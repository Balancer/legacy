; randomize - ax - rndnum 0 .. 65535; 能栽兩 es
; rand - ax - 0..65536; 祚飶兩 di, es
; rnd - bx=n -> ax=0..n-1 ; 祚飶兩 dx, di, es

rndnum  dd      ?


randomize       proc    near
        xor     ax,ax
        mov     es,ax
        mov     ax,es:[46Ch]
        xchg    ah,al
        mov     word ptr cs:[rndnum+2],ax
        mov     ax,es:[46Eh]
        mov     word ptr cs:[rndnum],ax
        ret
randomize       endp

rand    proc    near
        inc     word ptr cs:[rndnum]
        jnc     noinc
        inc     word ptr cs:[rndnum+2]
noinc:  mov     ax,word ptr cs:[rndnum]
        ror     ax,1
        xor     ah,al
        mov     di,ax
        mov     ax,word ptr cs:[rndnum+2]
        ror     ax,1
        xor     ah,al
        xor     ax,di
        ret
rand    endp

rnd     proc    near
        call    rand
        xor     dx,dx
        idiv    bx
        mov     ax,dx
        ret
endp