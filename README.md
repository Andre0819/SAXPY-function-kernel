# SAXPY Function in C and x86-64 assembly language
Kernels written in C and x86-64 assembly language that performs the SAXPY (A*X + Y) function.

## Execution Times and Analysis

### Debug Mode
| Kernel          | Vector Size (n) | Average Execution Time (seconds) |
|-----------------|-----------------|----------------------------------|
| C               | 2^20            |                                  |
| C               | 2^24            |                                  |
| C               | 2^30            |                                  |
| x86-64 Assembly | 2^20            |                                  |
| x86-64 Assembly | 2^24            |                                  |
| x86-64 Assembly | 2^30            |                                  |
### Release Mode
| Kernel          | Vector Size (n) | Average Execution Time (seconds) |
|-----------------|-----------------|----------------------------------|
| C               | 2^20            |                                  |
| C               | 2^24            |                                  |
| C               | 2^30            |                                  |
| x86-64 Assembly | 2^20            |                                  |
| x86-64 Assembly | 2^24            |                                  |
| x86-64 Assembly | 2^30            |                                  |

### Program output with C
to be filled out

### Program output with x86-64 Assembly
to be filled out
