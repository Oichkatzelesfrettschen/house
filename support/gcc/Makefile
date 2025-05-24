# Newer 64-bit toolchains ship libgcc objects without the
# trailing 'S' in their file names.  Fall back to the plain
# '.o' names when the '.oS' variants are missing.
LIBGCC := $(shell gcc -print-libgcc-file-name)
ifeq ($(shell ar t $(LIBGCC) 2>/dev/null | grep -c _divdi3.oS),1)
OBJS = _divdi3.oS _moddi3.oS _udivdi3.oS _umoddi3.oS
else
OBJS = _divdi3.o _moddi3.o _udivdi3.o _umoddi3.o
endif

all:
	ar x $(shell gcc -print-libgcc-file-name) $(OBJS)
	ar rc ../libtiny_gcc.a $(OBJS)
	ranlib ../libtiny_gcc.a

clean:
	rm -f *~
