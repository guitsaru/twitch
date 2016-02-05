defmodule Twitch.Ingest do
  alias Twitch.ResultStream

  defstruct id: 0,
    name: "",
    availability: 0.0,
    default: false,
    url_template: ""

  def all do
    "/ingests"
    |> ResultStream.new("ingests")
    |> Stream.map(&from_map/1)
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Ingest{}))
    |> Map.put(:id, map["_id"])

    struct(Twitch.Ingest, map)
  end
end
