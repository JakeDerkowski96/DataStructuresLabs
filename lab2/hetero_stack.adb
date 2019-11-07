package body hetero_stack is
  procedure Push(Stack: access hetero_stack; Y: in hetero_stackElementPtr) is
    Pt: hetero_stackElementPtr;
  begin
    Y.Next := Stack.Top;  Stack.Top := Y;   Stack.Count := Stack.Count + 1;
  end Push;

  function Pop(Stack: access hetero_stack) return hetero_stackElementPtr is
   Pt: hetero_stackElementPtr;
  begin
   if Stack.Top = null then
     return null;
   end if;
   Stack.Count := Stack.Count - 1;
   Pt := Stack.Top;   Stack.Top := Stack.Top.Next;
  return Pt;
  end Pop;

  function StackSize(Stack: hetero_stack) return integer is
  begin   return Stack.Count;   end StackSize;

end hetero_stack;
