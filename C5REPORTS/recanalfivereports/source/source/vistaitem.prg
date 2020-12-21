#include "fivewin.ch"

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************


CLASS TVistaMenuItem

      CLASSDATA nInitID INIT 100

      DATA oWnd
      DATA cText
      DATA cImage
      DATA hBmp
      DATA bAction
      DATA lLevel1    AS LOGICAL INIT .F.
      DATA aItems

      DATA rcItem
      DATA rcItemL1
      DATA nHText

      DATA nId
      DATA nHImage     AS NUMERIC INIT 0
      DATA nWImage     AS NUMERIC INIT 0
      DATA nAlphaLevel AS NUMERIC INIT 255
      DATA lEnable     AS LOGICAL INIT .T.
      DATA lHasAlpha   AS LOGICAL INIT .F.

      // TOOLTIP
      DATA cTHeader
      DATA cTooltip    AS CHARACTER INIT ""
      DATA cTFoot
      DATA cTBmpHeader
      DATA cTBmpLeft
      DATA cTBmpFoot
      DATA cTBtnClose

      METHOD New        ( oWnd, cText, cImage, bAction ) CONSTRUCTOR
      METHOD InsertItem ( n, cText, cImage, bAction )
      METHOD AddItem    ( cText, cImage, bAction )
      METHOD DelItem    ( nItem )
      METHOD Paint      ( hDC, lSelected, lFocus )
      METHOD IsOver     ( nRow, nCol ) INLINE PtInRect( nRow, nCol, ::rcItem )
      METHOD GetNewId   ( )            INLINE If( ::nInitId == nil, ::nInitId := 100,),++::nInitId
      METHOD LoadImage  ( cImage )
      METHOD nLen       ( ) INLINE len(::aItems)
      METHOD Destroy    ( )
      METHOD Enable     ( )
      METHOD Disable    ( )
      METHOD SetTooltip ( cTooltip, cBmpLeft, cHeader, cBmpHeader, cBody, cBmpBody, lBtnClose )
      METHOD oGetOver   ( nRow, nCol )
      METHOD SetText    ( cText ) INLINE ::cText := cText, ::oWnd:Resize()


ENDCLASS

*********************************************************************************************************
  METHOD New( oWnd, cText, cImage, bAction )  CLASS TVistaMenuItem
*********************************************************************************************************

   ::oWnd        := oWnd
   ::cText       := cText
   ::cImage      := cImage
   ::bAction     := bAction
   ::aItems      := {}
   ::rcItem      := {0,0,0,0}
   ::rcItemL1    := {0,0,0,0}
   ::hBmp        := 0
   ::nID         := ::GetNewID()

   ::LoadImage( ::cImage )

return self

*********************************************************************************************************
  METHOD InsertItem( n, cText, cImage, bAction ) CLASS TVistaMenuItem
*********************************************************************************************************

local oItem := TVistaMenuItem():New( ::oWnd, cText, cImage, bAction, self )

oItem:lEnable := ::lEnable

aadd( ::aItems, nil )
ains( ::aItems, n )
::aItems[n] := oItem

::oWnd:Resize()

return oItem


*********************************************************************************************************
  METHOD AddItem( cText, cImage, bAction ) CLASS TVistaMenuItem
*********************************************************************************************************

local oItem := TVistaMenuItem():New( ::oWnd, cText, cImage, bAction )

oItem:lEnable := ::lEnable

aadd(::aItems, oItem )

return oItem

*********************************************************************************************************
   METHOD DelItem( nItem ) CLASS TVistaMenuItem
*********************************************************************************************************

  if nItem < 1 .or. nItem > ::nLen()
     MsgStop( "Índice fuera de rango al borrar elementos","Atención")
     return 0
  endif

  adel ( ::aItems,  nItem     )
  asize( ::aItems, ::nLen()-1 )

  ::oWnd:Resize()

return 0

*********************************************************************************************************
  METHOD LoadImage( cImage ) CLASS TVistaMenuItem
*********************************************************************************************************
local nFormat := 0

if ::hBmp != 0
   DeleteObject( ::hBmp )
   ::hBmp := 0
endif

::cImage := cImage

if empty( ::cImage )
   ::hBmp := 0
   ::nHImage := 0
   ::nWImage := 0
   return 0
endif

if ValType( ::cImage ) == 'C' .and. '.' $ ::cImage
   if Lower( cFileExt( ::cImage ) ) == 'bmp'
      ::hBmp := ReadBitmap( 0, ::cImage )
   else
      ::hBmp := FILoadImg( ::cImage, @nFormat )
   endif
else
   ::hBmp := LoadBitmap( GetResources(), ::cImage )
endif

if ::hBmp == 0
   ::nHImage := 0
   ::nWImage := 0
   return 0
endif

::nHImage := nBmpHeight( ::hBmp )
::nWImage := nBmpWidth ( ::hBmp )

::lHasAlpha := HasAlpha(::hBmp)


return ::hBmp

*********************************************************************************************************
  METHOD Paint( hDC, lSelected, lFocus, nY, nX ) CLASS TVistaMenuItem
*********************************************************************************************************
local hFont, hOldFont
local nClrText
local nColor
local nTop
local nLeft
local nBottom
local nRight
local lDelFont := .f.
local hOldBrush, hPen, hOldPen, oBrush

DEFAULT nY := 0
DEFAULT nX := 0


nTop     := ::rcItem[1] + nY
nLeft    := ::rcItem[2] + nX
nBottom  := ::rcItem[3] + nY
nRight   := ::rcItem[4] + nX




if ::lLevel1
   hFont    := ::oWnd:oFont:hFont
   nClrText := ::oWnd:nClrText
else
   hFont    := ::oWnd:oFont2:hFont
   nClrText := ::oWnd:nClrText2
endif

if ::lEnable .and. PtInRect( ::oWnd:nRow-nY, ::oWnd:nCol-nX, ::rcItem )
   hFont := CreateFontUnderline( hFont )
   lDelFont := .t.
   if ::lLevel1
      nClrText := ::oWnd:nClrTextOver1
   else
      nClrText := ::oWnd:nClrTextOver2
   endif
endif

if lSelected .and. ::lEnable
   hPen    := CreatePen( PS_SOLID, 1, ::oWnd:nClrBorderOver )
   hOldPen := SelectObject( hDC, hPen )

   oBrush := TBrushEx():New( 3, ::rcItemL1[3]-::rcItemL1[1] ,::oWnd:nClrPaneOver, ::oWnd:nClrPaneOver2, .t. )
   hOldBrush := SelectObject( hDC, oBrush:hbrush)

   SetBrushOrg( hDC, oBrush:hBrush, ::rcItemL1[2]+nX, ::rcItemL1[1]+nY )

   //RoundRect( hDC, ::rcItemL1[1], ::rcItemL1[2]+2, ::rcItemL1[3], ::rcItemL1[4]-2, 5, 5 )
   RoundBox ( hDC, ::rcItemL1[2]+3+nX, ::rcItemL1[1]+1+nY, ::rcItemL1[4]-3+nX, ::rcItemL1[3]-1+nY, 6, 6, ::oWnd:nClrBorderOver2 )
   RoundRect( hDC,  ::rcItemL1[2]+2+nX, ::rcItemL1[1]+nY,   ::rcItemL1[4]-2+nX, ::rcItemL1[3]+nY,  5, 5 )
   //RoundBox ( hDC,  ::rcItemL1[1]+1, ::rcItemL1[2]+3, ::rcItemL1[3]-1, ::rcItemL1[4]-3,6, 6, ::oWnd:nClrBorderOver2 )

   SelectObject( hDC, hOldPen )
   SelectObject( hDC, hOldBrush )
   DeleteObject( hPen )
   oBrush:End()

endif

if lFocus
//   if ::lLevel1 .or. (!::lLevel1 .and. ::oWnd:nType == 1 )
//      DrawFocusRect( hDC, nTop, nLeft-5, nBottom, nRight+5 )
//   else
//      DrawFocusRect( hDC, nTop-2, nLeft-5, nBottom-2, nRight-15 )
//   endif
endif


hOldFont := SelectObject( hDC, hFont )

if !::lEnable
   nColor   := SetTextColor( hDC, CLR_HGRAY )
else
   nColor   := SetTextColor( hDC, nClrText )
endif



if ::hBmp != 0
   if ::lHasAlpha
      ABPaint( hDC, nLeft-::oWnd:nWLeftImage+10, nTop, ::hBmp, ::nAlphaLevel )
   else
      DrawMasked( hDC, ::hBmp, nTop, nLeft-::oWnd:nWLeftImage+10 )
   endif
endif

//if ::lLevel1
//   nLeft += ::oWnd:nWLeftImage
//endif

if ::lLevel1 .or. (!::lLevel1 .and. ::oWnd:nType == 1 )
   DrawMText( hDC, ::cText , {nTop,nLeft,nBottom,nRight} )
else
   DrawText( hDC, ::cText , {nTop,nLeft,nBottom,nRight}, 32 )
   //Linea( hDC, nTop+1, nRight-11, nBottom-1, nRight-11, rgb( 207,207,207))
endif


SelectObject( hDC, hOldFont )
SetTextColor( hDC, nColor   )


if lDelFont
   DeleteObject( hFont )
endif

return 0


*********************************************************************************************************
  METHOD Destroy() CLASS TVistaMenuItem
*********************************************************************************************************
local nLen := ::nLen()
local n

if ::hBmp != 0
   DeleteObject( ::hBmp )
endif

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:Destroy()
   next
endif

return 0

***********************************************************************************************************************
  METHOD SetTooltip( cTooltip, cBmp, cHeader, cBmpHeader, cFoot, cBmpFoot, cBtnClose ) CLASS TVistaMenuItem
***********************************************************************************************************************


::cTHeader    := cHeader
::cTooltip    := cTooltip
::cTFoot      := cFoot
::cTBmpHeader := cBmpHeader
::cTBmpLeft   := cBmp
::cTBmpFoot   := cBmpFoot
::cTBtnClose  := cBtnClose

return 0


***********************************************************************************************************************
      METHOD Enable() CLASS TVistaMenuItem
***********************************************************************************************************************
local nLen := ::nLen()
local n

::lEnable := .t.

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:lEnable := .t.
   next
endif

::Refresh()

return ::lEnable

***********************************************************************************************************************
      METHOD Disable() CLASS TVistaMenuItem
***********************************************************************************************************************
local nLen := ::nLen()
local n

::lEnable := .f.

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:lEnable := .f.
   next
endif

::Refresh()

return ::lEnable

*********************************************************************************************************
   METHOD oGetOver( nRow, nCol ) CLASS TVistaMenuItem
*********************************************************************************************************
local n
local nLen  := ::nLen()
local oOver

for n := 1 to nLen
    if ::aItems[n]:lEnable .and. PtInRect( nRow, nCol, ::aItems[n]:rcItemL1 )
       oOver := ::aItems[n]
       exit
    endif
next

return oOver

