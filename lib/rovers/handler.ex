defmodule Rovers.Handler do
  use OK.Pipe
  alias Rovers.Parser.InputParser
  alias Rovers.Parser.GridParser
  alias Rovers.Parser.RoverParser
  alias Rovers.Resolver
  alias Rovers.Formatter

  @doc """

  ## Examples
      iex> Handler.handle("
      ...>   10 10
      ...>   5 5 N F F L F R
      ...>   4 6 W L F R R F L F
      ...> ")
      {:ok, "4, 7 facing north/n3, 6 facing west"}

      iex> Handler.handle("
      ...>   5 5
      ...>   4 4 S F L F
      ...>   4 3 W L F R R F L F
      ...> ")
      {:ok, "Went off grid, last seen at 4, 3 facing east/n3, 3 facing west"}

      iex> Handler.handle("
      ...>   5 5
      ...>   4 4 W L F R R F L F
      ...>   7 7 N F L F F L F
      ...> ")
      {:error, "Invalid row '7 7 N F L F F L F' because 'Start position off grid'"}
  """
  @spec handle(String.t()) :: {:ok, String.t()} | {:error, any}
  def handle(input) do
    InputParser.split_input(input)
    ~>> parse_grid
    ~>> resolve_rovers
    ~> Enum.join("/n")
  end

  defp parse_grid({grid, rovers}) do
    case GridParser.parse(grid) do
      {:ok, grid} -> {:ok, {grid, rovers}}
      {:error, _} = error -> error
    end
  end

  defp resolve_rovers({grid, rovers}) do
    rovers
    |> Enum.map(&resolve_rover(&1, grid))
    |> Task.yield_many()
    |> OK.map_all(fn
      {_, {:ok, response}} -> response
      {_, {:exit, reason}} -> {:error, reason}
      {_, nil} -> {:error, "Time out"}
    end)
  end

  defp resolve_rover(rover, grid) do
    Task.Supervisor.async(
      Rovers.TaskSupervisor,
      fn ->
        RoverParser.parse(rover, grid)
        ~>> Resolver.resolve()
        ~>> Formatter.format()
      end
    )
  end
end
