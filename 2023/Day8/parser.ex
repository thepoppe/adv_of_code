defmodule Parser do

  def parse_ex do
    parse("ex.txt")
  end
  def parse_ex2 do
    parse("ex2.txt")
  end
  def parse_ex3 do
    parse("ex3.txt")
  end
  def parse_full do
    parse("full.txt")
  end
  def parse(file) do
    [sequence | [patterns|[]]] =
      File.read!(file)
      |> String.split("\r\n\r\n")
    sequence = Enum.map(String.split(sequence, "", trim: true), fn letter -> String.to_atom(letter) end)
    start = String.slice(patterns, 0..2)
    {pattern_map, destination} = String.split(patterns, "\r\n")
      |> Enum.reduce({Map.new(), 0},fn ptr, {map, _} ->
        [key|[direction|[]]] = String.split(ptr, " = ", trim: true)
        [left|[right]] = String.split(String.slice(direction, 1..8), ", ")
        map = Map.put(map, key, {{:L, left}, {:R, right} })
        {map, key}
      end)

      #So we are looking fo ZZZ not the last line... and start is also AAA. Complicating things too
    {:ok, sequence,  pattern_map, {:start, start}, {:dest, destination}}
  end
end
