;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; WildCommander API Header >= 0.62
;---------------------------------------
_WCINT		equ	#5BFF	; адрес обработки int wild commander
				; если его изменить отвалится 60% фунционала WC!!!
				; только на свой страх и риск! И да, это недокументированная
				; фича (хак ;)

_PAGE0		equ	#6000	; номер страницы подключенной с адреса #0000-#3fff
_PAGE1		equ	#6001	; номер страницы подключенной с адреса #4000-#7fff
_PAGE2		equ	#6002	; номер страницы подключенной с адреса #8000-#dfff
_PAGE3		equ	#6003	; номер страницы подключенной с адреса #c000-#ffff

_ABT		equ	#6004	; флаг выставляется, если был нажат Esc
_ENT		equ	#6005	; флаг выставляется, если был нажат Enter
_TMN		equ	#6009	; (2 байта) синхра. переменная-таймер, инкрементится по инту

;---------------------------------------
; Основные функции
;---------------------------------------

_MNGC_PL	equ	#00	; включение страницы на #C000 (из выделенного блока)
				; нумерация совпадает с использующейся в +36
				; i:A' - номер страницы (от 0)
				;   #FF - страница с фонтом (1го текстового экрана)
				;   #FE - первый текстовый экран (в нём панели)

_MNG0_PL	equ	#4e	; включение страницы на #0000
				; i:A' - номер страницы (от 0)
				;        не влияет на работу FAT драйвера, НО все структуры
				;	 которые будут подаваться файловым функциям, должны
				;	 лежать в адресах #8000-#FFFF!

_MNG8_PL	equ	#4f	; включение страницы на #8000
				; i:A' - номер страницы (от 0)

_PRWOW		equ	#01	; вывод окна на экран
				; i:IX - адрес по которому лежит структура окна (SOW)

_RRESB		equ	#02	; cтирание окна (восстановление информации)
				; i:IX - SOW

_PRSRW		equ	#03	; печать строки в окне
				; i:IX - SOW
				;   HL - Text addres (должен быть в #8000-#BFFF!)
				;   D - Y
				;   E - X
				;   BC - Lenght

_PRIAT		equ	#04	; выставление цвета (вызывается сразу после PRSRW)
				; i:PRSRW - выставленные координаты и длина
				;   A' - цвет

_GADRW		equ	#05	; получение адреса в окне
				; i:IX - SOW
				;   D - Y
				;   E - X
				; o:HL - Address

_CURSOR		equ	#06	; печать курсора
				; i:IX - SOW

_CURSER		equ	#07	; стирание курсора (восстановление цвета)
				; i:IX - SOW

_YN		equ	#08	; меню ok/cancel
				; i:A'
				;   #01 - инициализация (вычисляет координаты)
				;   #00 - обработка нажатий (вызывать раз в фрейм)
				;   #FF - выход
				; o:NZ - выбран CANCEL
				;   Z - выбран OK

_ISTR		equ	#09	; редактирование строки
				; i:A'
				;   #FF - инициализация (рисует курсор)
				; i:HL - адрес строки
				;   DE - CURMAX+CURNOW (длина строки + начальная позиция курсора в ней)
				;   #00 - опрос клавиатуры
				;         >опрашивает LF,RG,BackSpace
				;         >собственно редактируется строка
				;         >нужно вызывать каждый фрейм
				;   #01 - выход (стирает курсор)

_NORK		equ	#0a	; перевод байта в HEX (текстовый формат)
				; i:HL - Text Address
				;   A - Value
;		equ	#0b
;		equ	#0c

_DMAPL		equ	#0d	; работа с DMA
				; i: A' - тип операции
				; #00 - инит S и D (BHL - Source, CDE - Destination)
				; #01 - инит S (BHL)
				; #02 - инит D (CDE)
				; #03 - инит S с пагой из окна (HL, B - 0-3 [номер окна])
				; #04 - инит D с пагой из окна (HL, B - 0-3 [номер окна])
				; #05 - выставление DMA_T (B - кол-во бёрстов)
				; #06 - выставление DMA_N (B - размер бёрста)
				;
				; #FD - запуск без ожидания завершения (o:NZ - DMA занята)
				; #FE - запуск с ожиданием завершения (o:NZ - DMA занята)
				; #FF - ожидание готовности дма
				;
				; в функциях #00-#02 формат B/C следующий:
				; 			 [7]:%1 - выбор страницы из блока выделенного плагину (0-5)
				; 			     %0 - выбор страницы из видео буферов (0-31)
				;			 [6-0]:номер страницы

_TURBOPL	equ	#0e	; i:B - выбор Z80/AY
				;   #00 - меняется частота Z80
				; i:C - %00 - 3.5 MHz
				;   %01 - 7 MHz
				;   %10 - 14 MHz
				;   %11 - 28 MHz (в данный момент 14MHz)
				;   #01 - меняется частота AY
				; i:C - %00 - 1.75 MHz
				;   %01 - 1.7733 MHz
				;   %10 - 3.5 MHz
				;   %11 - 3.546 MHz

_GEDPL		equ	#0f	; восстановление паллитры, всех оффсетов и txt режима
				; ! обязательно вызывать при запуске плагина!
				; (включает основной txt экран)
				; i:none

;---------------------------------------
; работа с клавиатурой:
;---------------------------------------
_SPKE		equ	#10	; опрос клавиши SPACE
				; o: NZ - нажата

_UPPP		equ	#11	; опрос клавиши UP Arrow
				; o: NZ - нажата

_DWWW		equ	#12	; опрос клавиши Down Arrow
				; o: NZ - нажата

_LFFF		equ	#13	; опрос клавиши Down Arrow
				; o: NZ - нажата

_RGGG		equ	#14	; опрос клавиши Right Arrow
				; o: NZ - нажата
				
_TABK		equ	#15	; опрос клавиши Tab
				; o: NZ - нажата
				
_ENKE		equ	#16	; опрос клавиши Enter
				; o: NZ - нажата
				
_ESC		equ	#17	; опрос клавиши Ecs
				; o: NZ - нажата
				
_BSPC		equ	#18	; опрос клавиши Backspace
				; o: NZ - нажата
				
_PGU		equ	#19	; опрос клавиши pgUP
				; o: NZ - нажата
				
_PGD		equ	#1A	; опрос клавиши pgDN
				; o: NZ - нажата
				
_HOME		equ	#1B	; опрос клавиши Home
				; o: NZ - нажата
				
_END		equ	#1C	; опрос клавиши End
				; o: NZ - нажата
				
_F1		equ	#1D	; опрос клавиши F1
				; o: NZ - нажата
				
_F2		equ	#1E	; опрос клавиши F2
				; o: NZ - нажата
				
_F3		equ	#1F	; опрос клавиши F3
				; o: NZ - нажата
				
_F4		equ	#20	; опрос клавиши F4
				; o: NZ - нажата
				
_F5		equ	#21	; опрос клавиши F5
				; o: NZ - нажата
				
_F6		equ	#22	; опрос клавиши F6
				; o: NZ - нажата
				
_F7		equ	#23	; опрос клавиши F7
				; o: NZ - нажата
				
_F8		equ	#24	; опрос клавиши F8
				; o: NZ - нажата
				
_F9		equ	#25	; опрос клавиши F9
				; o: NZ - нажата
				
_F10		equ	#26	; опрос клавиши F10
				; o: NZ - нажата
				
_ALT		equ	#27	; опрос клавиши Alt
				; o: NZ - нажата
				
_SHIFT		equ	#28	; опрос клавиши Shift
				; o: NZ - нажата
				
_CTRL		equ	#29	; опрос клавиши Ctrl
				; o: NZ - нажата

_KBSCN		equ	#2a	; опрос клавиш
				; i:A' - обработчик
				;   #00 - учитывает SHIFT (TAI1/TAI2)
				;         (можно вызывать только 1 раз в фрейм)
				;   #01 - всегда выдает код из TAI1
				;         (можно вызывать несколько раз за фрейм)
				; o: NZ: A - TAI1/TAI2 (see PS2P.ASM)
				;     Z: A=#00 - unknown key
				;        A=#FF - buffer end

;		equ	#2b	; reserved ???

_CAPS		equ	#2c	; опрос клавиши Caps Lock
				; o: NZ - нажата

_ANYK		equ	#2d	; любая клавиша
				; o: NZ - нажата

_USPO		equ	#2e	; пауза для готовности клавиатуры
				; рекомендуется перед использованием NUSP
				
_NUSP		equ	#2f	; ожидание нажатия любой клавиши

;---------------------------------------
; работа с файлами:
;---------------------------------------
_LOAD512	equ	#30	; потоковая загрузка файла
				; i:HL - Address
				;   B - Blocks (512b)
				; o:HL - New Value

_SAVE512	equ	#31	; потоковая запись файла
				; i:HL - Address
				;   B - Blocks (512b)
				; o:HL - New Value

_GIPAGPL	equ	#32	; позиционировать на начало файла
				; (сразу после запуска плагина — уже вызвана)

_TENTRY		equ	#33	; получить ENTRY(32) из коммандера
				; (структура как в каталоге FAT32)
				; i:DE - Address
				; o:DE(32) - ENTRY

_CHTOSEP	equ	#34	; разложение цепочки активного файла в сектора
				; i:DE - BUFFER (куда кидать номера секторов)
				;   BC - BUFFER END (=BUFFER+BUFFERlenght)

_TENTRYN	equ	#35	; reserved ???

_TMRKDFL	equ	#36	; получить заголовок маркированного файла
				; i:HL - File number (1-2047)
				;   DE - Address (32byte buffer) [#8000-#BFFF!]
				;   (if HL=0; o:BC - count of marked files)
				; o:NZ - File not found or other error
				;   Z - Buffer updated
				;   >так же делается позиционированиена на начало этого файла!!!
				;   >соотв. функции LOAD512/SAVE512 будут читать/писать этот файл от начала.

_TMRKNXT	equ	#37	; reserved ???

;		equ	#38	; reserved ???

_STREAM		equ	#39	; работа с потоками
				; i:D - номер потока (0/1)
				;   B - устройство: 0-SD(ZC)
				;	1-Nemo IDE Master
				;	2-Nemo IDE Slave
				;   C - раздел (не учитывается)
				;   BC=#FFFF: включает поток из D (не возвращает флагов)
				;	      иначе создает/пересоздает поток.
				; o:NZ - устройство или раздел не найдены
				;   Z - можно начинать работать с потоком

; _MKFILE	equ	#3a	; создание файла в активном каталоге
; 				; i:DE(12) - name(8)+ext(3)+flag(1)
; 				;   HL(4) - File Size
; 				; o:NZ - Operation failed
; 				;   A - type of error (in next versions!)
; 				;   Z - File created
; 				;   ENTRY(32) [use TENTRY]

		;equ	#3a	; устаревшая точка вызова !!!

_FENTRY		equ	#3b	; поиск файла/каталога в активной директории
				; i:HL - flag(1),name(1-12),#00
				; 		 flag:#00 - file
				;		      #10 - dir
				;		 name:"NAME.TXT","DIR"...
				; o: Z - entry not found
				;    NZ - CALL GFILE/GDIR for activating file/dir
				;    [DE,HL] - file length

_LOAD256	equ	#3c	; reserved ???
_LOADNONE	equ	#3d	; reserved ???

_GFILE		equ	#3e	; выставить указатель на начало найденного файла
				; (вызывается после FENTRY!)

_GDIR		equ	#3f	; сделать найденный каталог активным
				; (вызывается после FENTRY!)

_MKFILE		equ	#48	; создание файла в активном каталоге
				; i:HL - flag(1),legth(4),name(1-12),#00
				; o:NZ - Operation failed
				;    Z - File created
				;        o:ENTRY(32) [use TENTRY]
				;        После создания файла происходит позиционирование
				;	 на его начало!!!

_MKDIR		equ	#49	; создание каталога в активной директории
				; i:HL - name(1-12),#00
				; o:NZ - Operation failed
				;    Z - Directory created


;---------------------------------------
; работа с режимами графики:
;---------------------------------------
_MNGV_PL	equ	#40	; включение видео страницы
				; i:A' - номер видео страницы
				;   #00 - основной экран (тхт)
				;         паллитра выставляется автоматом
				;         как и все режимы и смещения
				;   #01 - 1й видео буфер (16 страниц)
				;   #02 - 2й видео буфер (16 страниц)
				;   #03 - 3й видео буфер (16 страниц)
				;   #04 - 4й видео буфер (16 страниц)

_MNGCVPL	equ	#41	; включение страницы из видео буферов
				; i:A' - номер страницы
				;   #00-#0F - страницы из 1го видео буфера
				;   #10-#1F - страницы из 2го видео буфера
				;   #20-#2F - страницы из 3го видео буфера
				;   #30-#3F - страницы из 3го видео буфера

_MNG0VPL	equ	#50	; включение страницы из видео буферов на #0000
				; i:A' - номер страницы

_MNG8VPL	equ	#51	; включение страницы из видео буферов на #8000
				; i:A' - номер страницы

_GVmod		equ	#42	; включение видео режима (разрешение+тип)
				; i:A' - видео режим
				;   [7-6]: %00 - 256x192
				;          %01 - 320x200
				;          %10 - 320x240
				;          %11 - 360x288
				;   [5-2]: %0000
				;   [1-0]: %00 - ZX
				;          %01 - 16c
				;          %10 - 256c
				;          %11 - txt

_GYoff		equ	#43	; выставление смещения экрана по Y
				; i:HL - Y (0-511)

_GXoff		equ	#44	; выставление смещения экрана по X
				; i:HL - X (0-511)

_GVtm		equ	#45	; выставление страницы для TileMap
				; i:C - номер страницы из видео буфера (0-63)

_GVtl		equ	#46	; выставление страницы для TileGraphics
				; i:B - номер тайло-плоскости (0-1)
				;   C - номер страницы из видео буфера (0-63)

_GVsgp		equ	#47	; выставление страницы для SpriteGraphics
				; i:C - номер страницы из видео буфера (0-63)