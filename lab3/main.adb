with list_package;
with Vehicles; use Vehicles;
with Ada.Unchecked_Deallocation;
with Ada.Text_IO; use Ada.Text_IO;

procedure main is
  type DLLPtr is access all Vehicle'Class;
  procedure Free is new Ada.Unchecked_Deallocation(Vehicle'Class, DLLPtr);

  procedure PrintedItem(pItem : Vehicle'Class) is
  begin  PrintItem(pItem);  end;

  function Is_Manuf(V : in Vehicle'Class; W : in Vehicle'Class) return Boolean is
  begin
     return Manuf(V, W);      -- manufracturer binds objects into a class
  end;

  package VehicleDLList is new list_package(Vehicle, Is_Manuf);
  use VehicleDLList;

  procedure PrintList is new Iterate(PrintedItem);

  list : DLList;
  V : access Vehicle'Class;
  C : access Car;
  P : access Plane;
  K : aliased Car;

  append_list : String := "Inserted =>  ";
  delete_list : String := "Removed =>  ";
  contents_list : String := "List contents: ";

begin
   Initialize(list); -- begin with null head node
   -- a
   C := new Car'(Doors => 4, Manu => "Ford");
   InsertRear(list, DataPtr(C));
   Put(append_list);  PrintedItem(C.all);  New_Line(2);

   --b
   C := new Car'(Doors => 2, Manu => "Ford");
   InsertFront(list, DataPtr(C));
   Put(append_list);  PrintedItem(C.all); New_Line(2);

   --c
   C := new Car'(Doors => 2, Manu => "GMC ");
   InsertRear(list, DataPtr(C));
   Put(append_list);  PrintedItem(C.all); New_Line(2);

   --d
   C := new Car'(Doors => 2, Manu => "RAM ");
   InsertRear(list, DataPtr(C));
   Put(append_list);  PrintedItem(C.all); New_Line(2);

   --e
   C := new Car'(Doors => 3, Manu => "Chev");
   InsertFront(list, DataPtr(C));
   Put(append_list);  PrintedItem(C.all); New_Line(2);

   --f
   Put_Line("List size: " & ListSize(list)'Img); New_Line;

   --g
   Put_Line(contents_list);
   PrintList(list); New_Line;

   --h
   K := Car'(-1, "Ford");
   V := FindItem(list, K'Access);
   V := PopItem(list, K'Access);
   Put(delete_list);  PrintedItem(V.all);  New_Line(2);

   --i
   Put_Line("List size: " & ListSize(list)'Img); New_Line;

   --j
   Put_Line(contents_list);
   PrintList(list);  New_Line;

   --k
   P := new Plane'(Doors => 3, Engines => 6,  Manu => "Boeing  ");
   InsertFront(list, DataPtr(P));
   Put(append_list);  PrintedItem(P.all); New_Line(2);

   --l
   P := new Plane'(Doors => 2, Engines => 1,  Manu => "Piper   ");
   InsertFront(list, DataPtr(P));
   Put(append_list);  PrintedItem(P.all); New_Line(2);

   --m
   P := new Plane'(Doors => 4, Engines => 4,  Manu => "Cessna  ");
   InsertFront(list, DataPtr(P));
   Put(append_list);  PrintedItem(P.all); New_Line(2);

   --n
   Put_Line(contents_list);
   PrintList(list); New_Line(2);
end main;
