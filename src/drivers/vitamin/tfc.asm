        ifndef _tfc_asm_defined
        define _tfc_asm_defined

        module TFC

;CP866
; Original version by (C) Alone Coder
; SjasmPlus adaptation, code cleanup and size optimization by (C) Vitamin/CAIG

; Warning: no 60Hz modules support!

;TODO begin&end ⮫쪮 � ����� ������
newtfm=1 ;0=revision A, 1=revision C

        if newtfm == 1
statuschip0=%11111000
statuschip1=%11111001
        else
        if newtfm == 2 ;US031DX
statuschip0=%11111110
statuschip1=%11111111
        else ;newtfm=0
statuschip0=%11111100
statuschip1=%11111101
        endif
        endif

        struct Header
signature
        ds 6
version ds 3
intfreq db 0
tfmptrs ds 12
ssgptrs ds 12
        ends

        struct TFMData
addr    dw 0
skip    db 0
blkcnt  db 0
blkretaddr
        db 0
loopaddr
        db 0
tfmlow  db 0
tfmhigh db 0
        ends

        macro WaitStatus
        if newtfm != 2
        inf
        jp m,$-2
        endif
        endm

        macro FM.OutReg Reg
        WaitStatus
        out (c),Reg
        endm

        macro FM.SelectReg Reg
        ld b,d
        FM.OutReg Reg
        endm

        macro FM.WriteReg Reg
        ld b,e
        FM.OutReg Reg
        endm

Start
        ld hl,End
        jr Init
        jp Play
        jp Mute

        ifdef HaveFormatCheck
        include "format.asm"

;in HL - module addr
;out Z - is tfc
;out C - 60 Hz (valid only if Z)
CheckFormat
        EqualTo "T"
        EqualTo "F"
        EqualTo "M"
        EqualTo "c"
        EqualTo "o"
        EqualTo "m"
        AnyBytes 3
        ld a,(hl)
        cp 50
        ret z
        cp 60
        ccf
        ret

;         display "TFC checker size: ",$-CheckFormat
        endif

;HL - module addr
Init
        exd
        ld hl,Header.tfmptrs
        add hl,de
        exx

        ld hl,TFM.Init
        ld de,TFM.A
        ld bc,6*TFMData
        ldir

        ld hl,.tfminitab
        ld bc,128*(.tfminitab_end-.tfminitab)+#fd
.tfmini0
        ld de,.tfminiHL
        ldi
        ldi
        exx
        ld a,(hl)
        inc hl
        push hl
        ld h,(hl)
        ld l,a
        add hl,de
.tfminiHL=$+1
        ld (0),hl
        pop hl
        inc hl
        exx
        djnz .tfmini0

        jp Mute

.tfminitab
        DW TFM.A.addr
        DW TFM.B.addr
        DW TFM.C.addr
        DW TFM.D.addr
        DW TFM.E.addr
        DW TFM.F.addr
.tfminitab_end

Mute
        ld de,#ffbf
        ld c,#fd
        call selChip0
        call .tfminiPP
        call selChip1
.tfminiPP
        ; 0 -> (00..0D)
        ld hl,#0000
        ld a,#0e
        call .writeregsset

        ; 0 -> (30..3F)
        ld h,#30
        ld a,#40
        call .writeregsset

        ; 0 -> (50..B4)
        ld h,#50
        ld a,#b5
        call .writeregsset

        ; 0F -> (80..8F) ;max speed to RR
        ld hl,#800f
        ld a,#90
        call .writeregsset

        ; 0..2 -> 28, key off
        ; 2 -> 27 channel 3 mode
        ld hl,#2800
        call .writereg
        inc l
        call .writereg
        inc l
        call .writereg
        dec h
        call .writereg

        ; 7F -> (40..4F,2F,2D)
        ld hl,#407f
        ld a,#50
        call .writeregsset

        ld h,#2f
        call .writereg

        ld h,#2d
        call .writereg

        ld a,#ff ;�몫. FM
.selRegA
        ld b,d
        out (c),a
        ret

;H=REG start
;L=VALUE
;A=REG end (not inclusive)
.writeregsset
        call .writereg
        inc h
        cp h
        jr nz,.writeregsset
        ret
;H=REG
;L=VALUE
.writereg
        FM.SelectReg h
        FM.WriteReg l
        ret

selChip0
        ld a,statuschip0
        jr Mute.selRegA

selChip1
        ld a,statuschip1
        jr Mute.selRegA

Play
        ld de,#FFBF
        ld c,#FD

        call selChip0

        xor a
        exa
        ld ix,TFM.A
        call PlayChannel
        ld a,1
        exa
        ld ix,TFM.B
        call PlayChannel
        ld a,2
        exa
        ld ix,TFM.C
        call PlayChannel

        call selChip1

        xor a
        exa
        ld ix,TFM.D
        call PlayChannel
        ld a,1
        exa
        ld ix,TFM.E
        call PlayChannel
        ld a,2
        exa
        ld ix,TFM.F
        jp PlayChannel

;%11111111,-disp8 = ����� ���� ����� �� ᬥ饭�� -disp8
;%111ttttt = skip 32..2 frames
;%110ddddd = slide d-16
;%11010000,frames,-disp16 = repeat block (skips = 1 frame)
;%10111111,-disp16 = ����� ���� ����� �� ᬥ饭�� -disp16
;%10NNNNNf = keyoff,[freq,]0..30 regs, keyon
;%01111111 = end
;%01111110 = begin
;%01NNNNNf = keyoff,[freq,]0..31 regs
;%00NNNNNf =        [freq,]0..30 regs
bb=%01111110
be=%01111111
;IX - data
;DE - hi ports #FFBF
;C - low port #FD
;A' - fm channel
PlayChannel
        ld a,(ix+TFMData.skip)
        inc a
        jp nz,.skiper
        ld a,(ix+TFMData.blkcnt)
        and a
        jr z,.noframe
        dec (ix+TFMData.blkcnt)
        jr nz,.noframe
        ld l,(ix+TFMData.blkretaddr)
        ld h,(ix+TFMData.blkretaddr+1)
        jr .tfmframe
.begin
        ld (ix+TFMData.loopaddr),l
        ld (ix+TFMData.loopaddr+1),h
        jr .tfmframe
.end
        ld l,(ix+TFMData.loopaddr)
        ld h,(ix+TFMData.loopaddr+1)
        jr .tfmframe
.noframe
        ld l,(ix+TFMData.addr)
        ld h,(ix+TFMData.addr+1)
.tfmframe
        ld a,(hl)
        inc hl
        cp bb
        jr z,.begin
        cp be
        jr z,.end
        cp e ;#BF
        jp NC,.HLskiper
;TestKeyOff
        jp P,.noffX
        push af
        ld a,#28
        FM.SelectReg a
        exa
        FM.WriteReg a ;FMChannel
        exa
        pop af
.noffX
        OR a
        push af
;TestFreq
        RRA
        jr NC,.nofrqX

        ld b,(hl)
        inc hl
        ld c,(hl)
        inc hl
        ld (ix+TFMData.tfmhigh),b
        ld (ix+TFMData.tfmlow),c
        push bc
        ex (sp),hl
        ld c,#FD
        call .outTone
        pop hl

.nofrqX
        and #1F
        call nz,.OutRegs
        call .storeaddr
        pop af
        ret P
;.KeyOn
        ld a,#28
        FM.SelectReg a
        exa
        add a,#F0
        FM.WriteReg a
        sub #F0
        exa
        ret

.block
        ld a,(hl) ;N frames
                  ;1 now, N-1 later
                  ;skip command is used as 1 frame
        inc hl
        ld (ix+TFMData.blkcnt),a
        ld b,(hl)
        inc hl
        ld c,(hl) ;disp
        inc hl
        ld (ix+TFMData.blkretaddr),l
        ld (ix+TFMData.blkretaddr+1),h
.subframe
        add hl,bc
        ld c,#fd
        jp .tfmframe

.OLDfar
        ld b,(hl)
        inc hl
.OLDnear
        ld c,(hl)
        inc hl
        push hl
        call .subframe
        pop hl
.storeaddr
        ld (ix+TFMData.addr),l
        ld (ix+TFMData.addr+1),h
        ret
.HLskiper
        jr z,.OLDfar
        cp %11100000
        jr c,.slide
        ld b,a
        cp d ;#FF
        jr z,.OLDnear
        call .storeaddr
.skiper ld (ix+TFMData.skip),a
        ret
.slide
       ;a=-64..-33
        add a,48
       ;a=-16..15
        jr z,.block
        add a,(ix+TFMData.tfmlow)
        ld (ix+TFMData.tfmlow),a
        call .storeaddr
        ld h,(ix+TFMData.tfmhigh)
        ld l,a
.outTone
        exa
        add a,#a4
        FM.SelectReg a
        FM.WriteReg h
        sub #04  ;#A0+channel
        FM.SelectReg a
        FM.WriteReg l
        sub #a0
        exa
        ret

.OutRegs ld b,d ;%11111xxx
        WaitStatus
        outi   ;reg
        WaitStatus
        ld b,e ;#BF
        outi   ;value
        dec a
        jr nz,.OutRegs ;� turbo jr=jp
        ret

TFM.Init TFMData 0,-1,0
TFM.A  TFMData
TFM.B  TFMData
TFM.C  TFMData
TFM.D  TFMData
TFM.E  TFMData
TFM.F  TFMData

       endmod
TFC.End

;        display "TFC module size: ",TFC.End-TFC.Start

       endif
