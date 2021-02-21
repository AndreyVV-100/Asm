.model tiny
.code

org 100h

Start:
    mov ax, 0EDAh
    mov bx, 4
    call PrintPower2

    mov ax, 4c00h
    int 21h

PrintPower2 proc
;In ax - number
;In bx - power of 2, that do system of count

    mov cx, 4
    sub cx, bx
    shr my_mask, cl
    mov dl, bl
    mov bx, 0

    read_number:
        mov  cl, my_mask
        and  cx, ax
        push cx
        mov  cl, dl
        shr  ax, cl

        inc  bx

        cmp ax, 0
        jne read_number

    mov ah, 02h
    mov cx, bx

    print_number:
        pop bx
        mov byte ptr dl, [bx + offset ListOfDigits]
        int 21h
        dec cx

        cmp cx, 0
        jne print_number

    ret
    endp

ListOfDigits db '0123456789ABCDEF'
my_mask db 0Fh
end Start
