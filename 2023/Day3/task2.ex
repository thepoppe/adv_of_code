defmodule Task2 do

  def main do
    input = File.read!("mini_sample.txt") |> String.split("\n")
    {:parsed, grid} = Day3.parse_input(input)
    sum = iterate_rows(grid,0)
    {:ok, sum}
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



  def iterate_row(_, [], _, number, sum) when number == ""  do sum end
  def iterate_row([{list,rows}|rest], [], row, number, sum)  do
    verify_number([{list,rows}|rest], number, row, length(list)-1, sum)
  end
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
    same_is_adjacent = verify_same(full_list, row, last_index+1)
    next_is_adjacent = verify_around(full_list, row+1, first_index-1, last_index+1);
    above_is_adjacent = verify_above(full_list, row-1, last_index);
    #IO.inspect("same: #{inspect(same_is_adjacent)}")
    #IO.inspect("next: #{inspect(next_is_adjacent)}")
    IO.inspect(above_is_adjacent)

    case {same_is_adjacent, next_is_adjacent, above_is_adjacent} do
      {nil, nil, nil} -> sum
      {{row, col, true}, _, nil} ->
        first_num = String.to_integer(number)
        second_num = String.to_integer(find_second_number(full_list, row, col))
        IO.inspect("sum1: #{sum}, first num1: #{first_num}, second num1: #{second_num}")
        sum + (first_num*second_num)


      {_, {row, col, true}, nil} ->
        first_num = String.to_integer(number)
        second_num =  String.to_integer(find_second_number(full_list, row, col))
        IO.inspect("sum2: #{sum}, first num2: #{first_num}, second num2: #{second_num}")
        sum + (first_num*second_num)

      {_, _, some}->
        first_num = String.to_integer(number)
        IO.inspect(some)
        second_num =  String.to_integer(some)
        IO.inspect("sum3: #{sum}, first num3: #{first_num}, second num3: #{second_num}")
        sum + (first_num*second_num)
    end

  end


  def verify_same([{list, row}|_], row, behind)when behind >= length(list) do nil end
  def verify_same([{list, row}|_], row, behind) do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\*/, potential_symb_behind) do
      {row, behind, true}
    else
      nil
    end
  end
  def verify_same([_|rest], r,  behind) do verify_same(rest, r, behind) end


  def verify_around([], _, _, _)  do nil end
  def verify_around(_, row, _, _) when row < 0 do nil end
  def verify_around([{list, row}|_], row, start, stop) do verify_range(list, row, start, stop) end
  def verify_around([_|rest], row, start, stop) do verify_around(rest, row, start, stop) end



  def verify_above([], _, _)  do nil end
  def verify_above(_, row, _) when row < 0 do nil end
  def verify_above([{list, row}|t], row, right) do
    next_row = iterate_until(t, row+1)
    case verify_edges(list, right) do
      :right -> #CHECK NEXT right
        find_num_in_next(next_row, right+1)
      _ -> nil
    end
  end
  def verify_above([_|rest], row, right) do verify_above(rest, row,  right) end

  def verify_edges([], _) do nil end
  def verify_edges(list, right) do
    max_length = length(list)
    case right do
       ^max_length -> nil
       _ ->
        {right_char,_} = Enum.at(list, right)
        case Regex.match?(~r/\*/, right_char) do
          true -> #CHECK NEXT RIGHT
            :right
          false -> nil
        end
    end
  end

  def verify_range([],_, _, _)  do nil end
  def verify_range([{_, col}|_],_, _, stop) when col > stop do nil end
  def verify_range(list, row, start, stop) when start < 0  do verify_range(list, row, 0, stop) end
  def verify_range([{_, col}|t], row, start, stop) when col < start do verify_range(t, row, start, stop) end
  def verify_range([{h, col}|t], row, start, stop) do
    case Regex.match?(~r/\*/, h) do
      true -> {row, col, true}
      false -> verify_range(t, row,  start, stop)
    end
  end


  ## AS A START WE ONLY CHECK IF NEXT ROW HAS A SYMB

  def find_second_number(list, row, col) do
    same_row = iterate_until(list, row)
    next_row = iterate_until(list, row+1)
    prev_row =iterate_until(list, row-1)
    num_in_same_row = find_num_in_same(same_row, col+1)
    num_in_next_row = find_num_in_next(next_row, col)
    num_in_prev_row = find_num_in_next(prev_row, col)
    #IO.inspect("looking for adjacent numbers")
    #IO.inspect(num_in_same_row)
    #IO.inspect(num_in_next_row)
    #IO.inspect(num_in_prev_row)
    case {num_in_same_row, num_in_next_row, num_in_prev_row} do
      {"", "", ""} -> "0"
      {_, "", ""} -> num_in_same_row
      {"", _, ""} -> num_in_next_row
      {"", "", _} -> num_in_prev_row
      _ -> "0"
    end
  end


  def iterate_until([],_) do [] end
  def iterate_until([{head, row}|_], row) do head end
  def iterate_until([{_, _}|tail], another_row) do iterate_until(tail, another_row) end


  def find_nums_left(list, pos) when pos < 0 do "" end
  def find_nums_left(list, pos) do
    {char, _} = Enum.at(list, pos)
    case Regex.match?(~r/\d/, char) do
      true ->   find_nums_left(list, pos-1)<>char
      false -> ""
    end
  end

  def find_nums_right(list, pos) when pos >= length(list) do "" end
  def find_nums_right(list, pos) do
    {char, _} = Enum.at(list, pos)
    case Regex.match?(~r/\d/, char) do
      true ->  char<> find_nums_right(list, pos+1)
      false -> ""
    end
  end


  #code duplication... :(
  def find_num_in_same([],_) do "" end
  def find_num_in_same(list, behind)when behind >= length(list) do "" end
  def find_num_in_same(list, behind) do
    {char, _} = Enum.at(list, behind)
    if Regex.match?(~r/\d/, char) do
      char <> find_nums_right(list, behind+1)
    else
      ""
    end
  end


  def find_num_in_next([], _)  do "" end
  def find_num_in_next(list, col) when col >= length(list) do "" end
  def find_num_in_next(list, col) do
    {char, _} = Enum.at(list, col)
    if Regex.match?(~r/\d/, char) do
      find_nums_left(list, col-1) <> char <> find_nums_right(list, col+1)
    else
      find_nums_right(list, col+1)
    end
  end

end
