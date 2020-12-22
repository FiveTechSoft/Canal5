@echo off


:BUILD
   del *.obj		
   \BCC55\bin\make -ffwh2.mak %2 %3 > make.log
   if errorlevel 1 goto BUILD_ERR

:BUILD_OK

   if exist prueba.exe prueba.exe
   goto EXIT

:BUILD_ERR

   notepad make.log
   goto EXIT

:EXIT
del make.log
del *.hrb
del prueba.obj