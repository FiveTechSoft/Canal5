#include "fivewin.ch"
#include "wnddsgn.ch"
#define BLACKNESS         66//  (DWORD)0x00000042

#define CBM_INIT 4 && should move to prg header

#define DIB_RGB_COLORS 0 && should move to prg header

STATIC hLib

CLASS TDsgnImg FROM TShape

      DATA aProperties


      DATA cFileName
      DATA hBmp
      DATA hDib
      DATA hIcon
      DATA lIcon
      DATA lAdjust
      DATA lActive
      DATA lClientEdge
      DATA lFlat
      DATA lModalFrame
      DATA lMultiline
      DATA lStaticEdge
      DATA lTransparent
      DATA lSunken
      DATA nAlign
      DATA nClrText

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lIcon ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD cGetFileName()
      METHOD Destroy()
      METHOD RotateClassic2( nAngle )
      METHOD AjustaBrillo( nBrillo )
      METHOD AjustaContraste( nConstraste )
      METHOD LoadImage2( cFileName )
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD EditDlg ()
      METHOD SetProps( oList )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lIcon ) CLASS TDsgnImg
************************************************************************************************

   DEFAULT lIcon := .f.

   if nTop != nil .and. ( nBottom-nTop < 10 .or. nRight-nLeft < 10 )
      nBottom := nTop + 32
      nRight  := nLeft + 32
   endif

   if lIcon
      nBottom := nTop + 32
      nRight  := nLeft + 32
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::cCaption      := "Text"
   //::nClrPane      := nil
   ::nClrPane := GetSysColor( COLOR_BTNFACE )
   ::nAlign        := nOr(DT_SINGLELINE)
   ::lAdjust       := .f.
   ::lActive       := .t.
   ::lMultiline    := .f.
   ::lModalFrame   := .f.
   ::lClientEdge   := .f.
   ::lStaticEdge   := .f.
   ::lTransparent  := .t.
   ::lSunken       := .f.
   ::lBorder       := .f.
   ::lIcon         := lIcon
   ::hIcon         := 0
   ::hBmp          := 0
   ::nMinHeight    := 1
   ::nMinWidth     := 1
   ::cFileName     := " "
   ::cObjName         := ::GetObjName()

   ::cCaption     := "Image"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

   ::aProperties := { "cCaption"       ,;
                      "aDotsActives"   ,;
                      "aRect"          ,;
                      "cFileName"     ,;
                      "lActive"        ,;
                      "lAdjust"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lClientEdge"    ,;
                      "lStaticEdge"    ,;
                      "lSunken"        ,;
                      "lEditable"      ,;
                      "lFlat"          ,;
                      "lModalFrame"    ,;
                      "lTransparent"   ,;
                      "lVisible"       ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

   hLib := hLib()

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnImg
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hBmp := 0

if ::lIcon
   if file( ::cFileName )
      ::hBmp := ExtractIcon( ::cFileName )
   endif
   if ::hBmp == 0
      ::hBmp := LoadIcon( GetResources(),"icono" )
   endif
   if ::hBmp != 0
      DrawIcon( hDC, rc[1], rc[2], ::hBmp )
      DestroyIcon( ::hBmp )
   endif

else

   if file( ::cFileName )
      ::hBmp = FILoadImg( AllTrim( ::cFileName ) )
   endif


   if .f.
      return ::PaintContour( hDC )
   endif

   if ::hBmp == 0
      FillSolidRect( hDC, rc, CLR_WHITE, 0 )
      Moveto( hDC, rc[2], rc[1])
      Lineto( hDC, rc[4], rc[3])
      Moveto( hDC, rc[4], rc[1])
      Lineto( hDC, rc[2], rc[3])
   else
      if ::lAdjust
         if ::lTransparent
            DrawMasked( hDC, ::hBmp, ::aRect[1], ::aRect[2], ::nWidth, ::nHeight )
         else
            DrawBitmapEx( hDC, ::hBmp, ::aRect[1], ::aRect[2], ::nWidth, ::nHeight )
         endif
      else
         if ::lTransparent
            DrawMasked( hDC, ::hBmp, ::aRect[1], ::aRect[2] )
         else
            DrawBitmapEx( hDC, ::hBmp, ::aRect[1], ::aRect[2], nBmpWidth( hBmp ), nBmpHeight( hBmp ) )
         endif
      endif
   endif
endif

if ::lBorder
   Box( hDC, rc, 0 )
endif

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

if ::hBmp != 0
   DeleteObject( ::hBmp )
endif

return nil

***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnImg
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lAdjust"      ,,o:lAdjust       ,,{|oMenuItem|::lAdjust        := !::lAdjust       ,::Refresh()},,,,,,,.F.,,,.F. )
    MENUITEM "Imagen" ACTION o:cGetFileName() //xSelImage()
   SEPARATOR


return nil


***************************************************************************************************
      METHOD cGetFileName() CLASS TDsgnImg
***************************************************************************************************
local cFiltro := "Imágenes (*.bmp *.gif *.jpg ) | *.bmp;*.gif;*.jpg; |"
local cFiles := cGetFile( cFiltro, "Selecciona imagen" )
local cFile := ::cFileName

if ::lIcon
   cFiltro := "Iconos (*.ico ) | *.ico; |"
endif

::cFileName := cFiles

//if ::cFileName != cFile
//   if file( ::cFileName )
//      if ::hBmp != 0
//         DeleteObject( ::hBmp )
//      endif
//      ::hBmp = ::FiLoadImg( AllTrim( ::cFileName ) )
//   else
//      if ::hBmp != 0
//         DeleteObject( ::hBmp )
//         ::hBmp := 0
//      endif
//   endif
//endif


::oWnd:Refresh()

return ::cFileName

***************************************************************************************************
   METHOD Destroy( nKey, nFlags ) CLASS TDsgnImg
***************************************************************************************************

if ::hBmp != nil
   DeleteObject( ::hBmp )
endif

 FreeFreeImage()

return nil


***************************************************************************************************
  METHOD AjustaBrillo( nBrillo ) CLASS TDsgnImg
***************************************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp, hDib

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   FIAdjustBrightness( @::hDib, nBrillo )

   hInfoH  := fiGetInfoHeader( ::hDib )
   hInfo   := fiGetInfo( ::hDib )
   hBits   := fiGetBits( ::hDib )
   hWnd    := GetDskTp32()
   hDC     := GetDC32( hWnd )
   DeleteObject( ::hBmp )
   ::hBmp    := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )
   ReleaseDC32( hWnd, hDC )

return nil

***************************************************************************************************
  METHOD AjustaContraste( nConstraste ) CLASS TDsgnImg
***************************************************************************************************
   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp, hDib

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   FIAdjustContrast( @::hDib, nConstraste )

   hInfoH  := fiGetInfoHeader( ::hDib )
   hInfo   := fiGetInfo( ::hDib )
   hBits   := fiGetBits( ::hDib )
   hWnd    := GetDskTp32()
   hDC     := GetDC32( hWnd )
   DeleteObject( ::hBmp )
   ::hBmp    := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )
   ReleaseDC32( hWnd, hDC )

return nil

***************************************************************************************************
  METHOD RotateClassic2( nAngle ) CLASS TDsgnImg
***************************************************************************************************

   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp
   local cFile := ::cFileName


   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   nFormat := fiGetFileType( cFile, 0 )
   ::hDib    := fiLoad( nFormat, cFile, 0 )
   ::hDib    := RotateClassic( ::hDib, nAngle )
   hInfoH    := fiGetInfoHeader( ::hDib )
   hInfo     := fiGetInfo( ::hDib )
   hBits     := fiGetBits( ::hDib )

   hWnd      := GetDskTp32()
   hDC       := GetDC32( hWnd )
   hBmp      := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   ReleaseDC32( hWnd, hDC )

return hBmp


*****************************************************************************
  METHOD LoadImage2( cFile ) CLASS TDsgnImg
*****************************************************************************

   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if hLib <= 32
      MsgStop( "Cannot load Freeimage.dll" )
      return 0
   endif

   nFormat := fiGetFileType( cFile, 0 )
   ::hDib  := fiLoad( nFormat, cFile, 0 )
   hInfoH  := fiGetInfoHeader( ::hDib )
   hInfo   := fiGetInfo( ::hDib )
   hBits   := fiGetBits( ::hDib )
   hWnd    := GetDesktopWindow()
   hDC     := GetDC( hWnd )
   hBmp    := CreateDIBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo,DIB_RGB_COLORS )

   ReleaseDC32( hWnd, hDC )



return hBmp


*****************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnImg
*****************************************************************************
local cRet := ""

local cObject := ::cObjName

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

  cHeader += "local " + cObject + CRLF

  cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " IMAGE " + cObject + ' FILENAME "' + alltrim( ::cFileName ) + '" ;' + CRLF +;
          "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
          "                 OF " + cFrom + if( !::lBorder," NOBORDER","") + CRLF

return cRet


*****************************************************************************
  METHOD EditDlg() CLASS TDsgnImg
*****************************************************************************

local oWnd
local oBtn1
local oBtn3
local oBtn4
local oGet1
local cGet1 := padr( ::cFileName, 250 )
local oSay1
local oChk1
local lChk1 := .F.
local oImg1
local oBtn2
local oChk2
local lChk2 := .F.
local oChk3
local lChk3 := .F.


 DEFINE DIALOG oWnd FROM 0, 0 TO 0,0  SIZE 363, 229 ;
        TITLE "Propiedades de imágen"


        @ 10.50, 7.00 SAY oSay1 PROMPT "Fichero" ;
                 SIZE 19.00, 8.00 PIXEL ;
                 OF oWnd

        @ 8.00, 30.00 GET oGet1 VAR cGet1 ;
                 SIZE 107.50, 11.50 PIXEL ;
                 OF oWnd

        @ 7.50, 140.00 BUTTON oBtn1 PROMPT "..." ;
                 SIZE 13.00, 12.30 PIXEL ;
                 ACTION ( cGet1 := cGetFile( "*.bmp", "Seleccione imágen" ), oGet1:Refresh()) ;
                 OF oWnd

        @ 23.00, 30.00 CHECKBOX oChk1 VAR lChk1 PROMPT "Ruta relativa" ;
                 SIZE 42.00, 8.00 PIXEL ;
                 OF oWnd

        @ 31.50, 99.00 IMAGE oImg1 FILENAME "" ;
                 SIZE 62.50, 62.50 PIXEL ;
                 OF oWnd NOBORDER

        @ 34.00, 30.00 BUTTON oBtn2 PROMPT "Capturar" ;
                 SIZE 37.50, 11.50 PIXEL ;
                 ACTION CapturaRect() ;
                 OF oWnd

        @ 49.00, 30.00 CHECKBOX oChk2 VAR lChk2 PROMPT "Borde" ;
                 SIZE 31.00, 8.00 PIXEL ;
                 OF oWnd

        @ 60.50, 30.00 CHECKBOX oChk3 VAR lChk3 PROMPT "Ajustar" ;
                 SIZE 31.00, 8.00 PIXEL ;
                 OF oWnd

        @ 99.50, 137.00 BUTTON oBtn3 PROMPT "&Aceptar" ;
                 SIZE 37.50, 11.50 PIXEL ;
                 ACTION MsgInfo( "Action" ) ;
                 OF oWnd

        @ 99.50, 97.00 BUTTON oBtn4 PROMPT "&Cancelar" ;
                 SIZE 37.50, 11.50 PIXEL ;
                 ACTION MsgInfo( "Action" ) ;
                 OF oWnd


oWnd:lHelpIcon := .f.

ACTIVATE DIALOG oWnd CENTERED



return 0

***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnImg
***************************************************************************************************
local nGroup
local o := self

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lBorder","Border","L",nGroup )
oList:AddItem( "lAdjust","Adjust","L",nGroup )
oList:AddItem( "cFileName","Filename", "B",nGroup,,,{|| o:cGetFileName() } )


nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )


return 0


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


/*
#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"


///////////////////////////////////////////////////////////////////////////////////
// Emboss		- Creates a 3D embossed effect
// Returns		- A new bitmap containing the resulting effect
// hBitmap		- Bitmap that contains the basic text & shapes
// hbmBackGnd		- Contains the color image
// hPal			- Handle of palette associated with hbmBackGnd
// bRaised		- True if raised effect is desired. False for sunken effect
// xDest		- x coordinate - used to offset hBitmap
// yDest		- y coordinate - used to offset hBitmap
// clrHightlight	- Color used for the highlight edge
// clrShadow		- Color used for the shadow
//
// Note			- 1. Neither of the bitmap handles passed in should be selected
//			  in a device context.
//			  2. The pixel at 0,0 in hBitmap is considered the background color
//


HBITMAP Emboss( HBITMAP hBitmap, HBITMAP hbmBackGnd, HPALETTE hPal,
        	BOOL bRaised, int xDest, int yDest,
		COLORREF clrHighlight, COLORREF clrShadow )
{
	const DWORD PSDPxax = 0x00B8074A;
	BITMAP   bmInfo ;
	HBITMAP  hbmOld, hbmShadow, hbmHighlight, hbmResult, hbmOldMem ;
	HBRUSH   hbrPat ;
	HDC      hDC, hColorDC, hMonoDC, hMemDC ;
	BITMAP bm;

	if( !bRaised )
	{
		// Swap the highlight and shadow color
		COLORREF clrTemp = clrShadow;
		clrShadow = clrHighlight;
		clrHighlight = clrTemp;
	}

	// We create two monochrome bitmaps. One of them will contain the
	// highlighted edge and the other will contain the shadow. These
	// bitmaps are then used to paint the highlight and shadow on the
	// background image.

	hbmResult = NULL ;
	hDC = GetDC( NULL ) ;

	// Create a compatible DCs
	hMemDC = ::CreateCompatibleDC( hDC );
	hMonoDC = CreateCompatibleDC( hDC );
	hColorDC = CreateCompatibleDC( hDC );

	if( hMemDC == NULL || hMonoDC == NULL || hColorDC == NULL )
	{
		if( hMemDC ) DeleteDC( hMemDC );
		if( hMonoDC ) DeleteDC( hMonoDC );
		if( hColorDC ) DeleteDC( hColorDC );

		return NULL;
	}

	// Select the background image into memory DC so that we can draw it
	hbmOldMem = (HBITMAP)::SelectObject( hMemDC, hbmBackGnd );

	// Get dimensions of the background image

	::GetObject( hbmBackGnd, sizeof( bm ), &bm );



	// Create the monochrome and compatible color bitmaps
	GetObject( hBitmap, sizeof( BITMAP ), (LPSTR) &bmInfo ) ;
	hbmShadow =
		CreateBitmap( bmInfo.bmWidth, bmInfo.bmHeight, 1, 1, NULL ) ;
	hbmHighlight =
		CreateBitmap( bmInfo.bmWidth, bmInfo.bmHeight, 1, 1, NULL ) ;
	hbmResult =
		CreateCompatibleBitmap( hDC, bm.bmWidth, bm.bmHeight ) ;

	hbmOld = (HBITMAP)SelectObject( hColorDC, hBitmap ) ;

	// Set background color of bitmap for mono conversion
	// We assume that the pixel in the top left corner has the background color
	SetBkColor( hColorDC, GetPixel( hColorDC, 0, 0 ) ) ;

	// Create the highlight bitmap.
	hbmHighlight = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmHighlight ) ;
	PatBlt( hMonoDC, 0, 0, bmInfo.bmWidth, bmInfo.bmHeight, WHITENESS ) ;
	BitBlt( hMonoDC, 0, 0, bmInfo.bmWidth - 1, bmInfo.bmHeight - 1,
		hColorDC, 1, 1, SRCCOPY ) ;
	BitBlt( hMonoDC, 0, 0, bmInfo.bmWidth, bmInfo.bmHeight,
		hColorDC, 0, 0, MERGEPAINT ) ;
	hbmHighlight = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmHighlight ) ;


	// create the shadow bitmap
	hbmShadow = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmShadow ) ;
	PatBlt( hMonoDC, 0, 0, bmInfo.bmWidth, bmInfo.bmHeight, WHITENESS ) ;
	BitBlt( hMonoDC, 1, 1, bmInfo.bmWidth-1, bmInfo.bmHeight-1,
		hColorDC, 0, 0, SRCCOPY ) ;
	BitBlt( hMonoDC, 0, 0, bmInfo.bmWidth, bmInfo.bmHeight,
		hColorDC, 0, 0, MERGEPAINT ) ;
	hbmShadow = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmShadow ) ;


	// Now let's start working on the final image
	SelectObject( hColorDC, hbmResult ) ;
	// Select and realize the palette if one is supplied
	if( hPal && GetDeviceCaps(hDC, RASTERCAPS) & RC_PALETTE )
	{
		::SelectPalette( hColorDC, hPal, FALSE );
		::RealizePalette(hColorDC);
	}
	// Draw the background image
	BitBlt(hColorDC, 0, 0, bm.bmWidth, bm.bmHeight, hMemDC, 0, 0,SRCCOPY);
	// Restore the old bitmap in the hMemDC
	::SelectObject( hMemDC, hbmOldMem );


	// Set the background and foreground color for the raster operations
	SetBkColor( hColorDC, RGB(255,255,255) ) ;
	SetTextColor( hColorDC, RGB(0,0,0) ) ;

	// blt the highlight edge
	hbrPat = CreateSolidBrush( clrHighlight ) ;
	hbrPat = (HBRUSH)SelectObject( hColorDC, hbrPat ) ;
	hbmHighlight = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmHighlight ) ;
	BitBlt( hColorDC, xDest, yDest, bmInfo.bmWidth, bmInfo.bmHeight,
		hMonoDC, 0, 0, PSDPxax ) ;
	DeleteObject( SelectObject( hColorDC, hbrPat ) ) ;
	hbmHighlight = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmHighlight ) ;

	// blt the shadow edge
	hbrPat = CreateSolidBrush( clrShadow ) ;
	hbrPat = (HBRUSH)SelectObject( hColorDC, hbrPat ) ;
	hbmShadow = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmShadow ) ;
	BitBlt( hColorDC, xDest, yDest, bmInfo.bmWidth, bmInfo.bmHeight,
		hMonoDC, 0, 0, PSDPxax ) ;
	DeleteObject( SelectObject( hColorDC, hbrPat ) ) ;
	hbmShadow = (HBITMAP)SelectObject( hMonoDC, (HGDIOBJ) hbmShadow ) ;

	// select old bitmap into color DC
	SelectObject( hColorDC, hbmOld ) ;

	DeleteObject( (HGDIOBJ) hbmShadow ) ;
	DeleteObject( (HGDIOBJ) hbmHighlight ) ;

	ReleaseDC( NULL, hDC ) ;

	return ( hbmResult ) ;
}


HB_FUNC( EMBOSS )
{

    hb_retnl( (LONG) Emboss( (HBITMAP) hb_parnl( 1 ), (HBITMAP) hb_parnl( 2 ), (HPALETTE)  hb_parnl( 3 ),
        	hb_parl( 4 ), hb_parni( 5 ), hb_parni( 6 ),
		hb_parnl( 7 ), hb_parnl( 8 ) ) );

}

#pragma ENDDUMP

*/

************************************************************************************************
  function LoadImageEx( cImage )
************************************************************************************************

 local hBmp := 0

 hBmp := LoadBitmap( GetResources(), cImage )
 if hBmp == 0
    hBmp := ReadBitmap( 0, cImage )
 endif

return hBmp


