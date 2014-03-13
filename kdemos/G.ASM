.286
.model tiny
.code
.startup
        call    randomize
        mov     al,13h
        call    SetVMode

        mov     ax,cs
        mov     es,ax
        mov     dx,offset palette
        mov     ax,1012h
        mov     bx,0
        mov     cx,256
        int     10h

        mov     si,400h
        mov     di,2000h
        mov     dx,0
l0:
        mov     bx,0
l1:
        mov     ax,si
        mov     cx,8
        push    si di bx dx
        call    FillBox1
        pop     dx bx di si
        add     bx,16
        mov     ax,di
        mov     cx,8
        push    si di bx dx
        call    FillBox1
        pop     dx bx di si
        add     bx,16
        cmp     bx,320
        jl      l1
        xchg    di,si
        add     dx,16
        cmp     dx,192
        jl      l0
        call    Beep
        call    Key
        ret

include FillBox1.inc
include rrrgggbb.inc
include putpixel.inc
include setvmode.inc
include random.inc
include frame.inc
include beep.inc
include line.inc
include key.inc
end