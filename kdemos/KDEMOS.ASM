.model tiny

stack   1024

.386

Extrn           HscPlayer : FAR


CODE   SEGMENT USE16

       ASSUME  CS:CODE,DS:CODE,ES:CODE,FS:CODE,GS:CODE

; Alt+22+X: (X)
; X= RGBNF
;    ³³³³ÀÄÄÄFlash
;    ³³³ÀÄÄÄÄraNdom
;    ³³ÀÄÄÄÄÄBlue
;    ³ÀÄÄÄÄÄÄGreen
;    ÀÄÄÄÄÄÄÄRed


Text            label byte
;                db      ' B®ªàãâ¨¢ áâà¥«ª ¬¨ N  B¬®¦­® ¯®à¥£ã«¨à®¢ âì'
;                db      ' áª®à®áâì áªà®««¨­£ F...'
;                db      '  R—¨áâë©  áá¥¬¡«¥à. Š á®¦ «¥­¨î ¨§ ¬ã§ëª «ì­ëå ª àâ®ç¥ª'
;                db      ' ¯®¤¤¥à¦¨¢ ¥âáï ¯®ª  â®«ìª® ADLIB'
;                db      '  GRG'
;                db      '  BÌ¹el from G=KRoN= F!!!'
;                db      20 dup (' ')
                db      '            GÌ¹el !!! R â¨ ä ©«ë ¨§ ¬®¥£®  àå¨¢ .'
                db      ' B ®«ì§ã©â¥áì ­  §¤®à®¢ì¥ F!!! R=KRoN=. GRG   '
TextSize        = $ - Text

Begin:
                push    es
                mov     ax,SEG MusicData
                mov     es,ax
                mov     si,OFFSET MusicData
                xor     ah,ah
                xor     bl,bl
                call    HscPlayer
                pop     es

                cld
                mov     bx,1000h
                mov     ah,4Ah
                int     21h                     ; DOS Services  ah=function 4Ah
                                                ;  change memory allocation
                                                ;   bx=bytes/16, es=mem segment
                mov     ah,48h                  ; 'H'
                mov     bx,4000
                int     21h                     ; DOS Services  ah=function 48h
                                                ;  allocate memory, bx=bytes/16
                jnc     short loc_112           ; Jump if carry=0
                jmp     ExitToDOS

loc_112:
                mov     bx,cs
                mov     ds,bx
                mov     es,bx
                mov     [WorkSeg],ax

                mov     ah,48h                  ; 'H'
                mov     bx,4000
                int     21h                     ; DOS Services  ah=function 48h
                                                ;  allocate memory, bx=bytes/16
                mov     [BackSeg],ax
                jnc     short loc_113           ; Jump if carry=0
                jmp     ExitToDOS

VSEG            dw      0A000h
WorkSeg         dw      ?
BackSeg         dw      ?
FillScr         dw      0
;FontAdr         dw      ?
;FontSeg         dw      ?
TextPtr         dw      0
TextY           dw      (200-16*8)/2
TextX           dw      0
TextYDir        dw      1
TextPasses      dw      0
TextColor       dw      0800h
LastColor       dw      0800h
ScrollSpeed     dw      3
ScrollCount     dw      1

ProcTable       dw      offset LissagLine
                dw      offset LissagLine
                dw      offset SplitLine
                dw      offset FrameLine1
                dw      offset FlyingBox
                dw      offset SlasheLine
                dw      offset RandomLine
ProcTableSize   = ($ - ProcTable)/2
EndProc         dw      0
ProcPtr         dw      0

ColTab          dw      800h,820h,840h
ColTabSize      = ($ - ColTab)/2

loc_113:
                call    ClearBack
                call    randomize

                mov     ax,cs
                mov     es,ax

                mov     di,offset Pal
                mov     cx,32
                xor     ax,ax
lfp1:           xchg    ah,al
                stosw
                stosb
                xchg    ah,al
                inc     al
                inc     al
                loop    lfp1 ; Green 0 .. 31

                mov     cx,32
                xor     al,al
lfp2:           stosb
                push    ax
                xor     ax,ax
                stosw
                pop     ax
                inc     al
                inc     al
                loop    lfp2 ; Red 32 .. 63

                mov     cx,32
                xor     al,al
lfp3:           push    ax
                xor     ax,ax
                stosw
                pop     ax
                stosb
                inc     al
                inc     al
                loop    lfp3 ; Blue 64 .. 95

                mov     al,13h
                call    SetVMode

;--------------------------------------------------------
;l                mov     ax,1130h
;l                mov     bh,6 ; font 8x16
;                int     10h
;                mov     [FontAdr],bp
;                mov     [FontSeg],es
;--------------------------------------------------------
;                mov     dx,3CEh ; Set 128k page
;                mov     al,6
;                cli
;                out     dx,al
;                inc     dx
;                in      al,dx
;                and     al,0F3h
;                out     dx,ax
;                sti
;
;                mov     dx,3CCh
;                cli
;                in      al,dx
;                and     al,not 20h
;                mov     dx,3C2h
;                out     dx,al
;                sti
;
;                mov     dx,3DAh
;loc3da:         in      al,dx
;                test    al,1
;                jz      loc3da
;                mov     dx,3D4h
;                mov     ax,000Dh ; low byte of address
;                out     dx,ax
;                mov     ax,810Ch ; high
;                out     dx,ax
;
;                mov     ax,100*256+18h
;                out     dx,ax
;                mov     al,11
;                cli
;                out     dx,al
;                inc     dx
;                in      al,dx
;                and     al,7Fh
;                out     dx,al
;                sti
;                dec     dx
;                mov     al,7
;                cli
;                out     dx,al
;                inc     dx
;                in      al,dx
;                and     al,not 10h
;                out     dx,al
;                sti
;                dec     dx
;                mov     al,9
;                cli
;                out     dx,al
;                inc     dx
;                in      al,dx
;                and     al,not 40h
;                out     dx,al
;                sti
;                dec     dx
;
;
;;                mov     dx,3D4h ; Set even/odd
;;                mov     al,5
;;                out     dx,al
;;                inc     dx
;                in      al,dx
;                mov     ah,al
;                xor     ah,80h
;                mov     al,5
;                dec     dx
;                out     dx,ax

;                mov     dx,3D4h
;                mov     ax,

;--------------------------------------------------------
                mov     word ptr [TextPtr],0
;--------------------------------------------------------
                mov     ax,cs
                mov     es,ax
                mov     di,offset Pal+96*3
;--------------------------------------------------------
                mov     cx,160
l1:             push    di
                call    rnd_col
                pop     di
                mov     si,offset Rc
                lodsw
                stosb
                lodsw
                stosb
                lodsw
                stosb
                loop    l1
                mov     si,offset Pal
                call    set_pal
;=========================================================
                xor     ax,ax
                mov     CS:[FillScr],ax
                mov     CS:[EndProc],ax
                mov     bx,ProcTableSize
                call    rnd
                mov     CS:[ProcPtr],ax
;---------------------------------------------------------
Main_Loop:      call    Inkey
                jz      PassKey
                call    Key
                cmp     al,27
                je      ExitToDos
                or      al,al
                jz      CtrlKey
                cmp     al,0E0h
                jne     PassKey
CtrlKey:
                mov     bx,cs:[ScrollSpeed]
                cmp     ah,4Dh ; right
                jne     Key2
                dec     bx
                cmp     bx,0
                jne     SetScroll
                dec     bx
                jmp     SetScroll
Key2:
                cmp     ah,4Bh ; Left
                jne     PassKey
                inc     bx
                cmp     bx,0
                jne     SetScroll
                inc     bx
SetScroll:
                neg     bx
                mov     cs:[ScrollCount],bx
                neg     bx
                mov     cs:[ScrollSpeed],bx
PassKey:
                cmp     word ptr CS:[EndProc],0
                jne     pass_p
                mov     si,cs:[ProcPtr]
                add     si,si
                call    CS:[ProcTable][si]
                jmp     short pass_l
pass_p:         mov     bx,100
                call    rnd
                or      ax,ax
                jz      BeginNewProc
                call    CopyBackToWork
                jmp     short pass_l
BeginNewProc:
                mov     bx,ProcTableSize
                call    rnd
                mov     CS:[ProcPtr],ax
                xor     ax,ax
                mov     CS:[FillScr],ax
                mov     CS:[EndProc],ax
;-------------------------------------------
pass_l:

                mov     si,offset Rc
                call    rnd_col
                mov     si,offset Rc
                mov     di,offset pal + 768
                lodsw
                stosb
                lodsw
                stosb
                lodsw
                stosb
                mov     si,offset pal+96*3+3
                mov     di,offset pal+96*3
                push    cx
                mov     cx,160*3
rep             movsb
                pop     cx
;--------------------------------------------------
;**********[ Out String ]**************************
                mov     ax,CS:[WorkSeg]
                mov     CS:[DrawSeg],ax

                mov     si,CS:[LastColor]
                mov     CS:[TextColor],si
                mov     bx,CS:[TextX]
                mov     dx,CS:[TextY]
                mov     si,CS:[TextPtr]
                mov     cx,6
                mov     al,cs:[Text][si]
                cmp     al,''
                jne     loc3
                inc     si
                mov     al,cs:[Text][si]
                inc     si
                mov     CS:[TextPtr],si
                call    DecodeColor
                mov     CS:[LastColor],ax
                mov     CS:[TextColor],ax
loc3:           mov     al,cs:[Text][si]
                cmp     al,22 ; ''
                jne     ContOutChar
                inc     si
                mov     al,cs:[Text][si]
                inc     si
                call    DecodeColor
                mov     CS:[TextColor],ax
                jmp     loc3
ContOutChar:
                inc     si
                cmp     si,TextSize
                jl      loc4
                mov     si,0
loc4:
                call    PutChar
                add     bx,8*8
                loop    loc3
                mov     ax,cs:[ScrollSpeed]
                cmp     ax,0
                jg      Scroll
                dec     cs:[ScrollCount]
                cmp     cs:[ScrollCount],0
                je      Scroll
                jmp     Scroll_pass
Scroll:
                cmp     ax,0
                jg      Scroll1
                neg     ax
                mov     CS:[ScrollCount],ax
                mov     ax,1
Scroll1:        sub     word ptr cs:[TextX],ax
                cmp     word ptr cs:[TextX],-64
                jg      loc5
                mov     word ptr cs:[TextX],0
                inc     word ptr cs:[TextPtr]
                cmp     word ptr cs:[TextPtr],TextSize
                jl      loc5
                mov     word ptr cs:[TextPtr],0
                inc     word ptr cs:[TextPasses]
loc5:
                mov     ax,cs:[TextY]
                add     ax,cs:[TextYDir]
                cmp     ax,0
                jge     loc6
                mov     word ptr cs:[TextYDir],1
                mov     ax,0
loc6:           cmp     ax,72
                jl      loc7
                mov     word ptr cs:[TextYDir],-1
                mov     ax,71
loc7:           mov     cs:[TextY],ax
Scroll_pass:
;-----[ Copy to Screen ]---------------------------
                mov     ds,CS:[WorkSeg]
                xor     si,si
                mov     es,CS:[VSEG]
                xor     di,di
                call    WaitVR
                mov     cx,16000
ml1:            mov     eax,[si]
                mov     es:[di],eax
                add     si,4
                add     di,4
                loop    ml1
;rep             movsd
;                call    WaitVR
;                mov     cx,8000
;rep             movsd
;                call    WaitVR
                push    cs
                pop     ds
                mov     si,offset Pal
                call    set_pal
;---------------------------------------------------
                jmp     Main_Loop

ExitToDos:
                mov     al,3
                call    SetVMode
;                mov     ah,3
;                call    HscPlayer
;                call    Key
                mov     ah,2
                call    HscPlayer
                mov     ax,4C00h
                int     21h

Rc      dw      30
Gc      dw      10
Bc      dw      0
Rdir    dw      3
Gdir    dw      -1
Bdir    dw      5

rnd_col         proc    near
                pusha
                mov     di,cs
                mov     ds,di
                mov     es,di
                mov     di,offset Rc
                mov     si,offset Rdir
                mov     cx,3
rnd_col_1:
                mov     ax,[si]
                add     ax,[di]
                cmp     ax,0
                jge     rnd_col_2
                mov     bx,7
                push    es di
                call    rnd
                pop     di es
                inc     ax
                mov     [si],ax
                jmp     short rnd_col_1
rnd_col_2:
                cmp     ax,63
                jle     rnd_col_3
                mov     bx,7
                push    es di
                call    rnd
                pop     di es
                inc     ax
                neg     ax
                mov     [si],ax
                jmp     short rnd_col_1
rnd_col_3:      stosw
                lodsw
                loop   rnd_col_1
                popa
                ret
rnd_col         endp

PCVar           dw      ?
PutChar         proc    near ; al=char; bx,dx = up,left
                mov     CS:[PCVar],cx
                pusha
                xor     ah,ah
 ;               mov     fs,cs:[FontSeg]
                mov     si,offset Font16
                shl     ax,4
                add     si,ax
                mov     di,16
pc1:            push    bx
                mov     al,cs:[si]
                inc     si
                mov     cx,8
pc2:            add     al,al
                jnc     pass_pixel
                pusha
                push    dx

                mov     ax,cs:[TextColor]
                cmp     ax,0
                jg      pc3

                xor     al,cl
                xor     ax,di
                xor     ax,cs:[TextPasses]
                mov     dx,cs:[PCVar]
                sub     dx,cs:[TextPtr]
                xor     ax,dx
                xor     dx,dx
                mov     cx,ColTabSize
                div     cx
                add     dx,dx
                mov     si,dx
                mov     ax,cs:[ColTab][si]
pc3:
                pop     dx
                mov     cx,4
                call    FillBox2
                popa
pass_pixel:
                add     bx,8
                loop    pc2
                pop     bx
                add     dx,8
                dec     di
                jnz     pc1
                popa
                ret
PutChar         endp

set_pal         proc    near
                push    dx cx ax si
                mov     dx,3C8h
                xor     al,al
                out     dx,al                   ; port 3C8h, VGA pel address
                inc     dx
                mov     cx,768
                mov     si,offset Pal
locloop_5:
                lodsb                           ; String [si] to al
                out     dx,al                   ; port 3C9h, VGA pel data reg
                loop    locloop_5               ; Loop if cx > 0
                pop     si ax cx dx
                ret
endp

SlasheLine      proc    near
                mov     cx,2
                mov     ax,CS:[BackSeg]
                mov     CS:[DrawSeg],ax
SlL1:
                mov     ax,319
                sub     ax,CS:[FillScr]
                shr     ax,1
                add     ax,96
                push    ax
                push    ax
                push    0
                push    word ptr CS:[FillScr]
                push    199
                push    0
                call    line
                push    0
                push    319
                push    199
                mov     ax,319
                sub     ax,CS:[FillScr]
                push    ax
                call    line
                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],320
                je      SlLiStop
                loop    SlL1
                jmp     CopyBackToWork
SlLiStop:       mov     word ptr cs:[EndProc],-1
                jmp     CopyBackToWork
SlasheLine      endp

SplitLine       proc    near
                mov     ax,CS:[BackSeg]
                mov     CS:[DrawSeg],ax
                mov     ax,159
                sub     ax,CS:[FillScr]
                add     ax,96
                push    ax
                push    ax
                push    0
                push    word ptr CS:[FillScr]
                push    199
                push    word ptr CS:[FillScr]
                call    line
                push    0
                mov     ax,319
                sub     ax,CS:[FillScr]
                push    ax
                push    199
                push    ax
                call    line
                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],160
                jne     SpLiEx
                mov     word ptr cs:[EndProc],-1
SpLiEx:         jmp     CopyBackToWork
SplitLine       endp

RandomLine      proc    near
                mov     ax,CS:[BackSeg]
                mov     CS:[DrawSeg],ax
                mov     cx,20
RLLoop:
                mov     bx,160
                call    rnd
                add     ax,96
                push    ax ; color
                mov     bx,200
                call    rnd
                push    ax ; y2
                mov     bx,320
                call    rnd
                push    ax ; x2
                mov     bx,200
                call    rnd ; y1
                push    ax
                mov     bx,320
                call    rnd
                push    ax ; x1
                call    line
                loop    RLLoop
                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],50
                jne     RLEx
                mov     word ptr cs:[EndProc],-1
RLEx:           jmp     CopyBackToWork
RandomLine      endp

WaitVR          proc    near
                mov    dx,3DAh
WaitVR_off:     in     al,dx
                test   al,8
                jnz    WaitVR_off
WaitVR_on:      in     al,dx
                test   al,8
                jz     WaitVR_on
                ret
WaitVR          Endp

FBvarX          dw      ?
FBvarY          dw      ?
FBcolor         dw      ?
FlyingBox       Proc    near
                call    CopyBackToWork

                mov     ax,CS:[WorkSeg]
                mov     CS:[DrawSeg],ax

                cmp     word ptr cs:[FillScr],0
                jne     FB_NoFirst

                mov     bx,3
                call    rnd

                or      ax,ax
                jz      FB_1

                mov     word ptr CS:[FBvarX],-64
                jmp     short FB_2
FB_1:
                mov     word ptr cs:[FBvarX],320
FB_2:
                mov     bx,3
                call    rnd

                or      ax,ax
                jz      FB_3

                mov     word ptr CS:[FBvarY],-64
                jmp     short FB_4
FB_3:
                mov     word ptr cs:[FBvarY],200
FB_4:
                mov     bx,3
                call    rnd
                shl     al,5
                mov     ah,1
                mov     cs:[FBColor],ax
FB_NoFirst:
                cmp     word ptr CS:[FBvarX],160
                jle     FBxless
                mov     cx,-4
                jmp     short FB_5
FBxless:        mov     cx,-2
FB_5:           mov     bx,7
                call    rnd
                add     ax,cx
                add     CS:[FBvarX],ax
                cmp     word ptr CS:[FBvarY],100
                jle     FByless
                mov     cx,-4
                jmp     short FB_6
FByless:        mov     cx,-2
FB_6:           mov     bx,7
                call    rnd
                add     ax,cx
                add     CS:[FBvarY],ax

                mov     bx,CS:[FBvarX]
                mov     dx,CS:[FBvarY]
                mov     cx,32
                mov     ax,cs:[FBColor]
                call    FillBox2

                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],400
                jne     FB_Ret
                mov     word ptr cs:[EndProc],-1
FB_Ret:         ret
FlyingBox       Endp

CopyBackToWork  Proc    near
                mov     ds,cs:[BackSeg]
                xor     si,si
                mov     es,cs:[WorkSeg]
                xor     di,di
                mov     cx,16000
l2:             mov     eax,[si]
                mov     es:[di],eax
                add     si,4
                add     di,4
                loop    l2
;rep             movsd
                mov     ax,cs
                mov     ds,ax
                mov     es,ax
                ret
CopyBackToWork  endp

FL1x            dw      ?
FL1y            dw      ?

FrameLine1      proc    near
                mov     ax,CS:[BackSeg]
                mov     CS:[DrawSeg],ax

                cmp     word ptr cs:[FillScr],0
                jne     FL1_NoFirst
                mov     cs:[FL1x],159

FL1_NoFirst:    mov     ax,159
                sub     ax,CS:[FillScr]
                add     ax,96
                push    ax
                push    ax
                push    ax
                push    ax
                mov     ax,CS:[FL1x]
                mov     cx,100
                mul     cx
                mov     cx,160
                div     cx
                mov     CS:[FL1y],ax

                push    0
                push    word ptr CS:[FL1x]
                push    word ptr CS:[FL1y]
                push    0
                call    line

                push    word ptr CS:[FL1y]
                push    319
                push    0
                mov     cx,319
                sub     cx,CS:[FL1x]
                push    cx
                call    line

                push    199
                push    word ptr CS:[FL1x]
                mov     cx,199
                sub     cx,CS:[FL1y]
                push    cx
                push    0
                call    line

                mov     cx,199
                sub     cx,CS:[FL1y]
                push    cx
                push    319
                push    199
                mov     cx,319
                sub     cx,CS:[FL1x]
                push    cx
                call    line

                dec     word ptr cs:[FL1x]
                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],160
                jne     FL1_Ex
                mov     word ptr cs:[EndProc],-1
FL1_Ex:         jmp     CopyBackToWork
FrameLine1      endp

LLx1            dw      0
LLy1            dw      0
LLx2            dw      0
LLy2            dw      0
LLwx1           dw      0
LLwx2           dw      0
LLwy1           dw      0
LLwy2           dw      0
LLimax          dw      5000
LLdx            dw      159
LLdy            dw      99
LLcolor         dw      ?
LLcolDir        dw      ?
LLfactor        dw      10
LLphase         dw      ?

LissagLine      proc    near

                mov     ax,CS:[BackSeg]
                mov     CS:[DrawSeg],ax

                cmp     word ptr cs:[FillScr],0
                jne     LL_NoFirst

                call    ClearBack

                call    rand
                mov     cs:[LLphase],ax
                mov     bx,CS:[LLimax]
                call    rnd
                mov     CS:[LLwx1],ax
                mov     bx,CS:[LLimax]
                call    rnd
                mov     CS:[LLwx2],ax
                mov     bx,CS:[LLimax]
                call    rnd
                mov     CS:[LLwy1],ax
                mov     bx,CS:[LLimax]
                call    rnd
                mov     CS:[LLwy2],ax

                mov     bx,160
                call    rnd
                add     ax,96
                mov     CS:[LLcolor],ax
                mov     bx,7
                call    rnd
                sub     ax,2
                mov     CS:[LLcolDir],ax

LL_NoFirst:
                fild    word ptr cs:[FillScr]
                fild    word ptr cs:[LLphase]
                fadd
                fild    word ptr cs:[LLfactor]
                fdiv

                fld     st(0)
                fild    word ptr CS:[LLwx1]
                fild    word ptr CS:[LLimax]
                fdiv
                fmul
                fcos
                fld1
                fadd
                fild    word ptr CS:[LLdx]
                fmul
                fistp   word ptr CS:[LLx1]

                fld     st(0)
                fild    word ptr CS:[LLwy1]
                fild    word ptr CS:[LLimax]
                fdiv
                fmul
                fsin
                fld1
                fadd
                fild    word ptr CS:[LLdy]
                fmul
                fistp   word ptr CS:[LLy1]

                fld     st(0)
                fild    word ptr CS:[LLwx2]
                fild    word ptr CS:[LLimax]
                fdiv
                fmul
                fcos
                fld1
                fadd
                fild    word ptr CS:[LLdx]
                fmul
                fistp   word ptr CS:[LLx2]

                fild    word ptr CS:[LLwy2]
                fild    word ptr CS:[LLimax]
                fdiv
                fmul
                fsin
                fld1
                fadd
                fild    word ptr CS:[LLdy]
                fmul
                fistp   word ptr CS:[LLy2]

                fwait

                mov     ax,CS:[LLcolor]
                add     ax,CS:[LLcolDir]
                cmp     ax,96
                jge     LL_pass1
                mov     bx,7
                call    rnd
                inc     ax
                mov     CS:[LLcolDir],ax
                mov     ax,96
                jmp     LL_2
LL_pass1:
                cmp     ax,256
                jl      LL_2
                mov     bx,7
                call    rnd
                inc     ax
                neg     ax
                mov     CS:[LLcolDir],ax
                mov     ax,255
LL_2:
                mov     CS:[LLcolor],ax
                push    ax
                push    CS:[LLy2]
                push    CS:[LLx2]
                push    CS:[LLy1]
                push    CS:[LLx1]
                call    line

                inc     word ptr cs:[FillScr]
                cmp     word ptr cs:[FillScr],100
                jne     LL_Ex
                mov     word ptr cs:[EndProc],-1
LL_Ex:          jmp     CopyBackToWork
LissagLine      endp

ClearBack       proc    near
                mov     es,[BackSeg]
                xor     di,di
                xor     eax,eax
                mov     cx,16000
;rep             stosd
l3:             mov     es:[di],eax
                add     di,4
                loop    l3

                mov     ax,cs
                mov     es,ax
                ret
endp

DecodeColor     proc    near ; al<code  color>ax
                cmp     al,'R'
                jnz     dc_1
                mov     ax,0820h
                ret
dc_1:
                cmp     al,'G'
                jnz     dc_2
                mov     ax,0800h
                ret
dc_2:
                cmp     al,'B'
                jnz     dc_3
                mov     ax,0840h
                ret
dc_3:
                cmp     al,'N'
                jnz     dc_4
                mov     ax,-1
                ret
dc_4:
                cmp     al,'F'
                jnz     dc_5
                mov     ax,0860h
dc_5:           ret
DecodeColor     EndP


include key.inc
include line.inc
include sqframe.inc
include Bold16.inc
include random.inc
include fillbox2.inc
include putpixel.inc
include setvmode.inc
include musicdat.inc

Pal     db      768+4 dup (0)

Dummy   db      0
ENDS

end Begin
