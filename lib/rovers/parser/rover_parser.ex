defmodule Rovers.Parser.RoverParser do
  use OK.Pipe
  alias Rovers.Model.Rover
  alias Rovers.Model.Position
  alias Rovers.Model.Grid

  @doc """
  Turns a rover string into a map with x, y, dir and ins and validates it with respect to the supplied grid

  ## Examples
      iex> RoverParser.parse("2 3 N F F L R", %Grid{width: 5, height: 5})
      {:ok, %Rover{grid: %Grid{height: 5, width: 5}, ins: [:forward, :forward, :left, :right], pos: %Position{dir: :north, x: 2, y: 3}, on_grid?: true}}

      iex> RoverParser.parse("2 3", %{width: 5, height: 5})
      {:error, "Invalid row '2 3' because 'Incorrect number of arguments'"}

      iex> RoverParser.parse("2 three N F F L R", %{width: 5, height: 5})
      {:error, "Invalid row '2 three N F F L R' because 'x or y is not integer'"}

      iex> RoverParser.parse("2 3 UNDEFINED_DIRECTION F L", %Grid{width: 5, height: 5})
      {:error, "Invalid row '2 3 UNDEFINED_DIRECTION F L' because 'Invalid direction'"}

      iex> RoverParser.parse("2 3 N F UNDEFINED_INSTRUCTION L", %Grid{width: 5, height: 5})
      {:error, "Invalid row '2 3 N F UNDEFINED_INSTRUCTION L' because 'Invalid instruction'"}
  """
  @spec parse(String.t(), Grid.t()) :: {:ok, Rover.t()} | {:error, any}
  def parse(rover_string, grid) do
    rover_string
    |> String.split(" ")
    |> create(grid)
  end

  defp create([x | [y | [dir | ins]]] = rover_list, grid) do
    with {:ok, pos} <- parse_position(x, y, dir, grid),
         {:ok, ins} <- parse_instructions(ins) do
      {:ok, %Rover{pos: pos, ins: ins, grid: grid}}
    else
      :error -> {:error, error_message(rover_list, "x or y is not integer")}
      {:error, reason} -> {:error, error_message(rover_list, reason)}
    end
  end

  defp create(rover_list, _) do
    {:error, error_message(rover_list, "Incorrect number of arguments")}
  end

  defp parse_position(x, y, dir, grid) do
    with {x, _} <- Integer.parse(x),
         {y, _} <- Integer.parse(y),
         {:ok, dir} <- parse_direction(dir) do
      %Position{x: x, y: y, dir: dir} |> validate_on_grid(grid)
    else
      {:error, _} = error -> error
      :error -> {:error, "x or y is not integer"}
    end
  end

  defp parse_direction("N"), do: {:ok, :north}
  defp parse_direction("E"), do: {:ok, :east}
  defp parse_direction("S"), do: {:ok, :south}
  defp parse_direction("W"), do: {:ok, :west}
  defp parse_direction(_), do: {:error, "Invalid direction"}

  defp parse_instructions(ins) do
    OK.map_all(ins, &parse_instruction(&1))
  end

  defp parse_instruction("F"), do: {:ok, :forward}
  defp parse_instruction("L"), do: {:ok, :left}
  defp parse_instruction("R"), do: {:ok, :right}
  defp parse_instruction(_), do: {:error, "Invalid instruction"}

  defp validate_on_grid(pos, grid) do
    if Position.on_grid?(pos, grid), do: {:ok, pos}, else: {:error, "Start position off grid"}
  end

  defp error_message(rover_list, reason) do
    "Invalid row '#{Enum.join(rover_list, " ")}' because '#{reason}'"
  end
end
