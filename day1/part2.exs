defmodule Part2 do
  def mark_seen(change, {prev_freq, seen}) do
    freq = prev_freq + change

    marked_freq = {freq, MapSet.member?(seen, freq)}
    acc = {freq, MapSet.put(seen, freq)}

    {[marked_freq], acc}
  end

  def run do
    File.stream!("input")
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Stream.transform({0, MapSet.new([0])}, &mark_seen/2)
    |> Enum.find(fn {_freq, seen} -> seen end)
    |> elem(0)
  end
end
