bits 64

section .text
global _start
_start:
	call	func

	mov	rax, 60
	mov	rdi, 0
	syscall


size		equ	20
buf		equ	size
o_buf		equ	buf + size
func:
	push	rbp
	mov	rbp, rsp
	sub	rsp, o_buf

	mov	rax, 0
	mov	rdi, 0
	lea	rsi, [rbp - buf]
	mov	rdx, size
	syscall

	xor	r8, r8
	mov	rcx, rax
	xor	rax, rax
	xor	rdx, rdx
	lea	rdi, [rbp - o_buf]
.process:
	mov	al, byte[rsi]
	cmp	al, ' '
	je	.space
	cmp	al, 10
	je	.enter

	cmp	r8, 1
	je	.copy
	inc	r8
	inc	rsi
	loop	.process
	jmp	.enter

.copy:
	xor	r8, r8
	mov	byte[rdi], al
	inc	rdi
	inc	rsi
	inc	rdx
	dec	rcx
	or	rcx, rcx
	jnz	.process
	jmp	.enter

.space:
	mov	r8, 0
	inc	rsi
	dec	rcx
	or	rcx, rcx
	jnz	.process
	jmp	.writing

.enter:
	push	rbx
	xor	rbx, rbx
	mov	bl, 10
	mov	byte[rdi], bl
	inc	rdx
	inc	rdi
	jmp	.writing

.writing:
	mov	rax, 1
	mov	rdi, 1
	lea	rsi, [rbp - o_buf]
	syscall

.end:
	leave
	ret
