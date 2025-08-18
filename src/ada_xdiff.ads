--
--  Copyright (C) 2025, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

package Ada_XDiff is

   type XDIFF_FLAGS is mod 2 ** 24;
   XDF_NEED_MINIMAL             : constant XDIFF_FLAGS := 2 ** 0;
   XDF_IGNORE_WHITESPACE        : constant XDIFF_FLAGS := 2 ** 1;
   XDF_IGNORE_WHITESPACE_AT_EOL : constant XDIFF_FLAGS := 2 ** 3;
   XDF_PATIENCE_DIFF            : constant XDIFF_FLAGS := 2 ** 14;
   XDF_HISTOGRAM_DIFF           : constant XDIFF_FLAGS := 2 ** 15;
   XDF_INDENT_HEURISTIC         : constant XDIFF_FLAGS := 2 ** 23;
   
   type Edits_Opaque is limited private;
   type Edits is access all Edits_Opaque;
   pragma Convention (C, Edits);
   
   function XDiff 
     (File1   : String;
      File2   : String;
      Options : XDIFF_FLAGS) 
      return Edits;
   --  Call XDIFF to generate a diff between File1 and File2.
   --  Return a list of Edits the head is a fake node.
   --  The Diff result is stored in the C layer, can be accessed using
   --  First_Edit and must be freed by calling Free_Edits.
   
   function Delete_Line_Start (Edit : Edits) return Integer;
   --  Return the Start line in File1 which must be deleted
   --  If the value is -1, then there is no line which must be deleted
   --  and the insertion point is Delete_Line_End
   
   function Delete_Line_End (Edit : Edits) return Integer;
   --  Return the End line in File1 which must be deleted
   
   function Insert_Line_Start (Edit : Edits) return Integer;
   --  Return the Start line in File2 which must be inserted
   
   function Insert_Line_End (Edit : Edits) return Integer;
   --  Return the End line in File2 which must be inserted
   
   function Has_Next (Edit : Edits) return Boolean;
   --  Return True if there is another Edit
   
   function Is_Empty (Edit : Edits) return Boolean;
   --  Return True if Edit is empty
   
   function Next_Edit (Edit : Edits) return Edits;
   --  Return the next edit, Has_Next must be True
   
   procedure Free_Edits (Edit : Edits);
   --  Free edit and all its children
   
private
   
   type Edits_Opaque is null record;
   --  This is an opaque type any access to its value should be done via 
   --  a C call.
   
   pragma Import (C, Delete_Line_Start, "delete_line_start");
   pragma Import (C, Delete_Line_End, "delete_line_end");
   pragma Import (C, Insert_Line_Start, "insert_line_start");
   pragma Import (C, Insert_Line_End, "insert_line_end");
   pragma Import (C, Next_Edit, "next_edit");
   pragma Import (C, Free_Edits, "free_edits");
   
end Ada_XDiff;
