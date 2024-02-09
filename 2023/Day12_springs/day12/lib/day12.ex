defmodule Day12 do
  def main do
    {_, text} = File.read("ex1.txt");
    parsed = parse(text);
    Enum.map(parsed, &check_row/1)
    :ok;
  end



  def check_row(row) do
    [ptrn | map] = row
    map = List.flatten(map)
    IO.inspect(ptrn)
    IO.inspect(map)
  end

  def parse(text) do
    list = String.split(text, "\r\n")
    Enum.map(list, fn line ->
      [pattern, map] = String.split(line, " ");
      [pattern | [Enum.map(String.split(map, ","), fn x -> String.to_integer(x) end)]]
    end)
  end
end
