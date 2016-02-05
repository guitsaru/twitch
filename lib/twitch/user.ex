defmodule Twitch.User do
  defstruct id: 0,
    name: "",
    url: "",
    type: "",
    bio: "",
    logo: "",
    display_name: "",
    created_at: "",
    updated_at: ""

  def get(name) do
    "/users/#{name}"
    |> Twitch.fetch!
    |> from_map
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.User{}))
    |> Map.put(:id, map["_id"])
    |> Map.put(:url, get_in(map, ["_links", "self"]))

    struct(Twitch.User, map)
  end
end
