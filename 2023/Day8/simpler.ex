defmodule Simpler do

  def main do
    {:ok, seq, ptrns, _,_} = Parser.parse_full
    start_keys = Enum.filter(Map.keys(ptrns), fn str -> String.slice(str, 2..2) == "A" end)
    end_keys = Enum.filter(Map.keys(ptrns), fn str -> String.slice(str, 2..2) == "Z" end)
    find_all(seq, start_keys,end_keys,seq,ptrns,0)
  end

  def find_all(seq, start_keys, end_keys, [], ptrns, count) do
    find_all(seq, start_keys, end_keys, seq, ptrns, count)
  end
  def find_all(seq, start_keys, end_keys, [path|next_path], ptrns, count) do
    case compare_lists(start_keys, end_keys) do
      true -> {:done, count}
      false ->
        if(rem(count, 1000000000000) == 0) do
          #IO.puts(count)
        end
        next_keys = Enum.map(start_keys, fn key -> search(key,path, ptrns) end  )
        find_all(seq, next_keys, end_keys, next_path, ptrns, count + 1)
    end
  end

  def compare_lists(entries, targets) do
    Enum.reduce(entries, true, fn entry, acc ->
      if Enum.member?(targets, entry) do
        acc
      else
        false
      end
    end)
  end

  def search(key, path, map) do
    {{:L, left}, {:R, right}} = Map.get(map, key)
    case path do
      :L -> left
      :R -> right
    end
  end

end
