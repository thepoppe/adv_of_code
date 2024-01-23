defmodule Day2 do
  def main() do
    file = "task1_sample.txt"
    {:ok, res} = parse_input(file)
    games = Enum.map(res,  &verify_game/1)
    indexed = Enum.with_index(games)
    valid_games =  Enum.reject(indexed, &filter_games/1)
    sum = Enum.reduce(valid_games, 0, fn {value, index}, acc -> acc + (index+1) end)
    {:done, sum}
  end

  def filter_games(list) do
    {elements, index} = list
    Enum.member?(elements, {0, :false})
  end

  def parse_input(file) do
    {:ok, res} = File.read(file)
     res = String.split(res, ["\n"])
     {:ok, Enum.map(res, &convert_text/1)}
  end

  def convert_text(row) do
    res = String.replace(row, ~r/Game \d+:/, "")
    res = String.trim(res)
    String.split(res, [";", ","])
  end

  def verify_game(game_set) do
    Enum.map(game_set, &compare_string/1)
  end

  def compare_string(string) do
    string= String.trim(string)
    [num | col] = String.split(string, " ")
    res = [String.to_integer(num) | col]
    verify_color(res)
  end

  def verify_color([n | c]) when n < 13 and c == ["red"|[]], do: {n, :true}
  def verify_color([n | c]) when n < 14 and c == ["green"|[]], do: {n, :true}
  def verify_color([n | c]) when n < 15 and c == ["blue"|[]], do: {n, :true}
  def verify_color([_ | _]), do: {0, false}



end
