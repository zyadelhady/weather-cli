defmodule Weather do
  @moduledoc """
  Documentation for `Weather`.
  """
  alias Task
  @weather_url_api "https://api.weatherapi.com/v1/forecast.json?"

  def get(countries) do
    countries
    |> Enum.map(&spawn_get/1)
    |> Enum.map(&Task.await/1)
    |> List.flatten()
    |> Enum.map(&print_table/1)
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

  def get_forecast(%{"forecast" => %{"forecastday" => forecast_days}}) do
    forecast_days
  end

  def get_day_data(%{"date" => date, "day" => day}) do
    %{:date => date, :day => day}
  end

  def print_table(%{
        date: date,
        day: %{
          "avgtemp_c" => avg_temp_c,
          "avghumidity" => avg_humidity,
          "condition" => %{"text" => text},
          "maxtemp_c" => max_temp,
          "mintemp_c" => min_temp
        }
      }) do
    IO.puts("""
       ———————— #{date} ——————
      |                          |
      |                          |
      |                          |
      |                          |
      |                          |
      |                          |
      |                          |
       ——————————————————————————
    """)

    # IO.puts(" ———————————————————————")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" |                     |")
    # IO.puts(" ———————————————————————")
  end
end
