# Weather-CLI

A weather cli application written in elixir to get weather for multiple countries
using Tasks in elixir

## How To Use

```
$> source config/.env
$> ./weather cairo spain morocco palestine 
```
call executable with as many countries or cities as you want

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `weather` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:weather, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/weather>.
