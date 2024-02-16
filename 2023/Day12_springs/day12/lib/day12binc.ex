defmodule Day12binc do
  def main() do
    range= 0..100
    {_, text} = File.read("full.txt");
    file = "res.dat"
    Enum.map(range, fn mul -> solve(mul, text, file) end)
    :done
  end

  def solve(mul, input, file) do
    parsed = parse(input, mul);
    t0 = System.monotonic_time(:millisecond)
    arrangements = Enum.map(parsed, fn row -> check_row(row, Mem3.new()) end)
    sum = Enum.reduce(arrangements, 0, fn {arr,_}, acc -> arr+acc end)
    t1 = System.monotonic_time(:millisecond)
    File.write(file, "#{mul}, #{t1-t0}\n", [:append])
    {:ok, sum};
  end

  def check_row({[], []},  mem) do {1, mem} end
  def check_row({[], _},  mem) do {0, mem} end
  def check_row({["." | rest], []},  mem) do check_mem({rest, []}, mem) end
  def check_row({["." | rest], map},  mem) do check_mem({rest, map},  mem) end
  def check_row({["#" | _], []},  mem) do {0, mem} end
  def check_row({["#" | rest] , [h|t]},  mem) do
    case verify_next(rest, h-1) do
      :fail -> {0, mem}
      {:ok, seq, :next} -> check_mem({seq, t},  mem);
      {:ok, seq, num} -> check_mem({seq, [num|t]},  mem);
    end
  end


  def check_row({["?" | rest], map}, mem) do
    {res, upd} = check_mem({["#" | rest], map}, mem);
    {alt, mem} = check_mem({["." | rest], map}, upd);
    {res+alt, mem}
  end
  def check_row(_, mem) do {0, mem} end


  def check_mem(seq,  mem) do
    case Mem3.lookup(mem, seq) do
      nil ->
        {res, updated} = check_row(seq,mem);
        {res, Mem3.store(updated, seq, res)};
      {:found, val} ->
        {val, mem};
    end
  end


  def verify_next([], num) when num > 0 do :fail end
  def verify_next([], _)  do {:ok, [], :next} end
  def verify_next(["?" | rest], n) when n == 0  do {:ok, rest, :next} end
  def verify_next(["?" | rest], n)  do {:ok, ["#" | rest], n} end
  def verify_next(["." | rest], n) when n == 0  do {:ok, rest, :next} end
  def verify_next(["." | _], _)  do :fail end
  def verify_next(["#" | _], n) when n == 0  do :fail end
  def verify_next(seq = ["#" |_], n)  do {:ok, seq, n} end


  def parse(text, mul) do
    list = String.split(text, "\r\n");
    Enum.map(list, fn line ->
      [pattern, map] = String.split(line, " ");
      pattern = Enum.filter(String.split(pattern, ""),  fn x -> String.length(x)> 0 end )
      map = Enum.map(String.split(map, ","), fn x -> String.to_integer(x); end )
      list = extend(pattern, map , mul , [], [])
    end);
  end
  def extend(pat, map, 0, pat_acc, map_acc) do
    {List.flatten([pat_acc | pat]), List.flatten([map_acc | map])}
  end
  def extend(pat, map, iterator, pat_acc, map_acc) do
    extend(pat, map, iterator - 1, [pat | [["?"] | pat_acc]] , [map | map_acc])
  end
end


defmodule Mem3 do
  def new do Map.new() end

  def store(mem, key, val) do
    Map.put(mem, key, val)
  end

  def lookup(mem, key) do
    case Map.fetch(mem, key) do
      :error -> :nil
      {:ok, val} -> {:found, val}
    end
  end
end
