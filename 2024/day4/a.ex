defmodule A do


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

  def find_horizontal(count, []), do: count
  def find_horizontal(count, [:X, :M, :A, :S, :A, :M, :X | rest]) do
    find_horizontal(count + 2, rest)
  end
  def find_horizontal(count, [:S, :A, :M, :X, :M, :A, :S | rest]) do
    find_horizontal(count + 2, rest)
  end
  def find_horizontal(count, [:X, :M, :A, :S | rest]) do
    find_horizontal(count + 1, rest)
  end
  def find_horizontal(count, [:S, :A, :M, :X | rest]) do
    find_horizontal(count + 1, rest)
  end
  def find_horizontal(count, [_first | rest]) do
    find_horizontal(count, rest)
  end


  def find_vertical(count, []), do: count
  def find_vertical(count, [_|[]]), do: count
  def find_vertical(count, [_,_|[]]), do: count
  def find_vertical(count, [_,_,_|[]]), do: count
  def find_vertical(count, list) do
    [a,b,c,d|_] = list
    find_vertical(count, a,b,c,d)
  end

  def find_vertical(count, [],[],[], []), do: count
  def find_vertical(count, [:X|a],[:M|b],[:A|c], [:S|d]) do
    find_vertical(count + 1, a,b,c,d)
  end
  def find_vertical(count, [:S|a],[:A|b],[:M|c], [:X|d]) do
    find_vertical(count + 1, a,b,c,d)
  end
  def find_vertical(count, [_|a],[_|b],[_|c], [_|d]) do
    find_vertical(count, a,b,c,d)
  end

  def find_diagonal(count, []), do: count
  def find_diagonal(count, [_|[]]), do: count
  def find_diagonal(count, [_,_|[]]), do: count
  def find_diagonal(count, [_,_,_|[]]), do: count

  def find_diagonal(count, [a,b,c,d|_]) do
    #IO.puts(" ___ ")
    #IO.inspect(a)
    #IO.inspect(b)
    #IO.inspect(c)
    #IO.inspect(d)

    [_,_,_ |ra] = a
    [_,_|rb] = b
    [_|rc] = c
    [_| lb ] = b
    [_,_|l_c] = c
    [_,_,_|ld] = d

    count = find_diagonal_left(count, ra,rb,rc,d)
    find_diagonal_right(count,a,lb,l_c,ld)
  end

  def find_diagonal_left(count, [],_, _, _ ), do: count
  def find_diagonal_left(count, [:X|r1], [:M|r2], [:A|r3], [:S|r4]) do
    find_diagonal_left(count + 1, r1,r2,r3,r4)
  end
  def find_diagonal_left(count, [:S|r1], [:A|r2], [:M|r3], [:X|r4] ) do
    find_diagonal_left(count + 1, r1,r2,r3,r4)
  end
  def find_diagonal_left(count, [_|r1], [_|r2], [_|r3], [_|r4] ) do
    find_diagonal_left(count, r1,r2,r3,r4)
  end

  def find_diagonal_right(count, _,_, _, [] ), do: count
  def find_diagonal_right(count, [:X|r1], [:M|r2], [:A|r3], [:S|r4] ) do
    find_diagonal_right(count + 1, r1,r2,r3,r4)
  end
  def find_diagonal_right(count, [:S|r1], [:A|r2], [:M|r3], [:X|r4] ) do
    find_diagonal_right(count + 1, r1,r2,r3,r4)
  end
  def find_diagonal_right(count, [_|r1], [_|r2], [_|r3], [_|r4]) do
    find_diagonal_right(count, r1,r2,r3,r4)
  end



  def search_list(count, []), do: count
  def search_list(count, list = [h|t]) do
    count = find_horizontal(count, h)
    count = find_vertical(count, list)
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
