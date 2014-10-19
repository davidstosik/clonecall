class Blob < GitObject

  def clone dest_repo
    existing_clone = existing_clone(dest_repo)
    return existing_clone if existing_clone

    new_blob = dest_repo.create 'blob', data.content, data.encoding
    map_clone new_blob
    new_blob
  end

end
