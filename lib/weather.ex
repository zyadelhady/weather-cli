defmodule Weather do
  @moduledoc """
  Documentation for `Weather`.
  """
  alias Task
  @weather_url_api "https://api.weatherapi.com/v1/forecast.json?"
  @colors [:light_magenta, :blue, :cyan, :green, :light_blue, :light_cyan, :light_magenta]

  @doc """
  This function won't be listed in docs.
  """
  def get(countries) do
    countries
    |> Enum.map(&spawn_get/1)
    |> Enum.map(&Task.await/1)
  end

  def spawn_get(country) do
    Task.async(fn -> get_country(country) end)
  end

  def get_country(country) do
    country
    |> generate_url()
    |> HTTPoison.get!()
    |> parse_json()
    |> get_forecast()
    |> Enum.map(&get_day_data/1)
    |> List.flatten()
    |> print_table()
  end

  def generate_url(country) do
    "#{@weather_url_api}key=#{System.get_env("API_KEY")}&q=#{country}&days=2&aqi=no&alerts=yes"
  end

  def parse_json(%HTTPoison.Response{status_code: 200, body: body}) do
    Jason.decode!(body)
  end

  def parse_json(%HTTPoison.Response{status_code: 400}) do
    IO.puts("No weather data is available for a country , please double check")
    System.halt(2)
  end

  def parse_json(%HTTPoison.Response{status_code: 403}) do
    IO.puts("There is something wrong with the authentecation change the api key")
    System.halt(2)
  end

  def parse_json({:error, %HTTPoison.Error{reason: reason}}) do
    IO.inspect(reason)
    System.halt(2)
  end

  def get_forecast(%{
        "location" => %{"name" => location},
        "forecast" => %{"forecastday" => forecast_days}
      }) do
    forecast_days
    |> Enum.map(&add_location(&1, location))
  end

  defp add_location(day, location) do
    Map.put(day, "location", location)
  end

  def get_day_data(%{"date" => date, "day" => day, "location" => location}) do
    %{:date => date, :day => day, :location => location}
  end

  def print_table(days) do
    x =
      days
      |> Enum.map(&create_table/1)

    IO.puts(
      IO.ANSI.format([
        Enum.random(@colors),
        x
      ])
    )
  end

  defp create_table(%{
         location: location,
         date: date,
         day: %{
           "avgtemp_c" => avg_temp_c,
           "avghumidity" => avg_humidity,
           "condition" => %{"text" => condition},
           "maxwind_kph" => max_wind,
           "daily_chance_of_rain" => rain_chance
         }
       }) do
    """

      ———————— #{date}-(#{location}) ———————

      -> C #{condition}       
      -> T #{avg_temp_c} C    
      -> W #{max_wind} Km/h             
      -> R #{rain_chance} % 
      -> H #{avg_humidity}
      ———————————————————————————————————

    """
  end
end
