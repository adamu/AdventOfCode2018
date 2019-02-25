defmodule Day13 do
  defmodule Cart do
    defstruct [:direction, :next_turn]
  end

  defmodule Parser do
    # track pieces
    # | - / \ +
    # Cars
    # ^ v < >
    # Inital car = straight track underneath
    # Sample input:
    # /->-\        
    # |   |  /----\
    # | /-+--+-\  |
    # | | |  | v  |
    # \-+-/  \-+--/
    #  \------/   
    def parse_file() do
      rows =
        File.read!("test")
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.to_charlist/1)

      {_, track, cars} =
        Enum.reduce(rows, {0, %{}, %{}}, fn row, {row_idx, track, cars} ->
          {_, _, track, cars} = Enum.reduce(row, {row_idx, 0, track, cars}, &parse_char/2)
          {row_idx + 1, track, cars}
        end)

      {track, cars}
    end

    defp parse_char(? , {row_idx, col_idx, track, cars}) do
      {row_idx, col_idx + 1, track, cars}
    end

    defp parse_char(cart, args) when cart in '^v<>', do: parse_cart(cart, args)
    defp parse_char(track, args) when track in '|-/\\+', do: parse_track(track, args)

    defp parse_cart(?^, {row_idx, col_idx, track, cars}) do
      cars = Map.put(cars, {row_idx, col_idx}, %Cart{direction: :up, next_turn: :left})
      parse_track(?|, {row_idx, col_idx, track, cars})
    end

    defp parse_cart(?v, {row_idx, col_idx, track, cars}) do
      cars = Map.put(cars, {row_idx, col_idx}, %Cart{direction: :down, next_turn: :left})
      parse_track(?|, {row_idx, col_idx, track, cars})
    end

    defp parse_cart(?<, {row_idx, col_idx, track, cars}) do
      cars = Map.put(cars, {row_idx, col_idx}, %Cart{direction: :left, next_turn: :left})
      parse_track(?-, {row_idx, col_idx, track, cars})
    end

    defp parse_cart(?>, {row_idx, col_idx, track, cars}) do
      cars = Map.put(cars, {row_idx, col_idx}, %Cart{direction: :right, next_turn: :left})
      parse_track(?-, {row_idx, col_idx, track, cars})
    end

    defp parse_track(char, {row_idx, col_idx, track, cars}) do
      track = Map.put(track, {row_idx, col_idx}, <<char::utf8>>)
      {row_idx, col_idx + 1, track, cars}
    end
  end

  # Plan:
  # Build a giant coordinate map containing what piece of track is at a coordinate
  # (spaces with no track can be skipped)
  # Build a separate map of cars
  # Cars should contain their location, direction, and next turn
  # -> Sort the map each tick to determine car order
  # For a tick, go through each car and update it's location (key), direction, and next turn
  # - if there's a collision, we can stop early and return the location
end
