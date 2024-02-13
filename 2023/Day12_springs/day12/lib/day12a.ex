defmodule Day12a do

  # https://adventofcode.com/2023/day/12
  def main do
    {_, text} = File.read("full.txt");
    parsed = parse(text);
     sum = Enum.reduce(parsed, 0 , fn row, acc -> check_row(row, acc) end);
    {:ok, sum};
  end

  def check_row({[], []}, acc) do acc+1 end
  def check_row({[], _}, acc) do acc end
  def check_row({["." | rest], []}, acc) do check_row({rest, []},acc) end
  def check_row({["." | rest], map}, acc) do check_row({rest, map}, acc) end
  def check_row({["#" | _], []}, acc) do acc end
  def check_row({["#" | rest] , [h|t]}, acc) do
    case verify_next(rest, h-1) do
      :fail -> acc
      {:ok, seq, :next} -> check_row({seq, t}, acc)
      {:ok, seq, num} -> check_row({seq, [num|t]}, acc)
    end
  end
  def check_row({["?" | rest], map},acc) do
    acc = check_row({["#" | rest], map}, acc)
    check_row({["." | rest], map}, acc)
  end
  def check_row(_,acc) do acc end



  def verify_next([], num) when num > 0 do :fail end
  def verify_next([], _)  do {:ok, [], :next} end
  def verify_next(["?" | rest], n) when n == 0  do {:ok, rest, :next} end
  def verify_next(["?" | rest], n)  do {:ok, ["#" | rest], n} end
  def verify_next(["." | rest], n) when n == 0  do {:ok, rest, :next} end
  def verify_next(["." | _], _)  do :fail end
  def verify_next(["#" | _], n) when n == 0  do :fail end
  def verify_next(seq = ["#" |_], n)  do {:ok, seq, n} end


  def parse(text) do
    list = String.split(text, "\r\n");
    Enum.map(list, fn line ->
      [pattern, map] = String.split(line, " ");
      pattern = Enum.filter(String.split(pattern, ""),  fn x -> String.length(x)> 0 end )
      map = Enum.map(String.split(map, ","), fn x -> String.to_integer(x); end )
      {pattern , map}
    end);
  end
end
