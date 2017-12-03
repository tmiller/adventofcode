defmodule Day3 do
  # first circle is 1^2
  # second circle is 3^2
  # third circle is 5^2
  # 1,3,5,7
  def find_level(target_number) do
    possible_values =
      Enum.take_every(1..9999, 2)
      |> Enum.drop_while(fn (number) -> :math.pow(number, 2) > target_number end)
    hd(possible_values)+1
  end

  def diameter_at_level(n) do
    Enum.take_every(1..9999, 2)
    |> Enum.at(n)
  end

  def simulate_circle(n) do
    # the last ring ends at (n-1)^2
    starting_point = round(:math.pow((n-1), 2) + 1)
    diameter       = diameter_at_level(n-1)

    circle =
      (starting_point..round(:math.pow(diameter, 2)))
      |> Enum.to_list

    # rotate(1): the circle starts from just above BR
    {last, circle} = List.pop_at(circle, -1)
    [last] ++ circle

    # each n-th spot is a corner
  end

  # distance = steps to midpoint of circle + number of levels you are at
  def distance(num) do
    # determine the number of levels
    find_level(num)
  end

  def run do
    IO.puts "ghetto tests"
    IO.puts distance(1) == 0
    IO.puts distance(12) == 3
    IO.puts distance(23) == 2
    IO.puts distance(1024) == 31

    IO.puts distance(265149)
  end
end

IO.inspect Day3.simulate_circle(2)
Day3.run
