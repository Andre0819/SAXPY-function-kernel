section .data
msg1 db "Hello World!",10,0
msg2 db "The first fp number is %1.2lf",10,0
msg3 db "The fp numbers are %1.2lf and %1.2lf",10,0
msg4 db "The sum is %1.2lf",10,0
msg5 db "Five integers: %lld, %lld, %lld, %lld, %lld",10,0
var1 dq 0.0
var2 dq 0.0
var3 dq 0.0
var4 dq 111, 222, 333, 444, 555
prompt1 db "Type any character to continue...",10,0
prompt2 db "Enter a floating point number: ",0
prompt3 db "Enter another floating point number: ",0
;;
scanfp db "%lf",0
scanstr db "%s",0
;;
;;
section .text
bits 64
default rel
;
global demo
extern printf, scanf
demo:
mov rbp, rsp; for correct debugging
;write your code here
sub rsp, 8*7
;
mov rcx, msg1
call printf
;
;
mov rcx, prompt2 ;Enter a floating point number:
call printf
;
lea rdx, [var1]
mov rcx, scanfp
call scanf
;
mov rdx, [var1]
mov rcx, msg2 ;The first fp number is...
call printf
;
mov rcx, prompt3 ;Enter another ...
call printf
;
lea rdx, [var2]
mov rcx, scanfp
call scanf
;
mov r8, [var2]
mov rdx, [var1]
mov rcx, msg3 ;The fp numbers are ...
call printf
;;
movsd xmm1, [var1]
addsd xmm1, [var2]
movsd qword [var3], xmm1
mov rdx, [var3]
mov rcx, msg4 ;The sum is
call printf
;;
;;
mov rax, [var4+4*8] ;6th param
mov [rsp+40], rax
mov rax, [var4+3*8] ;5th param
mov [rsp+32], rax
mov r9, [var4+2*8] ;4th param
mov r8, [var4+1*8] ;3rd param
mov rdx, [var4] ;2nd param
mov rcx, msg5 ;1st param (Five integers:...)
call printf
;
mov rcx, prompt1 ;Type any character
call printf
mov rcx, scanstr
call scanf
;
add rsp, 8*7
ret
