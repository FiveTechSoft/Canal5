#include "fivewin.ch"

#define SRCCOPY 13369376
#define BLACKNESS         66//  (DWORD)0x00000042
#define CBM_INIT 4 && should move to prg header
#define DIB_RGB_COLORS 0 && should move to prg header

static hLib


CLASS TShowImg FROM TControl

      CLASSDATA lRegistered

      DATA cImage
      DATA oDirL
      DATA hBitmap
      DATA hDib
      DATA nGrados

      DATA nZoom

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oDirL, cImage ) CONSTRUCTOR

      METHOD Display() INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Paint()
      METHOD SetImage( cImage )
      METHOD Destroy()
      METHOD RotateLeft( n )
      METHOD RotateRight( n )
		METHOD Rotar( n )

ENDCLASS


METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oDirL, cImage ) CLASS TShowImg

   ::nZoom     := 1
   ::hBitmap   := 0
   ::oDirL     := oDirL
   ::cImage    := cImage
   ::nGrados   := 0

   hLib := hLib()

   ::SetImage( ::cImage )

   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := ::nTop + nHeight - 1
   ::nRight    := ::nLeft + nWidth - 1
   ::oWnd      := oWnd
   ::nStyle    = nOR( WS_BORDER, WS_VSCROLL, WS_HSCROLL,;
                      WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS,;
                      WS_CLIPCHILDREN ) // , WS_TABSTOP )

   ::nId       = ::GetNewId()

   ::SetColor( 0, RGB(238,238,238) )
   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif





return self

METHOD Paint() CLASS TShowImg
local nTop, nLeft, nWidth, nHeight
local aClient := GetClientRect( ::hWnd )

if ::hBitmap != 0
   nWidth  := nBmpWidth( ::hBitmap ) * ::nZoom
   nHeight := nBmpHeight( ::hBitmap ) * ::nZoom

   if nWidth > aClient[4] .or. nHeight > aClient[3]
      nTop := 0
      nLeft := 0
      if ::nZoom == 1
         if nWidth > nHeight
            nWidth := aClient[4] / 1.2
            nHeight := nHeight * ( nWidth / nBmpWidth( ::hBitmap ) )
         else
            nHeight := aClient[3] / 1.2
            nWidth := nWidth * ( nHeight / nBmpHeight( ::hBitmap ) )
         endif
         nTop := (aClient[3]/2) - (nHeight/2)
         nLeft := (aClient[4]/2) - (nWidth/2)
      endif
   else
      nTop := (aClient[3]/2) - (nHeight/2)
      nLeft := (aClient[4]/2) - (nWidth/2)
   endif
   DrawBitmapEx( ::hDC, ::hBitmap, nTop, nLeft, nWidth, nHeight, SRCCOPY )
   Box( ::hDC, {nTop, nLeft, nTop + nHeight, nLeft + nWidth}, 0 )

endif

return 0

METHOD SetImage( cFile ) CLASS TShowImg
local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hDib

if ::hBitmap != 0
   DeleteObject( ::hBitmap )
   ::hBitmap := 0
   GlobalFree( ::hDib )
endif

if file( cFile )
   ::nZoom   := 1
   nFormat   := fiGetFileType( cFile, 0 )
   ::hDib      := fiLoad( nFormat, cFile, 0 )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )
   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   ::hBitmap := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )
   ReleaseDC32( hWnd, hDC )
endif

::Refresh()

return 0


  METHOD Destroy() CLASS TShowImg

   if ::hBitmap != 0
      DeleteObject( ::hBitmap )
      GlobalFree( ::hDib )
      ::hBitmap  = 0
   endif

   if ::oVScroll != nil
      ::oVScroll:End()
   endif

   if ::oHScroll != nil
      ::oHScroll:End()
   endif

   if ::hWnd != 0
      Super:Destroy()
   endif

   FreeFreeImage()

return nil


  METHOD RotateLeft( n ) CLASS TShowImg
  local nGrados := ::nGrados

  nGrados -= n

  if nGrados < 0
     nGrados += 360
  endif

  ::Rotar( nGrados )

  return 0

  METHOD RotateRight( n ) CLASS TShowImg
  local nGrados := ::nGrados

  nGrados += n

  if nGrados > 360
     nGrados -= 360
  endif

  ::Rotar( nGrados )

  return 0


********************************************************************************
 METHOD Rotar( nAngle ) CLASS TShowImg
********************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   ::hDib := RotateClassic( ::hDib, nAngle )
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

DLL32 STATIC FUNCTION ROTATECLASSIC( hDib AS LONG, angle AS _DOUBLE ) AS LONG;
PASCAL FROM "_FreeImage_RotateClassic@12" LIB hLib

DLL32 STATIC FUNCTION FISETBKCOLOR(hDib AS LONG, bkcolor AS _DOUBLE ) AS BOOL ;
PASCAL FROM "FreeImage_SetBackgroundColor" LIB hLib

DLL32 STATIC FUNCTION FISAVE( nFormat AS LONG, hDib AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS BOOL;
PASCAL FROM "_FreeImage_Save@16" LIB hLib

DLL32 STATIC FUNCTION FIADJUSTBRIGHTNESS( hDib AS LONG, percentage AS _DOUBLE ) AS BOOL ;
PASCAL FROM "_FreeImage_AdjustBrightness@12" LIB hLib

DLL32 STATIC FUNCTION FIADJUSTCONTRAST( hDib AS LONG, percentage AS _DOUBLE ) AS BOOL ;
PASCAL FROM "_FreeImage_AdjustContrast@12" LIB hLib


#ifndef __HARBOUR__
 // only needed for 16 bits
 DLL32 FUNCTION WOWHANDLE16( nHandle AS LONG, nHandleType AS LONG ) AS LONG;
 PASCAL FROM "WOWHandle16" LIB "wow32.dll"
#endif

