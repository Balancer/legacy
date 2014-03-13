; bx-dx - x,y
; cx - size
; al -color ; ah-step
FillBox2  proc    near
FB1L:   push    cx ax
        add     cx,cx
        call    SQFrame
        pop     ax cx
        inc     bx
        inc     dx
        add     al,ah
        loop    FB1L
        sub     al,ah
        cmp     bx,0
        jl      fbret
        cmp     bx,320
        jge     fbret
        cmp     dx,0
        jl      fbret
        cmp     dx,200
        jge     fbret
        call    PutPixel
fbret:
        ret
FillBox2        EndP
