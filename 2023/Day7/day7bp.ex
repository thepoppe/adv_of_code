# Timer function :timer.tc from erlang lib used to bench.
# almost two times faster than day7b.ex. from best meassurment {1638, {:ok, 244848487} to {921, {:ok, 244848487}}
defmodule Day7bp do

  def main(decks) do
    decks = decks
      |> Enum.map(&replace_jokers/1)
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

  def replace_jokers({deck, bid}) do
    no_jokers = Enum.filter(deck, fn valor -> valor !=1  end)
    case length(no_jokers) do
      0 -> {{:score, 6}, {:deck, deck}, {:bid, bid}}
      _ ->
        repetitions = count_repetitions(no_jokers, %{})
        {valor, count} = find_most_repetitions(no_jokers, repetitions, :first)
        nof_jokers = length(deck) - length(no_jokers)
        case count + nof_jokers do
          5 -> {{:score, 6}, {:deck, deck}, {:bid, bid}}
          4 -> {{:score, 5}, {:deck, deck}, {:bid, bid}}
          3 ->
            case find_another_two_count(Map.delete(repetitions, valor), no_jokers) do
              :ok -> {{:score, 4}, {:deck, deck}, {:bid, bid}}
              :no -> {{:score, 3}, {:deck, deck}, {:bid, bid}}
            end
          2 ->
            case find_another_two_count(Map.delete(repetitions, valor), no_jokers) do
              :ok -> {{:score, 2}, {:deck, deck}, {:bid, bid}}
              :no -> {{:score, 1}, {:deck, deck}, {:bid, bid}}
            end
          1 -> {{:score, 0}, {:deck, deck}, {:bid, bid}}
        end

    end
  end


  def find_another_two_count(_map, []) do :no end
  def find_another_two_count(map, [key | keys]) do
    case Map.get(map,key) do
      2 -> :ok
      _ -> find_another_two_count(map, keys)
    end
  end

  def find_most_repetitions([], _map, {valor, count}) do {valor, count} end
  def find_most_repetitions([valor|rest], map, :first) do find_most_repetitions(rest, map, {valor, Map.get(map, valor)}) end
  def find_most_repetitions([valor|rest], map, {val, count}) do
    new_count = Map.get(map, valor)
    if(new_count > count) do
      find_most_repetitions(rest, map, {valor, new_count} )
    else
      find_most_repetitions(rest, map, {val, count} )
    end
  end

  def count_repetitions([], map) do map end
  def count_repetitions([valor|rest], map) do
    case Map.fetch(map, valor) do
      :error -> count_repetitions(rest, Map.put(map, valor, 1))
      {:ok, num} -> count_repetitions(rest, Map.put(map, valor, num + 1))
    end
  end






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
