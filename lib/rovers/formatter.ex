defmodule Rovers.Formatter do
  alias Rovers.Model.Rover
  alias Rovers.Model.Position

  @spec format(Rover.t()) :: {:ok, String.t()}
  def format(%Rover{pos: position, on_grid?: true}) do
    {:ok, format_position(position)}
  end

  def format(%Rover{pos: position, on_grid?: false}) do
    {:ok, "Went off grid, last seen at #{format_position(position)}"}
  end

  defp format_position(%Position{x: x, y: y, dir: dir}) do
    "#{x}, #{y} facing #{Atom.to_string(dir)}"
  end
end
