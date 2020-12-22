#include "fivewin.ch"
#include "c5report.ch"

static hLib

CLASS TC5RptItemImg FROM TC5RptItem

      DATA cBmp
      DATA lAdjust       AS LOGICAL INIT .F.
      DATA lTransparent  AS LOGICAL INIT .F.
      DATA aEnablePoints AS ARRAY   INIT {.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.}
      DATA nType                    INIT C5BITMAP

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cBmp ) CONSTRUCTOR
      METHOD Load( cStr, lPaste ) CONSTRUCTOR
      METHOD LoadIni( oIni, cItem ) CONSTRUCTOR

      METHOD Paint        ( hDC )
      METHOD EditBmp      ( )
      METHOD Save         ( )
      METHOD SaveToIni    ( oIni )
      METHOD SaveToXML    ( oIni )
      METHOD RButtonDown  ( nRow, nCol, nFlags )
      METHOD cItemName    ( )  INLINE "Imagen (" + alltrim(str( ::nID )) + ")"
      METHOD CreateProps  ()
      METHOD IsOver( nRow, nCol )

ENDCLASS

****************************************************************************************************************************
  METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cBmp, lEnable ) CLASS TC5RptItemImg
****************************************************************************************************************************

   if cBmp     == nil;  cBmp      := " "      ; endif
   if lEnable  == nil;  lEnable   := .t.      ; endif

   DEFAULT nWidth := 150
   DEFAULT nHeight := 150

   ::oWnd       := oWnd
   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)
   ::cBmp       := cBmp
   ::lEnable    := lEnable
   ::nID        := ::GetNewID()
   ::nType      := C5BITMAP
   ::aEnablePoints := {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
   ::cType      := "Imagen"
   ::lTransparent := .f.

   ::CreateProps()


return self

******************************************************************************************************************
      METHOD CreateProps  ()CLASS TC5RptItemImg
******************************************************************************************************************

   ::AddProp( "nRealTop",     "Arriba",       nil,  "Posición" )
   ::AddProp( "nRealLeft",    "Izquierda",    nil,  "Posición" )
   ::AddProp( "nRealWidth",   "Ancho",        nil,  "Posición" )
   ::AddProp( "nRealHeight",  "Alto",         nil,  "Posición" )

   ::AddProp( "cBmp",         "Imagen",       {|c|EditBmp(c)},"Apariencia", ACCION )
   ::AddProp( "lAdjust",      "Ajustar",      nil,            "Apariencia" )
   ::AddProp( "lTransparent", "Transparente", nil,            "Apariencia" )
   ::AddProp( "lEnable",      "Activado",     nil,            "Apariencia" )

return 0


******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemImg
******************************************************************************************************************

 local hBmp := 0
 local nT := ::nTop      + ::oWnd:nRTop
 local nL := ::nLeft     + ::oWnd:nRLeft
 local nB := ::nBottom   + ::oWnd:nRTop
 local nR := ::nRight    + ::oWnd:nRLeft
 local nHBmp, nWBmp
 local hPenDotted
 local hOldPen
 local nAuxH, nAuxW

 if ::lMoviendo
    return super:Paint( hDC )
 endif

 hPenDotted := CreatePen( 2, 1, RGB(201,201,201) )

 //hBmp := LoadImageEx( ::cBmp )
 hBmp = C5FILoadImg( AllTrim( ::cBmp ) )


 if hBmp != 0

    if ::lAdjust
       nAuxW := ::aCoords[4]-::aCoords[2]
       nAuxH := ::aCoords[3]-::aCoords[1]
    else
       nAuxH := BmpHeight( hBmp )
       nAuxW := BmpWidth ( hBmp )
    endif

    nHBmp := nAuxH * ::oWnd:nZoom / 100
    nWBmp := nAuxW * ::oWnd:nZoom / 100

    if ::lTransparent
       TransparentBlt( hDC, hBmp, nT, nL, nWBmp, nHBmp, RGB(255,0,255) )
    else
       DrawBitmapEx( hDC, hBmp, nT, nL, nWBmp, nHBmp )
    endif
    ::aCoords[3] := ::aCoords[1] + nAuxH
    ::aCoords[4] := ::aCoords[2] + nAuxW
    nB := nT + nHBmp
    nR := nL + nWBmp

    ::aEnablePoints := {::lAdjust,::lAdjust,::lAdjust,::lAdjust,::lAdjust,::lAdjust,::lAdjust,::lAdjust}

    DeleteObject( hBmp )
 endif

 if hBmp == 0
    hOldPen := SelectObject( hDC, hPenDotted )
    Moveto( hDC, nL, nT )
    Lineto( hDC, nR-1, nT )
    Lineto( hDC, nR-1, nB-1 )
    Lineto( hDC, nL, nB-1 )
    Lineto( hDC, nL, nT )
    SelectObject( hDC, hOldPen )
 endif

DeleteObject( hPenDotted )

if !::oWnd:lCaptured
   ::PaintPts( hDC )
endif

return nil

******************************************************************************************************************
      METHOD EditBmp()   CLASS TC5RptItemImg
******************************************************************************************************************
 local cPath := AllTrim( GetModuleFileName( GetInstance() ) )
 local cFile
 cPath := cFilePath( cPath )

 if Right( cPath, 1 ) == '\'
    cPath := Left( cPath, Len( cPath ) - 1 ) // Quitamos la barra
 endif

 cFile := upper(cGetFile( "Fichero gráfico | *.BMP;*.DCX;*.GIF;*.JPG;*.PCX;*.TIF", "Seleccione imagen" ))

 if !empty( cFile )
    ::cBmp := strtran( cFile,cPath,".")
 endif

 SysRefresh()

 ::oWnd:Refresh(.t.)

 return ::cBmp

******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemImg
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cortar" ACTION ::oWnd:Cut()
   MENUITEM "Copiar" ACTION ::oWnd:Copy()
   MENUITEM "Pegar"  ACTION ::oWnd:Paste()

   MENUITEM "Deshabilitar" ACTION (::lEnable := .f., ::oWnd:Refresh())

   MENUITEM "Seleccionar imagen" ACTION (::cBmp := cGetFile( "*.bmp"),::oWnd:Refresh())

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0

******************************************************************************************************************
      METHOD Save() CLASS TC5RptItemImg
******************************************************************************************************************

local cStr

cStr := str(::nType,3)

cStr +=  str(::aCoords[1],4)
cStr +=  str(::aCoords[2],4)
cStr +=  str(::aCoords[3],4)
cStr +=  str(::aCoords[4],4)
cStr += ( str( len(::cBmp) ,5 )+ ::cBmp  )
cStr += ( if( ::lTransparent,".t.",".f.") )
cStr += ( if( ::lAdjust,".t.",".f.") )
cStr += ( if( ::lEnable,".t.",".f.") )
cStr +=  str(::nID,4)

return cStr

******************************************************************************************************************
      METHOD SaveToIni( oIni, n )  CLASS TC5RptItemImg
******************************************************************************************************************
local cStr := ""
local cItem := "Item" + alltrim(str(n))

cStr += "["+cItem+"]"                                            + CRLF
cStr += "Type="         + "Image"                                + CRLF
cStr += "nTop="         + strtrim(::aCoords[1])                  + CRLF
cStr += "nLeft="        + strtrim(::aCoords[2])                  + CRLF
cStr += "nWidth="       + strtrim(::aCoords[4]-::aCoords[2])     + CRLF
cStr += "nHeight="      + strtrim(::aCoords[3]-::aCoords[1])     + CRLF
cStr += "cBmp="         + ::cBmp                                 + CRLF
cStr += "lTransparent=" + if( ::lTransparent,"Yes","No")         + CRLF
cStr += "lAdjust="      + if( ::lAdjust,"Yes","No")              + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF + CRLF


return cStr

******************************************************************************************************************
      METHOD SaveToXML( oIni, n )  CLASS TC5RptItemImg
******************************************************************************************************************
local buffer :=""


buffer += '<Item Name="Image"' +' Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <nTop>'        + alltrim(str(::aCoords[1]))              + '</nTop>'        + CRLF
buffer += '   <nLeft>'       + alltrim(str(::aCoords[2]))              + '</nLeft>'       + CRLF
buffer += '   <nWidth>'      + alltrim(str(::aCoords[4]-::aCoords[2])) + '</nWidth>'      + CRLF
buffer += '   <nHeight>'     + alltrim(str(::aCoords[3]-::aCoords[1])) + '</nHeight>'     + CRLF
buffer += '   <cBmp>'        + ::cBmp                                  + '</cBmp>'        + CRLF
buffer += '   <lTransparent>'+ if( ::lTransparent,"Yes","No")          + '</lTransparent>'+ CRLF
buffer += '   <lAdjust>'     + if( ::lAdjust,"Yes","No")               + '</lAdjust>'     + CRLF
buffer += '   <lEnable>'     + if( ::lEnable,"Yes","No")               + '</lEnable>'     + CRLF
buffer += '   <nID>'         + alltrim(str(::nID))                     + '</nID>'         + CRLF
buffer += '</Item>'                                                                      + CRLF

return buffer


******************************************************************************************************************
      METHOD LoadIni( oIni, cItem ) CLASS TC5RptItemImg
******************************************************************************************************************
local lTransparent, lAdjust, lEnable
local nW, nH

  GET ::aCoords[1]                             SECTION cItem    ENTRY "nTop"         OF oIni DEFAULT 0
  GET ::aCoords[2]                             SECTION cItem    ENTRY "nLeft"        OF oIni DEFAULT 0
  GET nW                                       SECTION cItem    ENTRY "nWidth"       OF oIni DEFAULT 0
  GET nH                                       SECTION cItem    ENTRY "nHeight"      OF oIni DEFAULT 0
  GET ::cBmp                                   SECTION cItem    ENTRY "cBmp"         OF oIni DEFAULT ""
  GET   lTransparent                           SECTION cItem    ENTRY "lTransparent" OF oIni DEFAULT ""
  GET   lAdjust                                SECTION cItem    ENTRY "lAdjust"      OF oIni DEFAULT ""
  GET   lEnable                                SECTION cItem    ENTRY "lEnable"      OF oIni DEFAULT ""
  GET ::nID                                    SECTION cItem    ENTRY "nID"          OF oIni DEFAULT 0

  ::aCoords[3] := ::aCoords[1] + nH
  ::aCoords[4] := ::aCoords[2] + nW

  ::lTransparent := lTransparent == "Yes"
  ::lAdjust      := lAdjust      == "Yes"

  ::CreateProps()

return self


******************************************************************************************************************
      METHOD Load( cStr, lPaste, nPuntero ) CLASS TC5RptItemImg
******************************************************************************************************************

local cVersion := ReportVersion()
local nLen

DEFAULT lPaste := .f.


    ::aCoords[ 1] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4
    ::aCoords[ 2] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4
    ::aCoords[ 3] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4
    ::aCoords[ 4] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4

    if lPaste
       ::aCoords[ 1] += 20
       ::aCoords[ 2] += 20
       ::aCoords[ 3] += 20
       ::aCoords[ 4] += 20
    endif

    nLen   := val( substr( cStr, nPuntero, 5 ) )                  ; nPuntero += 5
    ::cBmp := substr( cStr, nPuntero ,nLen )                      ; nPuntero += nLen   //::cBmp

    if .t. //!empty( cVersion ) .and. val(right(cVersion,5)) > 1.00
       ::lTransparent := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3
    endif

    ::lAdjust     := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3
    ::lEnable     := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3

    if lPaste
       ::nID      := ::GetNewID()
    else
       ::nID      := val( substr( cStr, nPuntero, 4 ) )
    endif

    nPuntero += 4      //

    ::CreateProps()

return self


******************************************************************************************************************
      METHOD IsOver( nRow, nCol ) CLASS TC5RptItemImg
******************************************************************************************************************

local nTop
local nLeft
local nBottom
local nRight

if !::lEnable
   return .f.
endif

nTop    := (::aCoords[1] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
nLeft   := (::aCoords[2] + ::oWnd:aCoords[2])*::oWnd:nZoom/100
nBottom := (::aCoords[3] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
nRight  := (::aCoords[4] + ::oWnd:aCoords[2])*::oWnd:nZoom/100

return PtInRect( nRow, nCol, {nTop,nLeft,nBottom,nRight} )



//----------------------------------------------------------------------------//

#define CBM_INIT       4
#define DIB_RGB_COLORS 0

function C5FILOADIMG( cFile )

   local nFormat, hDib, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if Upper( cFileExt( cFile ) ) = "BMP"
      return ReadBitmap( 0, cFile )
   endif

   #ifdef __CLIPPER__
      hLib = LoadLib32( "freeimage.dll" )
   #else
      hLib = LoadLibrary( "freeimage.dll" )
   #endif

   if hLib <= 32
      MsgStop( "Cannot load FreeImage.dll" )
      return 0
   endif

   nFormat = FIGETFILETYPE( cFile, 0 )
   hDib    = FILOAD( nFormat, cFile, 0 )
   hInfoH  = FIGETINFOHEADER( hDib )
   hInfo   = FIGETINFO( hDib )
   hBits   = FIGETBITS( hDib )
   hWnd    = GETDESKTOPWINDOW()

   #ifdef __CLIPPER__
      hDC = GETDC32( hWnd )
   #else
     hDC = GETDC( hWnd )
   #endif

   hBmp = CreateDiBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo, DIB_RGB_COLORS )

   #ifdef __CLIPPER__
      ReleaseDC32( hWnd, hDC )
   #else
      ReleaseDC( hWnd, hDC )
   #endif

   FIUNLOAD( hDib )

   #ifdef __CLIPPER__
      FreeLib32( hLib )
   #else
      FreeLibrary( hLib )
   #endif

   #ifdef __CLIPPER__
      hBmp = nLoWord( WOWHANDLE16( hBmp, 8 ) )
   #endif

return hBmp

//----------------------------------------------------------------------------//

static function FISAVEIMG( cSrcFile, cDstFile, nDstFormat, nQuality )

   local nSrcFormat, hDib, hDib2, lOk

   DEFAULT nQuality := 0

   #ifdef __CLIPPER__
      hLib = LoadLib32( "freeimage.dll" )
   #else
      hLib = LoadLibrary( "freeimage.dll" )
   #endif

   nSrcFormat = FIGETFILETYPE( cSrcFile, 0 )

   hDib = FILOAD( nSrcFormat, cSrcFile, 0 )
   hDib2 = FICNV24( hDib )
   lOk = FISAVE( nDstFormat, hDib2, cDstFile, nQuality )

   FIUNLOAD( hDib )
   FIUNLOAD( hDib2 )

   #ifdef __CLIPPER__
      FreeLib32( hLib )
   #else
      FreeLibrary( hLib )
   #endif

return lOk

//----------------------------------------------------------------------------//

DLL32 STATIC FUNCTION FIGETFILETYPE( cFileName AS LPSTR, nSize AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetFileType@8" LIB hLib

DLL32 STATIC FUNCTION FILOAD( nFormat AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_Load@12" LIB hLib

DLL32 STATIC FUNCTION FISAVE( nFormat AS LONG, hDib AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS BOOL ;
      PASCAL FROM "_FreeImage_Save@16" LIB hLib

DLL32 STATIC FUNCTION FIUNLOAD( hDib AS LONG ) AS VOID ;
      PASCAL FROM "_FreeImage_Unload@4" LIB hLib

DLL32 STATIC FUNCTION FIGETINFOHEADER( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetInfoHeader@4" LIB hLib

DLL32 STATIC FUNCTION FIGETINFO( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetInfo@4" LIB hLib

DLL32 STATIC FUNCTION FIGETBITS( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetBits@4" LIB hLib

DLL32 STATIC FUNCTION FICNV24( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_ConvertTo24Bits@4" LIB hLib

DLL32 STATIC FUNCTION GETDC32( hWnd AS LONG ) AS LONG ;
      PASCAL FROM "GetDC" LIB "user32.dll"

DLL32 STATIC FUNCTION RELEASEDC32( hWnd AS LONG ) AS LONG ;
      PASCAL FROM "ReleaseDC" LIB "user32.dll"

DLL32 STATIC FUNCTION CREATEDIBITMAP( hDC AS LONG, hInfoH AS LONG, nFlags AS LONG, hBits AS LONG, hInfo AS LONG, nUsage AS LONG ) AS LONG ;
      PASCAL FROM "CreateDIBitmap" LIB "gdi32.dll"

DLL32 FUNCTION WOWHANDLE16( nHandle AS LONG, nHandleType AS LONG ) AS LONG ;
      PASCAL FROM "WOWHandle16" LIB "wow32.dll"

//----------------------------------------------------------------------------//
