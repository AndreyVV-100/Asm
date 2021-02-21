.model tiny
.code

org 100h

Start:
mov bx, 0

do:
mov ah, 2h
mov dl, Msg + bx
int 21h
add bx, 1

cmp Msg + bx, 0
jne do

mov ax, 4c00h
int 21h

Msg db 'Fisting is 300$', 0
end Start