with Ada.Text_IO; use Ada.Text_IO;
package Vehicles is
   type Vehicle is tagged null record;

   procedure PrintItem(V : in Vehicle);
   function Manuf(V : in Vehicle; W : in Vehicle'Class) return Boolean;

   type Car is new Vehicle with
   record
      Doors: Integer;
      Manu: String(1..4);
   end record;
   overriding procedure PrintItem(C : in Car);
   overriding function Manuf(C : in Car; W : in Vehicle'Class) return Boolean;

   type Plane is new Vehicle with
   record
      Doors: Integer;
      Engines: Integer;
      Manu: String(1..8);
   end record;
   overriding procedure PrintItem(P : in Plane);
   overriding function Manuf(P : in Plane; W : in Vehicle'Class) return Boolean;

end Vehicles;
