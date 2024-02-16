defmodule Day12bacc do
  def main do
    {_, text} = File.read("ex.txt");
    parsed = parse(text);
    extended = Enum.map(parsed, fn {seq, map} ->
      {seq ++ ["?"] ++ seq ++ ["?"] ++ seq ++ ["?"] ++ seq ++ ["?"] ++ seq, map ++ map ++ map ++ map ++ map} end);
    sum = Enum.map(extended, fn row -> check_row(row, 0, Mem2.new()); end)
    res = Enum.map(sum, fn {x,_} ->  x end)
    sum = Enum.reduce(res, 0 , fn x, acc -> x + acc end)
    {:ok, sum};
  end

  def check_row({[], []}, acc, mem) do {acc + 1, mem} end
  def check_row({[], _}, acc, mem) do {acc, mem} end
  def check_row({["." | rest], []}, acc, mem) do check_mem({rest, []}, acc, mem) end
  def check_row({["." | rest], map}, acc, mem) do check_mem({rest, map}, acc, mem) end
  def check_row({["#" | _], []}, acc, mem) do {acc, mem} end
  def check_row({["#" | rest] , [h|t]}, acc, mem) do
    case verify_next(rest, h-1) do
      :fail -> {acc, mem}
      {:ok, seq, :next} -> check_mem({seq, t}, acc, mem);
      {:ok, seq, num} -> check_mem({seq, [num|t]}, acc, mem);
    end
  end
  def check_row({["?" | rest], map},acc, mem) do
    {res, upd} = check_mem({["#" | rest], map}, acc, mem);
    {alt, mem} = check_mem({["." | rest], map}, acc, upd);
    {res+alt, mem}
  end
  def check_row(_, acc, mem) do {acc, mem} end

  def check_mem(seq, acc, mem) do
    case Mem2.lookup(mem, seq) do
      nil ->
        {res, updated} = check_row(seq,acc,mem);
        {res, Mem2.store(updated, seq, res)};
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

  def parse(text) do
    list = String.split(text, "\r\n");
    Enum.map(list, fn line ->
      [pattern, map] = String.split(line, " ");
      pattern = Enum.filter(String.split(pattern, ""),  fn x -> String.length(x)> 0 end )
      map = Enum.map(String.split(map, ","), fn x -> String.to_integer(x); end )
      {pattern , map}
    end);
  end
end


defmodule Mem2 do
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
