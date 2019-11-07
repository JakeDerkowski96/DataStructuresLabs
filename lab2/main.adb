with topologicalsort_pkg;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure main is
  Size  : Integer;
begin
  Put("How many jobs are there? (NA):  "); get(Size);
  topologicalsort_pkg.init_sort(Size);

end main;
