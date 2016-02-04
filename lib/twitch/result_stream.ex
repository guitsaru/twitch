defmodule Twitch.ResultStream do
  def new(path) do
    Stream.resource(fn -> fetch_page(path) end,
      &process_page/1,
      fn _ -> nil end
    )
  end

  defp fetch_page(path) do
    json = path |> Twitch.get! |> Map.fetch!(:body) |> Poison.decode!

    streams = get_in(json, ["streams"])
    next    = get_in(json, ["_links", "next"]) |> String.replace("https://api.twitch.tv/kraken", "")

    {streams, next}
  end

  defp process_page({nil, nil}) do
    {:halt, nil}
  end

  defp process_page({[], _}) do
    {:halt, nil}
  end

  defp process_page({nil, next_page}) do
    next_page
    |> fetch_page
    |> process_page
  end

  defp process_page({items, next_page}) do
    {items, {nil, next_page}}
  end
end
