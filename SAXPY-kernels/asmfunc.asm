
section .data
n dq 0
hold dq 0
results dq 0.0
msg1 db "Output Z (x86-64) --> %.2lf, %.2lf, %.2lf, %.2lf, %.2lf, %.2lf, %.2lf, %.2lf, %.2lf, %.2lf",10,0
msg2 db "test: %d", 10,0
msg3 db "float: %lf",10,0
param1 db "n: %d", 10, 0
param2 db "A: %lf", 10, 0
param3 db "pointer: %p", 10,0
section .text
bits 64
default rel

global saxpy_asm
extern printf, scanf
saxpy_asm:
    push r14
    push rbp
    mov rbp, rsp; for correct debugging
    add rbp, 16
    add rbp, 8
    sub rsp, 8*11
    ;write your code here
    
    
    mov rax, rcx      ; n (from RCX register)  
    movss xmm7, xmm1  ; A (from XMM0 register)
    mov r12, r8     ; X (from RDX register)
    mov r13, r9       ; Y (from R8 register)
    mov r14, [rbp+32]       ; Z (from R9 register) 
    
    mov qword [n], rax

    mov rbx, 0
    
    jmp SAXPY

SAXPY:
    cmp rbx, [n]
    je display_results
    
    movss xmm10, [r12 + 4*rbx]
    movss xmm11, [r13 + 4*rbx]
    
    vmulss xmm12, xmm10, xmm7
    addss xmm12, xmm11
    
    movss [r14+4*rbx], xmm12
    
    inc rbx
    jmp SAXPY
    
display_results:
    cmp rbx, 10
    jg reduce_to_10

    cmp rbx, 3
    jg store_other_vals
    
    cmp rbx, 3
    je store_3rd
    
    cmp rbx, 2
    je store_2nd
    
    cmp rbx, 1
    je store_1st
    
    cmp rbx, 0
    je end

    reduce_to_10:
        mov rbx, 10
        jmp store_other_vals
    
    store_other_vals:
        cmp rbx, 3
        je display_results

        mov rsi, rbx
        sub rsi, 1
        movss xmm13, [r14+4*rsi]
        cvtss2sd xmm13, xmm13
        movsd qword [results], xmm13

        mov rsi, rbx
        sub rsi, 4
        mov rax, [results]
        mov [rsp+32 + 8*rsi], rax
        

        dec rbx

        jmp store_other_vals
        
    store_3rd:
        movss xmm13, [r14+4*2]
        cvtss2sd xmm13, xmm13
        movsd qword [results], xmm13
        mov r9, [results]
    
    store_2nd:
        movss xmm13, [r14+4]
        cvtss2sd xmm13, xmm13
        movsd qword [results], xmm13
        mov r8, [results]
    
    store_1st:
        movss xmm13, [r14]
        cvtss2sd xmm13, xmm13
        movsd qword [results], xmm13
        mov rdx, [results]
    
    jmp end

end:
    mov rcx, msg1 ;The results are ...
    call printf
    
    add rsp, 8*11

    mov rax, r14

    pop rbp
    pop r14
    ret