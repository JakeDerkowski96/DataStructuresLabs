            ------------   binary_search_tree.ads   ------------

generic
   type key is private;
   type tree_rec is private;
   with function "<" (thekey : in key; Rec : tree_rec) return Boolean;
   with function ">" (thekey : in key ; Rec : tree_rec) return Boolean;
   with function "=" (thekey : in key; Rec : in tree_rec) return Boolean;

package binary_search_tree is
   subtype String10 is String(1..10);
   type TreePt is limited private;

   procedure InitBSTree;
   procedure Insert(Name : String10; Phone : String10);
   procedure Delete(Name : String10);
   function FindIterative(Name : String10) return TreePt;
   function FindRecursive(Name : String10) return TreePt;
   procedure InOrder(Name : String10);

   procedure ProOrder(Pntr : in TreePt);
   procedure PostOrderIter(Pntr : in TreePt);
   procedure PostOrderRecurs(Pntr : in TreePt);
   procedure InOrderReverse(Pntr : TreePt);
   function InOrderSucc(Pntr : in TreePt) return TreePt;
   function InOrderPred(Pntr : in TreePt) return TreePt;
   function CustomerName(Pntr : in TreePt) return String10;
   function CustomerPhone(Pntr : in TreePt) return String10;
   function Root return TreePt;
   procedure PrintInfo(Pntr : in TreePt);
   procedure FreeTree;

private
   type Node;
   type Customer is record
      Name  : String10;
      Phone : String10;
   end record;

   type TreePt is access Node;
   type Node is record
      Llink, Rlink : TreePt;
      Ltag, Rtag   : Boolean;      -- true = +; false = -
      Info         : Customer;
   end record;
end binary_search_tree;
