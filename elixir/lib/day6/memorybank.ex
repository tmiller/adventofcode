defmodule Advent2017.Day6 do
  @doc ~S"""
  Finds the most populated bank in `list`, and redistributes it across the
  other banks.

      iex> Advent2017.Day6.cycle([0, 2, 7, 0])
      [2, 4, 1, 2]
      iex> Advent2017.Day6.cycle([2, 4, 1, 2])
      [3, 1, 2, 3]
      iex> Advent2017.Day6.cycle([3, 1, 2, 3])
      [0, 2, 3, 4]
  """
  @spec cycle(list) :: list
  def cycle(list) do
    list =
      list
      |> Enum.with_index

    {max, index_of_max} =
      list
      |> largest_bank

    list = List.replace_at(list, index_of_max, {0, index_of_max})

    # rotate the list to the bank after the "max" bank
    rotated_list = rotate_to(list, index_of_max+1)

    redistribute(rotated_list, max)
    |> sort_banks
  end

  @doc ~S"""
      iex> Advent2017.Day6.redistribute([{1, 0}, {2, 1}, {3, 2}, {0, 3}], 3)
      ...> |> Advent2017.Day6.sort_banks
      [2, 3, 4, 0]
  """
  def redistribute(list, 0), do: list

  def redistribute([h|t], spare_blocks) do
    {head, index} = h
    redistribute(t ++ [{head+1, index}], spare_blocks-1)
  end

  @doc ~S"""
      iex> Advent2017.Day6.rotate_to([1,2,3], 1)
      [2, 3, 1]
      iex> Advent2017.Day6.rotate_to([1,2,3], 0)
      [1, 2, 3]
  """
  def rotate_to(list, 0), do: list

  def rotate_to(list, index) do
    Enum.slice(list, index..-1) ++ Enum.slice(list, 0..index-1)
  end

  @doc ~S"""
  Sorts a list of tuples (from `Enum.with_index`) back into it's original state

      iex> Advent2017.Day6.sort_banks([{1, 0}, {2, 1}, {3, 2}])
      [1, 2, 3]
      iex> Advent2017.Day6.sort_banks([{1, 1}, {2, 2}, {3, 0}])
      [3, 1, 2]
  """
  def sort_banks(list) do
    list
    |> Enum.sort(fn({_, i1}, {_, i2}) -> i1 <= i2 end)
    |> Enum.unzip
    |> elem(0)
  end

  @doc ~S"""
      iex> Advent2017.Day6.largest_bank([{1,1}, {2,0}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{2,0}, {1,1}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{2,0}, {2, 1}, {1,2}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{1, 5}, {5, 0}, {2, 3}, {5, 1}])
      {5,0}
      iex> Advent2017.Day6.largest_bank([{1, 5}, {0, 4}, {5, 0}, {6, 2}, {2, 3}, {5, 1}])
      {6, 2}
  """
  def largest_bank(list) do
    # because the list is of tuples where I'm tracking their original location
    # I have to have a custom sort. I probably would have done better to have
    # some other structure. :(
    list
    |> Enum.sort(fn({v1, _}, {v2, _}) -> v1 >= v2 end)
    |> List.first
  end

  @doc ~S"""
      iex> Advent2017.Day6.balance([0, 2, 7, 0])
      %{cycles: 5, distance: 4}
  """
  def balance(configuration, visited \\ []) do
    cond do
      Enum.any?(visited, &(configuration==&1)) ->
        %{cycles: Enum.count(visited),
          distance: Enum.count(visited) - Enum.find_index(visited, &(configuration==&1))}
      true ->
        configuration
        |> cycle
        |> balance(visited ++ [configuration])
    end
  end

  def load_file do
    {:ok, file} = File.read("lib/day6/input.txt")

    file
    |> String.split("\t", [trim: true])
    |> Enum.map(&(String.to_integer(String.trim(&1))))
  end

  def p1 do
    {:ok, answer} =
      load_file()
      |> balance
      |> Map.fetch(:cycles)
    answer
  end

  def p2 do
    {:ok, answer} =
      load_file()
      |> balance
      |> Map.fetch(:distance)
    answer
  end
end