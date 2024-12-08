defmodule B do


  def parse_input (file) do
    file
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn row ->
      row
      |>String.graphemes()
      |> Enum.map(fn char -> String.to_atom(char) end)
    end)
  end



  def find_diagonal(count, []), do: count
  def find_diagonal(count, [_|[]]), do: count
  def find_diagonal(count, [_,_|[]]), do: count

  def find_diagonal(count, [a1,b,c1|_]) do
    #IO.puts(" ___ ")


    [_,_|a2] = a1
    [_|rb] = b
    [_,_|c2] = c1

    find_diagonal_cross(count, a1,rb,c2,a2,rb,c1)
  end

  def find_diagonal_cross(count, _,_,[],[],_,_), do: count
  def find_diagonal_cross(count, [:M|a1], [:A|b], [:S|c2], [:M|a2], [:A|_b], [:S|c1]) do
    find_diagonal_cross(count + 1, a1,b,c2,a2,b,c1)
  end
  def find_diagonal_cross(count, [:M|a1], [:A|b], [:S|c2], [:S|a2], [:A|_b], [:M|c1]) do
    find_diagonal_cross(count + 1, a1,b,c2,a2,b,c1)
  end
  def find_diagonal_cross(count, [:S|a1], [:A|b], [:M|c2], [:S|a2], [:A|_b], [:M|c1]) do
    find_diagonal_cross(count + 1, a1,b,c2,a2,b,c1)
  end
  def find_diagonal_cross(count, [:S|a1], [:A|b], [:M|c2], [:M|a2], [:A|_b], [:S|c1]) do
    find_diagonal_cross(count + 1, a1,b,c2,a2,b,c1)
  end
  def find_diagonal_cross(count, [_|a1], [_|b], [_|c2], [_|a2], [_|_b], [_|c1]) do
    find_diagonal_cross(count, a1,b,c2,a2,b,c1)
  end




  def search_list(count, []), do: count
  def search_list(count, list = [_h|t]) do
    count = find_diagonal(count,list)
    search_list(count, t)
  end

  def main do
    text = parse_input("full.txt")

    count = search_list(0, text)
    IO.inspect(count)
    :ok
  end

end
