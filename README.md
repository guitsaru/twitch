# Twitch

Elixir client for the twitch.tv API.

## Usage

This library is Stream based for any endpoints that return multiple resources.

```elixir
Twitch.Stream.all |> Enum.take(5)
Twitch.Stream.search("Hearthstone") |> Enum.take(5)
Twitch.Stream.featured |> Enum.take(5)
Twitch.Stream.get("twitch")

Twitch.Game.top |> Enum.take(5)
Twitch.Game.search("Hearthstone") |> Enum.take(5)

Twitch.Channel.get("twitch")
Twtich.Channel.search("Hearthstone") |> Enum.take(5)

Twitch.Video.top |> Enum.take(5)
Twitch.Video.top("month") |> Enum.take(5)
Twitch.Game.top |> Enum.fetch!(0) |> Map.fetch!(:game) |> Twitch.Video.top |> Enum.take(5)
Twitch.Game.top |> Enum.fetch!(0) |> Map.fetch!(:game) |> Twitch.Video.top("all") |> Enum.take(5)
"twitch" |> Twitch.Channel.get |> Twitch.Video.all |> Enum.take(5)
Twitch.Video.get("v39161838")

Twitch.User.get("twitch")

"twitch" |> Twitch.User.get |> Twitch.Follow.all |> Enum.take(5)
"twitch" |> Twitch.Channel.get |> Twitch.Follow.all |> Enum.take(5)

Twitch.Team.all |> Enum.take(5)
Twitch.Team.get("eg")
"twitch" |> Twitch.Channel.get |> Twitch.Team.all |> Enum.take(5)

Twitch.Ingest.all |> Enum.take(5)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add twitch to your list of dependencies in `mix.exs`:

        def deps do
          [{:twitch, "~> 0.0.1"}]
        end

  2. Ensure twitch is started before your application:

        def application do
          [applications: [:twitch]]
        end

