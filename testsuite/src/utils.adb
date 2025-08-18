with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Utils is

   ---------------
   -- Read_File --
   ---------------

   function Read_File
     (Name  : String;
      Lines : out Lines_Vector.Vector)
      return String
   is
      Res : Unbounded_String;
      F   : File_Type;
   begin
      Lines := Lines_Vector.Empty_Vector;

      Open (F, In_File, Name);
      while not End_Of_File (F) loop
         declare
            Line : constant String := Get_Line (F);
         begin
            Lines.Append (Line);
            Append (Res, Line & ASCII.LF);
         end;
      end loop;
      Close (F);

      return To_String (Res);
   end Read_File;

   ------------------
   -- Output_Lines --
   ------------------

   procedure Output_Lines
     (Prefix     : String;
      Lines      : Lines_Vector.Vector;
      Start_Line : Integer;
      End_Line   : Integer) is
   begin
      if End_Line = -1 then
         return;
      end if;

      for Line in Start_Line .. End_Line loop
         Put_Line (Prefix & Lines.Element (Line));
      end loop;
   end Output_Lines;

end Utils;
