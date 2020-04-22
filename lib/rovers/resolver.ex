defmodule Rovers.Resolver do
  alias Rovers.Model.Rover
  alias Rovers.Model.Position

  @doc """


  ## Examples
  """
  @spec resolve(Rover.t()) :: {:ok, Rover.t()}
  def resolve(%Rover{ins: []} = rover), do: {:ok, rover}

  def resolve(%Rover{pos: pos, grid: grid, ins: [instruction | ins]} = rover) do
    pos = Position.move(pos, instruction)

    if Position.on_grid?(pos, grid),
      do: resolve(%Rover{rover | pos: pos, ins: ins}),
      else: {:ok, %Rover{rover | on_grid?: false}}
  end
end
