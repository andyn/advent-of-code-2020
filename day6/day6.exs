#! /usr/bin/env elixir

defmodule Day6 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])

    {any, all} = read_forms(handle)

    star1 = any |> Enum.map(&Enum.count/1) |> Enum.sum()
    IO.puts("Star 1: Sum of form unique lengths is #{star1}")
    star2 = all |> Enum.map(&Enum.count/1) |> Enum.sum()
    IO.puts("Star 2: Sum of form unique lengths is #{star2}")
  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp read_forms(handle) do
    forms =
      handle
      |> IO.read(:all)
      |> String.split("\n\n")

    unique_answers =
      forms
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(fn x -> Enum.uniq(x) -- '\n' end)

    common_answers = for form <- forms do
      form
      |> String.split("\n")
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(fn x -> Enum.uniq(x) -- '\n' end)
      |> Enum.reduce(fn x, y -> x -- (x -- y) end)
    end

    {unique_answers, common_answers}
  end

end

Day6.main(System.argv())
