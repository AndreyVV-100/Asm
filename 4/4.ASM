.model tiny
.code

org 100h

Start:
    mov ax, 0EDAh
    mov bx, 10
    call PrintAny

    mov ax, 4c00h
    int 21h

PrintAny proc
; In ax - number
; In bx - system of count

    mov cx, 0
    mov dx, 0

    read_number:
        div  bx
        push dx

        mov dx, 0
        inc cx

        cmp ax, 0
        jne read_number

    mov ah, 02h

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
end Start
