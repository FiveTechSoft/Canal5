#include "fivewin.ch"
#include "Informe.ch"


CLASS TSoporte FROM TControl

      CLASSDATA lRegistered AS LOGICAL
      DATA lxGrid
      DATA lLines
      DATA nxGrid
      DATA nLastWidth
      DATA aBandas
      DATA oInspect
      DATA cFileName AS CHARACTER INIT "noname.spr"
      DATA aTablas


      METHOD New( nTop, nLeft, oWnd ) CONSTRUCTOR

      METHOD Display()   INLINE ::BeginPaint(), ::Paint(), ::EndPaint(),0
      METHOD Paint()

      METHOD LButtonDown ( nRow, nCol, nKeyFlags )
      METHOD MouseMove   ( nRow, nCol, nKeyFlags )
      METHOD LButtonUp   ( nRow, nCol, nKeyFlags )
      METHOD ResizeHeights()
      METHOD ResizeWidths()
      METHOD SetGrid( lGrid )
      METHOD MoveLeft()
      METHOD MoveRight()
      METHOD MoveUp()
      METHOD MoveDown()
      METHOD SayCoords()
      METHOD IsOverBanda( nRow, nCol, nBanda )
      METHOD SetFocused( oBanda, oItem )
      METHOD ResetFocus( lErase )
      METHOD SetProperties()
      METHOD GetNameBandas()
      METHOD AddTabla( cBaseName, cPath )
      METHOD DelTabla( cBaseName )
      METHOD Refresh() INLINE super:Refresh(), aeval( ::aBandas, {|x| x:Refresh() } )
      METHOD nGrid( nVal ) SETGET
      METHOD lGrid( lVal ) SETGET

ENDCLASS

******************************************************************************************************************************************************
      METHOD SayCoords() CLASS TSoporte
******************************************************************************************************************************************************
local n

for n := 1 to len( ::aBandas )
    wqout( GetCoors(::aBandas[n]:hWnd))
next

return nil

******************************************************************************************************************************************************
   METHOD New( nTop, nLeft, oWnd ) CLASS TSoporte
******************************************************************************************************************************************************

   ::nTop       := nTop
   ::nLeft      := nLeft
   ::nBottom    := 10000
   ::nRight     := 10000
   ::oWnd       := oWnd
   ::lxGrid     := .t.
   ::nxGrid     := 10
   ::nLastWidth := 0
   ::aBandas    := {}
   ::aTablas    := {}

   ::nStyle      := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_CLIPSIBLINGS, WS_CLIPCHILDREN  )
   ::nId         := ::GetNewId()

   ::SetColor( 0, CLR_GRAY )

   ::Register(nOr( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif

return self


*******************************************************************************************************************
      METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TSoporte
*******************************************************************************************************************
local n, nLen

nLen := len( ::aBandas )

for n := 1 to nLen

   if PtInRect( nRow, nCol, ::aBandas[n]:aBtn )
      ::aBandas[n]:lOpen( !::aBandas[n]:lOpen )
      return n
   endif

next

CursorArrow()

if ::IsOverBanda( nRow, nCol, @n )
   ::aBandas[n]:SetFocus( .t. )
   ::aBandas[n]:SetProperties()
   return 0
endif

::SetProperties()



return 0


****************************************************************************************************
  METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSoporte
****************************************************************************************************
local n, nLen

nLen := len( ::aBandas )

for n := 1 to nLen

   if PtInRect( nRow, nCol, ::aBandas[n]:aBtn )
      CursorHand()
      exit
   else
      CursorArrow()
   endif

next

return 1

*******************************************************************************
  METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TSoporte
*******************************************************************************


return 1

*******************************************************************************
  METHOD ResizeHeights() CLASS TSoporte
*******************************************************************************
local n
local nLen := len( ::aBandas )
local oLast

for n := 2 to nLen

    oLast := ::aBandas[n-1]

    ::aBandas[n]:nTop := oLast:nTop + oLast:nHeight + 20
    ::aBandas[n]:Refresh()

next

::Refresh()

return nil

*******************************************************************************
  METHOD ResizeWidths() CLASS TSoporte
*******************************************************************************
local n
local nLen := len( ::aBandas )

for n := 1 to nLen

    ::aBandas[n]:nWidth( ::nLastWidth )

next

::nLastWidth := 0

::Refresh()

return nil


*******************************************************************************
  METHOD Paint() CLASS TSoporte
*******************************************************************************
local hDC := ::hDC
local aRect
local hFont, hOldFont
local nCol, nRow
local n, nLen
local o
nLen := len(::aBandas)

for n := 1 to nLen

   o := ::aBandas[n]

   aRect := { o:nTop-20, o:nLeft, o:nTop, o:nLeft + 2000 }

   FillSolidRect( hDC, aRect, if( o:hWnd == GetFocus(), CLR_BLUE, rgb( 220,220,220)) )
   ::aBandas[n]:aRectTitle := aRect

   if o:lOpen
      DrawMasked( hDC, o:hMinus, o:nTop - 15, o:nLeft + 10 )
   else
      DrawMasked( hDC, o:hPlus, o:nTop - 15, o:nLeft + 10 )
   endif

   o:aBtn := { o:nTop-15, o:nLeft+10, o:nTop-15+13, o:nLeft+10+13}

   hFont := GetStockObject( DEFAULT_GUI_FONT )
   hOldFont := SelectObject( hDC, hFont )
   SetBkMode( hDC, 1 )

   if o:hWnd == GetFocus()
      SetTextColor( hDC, CLR_WHITE )
   else
      SetTextColor( hDC, 0 )
   endif

   TextOut( hDC, o:nTop - 15, o:nLeft + 30, o:cName )
   SelectObject( hDC, hOldFont )
   SysRefresh()

next

return nil

*********************************************************************************************************
   METHOD SetGrid( lGrid ) CLASS TSoporte
*********************************************************************************************************
local n
local nLen := len( ::aBandas )

::lGrid := lGrid

for n := 1 to nLen

    ::aBandas[n]:Refresh()

next


return nil

*********************************************************************************************************
  METHOD MoveLeft() CLASS TSoporte
*********************************************************************************************************
local nLeft := GetCoors(::hWnd )[2]+10
::Move( GetCoors(::hWnd )[1], nLeft,,,.t.)
return nil


*********************************************************************************************************
  METHOD MoveRight() CLASS TSoporte
*********************************************************************************************************
local nLeft := GetCoors(::hWnd )[2]-10
::Move( GetCoors(::hWnd )[1], nLeft,,,.t.)
return nil

*********************************************************************************************************
  METHOD MoveUp() CLASS TSoporte
*********************************************************************************************************
local nTop := GetCoors(::hWnd )[1]+10
::Move( nTop, GetCoors(::hWnd )[2],,,.t.)
return nil


*********************************************************************************************************
  METHOD MoveDown() CLASS TSoporte
*********************************************************************************************************
local nTop := GetCoors(::hWnd )[1]-10
::Move( nTop , GetCoors(::hWnd )[2],,,.t.)
return nil


*********************************************************************************************************
  METHOD IsOverBanda( nRow, nCol, nBanda ) CLASS TSoporte
*********************************************************************************************************
local n, nLen
nBanda := 0

nLen := len( ::aBandas )

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aBandas[n]:aRectTitle )
       nBanda := n
       return .t.
    endif
next
return .f.

*********************************************************************************************************
  METHOD SetFocused( oBanda, oItem ) CLASS TSoporte
*********************************************************************************************************
local n, nLen
local n2, nLen2
local o

nLen := len( ::aBandas )

for n := 1 to nLen
    nLen2 := len( ::aBandas[n]:aItems )
    for n2 := 1 to nLen2
        o := ::aBandas[n]:aItems[n2]
        o:lFocused := (o:nID == oItem:nID )
    next
    ::aBandas[n]:Refresh()
next

return .f.

*********************************************************************************************************
  METHOD ResetFocus( lErase ) CLASS TSoporte
*********************************************************************************************************
local n, nLen
local n2, nLen2
local o

DEFAULT lErase := .t.

nLen := len( ::aBandas )
for n := 1 to nLen
    nLen2 := len( ::aBandas[n]:aItems )

    for n2 := 1 to nLen2
        o := ::aBandas[n]:aItems[n2]
        o:lFocused := .f.
    next
    if lErase
       ::aBandas[n]:Refresh()
    endif
next

return .f.

*******************************************************************************************************
  METHOD SetProperties() CLASS TSoporte
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup
local o := self
local aBandas := ::GetNameBandas()

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )

        oInsp:AddItem( "cFileName", "Nombre", ::cFileName,,nGroup )
        oInsp:AddItem( "",          "Bandas", aBandas[1], LISTA, nGroup,,,{|| aBandas } )
        oInsp:AddItem( "lGrid",     "Grid", ::lGrid,, nGroup )
        oInsp:AddItem( "nGrid",     "xy Grid", ::nGrid,, nGroup )



     nGroup := oInsp:AddGroup( "Posición" )

        oInsp:AddItem( "nHeight", "Alto",    ::nHeight,,nGroup,,.f. )
        oInsp:AddItem( "nWidth",  "Ancho",    ::nWidth,,nGroup,,.f. )
        oInsp:AddItem( "nTop",    "Arriba",     ::nTop,,nGroup,,.f. )
        oInsp:AddItem( "nLeft",   "Izquierda", ::nLeft,,nGroup,,.f. )

     oInsp:refresh()

return nil

*******************************************************************************************************
  METHOD GetNameBandas() CLASS TSoporte
*******************************************************************************************************
local aBandas := {}
local n
local nLen := len( ::aBandas )

for n := 1 to nLen
    aadd( aBandas, ::aBandas[n]:cName )
next

return aBandas


*********************************************************************************************************
      METHOD AddTabla( cBaseName, cPath ) CLASS TSoporte
*********************************************************************************************************
local n, nLen
local lFind := .f.
nLen := len( ::aTablas )
for n := 1 to nLen
    if ::atablas[n,1] == cBaseName
       lFind := .t.
       exit
    endif
next

if !lFind
   aadd( ::atablas, {cBaseName, 1, cPath } )
endif


return nil

*********************************************************************************************************
      METHOD DelTabla( cBaseName ) CLASS TSoporte
*********************************************************************************************************
local n, nLen
local lFind := .t.
nLen := len( ::aTablas )

for n := 1 to nLen

    if ::atablas[n,1] == cBaseName

       ::atablas[n,2] := ::atablas[n,2] - 1

       if ::atablas[n,2] == 0
          adel( ::aTablas, n )
          asize( ::aTablas, nLen - 1 )
       endif

       exit

    endif
next

return nil

*******************************************************************************************************
  METHOD nGrid( nVal ) CLASS TSoporte
*******************************************************************************************************
local aBandas := {}
local n
local nLen := len( ::aBandas )

if pcount() > 0
   ::nxGrid := nVal
   if ::lGrid
      for n := 1 to nLen
          ::aBandas[n]:SetGrid( ::nxGrid )
      next
   endif
endif

return ::nxGrid

*******************************************************************************************************
  METHOD lGrid( lVal ) CLASS TSoporte
*******************************************************************************************************
local aBandas := {}
local n
local nLen := len( ::aBandas )

if pcount() > 0
   ::lxGrid := lVal
   for n := 1 to nLen
       ::aBandas[n]:SetGrid( if( ::lxGrid, ::nxGrid, 0 ) )
   next
endif

return ::lxGrid

