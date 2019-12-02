-- in file random_integer.adb
package body random_integer is
 R: Integer := 1;

 procedure InitRandInt is
  begin R := 1; end InitRandInt;

 function UniqueRandInteger return Integer is
begin
    R := (5 * R) Mod NumBits;
    return R / 4;
end UniqueRandInteger;

end random_integer;
