# Laborator 1

## Exercise 1 - Inspecting Virtual Memory
[Q1]: Where is each section mapped? Try using the `search` command in `pwndbg` (or `search-pattern` in `GEF`).

```bash
             Start                End Perm     Size Offset File
          0x400000           0x401000 r--p     1000      0 /home/radu/osds-lab/lab1/bin/ex1
          0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
          0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x403000           0x404000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
          0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```



`.bss` and `.data` are mapped into the same segment. We can look for the read-write permissions in the virtual memory map pages or we can use `search` and look out for a string.

```bash
 0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```

This is the only section from ex1 with read-write permissions.
 
Also, if we run `search Where` we receive this address: `0x404010` which confirms that `.bss` and `.data` are mapped between `0x404000` and `0x405000`.

The `.text` section should have the execute permissions and the only range with that permission is from `0x401000` to `0x402000`.

```bash
0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
```