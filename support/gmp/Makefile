TARGET = ../libtiny_gmp.a
OBJS = assert.o memory.o

# Try to locate the system libgmp.a using gcc.  When not found we
# still produce a minimal library containing only the objects in
# $(OBJS) so the build can continue (useful in minimal environments
# such as the Codex container).
LIBGMP := $(shell gcc -print-file-name=libgmp.a)

EXC_OBJS = \
	assert.o memory.o set_str.o dump.o inp_str.o out_str.o		\
	dump.o fac_ui.o inp_raw.o inp_str.o out_raw.o out_str.o dump.o	\
	sscanffuns.o vfscanf.o vscanf.o randlc.o set_d.o inp_str.o	\
	out_str.o set_str.o asprntffuns.o doprnt.o doprntf.o doprnti.o	\
	obprntffuns.o printf.o printffuns.o sprintf.o snprntffuns.o	\
	vasprintf.o vfprintf.o vsnprintf.o vsprintf.o doscan.o		\
	fscanf.o fscanffuns.o scanf.o set_d.o set_str.o sprintffuns.o	\
	vprintf.o sscanf.o vsscanf.o set_str.o

all: $(TARGET)

$(TARGET): $(OBJS)
	@if [ -f "$(LIBGMP)" ]; then \
	cp "$(LIBGMP)" $@ && \
	ar d $@ $(EXC_OBJS); \
	else \
	echo "Warning: libgmp.a not found; creating minimal $(TARGET)"; \
	ar rc $@; \
	fi
	ar r $@ $(OBJS)
	ranlib $@

clean:
	rm -f $(OBJS) *~

%.o: %.c
	gcc -DSTANDALONE -O3 -fomit-frame-pointer -c $< -o $@
