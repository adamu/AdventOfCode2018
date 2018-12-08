defmodule Coord do
  defstruct [:x, :y]
end

defmodule Claim do
  defstruct id: nil, pos: %Coord{x: 0, y: 0}, len: %Coord{x: 0, y: 0}
  @input_pattern ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

  def new_from_str(str) do
    [id, pos_x, pos_y, len_x, len_y] =
      Regex.run(@input_pattern, str, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %Claim{id: id, pos: %Coord{x: pos_x, y: pos_y}, len: %Coord{x: len_x, y: len_y}}
  end

  def all_coords(claim) do
    x_coords = claim.pos.x..(claim.pos.x + claim.len.x - 1)
    y_coords = claim.pos.y..(claim.pos.y + claim.len.y - 1)
    for x <- x_coords, y <- y_coords, do: %Coord{x: x, y: y}
  end
end

defmodule Part1 do
  def count_claim_inches(claim, count) do
    Enum.reduce(Claim.all_coords(claim), count, fn coord, count ->
      Map.update(count, coord, 1, &(&1 + 1))
    end)
  end

  def run do
    File.stream!("input")
    |> Stream.map(&Claim.new_from_str/1)
    |> Enum.reduce(%{}, &count_claim_inches/2)
    |> Stream.filter(fn {_coord, count} -> count >= 2 end)
    |> Enum.count()
    |> IO.puts()
  end
end

Part1.run()
