bits 64
;    res = (c*a*b - c*d*e)/(a/b + c/d)
;    a, b - 16 bites
;    c, d, e - 32 bites
section .data
res: 
	dq 0
a:
	dw 100
b: 
	dw 100
c:
	dd -100
d:
	dd -100
e:
	dd 30
section .text
global _start
_start:
	movsx rsi, word[a]
	movsx rbx, word[b]
	movsx rcx, dword[c]
	movsx rdx, dword[d]
	movsx rdi, dword[e]
;	or rsi, rsi
;	jz zero
	or rbx, rbx
	jz zero
;	or rcx, rcx
;	jz zero
	or rdx, rdx
	jz zero
	mov rax, rsi	; rax = rsi = a
	imul rax, rbx	; rax = rax*rbx = a*b
	imul rax, rcx	; rax = rax*rcx = a*b*c
	mov r10, rdx	; r10 = rdx = d
	imul r10, rdi	; r10 = r10*rdi = d*e 
	imul r10, rcx	; r10 = r10*rcx = d*e*c
	jo overflow
	sub  rax, r10	; rax = rax-r10 = abc-cde
	jo overflow
	mov r8, rax		; r8 = rax = abc - cde
	mov r10, rcx	; r10 = rcx = c
	mov rax, rsi	; rax = rsi = a
	mov r12, rdx
	cqo 
	idiv rbx		; rax = rax/rbx = a/b
	mov r9, rax		; r9 = rax = a/b
	mov rax, rcx    ; rax = rcx = c
	cqo
	idiv r12        ; rax = c/d
	add rax, r9		; rax = rax+r9 = c/d + a/b
	jz zero
	xchg rax, r8
	cqo
	idiv r8			; rax = rax/r8 = (abc - cde)/(c/d + a/b)
	mov [res], rax
	mov edi, 0
	jmp end

overflow:
	mov edi, 2
	jmp end
	
zero:
	mov edi, 1
	jmp end

end:
	mov eax, 60
	syscall
