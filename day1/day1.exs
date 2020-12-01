#! /usr/bin/env elixir

defmodule Day1 do
  def main(args) do
    case parse_args(args) do
      {:ok, filename} -> process_file(filename)
      {:err, reason} -> IO.puts(reason)
    end
  end

  defp parse_args([]), do: {:err, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp process_file(filename) do
    case File.open(filename) do
      {:ok, handle} ->
        numbers = read_numbers(handle)

        pair_product =
          numbers
          |> Permutations.pairs()
          |> Enum.find(fn pair -> Enum.sum(pair) == 2020 end)
          |> Enum.reduce(&Kernel.*/2)

        IO.puts("Star 1: #{pair_product}")

        triple_product =
          numbers
          |> Permutations.triples()
          |> Enum.find(fn triple -> Enum.sum(triple) == 2020 end)
          |> Enum.reduce(&Kernel.*/2)

        IO.puts("Star 2: #{triple_product}")

      {:error, :enoent} ->
        IO.puts("#{filename} does not exist!")
    end
  end

  defp read_numbers(handle, numbers \\ []) do
    case IO.read(handle, :line) do
      {:error, reason} ->
        IO.puts("Error reading: " <> reason)

      :eof ->
        Enum.reverse(numbers)

      data ->
        {number, _} = data |> Integer.parse()
        read_numbers(handle, [number | numbers])
    end
  end
end

defmodule Permutations do
  # Shorthands
  def pairs(list), do: take(list, 2)
  def triples(list), do: take(list, 3)

  # Base terminating cases
  def take(_list, 0), do: [[]]
  def take(list = [_], _num_elements), do: [list]

  def take(list, num_elements) do
    for [head | tail] <- tails(list, []), inner_tail <- take(tail, num_elements - 1) do
      [head | inner_tail]
    end
  end

  # For a list of form [1, 2, 3] returns [[1, 2, 3], [2, 3], [3]]]
  defp tails([], acc), do: Enum.reverse(acc)

  defp tails(list = [_ | tail], acc) do
    tails(tail, [list] ++ acc)
  end
end

Day1.main(System.argv())
