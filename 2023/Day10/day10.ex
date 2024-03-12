defmodule Day10 do


  #https://adventofcode.com/2023/day/10
  def convert(c) do
    case c do
      "|" -> :vertical
      "-" -> :horizonal
      "L" -> :N_E
      "J" -> :N_W
      "7" -> :S_W
      "F" -> :S_E
      "." -> :ground
      "S" -> :START
    end
  end

  def main do
    {map, start, w,h} = parse(File.read!("inputs/test1.txt"))
    #IO.inspect(map)
    #IO.inspect(start)
    #IO.inspect(w)
    #IO.inspect(h)
    find_adjacent_paths(map, start, w, h)
  end

  def find_adjacent_paths(map, start, w, h) do
    cordinates = find_nearby_cordinates(start, [], w, h)
    IO.inspect(start)
    IO.inspect(cordinates)
    {first,second} = find_starts(start, coordinates)
    step_path(start, first, second)
  end


  def find_starts(start, potential) do
    #Enum.map(start)
  end

  def step_path(start,first, second) do

  end

  def find_nearby_cordinates({row_s, col_s}, acc, w, h) do
    acc = if(row_s-1 >= 0) do
      acc = [{row_s-1, col_s}|acc]
      acc = if col_s-1 >= 0 do
        [{row_s-1, col_s-1}|acc]
      else acc
      end
      acc = if col_s+1 < h do
        [{row_s-1, col_s+1}|acc]
      else acc
      end
    else acc
    end

    acc = if(row_s+1 < w) do
      acc = [{row_s+1, col_s}|acc]
      acc = if col_s-1 >= 0 do
        [{row_s+1, col_s-1}|acc]
      else acc
      end
      acc = if col_s+1 < h do
        [{row_s+1, col_s+1}|acc]
      else acc
      end
    else acc
    end

    acc = if(col_s-1 >= 0) do
      [{row_s, col_s-1}|acc]
    else acc
    end

    acc = if col_s+1 < h do
      [{row_s, col_s+1}|acc]
    else acc
    end

    acc

  end

  #returns a map of the coordinates with the turns and the starting coordinate
  def parse(input) do
    rows = String.split(input, "\r\n")
    {map, h, start, w} =
      Enum.reduce(rows, {Map.new(), 0, {0,0}, 0},
        fn line, {map, row, start, w} ->
          {map, row, _col, start} =
            Enum.reduce(String.split(line,"" ,trim: true), {map, row, 0, start},
            fn char, {map, row, col, start} ->
              case convert(char) do
                :START -> {Map.put(map, {row, col}, :start), row, col+1, {row,col}}
                conversion -> {Map.put(map, {row, col}, conversion), row, col+1, start}
              end
            end)
          {map, row+1, start, w+1}
        end)
    {map, start, w, h}
  end

end
