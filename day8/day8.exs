defmodule Day8 do
  import Kernel, except: [node: 1]

  def list, do: File.read!("input") |> String.split() |> Enum.map(&String.to_integer/1)

  def node([child_count, data_count | rest]) do
    {children, rest} = children(child_count, [], rest)
    {data, rest} = Enum.split(rest, data_count)
    {{data, children}, rest}
  end

  def children(0, acc, list), do: {Enum.reverse(acc), list}

  def children(count, acc, list) do
    {child, rest} = node(list)
    children(count - 1, [child | acc], rest)
  end

  def sum_node({items, children}, sum) do
    Enum.sum(items) + Enum.reduce(children, sum, &sum_node/2)
  end

  def part1 do
    {tree, _} = node(list())
    sum_node(tree, 0)
  end

  def select_children(children, indices) do
    child_map =
      children
      |> Enum.with_index(1)
      |> Map.new(fn {child, index} -> {index, child} end)

    indices
    |> Enum.map(&Map.get(child_map, &1))
    |> Enum.reject(&(&1 === nil))
  end

  def value_node({items, []}), do: Enum.sum(items)

  def value_node({items, children}) do
    select_children(children, items)
    |> Enum.reduce(0, fn child, value -> value + value_node(child) end)
  end

  def part2 do
    {tree, _} = node(list())
    value_node(tree)
  end
end

IO.puts(Day8.part1())
IO.puts(Day8.part2())
