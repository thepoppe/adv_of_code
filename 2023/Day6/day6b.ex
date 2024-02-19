defmodule Day6b do

  def main do
    parse(File.read!("real.txt"))
    |> find_longer()
    |> length()
  end

  def find_longer({time, record}) do
    range = 1..time
    Enum.map(range, fn speed -> speed * (time-speed) end )
    |> Enum.filter(fn length -> length > record end)
  end



  def parse(text) do
    text
      |> String.trim()
      |> String.split("\r\n")
      |> Enum.map(fn x ->
        [_|tail] = String.split(x, ":");
        Enum.filter(List.flatten(Enum.map(tail, fn x -> String.split(x, " ") end)),
         fn x -> String.length(x) >  0 end)
         end)
      |> Enum.map(fn list -> String.to_integer(Enum.reduce(list, "", fn x, acc ->  acc <> x end)) end)
      |> List.to_tuple()

  end
end
