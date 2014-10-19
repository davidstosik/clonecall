class Repository
  include OctokitCommonLogic

  attr_reader :full_name
  attr_reader :user

  def initialize full_name, user, data=nil
    @full_name = full_name
    @user = user
    @data = data
    @git_objects = {}
    @commits = {}
  end

  def data
    @data ||= user.octokit.repository full_name
  end

  def git_object type, sha
    type = type.to_sym
    @git_objects[type] ||= {}

    if type == :commit
      @git_objects[type][sha] ||=
        @commits.values.inject({}) do |mem, h|
          mem.merge! h
        end[sha]
    end

    @git_objects[type][sha] ||= GitObject.class_for(type).new self, sha
  end

  def commit sha
    git_object 'commit', sha
  end

  def commits branch=nil
    return @commits[branch] if @commits[branch]

    auto_paginate do
      @commits[branch] ||= Hash[user.octokit.commits(full_name, sha: branch).map do |commit|
        [commit.sha, Commit.new(self, commit.sha, commit)]
      end]
    end

    @commits[branch]
  end

  def create git_type, *params
    data = user.octokit.send("create_#{git_type}", full_name, *params)
    if data.is_a? String
      sha = data
      data = nil
    else
      sha = data.sha
    end
    GitObject.class_for(git_type).new self, sha, data
  end

  def branch_commit branch_name
    object = user.octokit.branch(full_name, branch_name).object
    Commit.new self, object.commit.sha
  end

  def clonecall dest_repo, branch_name=nil, start_at=nil, end_at=nil
    if [start_at, end_at].any? && ![start_at, end_at].all?
      now = Time.now
      start_at ||= now
      end_at   ||= now
    end

    branch = begin
      user.octokit.branch(full_name, branch_name || data.default_branch)
    rescue Octokit::NotFound
      user.octokit.branch(full_name, data.default_branch)
    end

    commits = commits branch_name

    interval = (end_at - start_at)/commits.count

    time = start_at
    commits.values.reverse_each do |commit|
      commit.clonecall dest_repo, time
      time += interval
    end

    branch = user.octokit.branch full_name, branch_name

    ref_commit_clone = Commit.new(self, branch.commit.sha, branch.commit).clonecall(dest_repo, end_at)

    if user.octokit.branch dest_repo.full_name, branch_name
      user.octokit.update_branch(dest_repo.full_name, branch_name, ref_commit_clone.sha)
    else
      user.octokit.create_ref(dest_repo.full_name, branch_name, ref_commit_clone.sha)
    end
  end

end
