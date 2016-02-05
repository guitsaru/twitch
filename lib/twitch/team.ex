defmodule Twitch.Team do
  alias Twitch.ResultStream

  defstruct id: 0,
    name: "",
    display_name: "",
    info: "",
    url: "",
    background: "",
    banner: "",
    created_at: "",
    updated_at: "",
    logo: ""

  def all do
    stream_path("/teams")
  end

  def all(%Twitch.Channel{name: channel}) do
    stream_path("/channels/#{channel}/teams")
  end

  def get(name) do
    "/teams/#{name}"
    |> Twitch.fetch!
    |> from_map
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Team{}))
    |> Map.put(:id, map["_id"])
    |> Map.put(:url, get_in(map, ["_links", "self"]))

    struct(Twitch.Team, map)
  end

  defp stream_path(path) do
    path
    |> ResultStream.new("teams")
    |> Stream.map(&from_map/1)
  end
end
