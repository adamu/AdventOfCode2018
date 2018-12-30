defmodule Day12 do
  defmodule Parser do
    def parse(filename) when is_binary(filename) do
      File.open!(filename, [:utf8], &parse/1)
    end

    def parse(file) do
      IO.read(file, String.length("initial state: "))
      state = file |> IO.read(:line) |> String.trim() |> str_to_bits()
      IO.read(file, :line)
      {state, parse_spec(file)}
    end

    def parse_spec(file), do: parse_spec(file, IO.read(file, :line), %{})

    def parse_spec(_file, :eof, spec), do: spec

    def parse_spec(file, line, spec) do
      [left, right] =
        ~r/(.{5}) => (.)/
        |> Regex.run(line, capture: :all_but_first)
        |> Enum.map(&str_to_bits/1)

      parse_spec(file, IO.read(file, :line), Map.put(spec, left, right))
    end

    def str_to_bits(str) do
      str
      |> String.graphemes()
      |> Enum.reduce(<<>>, fn char, bits -> <<bits::bits, (<<convert_char(char)::1>>)>> end)
    end

    def convert_char("#"), do: 1
    def convert_char("."), do: 0
  end
end
