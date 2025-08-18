//
//  Copyright (C) 2025, AdaCore
//
//  SPDX-License-Identifier: Apache-2.0
//

#include <stdbool.h>

struct edits;

int delete_line_start (struct edits *edit);
int delete_line_end (struct edits *edit);
int insert_line_start (struct edits *edit);
int insert_line_end (struct edits *edit);
bool has_next (struct edits *edit);
bool is_empty (struct edits *edit);

struct edits *next_edit (struct edits *edits);
void free_edits (struct edits *head);

struct edits *xdiff (char *file1, char *file2, int options);
