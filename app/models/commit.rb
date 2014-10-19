class Commit

  attr_reader :repository

  def self.find repo, sha, user
    new user.octokit.commit(repo.full_name, sha), repo, user
  end

  def initialize data, repo, user
    super data, user
    @repository = repo
  end

end
