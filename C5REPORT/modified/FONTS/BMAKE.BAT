@echo off


:BUILD
   del *.obj
   \BCC55\bin\make -ffwh.mak %2 %3 > make.log
   if errorlevel 1 goto BUILD_ERR

:BUILD_OK

   if exist c5report.exe c5report.exe
   goto EXIT

:BUILD_ERR

   notepad make.log
   goto EXIT

:EXIT
del make.log
del *.hrb
del prueba.obj