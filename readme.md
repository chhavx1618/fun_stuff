# Tiny Shell (NASM)

A minimal Linux shell written entirely in NASM assembly.  
This project manually constructs a 32-bit ELF executable and uses raw `int 0x80` syscalls — no libc, no linker.

## Features
- Handcrafted ELF header + program header  
- `#` prompt loop  
- Reads input and executes commands  
- Uses `fork()`, `execve()`, `waitpid()`  
- Parent waits, child runs the command  
- Exits on empty input (Ctrl-D)  
- Pure 32-bit Linux userspace program  

## Build

Install NASM:
```bash
sudo apt install nasm
```

Assemble:
```bash
nasm -f bin tiny_shell.asm -o tiny_shell
chmod +x tiny_shell
```

## Run (native)
```bash
./tiny_shell
```

Then inside the shell:
```
# /bin/ls
# /bin/pwd
# /bin/whoami
```

## Running Inside an LXC Container

### 1. Install LXC
```bash
sudo apt update
sudo apt install lxc lxc-utils
```

Verify:
```bash
lxc-checkconfig
```

### 2. Create container
```bash
sudo lxc-create -n tinybox -t download -- --dist ubuntu --release focal --arch amd64
```

Start:
```bash
sudo lxc-start -n tinybox -d
```

Enter:
```bash
sudo lxc-attach -n tinybox
```

### 3. Build/copy shell inside container

If building inside:
```bash
apt update
apt install nasm
mount -o remount,exec /root
```

Exit:
```bash
exit
```

Push binary:
```bash
sudo lxc file push tiny_shell tinybox/root/
sudo lxc-attach -n tinybox
chmod +x /root/tiny_shell
```

### 4. Run inside container
```bash
cd /root
./tiny_shell
```

Examples:
```
# /bin/ls
# /bin/cat /etc/os-release
# /bin/pwd
```

## Video Demo
![Demo](https://raw.githubusercontent.com/chhavx1618/fun_stuff/main/Screencast%20from%202025-11-21%2000-27-16.gif)

Video:
https://raw.githubusercontent.com/chhavx1618/fun_stuff/main/Screencast%20from%202025-11-21%2000-27-16.webm

## Notes
- Flat binary loads at `0x08048000`
- Pure 32-bit syscalls
- No PATH search, args, or error handling
