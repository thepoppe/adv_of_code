defmodule Day6a do

  def main do
    parse(File.read!("real.txt"))
    |> Enum.map( &find_longer/1)
    |> Enum.reduce(1, fn list, acc -> length(list) * acc end)
  end

  def find_longer({time, record}) do
    range = 1..time
    Enum.map(range, fn speed -> speed * ( time-speed) end )
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
      |> Enum.map(fn list -> Enum.map(list, fn x -> String.to_integer(x) end) end)
      |> Enum.zip()
  end
end
