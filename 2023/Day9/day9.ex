defmodule Day9 do

  def taska do
    test = parse(File.read!("full.txt"))
    #test = parse(File.read!("sample.txt"))
    Enum.reduce(test, 0, fn row, acc ->
      list = expand_list(row, [], [row])
      {ahead, behind} = find_history(list, 0, 0)
      behind + acc
    end)
  end

  def taskb do
    test = parse(File.read!("full.txt"))
    #test = parse(File.read!("sample.txt"))
    Enum.reduce(test, 0, fn row, acc ->
      list = expand_list(row, [], [row])
      {ahead, behind} = find_history(list, 0, 0)
      ahead + acc
    end)
  end

  def find_history([], ahead, behind) do {ahead ,behind} end
  def find_history([h|t], ahead, behind) do
    find_history(t, collect_first(h, ahead), collect_last(h, behind))
  end

  def collect_first([h|_], value) do h - value end

  def collect_last([], value) do value end
  def collect_last([last], value) do last+value end
  def collect_last([_|rest], value) do
    collect_last(rest, value)
  end

  def expand_list([_last|[]], acc, all) do
    acc = Enum.reverse(acc)
    if(Enum.sum(acc) == 0) do
      [acc|all]
    else
      expand_list(acc,[],[acc|all])
    end
end

  def expand_list([first| rest= [second|_]], acc, all) do
    dif = second - first
    expand_list(rest, [dif | acc], all)
  end

  def parse(input) do
    String.split(input, "\r\n")
    |> Enum.map(fn line -> String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1) end)
  end
end
