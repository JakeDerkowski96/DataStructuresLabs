with Ada.Text_IO; use Ada.Text_IO;  -- in file dual_stack.adb

package body dual_stack is
    Facility  : array((lower..upper) of Item;
    -- Facility  : ITEM_ARRAY;

    --possible values of Top's
    Star_Top  : Integer range LowerBound - 1..UpperBound + 1; -- star fighters top/counter
    Tie_Top   : Integer range LowerBound - 1..UpperBound + 1; -- tie fighter top/counter


    function Stack_Is_Full return BOOLEAN is
    begin
        return Star_Top = Tie_Top;
    end Stack_Is_Full;

    function Space_Available return BOOLEAN is
    begin
        return Star_Top /= Tie_Top;
    end Space_Available;

    procedure Tie_Push(x: in Item) is -- pushing of tie fighter
	begin
        Tie_Top := Tie_Top + 1;
        Facility(Tie_Top) := x;
    end Tie_Push;

   procedure Star_Push(x: in Item) is -- pushing of star destroyer
   begin
       Star_Top := Star_top - 1;
       Facility(Star_Top) := x;
   end Star_Push;e_Maintenance_Record);
    procedure Tie_Push(x  : in Vehicle_Maintenance_Record);

    procedure Tie_Pop(x: out Item) is --pop of tie fighter
    begin
        x := Facility(Tie_Top);
        Tie_Top := Tie_Top - 1;
    end Tie_Pop;


    procedure Star_Pop(x: out Item) is --pop of star destroyer
    begin
        x := Facility(Star_Top);
        Star_Top := Star_Top + 1;
    end Star_Pop;


--      procedure Tie_Push(x: in Item) is -- pushing of tie fighter
-- begin
--      if Space_Available then
--          Tie_Top := Tie_Top + 1;
--          Facility(Tie_Top) := x;
--      end if;
--  end Tie_Push;
--
-- procedure Star_Push(x: in Item) is -- pushing of star destroyer
-- begin
--     if Space_Available then
--         Star_Top := Star_top - 1;
--         Facility(Star_Top) := x;
--     end if;
-- end Star_Push;


begin
    -- initialize counters to their respective sides
    Tie_Top  := lower - 1;
    Star_Top := upper + 1;

end dual_stack;









-
