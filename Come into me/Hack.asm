.model tiny
.code

org 100h

MAX_BUF_SIZE = 228

END_OF_LINE = 0Dh
NEWLINE = 0Ah

Start: 

    jmp CreateProgram

MyProgram: db 90h

    ; Input

    mov ah, 0Ah
    lea dx, Buf
    int 21h
    
    call CheckPassword

    ; mov byte ptr ds:[offset Buf + 2], '0'
    ; lea bx, Buf + 2
    ; call Output

    ; Check input

    ; mov bl, byte ptr ds:[offset Buf + 1]
    ; mov bh, 0
    ; add bx, offset Buf + 2
    ; mov byte ptr ds:[bx], '$'

    ; lea dx, Buf + 2
    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

CheckPassword proc

    mov di, 0
    mov bh, 0

    WhileCheck:
    
        mov bl, byte ptr cs:[offset Password + di]
        sub bl, 'a'
        mov al, byte ptr cs:[offset Password + bx]
        mov ah, byte ptr cs:[offset Buf + 2  + di]
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

        cmp byte ptr cs:[offset Buf + 2 + di], END_OF_LINE
        jne BadPassword

        lea dx, Accessed
        ret
        endp

Accessed db NEWLINE, "Accessed$"
Failed   db NEWLINE, "Failed$"

Password db "thequickbrownfoxjumpsoverthelazydog", END_OF_LINE

; Password db "123", END_OF_LINE

Buf db MAX_BUF_SIZE, MAX_BUF_SIZE dup (0), 228

CreateProgram:

    jmp MyProgram

end Start
