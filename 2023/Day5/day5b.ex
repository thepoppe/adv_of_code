defmodule Day5b do

  def main do
    {_, text} = File.read("real.txt")
    {seeds, maps} = parse_text(text)
    locations = Enum.map(seeds, fn seed -> transform(maps, seed) end)
    min = Enum.reduce(locations, :inf,
      fn seed_locations, acc -> Enum.reduce(seed_locations, acc,
        fn {x,_}, acc ->
          if x < acc do
            x else acc end
          end)
        end)
    {:ok, min}
  end


  def transform(maps, seed_range) do
    Enum.reduce(maps, [seed_range],
      fn map, seed_ranges ->Enum.reduce(seed_ranges, [],
        fn seed_range, acc -> check_ranges(map, seed_range, acc ) end)
      end)
  end


  def check_ranges([], seed, acc) do [seed | acc] end
  def check_ranges(mapping, seed_range, acc) do
    [{_, to, map_start, len}| next_map] = mapping
    {seed_start, range} = seed_range
    seed_stop = (seed_start + range - 1);
    map_stop = (map_start + len - 1);
    case seed_start <= map_stop do
      false -> #after
        check_ranges(next_map, seed_range, acc)
      true ->
        case seed_start >= map_start  do
        true ->
          # we have values atleast until map_stop
          case  seed_stop  <= map_stop do
            true ->
              #done all in range
              [ {seed_start + to - map_start, range} | acc]
            false ->
              #inrange | after
              check_ranges(next_map,
              {map_start + len, range - (map_stop - seed_start)},
              [{seed_start - map_start + to, map_stop - seed_start} | acc] )
            end

        false -> #the end of the ranges may still be ok
          case seed_stop >= map_start do
            false -> #before
              check_ranges(next_map, seed_range, acc)
            true ->
              case seed_stop <= map_stop do
                true->
                  #meaning a part of the range is valid and neeeds mapping
                  # before | in range
                  before = {seed_start, map_start - seed_start}
                  mapped = {to, range - (map_start - seed_start)}
                  check_ranges(next_map, before, [mapped | acc])
                false ->
                  # before | in range | behind
                  before =  {seed_start, map_start - seed_start}
                  in_range = {to, len};
                  after_r= {map_stop, range - (map_start - seed_start) - len};
                  check_ranges(next_map, before, [in_range | acc]) ++ check_ranges(next_map, after_r, []);
              end
          end
      end
  end

end

  def parse_text(input) do
    [seeds|maps]= String.split(input,"\r\n\r\n")
    [_,res] = String.split(seeds,":")
    seeds = res
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)

    maps = Enum.map(maps, fn map ->
      [_| res] = String.split(map,"\r\n");
      Enum.map(res,
        fn str ->
          [to, from, len] = String.split(str, " ")
          {:tr, String.to_integer(to), String.to_integer(from), String.to_integer(len)}
        end)
      end)
    {seeds, maps}
  end
end
