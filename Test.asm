; kernel32
extern GetModuleHandleA

; user32
extern MessageBoxA
extern LoadCursorA
extern RegisterClassExA
extern CreateWindowExA
extern ShowWindow
extern DefWindowProcA
extern PeekMessageA
extern GetMessageA
extern TranslateMessage
extern DispatchMessageA

%define NULL 0x0
%define WS_OVERLAPPEDWINDOW 0xCF0000
%define CW_USEDEFAULT 0x80000000
%define IDC_ARROW 0x7F00

section .data

    HelloWorld: db "Welcome!", 0x0
    
    WindowTitle: db "Assembly Example", 0x0

section .text
    
    WelcomeMessage:
        sub rsp, 0x28
        xor rcx, rcx
        mov rdx, HelloWorld
        mov r8, WindowTitle
        xor r9, r9
        call MessageBoxA
        add rsp, 0x28
        ret
    
    ; LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    WindowProc:
        sub rsp, 0x28
        call DefWindowProcA
        add rsp, 0x28
        ret
    
    ; ATOM __stdcall InitClass(HINSTANCE hInstance)
    InitClass:
        sub rsp, 0x78
        mov qword [rsp+0x18], rcx
        mov qword [rsp+0x48], NULL
        mov qword [rsp+0x40], WindowTitle
        mov qword [rsp+0x38], NULL
        mov qword [rsp+0x30], 0x6
        mov rdx, IDC_ARROW
        xor rcx, rcx
        call LoadCursorA
        mov qword [rsp+0x28], rax
        mov qword [rsp+0x20], NULL
        mov dword [rsp+0x14], 0x0
        mov dword [rsp+0x10], 0x0
        mov qword [rsp+0x8], WindowProc
        mov dword [rsp+0x4], 0x3
        mov dword [rsp], 0x50
        mov rcx, rsp
        call RegisterClassExA
        add rsp, 0x78
        ret
    
    ; HWND __stdcall InitWindow(HINSTANCE hInstance, LPCSTR lpClass, LPCSTR lpTitle)
    InitWindow:
        ; return CreateWindowExA(NULL, lpClass, lpTitle, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, NULL, NULL, NULL, NULL);
        sub rsp, 0x68
        mov qword [rsp+0x58], NULL
        mov qword [rsp+0x50], rcx
        mov qword [rsp+0x48], NULL
        mov qword [rsp+0x40], NULL
        mov dword [rsp+0x38], 600
        mov dword [rsp+0x30], 800
        mov dword [rsp+0x28], CW_USEDEFAULT
        mov dword [rsp+0x20], CW_USEDEFAULT
        mov r9, WS_OVERLAPPEDWINDOW
        ; mov r8, r8
        ; mov rdx, rdx
        xor ecx, ecx
        call CreateWindowExA
        mov rdx, 0x5
        mov rcx, rax
        call ShowWindow
        add rsp, 0x68
        ret
    
    ; int main(int argc, char *argv[])
    _main:
    mov rbp, rsp; for correct debugging
        ; return InitWindow("Assembly Example", "Assembly Example");
        sub rsp, 0x88
        ;call WelcomeMessage
        xor rcx, rcx
        call GetModuleHandleA
        mov rcx, rax
        call InitClass
        xor rcx, rcx
        call GetModuleHandleA
        mov r8, WindowTitle
        mov rdx, WindowTitle
        mov rcx, rax
        call InitWindow
        
    _message_loop:
        ; mov dword [rsp+0x20], 0x1
        xor r9, r9
        xor r8, r8
        xor rdx, rdx
        lea rcx, [rsp+0x30]
        call GetMessageA
        test eax, eax
        jz _end
        
        lea rcx, [rsp+0x30]
        call TranslateMessage
        
        lea rcx, [rsp+0x30]
        call DispatchMessageA
        
        jmp _message_loop
        
    _end:
        add rsp, 0x88
        ret