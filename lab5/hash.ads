-- IN FILE HASH.ADS

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Direct_IO; -- direct streaming from file
with random_integer;


package hash is
   package f_IO is new Ada.Text_IO.Float_IO(Float);   use f_IO;

   subtype Read_Hash is String(1..18); -- extra space when reading in
   subtype Hash_Element is String(1..16);
   subtype Slice is String(1..2);
   subtype My_Slice is String(1..8);
   subtype Output_String is String(1..25);

   type Unsigned64Bit is mod 2**64;

   type Hash_Record is record
      Item    : Hash_Element;  -- from file
      HA_Addr : Integer;       -- initial Hash address
      Probes  : Integer := 1;  -- at least one Probe is necessary
   end record;

   package Hash_IO is new Direct_IO(Read_Hash);       use Hash_IO;     -- init stream
   package Output_IO is new Direct_IO(Hash_Record);   use Output_IO;   -- output stream

   type Hash_Table is array (Integer range <>) of Hash_Record;

   type Probe is (Linear, Random);         -- enum of possible probes
   type Hash_Method is (Jake, Burris);     -- my hash and your hash function
   type Implementation is (Memory, File);  -- option of storage location

   -- conversion functions for FileIO, char<->int, string<->int
   function Str2Unsign is new Ada.Unchecked_Conversion(Slice, Unsigned64Bit);
   function MyStr2Unsign is new Ada.Unchecked_Conversion(My_Slice, Unsigned64Bit);
   function Char2Unsign is new Ada.Unchecked_Conversion(Character, Unsigned64Bit);
   function Unsign2Int is new Ada.Unchecked_Conversion(Unsigned64Bit, Integer);
   function Int2Unsign is new Ada.Unchecked_Conversion(Integer, Unsigned64Bit);

   -- use hash function
   procedure Hash_Gen(inFile : String; Out_File : String; Table_Size : Integer;
                      Full : Float; Probe_Type : Probe; Hash_Type : Hash_Method;
                      Location : Implementation);

   -- implementation methods
   procedure Main_Memory(inFile : String; Table_Size : Integer; Full : Float;
                         Probe_Type : Probe; Hash_Type : Hash_Method);

   procedure File(inFile : String; Out_File : String; Table_Size : Integer; Full : Float;
                  Probe_Type : Probe; Hash_Type : Hash_Method);

   -- calculate number of probes
   procedure Probe_Average(Input : Hash_IO.File_Type; Storage : Output_IO.File_Type;
                           My_Table : Hash_Table; Lower : Integer; Upper : Integer;
                           Table_Size : Integer; Probe_Type : Probe;
                           Hash_Type : Hash_Method; Location : Implementation);

   procedure Probe_Theoretical(Table_Size : Integer; Keys : Integer; Probe_Type : Probe);

   -- get keys
   function Burris_Key(Item : Hash_Element) return Integer;
   function My_Key(Item : Hash_Element; Table_Size : Integer) return Integer;

   Calc_Table  : Hash_Table(1..2);    -- to calculate average
   Print_File  : Output_IO.File_Type; -- to output what is being printed to file

end hash;
