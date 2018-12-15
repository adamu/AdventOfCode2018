defmodule Day8 do
  import Kernel, except: [node: 1]

  def list, do: File.read!("input") |> String.split() |> Enum.map(&String.to_integer/1)

  def node([child_count, data_count | rest]) do
    {children, rest} = children(child_count, [], rest)
    {data, rest} = Enum.split(rest, data_count)
    {{data, children}, rest}
  end

  def children(0, acc, list), do: {acc, list}

  def children(count, acc, list) do
    {child, rest} = node(list)
    children(count - 1, [child | acc], rest)
  end

  def sum_tree({items, children}, sum) do
    Enum.sum(items) + Enum.reduce(children, sum, &sum_tree/2)
  end

  def part1 do
    {tree, _} = node(list())
    sum_tree(tree, 0)
  end
end

IO.puts(Day8.part1())
