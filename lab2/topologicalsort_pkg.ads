with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Conversion;

package topologicalsort_pkg is
   type Node;
   type NodePtr is access all Node;

   type Node is record
      Suc : Integer;
      Next : NodePtr := null;
   end record;

   type Element is record
      Count : Integer := 0;
      Top : NodePtr := null;
   end record;


   function ElementPtr is new Ada.Unchecked_Conversion(Integer, NodePtr);
   type SortStructure is array(Integer range <>) of Element;
   type JobQuene is array(Integer range <>) of Integer;
   procedure Init_Sort(Size : Integer);

   end topologicalsort_pkg;
