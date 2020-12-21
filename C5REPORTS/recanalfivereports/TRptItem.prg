#include "fivewin.ch"
#include "Informe.ch"



CLASS TRptItem

      DATA nTop, nLeft, nBottom, nRight
      DATA oBanda
      DATA lFocused
      DATA lSelected
      DATA nId
      DATA lBorder
      DATA aOldRect
      DATA aOldPos
      DATA aProperties

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda ) CONSTRUCTOR

      METHOD GetNewId()       INLINE ++nIdItem
      METHOD GetRect()        INLINE {::nTop, ::nLeft, ::nBottom, ::nRight}
      METHOD MoveTo( nTop, nLeft, nBottom, nRight )
      METHOD Paint( hDC )
      METHOD PaintDots( hDC )
      METHOD PaintSel ( hDC, aRect )
      METHOD Refresh()        INLINE ::oBanda:Refresh()
      METHOD SetFocus(lFocus) INLINE ::lFocused := lFocus, if( ::lFocused, ::SetProperties(),)
      METHOD Select( lSel )   INLINE ::lSelected := lSel
      METHOD SetProperties()
      METHOD SetOldRect()     INLINE ::aOldRect := ::GetRect(), ::aOldRect
      METHOD SetOldPos ()     INLINE ::aOldPos  := {::nTop, ::nLeft}
      METHOD nHeight( nVal )  SETGET
      METHOD nMedHeight       INLINE (::nBottom-::nTop)/2
      METHOD nMedWidth        INLINE (::nRight-::nLeft)/2
      METHOD nWidth ( nVal )  SETGET
      METHOD AddProperties( aProps )
      METHOD Copy()

ENDCLASS

*******************************************************************************************************
  METHOD New( nTop, nLeft, nBottom, nRight, oBanda ) CLASS TRptItem
*******************************************************************************************************

local nGrid

      ::aProperties := {"nWidth","nHeight","lBorder"}

      ::nTop      := nTop
      ::nLeft     := nLeft
      ::nBottom   := nBottom
      ::nRight    := nRight
      ::oBanda    := oBanda
      ::lFocused  := .f.
      ::lSelected := .f.
      ::lBorder   := .f.
      ::nId       := ::GetNewID()

      if ::oBanda:oWnd:lGrid
         nGrid := ::oBanda:oWnd:nGrid
         ::nTop    -= ::nTop    % nGrid
         ::nLeft   -= ::nLeft   % nGrid
         ::nBottom -= ::nBottom % nGrid
         ::nRight  -= ::nRight  % nGrid
      endif
      aadd( ::oBanda:aItems, self )

return self

*******************************************************************************************************
  METHOD Paint( hDC, nTop, nLeft, nBottom, nRight ) CLASS TRptItem
*******************************************************************************************************
local hPen, hOldPen


if nTop == nil
   nTop    := ::nTop
   nLeft   := ::nLeft
   nBottom := ::nBottom
   nRight  := ::nRight
else
   if valtype( nTop ) == "A"
      nTop    := nTop[1]
      nLeft   := nTop[2]
      nBottom := nTop[3]
      nRight  := nTop[4]
   endif
endif

hPen := CreatePen( PS_SOLID, 1, RGB( 220,220,220) )
hOldPen := SelectObject( hDC, hPen )

MoveTo( hDC, nLeft,  nTop )
LineTo( hDC, nRight, nTop )
LineTo( hDC, nRight, nBottom )
LineTo( hDC, nLeft,  nBottom )
LineTo( hDC, nLeft,  nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )

return nil

*******************************************************************************************************
  METHOD PaintSel ( hDC, aRect )
*******************************************************************************************************
local hPen, hOldPen
local nTop, nLeft, nBottom, nRight

nTop    := aRect[1]
nLeft   := aRect[2]
nBottom := aRect[3]
nRight  := aRect[4]

hPen := CreatePen( PS_SOLID, 1, RGB( 220,220,220) )
hOldPen := SelectObject( hDC, hPen )

MoveTo( hDC, nLeft,  nTop )
LineTo( hDC, nRight, nTop )
LineTo( hDC, nRight, nBottom )
LineTo( hDC, nLeft,  nBottom )
LineTo( hDC, nLeft,  nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )


return nil

*******************************************************************************************************
  METHOD PaintDots( hDC ) CLASS TRptItem
*******************************************************************************************************

local aRect
local nColor

if ::lSelected
   nColor := CLR_HGRAY
endif

if ::lFocused
   if len( ::oBanda:aSelecteds ) > 0
      nColor := CLR_HBLUE
   else
      nColor := 0
   endif
endif

if ::lSelected

      aRect := { ::nTop, ::nLeft, ::nTop + 5, ::nLeft+5}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop, ::nLeft+::nMedWidth-2, ::nTop + 5, ::nLeft+::nMedWidth+3}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop, ::nRight-5, ::nTop + 5, ::nRight}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop+::nMedHeight-2, ::nRight-5, ::nTop +::nMedHeight+ 3, ::nRight}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nRight-5, ::nBottom, ::nRight}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nLeft+::nMedWidth-2, ::nBottom, ::nLeft+::nMedWidth+3}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nLeft, ::nBottom , ::nLeft+5}
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop+::nMedHeight-2, ::nLeft, ::nTop +::nMedHeight+ 3, ::nLeft+5}
      FillSolidRect( hDC, aRect, nColor )

else
   if ::lFocused

      asize( ::oBanda:aDots, 0 )

      aRect := { ::nTop, ::nLeft, ::nTop + 5, ::nLeft+5}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop, ::nLeft+::nMedWidth-2, ::nTop + 5, ::nLeft+::nMedWidth+3}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop, ::nRight-5, ::nTop + 5, ::nRight}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop+::nMedHeight-2, ::nRight-5, ::nTop +::nMedHeight+ 3, ::nRight}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nRight-5, ::nBottom, ::nRight}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nLeft+::nMedWidth-2, ::nBottom, ::nLeft+::nMedWidth+3}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nBottom-5, ::nLeft, ::nBottom , ::nLeft+5}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop+::nMedHeight-2, ::nLeft, ::nTop +::nMedHeight+ 3, ::nLeft+5}
      aadd( ::oBanda:aDots, aRect )
      FillSolidRect( hDC, aRect, nColor )

      aRect := { ::nTop, ::nLeft, ::nBottom, ::nRight}
      aadd( ::oBanda:aDots, aRect )

   endif
endif
return self


*******************************************************************************************************
  METHOD MoveTo( nTop, nLeft, nBottom, nRight ) CLASS TRptItem
*******************************************************************************************************
local nWidth := ::nWidth
local nHeight := ::nHeight

DEFAULT nBottom := nTop + nHeight
DEFAULT nRight := nLeft + nWidth


::nLeft := nLeft
::nTop  := nTop
::nBottom := nBottom
::nRight := nRight


return nil

*******************************************************************************************************
  METHOD SetProperties( lReset ) CLASS TRptItem
*******************************************************************************************************
Local nGroup, oInsp := Inspector()
local hDC, aFonts

     DEFAULT lReset := .t.

     if lReset
        oInsp:Reset()
        oList:oObject := self
     endif

     nGroup := oInsp:AddGroup( "Posición" )

     oInsp:AddItem( "nHeight", "Alto", int(::nHeight),,nGroup )
     oInsp:AddItem( "nWidth",  "Ancho", int(::nWidth),,nGroup )
     oInsp:AddItem( "nTop",    "Arriba", int(::nTop),,nGroup )
     oInsp:AddItem( "nLeft",   "Izquierda", int(::nLeft),,nGroup )

     if lReset
        oInsp:Refresh()
     endif

return nil

*******************************************************************************************************
  METHOD nWidth ( nVal ) CLASS TRptItem
*******************************************************************************************************

if pcount() > 0
   ::nRight := ::nLeft + nVal
endif

return ::nRight - ::nLeft



*******************************************************************************************************
  METHOD nHeight( nVal ) CLASS TRptItem
*******************************************************************************************************

if pcount() > 0
   ::nBottom := ::nTop + nVal
endif

return ::nBottom - ::nTop



*******************************************************************************************************
  METHOD AddProperties( aProps ) CLASS TRptItem
*******************************************************************************************************
local n, nLen

nLen := len( aProps )

for n := 1 to nLen
    aadd( ::aProperties, aProps[n] )
next

return nil

*******************************************************************************************************
  METHOD Copy() CLASS TRptItem
*******************************************************************************************************
local cStr := ""
local n, nLen
local uData, cType
local nProps := 0

nLen := len( ::aProperties )
cStr += ::ClassName() + CRLF

for n = 1 to nLen

    uData := OSend( Self, ::aProperties[ n ] )

    cType = ValType( uData )

    cStr += ( I2Bin( Len( ::aProperties[ n ] ) ) + ::aProperties[ n ] )

    cStr += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) +  uData )

    nProps ++

next

cStr := I2Bin( nProps ) + cStr

return cStr
