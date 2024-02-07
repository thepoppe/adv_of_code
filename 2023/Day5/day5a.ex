defmodule Day5a do
  #adv ranges
  def main do
    {_, text} = File.read("real.txt")
    #IO.inspect(text)
    {seeds, maps} = parse_text(text)
    locations = Enum.map(seeds, fn seed -> transform(maps, seed) end)
    #IO.inspect(locations)
    {:ok, Enum.min(locations)}
  end

  def transform(maps, seed) do
    #IO.inspect(seed)
    Enum.reduce(maps, seed, fn map, sofar -> #IO.inspect(map);
      transf(map, sofar) end)
  end

  # [{:tr, from to length}, {:tr, from, to, length}]
  def transf(trs, num) do
    #IO.inspect(trs)
    case Enum.filter(trs, fn {:tr, _, from, length} ->(num >= from) and (num <= from+length-1) end) do
      [] -> num
      [{:tr, to, from, _}] -> (num - from + to)
    end
  end

  def parse_text(input) do
    [seeds|maps]= String.split(input,"\r\n\r\n")
    [_,res] = String.split(seeds,":")
    seeds = String.split(String.trim(res)," ")
    seeds = Enum.map(seeds, fn x -> String.to_integer(x) end)
    #IO.inspect(maps)
    maps = Enum.map(maps, fn map -> [_| res] = String.split(map,"\r\n");
      #IO.inspect(res);
      Enum.map(res, fn str -> [to, from, len] = String.split(str, " ")
        {:tr, String.to_integer(to), String.to_integer(from), String.to_integer(len)} end)
      end)
    {seeds, maps}
  end
end
