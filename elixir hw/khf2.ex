defmodule Khf2 do

  @moduledoc """
  Kemping térképe
  @author "UHQUIW"
  @date   "2022-09-23"
  ...
  """

  @type row   :: integer    
  @type col   :: integer    
  @type field :: {row, col} 

  @type tents_count_rows :: [integer] 
  @type tents_count_cols :: [integer] 

  @type trees       :: [field]  
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees} 

  @type dir       :: :n | :e | :s | :w 
  @type tent_dirs :: [dir] 

  @spec converter({pos::field, d::dir}):: String.t
  defp converter({{y, x}, d}) do
    c = String.upcase(Atom.to_string(d))
    case c do
        "N" ->
            {x, y-1, "N"}
        "E" ->
            {x+1, y, "E"}
        "S" -> 
            {x, y+1, "S"}
        "W" -> 
            {x-1, y, "W"}
    end
  end
  @spec switcher(dirs::tent_dirs, f::field)::String.t
  defp switcher(dirs, {i, j}) do
    cond do
        Enum.member?(dirs, {j, i, "N"}) -> "N"
        Enum.member?(dirs, {j, i, "E"}) -> "E"
        Enum.member?(dirs, {j, i, "S"}) -> "S"
        Enum.member?(dirs, {j, i, "W"}) -> "W"
        true -> "-"
    end
  end


  @spec to_external(pd::puzzle_desc, ds::tent_dirs, file::String.t) :: :ok
  def to_external({rs, cs, ts}, ds, file) do
        fr = " "<>Enum.join(cs, " ")<>"\n"
        pack = Enum.zip([ts, ds])
        dirs =  Enum.map(pack, fn x -> converter(x) end)
        sol = for i <- 1..length(rs), do: for j <- 1..length(cs), do: if Enum.member?(ts, {i, j}), do: "*", else: switcher(dirs, {i, j})
        
        comb_sol = Enum.map(Enum.zip([rs, sol]), fn {k, l} -> [k | l] end)
        
        fin_sol = Enum.join(Enum.map(comb_sol, fn x -> Enum.join(x, " ") end), "\n")
        megoldas = fr<>fin_sol
        
        File.write(file, megoldas)
  end

end
