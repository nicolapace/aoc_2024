defmodule Day2 do

  def part1(filename) do
    case File.read(filename) do
      {:ok, content} ->

        lines = String.split(content, "\n")
        lines_numbers = Enum.map(lines, fn line ->
          Enum.map(String.split(line, " "), fn x -> String.to_integer(x) end)
        end)
        
        # IO.inspect(lines_numbers)
        # check if line is decreasing or increasing by at least one and at most three by the previous number.
        inc = fn line -> Enum.all?(Enum.zip(line, tl(line)), fn {a, b} -> a < b and b - a <= 3 end)  end
        dec = fn line -> Enum.all?(Enum.zip(line, tl(line)), fn {a, b} -> a > b and a - b <= 3 end)  end
        inc_or_dec = fn line -> case inc.(line) or dec.(line) do true -> 1; false -> 0 end end

        # passing a function that checks this and returning true or false for each line
        res =  Enum.map(lines_numbers, fn line -> inc_or_dec.(line) end) |> Enum.sum 
        IO.puts("Result part1: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  def part2(filename) do
    case File.read(filename) do
      {:ok, content} ->

        lines = String.split(content, "\n")
        lines_numbers = Enum.map(lines, fn line ->
          Enum.map(String.split(line, " "), fn x -> String.to_integer(x) end)
        end)
        
        # IO.inspect(lines_numbers)
        # check if line is decreasing or increasing by at least one and at most three by the previous number.
        inc = fn line -> Enum.all?(Enum.zip(line, tl(line)), fn {a, b} -> a < b and b - a <= 3 end)  end
        dec = fn line -> Enum.all?(Enum.zip(line, tl(line)), fn {a, b} -> a > b and a - b <= 3 end)  end
        inc_or_dec = fn line -> case inc.(line) or dec.(line) do true -> 1; false -> 0 end end

        # passing a function that checks this and returning true or false for each line
        res =  Enum.map(lines_numbers, fn line -> inc_or_dec.(line) end) |> Enum.sum 
        IO.puts("Result part2: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end
end

#tests
Day2.part1("test.txt")
# Day2.part2("test.txt")

#solve
Day2.part1("input.txt")
#Day2.part2("input.txt")
