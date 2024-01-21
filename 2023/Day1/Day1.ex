defmodule Day1 do

  #Task 1 read one line, find first and last num , sum the result
  #Task 2 read "one" as 1 etc
  def read_file() do
    file_content = ("real_text.txt") |> File.read!() |> String.split("\n", trim: true)
    converted_content = Enum.map(file_content, &convert_word_to_digit/1)

    IO.puts("File Content:")
    Enum.each(converted_content, &IO.puts/1)
    res = Enum.map(converted_content, &extract_nums/1)
    sum = Enum.sum(res)
    {:res, sum}
  end



  def extract_nums(text) do
    digits = Regex.scan(~r/\d/, text)
    case digits do
      [] ->  {:error, "no digit"}
      [first | rest] when rest == [] ->
        first = List.first(first)
        String.to_integer(first<>first)
      [first | rest] ->
        first = (List.first(first))
        last = List.last(List.flatten(rest))
        String.to_integer(first<>last)
    end
  end


  #not so efficient but probbably works
  #edit eightwothree needs to be 8wo3 not eigh23 as this code produces.
  #Ugly solution but lets just add a duplicate with the num in the middle
  def convert_word_to_digit(text) do
    text = Regex.replace(~r/one/, text, "one1one")
    text = Regex.replace(~r/two/, text, "two2two")
    text = Regex.replace(~r/three/, text, "three3three")
    text = Regex.replace(~r/four/, text, "four4four")
    text = Regex.replace(~r/five/, text, "five5five")
    text = Regex.replace(~r/six/, text, "six6six")
    text = Regex.replace(~r/seven/, text, "seven7seven")
    text = Regex.replace(~r/eight/, text, "eight8eight")
    Regex.replace(~r/nine/, text, "nine9nine")
  end




end
