(lang dune 2.9)
(name faugere)

(license MIT)
(authors "John Cyphert")
(maintainers "github.com/cyphertjohn")
(homepage "github.com/cyphertjohn/faugere")
(bug_reports "github.com/cyphertjohn/faugere")

(package
 (name faugere)
 (synopsis "Provides an interface to a c library implementing Faugere's Grobner basis algorithms.")
 (depends
   (ctypes :build)
   (ctypes-foreign :build)
 )
)