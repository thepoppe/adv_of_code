defmodule Day4a do

  def parse() do
    {_, text} = File.read("real.txt")
    text = String.split(text, "\n")
    text = Enum.map(text, &parse_row/1)
    res = Enum.map(text, &evaluate_row/1)
    {sum, _} = evaluate_res(res)
    {:ok, sum}
  end

  def evaluate_res(res) do
    res = Enum.filter(res, fn list -> length(list)!= 0 end)
    sum = Enum.reduce(res, 0, fn card, acc -> acc + Integer.pow(2, length(card)-1) end)
    {sum, res}
  end
  def evaluate_row(row) do
    {nums , matches} = row;
    Enum.filter(nums, fn num -> Enum.member?(matches, num) end)
  end

  def parse_row(string) do
    [_ | [first |[second|[]]]] = String.split(string, [":","|"])
    first = first
    |> String.trim()
    |> String.split(" ")
    |> Enum.filter(fn x -> String.length(x)> 0 end)
    |> Enum.map(&String.to_integer/1)
    second = second
    |> String.trim()
    |> String.split(" ")
    |> Enum.filter(fn x -> String.length(x)> 0 end)
    |> Enum.map(fn x -> String.to_integer(x) end)
    {first, second}
  end


end
