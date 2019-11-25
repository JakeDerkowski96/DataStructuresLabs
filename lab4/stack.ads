with Ada.Text_IO; use Ada.Text_IO;
with Unchecked_Conversion;

generic
   stack_max : Natural := 5;
   type Item is private;
package stack is
   procedure set_max (new_max : in Natural);
   procedure push (new_item : in Item);
   function pop return Item;
   function peek return Item;
   function is_empty return Boolean;
   function is_full return Boolean;
   function is_overflow return Boolean;
   function is_underflow return Boolean;
end stack;
