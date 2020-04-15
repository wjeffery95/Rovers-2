defmodule RoversTest do
  use ExUnit.Case
  doctest Rovers

  test "greets the world" do
    assert Rovers.hello() == :world
  end
end
