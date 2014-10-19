class Repository
  include OctokitCommonLogic

  attr_reader :full_name
  attr_reader :user

  def initialize full_name, user, data=nil
    @full_name = full_name
    @user = user
    @data = data
    @unique_commits = {}
    @commits = {}
  end

  def data
    @data ||= user.octokit.repository full_name
  end

  def commit sha
    @unique_commits[sha] ||= @commits.values.inject({}) do |mem, h|
      mem.merge! h
    end[sha]
    @unique_commits[sha] ||= Commit.new self, sha, user
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

end
