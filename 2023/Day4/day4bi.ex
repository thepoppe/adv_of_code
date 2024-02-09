defmodule Day4b do
  # different approach for row attach a changable number that is updated when we find matches.
  # NOT DONE


  def main() do
    {_, text} = File.read("real.txt")
    list = text |> String.split("\n") |> Enum.map(&parse_row/1)

  end



  def parse_row(string) do
    [game | [first |[second|[]]]] = String.split(string, [":","|"])
    [_|game] = String.split(game, " ")
    game = String.to_integer(List.to_string(game))
    first = first
    |> String.trim()
    |> String.split(" ")
    |> Enum.filter(fn x -> String.length(x)> 0 end)
    |> Enum.map(&String.to_integer/1)
    second = second
    |> String.trim()
    |> String.split(" ")
    |> Enum.filter(fn x -> String.length(x)> 0 end)
    |> Enum.map(fn x -> String.to_integer(x) end)
    {game, first, second}
  end


  end
