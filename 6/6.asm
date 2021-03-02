.model tiny
.code

org 100h

Start:

    mov bx, 0
    mov es, bx
    mov bx, 9 * 4 ;itteruption 9
    cli

    mov ax, es:[bx]
    mov Old09Ofs, ax
    mov ax, es:[bx+2]
    mov Old09Seg, ax

    mov es:[bx], offset Int09
    mov ax, cs
    mov es:[bx+2], ax
    sti

    mov ax, 3100h           
    mov dx, offset EndOfAll                 
    shr dx, 4               
    inc dx                  
    
    ; mov ax, 4c00h
    int 21h

Int09 proc

    ; Save old meanings
    push ax
    push di 
    push es

    mov di, 0B800h
    mov es, di
    mov di, (80 * 2 + 50)

    mov ah, 4eh
    in al, 60h
    mov es:[di], ax

    jmp EOI

    ; Not actually, when we are using old interruption

    in  al, 61h
    mov ah, al
    or  al, 80h
    out 61h, al
    mov  al, ah
    out 61h, al

    mov al, 20h
    out 20h, al

    EOI:

    pop es
    pop di
    pop ax

    db 0eah ; jump far

    Old09Ofs dw 0
    Old09Seg dw 0

    iret ;Not actually
    endp

EndOfAll:
end Start
