--
--  Copyright (C) 2025, AdaCore
--
--  SPDX-License-Identifier: Apache-2.0
--

with Interfaces.C;         use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body Ada_XDiff is

   ---------
   -- Foo --
   ---------

   function XDiff
     (File1   : String;
      File2   : String;
      Options : XDIFF_FLAGS)
      return Edits
   is
      function Internal
        (File1   : Interfaces.C.Strings.chars_ptr;
         File2   : Interfaces.C.Strings.chars_ptr;
         Options : Integer) return Edits;
      pragma Import (C, Internal, "xdiff");

      F1   : Interfaces.C.Strings.chars_ptr := New_String (File1);
      F2   : Interfaces.C.Strings.chars_ptr := New_String (File2);
      Edit : constant Edits := Internal (F1, F2, Integer (Options));
   begin
      Free (F1);
      Free (F2);
      return Edit;
   end XDiff;

   --------------
   -- Has_Next --
   --------------

   function Has_Next (Edit : Edits) return Boolean
   is
      function Internal (Edit : Edits) return Interfaces.C.C_bool;
      pragma Import (C, Internal, "has_next");
   begin
      return Boolean (Internal (Edit));
   end Has_Next;

   --------------
   -- Is_Empty --
   --------------

   function Is_Empty (Edit : Edits) return Boolean
   is
      function Internal (Edit : Edits) return Interfaces.C.C_bool;
      pragma Import (C, Internal, "is_empty");
   begin
      return Boolean (Internal (Edit));
   end Is_Empty;

end Ada_XDiff;
