defmodule Day4 do
  def part1(filename) do
    case File.read(filename) do
      {:ok, content} ->
        grid = String.split(content, "\n") |> Enum.map(&String.graphemes/1)

        # function to search for "XMAS" in the raw
        find_xmas_raw = fn r, c ->
          if c <= length(Enum.at(grid, r)) - 4 and
               Enum.at(grid, r) |> Enum.slice(c, 4) == ["X", "M", "A", "S"],
             do: 1,
             else: 0
        end

        find_xmas_col = fn r, c ->
          if r <= length(grid) - 4 and
               Enum.slice(grid, r, 4) |> Enum.map(&Enum.at(&1, c)) == ["X", "M", "A", "S"],
             do: 1,
             else: 0
        end

        find_samx_raw = fn r, c ->
          if c >= 3 and Enum.at(grid, r) |> Enum.slice(c - 3, 4) == ["S", "A", "M", "X"],
            do: 1,
            else: 0
        end

        find_samx_col = fn r, c ->
          if r >= 3 and
               Enum.slice(grid, r - 3, 4) |> Enum.map(&Enum.at(&1, c)) == ["S", "A", "M", "X"],
             do: 1,
             else: 0
        end

        find_xmas_diag1 = fn r, c ->
          if r <= length(grid) - 4 and c <= length(Enum.at(grid, r)) - 4 and
               Enum.with_index(Enum.slice(grid, r, 4))
               |> Enum.map(fn {row, i} -> Enum.at(row, c + i) end) == ["X", "M", "A", "S"],
             do: 1,
             else: 0
        end

        find_xmas_diag2 = fn r, c ->
          if r <= length(grid) - 4 and c >= 3 and
               Enum.with_index(Enum.slice(grid, r, 4))
               |> Enum.map(fn {row, i} -> Enum.at(row, c - i) end) == ["X", "M", "A", "S"],
             do: 1,
             else: 0
        end

        find_samx_diag1 = fn r, c ->
          if r >= 3 and c <= length(Enum.at(grid, r)) - 4 and
               Enum.with_index(Enum.slice(grid, r - 3, 4))
               |> Enum.map(fn {row, i} -> Enum.at(row, c + 3 - i) end) == ["S", "A", "M", "X"],
             do: 1,
             else: 0
        end

        find_samx_diag2 = fn r, c ->
          if r >= 3 and c >= 3 and
               Enum.with_index(Enum.slice(grid, r - 3, 4))
               |> Enum.map(fn {row, i} -> Enum.at(row, c - 3 + i) end) == ["S", "A", "M", "X"],
             do: 1,
             else: 0
        end

        find_xmas = fn r, c ->
          find_xmas_raw.(r, c) + find_xmas_col.(r, c) + find_xmas_diag1.(r, c) +
            find_xmas_diag2.(r, c)
        end

        find_samx = fn r, c ->
          find_samx_raw.(r, c) + find_samx_col.(r, c) + find_samx_diag1.(r, c) +
            find_samx_diag2.(r, c)
        end

        find_all = fn r, c -> find_xmas.(r, c) + find_samx.(r, c) end

        # using find_all for each "X" in the grid to get the total sum
        res =
          Enum.with_index(grid)
          |> Enum.map(fn {row, r} ->
            Enum.with_index(row)
            |> Enum.map(fn {x, c} ->
              case x do
                "X" ->
                  find_all.(r, c)

                _ ->
                  0
              end
            end)
          end)
          |> Enum.concat()
          |> Enum.sum()

        IO.puts("Result part1: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  def part2(filename) do
    case File.read(filename) do
      {:ok, content} ->
        grid = String.split(content, "\n") |> Enum.map(&String.graphemes/1)

        # function to check if in the A diagonal there is a X of MAS
        find_all = fn r, c ->
          if r > 0 and r < length(grid) - 1 and c > 0 and c < length(Enum.at(grid, r)) - 1 do
            elements = [
              Enum.at(Enum.at(grid, r-1), c-1),
              Enum.at(Enum.at(grid, r-1), c+1),
              Enum.at(Enum.at(grid, r+1), c-1),
              Enum.at(Enum.at(grid, r+1), c+1)
            ]

            case elements do
              ["S", "S", "M", "M"] -> 1
              ["S", "M", "S", "M"] -> 1
              ["M", "S", "M", "S"] -> 1
              ["M", "M", "S", "S"] -> 1
              _ -> 0
            end
          else
            0
          end
        end

        # using find_all for each "A" in the grid to get the total sum
        res =
          Enum.with_index(grid)
          |> Enum.map(fn {row, r} ->
            Enum.with_index(row)
            |> Enum.map(fn {x, c} ->
              case x do
                "A" ->
                  find_all.(r, c)

                _ ->
                  0
              end
            end)
          end)
          |> Enum.concat()
          |> Enum.sum()

        IO.puts("Result part2: #{res}")

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end
end

# tests
# Day4.part1("test.txt")
Day4.part2("test.txt")

# solve
# Day4.part1("input.txt")
Day4.part2("input.txt")
