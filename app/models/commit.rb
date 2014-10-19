class Commit < GitObject
  def tree
    @tree ||= Tree.new repository, data.commit.tree.sha
  end

  def clone dest_repo
    existing_clone = existing_clone(dest_repo)
    return existing_clone if existing_clone

    new_tree = tree.clone dest_repo
    new_commit = dest_repo.create 'commit', data.commit.message, new_tree.sha #TODO parents
    map_clone new_commit
    new_commit
  end

end
