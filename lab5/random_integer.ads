-- in file random_integer.ads
generic
 NumBits : Integer;

package random_integer is

 procedure InitRandInt;
 function UniqueRandInteger return Integer;

end random_integer;
