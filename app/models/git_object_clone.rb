class GitObjectClone < ActiveRecord::Base
  belongs_to :user

  def source_object
    GitObject.class_for(git_type).find src_repo, src_sha, user
  end

  def dest_object
    GitObject.class_for(git_type).find dst_repo, dst_sha, user
  end
end
