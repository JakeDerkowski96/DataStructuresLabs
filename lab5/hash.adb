-- IN FILE HASH.ADB

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body hash is

   procedure Hash_Gen(inFile : String; Out_File : String; Table_Size : Integer;
                      Full : Float; Probe_Type : Probe; Hash_Type : Hash_Method;
                      Location : Implementation) is
   begin
      put_line("Hashing Function: " & Hash_Method'Image(Hash_Type));
      put_line("Probe type: " & Probe'Image(Probe_Type));

      if Location = Memory then put_line("Location: Main Memory");
         Main_Memory(inFile, Table_Size, Full, Probe_Type, Hash_Type);

      else put_line("Location: " &  Out_File);
         File(inFile, Out_File, Table_Size, Full, Probe_Type, Hash_Type);
      end if;

   end Hash_Gen;

   procedure Main_Memory(inFile : String; Table_Size : Integer; Full : Float;
                      Probe_Type : Probe; Hash_Type : Hash_Method) is
      Input : Hash_IO.File_Type;
      Limit : Integer := Integer(Float'Floor(Float(Table_Size) * Full));
   begin
      Open(Input, in_file, inFile);
      Reset(Input);
      declare
         Null_Record : Hash_Record := (Item => "                ", HA_Addr => 0, Probes => 0);
         My_Table : Hash_Table(0..Table_Size - 1) := (others => Null_Record);

      begin
         for i in 2..Limit + 1 loop
            declare
               HA_Rec : Hash_Record; -- store items
               temp : Read_Hash; -- read from file
               Offset : Integer := 0;
               -- for random number generation
               R : Integer := 1;
               div : Integer := 2**(Integer(Log(Base => 2.0, X => Float(Table_Size))) + 2);
               package RandOffset is new random_integer(div);  use RandOffset;
            begin
               Read(Input, temp, Hash_IO.Count(i)); -- read item from file
               HA_Rec.Item := temp(1..16);          -- store item into

               if Hash_Type = Burris then HA_Rec.HA_Addr := Burris_Key(HA_Rec.Item);  -- burris hash
               else HA_Rec.HA_Addr := My_Key(HA_Rec.Item, Table_Size); -- my hash
               end if;

            -- if HA_Rec.HA.Addr = 128 then HA_Addr := 1; end if; -- circle table

               while My_Table((HA_Rec.HA_Addr + Offset) mod Table_Size).Item /= Null_Record.Item loop

                  if Probe_Type = LINEAR then Offset := Offset + 1; -- linear
                  else Offset := R + UniqueRandInteger;             -- random
                  end if;

                  HA_Rec.Probes := HA_Rec.Probes + 1; -- count number of probes

               end loop;

               My_Table((HA_Rec.HA_Addr + Offset) mod Table_Size) := HA_Rec;
            end;
         end loop;

         for i in 0..Table_Size - 1 loop

            if My_Table(i).Item /= Null_Record.Item then -- not empty
               put(Integer'Image(i) & " :   " & My_Table(i).Item & "      ");
               put("Original Location:" & "   " & Integer'Image(My_Table(i).HA_Addr) & "       ");
               put("Probes:" & "  " & Integer'Image(My_Table(i).Probes)); new_line;
            else put_line(Integer'Image(i) & " :   " & "NULL");
            end if;

         end loop;
         new_line;
         -- first 30
         put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
         put_line("Statistics: first 30 records inserted:");
         Probe_Average(Input, Print_File, My_Table, 2, 31, Table_Size, Probe_Type, Hash_Type, Memory);
         -- last 30 records
         put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
         put_line("Statistics: last 30 records inserted:");
         Probe_Average(Input, Print_File, My_Table, Limit - 29, Limit, Table_Size, Probe_Type, Hash_Type, Memory);
         Probe_Theoretical(Table_Size, Limit, Probe_Type); new_line;

      end;
      Close(Input);
   end Main_Memory;

   procedure File(inFile : String; Out_File : String; Table_Size : Integer;
                   Full : Float; Probe_Type : Probe; Hash_Type : Hash_Method) is
      Input : Hash_IO.File_Type;
      storage : Output_IO.File_Type;
      Limit : Integer := Integer(Float'Floor(Float(Table_Size) * Full));
      T : Hash_Record;    -- temp out
      HA_Addr : Integer;
   begin
      Open(Input, in_file, inFile); -- open/read "Words200D16.txt"
      declare
         Null_Record : Hash_Record := ("                ", 0, 0); -- empty record
      begin
         Create(storage, InOut_file, Out_File); -- create output file
         for i in 1..Table_Size loop
            Output_IO.Write(storage, Null_Record, Output_IO.Count(i)); -- init table
         end loop;                     -- with null records

         for i in 1..Limit loop
            declare
               HA_Rec : Hash_Record;  -- store hash
               temp : Read_Hash;      -- read in item
               Offset : Integer := 0; -- linear/random
               R : Integer := 1;      -- init seed
               div : Integer := 2**(Integer(Log(Base => 2.0, X => Float(Table_Size))) + 2);
               -- div == NumBits in random_integer
               package RandOffset is new random_integer(div);  use RandOffset;

            begin
               Hash_IO.Read(Input, temp, Hash_IO.Count(i)); -- read item from file
               HA_Rec.Item := temp(1..16); -- item into hash record

               -- pick which hash function to use,
               -- generate hash address for the item
               if Hash_Type = Burris then HA_Rec.HA_Addr := Burris_Key(HA_Rec.Item); -- burris hash
               else HA_Rec.HA_Addr := My_Key(HA_Rec.Item, Table_Size); -- my hash
               end if;

               -- if HA_Addr = 0 then HA_Addr := 64; end if; -- circle table

               loop -- looking for free storage space
                  HA_Addr := (HA_Rec.HA_Addr + Offset) mod Table_Size;

                  if HA_Addr = 0 then HA_Addr := 64; end if; -- circle table

                  Output_IO.Read(storage, T, Output_IO.Count(HA_Addr));
                  exit when T = Null_Record;         -- end of file

                  HA_Rec.Probes := HA_Rec.Probes + 1; -- increments probes needed

                  -- collosion handling
                  if Probe_Type = LINEAR then Offset := Offset + 1;
                  else Offset := R + UniqueRandInteger; -- random
                  end if;

               end loop;
               -- write hash record to file
               Output_IO.Write(storage, HA_Rec, Output_IO.Count(HA_Addr));
            end;
         end loop;

         for i in 1..Table_Size loop
            Output_IO.Read(storage, T, Output_IO.Count(i));  -- print hash to screen

            if T /= Null_Record then -- display table contents
               put(Integer'Image(i) & " :   " & T.Item & "      ");
               put("Original Location:" & "   " & Integer'Image(T.HA_Addr) & "     ");
               put("Probes:" & "  " & Integer'Image(T.Probes)); new_line;
            else put_line(Integer'Image(i) & " :   " & "NULL");
            end if;

         end loop;
         new_line;

         -- Statistics section
         put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");         -- first 30 records
         put_line("Statistics for first 30 records inserted:");
         Probe_Average(Input, storage, Calc_Table, 2, 31, Table_Size, Probe_Type, Hash_Type, File);

         put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");         -- last 30 records
         put_line("Statistics for last 30 records inserted:");
         Probe_Average(Input, storage, Calc_Table, Limit - 29, Limit, Table_Size, Probe_Type, Hash_Type, File);
         Probe_Theoretical(Table_Size, Limit, Probe_Type); new_line;

         Close(storage);
      end;
      Close(Input);
   end File;

   procedure Probe_Average(Input : Hash_IO.File_Type; storage : Output_IO.File_Type;
                    My_Table : Hash_Table; Lower : Integer; Upper : Integer;
                    Table_Size : Integer; Probe_Type : Probe; Hash_Type : Hash_Method;
                    Location : Implementation) is
      min : Integer := 1000;  -- initialize variables
      max : Integer := 1;
      avg : Float := 0.0;
      div : Float := Float(Upper - Lower);
      probe_min : Integer := 1000;
      probe_max : Integer := 1;
   begin
      for i in Lower..Upper loop
         declare
            T, T2: Hash_Record;
            temp : Read_Hash;
            Offset, HA_Addr : Integer := 0;
            R : Integer := 1;
            N : Integer := 2**(Integer(Log(Base => 2.0, X => Float(Table_Size))) + 2);
            package RandOffset is new random_integer(N);  use RandOffset;
         begin
            Read(Input, temp, Hash_IO.Count(i));
            T.Item := temp(1..16);

            -- determine which hash function
            if Hash_Type = Burris then T.HA_Addr := Burris_Key(T.Item); -- given hash
            else T.HA_Addr := My_Key(T.Item, Table_Size); -- my hash
            end if;

            if Location = File then -- if file storage is being used
               loop
                  HA_Addr := (T.HA_Addr + Offset) mod Table_Size;

                  if HA_Addr = 0 then HA_Addr := 64; end if;  -- loop table to begin

                  Output_IO.Read(storage, T2, Output_IO.Count(HA_Addr));
                  exit when T2.Item = T.Item; -- all items have been compl.

                  T.Probes := T.Probes + 1; -- increment times probed

                  -- collosion handling
                  if Probe_Type = LINEAR then Offset := Offset + 1;
                  else Offset := R + UniqueRandInteger;
                  end if;


               end loop;
            else
               while My_Table((T.HA_Addr + Offset) mod Table_Size).Item /= T.Item loop

                  T.Probes := T.Probes + 1;

                  if HA_Addr = 0 then HA_Addr := 64; end if; -- test -- loop table to begin

                  -- collosion handling
                  if Probe_Type = LINEAR then Offset := Offset + 1;
                  else Offset := R + UniqueRandInteger;
                  end if;

               end loop;
               put_line(integer'image(t.probes));
            end if;

            if T.Probes < min then min := T.Probes; end if;
            if T.Probes > max then max := T.Probes; end if;

            avg := avg + (Float(T.Probes) / div);

         end;
      end loop;
      -- print Statistics

      put_line("Minimum:" & "  " & Integer'Image(min));
      put_line("Maximum:" & "  " & Integer'Image(max));
      put("Average:" &"  "); f_IO.put(Item => avg, Fore => 3, Aft => 2, Exp => 0); new_line;
      put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"); new_line;
   end Probe_Average;

   procedure Probe_Theoretical(Table_Size : Integer; keys : Integer; Probe_Type : Probe) is
      alpha, E : Float;
   begin -- expected number of probes
      alpha := (Float(keys) / Float(Table_Size));

      if Probe_Type = LINEAR then E := (1.0 - alpha / 2.0) / (1.0 - alpha);
      else E := -(1.0 / alpha) * (Log(1.0 - alpha));
      end if;

      put_line("~~~~~~~~~~~~~~~~Theoretical~~~~~~~~~~~~~~~~~");
      put_line("Keys:" & "  " & Integer'Image(keys));
      put("Load level:" & "  ");
      f_IO.put(Item => alpha * 100.0, Fore => 2, Aft => 2, Exp => 0); put("%");
      new_line;
      put("Expected average Probes:" & "  ");
      f_IO.put(Item => E, Fore => 2, Aft => 2, Exp => 0); new_line;
      put_line("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");  new_line;
   end Probe_Theoretical;

   function Burris_Key(Item : Hash_Element) return Integer is
      temp : Unsigned64Bit;
      Hash_Address : Integer;
   begin -- hash function esse-- then arbituary dividing by a integer
      temp := abs(Str2Unsign(Item(4..5)) + Str2Unsign(Item(13..14)));
      temp := temp / 65535;
      temp := temp + abs(Char2Unsign(Item(10))); -- more simple codes
      -- put_line("TEMP VALUE: -> " & Unsigned64Bit'Image(temp));
      temp := temp mod 128; -- hash address
      -- put_line("HashADdr VALUE: -> " & Unsigned64Bit'Image(temp));
      -- table size is quite small for this to be a good hash, and would most likely
      -- never be a reliable hash becuase the use of "simple codes" and set arithmetic
      -- can almost never guarantee collosion free hash, size of numbers used in
      -- arithmetic are negligable
      Hash_Address := Unsign2Int(temp);
      return Hash_Address;
   end Burris_Key;

   function My_Key(Item : Hash_Element; Table_Size : Integer) return Integer is
      temp : Unsigned64Bit;
      Hash_Address : Integer;
   begin
      -- Method used: square and extract N bits and division remainder
      -- this method is used because it works well with table sizes of 2**n
      -- each hash element is split up in half by slicing, then converted to un
      -- signed integer then multiplied.
      -- the middle 8 bits are extracted then modulus the table size + 1
      -- Division remainder works great with unknown keys and creates a hash Table
      -- that is typically more uniformly distributed
      temp := abs(MyStr2Unsign(Item(1..8)) * MyStr2Unsign(Item(9..16))); -- 8*8 = 64 bit unsigned int
      temp := temp / 2**12; -- extract N bits
      Hash_Address := Unsign2Int(temp mod Int2Unsign(Table_Size - 1)); -- division remainder
      return Hash_Address;

   end My_Key;

end hash;
