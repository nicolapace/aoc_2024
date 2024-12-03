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
        dec = fn line -> Enum.all?(Enum.zip(line, tl(line)), fn {a, b} -> b < a and a - b <= 3 end)  end
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
        

        get_remove_size = fn line ->

          # for each number in line from 0 to n-2 append a list of k, k+1 and k+2
          three_nums = Enum.map(0..(length(line)-3), fn i -> {Enum.at(line, i), Enum.at(line, i+1), Enum.at(line, i+2)} end)

          to_remove_set = Enum.reduce(Enum.with_index(three_nums), MapSet.new(), fn {{a, b, c}, i}, acc ->  
            if not(b>a and b-a<=3) do
              if c == nil do
                if not MapSet.member?(acc, i) do
                  MapSet.put(acc, i+1)
                else
                  acc
                end
              else
                if not(c>a and c-a<=3) do
                  MapSet.put(acc, i)
                else
                  MapSet.put(acc, i+1)
                end
              end
            else
              acc
            end
          end)
            
          cond do
            MapSet.size(to_remove_set) == 0 ->
              true

            MapSet.size(to_remove_set) == 1 ->
              to_del_index = Enum.at(MapSet.to_list(to_remove_set), 0)
              if to_del_index == 0 or to_del_index == length(line) - 2 do
                true
              else
                Enum.at(line, to_del_index + 1) > Enum.at(line, to_del_index - 1) and Enum.at(line, to_del_index + 1) - Enum.at(line, to_del_index - 1) <= 3
              end

            true ->
              false
          end
        end

        inc_or_dec = fn line -> case get_remove_size.(line ++ [nil]) or get_remove_size.(Enum.reverse(line) ++ [nil]) do true -> 1; false -> 0 end end
        res =  Enum.map(lines_numbers, fn line -> inc_or_dec.(line) end) |> Enum.sum

        IO.puts("Result part2: #{res}")


      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end
end

#part1
Day2.part1("test.txt")
Day2.part1("input.txt")

#solve
Day2.part2("test.txt")
Day2.part2("input.txt")
