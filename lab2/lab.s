bits    64
;       Sorting columns of matrix by max elements(insertion sort)
section .data
n:
        db      3
m:
        db      5
matrix:
        dd      4, 6, 1, 8, 3 
        dd      1, 2, 3, 4, -23
        dd      0, -7, 3, -1, 0
max:
        dd      0, 0, 0, 0, 0        
matrix_t:
		dd		0, 0, 0, 0, 0
		dd		0, 0, 0, 0, 0
		dd		0, 0, 0, 0, 0
adress:
		dd		0, 0, 0, 0, 0		
		
section .text
global  _start
_start:
		xor 	eax, eax
		movzx   eax, byte[m]
		movzx	ebx, byte[n]
		imul 	ebx
		imul    eax, 4
		mov 	ebx, matrix
		add     ebx, eax
		cmp     ebx, max
		jne     m8
        movzx   ecx, byte[m]
        cmp     ecx, 1
        jle     m8
        mov     ebx, matrix
        mov 	edx, adress
        xor 	edi, edi  
m0:		
		mov     [rdx + rdi*4], ebx
		inc 	edi
		add 	ebx, 4
		loop 	m0
		mov 	ebx, matrix	
		movzx	ecx, byte[m]		
m1:
        xor     edi, edi
        mov     eax, [rbx]
        push    rcx
        movzx   ecx, byte[n]
        dec     ecx
        jecxz   m3
m2:
        add     dil, [m]
        cmp     eax, [rbx+rdi*4]
        cmovl   eax, [rbx+rdi*4]
        loop    m2
m3:
        add     dil, [m]
        mov     [rbx+rdi*4], eax
        add     ebx, 4
        pop     rcx
        loop    m1
        xor     edi, edi						; max array was getted
        movzx   ecx, byte[m]
        dec     ecx
m4:
        inc     edi
        mov     eax, [rdi*4 + max]
        mov 	ebx, [rdi*4 + adress]
        mov     esi, edi
m5:
        dec     esi
        js 		.m5
        cmp     eax, [rsi*4 + max]
        %ifdef LESS
        jle		.m5
        %else   
        jge	    .m5	
        %endif				
        mov     edx, [max + rsi*4]
        mov     [max + rsi*4 + 4], edx
		mov     edx, [adress + rsi*4]			; adress array
		mov     [adress + rsi*4 + 4], edx
		jmp 	m5
.m5:	
		inc     esi
		mov     [max + rsi*4], eax
		mov  	[adress + rsi*4], ebx
		loop	m4        
		movzx 	ecx, byte[m]
		xor		ebx, ebx
m11:
		xor		edi, edi
		push 	rcx
		movzx	ecx, byte[n]
		mov     eax, [adress + 4*rbx]
m9:
		mov 	edx, [rax + 4*rdi]
		xor 	esi, esi
		add		esi, edi
		add		esi, ebx 
		mov 	[matrix_t + 4*rsi], edx
		add 	dil, byte[m]
		loop 	m9
m10:	
		pop 	rcx
		inc 	ebx
		loop 	m11
		movzx 	eax, byte[m]
		movzx	ebx, byte[n]
		mul 	ebx  
		mov 	rsi, matrix_t
		mov 	rdi, matrix
		mov 	rcx, rax
		rep 	movsd
			
m8:
        mov     eax, 60
        mov     edi, 0
        syscall
