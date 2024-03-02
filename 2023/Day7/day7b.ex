defmodule Day7b do

    def main(decks) do
      decks = decks
        |> Enum.map(&evaluate_deck/1)
        |> Enum.sort(&compare_results/2)
        sum = calculate(decks, 1, 0)
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

    def replace_jokers(deck) do
      no_jokers = Enum.filter(deck, fn valor -> valor !=1  end)
      case length(no_jokers) do
        0 -> deck #jjjjj
        _ ->
          highest_count_valor = find_most_repetitions(no_jokers, :none)
          Enum.map(deck, fn valor -> if valor == 1 do highest_count_valor else valor end end)
      end
    end
#Better solution would be to use the map values found, add the number of jokers to the count and use the map count.
    def find_most_repetitions([h|[]], :none) do h end
    def find_most_repetitions([h|t], :none) do
      map = count_repetitions([h|t], %{})
      leader = Map.get(map,h)
      find_most_repetitions(t, Map.delete(map,h), {h, leader})
    end
    def find_most_repetitions([], _map, {valor, _count}) do valor end
    def find_most_repetitions([valor|rest], map, {val, count}) do
      new_count = Map.get(map, valor)
      if(new_count > count) do
        find_most_repetitions(rest, Map.delete(map,valor), {valor, new_count} )
      else
        find_most_repetitions(rest, Map.delete(map,valor), {val, count} )
      end
    end

    def count_repetitions([], map) do map end
    def count_repetitions([valor|rest], map) do
      case Map.fetch(map, valor) do
        :error -> count_repetitions(rest, Map.put(map, valor, 1))
        {:ok, num} -> count_repetitions(rest, Map.put(map, valor, num + 1))
      end
    end



    def evaluate_deck({deck, bid}) do
      no_jokers = replace_jokers(deck)
      scores = Enum.map(no_jokers, fn valor -> Enum.reduce(no_jokers, 0, fn next, acc -> if next == valor do acc+1 else acc end end) end)
      res = case check_for_house(scores, :zero) do
        :no ->
          max = Enum.max(scores)
          pairs = Enum.filter(scores, fn score -> score == max end)
          case max do
            1 -> 0
            2 -> if length(pairs)> 2 do 2 else 1 end
            3 -> 3
            4 -> 5
            5 -> 6
          end
        :yes -> 4
      end
      {{:score, res}, {:deck, deck}, {:bid, bid}}
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
        "J" -> 1
        "Q" -> 12
        "K" -> 13
        "A" -> 14
      end
    end
  end
