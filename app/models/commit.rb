class Commit < GitObject
  def tree
    @tree ||= Tree.new repository, data.commit.tree.sha
  end

  def clone dest_repository, commit_at

  end

end
