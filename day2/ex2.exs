defmodule AdventOfCode.Day2.Part2 do
  @moduledoc """
  Solution for AdventOfCode Day 2, Part 2
  """

  @doc """
  Finds boxes which have all characters in common but one.
  """
  @spec find_boxes(list(binary()), tuple | nil) :: tuple()
  def find_boxes(boxes, result \\ nil)

  def find_boxes([], result), do: result

  def find_boxes([first_box | rest], _result) do
    result = check_myers_difference(first_box, rest)

    case result do
      nil ->
        find_boxes(rest, nil)

      _ ->
        result
    end
  end

  @spec check_myers_difference(binary, list(binary())) :: tuple() | nil
  def check_myers_difference(box, rest) do
    rest
    |> Enum.find_value(fn current_box ->
      myers_diff = String.myers_difference(box, current_box)
      diff = Keyword.get_values(myers_diff, :del)
      # boxes match if they have only one :del element and its length is 1
      # I thought about matching myers_diff length to 4: 
      # myers_diff = [eq: "foo", del: "bar", ins: "bah", eq: "blah"].
      # but that would fail if the differences between the boxes is either
      # on the first or last character.
      if length(diff) == 1 and String.length(List.first(diff)) == 1 do
        {box, current_box, myers_diff}
      else
        nil
      end
    end)
  end

  @spec get_solution(Enumerable.t()) :: binary()
  def get_solution(stream) do
    {_box1, _box2, myers_diff} =
      stream
      |> Enum.to_list()
      |> find_boxes()

    myers_diff
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
