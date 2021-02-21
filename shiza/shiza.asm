.model tiny
.code

org 100h

Frase = 0810

Start:
mov bx, 0b800h
mov es, bx
lea bx, Msg
add bx, Frase

do:
mov dl, [bx]
mov byte ptr es:[bx], dl
inc bx
mov byte ptr es:[bx], 4eh
inc bx

cmp bx, 0
jne do

mov ax, 4c00h
int 21h

Msg db 'Fisting is 300$', 0
end Start
