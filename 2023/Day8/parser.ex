defmodule Parser do

  def parse_ex do
    parse("ex.txt")
  end
  def parse_ex2 do
    parse("ex2.txt")
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
    {{:seq, sequence}, {:map, pattern_map}, {:start, String.to_atom(start)}, {:dest, String.to_atom(destination)}}
  end
end

#
#{patterns, start, destination} = String.split(patterns, "\r\n")
#|> Enum.reduce({Map.new(),:start, :dest},fn ptr, {map, start, _} ->
#  [key|[direction|[]]] = String.split(ptr, " = ", trim: true)
#  [left|[right]] = String.split(String.slice(direction, 1..8), ", ")
#  map = Map.put(map, String.to_atom(key), {{:L, String.to_atom(left)}, {:R, String.to_atom(right)} })
#  if(start == :start) do
#    {map, key, key}
#  else
#    {map, start, key}
#  end
#end)
