class Tree < GitObject

  def items
    @items ||= data.tree
  end

  def clone dest_repo
    clone = existing_clone(dest_repo)
    return clone if clone

    new_items = items.map do |item|
      object = repository.git_object item.type, item.sha
      new_object = object.clone dest_repo

      {
        path: item.path,
        mode: item.mode,
        type: item.type,
        sha: new_object.sha,
      }
    end

    new_tree = dest_repo.create 'tree', new_items
    map_clone new_tree
    new_tree
  end

end
