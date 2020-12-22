@echo off

del Prueba.exe
rem del .\code.obj\main.obj

call rmake /u /xs1500 z.rmk
if errorlevel 1 goto exit


Ilink32.exe @z.lnk

del *.lib
del *.exp
del *.bak
del *.tmp
del *.il*
del *.map
del *.tds

rem brc32 -k XBrowse.rc

Prueba.exe
