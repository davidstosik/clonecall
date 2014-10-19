class GitObject
  include OctokitCommonLogic

  attr_reader :repository
  attr_reader :sha

  def self.git_type; self.name.underscore; end
  def      git_type; self.class.git_type; end

  def self.class_for git_type
    Object.const_get git_type.to_s.camelcase
  end

  def data
    @data ||= user.octokit.send(git_type, repository.full_name, sha)
  end

  def user
    repository.user
  end

  def initialize repository, sha, data=nil
    @repository = repository
    @sha = sha
    @data = data
  end

  def map_clone cloned_object
    GitObjectClone.create(
      user: user,
      git_type: git_type,
      src_repo: repository.full_name,
      src_sha: sha,
      dst_repo: cloned_object.repository.full_name,
      dst_sha: cloned_object.sha,
    )
  end

  def existing_clone dest_repo
    mapping = GitObjectClone.find_by(
      user: user,
      git_type: git_type,
      src_repo: repository.full_name,
      src_sha: sha,
      dst_repo: dest_repo.full_name
    )
    return unless mapping
    self.class.new dest_repo, mapping.dst_sha
  end

  def clone 

  end

end
