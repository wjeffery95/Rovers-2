defmodule Rovers.Model.Rover do
  alias Rovers.Model.Position
  alias Rovers.Model.Grid

  @type t :: %__MODULE__{
          pos: Position.t(),
          ins: [Position.instruction()],
          grid: Grid.t(),
          on_grid?: boolean()
        }

  @enforce_keys [:pos, :ins, :grid]
  defstruct [:pos, :ins, :grid, on_grid?: true]
end
