;--------  LINE  ------------------------------------------
; Чертит линию из x1,y1 в x2,y2 цветом color
; стек освобождает сама
; все регистры сохраняет
; рабочий сегмент хранится в переменной DrawSeg
;----------------------------------------------------------
; Передавать параметры:
; push color
; push y2
; push x2
; push y1
; push x1
;----------------------------------------------------------
; Пример:
;               push    14
;               push    0
;               push    319
;               push    199
;               push    0
;               call    line
; Рисует линию жёлтого цвета снизу-слева вверх-справа
;----------------------------------------------------------

DrawSeg         dw      0A000h

ARGx1           EQU     word ptr [bp+ 4]
ARGy1           EQU     word ptr [bp+ 6]
ARGx2           EQU     word ptr [bp+ 8]
ARGy2           EQU     word ptr [bp+10]
ARGn            EQU     byte ptr [bp+12]
VARincr1        EQU     word ptr [bp  ]
VARincr2        EQU     word ptr [bp-2]
VARroutine      EQU     word ptr [bp-4]

BytesPerLine    EQU     320

Line    Proc    near
        push    bp
        mov     bp,sp
        sub     sp,6
        pusha
        push    si
        push    di
        mov     si,BytesPerLine
        mov     cx,ARGx2
        sub     cx,ARGx1
        jz      VertLine
        jns     L01
        neg     cx
        mov     bx,ARGx2
        xchg    bx,ARGx1
;----------------------------
        mov     ARGx2,bx
        mov     bx,ARGy2
        xchg    bx,ARGy1
        mov     ARGy2,bx
L01:    mov     bx,ARGy2
        sub     bx,ARGy1
        jz      HorizLine
        jns     L03
        neg     bx
        neg     si
L03:    push    si
        mov     VARroutine,offset LoSlopeLine
        cmp     bx,cx
        jle     L04
        mov     VARroutine,offset HiSlopeLine
        xchg    bx,cx
L04:    shl     bx,1
        mov     VARincr1,bx
        sub     bx,cx
        mov     si,bx
        sub     bx,cx
        mov     VARincr2,bx
        push    cx
        mov     ax,ARGy1
        mov     bx,ARGx1
        call    PixelAddr
        mov     di,bx
        pop     cx
        inc     cx
        pop     bx
        jmp     VARroutine
VertLine:
        mov     ax,ARGy1
        mov     bx,ARGy2
        mov     cx,bx
        sub     cx,ax
        jge     L31
        neg     cx
        mov     ax,bx
L31:    inc     cx
        mov     bx,ARGx1
        push    cx
        call    PixelAddr
        pop     cx
        mov     di,bx
        dec     si
        mov     al,ARGn
;------------------------------
L32:    stosb
        add     di,si
        loop    L32
        jmp     Lexit
HorizLine:
        push    cx
        mov     ax,ARGy1
        mov     bx,ARGx1
        call    PixelAddr
        mov     di,bx
        pop     cx
        inc     cx
        mov     al,ARGn
        rep     stosb
        jmp     short Lexit
LoSlopeLine:
        mov     al,ARGn
L11:    stosb
        or    si,si
        jns   L12
        add   si,VARincr1
        loop  L11
        jmp   short Lexit
L12:    add   si,VARincr2
        add   di,bx
        loop  L11
        jmp   short Lexit

HiSlopeLine:
        mov   al,ARGn
L21:    stosb
        add   di,bx
L22:    or    si,si
        jns   L23
        add   si,VARincr1
        dec   di
        loop  L21
        jmp   short Lexit
L23:    add   si,VARincr2
        loop  L21
Lexit:
        pop   di
        pop   si
        popa
        mov   sp,bp
        pop   bp
        ret   10
Line    endp

PixelAddr       proc near
                xchg    ah,al
                add     bx,ax
                shr     ax,2
                add     bx,ax
                mov     ax,cs:[DrawSeg]
                mov     es,ax
                ret
PixelAddr       EndP
