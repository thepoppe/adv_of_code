defmodule Task2 do

  def main do
    input = File.read!("mini_sample.txt") |> String.split("\n")
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
          iterate_row(full_list, t, row, "", sum)
        else
          iterate_row(full_list, t, row, number, sum)
        end
      end
  end

  def verify_number(full_list, number, row, last_index, sum) do
    first_index = last_index - String.length(number) +1
    second_number = "0"
    same_is_adjacent = verify_same(full_list, row, first_index-1, last_index+1)
    next_is_adjacent = verify_around(full_list, row+1, first_index-1, last_index+1);
    #IO.inspect("same: #{inspect(same_is_adjacent)}")
    #IO.inspect("next: #{inspect(next_is_adjacent)}")

    case {same_is_adjacent, next_is_adjacent} do
      {{row, col, true}, _} -> sum + String.to_integer(number) *
      String.to_integer(find_second_number(full_list, row, col, second_number))
      {_, {row, col, true}} ->  sum + String.to_integer(number) *
       String.to_integer(find_second_number(full_list, row, col, second_number))
      _ -> sum
    end

  end


  def verify_same([{list, row}|_], row, ahead, behind)when behind >= length(list) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    if Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_infront) do
      {row, ahead, true}
    else
      nil
    end
  end
  def verify_same([{list, row}|_], row, ahead, behind)when ahead < 0 do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_behind) do
      {row, behind, true}
    else
      nil
    end
  end
  def verify_same([{list, row}|_], row, ahead, behind) do
    {potential_symb_infront, _} = Enum.at(list, ahead)
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_infront) do
      {row, ahead, true}
    else
      if Regex.match?(~r/[^a-zA-Z0-9\s.]/, potential_symb_behind) do
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


  def verify_range([],_, _, _)  do false end
  def verify_range([{_, col}|_],_, _, stop) when col > stop do nil end
  def verify_range(list, row, start, stop) when start < 0  do verify_range(list, row, 0, stop) end
  def verify_range([{_, col}|t], row, start, stop) when col < start do verify_range(t, row, start, stop) end
  def verify_range([{h, col}|t], row, start, stop) do
    case Regex.match?(~r/[^a-zA-Z0-9\s.]/, h) do
      true -> {row, col, true}
      false -> verify_range(t, row,  start, stop)
    end
  end


  ## AS A START WE ONLY CHECK IF NEXT ROW HAS A SYMB

  def find_second_number(list, row, col, num) do
    [h|t] = list
    same_row = iterate_until(list, row)
    num_in_same_row = find_num_in_same(same_row, col-1, col+1)
    IO.inspect(num_in_same_row)
    next_row = iterate_until(list, row+1)
    num_in_next_row = find_num_in_next(next_row, col)


    num
  end


  def iterate_until([],_) do [] end
  def iterate_until([{head, row}|_], row) do head end
  def iterate_until([{_, row}|tail], another_row) do iterate_until(tail, another_row) end


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
      ""
    end
  end
  def find_num_in_same(list, ahead, behind)when ahead < 0 do
    {potential_symb_behind, _} = Enum.at(list, behind)
    if Regex.match?(~r/\d/, potential_symb_behind) do
      potential_symb_behind <> find_nums_left(list, behind+1)
    else
      ""
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
        ""
      end
    end
  end
  def find_num_in_same([_|rest], r, ahead, behind) do find_num_in_same(rest, r, ahead, behind) end


  def find_num_in_next([], _)  do nil end
  def find_num_in_next(list, col) do
    IO.inspect("HEREWEARE")
    IO.inspect(list)
    IO.inspect(col)
    {num, _} = Enum.as(list, col)
    last_pos = length(list)-1
    case Regex.match?(~r/\d/, num), col do
      {true, 0} -> num <> find_nums_right(list, col+1)
      {true, ^last_pos} ->  find_nums_left(list, col-1) <> num
      {true, _} -> WRONG


      _ -> ""
    end
    #find_num_in_range(list, start, stop)
    ##CASESS ????????????????????????????????????
  end
  def find_num_in_next([_|rest], col) do find_num_in_next(rest, col) end


  def find_num_in_range([], _, _)  do false end
  def find_num_in_range([{_, col}|_],_, _, stop) when col > stop do nil end
  def find_num_in_range(list, start, stop) when start < 0  do find_num_in_range(list,  0, stop) end
  def find_num_in_range([{_, col}|t], start, stop) when col < start do find_num_in_range(t, start, stop) end
  def find_num_in_range([{h, col}|t], start, stop) do
    case Regex.match?(~r/[^a-zA-Z0-9\s.]/, h) do
      true -> { col, true}
      false -> find_num_in_range(t,  start, stop)
    end
  end






end
