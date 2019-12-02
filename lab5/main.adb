--- in file main.adb

with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with hash; use hash;

procedure main is

begin
   -- all of the following are C Option function calls, not needed anymore
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.50, Linear, Burris, Memory); -- A
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.90, Linear, Burris, Memory); -- B
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.50, Random, Burris, Memory); -- C
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.90, Random, Burris, Memory); -- C
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.50, Linear, Jake, Memory); -- E
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.90, Linear, Jake, Memory); -- E
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.90, Random, Jake, Memory); -- E
   -- hash.Hash_Gen("Words200D16.txt", "null", 128, 0.50, Random, Jake, Memory); -- E
   --
   -- put_line("Question A:");
   -- put_line("~~~~~~~~~~~~~");
   -- hash.Hash_Gen("Words200D16.txt", "Question_A", 128, 0.50, Linear, Burris, File);
   -- put_line("_________________________________________________________________");
   --
   put_line("Question B:");
   -- put_line("~~~~~~~~~~~~~");
   hash.Hash_Gen("Words200D16.txt", "Question_B", 128, 0.90, Linear, Burris, File);
   -- put_line("_________________________________________________________________");
   --
   -- put_line("Question C:");
   -- put_line("~~~~~~~~~~~~~");
   -- hash.Hash_Gen("Words200D16.txt", "Question_C_part1", 128, 0.50, Random, Burris, File);
   -- hash.Hash_Gen("Words200D16.txt", "Question_C_part2", 128, 0.90, Random, Burris, File);
   -- put_line("_________________________________________________________________");
   --
   -- put_line("Question E:");
   -- put_line("~~~~~~~~~~~~~");
   -- hash.Hash_Gen("Words200D16.txt", "Question_E_part1", 128, 0.50, Linear, Jake, File); -- A
   -- hash.Hash_Gen("Words200D16.txt", "Question_E_part2", 128, 0.90, Linear, Jake, File); -- B
   -- hash.Hash_Gen("Words200D16.txt", "Question_E_part3", 128, 0.50, Random, Jake, File); -- C
   -- hash.Hash_Gen("Words200D16.txt", "Question_E_part4", 128, 0.90, Random, Jake, File); -- C
   --
   -- delay(Duration(1));
   -- put_line("End of hashing demonstration."); new_line;
   -- put_line("Terminating program."); new_line;
end main;
