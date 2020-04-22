defmodule Rovers.Model.Grid do
  @type t :: %__MODULE__{
          height: Integer.t(),
          width: Integer.t()
        }

  @enforce_keys [:height, :width]
  defstruct [:height, :width]
end
