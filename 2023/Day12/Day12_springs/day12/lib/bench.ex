defmodule Bench do
  def run() do
    range = 1..6
    file = "mem.dat"
    res = Enum.map(range, fn x -> test(x, file) end)
  end

  def test(x, file) do
    IO.inspect(x)
    range = 0..x
    seq = "?"
    mapping = "1"
    seq = Enum.map(range, fn x -> List.to_string(concat(seq, x)) end)
    map = Enum.map(range, fn x -> List.to_string(concat(:map, mapping, x)) end)
    comb = Enum.zip(seq, map)
       |> Enum.with_index()
       |> Enum.map(fn
            { {x, y}, index } when index == length(seq) - 1 -> "#{x} #{y}"
            { {x, y}, _ } -> "#{x} #{y}\r\n"
          end)
    File.write!("ex.txt", List.to_string(comb))

    t1 = System.monotonic_time(:millisecond)
    Day12bacc.main
    t2 = System.monotonic_time(:millisecond)
    t = t2 - t1
    File.write(file, "#{x}, #{t}\n", [:append])
  end

  def concat(text, iteration) do
    if(iteration == 0) do
      [text]
    else
      [text]++concat(text, iteration-1)
    end
  end
  def concat(:map, text, 0) do [text] end
  def concat(:map, text, iteration) do [text <> ","] ++ concat(:map, text, iteration-1) end
end
