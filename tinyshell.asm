BITS 64
org 0x400000

ehdr:
  db 0x7F, "ELF", 2, 1, 1, 0  ; 64-bit ELF
  times 8 db 0
  dw 2                         ; executable
  dw 0x3E                      ; x86-64
  dd 1
  dq _start
  dq phdr - ehdr
  dq 0
  dd 0
  dw 64
  dw 56
  dw 1
  dw 0
  dw 0
  dw 0

phdr:
  dd 1
  dd 7
  dq 0
  dq 0x400000
  dq 0x400000
  dq filesize
  dq filesize
  dq 0x1000

_start:
.loop:
  ; write(1, prompt, 2)
  mov rax, 1
  mov rdi, 1
  mov rsi, prompt
  mov rdx, 2
  syscall
  
  ; read(0, buffer, 255)
  xor rax, rax
  xor rdi, rdi
  mov rsi, buffer
  mov rdx, 255
  syscall
  
  test rax, rax
  jle .exit
  
  ; null terminate
  mov byte [buffer + rax - 1], 0
  
  ; fork
  mov rax, 57
  syscall
  
  test rax, rax
  jnz .parent
  
  ; Child: setup argv
  mov qword [argv], buffer
  mov qword [argv + 8], 0
  
  ; execve
  mov rax, 59
  mov rdi, buffer
  mov rsi, argv
  xor rdx, rdx
  syscall
  
  jmp .exit
  
.parent:
  ; wait4
  mov rax, 61
  mov rdi, -1
  xor rsi, rsi
  xor rdx, rdx
  xor r10, r10
  syscall
  
  jmp .loop

.exit:
  mov rax, 60
  xor rdi, rdi
  syscall

prompt: db "# "
buffer: times 256 db 0
argv: times 2 dq 0

filesize equ $ - ehdr
