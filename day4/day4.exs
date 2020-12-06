#! /usr/bin/env elixir

defmodule Day4 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])
    passports = read_passports(handle)

    star1_valid_passports =
      (for passport <- passports, do: naive_passport_valid? passport)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()
    IO.puts("Star 1: #{star1_valid_passports} valid passports.")

    star2_valid_passports =
      (for passport <- passports, do: strict_passport_valid? passport)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()
    IO.puts("Star 2: #{star2_valid_passports} valid passports.")

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

  defp naive_passport_valid?(passport) do
    fields = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]
    found_fields = for field <- fields, do: Map.has_key?(passport, field)
    case found_fields |> Enum.filter(fn x -> x == true end) |> Enum.count() do
      8 -> true
      7 -> not Map.has_key?(passport, :cid)
      _ -> false
    end
  end

  defp strict_passport_valid?(passport) do
    birth_year_valid? = case Map.get(passport, :byr) do
      nil ->
        false
      something -> case Integer.parse(something) do
        {birth_year, ""} when birth_year in 1920..2002 -> true
        _ -> false
      end
    end

    issue_year_valid? = case Map.get(passport, :iyr) do
      nil ->
        false
      something -> case Integer.parse(something) do
        {issue_year, ""} when issue_year in 2010..2020 -> true
        _ -> false
      end
    end

    expiration_year_valid? = case Map.get(passport, :eyr) do
      nil ->
        false
      something -> case Integer.parse(something) do
        {expiration_year, ""} when expiration_year in 2020..2030 -> true
        _ -> false
      end
    end

    height_valid? = case Map.get(passport, :hgt) do
      nil ->
        false
      something -> case Integer.parse(something) do
        {height_cm, "cm"} when height_cm in 150..193 -> true
        {height_in, "in"} when height_in in 59..76 -> true
        _ -> false
      end
    end

    hair_color_valid? = case Map.get(passport, :hcl) do
      nil -> false
      something -> String.match?(something, ~r/^#[0-9a-f]{6}$/)
    end

    eye_color_valid? = case Map.get(passport, :ecl) do
      "amb" -> true
      "blu" -> true
      "brn" -> true
      "gry" -> true
      "grn" -> true
      "hzl" -> true
      "oth" -> true
      _ -> false
    end

    passport_id_valid? = case Map.get(passport, :pid) do
      nil -> false
      something -> something |> String.match?(~r/^[0-9]{9}$/)
    end

    unless (birth_year_valid?
      and issue_year_valid?
      and expiration_year_valid?
      and height_valid?
      and hair_color_valid?
      and eye_color_valid?
      and passport_id_valid?) do
      :false
    else
      :true
    end
  end
end

Day4.main(System.argv())
