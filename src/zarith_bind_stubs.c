
#include <ctypes_cstubs_internals.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <gmp.h>
#include <zarith.h>

#if !defined(__cplusplus)
#if defined(__clang__) && (__clang_major__ > 3 || ((__clang_major__ == 3) && (__clang_minor__ >= 3)))
#define DISABLE_CONST_WARNINGS_PUSH()                                   \
  _Pragma("clang diagnostic push")                                      \
  _Pragma("clang diagnostic ignored \"-Wincompatible-pointer-types-discards-qualifiers\"")
#define DISABLE_CONST_WARNINGS_POP()            \
  _Pragma("clang diagnostic pop")
#elif !defined(__clang__) && defined(__GNUC__) && ( __GNUC__ >= 5 )
#define DISABLE_CONST_WARNINGS_PUSH()                           \
  _Pragma("GCC diagnostic push")                                \
  _Pragma("GCC diagnostic ignored \"-Wdiscarded-qualifiers\"") \
  _Pragma("GCC diagnostic ignored \"-Wdiscarded-array-qualifiers\"")
#define DISABLE_CONST_WARNINGS_POP() \
    _Pragma("GCC diagnostic pop")
#endif
#endif

#ifndef DISABLE_CONST_WARNINGS_PUSH
#define DISABLE_CONST_WARNINGS_PUSH()
#endif

#ifndef DISABLE_CONST_WARNINGS_POP
#define DISABLE_CONST_WARNINGS_POP()
#endif

#ifndef CAMLdrop
#define CAMLdrop caml_local_roots = caml__frame
#endif

#ifdef __cplusplus
#define PPX_CSTUBS_ADDR_OF_FATPTR(typ,var)      \
  (typ)(CTYPES_ADDR_OF_FATPTR(var))
#else
#define PPX_CSTUBS_ADDR_OF_FATPTR(typ,var)      \
  CTYPES_ADDR_OF_FATPTR(var)
#endif

#ifndef CTYPES_PTR_OF_OCAML_BYTES
#ifdef Bytes_val
#define CTYPES_PTR_OF_OCAML_BYTES(s)   \
  (Bytes_val(Field(s, 1)) + Long_val(Field(s, 0)))
#else
#define CTYPES_PTR_OF_OCAML_BYTES(s) CTYPES_PTR_OF_OCAML_STRING(s)
#endif
#endif



#include <gmp.h>


DISABLE_CONST_WARNINGS_PUSH();
#ifdef __cplusplus
extern "C" {
#endif
value ppxc_zarith_bind_c_ee_mpz_clear(value);
#ifdef __cplusplus
}
#endif

value ppxc_zarith_bind_c_ee_mpz_clear(value ppxc__0)  {
  __mpz_struct* ppxc__1 = PPX_CSTUBS_ADDR_OF_FATPTR(__mpz_struct*,ppxc__0);
  mpz_clear(ppxc__1);
  return Val_unit;
}
DISABLE_CONST_WARNINGS_POP();


DISABLE_CONST_WARNINGS_PUSH();
#ifdef __cplusplus
extern "C" {
#endif
value ppxc_zarith_bind_e_12a_mpz_init(value);
#ifdef __cplusplus
}
#endif

value ppxc_zarith_bind_e_12a_mpz_init(value ppxc__0)  {
  CAMLparam1(ppxc__0);
  __mpz_struct* ppxc__1 = PPX_CSTUBS_ADDR_OF_FATPTR(__mpz_struct*,ppxc__0);
  mpz_init(ppxc__1);
  CAMLreturn(Val_unit);
}
DISABLE_CONST_WARNINGS_POP();


static void ppxc_zarith_bind_18_225_iset(value ppxc__var0_zt_, __mpz_struct* ppxc__var1_tptr_){

   value z = ppxc__var0_zt_; /* not converted. The usual rules for stub code must be
                      obeyed (accessors, memory management (GC), etc.) */
   __mpz_struct * p = ppxc__var1_tptr_; /* already converted to a native c type, will not
                                 be garbage collected during the stub code */
   ml_z_mpz_set_z(p, z);

}


DISABLE_CONST_WARNINGS_PUSH();
#ifdef __cplusplus
extern "C" {
#endif
value ppxc_zarith_bind_18_225_fset(value, value);
#ifdef __cplusplus
}
#endif

value ppxc_zarith_bind_18_225_fset(value ppxc__0, value ppxc__2)  {
  CAMLparam1(ppxc__2);
  value ppxc__1 = ppxc__0;
  __mpz_struct* ppxc__3 = PPX_CSTUBS_ADDR_OF_FATPTR(__mpz_struct*,ppxc__2);
  ppxc_zarith_bind_18_225_iset(ppxc__1, ppxc__3);
  CAMLreturn(Val_unit);
}
DISABLE_CONST_WARNINGS_POP();


static value ppxc_zarith_bind_27_3ff_ito_z(__mpz_struct* ppxc__var0_ptr_){

  return (ml_z_from_mpz(ppxc__var0_ptr_));

}


DISABLE_CONST_WARNINGS_PUSH();
#ifdef __cplusplus
extern "C" {
#endif
value ppxc_zarith_bind_27_3ff_fto_z(value);
#ifdef __cplusplus
}
#endif

value ppxc_zarith_bind_27_3ff_fto_z(value ppxc__0)  {
  CAMLparam1(ppxc__0);
  __mpz_struct* ppxc__1 = PPX_CSTUBS_ADDR_OF_FATPTR(__mpz_struct*,ppxc__0);
  value ppxc__2;
  value ppxc__3;
  ppxc__3 = ppxc_zarith_bind_27_3ff_ito_z(ppxc__1);
  ppxc__2 = ppxc__3;
  CAMLreturn(ppxc__2);
}
DISABLE_CONST_WARNINGS_POP();
