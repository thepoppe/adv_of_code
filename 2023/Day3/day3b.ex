defmodule Task2 do
  def main do
    input = File.read!("case3.txt") |> String.split("\n")
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

    prev_is_adjacent = verify_around(full_list, row-1, first_index, last_index+1);
    #below_is_adjacent = verify_around(full_list, row+1, first_index-1, last_index+1);
    #IO.inspect("same: #{inspect(same_is_adjacent)}")
    IO.inspect("prev: #{inspect(prev_is_adjacent)}")
    #IO.inspect(above_is_adjacent)

    case {same_is_adjacent, prev_is_adjacent, nil} do
      {nil, nil, nil} -> sum
      {{:same, true}, _, _} ->
        first_num = String.to_integer(number)
        second_num = String.to_integer(find_second_number(full_list, row, last_index+1, :same))

        IO.inspect("sum1: #{sum}, first num1: #{first_num}, second num1: #{second_num}")
        sum + (first_num*second_num)

      {_, {row, col, true}, _} ->
        first_num = String.to_integer(number)
        second_num =  String.to_integer(find_second_number(full_list, row, col, :around))
        IO.inspect("sum2: #{sum}, first num2: #{first_num}, second num2: #{second_num}")
        sum + (first_num*second_num)
      #{_, _, some}->
      #  first_num = String.to_integer(number)
      #  IO.inspect(some)
      #  second_num =  String.to_integer(some)
      #  IO.inspect("sum3: #{sum}, first num3: #{first_num}, second num3: #{second_num}")
      #  sum + (first_num*second_num)
    end
  end

  def verify_same([{list, row}|_], row, behind)when behind >= length(list) do nil end
  def verify_same([{list, row}|_], row, behind) do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\*/, potential_symb_behind) do
      {:same, true}
    else
      nil
    end
  end
  def verify_same([_|rest], r,  behind) do verify_same(rest, r, behind) end


  def verify_around([], _, _, _)  do nil end
  def verify_around(_, row, _, _) when row < 0 do nil end
  def verify_around([{list, row}|_], row, start, stop) do verify_range(list, row, start, stop) end
  def verify_around([_|rest], row, start, stop) do verify_around(rest, row, start, stop) end

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







  def find_second_number(list, row, col, :same) do
    same_row = iterate_until(list, row)
    next_row = iterate_until(list, row+1)
    prev_row =iterate_until(list, row-1)
    num_in_same_row = find_num_inline(:same, same_row, col+1)
    num_in_prev_row = find_num_around(:same, prev_row, col)
    num_in_next_row = find_num_around(:same, next_row, col)
    IO.inspect(":same, same:#{num_in_same_row}, prev:#{num_in_prev_row}, next:#{num_in_next_row}")
    case {num_in_same_row, num_in_prev_row, num_in_next_row} do
      {"","",""} -> "0"
      {_,"",""} -> num_in_same_row
      {"", _, ""} -> num_in_prev_row
      {"","", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :same"}
    end
  end

  def find_second_number(list, row, col, :around) do
    same_row = iterate_until(list, row)
    next_row = iterate_until(list, row+1)
    prev_row =iterate_until(list, row-1)
    num_in_same_row = find_num_inline(:around, same_row, col)
    num_in_prev_row = find_num_around(:around, prev_row, col)
    num_in_next_row = find_nums_right(next_row, col+1)
    IO.inspect(":around,#{row}, same:#{num_in_same_row}, prev:#{num_in_prev_row}, next:#{num_in_next_row}")
    case {num_in_same_row, num_in_prev_row, num_in_next_row} do
      {"","",""} -> "0"
      {_,"",""} -> num_in_same_row
      {"", _, ""} -> num_in_prev_row
      {"","", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :around"}
    end

  end

  def find_num_inline(_,[],_) do "" end
  def find_num_inline(:same,list, col)when col >= length(list) do "" end
  def find_num_inline(:same, list, behind) do
    {char, _} = Enum.at(list, behind)
    if Regex.match?(~r/\d/, char) do
      char <> find_nums_right(list, behind+1)
    else
      ""
    end
  end
  def find_num_inline(:around, list, col)when col == length(list)-1 do
    {char_to_left, _} = Enum.at(list, col-1)
    if Regex.match?(~r/\d/, char_to_left) do
      find_nums_left(list, col-1) <> char_to_left
    else
      ""
    end
  end
  def find_num_inline(:around, list, col)when col == 0 do
    {char_to_right, _} = Enum.at(list, col+1)
    if Regex.match?(~r/\d/, char_to_right) do
      char_to_right <> find_nums_right(list, col+1)
    else
      ""
    end
  end
  def find_num_inline(:around, list, col) do
    {char_ahead, _} = Enum.at(list, col-1)
    {char_behind, _} = Enum.at(list, col+1)
    case {Regex.match?(~r/\d/, char_ahead), Regex.match?(~r/\d/, char_behind)} do
      {false, false} -> ""
      {true, false} -> find_nums_left(list, col-2) <> char_ahead
      {false, true} -> char_behind <> find_nums_right(list, col+2)
      {true, true} -> {:error, "inline true true  ex. 24*24 should not be handled here"}
    end
#    if Regex.match?(~r/\d/, char) do
#    char <> find_nums_right(list, col+1)
#    else
#      ""
#    end
  end


  def find_num_around(_,[], _)  do "" end
  def find_num_around(_,list, col) when col >= length(list) do "" end
  def find_num_around(:same ,list, col) do
    {char, _} = Enum.at(list, col)
    if Regex.match?(~r/\d/, char) do
      find_nums_left(list, col-1) <> char <> find_nums_right(list, col+1)
    else
      find_nums_right(list, col+1)
    end
  end
  def find_num_around(:around ,list, col) do
    {num_at_col, _} = Enum.at(list, col)
    case Regex.match?(~r/\d/,num_at_col) do
      true -> find_nums_left(list, col-1) <> num_at_col  <> find_nums_right(list, col+1)
      false ->
        {num_before, _} = Enum.at(list, col-1)
        {num_after, _} = Enum.at(list, col+1)
        case {Regex.match?(~r/\d/,num_before), Regex.match?(~r/\d/,num_after)} do
          {false, false} -> ""
          {true, false} -> find_nums_left(list, col-2) <> num_before
          {false, true} -> num_after <> find_nums_right(list, col+2)
        end
    end
  end


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


  def iterate_until([],_) do [] end
  def iterate_until([{head, row}|_], row) do head end
  def iterate_until([{_, _}|tail], another_row) do iterate_until(tail, another_row) end

end
