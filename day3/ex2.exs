defmodule AdventOfCode.Day3.Part2 do
  @moduledoc """
  Solution for AdventOfCode Day 3, Part 2
  """

  @doc """
  Find the fabric's claim that's intact.
  """
  @spec find_intact_claim(Enumerable.t()) :: binary()
  def find_intact_claim(stream) do
    stream
    |> Enum.reduce(%{intact: MapSet.new()}, fn %{
                                                  "id" => id,
                                                  "x" => x,
                                                  "y" => y,
                                                  "width" => w,
                                                  "height" => h
                                                },
                                                acc ->

      acc = Map.update!(acc, :intact, &MapSet.put(&1, id))

      {acc, MapSet.new()}
      |> record_claim(id, x, y, w, h)
    end)
    |> Map.get(:intact)
    |> Enum.to_list()
    |> List.first
  end

  @doc """
  Adds claim to the fabric.
  """
  def record_claim({fabric, to_drop}, _, _, _, _, 0) do
    fabric
    |> Map.update!(:intact, fn set ->
      to_drop
      |> Enum.reduce(set, &MapSet.delete(&2, &1))
    end)
  end

  def record_claim(acc, id, left, top, w, h) do
    Range.new(0, w - 1)
    |> Enum.reduce(acc, fn x, {fabric, to_drop} ->
      key = "#{left + x},#{top + h - 1}"
      inch = Map.get(fabric, key)
      fabric = update_inch(fabric, key, id)

      case inch do
        nil ->
          {fabric, to_drop}

        {_, ids} ->
          {fabric, Enum.into([id | ids], to_drop, & &1)}
      end
    end)
    |> record_claim(id, left, top, w, h - 1)
  end

  def update_inch(acc, key, id) do
    acc
    |> Map.update(key, {1, [id]}, fn {count, ids} ->
      {count + 1, [id | ids]}
    end)
  end

  @spec get_solution(Enumerable.t()) :: integer()
  def get_solution(stream) do
    stream
    |> find_intact_claim()
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
      ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/,
      claim
    )
    |> Map.new(fn {k, v} -> {k, String.to_integer(v)} end)
  end)
  |> AdventOfCode.Day3.Part2.get_solution()

IO.puts("Solution: #{inspect(result)}")
