defmodule Twitch do
  use HTTPoison.Base

  @version   "v3"
  @mime_type "application/vnd.twitchtv.#{@version}+json"

  def process_url(url) do
    "https://api.twitch.tv/kraken" <> url
  end

  def process_request_headers(headers) do
    headers ++ [{"Accept", @mime_type}]
  end
end
