defmodule Rovers.MixProject do
  use Mix.Project

  def project do
    [
      app: :rovers,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Rovers.Application, []}
    ]
  end

  defp deps do
    [
      {:ok, "~> 2.3"}
    ]
  end
end
