defmodule Twitch.Stream do
  alias Twitch.ResultStream

  defstruct id: 0,
    url: "",
    game: "",
    viewers: 0,
    created_at: "",
    video_height: 0,
    average_fps: 0.0,
    delay: 0,
    is_playlist: false,
    preview: %{},
    channel: %Twitch.Channel{}

  def all do
    stream_path("/streams")
  end

  def search(query) do
    stream_path("/search/streams?query=#{query}")
  end

  def get(name) do
    "/streams/#{name}"
    |> Twitch.get!
    |> Map.fetch!(:body)
    |> Poison.decode!
    |> Map.fetch!("stream")
    |> from_map
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Stream{}))
    |> Map.drop([:channel])
    |> Map.put(:id, map["_id"])
    |> Map.put(:url, get_in(map, ["_links", "self"]))
    |> Map.put(:channel, Twitch.Channel.from_map(map["channel"]))

    struct(Twitch.Stream, map)
  end

  defp stream_path(path) do
    path
    |> ResultStream.new("streams")
    |> Stream.map(&from_map/1)
  end
end
