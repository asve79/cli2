;Understand, Correct, Improve           ___
;________/| _________________/\__/\____/  /_____
;\  ____/ |/   __/  /  / __ /  \/  \  \  /   __/
;|   __/  /\__   \    /  __ \      /     \  _/ \
;|___\ \__\____  //__/\_____/\    /__/\  /_____/
;+-------------\/breeze'13----\  /crew-\/------+
;                              \/
; ____      ____
;|    _----_    |  GLaDOS based KERNEL•8 (Eito/)
;|  _/ _||_ \_  |  «we do what we can because we must»
;  |  //\/\\  |    Copyright © 1995,1996 Spectrum Warriors corp. All right reserved
;  |=| \  / |=|    Copyright © 1997,2000 Ascendancy Cr.Lb. All right reserved
;  |_ \_\/_/ _|    Copyright © 2001,2016 Fishbone Crew. All right reserved
;|   \_ || _/   |  Written by breeze/fishbone crew | http://fishbone.untergrund.net/
;|_____----_____|  fishbone@speccy.su


;---------------------------------------
; CLi² (Command Line Interface)
; 2012,2016 © breeze/fishbone crew
;---------------------------------------

	DEVICE ZXSPECTRUM128

	define	OS_WINDOWS=1

 	define buildSexyBoot				; Сборка загрузчика системы boot.$c
; 	define buildKernel				; Сборка всей системы
; 	define buildRes					; Сборка файлов ресурсов (Pal, Cur, Fnt, keymap)
; 	define buildTest				; Сборка тестового приложения test
; 	define buildEcho				; Сборка команды echo
; 	define buildLoadPal				; Сборка утилиты loadpal
; 	define buildLoadFont				; Сборка утилиты loadfont
; 	define buildSleep				; Сборка команды sleep
; 	define buildType				; Сборка команды type
; 	define buildKeyScan				; Сборка утилиты keyscan
; 	define buildLoadMod				; Сборка утилиты loadmod
; 	define buildLoadMus				; Сборка утилиты loadmus
; 	define buildCursor				; Сборка утилиты cursor
; 	define buildMiceTest				; Сборка утилиты micetest
; 	define buildGliTest				; Сборка утилиты glitest
;  	define buildLoadSxg				; Сборка утилиты loadsxg
; 	define buildNvram				; Сборка утилиты nvram
; 	define buildHello				; Сборка тестового приложения hello
; 	define buildMkdir				; Сборка команды mkdir
; 	define buildScreenFX				; Сборка приложения screenFX
;  	define buildDate				; Сборка приложения date
;	define buildTestSave				; Сборка тестового приложения testsave

; 	define buildBoing				; Сборка тестовой демки boing
; 	define buildTestFile				; Сборка тестового приложения testfile
; 	define buildDisk2trd				; Сборка приложения disk2trd

; 	define buildLoader				; Сборка загрузчика системы (плагин для WC)
;-------------------------------------------------------------------------
	ifdef buildLoader
	; CLi² Loader
	DISPLAY "Start build: Loader..."
	ifdef OS_WINDOWS
	include "cliloader\main.asm"
	else
	include "cliloader/main.asm"
	endif
	endif
;-------------------------------------------------------------------------
	ifdef buildSexyBoot
	; CLi² Sexy Boot
	DISPLAY "Start build: SexyBoot..."
	ifdef OS_WINDOWS
	include "sexyBoot\main.asm"
	else
	include "sexyBoot/main.asm"
	endif
	endif
;-------------- загрузчик или ядро системы -------------------------------

	ifdef buildKernel
	DISPLAY "Start build: Kernel..."
;-------------------------------------------------------------------------
	; Используется, если собирается только система (без приложения)
	ifdef OS_WINDOWS
	include "system\constants.asm"
;-------------------------------------------------------------------------
	include "system\main.asm" 			; CLi² Kernel
	include "drivers\main.asm"			; CLi² Drivers
	include "libs\gli.asm"				; CLi² Graphics Library

;-------------------------------------------------------------------------
	; Используется, если собирается только система (без приложения)
	include "system\errorcodes.asm"
	include "system\api.h.asm"
	include "drivers\drivers.h.asm"
	include "libs\gli.h.asm"
	else
	include "system/constants.asm"
;-------------------------------------------------------------------------
	include "system/main.asm" 			; CLi² Kernel
	include "drivers/main.asm"			; CLi² Drivers
	include "libs/gli.asm"				; CLi² Graphics Library

;-------------------------------------------------------------------------
	; Используется, если собирается только система (без приложения)
	include "system/errorcodes.asm"
	include "system/api.h.asm"
	include "drivers/drivers.h.asm"
	include "libs/gli.h.asm"
;-------------------------------------------------------------------------
	endif
	endif

	ifdef buildRes
	DISPLAY "Start build: Resources..."
	ifdef OS_WINDOWS
	include "res\pals\cli.pal.asm"			; CLi² 16 colors palette for text mode (CLi colors)
	include "res\pals\zx.pal.asm"			; CLi² 16 colors palette for text mode (ZX colors)

	include "res\cursors\default.cur.asm"			; CLi² default cursor

	include "res\fonts\8x8\default.fnt.asm"		; CLi² default font
	include "res\fonts\8x8\alt.fnt.asm"		; CLi² alternative font
	include "res\fonts\8x8\bge.fnt.asm"		; CLi² bge font
	include "res\fonts\8x8\bred.fnt.asm"		; CLi² bred font
	include "res\fonts\8x8\buratino.fnt.asm"	; CLi² buratino font
	include "res\fonts\8x8\ibm.fnt.asm"		; CLi² ibm font
	include "res\fonts\8x8\light.fnt.asm"		; CLi² light font
	include "res\fonts\8x8\robat.fnt.asm"		; CLi² robat font

	include "res\fonts\16x16\apple_j.fnt.asm"	; 16c color font 8x16

	include "res\keymaps\default.key.asm"		; Таблица раскладки клавиатуры (EN/RU)
	else
	include "res/pals/cli.pal.asm"			; CLi² 16 colors palette for text mode (CLi colors)
	include "res/pals/zx.pal.asm"			; CLi² 16 colors palette for text mode (ZX colors)

	include "res/cursors/default.cur.asm"			; CLi² default cursor

	include "res/fonts/8x8/default.fnt.asm"		; CLi² default font
	include "res/fonts/8x8/alt.fnt.asm"		; CLi² alternative font
	include "res/fonts/8x8/bge.fnt.asm"		; CLi² bge font
	include "res/fonts/8x8/bred.fnt.asm"		; CLi² bred font
	include "res/fonts/8x8/buratino.fnt.asm"	; CLi² buratino font
	include "res/fonts/8x8/ibm.fnt.asm"		; CLi² ibm font
	include "res/fonts/8x8/light.fnt.asm"		; CLi² light font
	include "res/fonts/8x8/robat.fnt.asm"		; CLi² robat font

	include "res/fonts/16x16/apple_j.fnt.asm"	; 16c color font 8x16

	include "res/keymaps/default.key.asm"		; Таблица раскладки клавиатуры (EN/RU)
	endif
	endif
;-------------------------------------------------------------------------

	ifndef buildKernel

		ifdef buildTest
		; CLi² test application
		DISPLAY "Start build: Test..."
		ifdef OS_WINDOWS
		include "app\test.asm"
		else
		include "app/test.asm"
		endif
		endif

		ifdef buildEcho
		; CLi² echo application
		DISPLAY "Start build: Echo..."
		ifdef OS_WINDOWS
		include "app\echo.asm"
		else
		include "app/echo.asm"
		endif
		endif

		ifdef buildLoadPal
		; CLi² load palette application
		DISPLAY "Start build: LoadPal..."
		ifdef OS_WINDOWS
		include "app\loadPal.asm"
		else
		include "app/loadPal.asm"
		endif
		endif

		ifdef buildLoadFont
		; CLi² load font application
		DISPLAY "Start build: LoadFont..."
		ifdef OS_WINDOWS
		include "app\loadFont.asm"
		else
		include "app/loadFont.asm"
		endif
		endif

		ifdef buildSleep
		; CLi² sleep application
		DISPLAY "Start build: Sleep..."
		ifdef OS_WINDOWS
		include "app\sleep.asm"
		else
		include "app/sleep.asm"
		endif
		endif

		ifdef buildType
		; CLi² type application
		DISPLAY "Start build: Type..."
		ifdef OS_WINDOWS
		include "app\type.asm"
		else
		include "app/type.asm"
		endif
		endif

		ifdef buildKeyScan
		; CLi² keyboard scancode application
		DISPLAY "Start build: KeyScan..."
		ifdef OS_WINDOWS
		include "app\keyScan.asm"
		else
		include "app/keyScan.asm"
		endif
		endif

		ifdef buildLoadMod
		; CLi² mod loader application
		DISPLAY "Start build: LoadMod..."
		ifdef OS_WINDOWS
		include "app\loadMod.asm"
		else
		include "app/loadMod.asm"
		endif
		endif

		ifdef buildLoadMus
		; CLi² ay loader application
		DISPLAY "Start build: LoadMus..."
		ifdef OS_WINDOWS
		include "app\loadMus.asm"
		else
		include "app/loadMus.asm"
		endif
		endif

		ifdef buildCursor
		; CLi² cursor application
		DISPLAY "Start build: Cursor..."
		ifdef OS_WINDOWS
		include "app\cursor.asm"
		else
		include "app/cursor.asm"
		endif
		endif

		ifdef buildMiceTest
		; CLi² mice test application
		DISPLAY "Start build: MiceTest..."
		ifdef OS_WINDOWS
		include "app\miceTest.asm"
		else
		include "app/miceTest.asm"
		endif
		endif

		ifdef buildGliTest
		; CLi² mice test gli
		DISPLAY "Start build: GLITest..."
		ifdef OS_WINDOWS
		include "app\gliTest.asm"
		else
		include "app/gliTest.asm"
		endif
		endif

		ifdef buildLoadSxg
		; CLi² mice test gli
		DISPLAY "Start build: LoadSXG..."
		ifdef OS_WINDOWS
		include "app\loadSxg.asm"
		else
		include "app/loadSxg.asm"
		endif
		endif

		ifdef buildNvram
		; CLi² nvram info & tool application
		DISPLAY "Start build: NVRam..."
		ifdef OS_WINDOWS
		include "app\nvram.asm"
		else
		include "app/nvram.asm"
		endif
		endif

		ifdef buildHello
		; CLi² hello world application
		DISPLAY "Start build: Hello..."
		ifdef OS_WINDOWS
		include "app\hello.asm"
		else
		include "app/hello.asm"
		endif
		endif

		ifdef buildBoing
		; CLi² demo 1
		DISPLAY "Start build: Boing..."
		ifdef OS_WINDOWS
		include "demo\boing.asm"
		else
		include "demo/boing.asm"
		endif
		endif

		ifdef buildMkdir
		; CLi² mkdir application
		DISPLAY "Start build: MKdir..."
		ifdef OS_WINDOWS
		include "app\mkdir.asm"
		else
		include "app/mkdir.asm"
		endif
		endif

		ifdef buildTestSave
		; CLi² testsave application
		DISPLAY "Start build: testsave..."
		ifdef OS_WINDOWS
		include "app\testsave.asm"
		else
		include "app/testsave.asm"
		endif
		endif

		ifdef buildTestFile
		; CLi² testsave application
		DISPLAY "Start build: testfile..."
		ifdef OS_WINDOWS
		include "app\testfile.asm"
		else
		include "app/testfile.asm"
		endif
		endif

		ifdef buildScreenFX
		; CLi² screenFX application
		DISPLAY "Start build: screenFX..."
		ifdef OS_WINDOWS
		include "app\screenFX.asm"
		else
		include "app/screenFX.asm"
		endif
		endif

		ifdef buildDate
		; CLi² date application
		DISPLAY "Start build: date..."
		ifdef OS_WINDOWS
		include "app\date.asm"
		else
		include "app/date.asm"
		endif
		endif

		ifdef buildDisk2trd
		; CLi² disk2trd application
		DISPLAY "Start build: disk2trd..."
		ifdef OS_WINDOWS
		include "app\disk2trd.asm"
		else
		include "app/disk2trd.asm"
		endif
		endif

	endif

; 	DISPLAY "showHelp",/A,showHelp
; 	DISPLAY "shPrint_0",/A,shPrint_0
; 	DISPLAY "_printStatusString",/A,_printStatusString
