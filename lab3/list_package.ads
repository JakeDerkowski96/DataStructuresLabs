with Ada.Unchecked_Deallocation;

generic
   type Data is tagged limited private;
   with function "="(C,D: Data'Class) return Boolean;

package list_package is
   type DLList is private;
   type DataPtr is access all Data'Class;

   procedure Initialize(list: in out DLList);
   procedure ClearList(list: in out DLList);
   function ListSize(list: in DLList) return Integer;

   procedure InsertFront(list: in out DLList; Item: in DataPtr);
   procedure InsertRear(list: in out DLList; Item: in DataPtr);
   function Delete(list : in out DLList) return DataPtr;

   generic
   with procedure Process(D : Data'Class);
   procedure Iterate(list : in DLList);

   function FindItem(list : in DLList; C : DataPtr) return DataPtr;
   function PopItem(list : in out DLList; C : DataPtr) return DataPtr;

private
   type Element;
   type Element_Ptr is access Element;

   type Element is record
      Data : DataPtr;
      Next, Previous : Element_Ptr;
   end record;

   type DLList is record
      Knt : Integer := 0;
      Head : Element_Ptr;
   end record;
end list_package;
