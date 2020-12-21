#include "FiveWin.ch"
#include "Constant.ch"
#include "Inkey.ch"

#define GW_CHILD      5
#define GW_HWNDNEXT   2
#define RT_BITMAP     2

#define MB_ICONEXCLAMATION 48

#ifdef __XPP__
   #define New        _New
   #define Super      ::TBitmap
#endif

#define CBM_INIT 4 && should move to prg header

#define DIB_RGB_COLORS 0 && should move to prg header


static hLib

function ImageEditor( cFileName )
local oWnd
local oImage := nil
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )

DEFAULT cFileName := cGetFile( "Imágenes (*.bmp *.gif *.jpg *.ico *.png *.tif ) | *.bmp;*.gif;*.jpg;*.ico;*.png;*.tif; |", "Selecciona fichero" )
if empty( cFileName ) .or. !file( cFileName )
   MsgStop( "Fichero no encontrado")
   return 0
endif

  DEFINE WINDOW oWnd  ;
         FROM 0,200 TO aClient[3]-Aplicacion():oWnd:oBar:nHeight , aClient[4] PIXEL ;
         TITLE "Editor de imágenes - [" + cFileName + "]"



         if file( cFileName )
            @ 10, 10 IMAGE oImage OF oWnd FILE cFileName PIXEL
            DEFINE BRUSH oImage:oBrush STYLE "NULL"
            WndFold()
            Aplicacion():oImgFocus := oImage
            oWnd:bGotFocus := {|| Aplicacion():oImgFocus := oImage,;
                                  Aplicacion():oToolBox:cargo:SetOption( 1 ),;  // tab
                                  Aplicacion():oToolBox:cargo:cargo[1]:SetOption( 4 ) }
         endif




  ACTIVATE WINDOW oWnd ON INIT if( oImage != nil, oImage:SetSize( nBmpWidth( oImage:hBitmap ), nBmpHeight( oImage:hBitmap ) ),)

return nil


CLASS TImage FROM TBitmap

   DATA nProgress
   DATA hDib
   DATA cBmpFile

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
               oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
               cMsg, lUpdate, bWhen, lPixel, bValid, lDesign ) CONSTRUCTOR

   METHOD Define( cResName, cBmpFile, oWnd ) CONSTRUCTOR
   METHOD Destroy()

   METHOD LoadImage( cResName, cBmpFile )
   METHOD LoadImage2( cBmpFile )

   METHOD Progress( lProgress )

   METHOD SaveImage( cFile, nFormat, nFlag )
   METHOD LoadImage2( cFileName )

   METHOD Zoom( nZoom )
   METHOD UnZoom( nZoom )

   METHOD Rotar( nAngle )
   METHOD FlipV()
   METHOD FlipH()
   METHOD Save() INLINE ::SaveImage()
   METHOD SaveAsJPG()
   METHOD SaveAsTIF()
   METHOD SaveAsPNG()
   METHOD SaveAsBMP()
   METHOD SaveAsGIF()
   METHOD SaveAsICO()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign ) CLASS TImage

   #ifdef __XPP__
      ::lRegistered = .f.
   #endif

   ::nProgress := 1
   ::hDib      := 0

   hLib := hLib()

   Super:New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder, ;
              oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,      ;
              cMsg, lUpdate, bWhen, lPixel, bValid, lDesign )



return Self

*******************************************************************************
 METHOD Destroy() CLASS TImage
*******************************************************************************

 FreeFreeImage()

 return super:Destroy()

//----------------------------------------------------------------------------//
// This method does not create a control, it just creates a bitmap object to
// be used somewhere else.
METHOD Define( cResName, cBmpFile, oWnd ) CLASS TImage

   local aBmpPal

   DEFAULT oWnd := GetWndDefault()

   ::oWnd     = oWnd
   ::nZoom    = 1
   ::hWnd     = 0
   ::hBitmap  = 0
   ::hPalette = 0

   if ! Empty( cResName )
      aBmpPal    = PalBmpLoad( cResName )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      cBmpFile  = nil
   elseif File( cBmpFile )
      ::hBitmap = ::loadimage2( AllTrim( cBmpFile ), ::nProgress )
      cResName  := nil
   endif

   if ::hBitmap != 0
      PalBmpNew( 0, ::hBitmap, ::hPalette )
   endif

   if hLib == nil
      hLib := LoadLibrary( "freeimage.dll" )
   endif
   nInstance++


return Self

//----------------------------------------------------------------------------//

METHOD LoadImage( cResName, cBmpFile ) CLASS TImage

   local lChanged := .f.
   local hOldBmp  := ::hBitmap
   local hOldPal  := ::hPalette
   local aBmpPal

   DEFAULT cResName := ::cResName, cBmpFile := ::cBmpFile

   if ! Empty( cResName )
      aBmpPal    = PalBmpLoad( cResName )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      lChanged   = .t.
      cBmpFile   = nil
   elseif File( cBmpFile )
       ::hBitmap = ::loadimage2( AllTrim( cBmpFile ), ::nProgress )
       lChanged  := .t.
       cResName  := nil
   endif

   if lChanged

      ::cResName = cResName
      ::cBmpFile = cBmpFile

      if ! Empty( hOldBmp )
         PalBmpFree( hOldBmp, hOldPal )
      endif

      PalBmpNew( ::hWnd, ::hBitmap, ::hPalette )

   endif

return lChanged

*****************************************************************************
  METHOD LoadImage2( cFile ) CLASS TImage
*****************************************************************************

   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   ::cBmpFile := cFile
   nFormat   := fiGetFileType( cFile, 0 )
   ::hDib    := fiLoad( nFormat, cFile, 0 )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )
   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   ::hBitmap := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   ReleaseDC32( hWnd, hDC )

return ::hBitmap




//----------------------------------------------------------------------------//
METHOD Zoom( nZoom ) CLASS TImage
local aClient := GetClientRect( ::hWnd )
local nWidth, nHeight

DEFAULT nZoom := 25

nWidth := aClient[4]
nHeight := aClient[3]

::lStretch := .t.

::SetSize( nWidth + ( nWidth *  nZoom / 100 ) ,;
           nHeight + ( nHeight *  nZoom / 100 ),.t. )

return nil

//----------------------------------------------------------------------------//
METHOD UnZoom( nZoom ) CLASS TImage
local aClient := GetClientRect( ::hWnd )
local nWidth, nHeight

DEFAULT nZoom := 25

nWidth  := aClient[4]
nHeight := aClient[3]

::lStretch := .t.

::SetSize( nWidth - ( nWidth *  nZoom / 100 ) ,;
           nHeight - ( nHeight *  nZoom / 100 ), .t. )


return nil
//----------------------------------------------------------------------------//

METHOD Progress( lProgress ) CLASS TImage

   if ValType( lProgress ) == "L"
      if lProgress
         ::nProgress = 1
      else
         ::nProgress = 0
      endif
   endif

return nil

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

   METHOD SaveAsJPG() CLASS TImage
   local cFileName := cGetFile( "*.jpg","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif
   ? ::SaveImage( cFileName, 2 )

   return 0

   METHOD SaveAsTIF() CLASS TImage
   local cFileName := cGetFile( "*.tif","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif
   ? ::SaveImage( cFileName, 18 )

   return 0

   METHOD SaveAsPng() CLASS TImage
   local cFileName := cGetFile( "*.png","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif
   ? ::SaveImage( cFileName, 13 )

   return 0

   METHOD SaveAsBMP() CLASS TImage
   local cFileName := cGetFile( "*.bmp","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif

   ? ::SaveImage( cFileName, 0 )

   return 0

   METHOD SaveAsICO() CLASS TImage
   local cFileName := cGetFile( "*.ico","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif

   ? ::SaveImage( cFileName, 1 )

   return 0

   METHOD SaveAsGIF() CLASS TImage
   local cFileName := cGetFile( "*.gif","Guardar imagen como...", 1, , .t. )
   if empty( cFileName )
      MsgStop( "Operación cancelada" )
      return 0
   endif
   if file( cFileName )
      if !MsgYesNo( "Fichero ya existe." + CRLF +;
                   "Desea sobre escribirlo?","Atención")
          MsgStop( "Operación cancelada" )
          return 0
      endif
   endif

   ? ::SaveImage( cFileName, 25 )

   return 0


METHOD SaveImage( cFile, nFormat, nFlag ) CLASS TImage

   local lOk

   //   0 -> Bmp
   //   2 -> Jpg
   //  13 -> Png



   DEFAULT nFormat   := fiGetFileType( ::cBmpFile, 0 )
   DEFAULT cFile     := ::cBmpFile

   if ::hDib == 0
      MsgStop( "No image loaded" )
      return nil
   endif

   lOk := fiSave( nFormat, ::hDib, cFile, nFlag )

   if !lOk
      MsgInfo( "Can't not save file" )
   endif

return Nil

********************************************************************************
 METHOD Rotar( nAngle ) CLASS TImage
********************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   ::hDib    := RotateClassic( ::hDib, nAngle )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )

   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   hBmp      := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   if hBmp != 0
      DeleteObject( ::hBitmap )
      ::hBitmap := hBmp
      ::SetSize( nBmpWidth( ::hBitmap ), nBmpHeight( ::hBitmap ), .t. )
      ::Refresh()
   endif

   ReleaseDC32( hWnd, hDC )

return ::hBitmap

********************************************************************************
 METHOD FlipV() CLASS TImage
********************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   FREEIMAGE_FLIPVERTICAL( @::hDib )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )

   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   hBmp      := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   if hBmp != 0
      DeleteObject( ::hBitmap )
      ::hBitmap := hBmp
      ::Refresh()
   endif

   ReleaseDC32( hWnd, hDC )

return ::hBitmap


********************************************************************************
 METHOD FlipH() CLASS TImage
********************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   FREEIMAGE_FLIPHORIZONTAL( @::hDib )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )

   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   hBmp      := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   if hBmp != 0
      DeleteObject( ::hBitmap )
      ::hBitmap := hBmp
      ::Refresh()
   endif

   ReleaseDC32( hWnd, hDC )

return ::hBitmap






//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

DLL32 STATIC FUNCTION FIGETFILETYPE( cFileName AS LPSTR, nSize AS LONG )AS LONG;
PASCAL FROM "_FreeImage_GetFileType@8" LIB hLib

DLL32 STATIC FUNCTION FILOAD( nFormat AS LONG, cFileName AS LPSTR,nFlags AS LONG ) AS LONG;
PASCAL FROM "_FreeImage_Load@12" LIB hLib

DLL32 STATIC FUNCTION FIGETINFOHEADER( hDib AS LONG ) AS LONG;
PASCAL FROM "_FreeImage_GetInfoHeader@4" LIB hLib

DLL32 STATIC FUNCTION FIGETINFO( hDib AS LONG ) AS LONG;
PASCAL FROM "_FreeImage_GetInfo@4" LIB hLib

DLL32 STATIC FUNCTION FIGETBITS( hDib AS LONG ) AS LONG;
PASCAL FROM "_FreeImage_GetBits@4" LIB hLib

DLL32 STATIC FUNCTION GETDSKTP32( hWnd AS LONG ) AS LONG;
PASCAL FROM "GetDesktopWindow" LIB "user32.dll"

DLL32 STATIC FUNCTION GETDC32( hWnd AS LONG ) AS LONG;
PASCAL FROM "GetDC" LIB "user32.dll"

DLL32 STATIC FUNCTION RELEASEDC32( hWnd AS LONG ) AS LONG;
PASCAL FROM "ReleaseDC" LIB "user32.dll"

DLL32 STATIC FUNCTION CREATEDIBITMAP( hDC AS LONG, hInfoH AS LONG,nFlags AS LONG, hBits AS LONG, hInfo AS LONG, nUsage AS LONG ) AS LONG;
PASCAL FROM "CreateDIBitmap" LIB "gdi32.dll"

DLL32 STATIC FUNCTION FISAVE( nFormat AS LONG, hDib AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS BOOL;
PASCAL FROM "_FreeImage_Save@16" LIB hLib


DLL32 STATIC FUNCTION ROTATECLASSIC( hDib AS LONG, angle AS _DOUBLE ) AS LONG;
PASCAL FROM "_FreeImage_RotateClassic@12" LIB hLib

DLL32 STATIC FUNCTION FREEIMAGE_FLIPHORIZONTAL( hDib AS LONG ) AS BOOL PASCAL FROM "_FreeImage_FlipHorizontal@4" LIB hLib
DLL32 STATIC FUNCTION FREEIMAGE_FLIPVERTICAL( hDib AS LONG ) AS BOOL PASCAL FROM "_FreeImage_FlipVertical@4" LIB hLib


#ifndef __HARBOUR__
 // only needed for 16 bits
 DLL32 FUNCTION WOWHANDLE16( nHandle AS LONG, nHandleType AS LONG ) AS LONG;
 PASCAL FROM "WOWHandle16" LIB "wow32.dll"
#endif

/*
FI_ENUM(FREE_IMAGE_FORMAT) {
	FIF_UNKNOWN = -1,
	FIF_BMP		= 0,
	FIF_ICO		= 1,
	FIF_JPEG	= 2,
	FIF_JNG		= 3,
	FIF_KOALA	= 4,
	FIF_LBM		= 5,
	FIF_IFF = FIF_LBM,
	FIF_MNG		= 6,
	FIF_PBM		= 7,
	FIF_PBMRAW	= 8,
	FIF_PCD		= 9,
	FIF_PCX		= 10,
	FIF_PGM		= 11,
	FIF_PGMRAW	= 12,
	FIF_PNG		= 13,
	FIF_PPM		= 14,
	FIF_PPMRAW	= 15,
	FIF_RAS		= 16,
	FIF_TARGA	= 17,
	FIF_TIFF	= 18,
	FIF_WBMP	= 19,
	FIF_PSD		= 20,
	FIF_CUT		= 21,
	FIF_XBM		= 22,
	FIF_XPM		= 23,
	FIF_DDS		= 24,
	FIF_GIF         = 25,
	FIF_HDR		= 26
};
*/
