#include "fivewin.ch"
#include "c5report.ch"

function FillRectBmp( hDC, rc, cBmp )

local hBmpBrush := LoadBitmap( GetResources(), cBmp )
local hBrush    := CreatePatternBrush( hBmpBrush )

SetBrushOrg( hDC, hBrush, rc[2], rc[1]   )
FillRect( hDC, rc, hBrush )

DeleteObject( hBrush )
DeleteObject( hBmpBrush )

return 0

function aPapers()
return {"10x14 in"                           ,;
        "11x17 in"                           ,;
        "6 3/4 Envelope 3 5/8 x 6 1/2 in"    ,;
        "A3 297 x 420 mm"                    ,;
        "A4 210 x 297 mm"                    ,;
        "A4 Small 210 x 297 mm"              ,;
        "A5 148 x 210 mm"                    ,;
        "B4 250 x 354 mm"                    ,;
        "B5 182 x 257 mm"                    ,;
        "C size sheet"                       ,;
        "D size sheet"                       ,;
        "E size sheet"                       ,;
        "Envelope #10 4 1/8 x 9 1/2"         ,;
        "Envelope #11 4 1/2 x 10 3/8"        ,;
        "Envelope #12 4 \276 x 11"           ,;
        "Envelope #14 5 x 11 1/2"            ,;
        "Envelope #9 3 7/8 x 8 7/8"          ,;
        "Envelope 110 x 230 mm"              ,;
        "Envelope B4  250 x 353 mm"          ,;
        "Envelope B5  176 x 250 mm"          ,;
        "Envelope B6  176 x 125 mm"          ,;
        "Envelope C3  324 x 458 mm"          ,;
        "Envelope C4  229 x 324 mm"          ,;
        "Envelope C5 162 x 229 mm"           ,;
        "Envelope C6  114 x 162 mm"          ,;
        "Envelope C65 114 x 229 mm"          ,;
        "Envelope DL 110 x 220mm"            ,;
        "Envelope Monarch 3.875 x 7.5 in"    ,;
        "Executive 7 1/4 x 10 1/2 in"        ,;
        "Folio 8 1/2 x 13 in"                ,;
        "German Legal Fanfold 8 1/2 x 13 in" ,;
        "German Std Fanfold 8 1/2 x 12 in"   ,;
        "Ledger 17 x 11 in"                  ,;
        "Legal 8 1/2 x 14 in"                ,;
        "Letter 8 1/2 x 11 in"               ,;
        "Letter Small 8 1/2 x 11 in"         ,;
        "Note 8 1/2 x 11 in"                 ,;
        "Quarto 215 x 275 mm"                ,;
        "Statement 5 1/2 x 8 1/2 in"         ,;
        "Tabloid 11 x 17 in"                 ,;
        "US Std Fanfold 14 7/8 x 11 in"    }


function aSizePapers()
return {{254     ,355.6   },;
        {279.4   ,431.8   },;
        {92.075  ,165.1   },;
        {297     ,420     },;
        {210     ,297     },;
        {210     ,297     },;
        {148     ,210     },;
        {250     ,354     },;
        {182     ,257     },;
        {0       ,0       },;
        {0       ,0       },;
        {0       ,0       },;
        {104.775 ,241.3   },;
        {114.3   ,263.525 },;
        {101.692 ,279.4   },;
        {127     ,292.1   },;
        {98.425  ,225.425 },;
        {110     ,230     },;
        {250     ,353     },;
        {176     ,250     },;
        {176     ,125     },;
        {324     ,458     },;
        {229     ,324     },;
        {162     ,229     },;
        {114     ,162     },;
        {114     ,229     },;
        {110     ,220     },;
        {98.425  ,190.5   },;
        {184.15  ,266.7   },;
        {215.9   ,330.2   },;
        {215.9   ,330.2   },;
        {215.9   ,304.8   },;
        {431.8   ,279.4   },;
        {215.9   ,355.6   },;
        {215.9   ,279.4   },;
        {215.9   ,279.4   },;
        {215.9   ,279.4   },;
        {215     ,275     },;
        {139.7   ,215.9   },;
        {279.4   ,431.8   },;
        {377.825 ,279.4   }}

*****************************************************************************************
  function vPix2MM( nPix )
*****************************************************************************************
local nMMs := 0
local hdc      := CreateDC( "DISPLAY",0,0,0 )
local hres     := GetDeviceCaps(hdc,HORZRES)    // {display width in pixels}
local vres     := GetDeviceCaps(hdc,VERTRES)    // {display height in pixels}
local hsiz     := GetDeviceCaps(hdc,HORZSIZE)   // {display width in mm}
local vsiz     := GetDeviceCaps(hdc,VERTSIZE)   // {display height in mm}
local HPixByMM := (hres/hsiz )                  // pixels hay en un mm horizontal
local VPixByMM := (vres/vsiz )                  // pixels hay en un mm vertical

DeleteDC( hdc )

   nMMs :=  nPix / VPixByMM

return nMMs

*****************************************************************************************
  function hPix2MM( nPix )
*****************************************************************************************
local nMMs := 0
local hdc      := CreateDC( "DISPLAY",0,0,0 )
local hres     := GetDeviceCaps(hdc,HORZRES)    // {display width in pixels}
local vres     := GetDeviceCaps(hdc,VERTRES)    // {display height in pixels}
local hsiz     := GetDeviceCaps(hdc,HORZSIZE)   // {display width in mm}
local vsiz     := GetDeviceCaps(hdc,VERTSIZE)   // {display height in mm}
local HPixByMM := (hres/hsiz )                  // pixels hay en un mm horizontal
local VPixByMM := (vres/vsiz )                  // pixels hay en un mm vertical

DeleteDC( hdc )

   nMMs := nPix / HPixByMM

return nMMs

*****************************************************************************************
  function vMM2Pix( nMMs )
*****************************************************************************************
local nPix := 0
local hdc      := CreateDC( "DISPLAY",0,0,0 )
local hres     := GetDeviceCaps(hdc,HORZRES)    // {display width in pixels}
local vres     := GetDeviceCaps(hdc,VERTRES)    // {display height in pixels}
local hsiz     := GetDeviceCaps(hdc,HORZSIZE)   // {display width in mm}
local vsiz     := GetDeviceCaps(hdc,VERTSIZE)   // {display height in mm}
local HPixByMM := (hres/hsiz )                  // pixels hay en un mm horizontal
local VPixByMM := (vres/vsiz )                  // pixels hay en un mm vertical

DeleteDC( hdc )

   nPix :=  nMMs * VPixByMM

return nPix

*****************************************************************************************
  function hMM2Pix( nMMs )
*****************************************************************************************
local nPix := 0
local hdc      := CreateDC( "DISPLAY",0,0,0 )
local hres     := GetDeviceCaps(hdc,HORZRES)    // {display width in pixels}
local vres     := GetDeviceCaps(hdc,VERTRES)    // {display height in pixels}
local hsiz     := GetDeviceCaps(hdc,HORZSIZE)   // {display width in mm}
local vsiz     := GetDeviceCaps(hdc,VERTSIZE)   // {display height in mm}
local HPixByMM := (hres/hsiz )                  // pixels hay en un mm horizontal
local VPixByMM := (vres/vsiz )                  // pixels hay en un mm vertical

DeleteDC( hdc )

   nPix := nMMs * HPixByMM

return nPix

**************************************************************************
   function aTokens( cStr, cChar )
**************************************************************************
local n := 1
local aRet := {}
local cToken
DEFAULT cChar := " "

cStr += cChar

do while !empty( cToken := strtoken( cStr, n++, cChar ) )
   aadd( aRet, cToken )
enddo

return aRet


***************************************************************************
   function strtrim( nVal ); return alltrim(str(nVal))
***************************************************************************

***************************************************************************
   function MemoWritEx( cFileName, cStr )
***************************************************************************

  local nmanejador:=FCREATE(cFileName, 0)
  FWRITE(nManejador, cStr )
  FCLOSE(nManejador)

return 0

function C5Simbol( hDC, nTop, nLeft, lOver, cChar, lEnable )
local oFont, hOldFont
local aRect
local nMode
local nColor

DEFAULT lOver := .f.

  nMode    := SetBkMode( hDC, 1 )
  oFont := TFont():New( "Marlett", 0, -10, .f.,.f.,,,,.f.,.f.,.f., 1 )
  hOldFont := SelectObject( hDC, oFont:hFont )
  aRect := {nTop,nLeft,nTop+10,nLeft+ 9}
  nColor := SetTextColor( hDC, if( lEnable, 0, CLR_GRAY ) )
  TextOut( hDC, aRect[1]+1, aRect[2], cChar )
  SetTextColor( hDC, nColor )
  SelectObject( hDC, hOldFont  )
  oFont:End()
  SetBkMode( hDC, nMode )
  if lOver
     Box(hDC,aRect)
  endif

return aRect


******************************************************************************
 function C5GetFontNames()
******************************************************************************

local hDC    := GetDC( Inspector():hWnd )
local aFonts := GetFontNames(hDC)
aFonts := asort( aFonts )
ReleaseDC(Inspector():hWnd,hDC)

return aFonts

******************************************************************************************************************
   function EditBmp( cBmp )
******************************************************************************************************************
 local cPath := AllTrim( GetModuleFileName( GetInstance() ) )
 local cFile
 DEFAULT cBmp := ""
 cPath := cFilePath( cPath )

 if Right( cPath, 1 ) == '\'
    cPath := Left( cPath, Len( cPath ) - 1 ) // Quitamos la barra
 endif

 cFile := upper(cGetFile( "Fichero gráfico | *.BMP;*.DCX;*.GIF;*.JPG;*.PCX;*.TIF;*.PNG", "Seleccione imagen" ))

 if !empty( cFile )
    cBmp := strtran( cFile,cPath,".")
 endif

 SysRefresh()

 oWnd():Refresh(.t.)

 return cBmp


******************************************************************************************************************
      function EditText( c )
******************************************************************************************************************
local cOldVar
local rc
local cText := c
local oFont
local o
local lOk := .f.
local oDlg
local cVar1 := padr( cText, 1000 )
local oGet1
local oBtn1
local oBtn2
local oBtn3

DEFINE DIALOG oDlg ;
       FROM 259, 146 TO 611, 744 PIXEL ;
       TITLE "Editar texto"

       @ 25, 28 GET oGet1 VAR cVar1 ;
             SIZE 249, 105 PIXEL OF oDlg MULTILINE

       @ 143, 153 BUTTON oBtn1 PROMPT "Aceptar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (lOk := .t., oDlg:End())

       @ 143, 199 BUTTON oBtn2 PROMPT "Cancelar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (oDlg:End())

       @ 143, 244 BUTTON oBtn3 PROMPT "Ayuda" ;
             SIZE 44, 12 PIXEL OF oDlg

ACTIVATE DIALOG oDlg CENTERED



return cVar1


******************************************************************************************************************
  function EditDbf( c )
******************************************************************************************************************
 local cPath := AllTrim( GetModuleFileName( GetInstance() ) )
 local cFile := c
 cPath := cFilePath( cPath )

 if Right( cPath, 1 ) == '\'
    cPath := Left( cPath, Len( cPath ) - 1 ) // Quitamos la barra
 endif

 cFile := upper(cGetFile( "*.dbf", "Seleccione Dbf" ))

 if !empty( cFile )
    c := strtran( cFile,cPath,".")
 endif

 SysRefresh()

 oWnd():Refresh(.t.)

 return c



******************************************************************************************************************
  function GetFields( c )
******************************************************************************************************************
local aFields := {}
local aStructure := {}
local n
local nLen

if !empty( c )

   DBUSEAREA (.T.,,c ,"test")

   aStructure := test->(DbStruct())

   for n := 1 to len( aStructure )
       aadd( aFields, aStructure[n,1] )
   next

   test->(DbCloseArea())

endif

return aFields


CLASS TPenExt

   DATA   hPen
   DATA   nWidth, nColor
   DATA   oDevice

   METHOD New( nWidth, nColor, oDevice ) CONSTRUCTOR
   METHOD Release() INLINE  DeleteObject( ::hPen ), ::hPen := 0
   METHOD End()     INLINE  DeleteObject( ::hPen ), ::hPen := 0

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nWidth, nColor, oDevice ) CLASS TPenExt

   DEFAULT nWidth := 1        ,;
           nColor := CLR_BLACK

   if oDevice != nil
      ::nWidth  = ( oDevice:nLogPixelY() / 72 ) * ::nWidth
      ::oDevice = oDevice
   endif

   ::hPen   = ExtCreatePen( nWidth, nColor )
   ::nWidth = nWidth
   ::nColor = nColor


return Self


