defmodule Day5b do

  def main do
    {_, text} = File.read("real.txt")
    #IO.inspect(text)
    {seeds, maps} = parse_text(text)
    locations = Enum.map(seeds, fn seed -> transform(maps, seed) end)
    min = Enum.reduce(locations, :inf,
      fn seed_locations, acc -> Enum.reduce(seed_locations, acc,
        fn {x,_}, acc ->
          if x < acc do
            x else acc end
          end)
        end)
    #IO.inspect(locations)
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
    #IO.inspect(seed_range)
    [{_, to, map_start, len}| next_map] = mapping
    {seed_start, range} = seed_range
    seed_stop = (seed_start + range - 1);
    map_stop = (map_start + len - 1);
    #IO.inspect(seed_start)
    case seed_start <= map_stop do
      false -> check_ranges(next_map, seed_range, acc)
      true ->
        case seed_start >= map_start  do # we have vbalues atleast until map_start + len -1
        true ->
          case  seed_stop  <= map_stop do
            true ->
              #done?
              #IO.inspect(acc)
              #IO.inspect(seed_start )
              #IO.inspect(to)
              #IO.inspect(map_start)
              [ {seed_start + to - map_start, range} | acc]
            false ->
              #meaning some numbers match some dont
              #seed_start to map_start + len | map_start + len to range -len
              check_ranges(next_map,
              {map_start + len, range - (map_stop - seed_start)},
              [{seed_start - map_start + to, range - (range - (map_stop - seed_start))} | acc] )
            end

        false -> #the end of the ranges may still be ok

          case seed_stop >= map_start do
            false -> check_ranges(next_map, seed_range, acc)
            true ->
              case seed_stop <= map_stop do
                true->
                  #meaning a part of the range is valid and neeeds mapping
                  before = {seed_start, map_start - seed_start}
                  mapped = {to, range - (map_start - seed_start)}
                  check_ranges(next_map, before, [mapped | acc])
                false ->
                  # before | in range | behind
                  # simple we choose one and let the recursion handles the next NO DOESNT WORK,
                  # add the correct to one and leave the other acc empty?
                  before =  {seed_start, map_start - seed_start}
                  in_range = {to, len};
                  after_r= {map_stop, range - (map_start - seed_start) - len}; # correct?
                  check_ranges(next_map, before, [in_range | acc]) ++ check_ranges(next_map, after_r, []);
              end
          end
      end
  end

end

  def parse_text(input) do
    [seeds|maps]= String.split(input,"\r\n\r\n")
    [_,res] = String.split(seeds,":")
    seeds = String.split(String.trim(res)," ")
    seeds = Enum.map(seeds, fn x -> String.to_integer(x) end)
    seeds = Enum.chunk_every(seeds, 2)
    seeds = Enum.map(seeds, fn x -> List.to_tuple(x)end)
    #IO.inspect(seeds)
    maps = Enum.map(maps, fn map -> [_| res] = String.split(map,"\r\n");
      #IO.inspect(res);
      Enum.map(res, fn str -> [to, from, len] = String.split(str, " ")
        {:tr, String.to_integer(to), String.to_integer(from), String.to_integer(len)} end)
      end)
    {seeds, maps}
  end
end
