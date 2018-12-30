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
      [<<left::5>>, <<right::1>>] =
        ~r/(.{5}) => (.)/
        |> Regex.run(line, capture: :all_but_first)
        |> Enum.map(&str_to_bits/1)

      parse_spec(file, IO.read(file, :line), Map.put(spec, left, right))
    end

    def str_to_bits(str) do
      str
      |> String.graphemes()
      |> Enum.reduce(<<>>, fn char, bits -> <<bits::bits, convert_char(char)::bits>> end)
    end

    def convert_char("#"), do: <<1::1>>
    def convert_char("."), do: <<0::1>>
  end

  defmodule Bitstring do
    @moduledoc "Helper module for visualising bitstrings"
    def visualise(bits), do: visualise(bits, "")
    def visualise(<<>>, str), do: str
    def visualise(<<0::1, rest::bits>>, str), do: visualise(rest, str <> "0")

    # Not sure which of these is faster, will trust to_string over n concatenations
    # def visualise(<<1::1, rest::bits>>, str), do: visualise(rest, str <> "1")
    def visualise(bits, str) do
      size = bit_size(bits)
      <<int::size(size)>> = bits
      str <> Integer.to_string(int, 2)
    end
  end

  # Ensure intial two pots are empty
  def generation(<<1::1, rest::bits>>, spec), do: generation(<<1::5, rest::bits>>, spec)
  def generation(<<1::2, rest::bits>>, spec), do: generation(<<1::5, rest::bits>>, spec)

  # Entry point (after handing special case above)
  def generation(bits, spec), do: generation(bits, <<>>, spec)

  # Terminating condition
  def generation(<<>>, next, _spec), do: trim(next)

  # Process pattern of 5
  def generation(<<pattern::5, _rest::bits>> = thisgen, nextgen, spec) do
    generation(thisgen, nextgen, pattern, spec)
  end

  # Pad with zeros for end of input
  def generation(thisgen, nextgen, spec) do
    padding = 5 - bit_size(thisgen)
    <<pattern::5>> = <<thisgen::bits, 0::size(padding)>>
    generation(thisgen, nextgen, pattern, spec)
  end

  # Consumes an element of thisgen and adds an element to nextgen
  def generation(thisgen, nextgen, pattern, spec) do
    <<_::1, thisgen::bits>> = thisgen
    generation(thisgen, <<nextgen::bits, spec[pattern] || 0::1>>, spec)
  end

  def trim(<<0::1, rest::bits>>), do: trim(rest)

  def trim(bits) do
    size = bit_size(bits) - 1

    case bits do
      <<trimed::bits-size(size), 0::1>> -> trim(trimed)
      bits -> bits
    end
  end

  def spread(pots, _spec, 0) do
    IO.puts("20: #{Bitstring.visualise(pots)}")
    pots
  end

  def spread(pots, spec, times) do
    IO.puts("#{20 - times}: #{Bitstring.visualise(pots)}")
    spread(generation(pots, spec), spec, times - 1)
  end

  # FUUUU got the generations, but apparently needed to keep track of the indecies.
  # Will need to undo the "trim" feature and work out how to keep the array stable
  # Or maybe can just keep track of how many I added to the left, which will be minus indeces
  def part1(filename) do
    {pots, spec} = Parser.parse(filename)
    spread(pots, spec, 20)
  end
end
