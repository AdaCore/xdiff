with Ada.Text_IO; use Ada.Text_IO;
with Ada_XDiff;   use Ada_XDiff;
with Utils;       use Utils;

procedure Test1 is
   Lines1 : Lines_Vector.Vector;
   Lines2 : Lines_Vector.Vector;
   File1  : constant String :=
     Read_File ("./resources/basic1.adb", Lines1);
   File2  : constant String :=
     Read_File ("./resources/basic2.adb", Lines2);
   Edit   : Edits := XDiff (File1, File2, XDF_PATIENCE_DIFF);
begin
   Put_Line ("This is a simple diff between 2 Ada files");
   Put_Line ("Diff Computed");

   declare
      Cur : Edits := Edit;
   begin
      while Ada_XDiff.Has_Next (Cur) loop
         --  Discard the first node which is fake
         Cur := Ada_XDiff.Next_Edit (Cur);

         Output_Lines
           ("- ", Lines1, Delete_Line_Start (Cur), Delete_Line_End (Cur));
         Output_Lines
           ("+ ", Lines2, Insert_Line_Start (Cur), Insert_Line_End (Cur));
      end loop;
   end;

   Free_Edits (Edit);
end Test1;
