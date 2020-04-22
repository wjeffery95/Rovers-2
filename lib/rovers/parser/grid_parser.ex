defmodule Rovers.Parser.GridParser do
  alias Rovers.Model.Grid

  @doc """
  Parses a string representation of a grid into a map

  ## Example
      iex> GridParser.parse("6 9")
      {:ok, %Grid{width: 6, height: 9}}

      iex> GridParser.parse("6 9 9")
      {:error, "Invalid number of arguments"}

      iex> GridParser.parse("Six 9")
      {:error, "Grid width and height must be integers"}
  """
  @spec parse(String.t()) :: {:ok, Grid.t()} | {:error, any}
  def parse(grid_string) do
    grid_string
    |> String.split(" ")
    |> create_grid
  end

  defp create_grid([width | [height | []]]) do
    with {width, _} <- Integer.parse(width),
         {height, _} <- Integer.parse(height) do
      {:ok, %Grid{width: width, height: height}}
    else
      :error -> {:error, "Grid width and height must be integers"}
    end
  end

  defp create_grid(_) do
    {:error, "Invalid number of arguments"}
  end
end
