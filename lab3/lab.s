bits    64
;   Delete words in string where the first and last symbhols are different
;   input - command line, output - file
section .data
size    equ 15
namelen equ 256
anslen  equ 3
arg:
	db 	"OUT="
arglen 	equ $-arg
msg1:
    db  "Enter the text", 10
msg1len equ $-msg1
msg2:
    db  "Input filename for write", 10
msg2len equ $-msg2
msg3:
    db  "File exists. Rewrite? (Y/N)", 10
msg3len equ $-msg3
msg4:
	db	"END OF WORK", 10
msg4len	equ $-msg4
err2:
    db  "No such file or directory!", 10
err5:
	db 	"Input/otput error!", 10    
err13:
    db  "Permission denied!", 10
err17:
    db  "File exists!", 10
err21:
    db  "Is a directory!", 10
err36:
    db  "File name too long", 10
err150:
    db  "Program does not require more parameters!", 10
err151:
    db  "Error reading filename!", 10
err255:
    db  "Unknown error!", 10
errlist:
    times  2   dd  err255
    dd  err2
    times  2  dd  err255
    dd 	err5
    times  7  dd  err255
    dd  err13
    times  3   dd  err255
    dd  err17
    times  3   dd  err255
    dd  err21
    times  14  dd  err255
    dd  err36
    times  113 dd  err255
    dd  err150
    dd  err151
    times  154 dd  err255
name:
    times    namelen db 	0
ans:
    times   anslen  db      0
fdw:
    dd  -1
        
section .text
global _start
_start:
	mov rbx, [rsp]
	inc rbx
.A:
	inc rbx
	mov rsi, [rsp+8*rbx]
	cmp rsi, 0
	je 	.E
	mov rdi, arg
	mov rcx, arglen
	repe cmpsb
	jnz .A
	mov rdi, [rsp+8*rbx]
	;cmp qword[rsp], 1
	;je  .m0
	;mov rsi, [rsp+16]
	;mov	rdi, name
	;mov rcx, namelen
	;rep movsb
	;mov rdi, name
	;xor rcx, rcx
;L:	 
;	inc rcx
;	cmp byte[rdi+rcx], 0
;	jne L	
	;mov	qword[name], rdi
;	cmp dword[rsp], 2
;	je 	.m33
;error:
;	mov ebx, 150
;	jmp .m11
.C:
	cmp byte[rdi], 61; =
	je  .m3
	inc rdi
	jmp .C
;.m0:
;	mov eax, 1
;	mov edi, 1
;	mov esi, msg2
;	mov edx, msg2len
;	syscall
;	mov eax, 0
;	mov edi, 0
;	mov esi, name
;	mov edx, namelen
;	syscall
;	or eax,eax
;	jle .m1
;	cmp eax, namelen
;	jl .m2
.E:
	mov ebx, 151
	jmp .m11
;.m2:
;        mov     byte [rax+name-1], 0
 ;       ;mov 	edi, name
;.m33: 	
;		mov rbx, [rsp]
;		inc rbx
;.m333:
;		inc rbx
;		mov rsi, [rsp+rbx*8]
;		mov rdi, name
;		repe cmpsb
;		jnz .m333
;		mov rdi, [rsp+8*rbx]
;.m3333:
;		cmp byte[rdi], 61
;		je .m3
;		inc rdi
;		jmp .m3333
.m3:
		;mov     [name], rdi
		inc rdi
		push rdi
        mov     eax, 2
        ;mov     edi, name
        mov     esi, 0c1h
		mov 	edx, 600o
        syscall
        or      eax, eax
        jge     .m10
        cmp     eax, -17
		je 	.m6
		mov 	ebx, eax
        neg     ebx
        jmp     .m11
.m6:
        mov     eax, 1
        mov     edi, 1
        mov     esi, msg3
        mov     edx, msg3len
        syscall
        mov     eax, 0
        mov     edi, 0
        mov     esi, ans
        mov     edx, anslen
        syscall
        or      eax, eax
        jle     .m7
        cmp     eax, ans
        jl      .m8
.m7:
        mov     ebx, 17
        jmp     .m11
.m8:
        cmp     byte [ans], 'y'
        je      .m9
        cmp     byte [ans], 'Y'
        je      .m9
        mov     ebx, 17
        jmp     .m11
.m9:
        mov     eax, 2
        pop 	rdi
        ;mov     edi, name
        mov     esi, 201h
        syscall
        or      eax, eax
        jge     .m10
        mov     ebx, eax
        neg     ebx
        jmp     .m11
.m10:
        mov     [fdw], eax
        mov     esi, eax
        call    work
        mov     ebx, eax
        neg     ebx
.m11:
        or      ebx, ebx
        je      .m14
        mov     eax, 1
        mov     edi, 1
        mov     esi, [errlist+rbx*4]
        xor     edx, edx
.m12:
        inc     edx
        cmp     byte [rsi+rdx-1], 10
        jne     .m12
        syscall
.m14:
        cmp     dword [fdw], -1
        je      .m15
        mov     eax, 3
        mov     edi, [fdw]
        syscall
.m15:
		mov 	eax, 1
		mov 	edi, 1
		mov 	esi, msg4
		mov 	edx, msg4len
		syscall 
        mov     edi, ebx
        mov     eax, 60
        syscall

bufin   equ     size
bufout  equ     size+bufin
fw      equ     bufout+4
n 		equ 	fw+4; счетчик слов в строке
l       equ     n+4 ; счетчик букв в слове
;начало работы, оформляем вкид
work:
        push    rbp
        mov     rbp, rsp
        sub     rsp, l
        and		rsp, -8
        push    rbx
        mov     [rbp-fw], esi
        mov     dword [rbp-l], 0 
        mov 	eax, 1
        mov 	edi, 1
        mov 	esi, msg1
        mov 	edx, msg1len
        syscall
.m0:
		mov 	r14d, [rbp-n]
 		mov		ecx, [rbp-l]
        mov     eax, 0
		xor 	edi, edi
        lea     rsi, [rbp-bufin+rcx] ; +rcx
        mov		edx, size
        sub		edx, ecx
        je 		.m9	
        ;mov     edx, size
        syscall  ; прочитали
        or      eax, eax 
        jle     .m8 ; error, the end of work
        mov     ebx, [rbp-l]
        lea     rsi, [rbp-bufin+rbx] ; rsi - in
        lea     rdi, [rbp-bufout] ; rdi - out 
        mov     ecx, eax ; counter
        ;add 	ecx, ebx
.m1:
        mov     al, [rsi] ; read symbhol
        inc     rsi 
        cmp     al, 10
        je      .m4
        cmp     al, ' '
        je      .m4
        cmp     al, 9
        je      .m4
        or      ebx, ebx
        jne     .m3 ; что-то прочитали до этого
        mov 	r12b, al
      	jmp		.m3
.m3:
        inc     ebx ; symb count
        jmp     .m6
.m4:
        or		ebx, ebx
        je		.m5 ; 0 symb?
        push	rcx
        push	rax
        mov		ecx, ebx
        cmp		r12b, [rsi-2]
        jne		.m45
        or  	r14d, r14d
        je  	.m2
        mov 	byte[rdi], ' '
        inc 	rdi
.m2:
        mov     rax, rsi
        sub     rax, rcx
        dec		rax
        mov		dl, [rax]
        mov     [rdi], dl
        inc		rdi
        loop    .m2
        inc 	r14d
        ;mov		byte[rdi], ' '
        ;inc 	rdi     
.m45:
		pop 	rax
        pop		rcx; восстановили кол-во прочитанных символов
        xor     ebx, ebx
.m5:
        cmp		al, 10; \n?
        jne		.m6 ; no
        xor 	r14d, r14d
 ;       lea 	rdx, [rbp-bufout]
  ;      cmp		rdi, rdx
 ;       je		.m55
        mov		byte[rdi], 10 ; put \n
        inc 	rdi
       ;jmp		.m6
;.m55:	
;		mov		byte[rdi], 10
;		inc		rdi
;		jmp		.m6
.m6:
        loop	.m1
        cmp		ebx, 0
        je		.m65
        mov 	ecx, ebx
        xor		r13d, r13d
.m625:
		mov 	rax, rsi
		sub		rax, rcx
		mov		dl, [rax]
		mov 	byte[rbp-bufin+r13], dl
		inc 	r13
		loop 	.m625
	
.m65:
		mov     [rbp-l], ebx ; remember symb count
		mov 	[rbp-n], r14d
        lea     rsi, [rbp-bufout] ; записали адрес буфера ввода 
        mov     rdx, rdi
        sub     rdx, rsi ; посчитали размер буфера для записи
        mov     ebx, edx
.m7:
        mov     eax, 1
        mov     edi,[rbp-fw]
        syscall ; запись в файл
        or      eax, eax
        jl      .m8 ; ошибка записи
        sub     ebx, eax
        je      .m0
        lea     rsi, [rbp+rax-bufout]
        mov     edx, ebx
        jmp     .m7 ; запись оставшегося куска
.m9:
 		xor 	eax, eax
 		xor 	edi, edi
 		lea 	rsi, [rbp-bufin]
 		mov 	rdx, size
 		syscall
 		cmp 	byte[rbp-bufin+rax-1], 10
 		je 		.m85
 		mov 	edx, size
 		cmp 	edx, eax
 		je 		.m9
.m85:
		mov 	eax, -5
.m8:
        pop     rbx
        leave
        ret
