defmodule Day7a do
#MISSAT FALLET MED 2 pairs...
  def main do
    decks =
      File.read!("real.txt")
      |> parse()
      |> Enum.map(&evaluate_decks/1)
      |> Enum.sort(&compare_results/2)
      sum = calculate(decks, 1,0)
    {:ok, sum}
  end

  def calculate([],_,acc) do acc end
  def calculate([{_,_,{:bid, bid}}|t], rank, acc) do calculate(t, rank+1, acc + (rank * bid) ) end

  def compare_results({{:score, s1}, _, _}, {{:score, s2}, _, _}) when s1 < s2 do true end
  def compare_results({score, {:deck, [card_left|_]}, _}, {score, {:deck, [card_right|_]}, _}) when card_left < card_right do true end
  def compare_results({score, {:deck, [card|tail_left]}, bid_left}, {score, {:deck, [card|tail_right]}, bid_right}) do
    compare_results({score, {:deck, tail_left}, bid_left}, {score, {:deck, tail_right}, bid_right})
  end
  def compare_results(_, _) do false end


  def evaluate_decks({deck, bid}) do
    score = Enum.map(deck, fn valor -> Enum.reduce(deck, 0, fn next, acc -> if next == valor do acc+1 else acc end end) end)
    score = case check_for_house(score, :zero) do
      :no ->
        max = Enum.max(score)
        pairs = Enum.zip(score, deck)
        |> Enum.filter(fn {score, _valor} -> score == max end)
        case max do
          1 -> 0
          2 -> if length(pairs)> 2 do 2 else 1 end
          3 -> 3
          4 -> 5
          5 -> 6
        end
      :yes -> 4
    end
    {{:score, score}, {:deck, deck}, {:bid, bid}}
  end

  def remove_smaller([], acc) do acc end
  def remove_smaller([first|rest], []) do remove_smaller(rest, [first]) end
  def remove_smaller([num = {_, num1}|rest], acc = [{_, num2}| _]) do
    if num1 < num2 do
      acc
    else
      remove_smaller(rest, [num | acc])
    end
  end

  def check_for_house([], _) do :no end
  def check_for_house([score | next], :zero) when score == 3 do check_for_house(next, :three) end
  def check_for_house([score | next], :zero) when score == 2 do check_for_house(next, :two) end
  def check_for_house([score | _], :three) when score == 2 do :yes end
  def check_for_house([score | _], :two) when score == 3 do :yes end
  def check_for_house([_ | next], other) do check_for_house(next, other) end



  def parse(text)do
    text
    |> String.split("\r\n")
    |> Enum.map(fn deck ->
      [cards| bid] = String.split(deck, " ")
      {cards
      |> String.split("", trim: true)
      |> Enum.reject(&(&1 == ""))
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
