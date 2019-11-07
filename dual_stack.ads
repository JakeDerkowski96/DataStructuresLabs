generic
  LowerBound : Integer;
  UpperBound : Integer;             -- size of stack
  -- DagaKNT : Integer;
  type item is private;  -- type to stack
package dual_stack is
    function Stack_Is_Full return BOOLEAN;
    function Tie_Count return Integer;
    function Star_Count return Integer;
    function Space_Available return BOOLEAN;
    procedure Star_Push(x : in item);
	procedure Star_Pop(x  : out item);
    procedure Tie_Push(x  : in item);
    procedure Tie_Pop(x   : out item);
    end dual_stack;
