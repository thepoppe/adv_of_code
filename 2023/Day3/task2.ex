defmodule Task2 do

  def main do
    input = File.read!("sample.txt") |> String.split("\n")
    {:parsed, grid} = Day3.parse_input(input)
    sum = iterate_rows(grid,0)
    {:ok, sum}
  end


  #def iterate_rows(_, [], sum) do sum end
  #def iterate_rows(prev, curr, sum) do
  #  [h|t] = curr
  #  sum = iterate_row(prev, h, t, "", sum)
  #  iterate_rows(h, t, sum)
  #end
#
  #def iterate_rows(list, sum) do
  #  [{h, row_num}|t] = list
  #  [next|rest] = t
  #  sum = iterate_row(list, h, row_num, "", sum)
  #  iterate_rows(list, t, sum)
  #end



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
          IO.inspect(sum)
          iterate_row(full_list, t, row, "", sum)
        else
          iterate_row(full_list, t, row, number, sum)
        end
      end
  end

  def verify_number(full_list, number, row, last_index, sum) do
    first_index = last_index - String.length(number) +1
    same_is_adjacent = verify_same(full_list, row, first_index-1, last_index+1)
    next_is_adjacent = verify_around(full_list, row+1, first_index-1, last_index+1);
    IO.inspect("same: #{inspect(same_is_adjacent)}")
    IO.inspect("next: #{inspect(next_is_adjacent)}")

    case {same_is_adjacent, next_is_adjacent} do
      {nil, nil} -> sum
      {{row, col, true}, _} ->
         sum + String.to_integer(number) *
      String.to_integer(find_second_number(full_list, row, col))
      {_, {row, col, true}} ->
        sum + String.to_integer(number) *
       String.to_integer(find_second_number(full_list, row+1, col))
    end

  end


  def verify_same([{list, row}|_], row, ahead, behind)when behind >= length(list) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    if Regex.match?(~r/\*/, potential_symb_infront) do
      {row, ahead, true}
    else
      nil
    end
  end
  def verify_same([{list, row}|_], row, ahead, behind)when ahead < 0 do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\*/, potential_symb_behind) do
      {row, behind, true}
    else
      nil
    end
  end
  def verify_same([{list, row}|_], row, ahead, behind) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\*/, potential_symb_infront) do
      {row, ahead, true}
    else
      if Regex.match?(~r/\*/, potential_symb_behind) do
        {row, behind, true}
      else
        nil
      end
    end
  end
  def verify_same([_|rest], r, ahead, behind) do verify_same(rest, r, ahead, behind) end


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


  ## AS A START WE ONLY CHECK IF NEXT ROW HAS A SYMB

  def find_second_number(list, row, col) do
    same_row = iterate_until(list, row)
    num_in_same_row = find_num_in_same(same_row, col-1, col+1)
    next_row = iterate_until(list, row+1)
    num_in_next_row = find_num_in_next(next_row, col)
    #IO.inspect(num_in_same_row)
    #IO.inspect(num_in_next_row)
    case {String.length(num_in_same_row), String.length(num_in_next_row)} do
      {0, 0} -> "0"
      {_, 0} -> num_in_same_row
      {0, _} -> num_in_next_row
      _ -> "0"
    end
  end


  def iterate_until([],_) do [] end
  def iterate_until([{head, row}|_], row) do head end
  def iterate_until([{_, _}|tail], another_row) do iterate_until(tail, another_row) end


  def find_nums_left(list, pos) do
    {char, _} = Enum.at(list, pos)
    case Regex.match?(~r/\d/, char) do
      true -> find_nums_left(list, pos-1 ) <> char
      false -> ""
    end
  end
  def find_nums_right(list, pos) do
    {char, _} = Enum.at(list, pos)
    case Regex.match?(~r/\d/, char) do
      true ->  char<> find_nums_left(list, pos+1)
      false -> ""
    end
  end


  #code duplication... :(
  def find_num_in_same(list, ahead, behind)when behind >= length(list) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    if Regex.match?(~r/\d/, potential_symb_infront) do
      find_nums_left(list, ahead-1) <> potential_symb_infront
    else
      "0"
    end
  end
  def find_num_in_same(list, ahead, behind)when ahead < 0 do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\d/, potential_symb_behind) do
      potential_symb_behind <> find_nums_left(list, behind+1)
    else
      "0"
    end
  end
  def find_num_in_same(list,  ahead, behind) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\d/, potential_symb_infront) do
      find_nums_left(list, ahead-1) <> potential_symb_infront
    else
      if Regex.match?(~r/\d/, potential_symb_behind) do
        potential_symb_behind <> find_nums_left(list, behind+1)
      else
        "0"
      end
    end
  end
  def find_num_in_same([_|rest], r, ahead, behind) do find_num_in_same(rest, r, ahead, behind) end


  def find_num_in_next([], _)  do "0" end
  def find_num_in_next(list, col) do
    last_pos = length(list)-1
    case col do
      0 ->
        {num_at_col, _} = Enum.at(list, col)
        {num_after, _} = Enum.at(list, col+1)
        case {Regex.match?(~r/\d/, num_at_col), Regex.match?(~r/\d/, num_after)} do
        {false, false} -> "0"
        {false, true} -> num_after <> find_nums_right(list, col+2)
        {true, _} -> num_at_col <> find_nums_right(list, col+1)
        end

      ^last_pos ->
        {num_at_col, _} = Enum.at(list, col)
        {num_before, _} = Enum.at(list, col-1)
        case {Regex.match?(~r/\d/, num_at_col), Regex.match?(~r/\d/, num_before)} do
        {false, false} -> "0"
        {false, true} -> find_nums_right(list, col-2) <> num_before
        {true, _} -> find_nums_right(list, col-1 ) <> num_at_col
        end
      _ ->
        {num_at_col, _} = Enum.at(list, col)
        {num_before, _} = Enum.at(list, col-1)
        {num_after, _} = Enum.at(list, col+1)
        case {Regex.match?(~r/\d/, num_at_col), Regex.match?(~r/\d/, num_before) , Regex.match?(~r/\d/, num_after)} do
        {false, false, false} -> "0"
        {_, true, false} -> find_nums_left(list, col-2) <> num_before
        {_, false, true} -> num_after <> find_nums_right(list, col+2)
        {true, _, _} -> find_nums_left(list, col-1) <> num_at_col <> find_nums_right(list, col+1)
        end
    end
  end

end
