;---------------------------------------
; CLi² (Command Line Interface) fonts
; 2015,2016 © breeze/fishbone crew
;---------------------------------------

	MODULE	robat_fnt

		org	#C000

sFont		db	#7f,"FNT"				; #7f+"FNT" - 4 байта сигнатура, что это формат файла FNT
		db	#02					; 1 байт версия формата
		db	#00					; 1 байт тип упаковки данных:
								;		#00 - данные не пакованы
		db	#00					; 1 байт тип шрифта:
								;		#x0 - обычный шрифт
								;		#x1 - наклонный шрифт (italic)
								;		#x2 - жирный шрифт (bold)
								;		#x3 - наклонный + жирный
								;		#8x - если bit 7 = 0, то шрифт моноширный
								;		      и ширина берётся одна для всех
								;		      если bit 7 = 1, то шрифт пропорциональный
								;		      и ширина берётся из таблицы
		db	#01					; 1 байт формат данных шрифта:
								;		#01 - 1 bit (обычный ч/б) шрифт
								;		#02 - 4 bit 16-ти цветный шрифт
								;		#03 - 8 bit 256-ти цветный шрифт
		dw	#0008					; 2 байта ширина шрифта
		dw	#0008					; 2 байта высота шрифта
		dw	bFont-taFont				; 2 байта смещение от текущего адреса до начала данных шрифта

taFont		dw	#0000					; 2 байта смещение от текущего адреса до начала палитры шрифта (если шрифт не 1bit)
		dw	#0000					; 2 байта смещение от текущего адреса до начала таблицы ширины шрифта (если шрифт пропорциональный)

								; Мета-данные:
		dw	neFont-nFont				; 2 байта длина название шрифта
nFont		db	"Font for Wild Commander",#00		; * байт название шрифта, оканчивающихся кодом #00
neFont
		dw	aeFont-aFont				; 2 байта длина автора шрифта
aFont		db	"Robat-e",#00				; * байт автор шрифта, оканчивающихся кодом #00
aeFont
		dw	deFont-dFont				; 2 байта длина описания шрифта
dFont		db	"Original",#00 ; * байт описание шрифта, оканчивающихся кодом #00
deFont

bFont		incbin  "rc/fonts/8x8/robat.bin"			; Начало данных шрифта
eFont

;		ds	256,0					; таблица ширины символов для пропорционального шрифта
								; если задан bit 7 в типе шрифта

; 	DISPLAY "bFont-taFont",/A,bFont-taFont

	SAVEBIN "../../../../install/system/res/fonts/8x8/robat.fnt", sFont, eFont-sFont

	ENDMODULE
