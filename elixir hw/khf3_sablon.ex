defmodule Khf3 do

  @moduledoc """
  Kemping helyessége
  @author "UHQUIW"
  @date   "2022-09-28"
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

  @type cnt_tree  :: integer                        
  @type cnt_tent  :: integer    
  @type err_rows  :: %{err_rows:  [integer]}         
  @type err_cols  :: %{err_cols:  [integer]}        
  @type err_touch :: %{err_touch: [field]}          
  
  @type errs_desc :: {err_rows, err_cols, err_touch}
  
  @spec converter({pos::field, d::dir}):: field
  defp converter({{y, x}, d}) do
    c = String.upcase(Atom.to_string(d))
    case c do
        "N" ->
            {y-1, x}
        "E" ->
            {y, x+1}
        "S" -> 
            {y+1, x}
        "W" -> 
            {y, x-1}
    end
  end
  
  @spec rs_counter(i::integer, rs::tents_count_rows, dirs::trees):: err_rows
  defp rs_counter(_, [], _), do: []
  defp rs_counter(i, [hrs|trs], dirs) do
    if Enum.count(dirs, fn {y, _} -> y == i end) == hrs or hrs < 0 do
        rs_counter(i+1, trs, dirs)
    else
        [i |rs_counter(i+1, trs, dirs)]
    end
  end
  
  @spec cs_counter(i::integer, cs::tents_count_cols, dirs::trees):: err_rows
  defp cs_counter(_, [], _), do: []
  defp cs_counter(i, [hcs|tcs], dirs) do
    if Enum.count(dirs, fn {_, x} -> x == i end) == hcs or hcs < 0  do
        cs_counter(i+1, tcs, dirs)
    else
        [i |cs_counter(i+1, tcs, dirs)]
    end
  end
  
  @spec check_neighbour(dir1::field, dir2::field):: boolean
  defp check_neighbour({y1, x1}, {y2, x2}) do
    abs(y2 - y1) <= 1 and abs(x2 - x1) <= 1
  end
  
  @spec has_neighbours(dirs::trees, rdirs::trees):: [field]
  defp has_neighbours([], _), do: []
  defp has_neighbours([hdirs|tdirs], rdirs) do
    if Enum.count(rdirs, fn x -> check_neighbour(hdirs, x)end) >= 2 do
        [hdirs|has_neighbours(tdirs, rdirs)]
    else
        has_neighbours(tdirs, rdirs)
    end
  end
  
  @spec check_sol(pd::puzzle_desc, ds::tent_dirs) :: ed::errs_desc
  def check_sol({rs, cs, ts}, ds) do
    dirss =  Enum.map(Enum.zip([ts, ds]), fn x -> converter(x) end)
	dirs = Enum.filter(dirss, fn {r,c} ->  r > 0 and r <= length(rs) and c > 0 and c <= length(cs) end )
    {%{err_rows:  rs_counter(1, rs, dirs)} , 
    %{err_cols:  cs_counter(1, cs, dirs)} , 
    %{err_touch: has_neighbours(dirs, dirs)} 
    }
  end
  
end
