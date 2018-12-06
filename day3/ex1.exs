defmodule AdventOfCode.Day3.Part1 do
  @moduledoc """
  Solution for AdventOfCode Day 3, Part 1
  """

  @doc """
  Count the number of claims that repeated twice or more.
  """
  @spec count_repeated_claims(Enumerable.t()) :: map()
  def count_repeated_claims(stream) do
    stream
    |> Enum.reduce(%{}, fn %{"x" => x, "y" => y, "width" => w, "height" => h},
                           acc ->
      record_claim(acc, x, y, w, h)
    end)
    |> Enum.count(fn {_, claims} -> claims > 1 end)
  end

  @doc """
  Adds claim to the fabric.
  """
  def record_claim(fabric, _, _, _, 0), do: fabric

  def record_claim(fabric, left, top, w, h) do
    Range.new(0, w - 1)
    |> Enum.reduce(fabric, fn x, acc ->
      acc
      |> Map.update("#{left + x},#{top + h - 1}", 1, &(&1 + 1))
    end)
    |> record_claim(left, top, w, h - 1)
  end

  @spec get_solution(Enumerable.t()) :: integer()
  def get_solution(stream) do
    stream
    |> count_repeated_claims()
  end
end

filename =
  case System.argv() do
    [] -> "#{__DIR__}/input"
    [file] -> file
  end

result =
  filename
  |> File.stream!([], :line)
  |> Stream.map(fn claim ->
    Regex.named_captures(
      ~r/@ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/,
      claim
    )
    |> Map.new(fn {k, v} -> {k, String.to_integer(v)} end)
  end)
  |> AdventOfCode.Day3.Part1.get_solution()

IO.puts("Solution: #{inspect(result)}")
