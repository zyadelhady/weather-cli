defmodule Cli do
  def main(args \\ []) do
    args
    |> parse_args()
    |> Weather.get()
  end

  defp parse_args(args) do
    args
  end
end
