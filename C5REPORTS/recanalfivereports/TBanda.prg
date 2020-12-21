#include "fivewin.ch"
#include "Informe.ch"



CLASS TBanda FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA nOldRow
      DATA nOldCol
      DATA nOldRow2
      DATA nOldCol2
      DATA nDeltaTop
      DATA nDeltaLeft
      DATA aOldRect
      DATA lIsOver
      DATA iRop
      DATA hPen, hOldPen
      DATA lxOpen
      DATA hMinus, hPlus
      DATA cName
      DATA nState
      DATA aBtn
      DATA nLastHeight
      DATA aItems
      DATA aDots
      DATA aRectTitle
      DATA oFocused
      DATA aSelecteds
      DATA hBmpBrush

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cName ) CONSTRUCTOR

      METHOD Display()   INLINE ::BeginPaint(), ::Paint(), ::EndPaint(),0
      METHOD Paint()
      METHOD Destroy()   INLINE DeleteObject( ::hMinus ), DeleteObject( ::hPlus ), ::super:Destroy()

      METHOD LButtonDown ( nRow, nCol, nKeyFlags )
      METHOD MouseMove   ( nRow, nCol, nKeyFlags )
      METHOD LButtonUp   ( nRow, nCol, nKeyFlags )
      METHOD RButtonDown ( nRow, nCol, nKeyFlags )

      METHOD GotFocus( hCtlLost )
      METHOD IsOverDot( nRow, nCol, nDot )
      METHOD GetFocused()
      METHOD GetItem( nRow, nCol )
      METHOD SetProperties()

      METHOD nHeight( nVal ) SETGET
      METHOD lOpen( lVal ) SETGET
      METHOD SetGrid( nGrid )
      METHOD FindSelection( aRect )
      METHOD IsInSelected( oItem )
      METHOD KeyDown( nKey, nFlags )
      METHOD KeyChar( nKey, nFlags )


ENDCLASS


******************************************************************************************************************************************************
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cName ) CLASS TBanda
******************************************************************************************************************************************************

   ::nTop        := nTop
   ::nLeft       := nLeft
   ::nBottom     := nTop + nHeight
   ::nRight      := nLeft + nWidth
   ::oWnd        := oWnd
   ::aOldRect    := {}
   ::lCaptured   := .f.
   ::lxOpen      := .t.
   ::cName       := cName
   ::nState      := SELECCION
   ::aBtn        := {0,0,0,0}
   ::nLastHeight := ::nBottom - ::nTop
   ::aItems      := {}
   ::aDots       := {}
   ::aRectTitle  := {}
   ::aSelecteds  := {}

   ::nStyle      := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_CLIPSIBLINGS, WS_CLIPCHILDREN  )
   ::nId         := ::GetNewId()

   ::SetGrid( ::oWnd:nGrid )
   ::Register(nOr( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif

   ::hMinus := LoadBitmap( GetResources(), "minus" )
   ::hPlus  := LoadBitmap( GetResources(), "plus"  )

   aadd( ::oWnd:aBandas, self )



return self

*******************************************************************************************************
  METHOD SetProperties() CLASS TBanda
*******************************************************************************************************
Local nGroup, oInsp := Inspector()

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Posición" )

     oInsp:AddItem( "cName",   "Nombre", ::cName,,nGroup )
     oInsp:AddItem( "nHeight", "Altura", ::nHeight,,nGroup )
     oInsp:AddItem( "lOpen",   "Abierta", ::lOpen,,nGroup )

     oInsp:Refresh()

return nil




*******************************************************************************************************************
      METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TBanda
*******************************************************************************************************************

  local nSeg
  local nEn, n, nLen
  local nDot := 0
  local oItem

  SetFocus( ::hWnd )

  ::nOldRow  := nRow
  ::nOldCol  := nCol

  nLen := len( ::aSelecteds )

  ::oWnd:oWnd:cTitle := str( ::nState )

  if ! ::lCaptured

     ::lCaptured := .t.
     ::Capture()

     oItem       := ::GetItem( nRow, nCol )
     ::oFocused := ::GetFocused()

     if oItem != nil

        if ::IsInSelected( oItem )

           if nLen > 0

              ::nState := MULTIPLE_MOVIENDO_ITEM

              for n := 1 to nLen
                  ::aSelecteds[n]:SetOldPos()
              next

              ::nDeltaTop  := nRow - oItem:nTop
              ::nDeltaLeft := nCol - oItem:nLeft
              ::hDC        := ::GetDC()
              ::iRop    := SetRop2     ( ::hDC, R2_XORPEN )
              ::hPen    := CreatePen   ( PS_SOLID, 1, CLR_HGRAY )
              ::hOldPen := SelectObject( ::hDC, ::hPen )

              return 0

            endif

        else

           if ::oFocused != nil //.and. ::oFocused:nId != oItem:nID

              ::oWnd:ResetFocus()
              oItem:SetFocus( .t. )
              oItem:SetProperties()
              ::oFocused := oItem
              ::Refresh()
              SysRefresh()

           endif

        endif
     endif

     if ::IsOverDot( nRow, nCol, @nDot )

        // moviendo multiple selección
        if ::oFocused != nil

           do case
              case nDot == 1
                   ::nState := RESIZING_ITEM_NW
              case nDot == 2
                   ::nState := RESIZING_ITEM_N
              case nDot == 3
                   ::nState := RESIZING_ITEM_NE
              case nDot == 4
                   ::nState := RESIZING_ITEM_E
              case nDot == 5
                   ::nState := RESIZING_ITEM_SE
              case nDot == 6
                   ::nState := RESIZING_ITEM_S
              case nDot == 7
                   ::nState := RESIZING_ITEM_SW
              case nDot == 8
                   ::nState := RESIZING_ITEM_W
              case nDot == 9
                   ::nState := MOVIENDO_ITEM
           endcase

           ::nOldRow    := ::oFocused:nTop
           ::nOldCol    := ::oFocused:nLeft
           ::nOldRow2   := ::oFocused:nBottom
           ::nOldCol2   := ::oFocused:nRight

           ::nDeltaTop  := nRow - ::oFocused:nTop
           ::nDeltaLeft := nCol - ::oFocused:nLeft

           ::hDC        := ::GetDC()

        endif



     else

        if nRow >= ::nHeight - 5 .and. nRow <= ::nHeight

           ::nOldRow  := nRow
           ::nOldCol  := 0
           ::nState   := RESIZINGBOTTOM
           ::hDC      := GetDC( 0 )

        else

           if nCol >= ::nWidth - 5 .and. nCol <= ::nWidth

              ::nOldRow := nRow
              ::nOldCol := 0
              ::hDC     := GetDC( 0 )
              ::nState  := RESIZINGRIGHT

           else

              ::GetDC()

           endif

        endif

     endif

     ::iRop    := SetRop2     ( ::hDC, R2_XORPEN )
     ::hPen    := CreatePen   ( PS_SOLID, 1, CLR_HGRAY )
     ::hOldPen := SelectObject( ::hDC, ::hPen )

  endif



return 0


****************************************************************************************************
  METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TBanda
****************************************************************************************************
local aRect, n
local lCtrl   := GetKeyState( VK_CONTROL )
local lShift  := GetKeyState( VK_SHIFT )
local aPoint
local iRop
local aClient := GetClientRect(::oWnd:oWnd:hWnd)
local nDot    := 0
local nLen    := len( ::aSelecteds )
local nDRow
local nDCol
local oItem

if ::lCaptured

  ::oWnd:oWnd:cTitle := str( ::nState )

   If nRow > 32768
      nRow -= 65536
   Endif

   If nCol > 32768
      nCol -= 65536
   Endif

   if ::nState != SELECCION

      if ::nState == MULTIPLE_MOVIENDO_ITEM

         if !empty( ::aSelecteds[1]:aOldRect )

            for n := 1 to nLen
                ::aSelecteds[n]:PaintSel( ::hDC, ::aSelecteds[n]:aOldRect )
            next

         endif

         nDRow := ::nOldRow - nRow
         nDCol := ::nOldCol - nCol

         for n := 1 to nLen

             oItem := ::aSelecteds[n]

             aRect := { oItem:aOldPos[1]-nDRow, oItem:aOldPos[2]-nDCol, oItem:aOldPos[1]+oItem:nHeight-nDRow, oItem:aOldPos[2]+oItem:nWidth-nDCol }

             oItem:PaintSel( ::hDC, aRect )

             oItem:aOldRect := aRect

         next

      else

         if !empty( ::aOldRect )
            MoveTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
            LineTo( ::hDC, ::aOldRect[4], ::aOldRect[1] )
            LineTo( ::hDC, ::aOldRect[4], ::aOldRect[3] )
            LineTo( ::hDC, ::aOldRect[2], ::aOldRect[3] )
            LineTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
         endif

         do case
            case ::nState == RESIZING_ITEM_NW

                 aRect := { nRow , nCol, ::nOldRow2, ::nOldCol2 }

            case ::nState == RESIZING_ITEM_N

                 aRect := { nRow , ::nOldCol, ::nOldRow2, ::nOldCol2 }

            case ::nState == RESIZING_ITEM_NE

                 aRect := { nRow , ::nOldCol, ::nOldRow2, nCol }

            case ::nState == RESIZING_ITEM_E

                 aRect := { ::nOldRow , ::nOldCol, ::nOldRow2, nCol }

            case ::nState == RESIZING_ITEM_SE

                 aRect := { ::nOldRow , ::nOldCol, nRow, nCol }

            case ::nState == RESIZING_ITEM_S

                 aRect := { ::nOldRow , ::nOldCol, nRow, ::nOldCol2 }

            case ::nState == RESIZING_ITEM_SW

                 aRect := { ::nOldRow , nCol, nRow, ::nOldCol2 }

            case ::nState == RESIZING_ITEM_W

                 aRect := { ::nOldRow , nCol, ::nOldRow2, ::nOldCol2 }

            case ::nState == MOVIENDO_ITEM

                 aRect := { nRow - ::nDeltaTop, nCol-::nDeltaLeft, nRow - ::nDeltaTop + ::oFocused:nHeight, nCol-::nDeltaLeft+ ::oFocused:nWidth }

            case ::nState == RESIZINGBOTTOM

                 aPoint := {nRow+::nTop, 0}
                 aPoint := ClientToScreen( ::oWnd:hWnd, aPoint )
                 aRect := { aPoint[1], aPoint[2],    aPoint[1]+1 , aPoint[2] + +( aClient[4]-aClient[2]) }

            case ::nState == RESIZINGRIGHT

                 aPoint := {24, nCol+::nLeft }
                 aPoint := ClientToScreen( ::oWnd:hWnd, aPoint )
                 aRect := { aPoint[1], aPoint[2],   aPoint[1]+( aClient[3]-aClient[1])-25 , aPoint[2] + 1 }

            otherwise

                 aRect := { ::nOldRow, ::nOldCol,   nRow , nCol }

         endcase

         MoveTo( ::hDC, aRect[2], aRect[1] )
         LineTo( ::hDC, aRect[4], aRect[1] )
         LineTo( ::hDC, aRect[4], aRect[3] )
         LineTo( ::hDC, aRect[2], aRect[3] )
         LineTo( ::hDC, aRect[2], aRect[1] )

         ::aOldRect := aRect

      endif

   else

      // Seleccionado
      if !empty( ::aOldRect )
         MoveTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
         LineTo( ::hDC, ::aOldRect[4], ::aOldRect[1] )
         LineTo( ::hDC, ::aOldRect[4], ::aOldRect[3] )
         LineTo( ::hDC, ::aOldRect[2], ::aOldRect[3] )
         LineTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
      endif

      aRect := { ::nOldRow, ::nOldCol, nRow , nCol  }

      MoveTo( ::hDC, aRect[2], aRect[1] )
      LineTo( ::hDC, aRect[4], aRect[1] )
      LineTo( ::hDC, aRect[4], aRect[3] )
      LineTo( ::hDC, aRect[2], aRect[3] )
      LineTo( ::hDC, aRect[2], aRect[1] )

      ::aOldRect := aRect

   endif

else

   if nRow >= ::nHeight - 5 .and. nRow <= ::nHeight
      CursorNS()
   else
      if nCol >= ::nWidth - 5 .and. nCol <= ::nWidth
         CursorWE()
      else
         if ::IsOverDot( nRow, nCol, @nDot )
            do case
               case nDot == 1
                    SetCursor( LoadCursor( 0, IDC_SIZENWSE ))
               case nDot == 2
                    CursorNS()
               case nDot == 3
                    SetCursor( LoadCursor( 0, IDC_SIZENESW ))
               case nDot == 4
                    CursorWE()
               case nDot == 5
                    SetCursor( LoadCursor( 0, IDC_SIZENWSE ))
               case nDot == 6
                    CursorNS()
               case nDot == 7
                    SetCursor( LoadCursor( 0, IDC_SIZENESW ))
               case nDot == 8
                    CursorWE()
               case nDot == 9
                    SetCursor( LoadCursor( 0, IDC_SIZEALL ))

            endcase
         else
            CursorArrow()
         endif
      endif
   endif

endif

return 1

*******************************************************************************
  METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TBanda
*******************************************************************************

   local n, nAux
   local nSeg
   local iRop
   local nWidth,nHeight
   local aRect := {}
   local aPoint := {}
   local aItems := {}
   local oItem
   local nTop, nLeft, nBottom, nRight
   local nLen := len(::aSelecteds)
   local nDRow, nDCol

   if ::lCaptured

      ::lCaptured = .f.
      ReleaseCapture()

      if ::nState == MULTIPLE_MOVIENDO_ITEM

         if !empty( ::aSelecteds[1]:aOldRect )

            for n := 1 to nLen
                ::aSelecteds[n]:PaintSel( ::hDC, ::aSelecteds[n]:aOldRect )
            next

         endif

         nDRow := ::nOldRow - nRow
         nDCol := ::nOldCol - nCol

         for n := 1 to nLen

             oItem := ::aSelecteds[n]

             aRect := { oItem:aOldPos[1]-nDRow, oItem:aOldPos[2]-nDCol, oItem:aOldPos[1]+oItem:nHeight-nDRow, oItem:aOldPos[2]+oItem:nWidth-nDCol }

             oItem:MoveTo( aRect[1], aRect[2] )

             oItem:aOldRect := {}

         next
         ::Refresh()

      else


         // borramos lo último dibujado
         if !empty( ::aOldRect )
             MoveTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
             LineTo( ::hDC, ::aOldRect[4], ::aOldRect[1] )
             LineTo( ::hDC, ::aOldRect[4], ::aOldRect[3] )
             LineTo( ::hDC, ::aOldRect[2], ::aOldRect[3] )
             LineTo( ::hDC, ::aOldRect[2], ::aOldRect[1] )
             aRect := ::aOldRect
         endif

         SelectObject( ::hDC, ::hOldPen )
         DeleteObject( ::hPen )
         SetRop2( ::hDC, ::iRop )

         do case
            case ::nState == MOVIENDO_ITEM

                 ::ReleaseDC()

                 nTop  := nRow - ::nDeltaTop
                 nLeft :=  nCol-::nDeltaLeft
                 if ::oWnd:lGrid
                    nTop    -= nTop    % ::oWnd:nGrid
                    nLeft   -= nLeft   % ::oWnd:nGrid
                 endif
                 ::oFocused:MoveTo( nTop, nLeft )

                 ::Refresh()

            case ::nState == RESIZINGBOTTOM
                 ReleaseDC(0, ::hDC)
                 nHeight := nRow //::nHeight() + (nRow -::nOldRow)
                 if nHeight + ::nHeight() > 0
                    ::nHeight( nHeight )
                    ::oWnd:ResizeHeights()
                 endif

            case ::nState == RESIZINGRIGHT
                 nWidth := nCol
                 if nWidth + ::nWidth() > 0
                    ::oWnd:nLastWidth := nWidth
                    ::oWnd:ResizeWidths()
                 endif

            case ::nState >= RESIZING_ITEM_NW .and. ::nState <= RESIZING_ITEM_W

                 ::ReleaseDC()

                 if empty( ::aOldRect )
                    ::aOldRect := {}
                    ::nState := 0
                    ResetBar()
                    return nil
                 endif

                 nTop    := ::aOldRect[1]
                 nLeft   := ::aOldRect[2]
                 nBottom := ::aOldRect[3]
                 nRight  := ::aOldRect[4]

                 if ::oWnd:lGrid
                    nTop     -= nTop     % ::oWnd:nGrid
                    nLeft    -= nLeft    % ::oWnd:nGrid
                    nBottom  -= nBottom  % ::oWnd:nGrid
                    nRight   -= nRight   % ::oWnd:nGrid
                 endif

                 ::oFocused:MoveTo( nTop, nLeft, nBottom, nRight )

                 ::Refresh()

            otherwise

               ::ReleaseDC()

               nLen := len( ::aSelecteds )
               if nLen > 0
                  for n := 1 to nLen
                      ::aSelecteds[n]:Select(.f.)
                  next
                  ::Refresh()
                  SysRefresh()
                  asize( ::aSelecteds, 0 )
               endif

               if !empty( aRect )

                  if aRect[1] > aRect[3]
                     nAux := aRect[1]
                     aRect[1] := aRect[3]
                     aRect[3] := nAux
                  endif
                  if aRect[2] > aRect[4]
                     nAux := aRect[2]
                     aRect[2] := aRect[4]
                     aRect[4] := nAux
                  endif

                  if aRect[3]-aRect[1] <= 3 .and. aRect[4]-aRect[2] <= 3
                     return .f.
                  endif


                  if ::nState == SELECCION .and. nActivo == ARROW

                     ::aSelecteds := ::FindSelection( aRect )

                     nLen := len( ::aSelecteds )

                     for n := 1 to nLen
                         ::aSelecteds[n]:Select(.t.)
                     next

                     if nLen > 0
                        ::Refresh()
                     endif

                  else


                     do case
                        case nActivo == TEXTO
                             oItem := TRptTextItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )
                        case nActivo == LINE
                             oItem := TRptLineItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )
                        case nActivo == BOX
                             oItem := TRptBoxItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )
                        case nActivo == IMAGE
                             oItem := TRptImageItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )
                        case nActivo == BASE
                             oItem := TRptDataBaseItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )
                        case nActivo == FIELD
                             oItem := TRptFieldItem():New( aRect[1],aRect[2],aRect[3],aRect[4], self )

                     endcase

                     if oItem != nil
                        ::oWnd:SetFocused( self, oItem )
                        oItem:SetProperties()
                     endif

                  endif

               else

                  ::SetProperties()

               endif



         endcase

      endif
      ::aOldRect := {}
      ::nState := 0

   endif
   ResetBar()


return 1


*******************************************************************************
  METHOD RButtonDown ( nRow, nCol, nKeyFlags ) CLASS TBanda
*******************************************************************************
local oMenu
local lDisable

MENU oMenu POPUP
     MENUITEM "Insertar"
     MENU
        MENUITEM "Grupo Cabecera/Pie"
        MENUITEM "Informe Cabecera/Pie"
     ENDMENU
     MENUITEM "Borrar Sección"
     SEPARATOR
     MENUITEM "Cortar" DISABLED
     MENUITEM "Copiar" DISABLED
     MENUITEM "Pegar"  DISABLED
     MENUITEM "Traer al frente" DISABLED
     MENUITEM "Llevar al fondo" DISABLED
     MENUITEM "Alinear" DISABLED
     MENU
        MENUITEM "Izquierda" DISABLED
        MENUITEM "Centro"    DISABLED
        MENUITEM "Dercha"    DISABLED
        MENUITEM "Arriba"    DISABLED
        MENUITEM "En medio"  DISABLED
        MENUITEM "Abajo"     DISABLED
        MENUITEM "Al grid"   DISABLED
        MENUITEM "Centrar en sección"   DISABLED
     ENDMENU
     MENUITEM "Tamaño"  DISABLED
     MENU
        MENUITEM "Mismo ancho"   DISABLED
        MENUITEM "Mismo alto"    DISABLED
        MENUITEM "Mismo tamaño"  DISABLED
     ENDMENU

ENDMENU

ACTIVATE MENU oMenu OF Self AT nRow, nCol


return 1

*******************************************************************************
  METHOD Paint() CLASS TBanda
*******************************************************************************
local nCol, nRow
local hPen, hOldPen
local n, nLen

nLen := len( ::aItems )

for n := 1 to nLen
    ::aItems[n]:Paint( ::hDC )
next



return nil

*******************************************************************************
  METHOD GotFocus( hCtlLost ) CLASS TBanda
*******************************************************************************
local n
local nLen := len( ::oWnd:aControls )

//::oWnd:Refresh()

return ::super:GotFocus()


*******************************************************************************
  METHOD lOpen( lVal ) CLASS TBanda
*******************************************************************************

if pcount() > 0

   ::lxOpen := lVal

   if ::lxOpen
      ::nHeight( ::nLastHeight )
   else
      ::nLastHeight := ::nHeight
      ::nHeight( 0 )
   endif

endif

return ::lxOpen



*******************************************************************************
  METHOD IsOverDot( nRow, nCol, nDot ) CLASS TBanda
*******************************************************************************
local n, nLen

nDot := 0
nLen := len( ::aDots )
for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aDots[n] )
       nDot := n
       return .t.
    endif
next

return .f.


*******************************************************************************
  METHOD GetFocused() CLASS TBanda
*******************************************************************************
local n
local nLen := len( ::aItems )

for n := 1 to nLen
    if ::aItems[n]:lFocused
       return ::aItems[n]
    endif
next

return nil

*******************************************************************************
  METHOD GetItem( nRow, nCol ) CLASS TBanda
*******************************************************************************
local n, nLen

nLen := len( ::aItems )
for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aItems[n]:GetRect() )
       return ::aItems[n]
    endif
next

return nil


*******************************************************************************
  METHOD nHeight( nNewHeight ) CLASS TBanda
*******************************************************************************
local nAux

   if PCount() > 0
      nAux := WndHeight( ::hWnd, nNewHeight )
      ::oWnd:ResizeHeights()
      return nAux
   else
      if ! Empty( ::hWnd )
         return WndHeight( ::hWnd )
      else
         return ::nBottom - ::nTop + 1
      endif
   endif

return nil

************************************************************************************************************************
   METHOD SetGrid( nGrid ) CLASS TBanda
************************************************************************************************************************
local hDC, hDCMem, hOldBmp
local n := max( nGrid, 2 )

if ::hBmpBrush != nil
   DeleteObject( ::hBmpBrush )
endif

hDC         := ::GetDC()
hDCMem      := CreateCompatibleDC( hDC )
::hBmpBrush := CreateCompatibleBitmap( hDC, n, n )
hOldBmp     := SelectObject( hDCMem, ::hBmpBrush )

FillSolidRect( hDCMem, {0, 0, n, n }, ::nClrPane, ::nClrPane )

if nGrid != 0
   SetPixel( hDCMem, 0, 0, 0 )
endif
SelectObject( hDCMem, hOldBmp )

DeleteDC( hDCMem )
::ReleaseDC()

*::oBrush:End()

DEFINE BRUSH ::oBrush STYLE "NULL"
::oBrush:hBrush := CreatePatternBrush( ::hBmpBrush )

::Refresh()


return nil

*******************************************************************************
  METHOD FindSelection( aRect ) CLASS TBanda
*******************************************************************************
local n
local nLen := len( ::aItems )
local aItems := {}

for n := 1 to nLen
    if IntersectRect( ::aItems[n]:GetRect(), aRect )
       aadd( aItems, ::aItems[n] )
    endif
next

return aItems

*******************************************************************************
  METHOD IsInSelected( oItem ) CLASS TBanda
*******************************************************************************
local n
local lIs := .f.
local nLen := len( ::aSelecteds )

for n := 1 to nLen
    if ::aSelecteds[n]:nId == oItem:nID
       return .t.
    endif
next

return lIs


/***********************************************************************************************/
  METHOD KeyDown     ( nKey, nKeyFlags ) CLASS TBanda
/***********************************************************************************************/
local n, nLen := len( ::aSelecteds )
local nTop, nLeft, nBottom, nRight
local oItem
local rc, rc1, rc2
local nStep
local lControl := GetKeyState( VK_CONTROL )
local lShift   := GetKeyState( VK_SHIFT )

nStep := if( ::oWnd:lGrid, if( lControl, ::oWnd:nGrid*3,::oWnd:nGrid ), 1 )

do case
   case nKey == VK_DOWN

        if nLen > 0
           for n := 1 to nLen
               oItem := ::aSelecteds[n]
               rc := oItem:SetOldRect()
               nTop    := oItem:nTop    + if( lShift, 0, nStep )
               nLeft   := oItem:nLeft
               nBottom := oItem:nBottom + nStep
               nRight  := oItem:nRight
               oItem:MoveTo( nTop, nLeft, nBottom, nRight )
               rc1 := oItem:GetRect()
               rc2 := UnionRect( rc, rc1 )
               rc2[3] += 1
               rc2[4] += 1
               InvalidateRect(::hWnd, rc2, .t. )
           next
        else
           if ::oFocused != nil
              oItem := ::oFocused
              rc := oItem:SetOldRect()
              nTop    := oItem:nTop    + if( lShift, 0, nStep )
              nLeft   := oItem:nLeft
              nBottom := oItem:nBottom + nStep
              nRight  := oItem:nRight
              oItem:MoveTo( nTop, nLeft, nBottom, nRight )
              rc1 := oItem:GetRect()
              rc2 := UnionRect( rc, rc1 )
              rc2[3] += 1
              rc2[4] += 1
              InvalidateRect(::hWnd, rc2, .t. )
           endif
        endif

   case nKey == VK_RIGHT

        if nLen > 0
           for n := 1 to nLen
               oItem := ::aSelecteds[n]
               rc := oItem:SetOldRect()
               nTop    := oItem:nTop
               nLeft   := oItem:nLeft   + if( !lShift, nStep, 0 )
               nBottom := oItem:nBottom
               nRight  := oItem:nRight  + nStep
               oItem:MoveTo( nTop, nLeft, nBottom, nRight )
               rc1 := oItem:GetRect()
               rc2 := UnionRect( rc, rc1 )
               rc2[3] += 1
               rc2[4] += 1
               InvalidateRect(::hWnd, rc2, .t. )
           next
        else
           if ::oFocused != nil
              oItem := ::oFocused
              rc := oItem:SetOldRect()
              nTop    := oItem:nTop
              nLeft   := oItem:nLeft   + if( !lShift, nStep, 0 )
              nBottom := oItem:nBottom
              nRight  := oItem:nRight  + nStep
              oItem:MoveTo( nTop, nLeft, nBottom, nRight )
              rc1 := oItem:GetRect()
              rc2 := UnionRect( rc, rc1 )
              rc2[3] += 1
              rc2[4] += 1
              InvalidateRect(::hWnd, rc2, .t. )
           endif
        endif

   case nKey == VK_UP
        if nLen > 0
           for n := 1 to nLen
               oItem := ::aSelecteds[n]
               rc := oItem:SetOldRect()
               nTop    := oItem:nTop    - if( lShift,0, nStep )
               nLeft   := oItem:nLeft
               nBottom := oItem:nBottom - nStep
               nRight  := oItem:nRight
               oItem:MoveTo( nTop, nLeft, nBottom, nRight )
               rc1 := oItem:GetRect()
               rc2 := UnionRect( rc, rc1 )
               rc2[3] += 1
               rc2[4] += 1
               InvalidateRect(::hWnd, rc2, .t. )
           next
        else
           if ::oFocused != nil
              oItem := ::oFocused
              rc := oItem:SetOldRect()
              nTop    := oItem:nTop    - if( lShift, 0, nStep )
              nLeft   := oItem:nLeft
              nBottom := oItem:nBottom - nStep
              nRight  := oItem:nRight
              oItem:MoveTo( nTop, nLeft, nBottom, nRight )
              rc1 := oItem:GetRect()
              rc2 := UnionRect( rc, rc1 )
              rc2[3] += 1
              rc2[4] += 1
              InvalidateRect(::hWnd, rc2, .t. )
           endif
        endif

   case nKey == VK_LEFT

        if nLen > 0
           for n := 1 to nLen
               oItem := ::aSelecteds[n]
               rc := oItem:SetOldRect()
               nTop    := oItem:nTop
               nLeft   := oItem:nLeft   - if( lShift,0, nStep )
               nBottom := oItem:nBottom
               nRight  := oItem:nRight  - nStep
               oItem:MoveTo( nTop, nLeft, nBottom, nRight )
               rc1 := oItem:GetRect()
               rc2 := UnionRect( rc, rc1 )
               rc2[3] += 1
               rc2[4] += 1
               InvalidateRect(::hWnd, rc2, .t. )
           next
        else
           if ::oFocused != nil
              oItem := ::oFocused
              rc := oItem:SetOldRect()
              nTop    := oItem:nTop
              nLeft   := oItem:nLeft   - if( lShift, 0, nStep )
              nBottom := oItem:nBottom
              nRight  := oItem:nRight  - nStep
              oItem:MoveTo( nTop, nLeft, nBottom, nRight )
              rc1 := oItem:GetRect()
              rc2 := UnionRect( rc, rc1 )
              rc2[3] += 1
              rc2[4] += 1
              InvalidateRect(::hWnd, rc2, .t. )
           endif
        endif

endcase

return 0

/***********************************************************************************************/
  METHOD KeyChar( nKey, nKeyFlags ) CLASS TBanda
/***********************************************************************************************/
local n, nLen := len( ::aItems )
local oItem


do case
   case nKey == VK_TAB
        if nLen > 1 .and. ::oFocused != nil
           for n := 1 to nLen
               oItem := ::aItems[n]
               if oItem:nId == ::oFocused:nId
                  ::oFocused:SetFocus( .f. )
                  InvalidateRect(::hWnd, ::oFocused:GetRect(),.t.)
                  if n == nLen
                     ::aItems[1]:SetFocus( .t. )
                     ::oFocused := ::aItems[1]
                  else
                     ::aItems[n+1]:SetFocus( .t. )
                     ::oFocused := ::aItems[n+1]
                  endif
                  exit
               endif
           next
           InvalidateRect(::hWnd, ::oFocused:GetRect(),.t.)
        endif
endcase

return 0





