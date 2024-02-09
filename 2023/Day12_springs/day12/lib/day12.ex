defmodule Day12 do

  # https://adventofcode.com/2023/day/12
  def main do
    {_, text} = File.read("ex1.txt");
    parsed = parse(text);
    Enum.map(parsed, &check_row/1);
    :ok;
  end

  def check_row(row) do
    [ptrn | map] = row;
    map = List.flatten(map);
    IO.inspect(ptrn)
    IO.inspect(map)
  end

  def parse(text) do
    list = String.split(text, "\r\n");
    Enum.map(list, fn line ->
      [pattern, map] = String.split(line, " ");
      pattern = Enum.filter(String.split(pattern, ""),  fn x -> String.length(x)> 0 end )
      map = Enum.map(String.split(map, ","), fn x -> String.to_integer(x); end )
      [pattern | map]
    end);
  end
end
