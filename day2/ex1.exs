defmodule AdventOfCode.Day2.Part1 do
  @moduledoc """
  Solution for AdventOfCode Day 2, Part 1
  """

  @doc """
  """
  @spec count_repeated(Enumerable.t()) :: integer
  def count_repeated(stream) do
    stream
    |> Enum.reduce({0, 0}, fn box_id, {current_twice, current_triple} ->
      {twice, triple} = count_ocurrences(box_id)
      {current_twice + twice, current_triple + triple}
    end)
  end

  @doc """
  Counts ocurrences of each letter, given a list of letters.
  """
  @spec count_ocurrences(list[String.t()]) :: map()
  def count_ocurrences(letters) do
    ocurrences =
      letters
      |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, &(&1 + 1)) end)

    {num_repetitions(ocurrences, 2), num_repetitions(ocurrences, 3)}
  end

  defp num_repetitions(ocurrences, num) do
    if Enum.any?(ocurrences, fn {_, val} -> val == num end) do
      1
    else
      0
    end
  end

  #  @doc """
  #  Builds a list that only contains the letters which ocurrence is 2 or 3.
  #  """
  #  @spec filter_by_ocurrence(integer()) :: list
  #  def filter_by_ocurrences(ocurrences) do
  #    ocurrences
  #    |> Enum.filter(fn {_key, val} -> val == 2 or val == 3} end)
  #  end

  @spec get_solution(Enumerable.t()) :: integer()
  def get_solution(stream) do
    {twice, triple} =
      result =
      stream
      |> count_repeated()

    IO.inspect(result)
    twice * triple
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
  |> Stream.map(&String.graphemes/1)
  |> AdventOfCode.Day2.Part1.get_solution()

IO.puts("Solution: #{result}")
