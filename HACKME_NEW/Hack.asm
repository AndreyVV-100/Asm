.model tiny
.code

org 100h

MAX_BUF_SIZE = 1488
SECRET_KEY = 228

END_OF_LINE = 0

Start:

    lea bx, Buf

    push 1
    call Input 
    add sp, 2

    lea bx, Buf
    call CheckPassword

    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

Input proc

    mov ah, 01h
    int 21h
    cmp al, 0Dh
    je InputEnd

    cmp al, 08h
    jne NoBackspace
    dec bx
    jmp Input 

    NoBackspace:
        mov byte ptr cs:[bx], al 
        inc bx
        jmp Input

    InputEnd:
    mov byte ptr cs:[bx], END_OF_LINE

    ret
    endp

CheckPassword proc

    cmp byte ptr cs:[offset SecretChanceToHack + 0], SECRET_KEY
    jne StandartCheck
    cmp byte ptr cs:[offset SecretChanceToHack - 1], SECRET_KEY
    je StandartCheck
    cmp byte ptr cs:[offset SecretChanceToHack + 1], SECRET_KEY
    je StandartCheck

    lea dx, Accessed
    ret

    StandartCheck:
        mov di, 0

        WhileCheck:

            mov al, byte ptr cs:[offset Password + di]
            mov ah, byte ptr cs:[offset Buf      + di]
            cmp al, ah
            jne BadPassword
            inc di
            cmp byte ptr cs:[offset Password + di], END_OF_LINE
            je  EndOfCheck
            jmp WhileCheck

    BadPassword:

        lea dx, Failed
        ret

    EndOfCheck:

        cmp byte ptr cs:[offset Buf + di], END_OF_LINE
        jne BadPassword

        lea dx, Accessed
        ret
        endp

Accessed db "Accessed$"
Failed   db "Failed$"

Password db "Leha pidor nahuia ty zalez suda? Ya tebe ne razreshal lezt v asm!!!111", END_OF_LINE
; Password db "123", END_OF_LINE

Buf db MAX_BUF_SIZE dup (0)

SecretChanceToHack db 0

end Start
