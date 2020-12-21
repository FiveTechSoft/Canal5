#include "fivewin.ch"
#include "wnddsgn.ch"
#include "Splitter.ch"

#define SRCCOPY  13369376

#define HORZSIZE      4
#define VERTSIZE      6



function DsgnPrt( nType )

local oWnd, oDsgn, oBar, oShape
local oPanel
local oBrush
local lVScroll := .f.
local lHScroll := .f.
local cTitle   := "Diseñador de formularios"
local oSplit
local nWidth
local nHeight
local oImageList
local oDirList
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )
local nH, nW
local hDC

 nH := 297.4
 nW := 210.0

 hDC := CreateDC( "DISPLAY", 0, 0, 0 )
 nWidth := ( 1024 / GetDeviceCaps( hDC, HORZSIZE ) ) * nW
 nHeight := ( 768  / GetDeviceCaps( hDC, VERTSIZE ) ) * nH
 DeleteDC( hDC )


DEFINE BRUSH oBrush STYLE "NULL"

oWnd := TMdiChild2():New(   0,;
                          200,;
               aClient[4]-200,;
          aClient[3]-Aplicacion():oWnd:oBar:nHeight,;
        cTitle,,,; //nOr( WS_CLIPCHILDREN, WS_VISIBLE,WS_POPUP)
           Aplicacion():oWnd,,;
                     lVScroll,;
                            0,;
                   16777215,,,;
                          .F.,;
                   lHScroll,,,!.F.,!.F.,!.F.,!.F.,)

    oDsgn := TDsgnEditorRpt():New( 6, 6, nWidth, nHeight, oWnd )
    oDsgn:lBorder := .t.
    oDsgn:nType = nType

    oWnd:bCopy  := {|| if( oDsgn:oSelected != nil, oDsgn:oSelected:Copy(),) }
    oWnd:bPaste := {|| oDsgn:Paste( 40, 10, oDsgn ) }
    oWnd:bUndo  := {|| oDsgn:Undo() }
    oWnd:bSelectAll  := {|| oDsgn:SelectAll() }
    oWnd:bDelete  := {|| oDsgn:KeyDown( VK_DELETE ) }

       DEFINE SCROLLBAR oWnd:oHScroll HORIZONTAL   OF oWnd ;
          RANGE 12, 500 ;
          ON UP       oDsgn:GoLeft()   ;
          ON DOWN     oDsgn:GoRight()  ;
          ON PAGEUP   oDsgn:PageLeft()  ;
          ON PAGEDOWN oDsgn:PageRight() ;
          ON THUMBPOS oDsgn:HThumbPos( nPos )
          oWnd:oHScroll:SetPos( 6 )


       DEFINE SCROLLBAR oWnd:oVScroll VERTICAL OF oWnd ;
          RANGE 12, 500 ;
          ON UP       oDsgn:GoUp()    ;
          ON DOWN     oDsgn:GoDown()  ;
          ON PAGEUP   oDsgn:PageUp()   ;
          ON PAGEDOWN oDsgn:PageDown() ;
          ON THUMBPOS oDsgn:VThumbPos( nPos )
          oWnd:oVScroll:SetPos( 6 )

    WndFold()


ACTIVATE WINDOW oWnd ;
         ON INIT ( oWnd:Move( 0, 200, aClient[4]-200, aClient[3]-Aplicacion():oWnd:oBar:nHeight,.t.))


return oDsgn


CLASS TDsgnEditorRpt FROM TDsgnEditor

      CLASSDATA lRegistered AS LOGICAL

      DATA nHHeader
      DATA nHBody
      DATA nHFoot

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR

      METHOD Paint()

ENDCLASS


**********************************************************************************************************************
      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TDsgnEditorRpt
**********************************************************************************************************************
   local nCuarto := nHeight / 4

   super:New( nTop, nLeft, nWidth, nHeight, oWnd )

   ::nHHeader := nCuarto
   ::nHBody   := nCuarto*2
   ::nHFoot   := nCuarto

return self



**********************************************************************************************************************
  METHOD Paint() CLASS TDsgnEditorRpt
**********************************************************************************************************************
   local hDCMem
   local hBmpMem
   local aRect := GetClientRect(::hWnd)
   local hOldBmp
   local nLen
   local n
   local oFigura
   local hRegion, hRegion2
   local rc := {aRect[1],aRect[2],aRect[3],aRect[4]}
   local hOldFont, oFont
   local hPen := CreatePen( PS_DOT, 1, 0 )
   local hOldPen

   hDCMem  := CreateCompatibleDC( ::hDC )
   hBmpMem := CreateCompatibleBitmap( ::hDC, aRect[4], aRect[3] )
   hOldBmp := SelectObject( hDCMem, hBmpMem )

   FillSolidRect( hDCMem, aRect, RGB(240,240,250),0)

   nLen := len( ::aShapes )

   if nLen > 0
      ::aShapes[nLen]:Paint( hDCMem )
   endif

   hRegion := CreateRectRgn( rc[2],  rc[1], rc[4], rc[3] )
   SelectClipRgn( hDCMem, hRegion )
   DeleteObject( hRegion )

   hOldPen := SelectObject( hDCMem, hPen )
   Moveto( hDCMem,        0, ::nHHeader ) ;                     Lineto( hDCMem, ::nWidth, ::nHHeader )
   Moveto( hDCMem,        0, ::nHHeader+::nHBody ) ;            Lineto( hDCMem, ::nWidth, ::nHHeader+::nHBody )
   Moveto( hDCMem,        0, ::nHHeader+::nHBody+::nHFoot ) ;   Lineto( hDCMem, ::nWidth, ::nHHeader+::nHBody+::nHFoot )
   SelectObject( hDCMem, hOldPen )
   DeleteObject( hPen )

   for n := nLen-1 to 1 step -1
       oFigura := ::aShapes[n]
       if oFigura:lVisibleInForm
             oFigura:Paint( hDCMem )
       endif
   next

   if !empty( ::aRectSel )
      DrawFocusRect( hDCMem, ::aRectSel[1], ::aRectSel[2], ::aRectSel[3], ::aRectSel[4])
   endif

   SelectClipRgn( hDCMem, nil )

BitBlt( ::hDC, 0, 0, aRect[4], aRect[3], hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmpMem )
DeleteDC( hDCMem )


return 0


