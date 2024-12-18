AS = /usr/bin/nasm
LD = /usr/bin/ld

ASFLAGS = -g -f elf64
LDFLAGS = -static

SRCS = lab.s
OBJS = $(SRCS:.s=.o)

EXE1  = inc_lab
EXE2  = dec_lab

all: $(SRCS) $(EXE1)

clean:
	 rm -rf $(EXE1) $(EXE2) $(OBJS)

$(EXE1):# $(OBJS)
	$(AS) $(ASFLAGS) lab.s -o lab.o	
	$(LD) $(LDFLAGS) $(OBJS) -o $@

$(EXE2):# $(OBJS)
	$(AS) $(ASFLAGS) lab.s -d LESS -o lab.o	
	$(LD) $(LDFLAGS) $(OBJS) -o $@
	
#.s.o:
#	$(AS) $(ASFLAGS) $< -o $@	
