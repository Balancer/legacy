FUP     db      ?
FDOWN   db      ?
FLEFT   db      ?
FRIGHT  db      ?


Frame   proc    near         ;bx,dx=left/up,si:di=size,al=color
        mov     dword ptr cs:[FUP],-1
        cmp     bx,0
        jge     fl1
        add     si,bx
        xor     bx,bx
        mov     cs:[fleft],bl
fl1:
        cmp     dx,0
        jge     fl2
        add     di,dx
        xor     dx,dx
        mov     cs:[fup],dl
fl2:
        cmp     bx,320
        jl      fl3
        ret
fl3:
        cmp     dx,200
        jl      fl4
        ret
fl4:
        push    ax
        mov     ax,319
        sub     ax,bx
        cmp     ax,si
        jge     fl5
        mov     si,ax
        mov     byte ptr cs:[fright],0
fl5:
        mov     ax,199
        sub     ax,dx
        cmp     ax,di
        jge     fl6
        mov     di,ax
        mov     byte ptr cs:[fdown],0
fl6:
        pop     ax
        cmp     si,0
        jge     fl41
        ret
fl41:   cmp     di,0
        jge     fl42
        ret
fl42:
        xor     ah,ah
        ; up
        cmp     byte ptr cs:[fup],0
        je      flpass1
        push    ax ;col
        push    dx ; y2
        push    bx ; x2
        push    dx ; y1
        mov     bp,bx
        add     bp,si
        push    bp ; x1
        call    Line
flpass1:
        cmp     byte ptr cs:[fleft],0
        je      flpass2
        ; left
        push    ax
        mov     bp,dx
        add     bp,di
        push    bp ; y2
        push    bx ; x2
        push    dx ; y1
        push    bx ; x1
        call    Line
flpass2:
        cmp     byte ptr cs:[fright],0
        je      flpass3
        ; right
        push    ax
        mov     bp,dx
        add     bp,di
        push    bp ; y2
        mov     bp,bx
        add     bp,si
        push    bp ; x2
        push    dx ; y1
        push    bp ; x1
        call    Line
flpass3:
        cmp     byte ptr cs:[fdown],0
        je      flpass4
        ; down
        push    ax
        mov     bp,dx
        add     bp,di
        push    bp ; y2
        push    bx ; x2
        push    bp ; y1
        mov     bp,bx
        add     bp,si
        push    bp ; x1
        call    Line
flpass4:
        ret
endp