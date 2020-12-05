#! /usr/bin/env elixir

defmodule Day3 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])
    passports = read_passports(handle)

    star1_valid_passports =
      (for passport <- passports, do: passport_valid? passport)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()
    IO.puts("Star 1: #{star1_valid_passports} valid passports.")

  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp read_passports(handle) do
    passport_lines = IO.read(handle, :all) |> String.split("\n\n")
    for passport_description <- passport_lines do
      for field <- String.split(passport_description), into: %{} do
        [key, value] = String.split(field, ":")
        {String.to_atom(key), value}
      end
    end
  end

  defp passport_valid?(passport) do
    fields = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]
    found_fields = for field <- fields, do: Map.has_key?(passport, field)
    case found_fields |> Enum.filter(fn x -> x == true end) |> Enum.count() do
      8 -> true
      7 -> not Map.has_key?(passport, :cid)
      _ -> false
    end
  end

end

Day3.main(System.argv())
