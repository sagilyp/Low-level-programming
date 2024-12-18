section .data
matrix db 1, 4, 6, 4, 1, 4, 16, 24, 16, 4, 6, 24, 36, 24, 6, 4, 16, 24, 16, 4, 1, 4, 6, 4, 1

section .text
global blurasm
string equ 8
width equ string+8
height equ width+8
channels equ height+8
res equ channels+8
blurasm:
    push rbp
    mov rbp, rsp
    sub rsp, res
    and rsp, -8
    push rbx
    mov [rbp - string], rdi
    mov [rbp - width], rsi
    mov [rbp - height], rdx
    mov [rbp - channels], rcx
    mov [rbp - res], r8
    mov rsi, rdi
    mov rdi, r8
    xor r9, r9
.m1:
    cmp r9, [rbp - height]
    je .m0 ; exit
    xor r10, r10
.m2:    
    cmp r10, [rbp - width]
    jne .m3
    inc r9
    jmp .m1
.m3:    
    or r9, r9
    je .m4 ; r9 == 0
    or r10, r10 ; r10 == 0
    je .m4
    mov rax, [rbp - height]
    dec rax
    cmp r9, rax 
    je .m4
    mov rax, [rbp - width]
    dec rax
    cmp r10, rax
    je .m4
    jmp .m5
.m4:
    mov rcx, [rbp - channels]
    rep movsb
    inc r10
    jmp .m2
.m5:
    xor rax, rax
    xor rcx, rcx; counter of channels 
.m6:
    mov r8, -2; k строка
.m7:
    cmp r8, 2
    jg .m11
    mov r11, -2 ; l столбец
.m8:    
    cmp r11, 2
    jle .m9
    inc r8
    jmp .m7
.m9:    
    mov rdx, r8
    add rdx, r9
    jl .m10
    cmp rdx, [rbp - height]
    jge .m10
    mov rdx, r11
    add rdx, r10
    jl .m10
    cmp rdx, [rbp - width]
    jge .m10
    mov rdx, r8
    imul rdx, [rbp - width]
    add rdx, r11
    imul rdx, [rbp - channels]
    add rdx, rsi
    movzx rbx, byte[rdx]
    mov rdx, r8
    add rdx, 2
    imul rdx, 5
    add rdx, r11
    add rdx, 2
    movzx rdx, byte[matrix + rdx]
    imul rbx, rdx
    add rax, rbx
.m10:
    inc r11
    jmp .m8
.m11:
    mov rbx, 256
    cqo
    div rbx
    mov [rdi], al
    inc rsi
    inc rdi
    inc rcx
    cmp rcx, [rbp - channels]
    jne .m6
    inc r10
    jmp .m2
.m0:    
    pop rbx
    leave
    ret
