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

  def featured do
    "/streams/featured"
    |> ResultStream.new("featured")
    |> Stream.map(&Twitch.Stream.Featured.from_map/1)
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

defmodule Twitch.Stream.Featured do
  defstruct image: "",
    text: "",
    title: "",
    sponsored: false,
    scheduled: false,
    preview: %{},
    stream: %Twitch.Stream{}

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Stream.Featured{}))
    |> Map.drop([:stream])
    |> Map.put(:stream, Twitch.Stream.from_map(map["stream"]))

    struct(Twitch.Stream.Featured, map)
  end
end
