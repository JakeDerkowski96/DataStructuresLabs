package hetero_stack is
  type hetero_stack is limited private;
  type hetero_stackElement is tagged private;
  type hetero_stackElementPtr is -- is this what we dont need?
          access all hetero_stackElement'Class;

  procedure Push(Stack: access hetero_stack; Y: in hetero_stackElementPtr);
  function  Pop(Stack: access hetero_stack) return hetero_stackElementPtr;
  function  StackSize(Stack: hetero_stack) return Integer;

private
  type hetero_stackElement is tagged
    record
       Next: hetero_stackElementPtr;
    end record;

  type hetero_stack is limited
    record
      Count: Integer := 0;
      Top: hetero_stackElementPtr := null;
    end record;
end hetero_stack;
