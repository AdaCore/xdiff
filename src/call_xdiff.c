//
//  Copyright (C) 2025, AdaCore
//
//  SPDX-License-Identifier: Apache-2.0
//

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

#include "xdiff.h"

struct loc
{
  int start;
  int end;
};

struct edits
{
  struct loc delete;
  struct loc insert;
  struct edits *next;
};

int
delete_line_start (struct edits *edit)
{
  return edit->delete.start;
}

int
delete_line_end (struct edits *edit)
{
  return edit->delete.end;
}

int
insert_line_start (struct edits *edit)
{
  return edit->insert.start;
}

int
insert_line_end (struct edits *edit)
{
  return edit->insert.end;
}

bool
has_next (struct edits *edit)
{
  return edit->next != NULL;
}

static struct edits null_edit = {-1, -1, -1, -1, NULL};

bool
is_null_edit (struct edits *edit)
{
  //  Check the location and not next, we want to remove the header only
  return edit != NULL && edit->delete.start == null_edit.delete.start
         && edit->delete.end == null_edit.delete.end
         && edit->insert.start == null_edit.insert.start
         && edit->insert.end == null_edit.insert.end;
}

bool
is_empty (struct edits *edit)
{
  // Either the list is NULL or we have only the header and nothing after
  return edit == NULL || (is_null_edit (edit) && edit->next == NULL);
}

struct edits *
first_edit (struct edits *edit)
{
  // Remove the header
  if (is_null_edit (edit))
    {
      return edit->next;
    }
  return NULL;
}


struct edits *
next_edit (struct edits *edit)
{
  return edit->next;
}

void *
xmalloc (size_t len)
{
  void *p = malloc (len);
  return p;
}

void
free_edits (struct edits *head)
{
  struct edits *tmp;

  while (head != NULL)
    {
      tmp = head;
      head = head->next;
      free (tmp);
    }
}

int
add_edit (long start_a, long count_a, long start_b, long count_b, void *cb_data)
{
  int s1, e1, s2, e2;

  // Adjust the start-end ranges
  s1 = count_a ? start_a + 1 : start_a;
  e1 = start_a + count_a;

  s2 = count_b ? start_b + 1 : start_b;
  e2 = start_b + count_b;

  // Create the new edit
  struct edits *new_edit = malloc (sizeof (struct edits));

  if (count_a == 0)
    {
      // Nothing to delete, set to -1 to be explicit
      new_edit->delete.start = -1;
      new_edit->delete.end = e1;
    }
  else
    {
      new_edit->delete.start = s1;
      new_edit->delete.end = e1;
    }

  if (count_b == 0)
    {
      // Nothing to insert, set to -1 to be explicit
      new_edit->insert.start = -1;
      new_edit->insert.end = e2;
    }
  else
    {
      new_edit->insert.start = s2;
      new_edit->insert.end = e2;
    }

  new_edit->next = NULL;

  struct edits *head = (struct edits *)cb_data;
  if (head == NULL)
    {
      // No result yet, make it the head
      head = new_edit;
    }
  else
    {
      // Add it at the end of the list
      struct edits *lastNode = head;

      while (lastNode->next != NULL)
        {
          lastNode = lastNode->next;
        }
      lastNode->next = new_edit;
    }

  // Returning <0 would stop the diff
  return 1;
}

void
load_text_to_mmfile (mmfile_t *mf, char *text)
{
  size_t size = strlen (text);
  mf->size = size;
  mf->ptr = xmalloc (size);
  mf->ptr = text;
}

struct edits *
xdiff (char *file1, char *file2, int options)
{
  // Create the head of the list which is a fake edit
  struct edits *head = malloc (sizeof (struct edits));
  *head = null_edit;

  xpparam_t param = { 0 };
  xdemitconf_t econf = { 0, 0, 0, NULL, NULL, add_edit };
  xdemitcb_t ecb
    = { head, // Set head has the priv field of cb, it will be used as cb_data
        NULL, NULL };

  param.flags = options;

  mmfile_t f1, f2;
  load_text_to_mmfile (&f1, file1);
  load_text_to_mmfile (&f2, file2);

  xdl_diff (&f1, &f2, &param, &econf, &ecb);

  return head;
}
