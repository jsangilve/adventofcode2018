defmodule AdventOfCode.Day1 do
  @moduledoc """
  Solution for AdventOfCode Day 1
  """

  @doc """
  Processes Stream of frequency changes and sums them up.
  """
  @spec add_frequency_changes(Stream.t()) :: integer()
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

filename = case System.argv do
  [] -> "#{__DIR__}/input"
  [file] -> file
end


result = filename
|> File.read!()
|> String.split("\n")
|> AdventOfCode.Day1.add_frequency_changes()

IO.puts ("Solution: #{result}")
