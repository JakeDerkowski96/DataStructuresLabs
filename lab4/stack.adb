package body stack is
   max       : Natural := stack_max;
   top       : Natural range 0 .. max := 0;
   overflow  : Boolean := false;
   underflow : Boolean := false;
   stack_arr : array (1 .. max) of Item;

   procedure set_max (new_max : in Natural) is
   begin   max := new_max;   end set_max;

   procedure push (new_item : in Item) is
   begin
      if (top < max) then underflow := false;
         top := top + 1;   stack_arr (top) := new_item;
      else
         overflow := true;   new_line;
         put_line("OVERFLOW: Stack is full.");
      end if;
   end push;

   function pop return Item is
      blank : Item;
   begin
      if (top > 0) then overflow := false;
         top := top - 1;   return stack_arr(top + 1);
      else
         underflow := true;   new_line;
         put_line("UNDERFLOW: Stack is empty.");
         return blank;
      end if;
   end pop;

   function peek return Item is
      blank : Item;
   begin
      if is_empty then return blank;
      else return stack_arr (top);
      end if;
   end peek;

   function is_empty return Boolean is
   begin
      if (top = 0) then return true;
      else return false;
      end if;
   end is_empty;

   function is_full return Boolean is
   begin
      if (top = max) then return true;
      else return false;
      end if;
   end is_full;

   function is_overflow return Boolean is
   begin
      if (overflow) then return true;
      else return false;
      end if;
   end is_overflow;

   function is_underflow return Boolean is
   begin
      if (underflow) then return true;
      else return false;
      end if;
   end is_underflow;

end stack;
