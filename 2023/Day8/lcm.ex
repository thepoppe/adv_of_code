defmodule Lcm do

  def main do
    {:ok, seq, ptrns, _,_} = Parser.parse_full
    start_keys = Enum.filter(Map.keys(ptrns), fn str -> String.slice(str, 2..2) == "A" end)
    results = find_all_counts(seq, start_keys, ptrns)
    find_lcm(results)
  end

  def find_lcm(resulst) do
    Enum.reduce(resulst, 1, fn res,acc -> lcm(res, acc)  end)
  end

  def lcm(num1, num2) do
    a = abs(num1*num2)
    gcd = Integer.gcd(num1,num2)
    div(a, gcd)
  end

  def find_all_counts(seq, start_keys, ptrns) do
    refs = Enum.map(start_keys, fn key ->
      ref = make_ref()
      Solver.start(key, seq,ptrns, self(), ref)
      ref
    end)
    Enum.map(refs, fn ref -> receive do {:ok, ^ref, res} -> res end end)
  end


end

defmodule Solver do
  def start(start, seq, map, ctrl, ref) do
    spawn(fn -> search(ref, seq, ctrl, map, start, seq, 0) end)
  end

    #Helper to iterate the sequence
    def search(ref, seq, ctrl, ptrns, key, [], count) do
      search(ref, seq, ctrl, ptrns, key,  seq, count)
    end
    def search(ref, _, ctrl, _, <<_,_,?Z>>, _, count) do send(ctrl, {:ok, ref, count}) end
    def search(ref, seq, ctrl, ptrns, key, [path|next], count) do
      {{:L, left}, {:R, right}} = Map.get(ptrns, key)
      case path do
        :L -> search(ref, seq, ctrl, ptrns, left, next, count+1)
        :R -> search(ref, seq, ctrl, ptrns, right, next, count+1)
      end
    end
end
