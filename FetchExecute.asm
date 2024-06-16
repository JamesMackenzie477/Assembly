extern printf
extern getc

section .data

    Pointer: db "0x%x", 0xA, 0

section .text
    
    ; reads the rip register
    _rip:
        ; moves the return address from the stack into the return register
        mov rax, [rsp]
        ; returns teh address to the callee
        ret
    
    ; prints the address in the rip register
    _print_rip:
        ; moves the value in the rip register to the rax register
        call _rip
        ; adds the value from the rip register as an argument to the print function
        mov rdx, rax
        ; loads the address of a pointer format string as the first argument
        lea rcx, [Pointer]
        ; creates some stack space for the function
        sub rsp, 0x28
        ; calls the c runtime print function
        call printf
        ; fixes the stack
        add rsp, 0x28
        ; returns to the callee
        ret

    _main:
        ; creates some stack space for the function
        sub rsp, 0x28
        ; prints the address in the rip register
        call _print_rip
        ; waits for the user
        call getc
        ; fixes the stack
        add rsp, 0x28
        ; exits the program
        ret