defmodule Day5 do
  @moduledoc """
  Documentation for Day5
  """

  @type codepoint :: integer

  @doc """
  Calculates polymer reactions

  ## Examples

      iex> Day5.react('dabAcCaCBAcCcaDA')
      "dabCBAcaDA"

  """
  @spec react(charlist()) :: charlist()
  def react(stream) do
    stream
    |> Enum.reduce([], fn
      unit, [] ->
        [unit]

      unit, [head | rest] ->
        if abs(unit - head) == 32 do
          rest
        else
          [unit, head | rest]
        end
    end)
    |> Enum.reverse()
  end

  @spec count_units(charlist()) :: integer
  def count_units(polymer) do
    polymer
    |> react()
    |> length
  end

  @spec read_file(String.t()) :: charlist()
  def read_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> to_charlist()
  end

  @spec sol_part1(String.t()) :: integer()
  def sol_part1(filename) do
    filename
    |> read_file()
    |> react()
    |> count_units()
  end

  def ascii_chars(), do: Enum.to_list(?a..?z)

  @spec remove_unit(charlist(), codepoint) :: charlist()
  def remove_unit(polymer, unit) do
    polymer
    |> Enum.reject(&same_unit?(&1, unit))
  end

  @spec sol_part2_concurrent(String.t()) :: integer()
  def sol_part2_concurrent(filename) do
    polymer = read_file(filename)

    ascii_chars()
    |> Enum.map(fn unit ->
      Task.async(fn -> remove_and_react(polymer, unit) end)
    end)
    |> Enum.map(& Task.await(&1))
    |> Enum.sort_by(fn {_, count} -> count end)
    |> List.first
  end

  @spec sol_part2(String.t()) :: integer()
  def sol_part2(filename) do
    polymer = read_file(filename)

    ascii_chars()
    |> Enum.map(&remove_and_react(polymer, &1))
    |> Enum.sort_by(fn {_, count} -> count end)
    |> List.first
  end

  @spec remove_and_react(charlist, codepoint) :: {:ok, codepoint, integer}
  def remove_and_react(polymer, unit) do
    count =
      polymer
      |> remove_unit(unit)
      |> count_units()

    {unit, count}
  end

  @doc """
  Checks whether `a` and `b` are the same unit (ignores polarity).
  """
  @spec same_unit?(codepoint, codepoint) :: boolean()
  def same_unit?(a, b), do: a == b or abs(a - b) == 32
end
