set prog=main
rem #%frompage=02
rem #%topage=61

for %%i in ( src\%prog%.asm ) do sjasmplus --labels %%i

rem if EXIST %prog%.lab (
 rem # sed -i "s/${frompage}:/${topage}:/g" %prog%.lab
rem sed -i "s/main\./m\./g" %prog%.lab
rem sed -i "s/zifi\./z\./g" %prog%.lab
rem sed -i "s/string\./s\./g" %prog%.lab
rem sed -i "s/uart_ts_zifi\./utz\./g" %prog%.lab
rem )
