.model tiny
.code

org 100h

size_screenX = 80
size_screenY = 25

size_frameX = 14
size_frameY = 11

left_top_frameX = 60
left_top_frameY = 6

null_color  = 74h
null_symbol = 0

horisontal  = 205
vertical    = 186
lt_angle    = 201
rt_angle    = 187
lb_angle    = 200
rb_angle    = 188

frame_color = 74h

number_size = 4

frame_on  = 2
frame_off = 3

Start:

    mov bx, 0
    mov es, bx
    cli

    ; Creating interrupt 8
    mov bx, 8 * 4 
    lea di, Old08Func
    lea cx, Int08
    call CreateNewInt

    ; Creating interrupt 9
    mov bx, 9 * 4 
    lea di, Old09Func
    lea cx, Int09
    call CreateNewInt

    sti

    mov ax, 3100h           
    mov dx, offset EndOfAll                 
    shr dx, 4               
    inc dx                  
    
    int 21h

CreateNewInt proc
; Creating new interrupt
; Parameters:
; es = 0 - place of interrupt
; bx - number of interrupt * 4
; di - place, where adress of old function will be placed 
; cx - adress of new function

    ; Save adress of old function
    mov ax, es:[bx]
    mov word ptr cs:[di], ax
    mov ax, es:[bx+2]
    mov word ptr cs:[di+2], ax

    ; Write adress of new function
    mov es:[bx], cx
    mov ax, cs
    mov es:[bx+2], ax

    ret
    endp

Int08 proc
; No parameters

    cmp need_go, frame_on
    jne EOI

    ; Save old meanings to restore
    push ax
    push bx
    push cx
    push dx
    push di 
    push es

    ; Save old meanings to print
    mov word ptr save_ax, ax
    mov word ptr save_bx, bx
    mov word ptr save_cx, cx
    mov word ptr save_dx, dx

    ; Call working funtions
    call GetFrame
    call PrintRegisters

    ; End of interruption
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    EOI:

    db 0eah ; jump far
    Old08Func dd 0

    iret ;Not actually
    endp

Int09 proc
; No parameters

    ; Save old meanings
    push ax

    ; Check mode:
    ; 1 - frame on
    ; 2 - frame off

    in  al, 60h ; 60h - port of keyboard

    ; Compare pressed key
    cmp al, frame_on
    je ChangeMode
    cmp al, frame_off
    jne EndInt09

    ChangeMode:
    mov byte ptr need_go, al
    
    EndInt09:

    pop ax

    db 0eah ; jump far

    Old09Func dd 0

    iret ;Not actually
    endp

GetFrame proc
; Create frame
; No parameters

    ; Place of VRAM
    mov di, 0B800h
    mov es, di

    ; Call all stages of creating 
    call ClearScreen
    call HorizontalFill
    call VerticalFill
    call AnglesFill

    ret
    endp

ClearScreen proc

    ; Filling all frame with null-symbols
    mov ax, 2 * (size_screenX * left_top_frameY + left_top_frameX)

    while_Y:

        mov bx, ax
        add ax, 2 * size_frameX

        while_X:
            mov byte ptr es:[bx]  , null_symbol
            mov byte ptr es:[bx+1], null_color
            add bx, 2
            cmp bx, ax
            jb while_X

        add ax, 2 * (size_screenX - size_frameX)
        cmp ax, 2 * size_screenX * (size_frameY + left_top_frameY)
        jb while_Y

    ret
    endp

HorizontalFill proc

    mov bx, (size_screenX * left_top_frameY + left_top_frameX) * 2
    
    while_not_right_end:
        mov byte ptr es:[bx]    , horisontal
        mov byte ptr es:[bx + 1], frame_color
        mov byte ptr es:[bx + 2 * (size_screenX * (size_frameY - 1))]    , horisontal
        mov byte ptr es:[bx + 2 * (size_screenX * (size_frameY - 1)) + 1], frame_color

        add bx, 2

        cmp bx, (size_screenX * left_top_frameY + left_top_frameX + size_frameX) * 2
        jb  while_not_right_end

    ret
    endp

VerticalFill proc

    mov bx, (size_screenX * left_top_frameY + left_top_frameX) * 2

    while_not_bottom_end:
        mov byte ptr es:[bx]    , vertical
        mov byte ptr es:[bx + 1], frame_color
        mov byte ptr es:[bx + 2 * (size_frameX - 1)]    , vertical
        mov byte ptr es:[bx + 2 * (size_frameX - 1) + 1], frame_color

        add bx, 2 * size_screenX

        cmp bx, 2 * (size_screenX * (size_frameY + left_top_frameY) + left_top_frameX)
        jb  while_not_bottom_end

    ret
    endp

AnglesFill proc

    mov byte ptr es:[2 * (size_screenX *  left_top_frameY + left_top_frameX)]                                     , lt_angle
    mov byte ptr es:[2 * (size_screenX *  left_top_frameY + left_top_frameX + size_frameX - 1)]                   , rt_angle
    mov byte ptr es:[2 * (size_screenX * (left_top_frameY + size_frameY - 1) + left_top_frameX)]                  , lb_angle
    mov byte ptr es:[2 * (size_screenX * (left_top_frameY + size_frameY - 1) + left_top_frameX + size_frameX - 1)], rb_angle

    ret
    endp

PrintRegisters proc

    mov di, 0B800h
    mov es, di

    ; Print ax
    mov ax, save_ax
    mov byte ptr cs:[RegEquiv], 'a'
    mov di, 2 * (size_screenX * (left_top_frameY + 2) + left_top_frameX + 2)
    call PrintFrase
    call PrintHex

    ; Print bx
    mov ax, save_bx
    mov byte ptr cs:[RegEquiv], 'b'
    mov di, 2 * (size_screenX * (left_top_frameY + 4) + left_top_frameX + 2)
    call PrintFrase
    call PrintHex

    ; Print cx
    mov ax, save_cx
    mov byte ptr cs:[RegEquiv], 'c'
    mov di, 2 * (size_screenX * (left_top_frameY + 6) + left_top_frameX + 2)
    call PrintFrase
    call PrintHex

    ; Print dx
    mov ax, save_dx
    mov byte ptr cs:[RegEquiv], 'd'
    mov di, 2 * (size_screenX * (left_top_frameY + 8) + left_top_frameX + 2)
    call PrintFrase
    call PrintHex

    ret
    endp

PrintHex proc
; In ax - number
; 16 system of count

    my_mask = 0Fh
    xor bx, bx ; counter

    read_number:
        mov  dx, my_mask
        and  dx, ax
        push dx
        shr  ax, number_size

        inc bx
        cmp bx, number_size
        jb read_number

    xor cx, cx

    print_number:
        pop bx
        mov byte ptr dl, cs:[bx + offset ListOfDigits]
        mov byte ptr es:[di],     dl
        mov byte ptr es:[di + 1], frame_color
        inc cx
        add di, 2

        cmp cx, number_size
        jb print_number

    ; h (hexical) in the end
    mov byte ptr dl, 'h'
    mov byte ptr es:[di],     dl
    mov byte ptr es:[di + 1], frame_color

    ret
    endp

PrintFrase proc

    EndLine = 0

    xor bx, bx

    print_frase:

        mov dl, cs:[bx + offset RegEquiv]
        mov byte ptr es:[di],     dl
        mov byte ptr es:[di + 1], frame_color
        inc bx
        add di, 2

        cmp byte ptr cs:[bx + offset RegEquiv], EndLine
        jne print_frase

    ret
    endp

save_ax dw 0h
save_bx dw 0h
save_cx dw 0h
save_dx dw 0h

need_go db frame_on

ListOfDigits  db '0123456789ABCDEF'
RegEquiv db 'ax = ', 0

EndOfAll:
end Start
