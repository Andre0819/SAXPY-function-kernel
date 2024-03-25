
section .data
n dq 3
A dd 2.0
X dd 1.0, 2.0, 3.0
Y dd 11.0, 12.0, 13.0
Z dd 0.0, 0.0, 0.0
hold dd 0x0
results dq 0.0
msg1 db "The results are %.2lf, %.2lf, %.2lf",10,0
section .text
bits 64
default rel

global saxpy_run
extern printf, scanf
saxpy_run:
    mov rbp, rsp; for correct debugging
    ;write your code here
    sub rsp, 8*5
    
    movss xmm3, [A]
    mov R12, X
    mov R13, Y
    mov R14, Z

    mov rbx, 0
    
    jmp SAXPY

SAXPY:
    cmp rbx, [n]
    je display_results
    
    
    movss xmm1, [r12 + 4*rbx]
    movss xmm2, [r13 + 4*rbx]
    
    vmulss xmm4, xmm1, xmm3
    addss xmm4, xmm2
    
    movss [r14+4*rbx], xmm4
    
    inc rbx
    jmp SAXPY
    
display_results:
    cmp ebx, 3
    jg store_other_vals
    
    cmp ebx, 3
    je store_3rd
    
    cmp ebx, 2
    je store_2nd
    
    cmp ebx, 1
    je store_1st
    
    cmp ebx, 0
    je end
    
    store_other_vals:
        cmp rbx, 3
        je display_results
    
        movss xmm1, [r14+4*rbx-1]
        cvtss2sd xmm2, xmm1
        movsd qword [results], xmm2
        mov rax, [results]
        mov [rsp+32+8*rbx-4], rax
        
        dec rbx
        jmp store_other_vals
        
    store_3rd:
        movss xmm1, [r14+4*2]
        cvtss2sd xmm2, xmm1
        movsd qword [results], xmm2
        mov r9, [results]
    
    store_2nd:
        movss xmm1, [r14+4]
        cvtss2sd xmm2, xmm1
        movsd qword [results], xmm2
        mov r8, [results]
    
    store_1st:
        movss xmm1, [r14]
        cvtss2sd xmm2, xmm1
        movsd qword [results], xmm2
        mov rdx, [results]
    
    jmp end

end:
    mov rcx, msg1 ;The results are ...
    call printf
    
    add rsp, 8*5
    ret