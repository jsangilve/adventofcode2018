defmodule AdventOfCode.Day2.Part2 do
  @moduledoc """
  Solution for AdventOfCode Day 2, Part 2
  """

  @doc """
  Finds boxes which have all characters in common but one.
  """
  def find_boxes([], result), do: result

  def find_boxes([first_box | rest], _result) do
    case check_myers_difference(first_box, rest) do
      box when is_binary(box) ->
        {first_box, box}

      _ ->
        find_boxes(rest, nil)
    end
  end

  def check_myers_difference(box, rest) do
    Enum.find(rest, fn current_box ->
      myers_diff = String.myers_difference(box, current_box)
      count_del = Enum.count(myers_diff, fn {key, _} -> key == :del end)
      count_eq = Enum.count(myers_diff, fn {key, _} -> key == :eq end)

      count_del == 1 and count_eq > 1 and
        String.length(Keyword.get(myers_diff, :del, 0)) == 1
    end)
  end

  @spec get_solution(Enumerable.t()) :: integer()
  def get_solution(stream) do
    {box1, box2} =
      stream
      |> Enum.to_list()
      |> find_boxes(nil)

    IO.inspect({box1, box2})

    r =
      String.myers_difference(box1, box2)
      |> Keyword.get_values(:eq)
      |> Enum.join()
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
  |> Stream.map(&String.trim/1)
  |> AdventOfCode.Day2.Part2.get_solution()

IO.puts("Solution: #{inspect(result)}")
