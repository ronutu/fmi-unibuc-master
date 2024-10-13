# Laborator 1

## Exercise 1 - Inspecting Virtual Memory
[Q1]: Where is each section mapped? Try using the `search` command in `pwndbg` (or `search-pattern` in `GEF`).

```python
             Start                End Perm     Size Offset File
          0x400000           0x401000 r--p     1000      0 /home/radu/osds-lab/lab1/bin/ex1
          0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
          0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x403000           0x404000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```



`.bss` and `.data` are mapped into the same segment. We can either check the virtual memory map pages for read-write permissions or use the `search` command to find a string in the data section.

```python
 0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```

This is the only section in `ex1` with read-write permissions.
 
Also, when we run `search Where`, it returns the address `0x404010`, confirming that the `.bss` and `.data` sections are mapped between `0x404000` and `0x405000`.

The `.text` section should have the execute permissions and the only range with that permission is from `0x401000` to `0x402000`.

```python
0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
```
