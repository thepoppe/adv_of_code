defmodule Task2 do
  def main do
    input = File.read!("input.txt") |> String.split("\n")
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
    #case1
    same_is_adjacent = verify_same(full_list, row, last_index+1)
    #case2
    prev_is_adjacent = verify_around(full_list, row-1, first_index, last_index+1);
    #case3
    next_is_adjacent = verify_around(full_list, row+1, first_index-1, last_index+1)
    #IO.inspect("SAME IS ADJACENT:#{inspect(same_is_adjacent)}")
    #IO.inspect("PREV IS ADJACENT:#{inspect(prev_is_adjacent)}")
    #IO.inspect("NEXT IS ADJACENT:#{inspect(next_is_adjacent)}")

    #OBS THIS CASE OPERATOR MAY LEAVE THINGS OUT?????
    case {same_is_adjacent, prev_is_adjacent, next_is_adjacent} do
      {nil, nil, nil} -> sum
      {{:same, true}, _, _} ->
        first_num = String.to_integer(number)
        second_num = String.to_integer(find_second_number(full_list, row, last_index+1, :same))
        #IO.inspect("sum1: #{sum}, first num1: #{first_num}, second num1: #{second_num}")
        sum + (first_num*second_num)

      {_, {row, col, true}, _} ->
        first_num = String.to_integer(number)
        if col == (last_index+1) do
          second_num =  String.to_integer(find_second_number(full_list, row, col, :prev))
          #IO.inspect("sum2a: #{sum}, first num2: #{first_num}, second num2: #{second_num}")
          sum + (first_num * second_num)
        else
          #second_num =  String.to_integer(find_second_number(full_list, row, col, :above))
          #IO.inspect("sum2b: #{sum}, first num2: #{first_num}, second num2: #{second_num}")
          #sum + (first_num * second_num)
          sum
        end


      {_, _, {row, col, true}}->
        first_num = String.to_integer(number)
        if col == (last_index+1) do
          second_num =  String.to_integer(find_second_number(full_list, row, col, :next))
          #IO.inspect("sum3a: #{sum}, first num3: #{first_num}, second num3: #{second_num}")
          sum + (first_num * second_num)
        else
          second_num =  String.to_integer(find_second_number(full_list, row, col, :below))
          #IO.inspect("sum3b: #{sum}, first num3: #{first_num}, second num3: #{second_num}")
          sum + (first_num * second_num)
        end


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
    num_in_same_row = find_nums_right(same_row, col+1)
    num_in_prev_row = search_row( prev_row, col, :right)
    num_in_next_row = search_row( next_row, col, :right)

    case {num_in_same_row, num_in_prev_row, num_in_next_row} do
      {"","",""} -> "0"
      {_,"",""} -> num_in_same_row
      {"", _, ""} -> num_in_prev_row
      {"","", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :same"}
    end
  end

  def find_second_number(list, row, col, :prev) do
    same_row = iterate_until(list, row)
    #prev_row =iterate_until(list, row-1)
    next_row = iterate_until(list, row+1)

    num_in_same_row = find_nums_right(same_row, col+1)
    #num_in_prev_row = search_row(prev_row, col, :right) #
    #num_in_prev_row = find_nums_right(prev_row, col+1)  #POSSIBLE SOl TO AVOID twocases code still fails...
    num_in_next_row = find_nums_right(next_row, col+1)

    #IO.inspect(":around,#{row}, same:#{num_in_same_row}, prev:#{num_in_prev_row}, next:#{num_in_next_row}")
    case {num_in_same_row, "", num_in_next_row} do
      {"","",""} -> "0"
      {_,"",""} -> num_in_same_row
      {"", _, ""} -> "0"
      {"","", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :prev"}
    end
  end
  #def find_second_number(list, row, col, :above) do
  #  same_row = iterate_until(list, row)
  #  prev_row =iterate_until(list, row-1)
  #
  #  num_in_same_row = find_nums_right(same_row, col+1)
  #  num_in_prev_row = find_nums_right(prev_row, col+1)
  #  IO.inspect(":above,#{row}, same:#{num_in_same_row}, prev:#{num_in_prev_row}")
  #  case {num_in_same_row, num_in_prev_row,} do
  #    {"",""} -> "0"
  #    {_,""} -> num_in_same_row
  #    {"", _} -> num_in_prev_row
  #    _ -> {:error, "weird things happening in find second number :above"}
  #  end
  #end

  def find_second_number(list, row, col, :next) do
    same_row = iterate_until(list, row)
    prev_row =iterate_until(list, row-1)
    next_row = iterate_until(list, row+1)

    num_in_same_row = case {find_nums_left(same_row, col-1), find_nums_right(same_row, col+1)} do
      {"", ""} -> ""
      {num, ""} -> num
      {"", num} -> num
    end
    num_in_prev_row = find_nums_right(prev_row, col+1)
    num_in_next_row = search_row(next_row, col, :both) #NEW

    case {num_in_same_row, num_in_prev_row, num_in_next_row} do
      {"","",""} -> "0"
      {_,"",""} -> num_in_same_row
      {"", _, ""} -> num_in_prev_row
      {"","", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :next"}
    end
  end
  def find_second_number(list, row, col, :below) do
    same_row = iterate_until(list, row)
    next_row = iterate_until(list, row+1)

    num_in_same_row = find_nums_right(same_row, col+1)
    num_in_next_row = search_row(next_row, col, :both) #NEW

    case {num_in_same_row,  num_in_next_row} do
      {"",""} -> "0"
      {_, ""} -> num_in_same_row
      {"", _} -> num_in_next_row
      _ -> {:error, "weird things happening in find second number :below"}
    end
  end

  defp search_row([], _, _)  do "" end
  defp search_row(list, col, :right) when col == length(list) do "" end
  defp search_row(list, col, :right) do
    {num_at_col,_} = Enum.at(list, col)
    if Regex.match?(~r/\d/, num_at_col) do
      find_nums_left(list, col-1)<> num_at_col <> find_nums_right(list, col+1)
    else
      find_nums_right(list, col+1)
    end
  end
  defp search_row(list, col, :both) when col == length(list) do
    find_nums_left(list,col-1)
  end
  defp search_row(list, col, :both) do
    right_num = search_row(list, col, :right)
    if String.length(right_num) > 0 do
      right_num
    else
      find_nums_left(list, col-1)
    end
  end

  def find_nums_left(_, pos) when pos < 0 do "" end
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
