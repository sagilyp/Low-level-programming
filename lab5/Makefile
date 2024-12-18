CC = /usr/bin/cc
AS = /usr/bin/nasm
LD = /usr/bin/ld

CCFLAGS = -g -c -O0 -D STBI_ONLY_BMP -D STBI_NO_LINEAR
ASFLAGS = -g -f elf64
LDFLAGS = -static -z noexecstack

LIBPATH = -L /lib/gcc/x86_64-unknown-linux-gnu/13.2 -L /lib
OBJPATH = /usr/lib

LIBS = -lgcc -lgcc_eh -lc

PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

SRCS = lab5.c prog.c progasm.s
HEAD = prog.h stb_image.h stb_image_write.h Makefile
OBJS = lab5.o prog.o progasm.o

EXE = lab5

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.c.o:
	$(CC) $(CCFLAGS) $< -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

