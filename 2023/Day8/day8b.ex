defmodule Day8b do

  # similar but we cant use atoms anymore probably a good place to use binaries and pattern amtch for the last char
  # Instea will use two processes that works simulataneously and sends a confirmation  to acontroller.

  def main do
    {:ok, seq, ptrns,_, _} = Parser.parse_full
    pid = Master.start(seq, ptrns)
    :timer.sleep(1000)
    send(pid, :start)
    :timer.sleep(20000)
    send(pid, :done)
  end


end

defmodule Master do
  def start(seq, ptrns) do
    IO.puts("Starting the master")
    spawn_link( fn ->
      ending_A = Enum.filter(Map.keys(ptrns), fn str -> String.slice(str, 2..2) == "A" end)
      pids = Enum.map(ending_A, fn start -> Worker.start(start, ptrns, self()) end)
      IO.puts("Ready")
      ready(seq, pids)
    end)
  end
  def ready(seq, pids)do
    receive do
      :start ->
        IO.puts("Start Working")
        call_workers(seq, pids, seq, 1)
      :done -> Process.exit(self(), :kill)
    end
  end

  def call_workers(seq, pids, [], count) do call_workers(seq, pids, seq, count) end
  def call_workers(seq, pids, [path | next], count) do
    if(rem(count, 100000) == 0) do
      IO.puts(count)
    end

    refs = Enum.map(pids, fn pid ->
      #IO.puts("Sending task to worker: #{(inspect(pid))}")
      ref = make_ref()
      send(pid, {:go, path, ref})
      ref
    end)
    #IO.puts("References #{inspect(refs)}")
    last_chars = collect_results(refs)
    number_of_Z =  Enum.filter(last_chars, fn char -> char =="Z" end)
    #IO.puts("Last chars: #{last_chars}")

    if(length(last_chars) == length(number_of_Z)) do
      Enum.each(pids, fn pid -> send(pid, :done) end)
      IO.puts("Result is #{count}")
      Process.exit(self(), :kill)
    else
      call_workers(seq, pids, next, count + 1)
    end
  end

  def collect_results(refs) do
    #IO.puts("Collect Results")
    Enum.reduce(refs, [], fn ref, acc ->
      #IO.puts("Wait for ref: #{inspect(ref)}")
      receive do
        {:ok, value, ^ref} ->
          [String.slice(value, 2..2 )| acc]
        :done -> Process.exit(self(), :kill)
      end
    end)
  end

end

defmodule Worker do
  def start(start, map, master) do
    IO.puts("Starting a worker")
    spawn_link(fn ->  wait_for_task(start, map, master) end)
  end

  def wait_for_task(key, map, master) do
    #IO.inspect("#{inspect(self())} is waiting")
    receive do
      {:go, path, ref} ->
        new_key = search(key, map, path)
        send(master, {:ok, new_key, ref})
        wait_for_task(new_key, map, master)
    end
  end


  def search(key, ptrns, path) do
    {{:L, left}, {:R, right}} = Map.get(ptrns, key)
    case path do
      :L ->  left
      :R ->  right
    end
  end
end
