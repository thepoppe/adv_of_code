defmodule Day12 do

  # https://adventofcode.com/2023/day/12
  def main do
    {_, text} = File.read("all_known.txt");
    parsed = parse(text);
     sum = Enum.reduce(parsed, 0 , fn row, acc -> check_row(row, acc) end);
    {:ok, sum};
  end

  # base cases
  def check_row({[], h}, acc) when h == [0] or h == [] do acc+1 end
  def check_row({["."|rest], []}, acc) do check_row({rest, []}, acc) end
  def check_row({_, []}, acc) do acc end
  def check_row({[], _}, acc) do acc end

  #functional
  def check_row({["." | rest] , [h|t]}, acc) when h == 0 do
  check_row({rest, t}, acc) end
  def check_row({["." | rest] , map}, acc) do
   check_row({rest, map}, acc) end
  #broken found
  def check_row({["#" | _] , [h|_]}, acc) when h==0 do
  acc end
  def check_row({["#" | rest] , [h|t]}, acc) do
  check_row({rest, [h-1|t]}, acc) end
  #Unknown
  def check_row({["?"|rest], map}, acc) do
    #try a broken
    acc = check_row({["#"| rest], map}, acc)
    #try a working
    check_row({["."| rest], map}, acc)
  end




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
