#inspired by Nat Tuck's photo_blog implementation from lecture
defmodule Eventapp.Pictures do

  #gets the hash of the file with the given Name **must be in priv/pictures directory**
  def hash(name) do
      photos = Application.app_dir(:eventapp, "priv/pictures")
      path = Path.join(photos, name)
      {:ok, hash} = save_picture(name, path)
      hash
  end

  def save_picture(file_name, path) do
    data = File.read!(path)
    hash = sha256(data)
    meta = read_meta(hash)
    save_picture(file_name, data, hash, meta)
  end

  #no meta info is given about the file, create meta info
  def save_picture(file_name, data, hash, nil) do
    File.mkdir_p!(base_path(hash))
    meta = %{
      name: file_name,
      refs: 0,
    }
    save_picture(file_name, data, hash, meta)
  end

  # Note: data race TODO fix data race
  def save_picture(_file_name, data, hash, meta) do
    meta = Map.update!(meta, :refs, &(&1 + 1))
    File.write!(meta_path(hash), Jason.encode!(meta))
    File.write!(data_path(hash), data)
    {:ok, hash}
  end

  def load_picture(hash) do
    data = File.read!(data_path(hash))
    meta = read_meta(hash)
    {:ok, Map.get(meta, :name), data}
  end

  # deletes the picture with the given hash (for when users
  # update their profile picture)
  def delete_picture(hash) do
    data = File.rm!(data_path(hash))
    meta = read_meta(hash)
    {:ok, hash} # TODO do we even need hash anymore
  end

  def read_meta(hash) do
    with {:ok, data} <- File.read(meta_path(hash)),
         {:ok, meta} <- Jason.decode(data, keys: :atoms)
    do
      meta
    else
      _ -> nil
    end
  end

  def base_path(hash) do
    Path.expand("~/.local/data/eventapp")
    |> Path.join("#{Mix.env}")
    |> Path.join(String.slice(hash, 0, 2))
    |> Path.join(String.slice(hash, 2, 30))
  end

  def data_path(hash) do
    Path.join(base_path(hash), "photo.jpg")
  end

  def meta_path(hash) do
    Path.join(base_path(hash), "meta.json")
  end

  # hashes the the picture data with SHA256
  def sha256(data) do
    :crypto.hash(:sha256, data)
    |> Base.encode16(case: :lower)
  end
end
