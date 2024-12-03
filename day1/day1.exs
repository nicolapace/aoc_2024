defmodule Day1 do

  def part1(filename) do
    case File.read(filename) do
      {:ok, content} ->

        lines = String.split(content, "\n")
        {numbers_left, numbers_right} = Enum.map(lines, fn line ->
          case String.split(line, "   ") do
            [left, right | _] -> {String.to_integer(left), String.to_integer(right)}
          end
        end) |> Enum.unzip()
        # IO.inspect(numbers_left)
        # IO.inspect(numbers_right)

        sorted_left = Enum.sort(numbers_left)
        sorted_right = Enum.sort(numbers_right)
        # IO.inspect(sorted_left)
        # IO.inspect(sorted_right)
        res = Enum.zip(sorted_left, sorted_right) |> Enum.map(fn {left, right} -> abs(left - right) end) |> Enum.sum
        IO.puts("Result part1: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  def part2(filename) do
    case File.read(filename) do
      {:ok, content} ->

        lines = String.split(content, "\n")
        {numbers_left, numbers_right} = Enum.map(lines, fn line ->
          case String.split(line, "   ") do
            [left, right | _] -> {String.to_integer(left), String.to_integer(right)}
          end
        end) |> Enum.unzip()

        numbers_right_frequency = Enum.frequencies(numbers_right)
        # occurrences of number_left elements in numbers_right
        res = Enum.map(numbers_left, fn number_left ->
          case numbers_right_frequency[number_left] do
            nil -> 0
            frequency -> number_left*frequency
          end
        end) |> Enum.sum
        IO.puts("Result part2: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end
end

#tests
Day2.part1("test.txt")
Day2.part2("test.txt")

#solve
Day2.part1("input.txt")
Day2.part2("input.txt")
