bits 64
;    Compare natural logarithm from matlib and my own implementation

section .data
mode:
	db	"w", 0
shift:
	db	10, 0
format:
	db	"%lf", 0

msg0:
	db	"Input precison of calculations -> ", 0
msg1:
	db	"Input x -> ", 0
msg2:
	db	"%f", 0
msg3:
	db	"ln(1 + [%.6g]) = %.6lf", 10, 0
msg4:
	db	"my_ln(1 + [%.6g]) = %.6lf", 10, 0

err1:
	db	"Invalid value", 10, 0
err2:
	db	"Error opening file", 10, 0
err3:
	db	"Error! Filename is required!", 10, 0
section .text
one	dd	1.0
neg_one	dd	-1.0
zero	dd	0.0

x0	equ	8
x1	equ	x0+8
x2  equ x1+8
x3  equ x2+8
x4  equ x3+8
x5  equ x4+8
x6  equ x5+8
f 	equ	x6+8
my_ln:
	push	rbp
	mov rbp, rsp
	sub rsp, f
	mov     [rbp-f], edi
	movss   [rbp-x0], xmm0
	movss   [rbp-x1], xmm1
	mov	ebx, 1
	 	cvtss2sd        xmm0, xmm0
        	mov esi, msg2 ; %f instead %lf ???? wtf
        	mov eax, 1
        	call fprintf
            mov     edi, [rbp-f]
        	mov esi, shift
        	mov eax, 0
        	call fprintf
        	mov 	edi, [rbp-f]
	movss	xmm0, [rbp-x0]
	movss   xmm6, xmm0
	movss	xmm1, [rbp-x1]
	movss	xmm2, xmm0 ; accumulator
	movss	xmm3, [one]
	movss	xmm4, [one]
	mov     [rbp-f], edi
.m0:
	;movss	xmm6, xmm2
	mulss	xmm6, xmm0 ; x^n
	movss	xmm5, xmm6
	addss   xmm3, xmm4 ; xmm3+1
	divss	xmm5, xmm3 ; x^n / xmm3
		;	movss   [rbp-x0], xmm0
        ;	movss   [rbp-x1], xmm1
        	movss   [rbp-x2], xmm2
        	movss   [rbp-x3], xmm3
        	movss   [rbp-x4], xmm4
        	movss   [rbp-x5], xmm5
			movss   [rbp-x6], xmm6
        movss   xmm0, xmm5
        cvtss2sd	xmm0, xmm0
        mov esi, msg2
        mov eax, 1
        call fprintf
         	mov     edi, [rbp-f]
        mov esi, shift
        mov eax, 0
        call fprintf
	        	movss   xmm0, [rbp-x0]
                movss   xmm1, [rbp-x1]
                movss   xmm2, [rbp-x2]
                movss   xmm3, [rbp-x3]
                movss   xmm4, [rbp-x4]
                movss   xmm5, [rbp-x5]
                movss   xmm6, [rbp-x6]
                mov 	edi, [rbp-f]
	movss   xmm7, xmm5
	ucomiss	xmm7, [zero]
	jb 	.abs
	jmp 	.check
.abs:
	mulss	xmm7, [neg_one]
.check:
	ucomiss	xmm7, xmm1 ; сравнение члена ряда и точности
	jb 	.exit ; если член ряда меньше точности, то выходим
	test	ebx, 1
	jnz 	.odd
	addss	xmm2, xmm5
	jmp 	._inc
.odd:
	subss	xmm2, xmm5
._inc:
	inc 	ebx
	jmp 	.m0
.exit:
	;add 	rsp, 8
	movss	xmm0, xmm2
	leave
	ret

x	equ	4
y	equ	x+4
p 	equ y+4
fw	equ p+4

extern	printf
extern	scanf
extern	logf
extern	fprintf
extern	fopen
extern	fclose

global main
main:
	;mov 	rsi, 
	push	rbp
	mov	rbp, rsp
	sub	rsp, fw ; stack alignment
		cmp 	qword[rsp+fw], 2
		jne 	.ferr
		;mov 	rbx, [rsp+fw]
		mov 	rdi, [rsi+8]
		;mov 	rsi, [rsi]
		;mov 	rdi, [rsi-8]
	;mov rdi, filename ; open file 
	mov rsi, mode
	call fopen
	cmp	eax, 0 ; error opening
	je	.perr	
	mov [rbp-fw], eax ; 4 bytes
	mov	edi, msg1
	xor	eax, eax
	call	printf
	mov	edi, msg2
	lea	rsi, [rbp-x]
	xor     eax, eax
	call	scanf ; прочитали x
	movss	xmm0, [rbp-x] ; allow?
	ucomiss xmm0, [one]
	ja	.err
	ucomiss	xmm0, [neg_one]
	jbe .err 
	mov 	edi, msg0
	xor 	eax, eax
	call	printf
	mov 	edi, msg2
	lea 	rsi, [rbp-p]
	xor 	eax, eax
	call 	scanf ; прочитали точность p
	movss	xmm0, [rbp-p]
	ucomiss	xmm0, [zero]
	jbe 	.err
	movss 	xmm1, [one]
	movss	xmm0, [rbp-x]
	addss	xmm0, xmm1
	call	logf ; c-library function
	movss	[rbp-y], xmm0
	mov	edi, msg3
	movss	xmm0, [rbp-x]
	cvtss2sd xmm0, xmm0
	movss	xmm1, [rbp-y]
	cvtss2sd xmm1, xmm1
	mov	eax, 2
	call	printf
	movss	xmm0, [rbp-x]
	movss	xmm1, [rbp-p]
	mov 	edi,  [rbp-fw]	
	call	my_ln ; my own implementation
	movss	[rbp-y], xmm0
	mov	edi, msg4
	movss	xmm0, [rbp-x]
	cvtss2sd	xmm0, xmm0
	movss	xmm1, [rbp-y]
	cvtss2sd	xmm1, xmm1
	mov	eax, 2
	call	printf
	jmp 	._esc
.err:
	mov 	edi, err1
	xor 	eax, eax
	call	printf
	jmp 	._esc
.perr:
	mov 	edi, err2
	xor 	eax, eax
	call 	printf
	jmp 	._esc
.ferr:
	mov 	edi, err3
	xor 	eax, eax
	call 	printf
._esc:
	;mov rdi, [rbp-fw]
	;call fclose
	leave
	xor	eax, eax
	ret
