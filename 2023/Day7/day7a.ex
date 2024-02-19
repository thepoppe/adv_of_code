defmodule Day7a do

  def main do
    File.read!("ex.txt")
    |> parse()
    |> Enum.map(&evaluate_deck/1)
  end

  def evaluate_deck({deck, bid}) do
    deck
  end

  def parse(text)do
    text
    |> String.split("\r\n")
    |> Enum.map(fn deck ->
      [cards| bid] = String.split(deck, " ")
      {cards
      |> String.split("", trim: true)
      |> Enum.reject(&(&1 == ""))
      |> Enum.sort()
      |> Enum.map(fn str -> if String.match?(str, ~r/\d/) do String.to_integer(str) else String.to_atom(str) end end),
      String.to_integer(List.to_string(bid))}
    end)

  end
end
