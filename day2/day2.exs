#! /usr/bin/env elixir



defmodule Day2 do

  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])

    {star1, star2} = process_password_file(handle)
    IO.puts("Star 1: #{star1} passwords match.")
    IO.puts("Star 2: #{star2} passwords match.")
  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  @regex_password ~r/([0-9]+)-([0-9]+) ([a-z]): ([a-z]+).*/

  defp process_password_file(handle, num_valid_star1_passwords \\ 0, num_valid_star2_passwords \\ 0) do
    case IO.read(handle, :line) do

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")

      :eof ->
        {num_valid_star1_passwords, num_valid_star2_passwords}

      line ->
        # Parse
        {first, second, must_have, password} =
          Regex.run(@regex_password, line, capture: :all_but_first)
          |> fn [a, b, c, d] -> {String.to_integer(a), String.to_integer(b), List.first(String.to_charlist(c)), to_charlist(d)} end.()

        # Star1
        num_valid_star1_passwords = case Enum.count(password, fn character -> character == must_have end) do
          x when x in first..second -> num_valid_star1_passwords + 1
          _ -> num_valid_star1_passwords
        end

        # Star2
        first_matches? = (Enum.at(password, first - 1) == must_have)
        second_matches? = (Enum.at(password, second - 1) == must_have)
        num_valid_star2_passwords = case (first_matches? != second_matches?) do
          true -> num_valid_star2_passwords + 1
          false -> num_valid_star2_passwords
        end

        process_password_file(handle, num_valid_star1_passwords, num_valid_star2_passwords)

    end
  end

end


Day2.main(System.argv())
