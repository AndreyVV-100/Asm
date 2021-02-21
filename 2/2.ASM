.model tiny
.code

org 100h

Frase = 810
EndLine = 1

Start:
    mov bx, 0b800h
    mov es, bx
    mov bx, 0

do:
    mov dl, [bx + offset Msg]
    shl bx, 1
    mov byte ptr es:[bx + Frase],     dl
    mov byte ptr es:[bx + Frase + 1], 4eh
    shr bx, 1
    inc bx

    cmp byte ptr [bx + offset Msg], EndLine
    jne do

mov ax, 4c00h
int 21h

Msg db 'Without further interruption, let''s selebrate and suck some dick.', EndLine
end Start
