with Ada.Numerics.Discrete_Random;
package body Initialize_Seed is
  subtype seed is integer range 1..9999;
  package RandomSeed is new Ada.Numerics.Discrete_Random(seed);
  G : RandomSeed.Generator;
  -- Gen : RandomSeed.Generator;


  function Get_Seed return Integer is
  begin
    return RandomSeed.Random(Gen => G);
  end Get_Seed;

begin

  RandomSeed.Reset(Gen => G);  -- time-dependent initialization

end Initialize_Seed;
