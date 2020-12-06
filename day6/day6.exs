#! /usr/bin/env elixir

defmodule Day6 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])

    forms = read_forms(handle)

    star1 = forms |> Enum.map(&Enum.count/1) |> Enum.sum()
    IO.puts("Star 1: Sum of form unique lengths is #{star1}")
  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp read_forms(handle) do
    raw_forms = handle |> IO.read(:all) |> String.split("\n\n")
    for form <- raw_forms do
      uniques_only_form = form |> String.to_charlist() |> Enum.uniq()
      uniques_only_form -- '\n'
    end
  end

end

Day6.main(System.argv())
