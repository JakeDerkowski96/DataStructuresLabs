         ------------   binary_search_tree.adb   ------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with stack;

package body binary_search_tree is
   knt       : Integer := 1;
   Head      : TreePt;
   RecursPt  : TreePt;

   procedure Free is new Ada.Unchecked_Deallocation(Node, TreePt);

   procedure InitBSTree is
   begin
      Head := new Node;
      Head.Llink := Head;   Head.Rlink := Head;
      Head.Ltag  := false;   Head.Rtag  := true;
      RecursPt := Head.Llink;
   end InitBSTree;

   procedure Insert(Name : String10; Phone : String10) is
      P, Q : TreePt;
   begin
      P := new Node;
      P.Info.Name  := Name;
      P.Info.Phone := Phone;

      if "=" (Head.Llink, Head) then -- first node
         P.Llink := Head;   P.Rlink := Head;
         P.Ltag  := false;   P.Rtag  := false;
         Head.Llink := P;   Head.Ltag  := true;
         knt := knt + 1;

         new_line; put("Inserted => "); put (Name); new_line;
      else
         knt := knt + 1;
         new_line; put("Inserted => "); put (Name); new_line;

         Q := Head.Llink;

         loop
            if "<" (Name, Q.Info.Name) then
               if Q.Ltag /= false then Q := Q.Llink;
               else
                  P.Llink := Q.Llink;   P.Ltag  := Q.Ltag;

                  Q.Llink := P;   Q.Ltag := true;
                  P.Rlink := Q;   P.Rtag := false;
                  exit;
               end if;
            elsif ">" (Name, Q.Info.Name) or "=" (Name, Q.Info.Name) then
               if Q.Rtag /= false then Q := Q.Rlink;
               else
                  P.Rlink := Q.Rlink;   P.Rtag  := Q.Rtag;

                  Q.Rlink := P;   Q.Rtag := true;
                  P.Llink := Q;   P.Ltag := false;
                  exit;
               end if;
            end if;
         end loop;
      end if;
   end Insert;

   procedure Delete(Name : String10) is
      Q, P, tmp : TreePt;
   begin
      Q := FindIterative(Name);
      if Q.Info.Phone = "          " then return; -- = "not found"
      end if;

      tmp := Q;
      P := Q;

      if P /= Root then
         while P.Llink /= Q and P.Rlink /= Q loop
            if P = Head then P := Head.Llink;
            else P := InOrderSucc(P);
            end if;
         end loop;
      else
         P := Head;
      end if;

      if tmp.Rtag = false then Q := tmp.Llink;
         if Q = Head then Q := Head.Llink;
         end if;
      else
         if tmp.Ltag = false then Q := tmp.Rlink;
            if Q = Head then Q := Head.Llink;
            end if;
         end if;
      end if;

      if P = Head then Head.Llink := Q;
      else
         if P.Llink = tmp then P.Llink := Q;
            P.Ltag  := tmp.Ltag;
         else
            P.Rlink := Q;   P.Rtag  := tmp.Rtag;
         end if;
      end if;

      Free(tmp);
      knt := knt - 1;
      new_line;  put("Deleted: "); put(Name); new_line;

   end Delete;

   function FindIterative(Name : String10) return TreePt is
      P, blank : TreePt;
      Cust : Customer;
   begin
      Cust.Name := Name; Cust.Phone := "          ";
      P := Head.Llink;

      loop
         if "<" (Name, P.Info.Name) then
            if P.Ltag /= false then P := P.Llink;
            else
               new_line; put(Name); put(" not found"); new_line;

               P := new Node;
               P.Info := Cust;

               return P;
            end if;
         elsif ">" (Name, P.Info.Name) then
            if P.Rtag /= false then P := P.Rlink;
            else
               new_line; put(Name); put(" not found"); new_line;

               P := new Node;
               P.Info := Cust;

               return P;
            end if;
         elsif "=" (Name, P.Info.Name) then
            return P;
         else
            new_line; put(Name); put(" not found"); new_line;

            P := new Node;
            P.Info := Cust;

            return P;
         end if;
      end loop;
   end FindIterative;

   function FindRecursive(Name : String10) return TreePt is
      P : TreePt;
      Cust : Customer;
   begin
      Cust.Name := Name;
      Cust.Phone := "          ";

      if RecursPt = Head then RecursPt := Head.Llink;
      end if;

      loop
         if "<" (Name, RecursPt.Info.Name) then
            if RecursPt.Ltag /= false then RecursPt := RecursPt.Llink;
               return FindRecursive(Name);
            else
               new_line; put(Name); put(" not found"); new_line;

               P := new Node;
               P.Info := Cust;

               return P;
            end if;
         elsif ">" (Name, RecursPt.Info.Name) then
            if RecursPt.Rtag /= false then RecursPt := RecursPt.Rlink;
               return FindRecursive (Name);
            else
               new_line; put(Name); put(" not found"); new_line;

               P := new Node;
               P.Info := Cust;

               return P;
            end if;
         else
            return RecursPt;
         end if;
      end loop;
   end FindRecursive;

   procedure InOrder(Name : String10) is
      Node : TreePt;
   begin
      Node := FindIterative(Name);

      while Node.Ltag = true loop -- search left
         Node := Node.Llink;
      end loop;

      for i in 1 .. knt - 1 loop
         PrintInfo(Node);
         Node := InOrderSucc(Node);
      end loop;
   end InOrder;

   procedure ProOrder(Pntr : in TreePt) is
      P : TreePt;
      package stk is new stack(20, TreePt);
   begin
      P := Pntr;

      loop  -- Visit
         if P /= Head then PrintInfo(P);
            stk.push(P);
         end if;

         if P.Ltag = true then
            exit when P.Llink = Pntr;
            P := P.Llink;
         else
            while P.Rtag = false loop
               P := P.Rlink;
            end loop;

            if P.Rlink = Pntr then exit;
            end if;
            P := P.Rlink;
         end if;
      end loop;
   end ProOrder;

   procedure PostOrderIter(Pntr : in TreePt) is
      P : TreePt;
      type stk_rec is record
         pnt : TreePt;
         num : Natural range 0..1;
      end record;
      Rec : stk_rec;
      d   : Natural range 0..1;
      i   : Natural := 0;
      package stk is new stack (20, stk_rec);
   begin
      P := Pntr;
      loop
         if P /= null then
            Rec.pnt := P;   Rec.num := 0;
            stk.push(Rec);

            if P.Ltag = false then P := null;
            else P := P.Llink;
            end if;
         else
            exit when stk.is_empty = true;
            Rec := stk.pop;
            P := Rec.pnt;    d := Rec.num;

            if d = 0 then
               Rec.pnt := P;   Rec.num := 1;
               stk.push(Rec);

               if P.Rtag = false then P := null;
               else P := P.Rlink;
               end if;
            else
               loop
                  PrintInfo(P);
                  i := i + 1;

                  if i = knt - 1 then return;
                  end if;

                  exit when stk.is_empty = true;
                  Rec := stk.pop;
                  P := Rec.pnt;   d := Rec.num;

                  if d = 0 then
                     Rec.pnt := P;   Rec.num := 1;
                     stk.push(Rec);

                     if P.Rtag = false then P := null;
                     else P := P.Rlink;
                     end if;
                  end if;
                  exit when d = 0;
               end loop;
            end if;
         end if;
      end loop;
   end PostOrderIter;

   type stk_rec is record
      pnt : TreePt;
      num : Natural range 0..1;
   end record;
   package PostOrderStack is new stack(20, stk_rec);
   i : Natural := 0;
   PostOrderComplete : Boolean := false;

   procedure PostOrderRecurs(Pntr : in TreePt) is
      P : TreePt;
      Rec : stk_rec;
      d   : Natural range 0 .. 1;

      procedure reset is
         Wipe : stk_rec;
      begin
         i := 0;

         if PostOrderStack.is_empty = false then
            while PostOrderStack.is_empty = false loop
               Wipe := PostOrderStack.pop;
            end loop;
         end if;
      end reset;

   begin
      P := Pntr;
      loop
         if P /= null then
            Rec.pnt := P;   Rec.num := 0;
            PostOrderStack.push(Rec);

            if P.Ltag = false then PostOrderRecurs(null);
               if PostOrderComplete = true then reset;
                  return;
               end if;
            else
               PostOrderRecurs(P.Llink);
               if PostOrderComplete = true then reset;
                  return;
               end if;
            end if;
         else
            exit when PostOrderStack.is_empty = true;
            Rec := PostOrderStack.pop;
            P := Rec.pnt;   d := Rec.num;

            if d = 0 then
               Rec.pnt := P;   Rec.num := 1;
               PostOrderStack.push(Rec);

               if P.Rtag = false then PostOrderRecurs(null);
                  if PostOrderComplete = true then return;
                  end if;
               else
                  PostOrderRecurs (P.Rlink);
                  if PostOrderComplete = true then return;
                  end if;
               end if;
            else
               loop
                  PrintInfo (P);
                  i := i + 1;

                  if i = knt - 1 then PostOrderComplete := true;
                     reset;  return;
                  end if;

                  exit when PostOrderStack.is_empty = true;
                  Rec := PostOrderStack.pop;
                  P   := Rec.pnt;   d := Rec.num;

                  if d = 0 then
                     Rec.pnt := P;   Rec.num := 1;
                     PostOrderStack.push (Rec);

                     if P.Rtag = false then PostOrderRecurs (null);
                        if PostOrderComplete = true then return;
                        end if;
                     else
                        PostOrderRecurs (P.Rlink);
                        if PostOrderComplete = true then return;
                        end if;
                     end if;
                  end if;
                  exit when d = 0;
               end loop;
            end if;
         end if;
      end loop;
   end PostOrderRecurs;

   j : Integer := 1;
   procedure InOrderReverse(Pntr : TreePt) is
      Q : TreePt;
   begin
      Q := Pntr;

      if Q.Rtag = true then InOrderReverse(Q.Rlink); -- Right
         if j > knt - 1 then return;
         end if;
      end if;

      PrintInfo (Q);

      j := j + 1;
      if j > knt - 2 then return;
      end if;

      if Q.Ltag = true then InOrderReverse(Q.Llink);
         if j > knt - 2 then return;
         end if;
      end if;
   end InOrderReverse;

   function InOrderSucc(Pntr : in TreePt) return TreePt is
      Q : TreePt;
   begin
      Q := Pntr.Rlink;

      if Q = Head then
         while Q.Ltag = true loop
            Q := Q.Llink;
         end loop;
      end if;

      if Pntr.Rtag = false then return Q; -- for thread
      else
         while Q.Ltag = true loop
            Q := Q.Llink;
         end loop;

         return Q;
      end if;
   end InOrderSucc;

   function InOrderPred(Pntr : in TreePt) return TreePt is
      Q : TreePt;
   begin
      Q := Pntr.Llink;

      if Q = Head then
         while Q.Rtag = true loop
            Q := Q.Rlink;
         end loop;
      end if;

      if Pntr.Ltag = false then return Q;       -- if a thread
      else
         while Q.Rtag = true loop
            Q := Q.Rlink;
         end loop;

         return Q;
      end if;
   end InOrderPred;


   function CustomerName (Pntr : in TreePt) return String10 is
   begin   return Pntr.Info.Name;   end CustomerName;

   function CustomerPhone (Pntr : in TreePt) return String10 is
   begin      return Pntr.Info.Phone;       end CustomerPhone;

   function Root return TreePt is
   begin      return Head.Llink;   end Root;

   procedure PrintInfo (Pntr : TreePt) is
   begin
      put_line("Name: " & Pntr.Info.Name & "  Phone: " & Pntr.Info.Phone);
   end PrintInfo;

   procedure FreeTree is
      Q, P : TreePt;
   begin
      Q := Root;
      while Q.Ltag = true loop
         Q := Q.Llink;
      end loop;

      P := InOrderSucc (Q);

      new_line;   put_line ("Deallocating all tree nodes...");
      for i in 1 .. knt - 1 loop
         Free (Q);
         Q := P;
         P := InOrderSucc (P);
      end loop;
      new_line;

      put ("Pulling the Root from the tree...      ");
      Free (Head); put("Done.");   new_line;
      put_line("Binary Tree successfully completed.");
   end FreeTree;
   begin
      InitBSTree;
   end binary_search_tree;
