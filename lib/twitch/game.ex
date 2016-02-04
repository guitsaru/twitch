defmodule Twitch.Game do
  alias Twitch.ResultStream

  defstruct id: 0,
    name: "",
    giantbomb_id: 0,
    box: %{},
    logo: %{}

  def top do
    "/games/top"
    |> ResultStream.new("top")
    |> Stream.map(&Twitch.Game.Top.from_map/1)
  end

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Game{}))

    struct(Twitch.Game, map)
  end
end

defmodule Twitch.Game.Top do
  defstruct game: %Twitch.Game{},
    viewers: 0,
    channels: 0

  def from_map(map) do
    atom_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    map = atom_map
    |> Map.take(Map.keys(%Twitch.Game.Top{}))
    |> Map.drop([:game])
    |> Map.put(:game, Twitch.Game.from_map(map["game"]))

    struct(Twitch.Game.Top, map)
  end
end
