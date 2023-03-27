defmodule Khf1 do

  @moduledoc """
  Kemping
  @author "UHQUIW"
  @date   "2022-09-21"
  ...
  """


  @type row   :: integer
  @type col   :: integer
  @type field :: {row, col}

  @type tents_count_rows :: [integer]
  @type tents_count_cols :: [integer]

  @type trees       :: [field]
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

  @spec slicer(xs::[any]) :: sol :: puzzle_desc
  defp slicer(xs) do
    s = Enum.map(List.first(xs), fn x -> String.to_integer(x) end)
    f =  Enum.map(tl(xs), fn x -> String.to_integer(hd(x)) end)
    t2 = Enum.map(Enum.map(tl(xs), fn x -> tl(x) end), fn x -> Enum.with_index(x) end)
    
    {f, s, inner_slicer(Enum.with_index(t2))}
  end

  @spec inner_slicer(xs::[any]) :: root :: trees
  defp inner_slicer([]), do: []
  defp inner_slicer([{sor,i}|xs]), do: (for {"*", y} <- sor, do: {i+1, y+1}) ++ inner_slicer(xs)



  @spec to_internal(file::String.t) :: pd::puzzle_desc
  def to_internal(file) do
        {:ok, fel} = File.read(file)
        fel = String.split(fel, "\n", trim: true)
        fel = Enum.map(fel, fn x -> String.split(x, " ", trim: true) end)
        slicer(fel)
    end

end

