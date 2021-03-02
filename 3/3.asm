.model tiny
.code

org 100h

start_workplaceX = 0
start_workplaceY = 0

size_workplaceX = 80
size_workplaceY = 25

size_screenX = 80
size_screenY = 25

size_frameX = 60
size_frameY = 12

left_top_frameX = 10
left_top_frameY = 12

null_color  = 7
null_symbol = 0

horisontal  = 205
vertical    = 186
lt_angle    = 201
rt_angle    = 187
lb_angle    = 200
rb_angle    = 188

size_crossX = 12
size_crossY = 6

cross_color = 44h
frame_color = 74h

StartOfFrase = 2 * ((left_top_frameY + 3) * size_screenX + left_top_frameX + 3)

Start:
    mov bx, 0b800h
    mov es, bx

    call GetFrame
    call Roof
    call PrintWellCum
    call Pause
    
    mov ax, 4c00h
    int 21h    
    
ClearScreen proc

    mov ax, 2 * (size_screenX * start_workplaceY + start_workplaceX)

    while_Y:

        mov bx, ax
        add ax, 2 * size_workplaceX

        while_X:
            mov byte ptr es:[bx]  , null_symbol
            mov byte ptr es:[bx+1], null_color
            add bx, 2
            cmp bx, ax
            jb while_X

        add ax, 2 * (size_screenX - size_workplaceX)
        cmp ax, 2 * size_screenX * (size_workplaceY + start_workplaceY)
        jb while_Y

    ret
    endp

GetFrame proc

    ;Animation
    mov ah, 86h
    mov cx, 0
    mov dx, 10000

    call ClearScreen
    call HorizontalFill
    call VerticalFill
    call AnglesFill

    ret
    endp

HorizontalFill proc

    mov bx, (size_screenX * left_top_frameY + left_top_frameX) * 2
    
    while_not_right_end:
        mov byte ptr es:[bx]    , horisontal
        mov byte ptr es:[bx + 1], frame_color
        int 15h
        mov byte ptr es:[bx + 2 * (size_screenX * (size_frameY - 1))]    , horisontal
        mov byte ptr es:[bx + 2 * (size_screenX * (size_frameY - 1)) + 1], frame_color
        int 15h

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
        int 15h
        mov byte ptr es:[bx + 2 * (size_frameX - 1)]    , vertical
        mov byte ptr es:[bx + 2 * (size_frameX - 1) + 1], frame_color
        int 15h

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

Roof proc

    mov ah, 86h
    mov cx, 0
    mov dx, 10000
    mov bx, (size_screenX * (left_top_frameY - 1) + left_top_frameX) * 2
    mov cx, 0

    left_roof:
        mov byte ptr es:[bx]    , lt_angle
        mov byte ptr es:[bx + 1], frame_color
        int 15h
        mov byte ptr es:[bx + 2], horisontal
        mov byte ptr es:[bx + 3], frame_color
        int 15h
        mov byte ptr es:[bx + 4], horisontal
        mov byte ptr es:[bx + 5], frame_color
        int 15h
        mov byte ptr es:[bx + 6], rb_angle
        mov byte ptr es:[bx + 7], frame_color
        int 15h

        sub bx, 2 * (size_screenX - 3)
        inc cx

        cmp cx, 10
        jb left_roof

    mov bx, (size_screenX * (left_top_frameY - 1) + left_top_frameX + size_frameX - 1) * 2
    mov cx, 0

    right_roof:
        mov byte ptr es:[bx]    , rt_angle
        mov byte ptr es:[bx + 1], frame_color
        int 15h
        mov byte ptr es:[bx - 2], horisontal
        mov byte ptr es:[bx - 1], frame_color
        int 15h
        mov byte ptr es:[bx - 4], horisontal
        mov byte ptr es:[bx - 3], frame_color
        int 15h
        mov byte ptr es:[bx - 6], lb_angle
        mov byte ptr es:[bx - 5], frame_color
        int 15h
        sub bx, 2 * (size_screenX + 3)
        inc cx

        cmp cx, 10
        jb right_roof
    
    ;fix one symbol
    add bx, 2 * size_screenX 
    mov byte ptr es:[bx]    , horisontal
    mov byte ptr es:[bx + 1], frame_color

    ;vertical cross
    add bx, 2 * (3 * size_screenX - 1) + 1
    mov cx, 0

    vertical_cross:
        mov byte ptr es:[bx]    , cross_color
        mov byte ptr es:[bx + 2], cross_color
        mov byte ptr es:[bx + 4], cross_color
        mov byte ptr es:[bx + 6], cross_color
        
        inc cx
        add bx, 2 * size_screenX

        cmp cx, size_crossY
        jb vertical_cross

    ;horizontal cross
    sub bx, 2 * (4 * size_screenX + 4)
    mov cx, 0
    
    horizontal_cross:
        mov byte ptr es:[bx]                   , cross_color
        mov byte ptr es:[bx + 2 * size_screenX], cross_color

        inc cx
        add bx, 2

        cmp cx, size_crossX
        jb horizontal_cross

    ret
    endp

PrintWellCum proc

    mov bx, 0

    printing:
        mov dl, [bx + offset Frase]
        mov dh, [bx + offset Frase_Color]
        shl bx, 1
        mov byte ptr es:[bx + StartOfFrase],     dl
        mov byte ptr es:[bx + StartOfFrase + 1], dh
        shr bx, 1
        inc bx

        cmp byte ptr [bx + offset Frase], 0
        jne printing

    ;call PrintShiza

    ret
    endp

PrintShiza proc

    ret
    endp

Pause proc

    mov cx, 100
    mov ah, 86h
    int 15h

    ret
    endp

Frase db 'Добро пожаловать на сервер шизофрения!', 0
Frase_Color db 8 dup (74h, 75h, 72h, 73h, 71h)
end Start
