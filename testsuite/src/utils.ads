with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Utils is

   package Lines_Vector is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => String,
      "="          => "=");

   procedure Output_Lines
     (Prefix     : String;
      Lines      : Lines_Vector.Vector;
      Start_Line : Integer;
      End_Line   : Integer);

   function Read_File
     (Name  : String;
      Lines : out Lines_Vector.Vector)
      return String;

end Utils;
