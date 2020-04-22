defmodule Rovers.Parser.InputParser do
  @spec split_input(String.t()) :: {:ok, {String.t(), [String.t()]}}
  def split_input(input) do
    [grid_string | rover_strings] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim(&1))

    {:ok, {grid_string, rover_strings}}
  end
end
