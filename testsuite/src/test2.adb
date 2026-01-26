with Ada.Text_IO; use Ada.Text_IO;
with XDiff;       use XDiff;
with Utils;       use Utils;

procedure Test2 is
   Lines1 : Lines_Vector.Vector;
   Lines2 : Lines_Vector.Vector;
   File1  : constant String :=
     Read_File ("./resources/long_file.txt", Lines1);
   File2  : constant String :=
     Read_File ("./resources/long_file_formatted.txt", Lines2);
   Expected_Nb_Edits : constant Integer := 464;
begin
   Put_Line ("This is a performance test between 2 long files");
   Put_Line ("The diff will not be shown in the output.");

   declare
      Edit      : Edits := XDiff.XDiff (File1, File2, XDF_PATIENCE_DIFF);
      Cur       : Edits := XDIFF.First_Edit (Edit);
      Nb_Result : Integer := 0;
   begin
      Put_Line ("Finished computing the diff");
      --  Doing a simple loop on the result to check that the list is working
      loop
         Nb_Result := Nb_Result + 1;
         exit when not XDiff.Has_Next (Cur);
         Cur := XDiff.Next_Edit (Cur);
      end loop;

      Put_Line ("The number of textEdit is:" & Nb_Result'Image);
      Put_Line ("Expected number is:" & Expected_Nb_Edits'Image);
      Free_Edits (Edit);
   end;
end Test2;
