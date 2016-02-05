defmodule Twitch.Video do
  alias Twitch.ResultStream

  defstruct id: "",
    url: "",
    broadcast_id: 0,
    title: "",
    description: "",
    status: "",
    tag_list: "",
    recorded_at: "",
    game: "",
    length: 0,
    delete_at: nil,
    vod_type: "",
    is_muted: false,
    preview: "",
    thumbnails: [],
    views: 0,
    fps: %{},
    resolutions: %{},
    broadcast_type: "",
    created_at: "",
    channel: %Twitch.Channel{}

  def all(%Twitch.Channel{name: channel}) do
    "/channels/#{channel}/videos"
    |> ResultStream.new("videos")
    |> Stream.map(&from_map/1)
  end

  def top do
    "/videos/top"
    |> ResultStream.new("videos")
    |> Stream.map(&from_map/1)
  end

  def get(id) do
    "/videos/#{id}"
    |> Twitch.get!
    |> Map.fetch!(:body)
    |> Poison.decode!
    |> from_map
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Video{}))
    |> Map.drop([:channel])
    |> Map.put(:id, map["_id"])
    |> Map.put(:channel, Twitch.Channel.from_map(map["channel"]))

    struct(Twitch.Video, map)
  end
end
