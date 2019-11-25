               ------------   main.adb   ------------
with Ada.Text_IO; use Ada.Text_IO;
with binary_search_tree;

procedure main is

   type String10 is new String (1 .. 10);
   type Customer is record
      Name  : String10;
      Phone : String10;
   end record;


   function "<" (thekey : in String10; Rec : Customer) return Boolean is
   begin
      if thekey < Rec.Name then return true;
      else return false;
      end if;
   end;

   function ">" (thekey : in String10; Rec : Customer) return Boolean is
   begin
      if thekey > Rec.Name then return true;
      else return false;
      end if;
   end;

   function "=" (thekey : in String10; Rec : Customer) return Boolean is
   begin
      if thekey = Rec.Name then return true;
      else return false;
      end if;
   end;

   package BinTree is new binary_search_tree(String10, Customer, "<", ">", "=");
begin
   -- C OPTION DATA
   new_line;
   put_line("            C OPTION DATA");
   put_line("     --------------------------");
   new_line;

   -- # 1
   -- Insert the following data in the tree using InsertBinarySearchTree
   put_line("# 1 Inserting records into the Tree: ");
   BinTree.Insert("Moutafis  ", "295-1492  "); -- 1
   BinTree.Insert("Ikerd     ", "291-1864  "); -- 2
   BinTree.Insert("Gladwin   ", "295-1601  "); -- 3
   BinTree.Insert("Robson    ", "293-6122  "); -- 4
   BinTree.Insert("Dang      ", "295-1882  "); -- 5
   BinTree.Insert("Bird      ", "291-7890  "); -- 6
   BinTree.Insert("Harris    ", "294-8075  "); -- 7
   BinTree.Insert("Ortiz     ", "584-3622  "); -- 8
   delay Duration(1);  new_line;

   put("# 2 Iterative search for Ortiz: ");
   put_line(BinTree.CustomerPhone(BinTree.FindIterative("Ortiz     ")));
   delay Duration(1);  new_line;

   put("# 3 Recursive search for Ortiz: ");
   put_line(BinTree.CustomerPhone(BinTree.FindRecursive("Ortiz     ")));
   delay Duration(1);  new_line;

   put("# 4 Iterative search for Penton: ");
   put_line(BinTree.CustomerPhone(BinTree.FindIterative("Penton    ")));
   delay Duration(1);  new_line;

   put("# 5 Recursive search for Penton: ");
   put_line(BinTree.CustomerPhone(BinTree.FindRecursive("Penton    ")));
   delay Duration(1);  new_line;

   put_line("# 6 Inorder transversal, displaying records and beginning: ");
   BinTree.InOrder("Ikerd     ");  new_line;   delay Duration(1);  new_line;


   put_line("# 7 Inserting records into the Tree: ");
   BinTree.Insert("Avila     ", "294-1568  ");
   BinTree.Insert("Quijada   ", "294-1882  ");
   BinTree.Insert("Villatoro ", "295-6622  ");
   delay Duration(1);  new_line;


   put_line("# 8 InOrder transversal beginning with tree Root: ");  new_line;
   BinTree.InOrder("Avila     ");   delay Duration(1);  new_line;


   put_line("# 9 Preorder iterative transversal: ");   new_line;
   BinTree.ProOrder(BinTree.Root);   delay Duration(1);  new_line;

   put_line("# 10 PostOrder iterative transversal: ");    new_line;
   BinTree.PostOrderIter(BinTree.Root);   delay Duration(1);  new_line;

   -- B option
   new_line;
   put_line ("B OPTION DATA");
   put_line ("-------------");
   delay Duration(1);  new_line;

   put_line("# 7 Deleting records: "); new_line;
   delay Duration(1);  new_line;
   put_line("Could not get Delete to work properly for all of these nodes");
   -- BinTree.Delete("Robson    ");
   -- BinTree.Delete("Moutafis  ");
   -- BinTree.Delete("Ikerd     ");
   delay Duration(1);  new_line;


   put_line("# 8 Inserting records: ");
   BinTree.Insert("Poudel    ", "294-1666  ");
   -- put_line("Insert => Spell     , 295-1882  ");
   BinTree.Insert("Spell     ", "295-1882  ");
   delay Duration(1);  new_line;   new_line;


   put_line("# 9 InOrder Traversal from Root: ");   new_line;
   BinTree.InOrder(BinTree.CustomerName(BinTree.Root));
   delay Duration(1);  new_line;

   put_line("# 10 Reverse Transverse InOrder from Root: ");   new_line;
   BinTree.InOrderReverse(BinTree.Root);   delay Duration(1);  new_line;

   -- A option
   new_line;
   put_line ("A OPTION DATA");
   put_line ("-------------");
   delay Duration(1);  new_line;

   new_line;
   put_line("# 12 PostOrder iterative transversal: ");      new_line;
   BinTree.PostOrderIter(BinTree.Root);   delay Duration(1);  new_line;

   new_line;
   put_line ("# 13 Post Order Recursive Traversal: ");      new_line;
   BinTree.PostOrderRecurs(BinTree.Root);   delay Duration(1);  new_line;

   BinTree.FreeTree;
   delay Duration(1);
   new_line;

end main;
