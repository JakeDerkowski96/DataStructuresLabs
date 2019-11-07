with Initialize_Seed; use Initialize_Seed;
Package body RandFloat is
    x : integer;
   function next_float return float is
    n : integer;
  begin
    x := Get_Seed;
    x := x*29+37;
    n := x;
    x := x mod 1001;
    return  float(n mod 101) / 100.0;
  end next_float;
end RandFloat;
