(lang dune 2.9)
(name faugere)

(license MIT)
(authors "John Cyphert")
(maintainers "github.com/cyphertjohn")
(homepage "github.com/cyphertjohn/faugere")
(bug_reports "github.com/cyphertjohn/faugere")

(generate_opam_files false)

(package
 (name faugere)
 (synopsis "Provides an interface to a c library implementing Faugere's Grobner basis algorithms")
 (depends
   (ctypes (and :build (>= 0.22.0)))
   (ctypes-foreign (and :build (>= 0.22.0)))
   (ppx_cstubs :build)
 )
 (depopts
   (zarith :build)
 )
)