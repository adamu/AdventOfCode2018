defmodule Day12 do
  defmodule Parser do
    def parse(filename) when is_binary(filename) do
      File.open!(filename, [:utf8], &parse/1)
    end

    def parse(file) do
      IO.read(file, String.length("initial state: "))
      state = file |> IO.read(:line) |> String.trim() |> String.to_charlist() |> Enum.with_index()
      IO.read(file, :line)
      {state, parse_spec(file)}
    end

    def parse_spec(file), do: parse_spec(file, IO.read(file, :line), %{})
    def parse_spec(_file, :eof, spec), do: spec

    def parse_spec(file, line, spec) do
      [pattern, <<result::utf8>>] = ~r/(.{5}) => (.)/ |> Regex.run(line, capture: :all_but_first)

      parse_spec(
        file,
        IO.read(file, :line),
        Map.put(spec, String.to_charlist(pattern), result)
      )
    end
  end

  def evolve(input, _spec, 0), do: input

  def evolve(input, spec, generations) do
    input = generation(input, spec)
    evolve(input, spec, generations - 1)
  end

  def generation(input, spec) do
    input |> pad |> propagate(spec)
  end

  def propagate([a, b, c, d, e | rest], spec) do
    {_, pot} = c
    pattern = visualise([a, b, c, d, e])
    [{Map.get(spec, pattern), pot} | propagate([b, c, d, e | rest], spec)]
  end

  def propagate(rest, _spec) when length(rest) == 4, do: []

  # Pads with 4 empty pots. If the spec contained ..... => #, would need to pad with 5
  def pad(list) do
    list |> Enum.reverse() |> pad_rear |> Enum.reverse() |> pad_front
  end

  def pad_front([{?., _}, {?., _}, {?., _}, {?., _} | _] = done), do: done
  def pad_front([{_, i} | _] = list), do: pad_front([{?., i - 1} | list])

  def pad_rear([{?., _}, {?., _}, {?., _}, {?., _} | _] = done), do: done
  def pad_rear([{_, i} | _] = list), do: pad_rear([{?., i + 1} | list])

  def visualise(input) do
    Enum.map(input, fn {x, _i} -> x end)
  end

  def part1 do
    {input, spec} = Parser.parse("input")

    evolve(input, spec, 20)
    |> Enum.filter(fn {plant, _} -> plant === ?# end)
    |> Enum.map(fn {_, pot} -> pot end)
    |> Enum.sum()
  end
end
