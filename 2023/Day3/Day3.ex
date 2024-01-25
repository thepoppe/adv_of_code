defmodule Day3 do

  def main do
    input = File.read!("sample.txt") |> String.split("\n")
    {:parsed, grid} = parse_input(input)
    IO.inspect(grid)

    Enum.map(&iterate_row/1)

    :ok
  end

  def parse_input(text) do
    input = Enum.with_index(text)
    input = Enum.map(input, fn list ->
      {text, row} = list
      text = String.replace(text, ~r/\r$/, "")
        |> String.split("", trim: true)
        |> Enum.with_index()
      {text, row}
    end)
    {:parsed, input}
  end


  def iterate_row(org) do

  end

  def find_number([]) do [] end

  def iterate_row([{n, i}| t]) do
    if(Regex.match?(~r/\d/, n)) do
      num = n <> find_number(t)
      {num, i}
    else find_number(t)
    end
  end


end
