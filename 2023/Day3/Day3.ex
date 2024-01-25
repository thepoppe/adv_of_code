defmodule Day3 do

  def main do
    input = File.read!("sample.txt") |> String.split("\n")
    {:parsed, grid} = parse_input(input)
    #IO.inspect(grid)
    sum = iterate_rows(grid, 0)
    IO.puts("Sum: #{sum}")
    {:ok, sum}
  end

  def parse_input(text) do
    input = Enum.with_index(text)
    input = Enum.map(input, fn list ->
      {text, row} = list
      text = String.replace(text, ~r/\r$/, "")
        |> String.split("", trim: true)
        |> Enum.with_index()
      {text, row}
    end)
    {:parsed, input}
  end


  def iterate_rows(_, [], sum) do sum end
  def iterate_rows(full_list, [{h, row_num}|t], sum) do
    sum = iterate_row(full_list, h, row_num, "", sum)
    iterate_rows(full_list, t, sum)
  end

  def iterate_rows(list, sum) do
    [{h, row_num}|t] = list
    sum = iterate_row(list, h, row_num, "", sum)
    iterate_rows(list, t, sum)
  end


  def iterate_row(_, [], _,_, sum) do sum end
  def iterate_row(full_list, [{num, col} | t], row, number, sum) do
    case Regex.match?(~r/\d/, num) do
      true -> iterate_row(full_list, t, row, number <> num, sum)
      false ->
        if  String.length(number) > 0 do
          sum = verify_number(full_list, number, row, col-1, sum)
          iterate_row(full_list, t, row, "", sum)
        else
          iterate_row(full_list, t, row, number, sum)
        end
      end
  end

  def verify_number(full_list, number, row, last_index, sum) do
    first_index = last_index - String.length(number) +1
    is_adjacent =
      verify_same(full_list, row, first_index-1, last_index+1) ||
      verify_around(full_list, row-1, first_index-1, last_index+1) ||
      verify_around(full_list, row+1, first_index-1, last_index+1);

    case is_adjacent do
      true -> sum + String.to_integer(number)
      false -> sum
      _ -> :error
    end
  end


  def verify_same([{list, row}|_], row, ahead, behind) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    {potential_symb_behind, _} = Enum.at(list, behind)
    Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_infront) ||  Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_behind)
  end
  def verify_same([_|rest], r, ahead, behind) do verify_same(rest, r, ahead, behind) end


  def verify_around([], _, _, _)  do false end
  def verify_around(_, row, _, _) when row < 0 do false end
  def verify_around([{list, row}|_], row, start, stop) do verify_range(list, start, stop) end
  def verify_around([_|rest], row, start, stop) do verify_around(rest, row, start, stop) end


  def verify_range([], _, _)  do false end
  def verify_range([{_, col}|_], _, stop) when col > stop do false end
  def verify_range(list, start, stop) when start < 0  do verify_range(list, 0, stop) end
  def verify_range([{_, col}|t], start, stop) when col < start do verify_range(t, start, stop) end
  def verify_range([{h, _}|t], start, stop) do
    case Regex.match?(~r/[^a-zA-Z0-9\s.]/, h) do
      true -> true
      false -> verify_range(t,  start, stop)
    end
  end


end
