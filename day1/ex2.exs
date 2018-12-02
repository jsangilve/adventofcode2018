defmodule AdventOfCode.Day1.Part2 do
  @moduledoc """
  Solution for AdventOfCode Day 1, Part 2
  """

  @doc """
  Processes Stream of frequency changes and sums them up.
  """
  @spec first_repeated_twice(Enumerable.t()) :: integer
  def first_repeated_twice(stream) do
    stream
    |> Enum.reduce_while({0, MapSet.new()}, fn freq, {current, frequencies} ->
      new_freq = parse_change(freq) + current

      if MapSet.member?(frequencies, new_freq) do
        {:halt, new_freq}
      else
        {:cont, {new_freq, MapSet.put(frequencies, new_freq)}}
      end
    end)
  end

  @spec get_solution(Enumerable.t()) :: integer()
  def get_solution(stream) do
    result =
      stream
      |> first_repeated_twice()

    IO.puts("Solution: #{result}")
    result
  end

  defp parse_change(value) do
    case Integer.parse(value) do
      {change, _} ->
        change

      _ ->
        0
    end
  end
end

filename =
  case System.argv() do
    [] -> "#{__DIR__}/input"
    [file] -> file
  end

filename
|> File.stream!()
|> Stream.cycle()
|> AdventOfCode.Day1.Part2.get_solution()
