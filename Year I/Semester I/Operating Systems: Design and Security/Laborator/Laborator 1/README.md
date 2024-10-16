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
