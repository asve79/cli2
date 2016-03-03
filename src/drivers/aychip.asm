;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; Ay Chip driver (player)
;---------------------------------------
_pt3init	ld	a,ayBank
		call	_setRamPage0
		ld	hl,#0000
		call	INIT
		jp	_restoreWcBank
		
;---------------------------------------
_pt3play	ld	a,ayBank
		call	_setRamPage0
		call	PLAY
		jp	_restoreWcBank
;---------------------------------------
_pt3loopEnable	ld	a,(START)
		and	%00000110
		ld	(START),a
		ret
;---------------------------------------
_pt3loopDisable	ld	a,(START)
		and	%00000110
		or	%00000001
		ld	(START),a
		ret

;---------------------------------------
_pt3setType	ex	af,af'
		sla	a
		ld	c,a
		ld	a,(START)
		and	%00000001
		or	c
		ld	(START),a
		ret
;---------------------------------------
	include	"pt3play.asm"
;---------------------------------------
_pt3mute	equ	MUTE
;---------------------------------------