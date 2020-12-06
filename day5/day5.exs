#! /usr/bin/env elixir

defmodule Day5 do
  def main(args) do
    {:ok, filename} = parse_args(args)
    {:ok, handle} = File.open(filename, [:read])

    boarding_passes = read_boarding_passes(handle)

    star1 = Enum.max(boarding_passes)
    IO.puts("Star 1: Highest seat ID is #{star1}")

    star2 = find_missing_seat(boarding_passes)
    IO.puts("Star 2: The missing (your) seat ID is #{star2}")
  end

  defp parse_args([]), do: {:error, "No filename given!"}
  defp parse_args([filename | _]), do: {:ok, filename}

  defp read_boarding_passes(handle, boarding_passes \\ []) do
    case IO.read(handle, :line) do
      :eof -> Enum.reverse(boarding_passes)
      line ->
        case Regex.run(~r/([FB]{7})([RL]{3})/, line, capture: :all_but_first) do
          nil ->
            read_boarding_passes(handle, boarding_passes)
          [rowstring, colstring] ->
            row = parse_rowstring(rowstring)
            column = parse_colstring(colstring)
            seat_id = 8 * row + column
            read_boarding_passes(handle, [seat_id | boarding_passes])
        end
    end
  end

  defp parse_rowstring(rowstring) when is_binary(rowstring) do
    parse_rowstring(String.to_charlist(rowstring), 0, 128)
  end
  defp parse_rowstring([], min, _max), do: min
  defp parse_rowstring([head | tail], min, max) do
    case head do
      ?F -> parse_rowstring(tail, min, max - div(max - min, 2))
      ?B -> parse_rowstring(tail, min + div(max - min, 2), max)
    end
  end

  defp parse_colstring(colstring) when is_binary(colstring) do
    parse_colstring(String.to_charlist(colstring), 0, 8)
  end
  defp parse_colstring([], min, _max), do: min
  defp parse_colstring([head | tail], min, max) do
    case head do
      ?L -> parse_colstring(tail, min, max - div(max - min, 2))
      ?R -> parse_colstring(tail, min + div(max - min, 2), max)
    end
  end

  def find_missing_seat(boarding_passes, sorted \\ :false)
  def find_missing_seat(boarding_passes, :false), do: find_missing_seat(Enum.sort(boarding_passes), :true)
  def find_missing_seat([current | tail = [next | _]], :true) do
    case next - current do
      2 -> next - 1
      _ -> find_missing_seat(tail, :true)
    end
  end
  def find_missing_seat(_, _), do: "not found"  # To allow example.txt to pass through

end

Day5.main(System.argv())
