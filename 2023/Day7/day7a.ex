defmodule Day7a do

  def main do
    decks =
      File.read!("ex.txt")
      |> parse()
      |> Enum.map(&evaluate_decks/1)

    #Enum.sort(decks, &compare_results/2)

  end

  def compare_results(deck1 = {{:type, type1}, _, _}, deck2 = {{:type, type2}, _, _}) when type1 > type2 do deck1 end
  def compare_results(deck1 = {{:type, type1}, _, _}, deck2 = {{:type, type2}, _, _}) when type1 < type2 do deck2 end
  def compare_results(deck1 = {_, {:score, s1}, _}, deck2 = {_, {:score, s2}, _}) when s1 <= s2 do deck1 end
  def compare_results(deck1 = {_, {:score, s1}, _}, deck2 = {_, {:score, s2}, _}) when s1 > s2 do deck2 end


  def evaluate_decks({deck, bid}) do
    #IO.inspect("deck")
    #IO.inspect(deck)
    score = Enum.map(deck, fn valor -> Enum.reduce(deck, 0, fn next, acc -> if next == valor do acc+1 else acc end end) end)
    #IO.inspect(deck)
    #IO.inspect(score)
    {score, sum} = case check_for_house(score, :zero) do
      :no ->
        max = Enum.max(score)
        pairs = Enum.filter(Enum.zip(deck, score), fn {_num, score} -> score == max end)
        sum = Enum.reduce(pairs, 0, fn {num, _}, acc -> acc + num end)
        if max> 4 do {max + 1, sum} else {max, sum} end
      :yes ->
        {4, Enum.sum(deck)}
    end
    {{:type, score}, {:score, sum}, {:bid, bid}}

  end

  def check_for_house([], _) do :no end
  def check_for_house([score | next], :zero) when score == 3 do check_for_house(next, :three) end
  def check_for_house([score | next], :zero) when score == 2 do check_for_house(next, :two) end
  def check_for_house([score | next], :three) when score == 2 do :yes end
  def check_for_house([score | next], :two) when score == 3 do :yes end
  def check_for_house([score | next], other) do check_for_house(next, other) end



  def parse(text)do
    text
    |> String.split("\r\n")
    |> Enum.map(fn deck ->
      [cards| bid] = String.split(deck, " ")
      {cards
      |> String.split("", trim: true)
      |> Enum.reject(&(&1 == ""))
      |> Enum.sort(:desc)
      |> Enum.map(fn str ->
        if String.match?(str, ~r/\d/) do
          String.to_integer(str)
        else convert_chars(str)
        end
        end),
      String.to_integer(List.to_string(bid))}
    end)

  end

  def convert_chars(char) do
    case char do
      "T" -> 10
      "J" -> 11
      "Q" -> 12
      "K" -> 13
      "A" -> 14
    end
  end
end
