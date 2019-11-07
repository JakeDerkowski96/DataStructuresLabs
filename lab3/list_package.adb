with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body list_package is

   procedure Free is new Ada.Unchecked_Deallocation(Element, Element_Ptr);

   procedure Initialize(list : in out DlList) is     -- Initialize list
      Head : Element_Ptr := new Element;
   begin
      list.Knt := 0;       Head.Data := null;
      Head.Next := Head;   Head.Previous := Head;
      list.Head := Head;
   end;

   procedure ClearList(list : in out DLList) is    -- empty the list
      X: Element_Ptr;
   begin
      X := list.Head; Free(X); list.Head := null;
   end;

  function ListSize(list: in DLList) return Integer is
  begin return list.Knt; end ListSize;    -- get number of items in list

  procedure InsertFront(list: in out DLList; Item: in DataPtr) is
     newElem : Element_Ptr := new Element;
   begin
      newElem.Data := Item;
      newElem.Next := list.Head.Next;
      newElem.Previous := list.Head;
      newElem.Next.Previous := newElem;
      newElem.Previous.Next := newElem;
      list.Knt := list.Knt + 1;
   end;

  procedure InsertRear(list: in out DLList; Item: in DataPtr) is
     newElem : Element_Ptr := new Element;
  begin
     newElem.Data := Item;
     newElem.Previous := list.Head.Previous;
     newElem.Next := list.Head;
     newElem.Previous.Next := newElem;
     newElem.Next.Previous := newElem;
     list.Knt := list.Knt + 1;
  end;

  function Delete(list : in out DLList) return DataPtr is
     Elem : Element_Ptr;   Dptr : DataPtr;
   begin
      if list.Head.Next = list.Head then
         return null;
      end if;
      Elem := list.Head.Next;
      Elem.Next.Previous := list.Head;
      list.Head.Next := Elem.Next;
      Dptr := Elem.Data;   Free(Elem);
      list.Knt := list.Knt - 1;
      return Dptr;
   end;

   procedure Iterate(list : in DLList) is
      Elem: Element_Ptr;
   begin
      Elem := list.Head.Next;
      while Elem /= list.Head loop
         Process(Elem.Data.all);
         Elem := Elem.Next;   New_Line;
      end loop;
   end;

   function FindItem(list : in DLList; C : DataPtr) return DataPtr is
        Elem: Element_Ptr;
     begin
        Elem := list.Head.Next;
        while Elem /= list.Head loop
           if C.all = Elem.Data.all then
              return Elem.Data;
           end if;
           Elem := Elem.Next;
        end loop;
        return null;
     end;

     function PopItem(list : in out DLList; C : DataPtr) return DataPtr is
        Elem: Element_Ptr;    D : DataPtr;
     begin
        Elem := list.Head.Next;
        while Elem /= list.Head loop
           if C.all = Elem.Data.all then
              Elem.Previous.Next := Elem.Next;
              Elem.Next.Previous := Elem.Previous;
              D := Elem.Data; Free(Elem);
              list.Knt := list.Knt - 1;
              return D;
           end if;
           Elem := Elem.Next;
        end loop;
        return null;
     end;

end list_package;
