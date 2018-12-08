defmodule Day5 do
  def upcase?(char), do: char in ?A..?Z
  def same_letter?(c1, c2), do: String.upcase(<<c1::utf8>>) === String.upcase(<<c2::utf8>>)
  def case_differs?(c1, c2), do: upcase?(c1) !== upcase?(c2)
  def react?(c1, c2), do: same_letter?(c1, c2) && case_differs?(c1, c2)

  # note: reverses the list - for part 1 doesn't seem to matter
  def react(chars) do
    Enum.reduce(chars, [], fn
      curr, [] -> [curr]
      curr, [prev | old] -> if react?(curr, prev), do: old, else: [curr, prev | old]
    end)
  end

  def part1 do
    File.read!("input")
    |> String.trim()
    |> String.to_charlist()
    |> react()
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    polymer =
      File.read!("input")
      |> String.trim()
      |> String.to_charlist()

    lengths =
      for lower <- ?a..?z, upper = lower - 32 do
        Enum.reject(polymer, &(&1 in [lower, upper]))
        |> react()
        |> Enum.count()
      end

    Enum.min(lengths) |> IO.puts()
  end
end

Day5.part1()
Day5.part2()
