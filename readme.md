# Tiny ELF Shell (NASM)

This is a minimal Linux shell written entirely in NASM assembly.  
It manually constructs a 32-bit ELF executable and runs using only raw `int 0x80` syscalls — no libc, no linker.

## Features
- Handcrafted ELF + Program Header  
- Simple `# ` prompt loop  
- Reads input and executes commands  
- Uses `fork()` + `execve()`  
- Parent waits, child executes  
- Exits on empty input (Ctrl-D)

## Build
```bash
nasm -f bin tiny_shell.asm -o tiny_shell
chmod +x tiny_shell

```

## Run
```bash
./tiny_shell

then run:
# /bin/ls
# /bin/pwd
# /bin/whoami
(give it full paths)
```

## Video demo



#### Note
Flat binary loaded at 0x08048000

Uses 32-bit Linux syscalls

No PATH search, no args, no error handling — extremely tiny demo shell
