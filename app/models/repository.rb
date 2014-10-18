class Repository
  include OctokitObject

  def self.find param, user
    new user.octokit.repository(param), user
  end

  def initialize data, user
    super data, user
    @unique_commits = {}
    @commits = {}
  end

  def commit sha
    @unique_commits[sha] ||= @commits.values.inject {|h,mem| mem.merge! h }[sha]
    @unique_commits[sha] ||= Commit.find self, sha, @user
  end

  def commits branch=nil
    return @commits[branch] if @commits[branch]

    prev_val = user.octokit.auto_paginate
    user.octokit.auto_paginate = true

    @commits[branch] ||= Hash[user.octokit.commits(full_name, sha: branch).map do |commit|
      [commit.sha, commit]
    end]

    user.octokit.auto_paginate = prev_val

    @commits[branch]
  end

end
