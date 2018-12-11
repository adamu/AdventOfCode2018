defmodule Day7 do
  def input_to_graph do
    input_pattern = ~r/Step (\w) must be finished before step (\w) can begin./

    File.stream!("input")
    |> Enum.map(&Regex.run(input_pattern, &1, capture: :all_but_first))
    |> Enum.reduce(%{}, fn [from, to], routes ->
      Map.update(routes, from, [to], fn tos -> [to | tos] end)
    end)
  end

  def count_predecessors(graph) do
    Enum.reduce(graph, %{}, fn {step, _children}, counts ->
      counts = Map.put_new(counts, step, 0)
      count_predecessors(counts, counts[step], graph[step], graph)
    end)
  end

  def count_predecessors(counts, _, nil, _), do: counts

  def count_predecessors(counts, level, children, graph) do
    child_lvl = level + 1

    Enum.reduce(children, counts, fn child, counts ->
      counts = Map.update(counts, child, child_lvl, fn existing -> max(existing, child_lvl) end)
      count_predecessors(counts, counts[child], graph[child], graph)
    end)
  end

  def resolve_steps(graph, steps) when map_size(graph) === 1 do
    [{penultimate, ultimates}] = Map.to_list(graph)
    Enum.reverse(steps) ++ [penultimate | Enum.sort(ultimates)]
  end

  def resolve_steps(graph, steps) do
    before_counts = count_predecessors(graph)

    [next | _] =
      Enum.filter(before_counts, fn {_, count} -> count === 0 end)
      |> Enum.map(fn {step, _count} -> step end)
      |> Enum.sort()

    resolve_steps(Map.delete(graph, next), [next | steps])
  end

  def part1, do: input_to_graph() |> resolve_steps([]) |> Enum.join()
end

IO.puts(Day7.part1())
