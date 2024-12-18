bits 64

section .data
msg1:
	db	"Enter string ->"
msg1_len	equ	$ - msg1

msg2:
	db	"Result string ->"
msg2_len	equ	$ - msg2
section .text
global _start
_start:
	call	func

	mov	rax, 60
	mov	rdi, 0
	syscall

size	equ	20
buf		equ	20
b_out		equ	40
func:
	push	rbp
	mov	rbp, rsp
	sub	rsp, b_out

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msg1
	mov	rdx, msg1_len
	syscall

	xor	rax, rax
	xor	rdi, rdi
	lea	rsi, [rbp - buf]
	mov	rdx, size
	syscall

	mov	rcx, rax
	xor	rax, rax
	mov	r8, 1; - flag
	lea	rdi, [rbp - b_out]
	xor	rdx, rdx
.process:
	mov	al, byte[rsi]
	cmp	al, ' '
	je	.increment
	cmp	al, 10
	je	.writing
	or	r8, r8
	jnz	.copy

	inc	rsi
	loop	.process
.increment:
	or	r8, r8
	jnz	.not_incr
	inc	r8

.not_incr:
	dec	rcx
	inc	rsi
	or	rcx, rcx
	jnz	.process
	jmp	.writing
.copy:
	mov	byte[rdi], al
	inc	rdx
	inc	rdi
	inc	rsi
	dec	rcx
	dec	r8
	or	rcx, rcx
	jnz	.process
	jmp	.writing
.enter:
	push	rbx
	xor	rbx, rbx
	mov	bl, 10
	mov	byte[rdi], bl
	inc	rdx
	pop	rbx
.writing:
	push	rax
	push	rdi
	push	rsi
	push	rdx

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msg2
	mov	rdx, msg2_len
	syscall

	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax

	mov	rax, 1
	mov	rdi, 1
	lea	rsi, [rbp - b_out]
	syscall

.end:
	leave
	ret


