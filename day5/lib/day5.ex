defmodule Day5 do
  @moduledoc """
  Documentation for Day5.
  """

  @doc """
  Calculates polymer reactions

  ## Examples

      iex> Day5.react('dabAcCaCBAcCcaDA')
      "dabCBAcaDA"

  """
  def react(stream) do
    stream
    |> Enum.reduce([], fn
      unit, [] -> [unit]
      unit, [head | rest] ->
      #        IO.inspect({[unit], [head], rest})
        if abs(unit - head) == 32 do
            rest
        else
          [unit, head | rest]
        end
    end)
  end

  def count_units(polymer) do
    polymer
    |> react()
    |> length
  end

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> to_charlist()

  end
end
