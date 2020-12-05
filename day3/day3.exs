#! /usr/bin/env elixir

defmodule Day3 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])
    map = read_map(handle)

    star1 = calculate_collisions(map)
    IO.puts("Star 1: #{star1} collisions.")

    star2 =
      (for slope <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}], do: calculate_collisions(map, slope))
      |> Enum.reduce(&Kernel.*/2)
    IO.puts("Star 2: Product of collisions is #{star2}.")
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

  defp calculate_collisions(map, {x_slope, y_slope} \\ {3, 1} ) do
    route = for y <- 1..div(map.height, y_slope) do
      x = rem(x_slope * y, map.width)
      _tree_or_empty = Map.get(map, {x, y * y_slope}, :empty)
    end
    Enum.count(route, fn x -> x == :tree end)
  end

end

Day3.main(System.argv())
