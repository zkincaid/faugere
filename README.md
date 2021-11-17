# Grobner basis calculation using FGB
This package provides a high-level ocaml interface to Faugere's [FGb library](https://www-polsys.lip6.fr/~jcf/FGb/index.html) for computing Grobner basis
of polynomials over either the rational numbers or a finite field. 

The original FGb library is distributed as a series of c archives and header files for linux and macosx. See src/bindings/call_FGb for more details.

## Dependencies
FGb uses gmp mpz to represent unbounded integers when computing a GB over the rational numbers, and is required for this package to build.

For ocaml opam is also helpful. To install these dependencies on Ubuntu run:

`sudo apt-get install opam libgmp-dev libmpfr-dev`

To initialize opam run:

`opam init`

To install dune run:

`opam install dune`

### Optional dependency Zarith
This package contains two public libraries. faugere, and optionally faugere.zarith. faugere contains an interface to both the rational and finite field versions of FGb. However, in that library the only way to interface to the rational version is by the use of strings. That is, coefficients are given as decimal strings. The conversion from these strings to gmp values gives a slight overhead. faugere.zarith provides the rational version of FGb using zarith values to represent coefficients. Since, zarith values are often gmp values already this translation should have less overhead. Thus, for computing Gb's over the rational field, faugere.zarith is recommended. faugere.zarith will be built and installed if you have zarith installed. Otherwise, only faugere will be installed.

To install zarith run:

`opam install zarith`

## Building
To build the libraries run:

`dune build`

## Installing
To install the library as a dev version through opam run:

`opam install .`

## Usage
If the package is installed, documentation can be viewed with `odig doc`. Or documentation can be build locally with `dune build @doc`, and then viewed in _build/default/_doc/_html.

example.ml gives an example of using faugere.zarith. To run use `dune exec ./example.exe`