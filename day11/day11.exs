defmodule Day11 do
  @serial 7511
  @size 300

  def hundreds(lvl) when lvl < 100, do: 0

  def hundreds(lvl) do
    [_units, _tens, hundreds | _] = Integer.digits(lvl) |> Enum.reverse()
    hundreds
  end

  def power_level(x, y, serial) do
    rack_id = x + 10
    rack_id |> Kernel.*(y) |> Kernel.+(serial) |> Kernel.*(rack_id) |> hundreds() |> Kernel.-(5)
  end

  def grid(serial) do
    for x <- 1..@size, y <- 1..@size do
      {{x, y}, power_level(x, y, serial)}
    end
    |> Map.new()
  end

  def total_power(x, y, grid) do
    for x <- x..(x + 2), y <- y..(y + 2) do
      grid[{x, y}]
    end
    |> Enum.sum()
  end

  def find_largest(grid) do
    for x <- 1..(@size - 2), y <- 1..(@size - 2) do
      {{x, y}, total_power(x, y, grid)}
    end
    |> Enum.max_by(fn {_, power} -> power end)
  end

  def part1 do
    {{x, y}, power} = grid(@serial) |> find_largest()
    "#{x},#{y} (total power #{power})"
  end
end
