defmodule AdventOfCode.Day1.Part1 do
  @moduledoc """
  Solution for AdventOfCode Day 1, Part 1
  """

  @doc """
  Processes Stream of frequency changes and sums them up.
  """
  @spec add_frequency_changes(Enumerable.t()) :: integer()
  def add_frequency_changes(stream) do
    stream
    |> Enum.reduce(0, fn freq, acc ->
      case Integer.parse(freq) do
        {change, _} ->
          acc + change

        _ ->
          acc
      end
    end)
  end
end

filename =
  case System.argv() do
    [] -> "#{__DIR__}/input"
    [file] -> file
  end

result =
  filename
  |> File.stream!()
  |> AdventOfCode.Day1.Part1.add_frequency_changes()

IO.puts("Solution: #{result}")
