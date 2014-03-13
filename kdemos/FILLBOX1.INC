; bx-dx - x,y
; cx - size
; al -color ; ah-step
FillBox1        proc    near
        mov     si,cx
        add     si,si
        mov     di,si
FB1L:   push    ax
        push    bx dx si di
        call    Frame
        pop     di si dx bx
        pop     ax
        inc     bx
        inc     dx
        sub     si,2
        sub     di,2
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
FillBox1        EndP
