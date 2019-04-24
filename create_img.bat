rem @echo off

..\zx-evo\pentevo\tools\robimg\robimg.exe -p="cli2.img" -s=102400 -C=".\install"
copy /Y .\cli2.img C:\ZX-Speccy\Unreal-cli\
