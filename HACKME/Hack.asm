.model tiny
.code

org 100h

MAX_BUF_SIZE = 1488
SECRET_KEY = 228

END_OF_LINE = 0

Start:

    lea bx, Buf
    call Input 

    lea bx, Buf
    call CheckPassword

    ; mov ah, 0Ah
    ; lea dx, Buf
    ; int 21h
    
    ; mov byte ptr ds:[offset Buf + 2], '0'
    ; lea bx, Buf + 2
    ; call Output

    ; Check input

    ; mov bl, byte ptr ds:[offset Buf + 1]
    ; mov bh, 0
    ; add bx, offset Buf + 2
    ; mov byte ptr ds:[bx], '$'

    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

Input proc

    ; mov ah, 01h
    ; int 21h
    ; cmp al, 0Dh
    ; je InputEnd

    ; mov byte ptr ds:[bx], al 
    ; inc bx
    ; jmp Input

    ; InputEnd:
    ; mov byte ptr ds:[bx], END_OF_LINE

    ; Open file

    mov ah, 3Dh
    mov al, 0
    lea dx, FileName
    int 21h

    ; ReadFile
    mov bx, ax
    mov ah, 3Fh
    mov cx, 0FFFFh
    lea dx, buf
    int 21h

    ; Close file

    mov ah, 3Eh
    int 21h

    ret
    endp

CheckPassword proc

    cmp byte ptr ds:[offset SecretChanceToHack + 0], SECRET_KEY
    jne StandartCheck
    cmp byte ptr ds:[offset SecretChanceToHack - 1], SECRET_KEY
    je StandartCheck
    cmp byte ptr ds:[offset SecretChanceToHack + 1], SECRET_KEY
    je StandartCheck

    lea dx, Accessed
    ret

    StandartCheck:
        mov di, 0

        WhileCheck:

            mov al, byte ptr ds:[offset Password + di]
            mov ah, byte ptr ds:[offset Buf      + di]
            cmp al, ah
            jne BadPassword
            inc di
            cmp byte ptr ds:[offset Password + di], END_OF_LINE
            je  EndOfCheck
            jmp WhileCheck

    BadPassword:

        lea dx, Failed
        ret

    EndOfCheck:

        cmp byte ptr ds:[offset Buf + di], END_OF_LINE
        jne BadPassword

        lea dx, Accessed
        ret
        endp

.data

FileName db "S:\ASM\HACK\file.txt", 0
Accessed db "Accessed$"
Failed   db "Failed$"

Password db "Leha pidor nahuia ty zalez suda? Ya tebe ne razreshal lezt v asm!!!111", END_OF_LINE
; Password db "123", END_OF_LINE

Buf db MAX_BUF_SIZE dup (0)

SecretChanceToHack db 0

end Start
