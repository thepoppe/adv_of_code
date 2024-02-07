defmodule Day4a do

  def parse() do
    {_, text} = File.read("ex.txt")
    text = String.split(text, "\n")
    text = Enum.map(text, &parse_row/1)
    {:ok, text}
  end

  def parse_row(string) do
    [card | [first |[second|[]]]] = String.split(string, [":","|"])
    IO.inspect(card)
    card = String.to_atom()
  end


end
