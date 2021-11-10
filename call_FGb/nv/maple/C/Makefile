CFLAGS := -m64 -w
CC:=gcc $(CFLAGS)
CPP:=g++ $(CFLAGS)
LIBDIR := macosx
LIBDIR := x64

# ----------------------------------------------------------------------
#
# Use FGb as a library: demo files
#
# ----------------------------------------------------------------------


# --------------------------------------------------

main:main.o gb1.o  gb2.o
	$(CPP)  -o $@ main.o gb1.o gb2.o -L$(LIBDIR) -lfgb -lfgbexp -lgb -lgbexp -lminpoly -lminpolyvgf -lgmp -lm -fopenmp

lib:combined.static
	ar rcs -o libfg.a combined.static

combined.static:combined.o fgb.o fgbint.o
	$(CPP) -static -o $@ -c combined.o fgb.o fgbint.o -L$(LIBDIR) -lfgb -lfgbexp -lgb -lgbexp -lminpoly -lminpolyvgf -lgmp -lm -fopenmp

main.static:main.o gb1.o  gb2.o
	$(CPP) -static -o $@ main.o gb1.o gb2.o -L$(LIBDIR) -lfgb -lfgbexp -lgb -lgbexp -lminpoly -lminpolyvgf -lgmp -lm -fopenmp

main.o:main.c
	$(CC) -I ../../protocol -I ../../int  -c $<

gb1.o:gb1.c
	$(CC) -I ../../protocol -I ../../int  -c $<

gb2.o:gb2.c
	$(CC) -I ../../protocol -I ../../int  -c $<

combined.o:combined.c
	$(CC) -I ../../protocol -I ../../int  -c $<

fgb.o:fgb.c
	$(CC) -I ../../protocol -I ../../int  -c $<

fgbint.o:fgbint.c
	$(CC) -I ../../protocol -I ../../int  -c $<

clean:
	-rm main main.static combined.static libfg.a *.o

veryclean:
	-rm main main.static main.o gb2.o gb1.o *~

test:main
	@echo "======================================================================"
	./main 1
	@echo "======================================================================"

