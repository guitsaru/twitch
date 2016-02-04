defmodule Twitch.ResultStream do
  def new(path, key) do
    Stream.resource(fn -> fetch_page(path, key) end,
      fn {items, next_page} -> process_page({items, next_page}, key) end,
      fn _ -> nil end
    )
  end

  defp fetch_page(path, key) do
    json = path |> Twitch.get! |> Map.fetch!(:body) |> Poison.decode!

    items = get_in(json, [key])
    next  = get_in(json, ["_links", "next"]) |> String.replace("https://api.twitch.tv/kraken", "")

    {items, next}
  end

  defp process_page({nil, nil}, _) do
    {:halt, nil}
  end

  defp process_page({[], _}, _) do
    {:halt, nil}
  end

  defp process_page({nil, next_page}, key) do
    next_page
    |> fetch_page(key)
    |> process_page(key)
  end

  defp process_page({items, next_page}, _) do
    {items, {nil, next_page}}
  end
end
