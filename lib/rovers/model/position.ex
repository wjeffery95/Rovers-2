defmodule Rovers.Model.Position do
  alias Rovers.Model.Grid

  @type direction :: :north | :east | :south | :west
  @type instruction :: :forward | :left | :right

  @type t :: %__MODULE__{
          x: Integer.t(),
          x: Integer.t(),
          dir: direction()
        }

  @enforce_keys [:x, :y, :dir]
  defstruct [:x, :y, :dir]

  @spec on_grid?(t(), Grid.t()) :: boolean()
  def on_grid?(%__MODULE__{x: x, y: y}, %Grid{width: width, height: height}) do
    x >= 0 && x < width && y >= 0 && y < height
  end

  @spec move(t(), instruction()) :: t()
  def move(%__MODULE__{y: y, dir: :north} = position, :forward),
    do: %__MODULE__{position | y: y + 1}

  def move(%__MODULE__{x: x, dir: :east} = position, :forward),
    do: %__MODULE__{position | x: x + 1}

  def move(%__MODULE__{y: y, dir: :south} = position, :forward),
    do: %__MODULE__{position | y: y - 1}

  def move(%__MODULE__{x: x, dir: :west} = position, :forward),
    do: %__MODULE__{position | x: x - 1}

  def move(%__MODULE__{dir: :north} = position, :left), do: %__MODULE__{position | dir: :west}
  def move(%__MODULE__{dir: :east} = position, :left), do: %__MODULE__{position | dir: :north}
  def move(%__MODULE__{dir: :south} = position, :left), do: %__MODULE__{position | dir: :east}
  def move(%__MODULE__{dir: :west} = position, :left), do: %__MODULE__{position | dir: :south}

  def move(%__MODULE__{dir: :north} = position, :right), do: %__MODULE__{position | dir: :east}
  def move(%__MODULE__{dir: :east} = position, :right), do: %__MODULE__{position | dir: :south}
  def move(%__MODULE__{dir: :south} = position, :right), do: %__MODULE__{position | dir: :west}
  def move(%__MODULE__{dir: :west} = position, :right), do: %__MODULE__{position | dir: :north}
end
