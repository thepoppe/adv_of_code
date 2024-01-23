defmodule Day2Task2 do
  def main() do
    file = "small_sample.txt"
    {:ok, res} = Day2.parse_input(file)
    games = Enum.map(res,  &Day2.verify_game/1)
  end
end
