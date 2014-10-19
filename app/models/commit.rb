class Commit < GitObject
  def tree
    @tree ||= Tree.new repository, data.commit.tree.sha
  end

  def clone dest_repo, time=nil
    existing_clone = existing_clone(dest_repo)
    return existing_clone if existing_clone

    parents = nil #TODO: find them, get a clone
    new_tree = tree.clone dest_repo

    options = Hash[[:author, :committer].map do |key|
      user_data = data.commit.send(key).to_h
      user_data[:date] = time if time
      [key, user_data]
    end

    new_commit = dest_repo.create 'commit', data.commit.message, new_tree.sha, parents, options
    map_clone new_commit
    new_commit
  end

end
