#include "list.h"
#include <stdlib.h>

void listAddData(listItem* start, void* data)
{
  //Recurse till next=0
  listItem* t=start, *tt;
  tt=malloc(sizeof(listItem));
  tt->data=data;
  tt->next=0;

  while(1)
  {
    if(!t->next)
    {
      t->next=tt;
      return;
    }
    t=t->next;
  }

}

void listRemoveItem(listItem* start, listItem* item)
{
  //Recurse till we find item
  listItem* l=start;
  listItem* prev=start;

  while(l=l->next)
  {
    if(l==item)
    {
      //Anyone after this?
      if(l->next)
      {
        prev->next=l->next;
      } else {
        prev->next=0;
      }
      return;
    }
    prev=l;
  }
}

listItem* initList()
{
  listItem* ptr = malloc(sizeof(listItem));
  ptr->next=0;
  ptr->data=0;
  return(ptr);
}

void freeList(listItem* start)
{
  //Recurse through list:
  listItem* next=start;
  listItem* t;
  while(1)
  {
    if(next->next)
    {
      t=next;
      next=next->next;
      free(t);
    } else {
      free(next);
      return;
    }
  }
}

int listSize(listItem* start)
{
  listItem* t=start;
  int items=0;
  while(t=t->next)
  {
    items++;
  }
  return(items);
}

void* listGetItemData(listItem* start, int index)
{
  listItem* t = start;
  int i=0;
  while(t=t->next)
  {
    if(i==index)
    {
      return(t->data);
    }
    i++;
  }
  return(0);
}
