#include "fivewin.ch"


static oToolTip, oTmr, hPrvWnd, lToolTip := .f., hWndParent := 0,;
       hToolTip := 0


CLASS TVistaMenu FROM TShape //TControl

     // CLASSDATA lRegistered AS LOGICAL

      DATA nHMargen     AS NUMERIC INIT 0
      DATA nVTMargen    AS NUMERIC INIT 0
      DATA nRow, nCol
      DATA nxColumns
      DATA nWLeftImage
      DATA aItems
      DATA oOldOver
      DATA oOver
      DATA nOptionFocus AS NUMERIC INIT 1
      DATA oAbsOver
      //DATA rcItem

      DATA oFont
      DATA oFont2

      // COLORES
      DATA nClrText2

      // OVER
      DATA nColorStyle
      DATA nClrBorderOver
      DATA nClrBorderOver2
      DATA nClrPaneOver
      DATA nClrPaneOver2
      DATA nClrTextOver1
      DATA nClrTextOver2

      DATA nYOffset    AS NUMERIC INIT 0
      DATA aAlturas
      DATA nxType       AS NUMERIC INIT 1
      DATA nxMaxHeight  AS NUMERIC INIT 0

      METHOD New        ( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CONSTRUCTOR
      METHOD Redefine   ( nId, oWnd, oFont, oFont2 ) CONSTRUCTOR
      METHOD NewShape   ( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CONSTRUCTOR

      METHOD AddItem    ( cText, cImage, bAction )
      METHOD AddSample  ( )
      METHOD Default    ( )
      METHOD DelItem    ( nItem )
      METHOD Destroy    ( )
      METHOD Display    ( ) INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD EraseBkGnd ( hDC ) INLINE 1
      METHOD GetCoors   ( )
      METHOD Initiate   ( hDlg ) INLINE  Super:Initiate( hDlg ), ::Default()
      METHOD InsertItem ( n, cText, cImage, bAction )
      //METHOD IsOver     ( nRow, nCol ) INLINE PtInRect( nRow, nCol, ::rcItem )
      METHOD KeyDown    ( nKey, nFlags )
      METHOD LButtonDown( nRow, nCol )
      METHOD LButtonUp  ( nRow, nCol )
      METHOD LoadColors ( nStyle )
      METHOD MouseMove  ( nRow, nCol )
      METHOD Paint      ( )
      METHOD Resize     ( )
      METHOD SetMarginT ( n ) SETGET
      METHOD SetMarginH ( n ) SETGET
      METHOD VScroll    ( )
      METHOD nColumns   ( n ) SETGET
      METHOD nType      ( n ) SETGET
      METHOD nLen       ( ) INLINE len(::aItems)
      METHOD nRows      ( )
      METHOD oGetOver   ( nRow, nCol )
      METHOD ShowTooltip( nRow, nCol )
      METHOD ShowTooltip2( nRow, nCol )
      METHOD CheckToolTip()
      METHOD DestroyToolTip()
      METHOD oAbsoluteGetOver( nRow, nCol )
      METHOD oAbsItem( nItem )
      METHOD GoUp()
      METHOD GoDown()
      METHOD nAbsLen()
      METHOD ContextMenu( nRow, nCol )
      METHOD SetProps( oList )

ENDCLASS

*********************************************************************************************************
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CLASS TVistaMenu
*********************************************************************************************************

     //::oWnd           := oWnd
     //::nTop           := nTop
     //::nLeft          := nLeft
     //::nBottom        := nTop + nHeight
     //::nRight         := nLeft + nWidth
     //
     //::nStyle         := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_CLIPSIBLINGS, WS_CLIPCHILDREN, WS_VSCROLL )
     //::nId            := ::GetNewId()
     //::oFont  := oFont
     //::oFont2 := oFont2
     //
     //::Register(nOr( CS_VREDRAW, CS_HREDRAW ) )
     //
     //if ! Empty( oWnd:hWnd )
     //   ::Create()
     //   ::Default()
     //   oWnd:AddControl( Self )
     //else
     //   oWnd:DefControl( Self )
     //   ::lVisible  = .f.
     //endif


return self


*********************************************************************************************************
   METHOD Redefine( nId, oWnd, oFont, oFont2 ) CLASS TVistaMenu
*********************************************************************************************************

     //::oWnd       := oWnd
     //::nId        := nId
     //
     //::Register()
     //
     //::oWnd:DefControl( Self )
     //
     //::oFont  := oFont
     //::oFont2 := oFont2

return self

*********************************************************************************************************
   METHOD NewShape( nTop, nLeft, nBottom, nRight, oWnd, oFont, oFont2 ) CLASS TVistaMenu
*********************************************************************************************************

  ::hWnd := 0

  ::nxType := 1

  super:New( nTop, nLeft, nBottom, nRight, oWnd )

  ::cObjName         := ::GetObjName()
  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

  ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

   DEFINE FONT ::oFont  NAME "Segoe UI" SIZE 0, -20
   DEFINE FONT ::oFont2 NAME "Segoe UI" SIZE 0, -16

  ::Default()


return self

***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TVistaMenu
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MENUITEM "Añade item" ACTION o:AddSample()

   SEPARATOR


return nil
*********************************************************************************************************
      METHOD nColumns( n ) CLASS TVistaMenu
*********************************************************************************************************

  if pcount() > 0
     ::nxColumns := n
     ::Resize()
     ::Refresh()
  endif

return ::nxColumns

*********************************************************************************************************
      METHOD SetMarginT ( n )  CLASS TVistaMenu
*********************************************************************************************************

  if Pcount() > 0
     ::nVTMargen := n
  endif

return ::nVTmargen

*********************************************************************************************************
      METHOD SetMarginH ( n )  CLASS TVistaMenu
*********************************************************************************************************

if Pcount() > 0
   ::nHMargen := n
endif

return ::nHMargen

*********************************************************************************************************
   METHOD Default() CLASS TVistaMenu
*********************************************************************************************************

  ::aItems      := {}
  //::rcItem    := {0,0,0,0}
  ::nxColumns   := 1
  ::nWLeftImage := 70
  ::LoadColors( ::nColorStyle )
  ::nVTMargen   := 20

  if ::oFont == nil
     DEFINE FONT ::oFont  NAME "Segoe UI" SIZE 9, 22
  endif

  if ::oFont2 == nil
     DEFINE FONT ::oFont2 NAME "Segoe UI" SIZE 6, 15
  endif

  //DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self

  //::oVScroll:SetRange(0,0)
  //::cToolTip := ::ClassName()
  //::CheckToolTip()

   ::SetMarginH( 30 )
   ::nWLeftImage := 100

return 0

*********************************************************************************************************
   METHOD Destroy( ) CLASS TVistaMenu
*********************************************************************************************************
local n
local nLen := ::nLen()

::oFont2:End()

for n := 1 to nLen
    ::aItems[n]:Destroy()
next

return super:Destroy()


*********************************************************************************************************
   METHOD InsertItem( n, cText, cImage, bAction ) CLASS TVistaMenu
*********************************************************************************************************

local oItem := TVistaMenuItem():New( self, cText, cImage, bAction, self )
oItem:lLevel1 := .t.
aadd( ::aItems, nil )
ains( ::aItems, n )
::aItems[n] := oItem

::Resize()

return oItem

*********************************************************************************************************
   METHOD AddItem( cText, cImage, bAction ) CLASS TVistaMenu
*********************************************************************************************************

local oItem := TVistaMenuItem():New( self, cText, cImage, bAction, self )
oItem:lLevel1 := .t.
aadd( ::aItems, oItem )

return oItem

*********************************************************************************************************
   METHOD DelItem( nItem ) CLASS TVistaMenu
*********************************************************************************************************

  if nItem < 1 .or. nItem > ::nLen()
     MsgStop( "Índice fuera de rango al borrar elementos","Atención")
     return 0
  endif

  adel ( ::aItems,  nItem     )
  asize( ::aItems, ::nLen()-1 )

  ::Resize()

return 0

****************************************************************************************************
   METHOD ReSize( nType, nWidth, nHeight )  CLASS TVistaMenu
****************************************************************************************************

   ::nYOffset := 0
   ::GetCoors()
   Super:ReSize( nType, nWidth, nHeight )

return 0


*********************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TVistaMenu
*********************************************************************************************************

   do case
      case nKey == VK_UP
           ::GoUp()
      case nKey == VK_DOWN
           ::GoDown()
      case nKey == VK_LEFT
      case nKey == VK_RIGHT
   endcase




return 0

*********************************************************************************************************
   METHOD GoUp() CLASS TVistaMenu
*********************************************************************************************************
local rc := ::GetClientRect(::hWnd)
local n := ::nOptionFocus

::nOptionFocus := max( 1, ::nOptionFocus-1)

if !IntersectRect( rc, ::oAbsItem( ::nOptionFocus ):rcItem )
   ::nYOffset := min( 0, ::nYOffset + 40 )
endif

if n != ::nOptionFocus
   ::GetCoors()
   ::Refresh(.t.)
endif

return 0

*********************************************************************************************************
   METHOD GoDown() CLASS TVistaMenu
*********************************************************************************************************
local rc := ::GetClientRect(::hWnd)
local n := ::nOptionFocus

::nOptionFocus := min( ::nAbsLen(), ::nOptionFocus+1 )

if !IntersectRect( rc, ::oAbsItem( ::nOptionFocus ):rcItem )
   ::nYOffset -= 40
endif

if n != ::nOptionFocus
   ::GetCoors()
   ::Refresh(.t.)
endif

return 0

*********************************************************************************************************
   METHOD nAbsLen() CLASS TVistaMenu
*********************************************************************************************************
local nCount := 0
local n, n2, nLen, nLen2

nLen := ::nLen()
for n := 1 to nLen
    nCount++
    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        nCount++
    next
next

return nCount

*********************************************************************************************************
   METHOD oAbsItem( nItem ) CLASS TVistaMenu
*********************************************************************************************************
local nCount := 0
local n, n2, nLen, nLen2

nLen := ::nLen()
for n := 1 to nLen
    nCount++
    if nItem == nCount
       return ::aItems[n]
    endif
    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        nCount++
        if nItem == nCount
           return ::aItems[n]:aItems[n2]
        endif
    next
next

return nil



*********************************************************************************************************
   METHOD LButtonDown( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
::oOldOver := ::oGetOver( nRow, nCol )

if !::lCaptured
   ::Capture()
   ::lCaptured = .t.
endif


return 0

*********************************************************************************************************
   METHOD MouseMove( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
local oOver := ::oAbsoluteGetOver( nRow, nCol )
local nY := if( ::hWnd == 0, ::nTop, 0 )
local nX := if( ::hWnd == 0, ::nLeft, 0 )


::nRow := nRow
::nCol := nCol

if oOver != nil
   if ::oAbsOver != nil
      if oOver:nID != ::oAbsOver:nID
         ::DestroyToolTip()
         ::oAbsOver := oOver
         ::CheckToolTip()
      endif
   else
      ::DestroyToolTip()
      ::oAbsOver := oOver
      ::CheckToolTip()
   endif

else
   ::DestroyToolTip()
endif

::oOver := ::oGetOver( nRow-nY, nCol-nX )

::Refresh()

if ::oOver != nil
   CursorHand()
else
   Cursorarrow()
endif


return 0

*********************************************************************************************************
   METHOD LButtonUp( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
local n
local nLen
ReleaseCapture()
::lCaptured := .f.

if ::oOver != nil .and. ::oOver == ::oOldOver
   nLen := len( ::oOver:aItems )
   for n := 1 to nLen
       if ::oOver:aItems[n]:IsOver( nRow, nCol )
          if ::oOver:aItems[n]:bAction != nil
             return eval( ::oOver:aItems[n]:bAction, ::oOver:aItems[n] )
          else
             return 0
          endif
       endif
   next
   if ::oOver:bAction != nil
      if ::oOver:lEnable
         return eval( ::oOver:bAction, ::oOver )
      endif
   endif
endif

return 0



*********************************************************************************************************
   METHOD Paint( hDC ) CLASS TVistaMenu
*********************************************************************************************************
local hDCMem
local hBmpMem
local hOldBmp
local rc := ::aRect
local n, n2
local nLen := ::nLen()
local nLen2
local hOldFont
local nColor, nMode
local lSelected
local nCount := 0
local nY := 0
local nX := 0
local rc2
local hRgn
local hOldRgn

if ::hDC == nil
   hDCMem := hDC
   super:Paint( hDCMem )
   nY := ::nTop
   nX := ::nLeft
   hRgn := C5CreateRectRgn(rc[1], rc[2],rc[3],rc[4] )
   hOldRgn := C5SelectClipRgn( hDCMem, hRgn )
else
   hDCMem     := CreateCompatibleDC( ::hDC )
   hBmpMem    := CreateCompatibleBitmap( ::hDC, rc[4]-rc[2], rc[3]-rc[1] )
   hOldBmp    := SelectObject( hDCMem, hBmpMem )
endif

nMode      := SetBkMode( hDCMem, 1 )


FillSolidRect( hDCMem, rc, ::nClrPane )
if ::lBorder
   Box( hDCMem, rc, ::nClrBorder )
endif

for n := 1 to nLen

    lSelected := ::oOver != nil .and. ::oOver:nId == ::aItems[n]:nId
    nCount++
    ::aItems[n]:Paint( hDCMem, lSelected, nCount == ::nOptionFocus , nY, nX )

    nLen2 := ::aItems[n]:nLen()

    for n2 := 1 to nLen2
        nCount++
        ::aItems[n]:aItems[n2]:Paint( hDCMem, .f., nCount == ::nOptionFocus, nY, nX )
    next

next

SetBkMode( hDCMem, nMode )

if ::hDC != nil
   BitBlt( ::hDC, 0, 0, rc[4]-rc[2], rc[3]-rc[1], hDCMem,  0, 0, 13369376 )
   SelectObject( hDCMem, hOldBmp )
   DeleteObject( hBmpMem )
   DeleteDC( hDCMem )
else
   C5SelectClipRgn( hDCMem, 0 )
   DeleteObject( hRgn )

   if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
      ::DotsSelect( hDC )
   endif

endif

return 0


*********************************************************************************************************
   METHOD GetCoors() CLASS TVistaMenu
*********************************************************************************************************
local hDC
local hOldFont
local lFirst
local n
local n2
local nAcum
local nAcumWidth
local nB
local nBottom
local nCol
local nFila
local nHItem
local nHText
local nHeight
local nL
local nLeft
local nLeft0
local nLen
local nLen2
local nR
local nRight
local nRows
local nT
local nTop
local nWColumn
local nWText
local nWidth
local rc

lFirst     := .t.
hDC        := CreateDC( "DISPLAY",0,0,0)
rc         := ::GetClientRect(::hWnd)

rc := {0,0,rc[3]-rc[1],rc[4]-rc[2]}


nHeight    := rc[3]-rc[1]
nWidth     := rc[4]-rc[2]-15-(::nHMargen*2)

if ::nType == 2            // ¡¡ATENCIÓN!! SI ::nType == 2 -> ::nColumns := 1
   ::nColumns := 1
endif

nWColumn   := nWidth / ::nColumns
nLen       := ::nLen()
n          := 1
nRows      := ::nRows()
nTop       := rc[1]
nLeft      := rc[2] + 5 + ::nWLeftImage + ::nHMargen
nLeft0     := nLeft
nBottom    := nTop
nRight     := rc[2]+ nWColumn - 5
nFila      := 1
nCol       := 1
nAcum      := 0
nHItem     := 0
nAcumWidth := 0


::nxMaxHeight := 0
SetTextAlign( hDC, 0 )

::aAlturas := afill(array(::nColumns),0)

  for n := 1 to nLen

      nAcum := 0

      if nFila > nRows // cambio de columna

         nFila := 1
         nCol++

         nTop     := rc[1]
         nLeft    := nR + ::nWLeftImage
         nBottom  := nTop
         nRight   := nR + nWColumn

      endif

      // Para el item general que abarca a todos
      nT := nTop
      nL := nLeft  - ::nWLeftImage
      nB := nTop
      nR := nRight + 5

      nHItem := 0

      hOldFont := SelectObject( hDC, ::oFont:hFont )
      nHText   := DrawMText( hDC, ::aItems[n]:cText, {nTop, nLeft, nBottom, nRight }, .f.)
      SelectObject( hDC, hOldFont )
      nBottom := nTop + nHText

      ::aItems[n]:rcItem := { nTop, nLeft, nBottom, nRight }

      nAcum += nHText

      nLen2 := len( ::aItems[n]:aItems )
      do case
         case ::nType == 1
              for n2 := 1 to nLen2

                  nTop     := nBottom
                  nBottom  := nTop

                  hOldFont := SelectObject( hDC, ::oFont2:hFont )

                  nHText   := DrawMText( hDC, ::aItems[n]:aItems[n2]:cText , {nTop, nLeft, nBottom, nRight }, .f.)

                  SelectObject( hDC, hOldFont )

                  nBottom := nTop + nHText

                  ::aItems[n]:aItems[n2]:rcItem := { nTop, nLeft, nBottom, nRight }

                  nAcum += nHText

              next n2

         case ::nType == 2

              nTop       := nBottom +10
              nBottom    := nTop
              nLeft      := nLeft0
              nAcumWidth := 0

              lFirst     := .t.

              for n2 := 1 to nLen2

                  hOldFont := SelectObject( hDC, ::oFont2:hFont )

                  nHText   := DrawText( hDC, ::aItems[n]:aItems[n2]:cText , {0, nLeft0, 100, rc[4]}, 1056 ) * 1.3// DT_LEFT, DT_SINGLELINE, DT_CALCRECT
                  nWText   := GetTextWidth( hDC, ::aItems[n]:aItems[n2]:cText , ::oFont2:hFont ) + 22

                  SelectObject( hDC, hOldFont )

                  if nLeft + nWText < rc[4]-5

                     nRight     := nLeft + nWText
                     nBottom    := nTop + nHText

                     ::aItems[n]:aItems[n2]:rcItem := { nTop, nLeft, nBottom, nRight }

                     nLeft      := nRight

                     if lFirst
                        nAcum += nHText
                        lFirst := .f.
                     endif

                  else

                     lFirst     := .t.

                     if nLeft == nLeft0

                        nRight   := nLeft + nWText
                        nBottom  := nTop + nHText

                        ::aItems[n]:aItems[n2]:rcItem := {nTop, nLeft, nBottom, nRight}

                        nTop     += nHText
                        nBottom  := nTop + nHText
                        nLeft    := nLeft0
                        nRight   := nLeft + nWText

                     else

                        nTop    += nHText
                        nBottom := nTop + nHText
                        nLeft   := nLeft0
                        nRight  := nLeft + nWText
                        ::aItems[n]:aItems[n2]:rcItem := {nTop, nLeft, nBottom, nRight}
                        nLeft      := nRight


                     endif

                     nAcum += nHText

                  endif

              next n2

              nLeft := nLeft0
              nRight     := rc[2]+ nWColumn - 5

      endcase

      nHItem := max( ::aItems[n]:nHImage, nAcum ) + 10


      nB := nT + nHItem
      nT := nT - 10

      ::aItems[n]:rcItemL1 := { nT+5, nL, nB-5, nR }

      nTop := nB + 10


      ::aAlturas[nCol] += ( nTop - ::aItems[n]:rcItemL1[1] )

      nFila++

  next n



DeleteDC( hDC )

for n := 1 to len(::aAlturas)
    ::nxMaxHeight := max( ::nxMaxHeight, ::aAlturas[n] )
next

//if ::nMaxHeight < nHeight
//   ::oVScroll:SetRange(0,0)
//else
//   ::oVScroll:SetRange(0, (::nMaxHeight-nHeight )/ 10)
//   c5SetScrollInfo( ::hWnd, 1, int(( nHeight/::nMaxHeight)*(::nMaxHeight-nHeight))/10 , 2 ,.t.)
//endif

for n := 1 to nLen

    ::aItems[n]:rcItemL1[1] += ( ::nYOffset + ::nVTMargen )
    ::aItems[n]:rcItemL1[3] += ( ::nYOffset + ::nVTMargen )

    ::aItems[n]:rcItem[1] += ( ::nYOffset + ::nVTMargen )
    ::aItems[n]:rcItem[3] += ( ::nYOffset + ::nVTMargen )

    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        ::aItems[n]:aItems[n2]:rcItem[1] += ( ::nYOffset + ::nVTMargen )
        ::aItems[n]:aItems[n2]:rcItem[3] += ( ::nYOffset + ::nVTMargen )
    next

next


return 0


*********************************************************************************************************
   METHOD VScroll( nWParam, nLParam )  CLASS TVistaMenu
*********************************************************************************************************

   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )
   local nRange      := ::oVScroll:nMax-::oVScroll:nMin

  // do case
  //    case nScrollCode == SB_LINEUP
  //
  //         ::oVScroll:GoUp()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //
  //    case nScrollCode == SB_LINEDOWN
  //
  //         ::oVScroll:GoDown()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //    case nScrollCode == SB_PAGEUP
  //
  //         ::oVScroll:PageUp()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //    case nScrollCode == SB_PAGEDOWN
  //
  //         ::oVScroll:PageDown()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //    case nScrollCode == SB_TOP
  //
  //         ::oVScroll:GoTop()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //    case nScrollCode == SB_BOTTOM
  //
  //         ::oVScroll:GoBottom()
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())
  //
  //     case nScrollCode == SB_THUMBPOSITION
  //
  //         ::oVScroll:SetPos( nPos )
  //         ::oVScroll:ThumbPos( nPos )
  //
  //     case nScrollCode == SB_THUMBTRACK
  //
  //         nPos := GetScrollInfoPos( ::hWnd, 1 )
  //         ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*nPos)
  //
  //
  //
  //    otherwise
  //         return nil
  // endcase


::GetCoors()
::Refresh()

//::oWnd:cTitle := str( nPos ) + str( ::nMaxHeight-::nHeight)

RETURN( NIL )


*********************************************************************************************************
   METHOD nRows() CLASS TVistaMenu
*********************************************************************************************************
local nRows := 0
local nLen := ::nLen()

nRows := int( nLen/::nColumns )

if nLen % 2 > 0
   nRows++
endif

return nRows

*********************************************************************************************************
   METHOD oGetOver( nRow, nCol ) CLASS TVistaMenu
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

*********************************************************************************************************
   METHOD LoadColors( nStyle ) CLASS TVistaMenu
*********************************************************************************************************

DEFAULT nStyle := 1

do case
   case nStyle == 1

      ::nClrPane        := CLR_WHITE
      ::nClrText        := RGB(  0,110,  0)
      ::nClrText2       := RGB( 60, 64,238)
      ::nClrBorderOver  := RGB(218,242,252)
      ::nClrBorderOver2 := RGB(240,250,255)
      ::nClrPaneOver    := RGB(247,252,255)
      ::nClrPaneOver2   := RGB(234,247,255)
      ::nClrTextOver1   := RGB(  0,174, 29)
      ::nClrTextOver2   := RGB( 51,153,255)


endcase

return 0


***************************************************************************
  METHOD ShowToolTip()  CLASS TVistaMenu
***************************************************************************

   local cToolTip := ""
   local nT, nL

   if ::oAbsOver != nil

      if !Empty( ::oAbsOver:cTooltip  )
         cToolTip := ::oAbsOver:cTooltip
      endif

      nT := ::oAbsOver:rcItem[3] + 20
      nL := ::nCol

      ::cToolTip := cToolTip
      ::ShowToolTip2( nT, nL )
   endif

return nil

***************************************************************************
METHOD ShowToolTip2( nRow, nCol, cToolTip ) CLASS TVistaMenu
***************************************************************************

 //  local oFont, aPos, hOldFont, nTxtWidth := 0, nTxtHeight
 //  local aToolTip, nLenToolTip
 //  local a
 //
 //
 //  DEFAULT nCol := 7, nRow := ::nHeight() + 7, ;
 //          cToolTip := ::cToolTip
 //
 //
 //
 //  if oToolTip == nil
 //
 //     if ValType( cToolTip ) == "B"
 //        cToolTip = Eval( cToolTip )
 //     endif
 //
 //     if empty( cToolTip )
 //        return nil
 //     endif
 //
 //     oToolTip := TC5ToolTip():New( 0, 0, 1, 5, Self, .f., CLR_WHITE, RGB(228,229,240), RGB(100,100,100), 2, 2 )
 //
 //     if ::oAbsOver:cTHeader != nil
 //        oToolTip:cHeader := ::oAbsOver:cTHeader
 //     else
 //        oToolTip:cHeader := ""
 //     endif
 //
 //     if ::oAbsOver:cTooltip != nil
 //        oToolTip:cBody   := ::oAbsOver:cToolTip //::cToolTipEx
 //     else
 //        oToolTip:cBody   := ""
 //     endif
 //     DEFAULT ::cMsg := ""
 //     //if empty( ::cFoot )
 //     //   if At( "Alt", ::cMsg ) != 0
 //     //      oToolTip:cFoot := ::cMsg
 //     //   endif
 //     //else
 //     //   oToolTip:cFoot := ::cFoot
 //     //endif
 //
 //     //if empty( ::cToolTipEx )
 //     //   oToolTip:cHeader := ""
 //     //   oToolTip:cBody := cToolTip
 //     //endif
 //
 //     if ::oAbsOver:cTBmpLeft != nil
 //        oToolTip:cBmpLeft := ::oAbsOver:cTBmpLeft
 //     endif
 //     //oToolTip:cBmpFoot := ::cBmpFoot
 //
 //     //if ::bToolTip != nil
 //     //   eval( ::bTooltip, self, oTooltip )
 //     //endif
 //
 //     //oToolTip:DatosExamp( nRandom(8)+1 )
 //
 //     a := oTooltip:GetSize()
 //
 //     aPos = { nRow, nCol }
 //     aPos := ClientToScreen( ::hWnd, aPos )
 //
 //     if aPos[2]+a[1] > GetSysMetrics(1)
 //        aPos[2] := GetSysMetrics  - a[1] - 20
 //     endif
 //
 //     if aPos[2]+a[1] > GetSysMetrics( 1 )
 //        aPos[2] := GetSysMetrics( 1 ) - a[1] - 20
 //     endif
 //     oToolTip:Move( aPos[1], aPos[2],a[1],a[2], .f. )
 //     oToolTip:Default()
 //     oToolTip:Show()
 //     hToolTip = oToolTip:hWnd
 //
 //  endif
 //
 //  lToolTip = .t.

return nil

***************************************************************************
  METHOD DestroyToolTip() CLASS TVistaMenu
***************************************************************************

//  if oToolTip != nil
//     oToolTip:End()
//     oToolTip = nil
//  endif
//
//  hPrvWnd = 0
//  hWndParent = 0

return nil


***************************************************************************
   METHOD CheckToolTip() CLASS TVistaMenu
***************************************************************************

//   local hWndAct
//
//   if ::cToolTip == nil .and. ::hWnd != hWndParent
//      if ::hWnd != hToolTip
//         lToolTip = .f.
//      endif
//   endif
//
//   if ::cToolTip == nil
//      if hPrvWnd != ::hWnd
//         hPrvWnd  = ::hWnd
//      endif
//      if oToolTip != nil
//         oToolTip:End()
//         oToolTip = NIL
//      endif
//      if oTmr != NIL
//         oTmr:End()
//         oTmr = NIL
//      endif
//   else
//      if hPrvWnd != ::hWnd
//         hWndParent = GetParent( ::hWnd )
//         hPrvWnd    = ::hWnd
//         if oToolTip != nil
//            oToolTip:End()
//            oToolTip = NIL
//         endif
//         if oTmr != NIL
//            oTmr:End()
//            oTmr = NIL
//         endif
//         //if lToolTip
//         //   ::ShowToolTip()
//         //else
//            hWndAct = GetActiveWindow()
//            DEFINE TIMER oTmr INTERVAL ::nToolTip ;
//               ACTION ( If( GetActiveWindow() == hWndAct,;
//                        ::ShowToolTip(),), oTmr:End(), oTmr := nil )
//               oTmr:hWndOwner = GetActiveWindow() // WndApp()
//            ACTIVATE TIMER oTmr
//         //endif
//      endif
//   endif

return nil

***************************************************************************
  METHOD oAbsoluteGetOver( nRow, nCol ) CLASS TVistaMenu
***************************************************************************
local n, n2, nLen2
local nLen  := ::nLen()

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aItems[n]:rcItem )
       return ::aItems[n]
    else
       nLen2 := ::aItems[n]:nLen()
       for n2 := 1 to nLen2
           if PtInRect( nRow, nCol, ::aItems[n]:aItems[n2]:rcItem )
              return ::aItems[n]:aItems[n2]
           endif
       next
    endif
next

return nil

***************************************************************************
    METHOD AddSample  ( ) CLASS TVistaMenu
***************************************************************************
local oItem
local oVMenu := self

oItem := oVMenu:AddItem( "Seguridad", ".\images2\image2.bmp", {||MsgInfo(time())} )

      oItem:AddItem( "Buscar actualizaciones",, {|o|MsgInfo(o:cText)} )
      oItem:AddItem( "Dejar pasar un programa a través de Firewall de Windows" )

   ::Resize()
   ::Refresh()


return 0


***************************************************************************************************
   METHOD nType( nNewValue )  CLASS TVistaMenu
***************************************************************************************************

if pcount() > 0

   ::nxType := nNewValue

   ::Resize()
   ::Refresh()

endif

return ::nxType




***************************************************************************************************
   METHOD SetProps( oList )  CLASS TVistaMenu
***************************************************************************************************
local nGroup
local o := self
// ::aProperties := { "cCaption"         ,;
//                      "aDotsActives"   ,;
//                      "aRect"          ,;
//                      "lActive"        ,;
//                      "lBorder"        ,;
//                      "lCanSize"       ,;
//                      "lCanMove"       ,;
//                      "lClientEdge"    ,;
//                      "lStaticEdge"    ,;
//                      "lStaticFrame"   ,;
//                      "lSunken"        ,;
//                      "lEditable"      ,;
//                      "lFlat"          ,;
//                      "lModalFrame"    ,;
//                      "lMultiline"     ,;
//                      "lVisible"       ,;
//                      "nAlign"         ,;
//                      "nClrBorder"     ,;
//                      "nClrPane"       ,;
//                      "nClrText"       ,;
//                      "nOption"        ,;
//                      "oFont"          ,;
//                      "xMaxHeight"     ,;
//                      "xMaxWidth"      ,;
//                      "xMinHeight"     ,;
//                      "xMinWidth"      }

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lBorder","Border", "L",nGroup )
oList:AddItem( "nColumns","Columns", ,nGroup )
oList:AddItem( "lCanMove","Can move", ,nGroup )
oList:AddItem( "lCanSize","Can size", ,nGroup )
oList:AddItem( "lBorder" ,"Border", "L" ,nGroup )
oList:AddItem( "nClrText","Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane","Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )
oList:AddItem( "nType"   ,"Type", ,nGroup,,, )


nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0




*********************************************************************************************************
static function Linea( hDC, nTop, nLeft, nBottom, nRight, nColor, nWPen, nStyle )
*********************************************************************************************************

local hPen, hOldPen

DEFAULT nWPen  := 1
DEFAULT nColor := 0
DEFAULT nStyle := PS_SOLID

hPen := CreatePen( nStyle, nWPen, nColor )

hOldPen := SelectObject( hDC, hPen )
MoveTo( hDC, nLeft, nTop )
LineTo( hDC, nRight, nBottom )

SelectObject( hDC, hOldPen )

DeleteObject( hPen )

return 0


******************************************************************************************************
  function DrawMText( hDC, cText, rc, lDraw )
******************************************************************************************************
local nWidth   := rc[4]-rc[2]
local nEn
local cPalabra
local nLeft    := rc[2]
local nTop     := rc[1]
local cLinea   := ""
local sz
local nCount   := 0

DEFAULT lDraw := .T.

cText += " "
do while ( ( nEn := at( " ", cText )) != 0 )

   do while substr( cText, ++nEn, 1 ) == " " ; enddo

   cPalabra := left( cText, nEn-1 )

   nCount++

   sz = GetSizeText( hDC, cLinea + rtrim(cPalabra) )

   if sz[1] < nWidth

      cLinea += cPalabra

   else

      if lDraw
         ExtTextOut( hDC, nTop, nLeft, {nTop, rc[2], nTop+sz[2],rc[4]}, cLinea, 4 )
      endif

      cLinea := cPalabra

      if nCount > 1
         nTop += sz[2]
      endif

   endif

   cText := substr( cText, nEn )
enddo

if lDraw; ExtTextOut( hDC, nTop, nLeft, {nTop, rc[2], nTop+sz[2],rc[4]}, cLinea, 4 ) ; endif

return (nTop + sz[2])-rc[1]




#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

void FillSolidRect( HDC hDC, RECT *rct, COLORREF nColor )
{
    nColor = SetBkColor( hDC , nColor );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

}


HB_FUNC( C5SETSCROLLINFO )
{
   SCROLLINFO si;
   si.cbSize = sizeof( si );
   si.fMask  = hb_parni( 4 );
   si.nPage  = hb_parni( 3 );

   hb_retl( SetScrollInfo( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), &si, hb_parl( 5 ) ) );
}

HB_FUNC( INTERSECTRECT )
{

   RECT rc;
   RECT rc1;
   RECT rc2;

  rc.top    = 0;
  rc.left   = 0;
  rc.bottom = 0;
  rc.right  = 0;

  rc1.top    = hb_parvni(1,1);
  rc1.left   = hb_parvni(1,2);
  rc1.bottom = hb_parvni(1,3);
  rc1.right  = hb_parvni(1,4);

  rc2.top    = hb_parvni(2,1);
  rc2.left   = hb_parvni(2,2);
  rc2.bottom = hb_parvni(2,3);
  rc2.right  = hb_parvni(2,4);

  hb_retl( IntersectRect( &rc, &rc1, &rc2 ));
}

HB_FUNC( BOX )
   {
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen;
      HPEN hOldPen;
      RECT rc;

      if( hb_pcount() > 3 )
      {
         hPen = CreatePen( hb_parni(4),1, (COLORREF)hb_parnl( 3 ));
      }
      else
      {
         hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 3 ));
      }
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3)-1;
      rc.right  = hb_parvni( 2, 4)-1;
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, rc.left, rc.top, NULL );
      LineTo( hDC, rc.right, rc.top );
      LineTo( hDC, rc.right, rc.bottom );
      LineTo( hDC, rc.left, rc.bottom );
      LineTo( hDC, rc.left, rc.top );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
   }

HB_FUNC( ROUNDBOX )

{
   HBRUSH hBrush = (HBRUSH) GetStockObject( 5 );
   HBRUSH hOldBrush = (HBRUSH) SelectObject( (HDC) hb_parnl( 1 ), hBrush );
   HPEN hPen = CreatePen( PS_SOLID, hb_parni( 9 ), (COLORREF)hb_parnl( 8 ));
   HPEN hOldPen = (HPEN) SelectObject( (HDC) hb_parnl( 1 ), hPen );

   hb_retl( RoundRect( ( HDC ) hb_parnl( 1 ),
                               hb_parni( 2 ),
                               hb_parni( 3 ),
                               hb_parni( 4 ),
                               hb_parni( 5 ),
                               hb_parni( 6 ),
                               hb_parni( 7 ) ) );

   SelectObject( (HDC) hb_parnl( 1 ), hOldBrush );
   SelectObject( (HDC) hb_parnl( 1 ), hOldPen );
   DeleteObject( hPen );

}

HB_FUNC( GETSIZETEXT )
{
   HDC hDC = ( HDC ) hb_parnl( 1 );
   SIZE sz;
   GetTextExtentPoint32( hDC, hb_parc( 2 ), hb_parclen( 2 ), &sz );
   hb_reta(2);
   hb_storvni( sz.cx, -1, 1 );
   hb_storvni( sz.cy, -1, 2 );
}

HB_FUNC( CREATEFONTUNDERLINE )
{

   LOGFONT lf;
   TEXTMETRIC tm;
   HFONT hFont    = ( HFONT ) hb_parnl( 1 );
   HWND hWnd      = GetActiveWindow();
   HDC hDC        = GetDC( hWnd );
   HFONT hOldFont = ( HFONT ) SelectObject( hDC, hFont );
   char cName[ 80 ];

   ZeroMemory( &lf,sizeof( LOGFONT ) );

   GetTextMetrics( hDC, &tm );
   GetTextFace( hDC, sizeof( cName ), cName );
   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );


   lf.lfHeight         = tm.tmHeight;
   lf.lfWidth          = tm.tmAveCharWidth;
   lf.lfWeight         = tm.tmWeight;
   lf.lfItalic         = ( BYTE ) tm.tmItalic;
   lf.lfUnderline      = ( BYTE ) TRUE ;
   lf.lfStrikeOut      = ( BYTE ) tm.tmStruckOut;
   lf.lfCharSet        = ( BYTE ) tm.tmCharSet;
   strcpy( ( char * ) &( lf.lfFaceName ), cName );

   hb_retnl( (LONG) CreateFontIndirect( &lf ) );
}

HB_FUNC ( SETBRUSHORG )
{
    HDC hDC  = (HDC) hb_parnl( 1 );
    UnrealizeObject( ( HGDIOBJ ) hb_parnl( 2 ) );
    SetBrushOrgEx( hDC, hb_parni( 3 ), hb_parni( 4 ), NULL );
}

void VerticalGradient(HDC hDC, LPRECT lpRect, COLORREF sColor, COLORREF eColor, BOOL bGamma, double gamma)
{
        // Gradient params
        int width = lpRect->right - lpRect->left; // - 1;
        int height = lpRect->bottom - lpRect->top; // - 1;

        // Draw gradient

        double percent;
        unsigned char red, green, blue;
        COLORREF color;
        RECT rect;
        int i;
        for (i=0; i<height-1; i++)
        {
                // Gradient color percent
                percent = 1 - (double)i / (double)(height-2);

                // Gradient color
                red = (unsigned char)(GetRValue(sColor)*percent) + (unsigned char)(GetRValue(eColor)*(1-percent));
                green = (unsigned char)(GetGValue(sColor)*percent) + (unsigned char)(GetGValue(eColor)*(1-percent));
                blue = (unsigned char)(GetBValue(sColor)*percent) + (unsigned char)(GetBValue(eColor)*(1-percent));
                if (bGamma)
                {
                        red = (unsigned char)(pow((double)red/255.0, gamma) * 255);
                        green = (unsigned char)(pow((double)green/255.0, gamma) * 255);
                        blue = (unsigned char)(pow((double)blue/255.0, gamma) * 255);
                }
                color = RGB(red, green, blue);

                // Gradient
                rect.left = lpRect->left; // + 1;
                rect.top = lpRect->top + i + 1;
                rect.right = lpRect->right; // - 1;
                rect.bottom = rect.top + 1;
                FillSolidRect( hDC, &rect, color );
        }
}


HB_FUNC( VERTICALGRADIENT )
{
   RECT rct;
   rct.top    = hb_parvni( 2, 1 );
   rct.left   = hb_parvni( 2, 2 );
   rct.bottom = hb_parvni( 2, 3 );
   rct.right  = hb_parvni( 2, 4 );

   VerticalGradient((HDC) hb_parnl( 1 ), &rct, (COLORREF) hb_parnl( 3 ), (COLORREF) hb_parnl( 4 ), hb_parl( 5 ), hb_parnl( 6 ));
   hb_ret();
}
void DrawGradientFill( HDC hDC, RECT rct, COLORREF crStart, COLORREF crEnd, int nSegments, int bVertical )
{
	// Get the starting RGB values and calculate the incremental
	// changes to be applied.

	COLORREF cr;
	int nR = GetRValue(crStart);
	int nG = GetGValue(crStart);
	int nB = GetBValue(crStart);

	int neB = GetBValue(crEnd);
	int neG = GetGValue(crEnd);
	int neR = GetRValue(crEnd);


	int nDiffR = (neR - nR);
	int nDiffG = (neG - nG);
	int nDiffB = (neB - nB);

	int ndR = 256 * (nDiffR) / (max(nSegments,1));
	int ndG = 256 * (nDiffG) / (max(nSegments,1));
	int ndB = 256 * (nDiffB) / (max(nSegments,1));

	int nCX = (rct.right-rct.left) / max(nSegments,1);
	int nCY = (rct.bottom-rct.top) / max(nSegments,1);
	int nTop = rct.top;
	int nBottom = rct.bottom;
	int nLeft = rct.left;
	int nRight = rct.right;

        HPEN hPen;
        HPEN hOldPen;
        HBRUSH hBrush;
        HBRUSH pbrOld;

        int i;

	if(nSegments > ( rct.right - rct.left ) )
		nSegments = ( rct.right - rct.left );


	nR *= 256;
	nG *= 256;
	nB *= 256;

	hPen    = CreatePen( PS_NULL, 1, 0 );
	hOldPen = (HPEN) SelectObject( hDC, hPen );

	for (i = 0; i < nSegments; i++, nR += ndR, nG += ndG, nB += ndB)
	{
		// Use special code for the last segment to avoid any problems
		// with integer division.

		if (i == (nSegments - 1))
		{
			nRight  = rct.right;
			nBottom = rct.bottom;
		}
		else
		{
			nBottom = nTop + nCY;
			nRight = nLeft + nCX;
		}

		cr = RGB(nR / 256, nG / 256, nB / 256);

		{

			hBrush = CreateSolidBrush( cr );
			pbrOld = (HBRUSH) SelectObject( hDC, hBrush );

			if( bVertical )
			   Rectangle(hDC, rct.left, nTop, rct.right, nBottom + 1 );
			else
			   Rectangle(hDC, nLeft, rct.top, nRight + 1, rct.bottom);

			(HBRUSH) SelectObject( hDC, pbrOld );
			DeleteObject( hBrush );
		}

		// Reset the left side of the drawing rectangle.

		nLeft = nRight;
		nTop = nBottom;
	}

	(HPEN) SelectObject( hDC, hOldPen );
	DeleteObject( hPen );
}



HB_FUNC( HGRADIENTFILL )
{
        RECT rct;

        rct.top    = hb_parvni( 2, 1 );
        rct.left   = hb_parvni( 2, 2 );
        rct.bottom = hb_parvni( 2, 3 );
        rct.right  = hb_parvni( 2, 4 );

        DrawGradientFill( ( HDC ) hb_parnl( 1 ) , rct, hb_parnl( 3 ), hb_parnl( 4 ), hb_parni(5), FALSE);


}

HB_FUNC( C5CREATERECTRGN )
{
   hb_retnl( (long) CreateRectRgn( hb_parni( 2 ),hb_parni( 1 ),hb_parni( 4 ),hb_parni( 3 )));
}
HB_FUNC( C5SELECTCLIPRGN )
{
   hb_retni( SelectClipRgn( (HDC) hb_parnl( 1 ), (HRGN) hb_parnl( 2 ) ));
}

#pragma ENDDUMP


CLASS TBrushEx

      DATA   hBrush, hBitmap
      METHOD New( nColor, nColor2, lVGrad ) CONSTRUCTOR
      METHOD End() INLINE DeleteObject(::hBrush),DeleteObject(::hBitmap)

ENDCLASS

**************************************************************************
  METHOD New( nWidth, nHeight, nColor, nColor2, lVGrad ) CLASS TBrushEx
**************************************************************************

    ::hBitmap := CreaBitmapEx(nWidth, nHeight, nColor, nColor2, lVGrad )
    ::hBrush = If( ::hBitmap != 0, CreatePatternBrush( ::hBitmap ), )

return Self


////////////////////////////////////////////////////////////////////
  function CreaBitmapEx( nWidth, nHeight, nColor, nColor2, lVGrad )
////////////////////////////////////////////////////////////////////
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local hBmpMem := CreateCompatibleBitmap( hDC, nWidth, nHeight )
local hOldBmp := SelectObject( hDCMem, hBmpMem )
local rc      := {0,0,nHeight,nWidth}

if lVGrad == nil; lVGrad := .t.; endif
if nColor2 == nil; nColor2 := nColor; endif

if lVGrad
   VerticalGradient( hDCMem, rc, nColor, nColor2 )
else
   HGradientFill( hDCMem, {rc[1],rc[2],rc[3]+2,rc[4]}, nColor, nColor2, 60 )
endif

SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )
DeleteDC( hDC )

return hBmpMem




