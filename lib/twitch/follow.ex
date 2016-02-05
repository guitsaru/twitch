defmodule Twitch.Follow do
  alias Twitch.ResultStream

  defstruct user: %Twitch.User{},
    channel: %Twitch.Channel{},
    created_at: "",
    notifications: false

  def all(channel = %Twitch.Channel{name: name}) do
    "/channels/#{name}/follows"
    |> ResultStream.new("follows")
    |> Stream.map(&from_map/1)
    |> Stream.map(fn follow -> %{follow | channel: channel} end)
  end

  def all(user = %Twitch.User{name: name}) do
    "/users/#{name}/follows/channels"
    |> ResultStream.new("follows")
    |> Stream.map(&from_map/1)
    |> Stream.map(fn follow -> %{follow | user: user} end)
  end

  def from_map(map) do
    user = Map.get(map, "user", %{})
    channel = Map.get(map, "channel", %{})

    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Follow{}))
    |> Map.put(:user, user)
    |> Map.put(:channel, channel)

    struct(Twitch.Follow, map)
  end
end
