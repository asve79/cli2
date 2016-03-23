;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #4D nvRamSetData
;---------------------------------------
; Записать данные в ячейки nvRam
; i: A' - номер ячейки
;    L - новые данные

; Ячейки nvRam:
; #00 – регистр секунд
; #01 – регистр секунд (будильник) [реализовано?]
; #02 – регистр минут
; #03 – регистр минут (будильник) [реализовано?]
; #04 – регистр часов
; #05 – регистр часов (будильник) [реализовано?]
; #06 – регистр дня недели
; #07 – регистр дня месяца
; #08 – регистр месяца
; #09 – регистр года
; #0A - статусная ячейка A. Чтение <- #00. [???]
; #0B - статусная ячейка B. Чтение <- #02.
;			    Запись -> установка бита data mode
; #0C - статусная ячейка C. Чтение <- 2-й бит = 0/1 - статус Write Protect SD карты
;				      3-й бит = 0/1 - статус нахождения SD карты в разъеме
;			    Запись -> 0-ой бит = 1 — сброс буфера кодов PS/2 клавиатуры
;				      1-й бит = 0/1 — управляет состоянием Caps Lock Led
; #0D - статусная ячейка D. Чтение <- #80. [???]
; ...
; #F0…#FF — любая из ячеек этой группы!
;	    запись -> #00 — подготовить данные о версии базовой конфигурации
;	    запись -> #01 — подготовить данные о версии bootloader
;	    запись -> #02 — подготовить данные с PS/2 клавиатуры
;             чтение <- скан-код клавиатуры
;---------------------------------------
_nvRamSetData	ex	af,af'
		ld	bc,peNvRamLocation
		out	(c),a
		ld	bc,peNvRamData
		ld	a,l
		out	(c),a
		ret
;---------------------------------------