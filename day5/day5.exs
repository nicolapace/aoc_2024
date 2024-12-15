defmodule Day5 do
  @moduledoc """
  Module for solving Day 5 of the challenge.
  """
  def parse_input(filename) do
    input = File.read!(filename)
    [rules, updates] = String.split(input, "\n\n")

    rules = String.split(rules, "\n")
    updates_str = String.split(updates, "\n")

    {bigger_numbers, smaller_numbers} = Enum.reduce(rules, {%{}, %{}}, fn rule, {bigger, smaller} ->
      [left_num, right_num] =
        rule
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)

      bigger = Map.update(bigger, left_num, MapSet.new([right_num]), fn set ->
        MapSet.put(set, right_num)
      end)
      bigger = Map.put_new(bigger, right_num, MapSet.new())

      smaller = Map.update(smaller, right_num, MapSet.new([left_num]), fn set ->
        MapSet.put(set, left_num)
      end)
      smaller = Map.put_new(smaller, left_num, MapSet.new())

      {bigger, smaller}
    end)

    updates = Enum.map(updates_str, fn update -> 
      update
      |> String.split(",")
      |> Enum.map(&String.to_integer/1) 
    end)

    {updates, bigger_numbers, smaller_numbers}
  end

  defp check_validity(update, left, right, smaller_numbers, bigger_numbers) do
    Enum.reduce_while(update, {true, left, right}, fn el, {_, curr_left, curr_right} ->

        curr_right = MapSet.delete(curr_right, el)

        if MapSet.size(MapSet.difference(curr_left, smaller_numbers[el])) > 0 do
          {:halt, {false, curr_left, curr_right}}
        else if MapSet.size(MapSet.difference(curr_right, MapSet.new(bigger_numbers[el]))) > 0 do
          {:halt, {false, curr_left, curr_right}}
        else
          curr_left = MapSet.put(curr_left, el)
          {:cont, {true, curr_left, curr_right}}
        end
      end
        
    end) |> elem(0)
  end

  def part1(filename) do
    {updates, bigger_numbers, smaller_numbers} = parse_input(filename)

    res =
      Enum.reduce(updates, 0, fn update, res ->
        left = MapSet.new()
        right = MapSet.new(update)
        valid = check_validity(update, left, right, smaller_numbers, bigger_numbers)

        if valid do
          res + Enum.at(update, div(Enum.count(update), 2))
        else
          res
        end
      end)

    IO.puts("Result part1: #{res}")
  end

end

# tests
Day5.part1("test.txt")
# Day5.part2("test.txt")

# solve
Day5.part1("input.txt")
# Day5.part2("input.txt")
