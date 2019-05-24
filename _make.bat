set prog=main

for %%i in ( src\%prog%.asm ) do sjasmplus --labels %%i

