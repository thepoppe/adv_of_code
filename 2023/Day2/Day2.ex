defmodule Day2 do
  def main() do
    file = "small_sample.txt"
    {:ok, res} = parse_input(file)
    games = Enum.map(res,  &verify_game/1)
    valid_games =  Enum.reject(games, &filter_games/1)
    IO.inspect(valid_games)
    :ok
  end

  def filter_games(list) do
    Enum.member?(list, {0, :false})
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

  def verify_color([n | c]) when n < 12 and c == ["red"|[]], do: {n, :true}
  def verify_color([n | c]) when n < 13 and c == ["green"|[]], do: {n, :true}
  def verify_color([n | c]) when n < 14 and c == ["blue"|[]], do: {n, :true}
  def verify_color([_ | _]), do: {0, false}



end
