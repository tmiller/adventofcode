defmodule Advent2017 do
  @moduledoc """
  My work for Advent of Code 2017 in elixir this year!

  I started out writing it in random .exs scripts, but now I'm putting it into
  mix so I can use tests.
  """
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific day from the problem set"
  def run(day) do
    if day == ["all"] do
      Enum.each(1..25, fn d ->
        run d
        IO.puts "\n"
      end)
    else
      IO.puts "Day #{day}: \n" <>
      "Part 1:\n#{apply(String.to_existing_atom("Elixir.Advent2017.Day#{day}"), :p1, [])}\n" <>
      "Part 2:\n#{apply(String.to_existing_atom("Elixir.Advent2017.Day#{day}"), :p2, [])}"
    end
  end
end
