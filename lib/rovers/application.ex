defmodule Rovers.Application do
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Rovers.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Rovers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
