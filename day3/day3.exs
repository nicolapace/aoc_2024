defmodule Day3 do

  def execute_mul(content) do
    String.split(content, "mul(") |> Enum.map( fn line ->
          try do
            [left, right_to_split | _] = String.split(line, ",")
            right = String.split(right_to_split, ")") |> hd
            # IO.inspect({left, right})
            String.to_integer(left) * String.to_integer(right)
          rescue
            _ -> 0
          end
        end) |> Enum.sum
  end

  def part1(filename) do
    case File.read(filename) do
      {:ok, content} ->
        #remove \n from content
        content = String.replace(content, "\n", "")

        res = execute_mul(content)
        IO.puts("Result part1: #{res}")
        
        
      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  def part2(filename) do
    case File.read(filename) do
      {:ok, content} ->
        #remove \n from content
        content = String.replace(content, "\n", "")

        res = String.split(content, "do()") |> Enum.map( fn line ->
          try do
            [part_to_mul | _] = String.split(line, "don't()")
            execute_mul(part_to_mul)
          rescue
            _ -> 0
          end
        end) |> Enum.sum
        IO.puts("Result part2: #{res}")
        
        
      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

    
end

#tests
# Day3.part1("test.txt")
# Day3.part2("test.txt")

# #solve
Day3.part1("input.txt")
Day3.part2("input.txt")
