# Laborator 1

## Exercise 1 - Inspecting Virtual Memory
### [Q1]: Where is each section mapped? Try using the `search` command in `pwndbg` (or `search-pattern` in `GEF`).
```python
             Start                End Perm     Size Offset File
          0x400000           0x401000 r--p     1000      0 /home/radu/osds-lab/lab1/bin/ex1
          0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
          0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x403000           0x404000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```

### Solution to [Q1]:
`.bss` and `.data` are mapped into the same segment. We can either check the virtual memory map pages for read-write permissions or use the `search` command to find a string in the data section.
```python
0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```

This is the only section in `ex1` with read-write permissions. Also, when we run `search Where`, it returns the address `0x404010`, confirming that the `.bss` and `.data` sections are mapped between `0x404000` and `0x405000`.

The `.text` section should have the execute permissions and the only range with that permission is from `0x401000` to `0x402000`.
```python
0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
```

We add a new constant variable `const int rodata` to track the location of the `.rodata` section. By using the `x` command, we find its address:
```python
pwndbg> x rodata
0x402004 <rodata>:      "rodata"
```
The `.rodata` section is located between `0x402000` and `0x403000`, which indeed has read-only permissions:
```python
0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
```


### [Q2]: Try finding the address of bar() in gdb and printing its disassembly.

### Solution to [Q2]:
We will use the `info address` command:
> Displays the address of a given symbol

```python
pwndbg> info address bar
Symbol "bar" is a function at address 0x401136.
```

```python
pwndbg> disassemble bar
Dump of assembler code for function bar:
   0x0000000000401136 <+0>:     endbr64
   0x000000000040113a <+4>:     push   rbp
   0x000000000040113b <+5>:     mov    rbp,rsp
   0x000000000040113e <+8>:     sub    rsp,0x20
   0x0000000000401142 <+12>:    mov    DWORD PTR [rbp-0x14],edi
   0x0000000000401145 <+15>:    mov    QWORD PTR [rbp-0x20],rsi
   0x0000000000401149 <+19>:    mov    DWORD PTR [rbp-0x4],0x0
   0x0000000000401150 <+26>:    jmp    0x401165 <bar+47>
   0x0000000000401152 <+28>:    lea    rax,[rip+0x2ec7]        # 0x404020 <useful>
   0x0000000000401159 <+35>:    mov    rdi,rax
   0x000000000040115c <+38>:    call   0x401040 <puts@plt>
   0x0000000000401161 <+43>:    add    DWORD PTR [rbp-0x4],0x1
   0x0000000000401165 <+47>:    mov    eax,DWORD PTR [rbp-0x4]
   0x0000000000401168 <+50>:    cmp    eax,DWORD PTR [rbp-0x14]
   0x000000000040116b <+53>:    jl     0x401152 <bar+28>
   0x000000000040116d <+55>:    nop
   0x000000000040116e <+56>:    nop
   0x000000000040116f <+57>:    leave
   0x0000000000401170 <+58>:    ret
```

## Exercise 2 - Baby's first executable loader
### [Q3]: Check `gdb` with your binary. How does `vmmap` look after running `mmap`? You can step through each line of code with `next` or `n`. You can step through each assembly instruction with `next instruction` or `ni`.

### Solution to [Q3]:
```
objdump -d dummy -F
```


Modify `ex2.c`:
```c

#include <stdio.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
        FILE *f = fopen("./bin/dummy", "rb");
        if (!f) {
                perror("fopen");
                return 1;
        }

        off_t foo_offset = 0x1106;

        fseek(f, foo_offset, SEEK_SET);

        unsigned char buffer[100];
        fread(buffer, 1, sizeof(buffer), f);



        void *exec_mem = mmap(NULL, sizeof(buffer), PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
         if (exec_mem == MAP_FAILED) {
                  perror("mmap");
                  return 1;
         }

         memcpy(exec_mem, buffer, sizeof(buffer));

         fclose(f);

         (*(void(*)()) exec_mem)();

         return 0;
}
```


```python
             Start                End Perm     Size Offset File
          0x400000           0x401000 r--p     1000      0 /home/radu/osds-lab/lab1/bin/ex2
          0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex2
          0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex2
          0x403000           0x404000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex2
          0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex2
          0x405000           0x426000 rw-p    21000      0 [heap]
```

## Exercise 3 - Stacks, calling conventions and mind controlling execution
### [Q4]: Can you identify the arguments of a function call in the disassembly?

### Solution to [Q4]:

```python
0000000000401196 <print_msg> (File Offset: 0x1196):
  401196:       f3 0f 1e fa             endbr64
  40119a:       55                      push   %rbp
  40119b:       48 89 e5                mov    %rsp,%rbp
  40119e:       48 83 ec 10             sub    $0x10,%rsp
  4011a2:       48 89 7d f8             mov    %rdi,-0x8(%rbp)
  4011a6:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  4011aa:       48 89 c6                mov    %rax,%rsi
  4011ad:       48 8d 05 54 0e 00 00    lea    0xe54(%rip),%rax        # 402008 <_IO_stdin_used+0x8> (File Offset: 0x2008)
  4011b4:       48 89 c7                mov    %rax,%rdi
  4011b7:       b8 00 00 00 00          mov    $0x0,%eax
  4011bc:       e8 bf fe ff ff          call   401080 <printf@plt> (File Offset: 0x1080)
  4011c1:       90                      nop
  4011c2:       c9                      leave
  4011c3:       c3                      ret
```
