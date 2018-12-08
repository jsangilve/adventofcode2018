defmodule Day4 do
  @moduledoc """
  Solution for AdventOfCode Day 4, Part 1
  """

  @doc """
  Parses a record.

  ## Examples


      iex> Day4.parse_record("[1518-11-01 00:00] Guard #10 begins shift")
      {~N[1518-11-01 00:00:00], "10"}
      iex> Day4.parse_record("[1518-11-01 00:05] falls asleep")
      {~N[1518-11-01 00:05:00], :sleep}
      iex> Day4.parse_record("[1518-11-01 00:25] wakes up")
      {~N[1518-11-01 00:25:00], :awake}


  """
  def parse_record(record) do
    case String.split(record, ["[", "]", "#", " "], trim: true) do
      [date, time, "Guard", id, _, _] ->
        {parse_dt(date, time), String.to_integer(id)}

      [date, time, "wakes", _] ->
        {parse_dt(date, time), :awake}

      [date, time, "falls", _] ->
        {parse_dt(date, time), :sleep}
    end
  end

  @doc """
  Builds a map containing the sleeping minutes of each guard
  ## Examples

  """
  def sleeping_minutes(records) do
    {sleeping, _, _, _} =
      records
      |> Enum.map(&parse_record/1)
      |> Enum.sort_by(fn {dt, _} -> DateTime.to_unix(dt) end)
      |> Enum.reduce(
        {%{}, 0, nil, nil},
        fn
          {_, id}, {acc_mins, _, _, _} when is_integer(id) ->
            # this assumes Guards are always awake before 00:59
            {acc_mins, 0, id, :awake}

          {dt, :sleep}, {minutes, _, id, _} ->
            {minutes, dt.minute, id, :sleep}

          {%{minute: minute}, :awake}, {acc_mins, m, id, :sleep} ->
            new_mins = Enum.to_list(m..(minute - 1))
            {Map.update(acc_mins, id, new_mins, &Enum.concat(&1, new_mins)), m, id, :awake}
        end
      )

    sleeping
  end

  def most_asleep_minute(minutes) do
    minutes
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.max_by(fn {_, v} -> v end)
  end

  @doc """
  Finds the guard that sleeps the most (part 1).
  """
  def most_asleep_guard(records) do
    {guard_id, minutes} =
      records
      |> sleeping_minutes()
      |> Enum.max_by(fn {_, v} -> length(v) end)

    {min, _count} = most_asleep_minute(minutes)
    {guard_id, min, guard_id * min}
  end

  @doc """
  Finds the guard that sleep most frequently in the same minute (part 2)
  """
  def most_frequently_asleep(records) do
    {guard_id, min, _} =
      records
      |> sleeping_minutes()
      |> Enum.map(fn {guard_id, mins} ->
        {min, count} = most_asleep_minute(mins)
        {guard_id, min, count}
      end)
      |> Enum.max_by(fn {_, _, count} -> count end)

    {guard_id, min, guard_id * min}
  end

  #########
  # Helpers
  #########

  defp parse_dt(date, time) do
    {:ok, dt, _} = DateTime.from_iso8601("#{date} #{time}:00Z")
    dt
  end
end
