defmodule Day2Task2 do
  def main() do
    file = "input.txt"
    {:ok, res} = Day2.parse_input(file)
    games = Enum.map(res,  &Day2.verify_game/1)
    total = Enum.reduce(games, 0, fn game, acc -> {:ok,res} =find_largest_colors(game); res + acc end)
    {:ok, total}
  end

  def find_largest_colors(game) do
    list = Enum.reduce(game, [], fn {val, col, stat}, acc ->
      add(acc, {val, col, stat})
    end)
    power_set = Enum.reduce(list, 1, fn {v,_,_}, acc -> v*acc end)
    {:ok, power_set}
  end

  def add([], game) do [game|[]] end
  def add([{val, col, _} |t], {v, c, stat}) when v > val and c==col do [{v, col, stat}| t] end
  def add([h|t], game) do
    {_, col, _} = h
    {_, c, _} = game
    if(col != c) do
      [h | add(t, game) ]
    else [h | t]
    end
  end


end
