defmodule Twitch.Channel do
  defstruct id: 0,
    mature: false,
    status: "",
    broadcaster_language: "",
    display_name: "",
    game: "",
    language: "",
    name: "",
    created_at: "",
    updated_at: "",
    delay: 0,
    logo: "",
    banner: "",
    video_banner: "",
    background: "",
    profile_banner: "",
    profile_banner_background_color: "",
    partner: false,
    url: "",
    views: 0,
    followers: 0

  def get(name) do
    "/channels/#{name}"
    |> Twitch.get!
    |> Map.fetch!(:body)
    |> Poison.decode!
    |> from_map
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Channel{}))
    |> Map.put(:id, map["_id"])

    struct(Twitch.Channel, map)
  end
end
