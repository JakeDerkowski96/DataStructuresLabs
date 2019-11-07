with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
package body topologicalsort_pkg is
  function INT_Ptr is new Ada.Unchecked_Conversion(Integer, NodePtr);

   procedure Init_Sort (Size : Integer) is
   begin
      declare -- step one: initialization of Linked List + Quene
         Front, Rear : Integer := 0;
         i : Integer := 0;
         tempTop : NodePtr;
         pred, succ : Integer;
         NA, KN : Integer := 0;
         Data : SortStructure(0..Size); 
         JobQ : JobQuene(0..Size) := (others => 0);
      begin
         Put("Enter the number of relations (Number of tasks): "); Get(NA);
         for i in 1..NA loop -- step two: get all of the relation
            Put("Enter the predeccessor (J): "); Get(pred);
            Put("Enter the successor (K): "); Get(succ);
            tempTop := Data(pred).Top;
            Data(pred).Top := new Node'(succ, tempTop);
            Data(succ).Count := Data(succ).Count + 1;
         end loop;

         KN := NA;

         for i in 1..Size loop
            if Data(i).Count = 0 then -- step three: links eligiable jobs to JobQ
               JobQ(Rear) := i;
               Rear := i;
            end if;
         end loop;
         Front := JobQ(0);

         while Front /= 0 loop  -- step four: perform the eligible actions
            tempTop := Data(Front).Top;
            while tempTop /= null loop
               KN := KN - 1; -- decrement number of jobs being waited on
               Data(tempTop.Suc).Count := Data(tempTop.Suc).Count - 1;
               if Data(tempTop.Suc).Count = 0 then  -- perform job
                  JobQ(Rear) := tempTop.Suc;
                  Rear := tempTop.Suc;
               end if;
               tempTop := tempTop.Next;
            end loop;
            Front := JobQ(Front);
         end loop;

         if KN = 0 then   -- step five:  check if sort was successful
           Put("Topological Sort has completed successfully."); new_line;
            Put("One possible solution: ");
            while JobQ(Front) /= 0 loop
               put(JobQ(Front), Width => 2);
               Front := JobQ(Front);
            end loop;
         else  --print a loop
            Put("The following nodes are in a loop: ");
            for k in 1..Size loop
               JobQ(k) := 0;
            end loop;

            for i in 1..Size loop
               tempTop := Data(i).Top;
               while tempTop /= null and then JobQ(i) = 0 loop
                  JobQ(i) := tempTop.Suc;
                  if tempTop /= null then
                     tempTop := tempTop.Next;
                  end if;
               end loop;
            end loop;

            i := 1;
            while JobQ(i) = 0 loop
               i := i + 1;
            end loop;

            loop
               Data(i).Top := INT_Ptr(1);
               i := JobQ(i);
            exit when Data(i).Top /= null;
            end loop;

            while Data(i).Top /= null loop
               put(Data(i).Top.Suc, width => 2);
               Data(i).Top := null;
               i := JobQ(i);
            end loop;

         end if;
       end;
   end Init_Sort;

end topologicalsort_pkg;
