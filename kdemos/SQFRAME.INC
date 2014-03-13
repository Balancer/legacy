; Квадратная рамка
;bx,dx=left/up,cx=size,al=color
;ax, bx, dx, cx - сохран
;bp,es,si,di-порт (ES=DrawSeg)

SQFrame proc    near
        cmp     bx,320
        jge     SQFret
        cmp     dx,200
        jl      SQFloc0
SQFret: ret
SQFloc0:

        mov     es,CS:[DrawSeg]
        mov     bp,cx

        ; up
        push    bx
        cmp     dx,0
        jl      SQFpass1
        cmp     dx,200
        jge     SQFpass1

        mov     cx,bp
        cmp     bx,0
        jge     SQFloc2
        add     cx,bx
        xor     bx,bx
SQFloc2:
        mov     si,320
        sub     si,bx
        cmp     si,cx
        jge     SQFloc3
        mov     cx,si
SQFloc3:
        cmp     cx,0
        jle     SQFpass1

        mov     si,dx
        shl     si,6
        mov     di,si
        shl     si,2
        add     di,si
        add     di,bx
rep     stosb

SQFpass1:
        pop     bx
        ; left
        push    dx
        cmp     bx,0
        jl      SQFpass2
        cmp     bx,320
        jge     SQFpass2

        mov     cx,bp
        cmp     dx,0
        jge     SQFloc5
        add     cx,dx
        xor     dx,dx
SQFloc5:
        mov     si,200
        sub     si,dx
        cmp     si,cx
        jge     SQFloc6
        mov     cx,si
SQFloc6:
        cmp     cx,0
        jle     SQFpass2

        mov     si,dx
        shl     si,6
        mov     di,si
        shl     si,2
        add     di,si
        add     di,bx

sqfLoc7:
        stosb
        add     di,319
        loop    sqfLoc7

SQFpass2:
        pop     dx

        ; right

        push    bx dx
        add     bx,bp
        cmp     bx,0
        jl      SQFpass3
        cmp     bx,320
        jge     SQFpass3

        mov     cx,bp
        cmp     dx,0
        jge     SQFloc8
        add     cx,dx
        xor     dx,dx
SQFloc8:
        mov     si,200
        sub     si,dx
        cmp     si,cx
        jge     SQFloc9
        mov     cx,si
SQFloc9:
        cmp     cx,0
        jle     SQFpass3
        mov     si,dx
        shl     si,6
        mov     di,si
        shl     si,2
        add     di,si
        add     di,bx
sqfloc10:
        stosb
        add     di,319
        loop    sqfloc10
SQFpass3:
        pop     dx bx

        ; down

        push    bx dx
        add     dx,bp
        cmp     dx,0
        jl      SQFpass4
        cmp     dx,200
        jge     SQFpass4

        mov     cx,bp
        inc     cx
        cmp     bx,0
        jge     SQFloc11
        add     cx,bx
        xor     bx,bx
SQFloc11:
        mov     si,320
        sub     si,bx
        cmp     si,cx
        jge     SQFloc12
        mov     cx,si
SQFloc12:
        cmp     cx,0
        jle     SQFpass4
        mov     si,dx
        shl     si,6
        mov     di,si
        shl     si,2
        add     di,si
        add     di,bx
rep     stosb
SQFpass4:
        pop     dx bx
        mov     cx,bp
        ret
endp