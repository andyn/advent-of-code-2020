#! /usr/bin/env elixir

defmodule Day3 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])
    map = read_map(handle)
    star1 = calculate_collisions(map)
    IO.puts("Star 1: #{star1} collisions.")
    # IO.puts("Star 2: #{star2} passwords match.")
  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp read_map(handle, map \\ %{}, x \\ 0, y \\ 0, width \\ 0) do
    case IO.read(handle, 1) do
      :eof ->
        # A trailing newline would give erroneous numbers - not that this matters, but let's just be pedantic
        height = case x do
          0 -> y
          _ -> y + 1
        end
        map |> Map.put(:height, height) |> Map.put(:width, width)
      "\n" ->
        read_map(handle, map, 0, y + 1, max(width, x))

      "#" ->
        read_map(handle, Map.put(map, {x, y}, :tree), x + 1, y, width)

      "." ->
        read_map(handle, map, x + 1, y, width)

    end
  end

  defp calculate_collisions(map) do
    route = for y <- 1..map.height do
      x = rem(3 * y, map.width)
      _tree_or_empty = Map.get(map, {x, y}, :empty)
    end
    Enum.count(route, fn x -> x == :tree end)
  end
end

Day3.main(System.argv())
