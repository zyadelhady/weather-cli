defmodule Weather do
  @moduledoc """
  Documentation for `Weather`.
  """
  @weather_url_api "https://api.weatherapi.com/v1/forecast.json?"

  def get(country) do
    country
    |> generate_url()
    |> HTTPoison.get!()
    |> parse_json()
    |> get_weather_data()
    |> Enum.map(&print_data/1)
  end

  def generate_url(country) do
    "#{@weather_url_api}key=#{System.get_env("API_KEY")}&q=#{country}&days=2&aqi=no&alerts=yes"
  end

  def parse_json(%HTTPoison.Response{status_code: 200, body: body}) do
    Jason.decode!(body)
  end

  def parse_json(%HTTPoison.Response{status_code: 400, body: body}) do
    IO.puts("No weather data is available for a country , please double check")
    System.halt(2)
  end

  def parse_json({:error, %HTTPoison.Error{reason: reason}}) do
    IO.inspect(reason)
    System.halt(2)
  end

  def get_weather_data(%{"forecast" => %{"forecastday" => forecast_days}}) do
    forecast_days
  end

  def print_data(%{"date" => date, "day" => day}) do
    %{:date => date, :day => day}
  end
end
