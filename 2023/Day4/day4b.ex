defmodule Day4b do
# very bad solution in regards to time complexity but it works
def main() do
  {_, text} = File.read("real.txt")
  list = text |> String.split("\n") |> Enum.map(&parse_row/1)
  matches = Enum.reverse(Enum.reduce(list, [], &find_matches/2))
  matches = Enum.reverse(List.flatten(map_matches(matches,matches)))
  matches = calc_sum(matches)
  {:ok, length(matches)}
end

def calc_sum(matches) do
  Enum.sort(matches, fn {num1,_}, {num2,_} -> num1<num2 end)
end

def map_matches(matches, og_matches) do

  Enum.reduce(matches, [], fn match, acc->
    {game, nof} = match;
    adjacent_matches = Enum.filter(og_matches, fn {g, _} -> game<g and g <= game+nof end)
    [map_matches(adjacent_matches, og_matches) | [match | acc]]
  end)


end



def find_matches(row, acc) do
  {game, nums , matches} = row;
  matches = Enum.filter(nums, fn num -> Enum.member?(matches, num) end)
  [{game, length(matches)}|acc]

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
