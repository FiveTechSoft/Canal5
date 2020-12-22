@ECHO OFF
CLS
del *.exe

Harbour Test     /n
Harbour ListProp /n

Bcc32 -M -c -O2 Test.c
Bcc32 -M -c -O2 ListProp.c

Brc32 -r Test

ILink32 -aa -Tpe -s -x @z.lnk

del *.c
del *.obj
del *.i??
del *.bak
del *.t??
del *.res

TEST.exe
