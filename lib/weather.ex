defmodule Weather do
  @moduledoc """
  Documentation for `Weather`.
  """
  @weather_url_api "https://api.weatherapi.com/v1/forecast.json?"

  def get(country) do
    country
    |> generate_url
    |> HTTPoison.get!()
    |> parse_json
  end

  def generate_url(country) do
    "#{@weather_url_api}key=#{System.get_env("API_KEY")}&q=#{country}&days=3&aqi=no&alerts=yes"
  end

  def parse_json(%HTTPoison.Response{status_code: 200, body: body}) do
    Jason.decode!(body)
    |> IO.inspect()
  end
end
