defmodule Day8a do

  def main do
    {:ok, seq, ptrns, {:start, start}, {:dest, dest}} = Parser.parse_full

    #from AAA to ZZZ not the first line to the last...
    search(seq, ptrns, "AAA", "ZZZ", seq, 0)
  end


  #Helper to iterate the sequence
  def search(seq, ptrns, key, dest, [], count) do
    search(seq, ptrns, key, dest, seq, count)
  end
  #stop if key == dest
  def search(_seq, _ptrns, dest, dest, _, count) do count end
  def search(seq, ptrns, key, dest, [path|next], count) do
    {{:L, left}, {:R, right}} = Map.get(ptrns, key)
    case path do
      :L -> search(seq, ptrns, left, dest, next, count+1)
      :R -> search(seq, ptrns, right, dest, next, count+1)
    end
  end
end
