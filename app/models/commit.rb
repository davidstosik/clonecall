class Commit < GitObject
  def tree
    @tree ||= Tree.new repository, data.commit.tree.sha
  end

  def clone dest_repo
    new_tree = tree.clone dest_repo
    new_commit = dest_repo.create 'commit', data.commit.message, new_tree.sha #TODO parents
  end

end
