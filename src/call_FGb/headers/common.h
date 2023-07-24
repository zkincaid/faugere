#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "style.h"
#include "gmp.h"

#define MAPLE_FGB_BIGNNI 2

extern I32 FGb_internal_version();
extern I32 FGb_int_internal_version();

typedef void* Expos;
typedef void* Dpol;
typedef Dpol Dpol_INT;

#include "protocol_maple.h"


#if defined (__cplusplus)
extern "C"{
#endif


extern void threads_FGb(int t);

int FGb_verb_info = 0;

#ifndef CALL_FGB_DO_NOT_DEFINE
extern FILE* log_output;
void info_Maple(const char* s)
{
  if (FGb_verb_info)
    {
      fprintf(stderr,"%s",s);
      fflush(stderr);
    }
}

void FGb_int_error_Maple(const char* s)
{
  caml_failwith(s);
}

void FGb_error_Maple(const char* s)
{
  FGb_int_error_Maple(s);
}


extern int FGb_int_internal_threads(const int tr0);
extern int FGb_internal_threads(const int tr0);
void threads_FGb(int t)
{
  I32 code=FGb_int_internal_threads(t);
  code=FGb_internal_threads(t);
}

void FGb_checkInterrupt()
{
}

void FGb_int_checkInterrupt()
{
}

void FGb_push_gmp_alloc_fnct(void *(*alloc_func) (size_t),
			     void *(*realloc_func) (void *, size_t, size_t),
			     void (*free_func) (void *, size_t))
{
}

void FGb_pop_gmp_alloc_fnct()
{
}
#else
extern FILE* log_output;
#endif /* ndef CALL_FGB_DO_NOT_DEFINE */


#if defined (__cplusplus)
}
#endif
