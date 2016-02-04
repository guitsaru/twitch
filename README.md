# Twitch

Elixir client for the twitch.tv API.

## Usage

This library is Stream based for any endpoints that return multiple resources.

```elixir
Twitch.Stream.all |> Enum.take(5)
Twitch.Stream.search("Hearthstone") |> Enum.take(5)
Twitch.Stream.featured |> Enum.take(5)
Twitch.Game.top |> Enum.take(5)

Twitch.Stream.get("twitch")
Twitch.Channel.get("twitch")
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

