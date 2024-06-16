; __int64 __stdcall __rip()
__rip:
    ; moves the return address from the stack into the return register
    mov rax, [rsp]
    ; returns to the callee
    ret

; __int32 __stdcall __eip()
__eip:
    ; moves the return address from the stack into the return register
    mov eax, [esp]
    ; returns to the callee
    ret
   
_main:
    ret