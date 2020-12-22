#include "fivewin.ch"
#include "c5report.ch"

CLASS TC5RptItemDetail FROM TC5RptItem

      DATA axCols        AS ARRAY   INIT {}
      DATA nxRows        AS NUMERIC INIT 4
      DATA nxCols        AS NUMERIC INIT 6
      DATA nxRW          AS NUMERIC INIT 10
      DATA nxRH          AS NUMERIC INIT 10
      DATA lShowLines  	 AS LOGICAL INIT .F.
      DATA nxPen         AS NUMERIC INIT 1
      DATA nxClrPen      AS NUMERIC INIT 0
      DATA nClrPane  	 AS NUMERIC INIT CLR_WHITE
      DATA nxActiveCol   AS NUMERIC INIT 1
      DATA cxActiveCol
//      DATA nxHeaders     AS NUMERIC INIT 1

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD Save( )
      METHOD Load( cStr, nPuntero )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD IsOver  ( nRow, nCol )
      METHOD SetProperties( lReset )
      METHOD nPen         ( NValue ) SETGET
      METHOD nClrPen      ( NValue ) SETGET

      METHOD aCols        ( aValue ) SETGET
      METHOD acCols       ()
      METHOD nRows        ( nValue ) SETGET
      METHOD nCols        ( nValue ) SETGET
      METHOD ResizeCols()
      METHOD SelInto()    INLINE if( ::nActiveCol != nil,::aCols[::nActiveCol]:SetProperties(),)
      METHOD nActiveCol   ( nValue ) SETGET
      METHOD cActiveCol   () INLINE ::acCols()[::nActiveCol]
      METHOD SetActiveCol ( cColName ) SETGET
//      METHOD nHeaders     ( nValue ) SETGET
      METHOD cItemName()  INLINE "Detalle (" + alltrim(str( ::nID )) + ")"

ENDCLASS

****************************************************************************************************************************
  METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CLASS TC5RptItemDetail
****************************************************************************************************************************

   if nTop       == nil; nTop       := 0        ; endif
   if nLeft      == nil; nLeft      := 0        ; endif
   if nWidth     == nil; nWidth     := 0        ; endif
   if nHeight    == nil; nHeight    := 0        ; endif
   if lEnable  == nil;  lEnable   := .t.      ; endif

   ::oWnd          := oWnd
   ::aCoords[1]    := nTop
   ::aCoords[2]    := nLeft
   ::aCoords[3]    := (nTop + nHeight)
   ::aCoords[4]    := (nLeft + nWidth)
   ::lEnable       := lEnable
   ::nID           := ::GetNewID()
   ::nType         := C5DETAIL
   ::aEnablePoints := {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
   ::nRows         := ::nxRows
   ::nCols         := ::nxCols
   ::lTransparent  := .f.
   ::lFromNew      := .f.

return self

//******************************************************************************************************************
//   METHOD nHeaders( nValue )  CLASS TC5RptItemDetail
//******************************************************************************************************************
//
//if nValue != nil
//   ::nxHeaders := nValue
//endif
//
//return ::nxHeaders

******************************************************************************************************************
   METHOD nPen( nValue ) CLASS TC5RptItemDetail
******************************************************************************************************************

if nValue != nil
   if !::lFromNew
      if !::oWnd:lDoingUndo()
         ::oWnd:AddUndo( 1, self, "nPen", ::nxPen, .t. )
      endif
      ::nxPen := nValue
   endif
endif
return ::nxPen

******************************************************************************************************************
   METHOD nClrPen( nValue ) CLASS TC5RptItemDetail
******************************************************************************************************************

if nValue != nil
   if !::lFromNew
      if !::oWnd:lDoingUndo()
         ::oWnd:AddUndo( 1, self, "nClrPen", ::nxClrPen, .t. )
      endif
      ::nxClrPen := nValue
   endif
endif
return ::nxClrPen


******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemDetail
******************************************************************************************************************

 local hFont
 local hOldFont
 local nMode
 local hBrush, hOldBrush
 local nT := ::nTop      + ::oWnd:nRTop
 local nL := ::nLeft     + ::oWnd:nRLeft
 local nB := ::nBottom   + ::oWnd:nRTop
 local nR := ::nRight    + ::oWnd:nRLeft
 local n
 local hPen    := CreatePen( PS_SOLID, ::nPen * ::oWnd:nZoom/100, ::nClrPen )
 local nH := ::nHeight
 local nW := ::nWidth
 local hPenDotted := CreatePen( 2, 1, RGB(201,201,201) )
 local nColor
 local nWidth
 local nDFila     := (nB-nT) / ::nRows
 local nDColumna  := (nR-nL) / ::nCols
 local hOldPen
 local nAuxL := nL
 local nAuxL2
 local hBmp
 local oCol

    if ::lTransparent
       hBrush := GetStockObject( 5 )
    else
       hBrush := CreateSolidBrush( ::nClrPane )
    endif

    hOldBrush := SelectObject( hDC, hBrush )

    for n := 1 to ::nCols

        oCol := ::aCols[n]
        oCol:Paint( hDC, nT, nL, ( oCol:nWidth * ::oWnd:nZoom/100 ),nDFila )
        nL += oCol:nWidth

    next

    nL := ::nLeft     + ::oWnd:nRLeft

    if !::lShowLines
       hOldPen := SelectObject( hDC, hPenDotted )
    else
       hOldPen := SelectObject( hDC, hPen )
    endif

//    if ::lRoundRect
//       RoundRect( hDC, nT, nL, nB, nR, ::nRW * ::oWnd:nZoom/100, ::nRH* ::oWnd:nZoom/100 )
//    else
       Rectangle( hDC, nT, nL, nB, nR )
//    endif

    for n := 1 to ::nRows -1
        Moveto( hDC, nL, nT + n * nDFila )
        Lineto( hDC, nR, nT + n * nDFila )
    next

    for n := 1 to ::nCols
        if n == ::nActiveCol
           nAuxL2 := nAuxL
        endif
        Moveto( hDC, nAuxL, nT )
        Lineto( hDC, nAuxL, nB )
        nAuxL += ( ::aCols[n]:nWidth * ::oWnd:nZoom/100 )
    next

    if ::oWnd:oSelected != nil .and. ::oWnd:oSelected:nID == ::nID
       if ::nActiveCol != nil  .and. ::nActiveCol >= 1 .and. ::nActiveCol <= len( ::aCols )
          nL := nAuxL2
          Box( hDC, {nT,nAuxL2,nB-1,nAuxL2+(::aCols[::nActiveCol]:nWidth*::oWnd:nZoom/100)}, CLR_HRED )
       endif
    endif

    SelectObject( hDC, hOldPen )
    DeleteObject( hPen )
    DeleteObject( hPenDotted )

    if hOldBrush != nil
       SelectObject( hDC, hOldBrush )
    endif
    if hBrush != nil
       DeleteObject( hBrush )
    endif



 if !::oWnd:lCaptured
   ::PaintPts( hDC )
 endif

return nil

******************************************************************************************************************
      METHOD SetActiveCol ( cColName ) CLASS TC5RptItemDetail
******************************************************************************************************************
local oColumn := nil
local n
local acCols := ::acCols()

for n := 1 to len( acCols )
    if acCols[n] == cColName
       ::nActiveCol := n
       oColumn := ::aCols[n]
       oColumn:SetProperties()
       ::Refresh()
       exit
    endif
next

return oColumn

******************************************************************************************************************
      METHOD IsOver  ( nRow, nCol )  CLASS TC5RptItemDetail
******************************************************************************************************************
local lRet := .f.
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


do case
   case ::nType == 3 // línea vertical
        lRet := PtInRect( nRow, nCol, {nTop,nLeft-3,nBottom,nRight+3} )
   case ::nType == 4 // línea horizontal
        lRet := PtInRect( nRow, nCol, {nTop-3,nLeft,nBottom+3,nRight} )
   otherwise
      lRet := PtInRect( nRow, nCol, {nTop,nLeft,nBottom,nRight} ) .and.;
              if( !::lTransparent,.t., !PtInRect( nRow, nCol, {nTop+5,nLeft+5,nBottom-5,nRight-5} ))
endcase

//FillSolidRect(::oWnd:GetDC(),{nTop,nLeft,nBottom,nRight}, 0 )
//::oWnd:ReleaseDC()

return lRet


******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemDetail
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cut" ACTION ::oWnd:Cut()
   MENUITEM "Copy" ACTION ::oWnd:Copy()
   MENUITEM "Paste" ACTION ::oWnd:Paste()

   if ::lEnable
      MENUITEM "Disable" ACTION (::lEnable := .f., ::oWnd:Refresh())
   else
      MENUITEM "Enable" ACTION  (::lEnable := .t., ::oWnd:Refresh())
   endif

   MENUITEM "Transparent"       ACTION (::lTransparent := !::lTransparent, ::oWnd:Refresh())
   MENUITEM "Round Corners"     ACTION (::lRoundRect := !::lRoundRect, ::oWnd:Refresh())
   MENUITEM "Line Color"        ACTION (::nClrPen  := ChooseColor( ::nClrPen ), ::oWnd:Refresh())
   MENUITEM "Background Color"  ACTION (::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0

******************************************************************************************************************
      METHOD Save( ) CLASS TC5RptItemDetail
******************************************************************************************************************

local cStr



cStr := str(::nType,3)

cStr +=  str(::aCoords[1],4)
cStr +=  str(::aCoords[2],4)
cStr +=  str(::aCoords[3],4)
cStr +=  str(::aCoords[4],4)
cStr += ( str(::nPen, 2 )                   )
cStr += ( str(::nClrPen,8)                  )
cStr += ( str(::nClrPane,8)                 )
cStr += ( if( ::lTransparent,  ".t.",".f.") )
cStr += ( str(::nRW, 3)                     )
cStr += ( str(::nRH, 3)                     )


return cStr


******************************************************************************************************************
      METHOD Load( cStr, nPuntero ) CLASS TC5RptItemDetail
******************************************************************************************************************
local nLen

    ::aCoords[1]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nTop
    ::aCoords[2]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nLeft
    ::aCoords[3]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nBottom
    ::aCoords[4]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nRight
    ::nPen         := val( substr( cStr, nPuntero, 2 ) )                  ; nPuntero += 2      //::nPen
    ::nClrPen      := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPen
    ::nClrPane     := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPane
    ::lTransparent :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::nRW          := val( substr( cStr, nPuntero, 3 ) )                  ; nPuntero += 3      //::nPen
    ::nRH          := val( substr( cStr, nPuntero, 3 ) )                  ; nPuntero += 3      //::nPen

return 0


******************************************************************************************************************
   METHOD nActiveCol( nValue ) CLASS TC5RptItemDetail
******************************************************************************************************************

if nValue != nil
   ::nxActiveCol := nValue
endif

return ::nxActiveCol



******************************************************************************************************************
   METHOD SetProperties( lReset ) CLASS TC5RptItemDetail
******************************************************************************************************************
Local nGroup, oInsp := Inspector()
local hDC, aFonts
local nColor

     DEFAULT lReset := .t.

     oInsp:Reset()
     oInsp:oObject := self

     nGroup := oInsp:AddGroup( "Información" )
     oInsp:AddItem( "",    "Tipo", "Detalle",,nGroup,,.F. )
     oInsp:AddItem( "nID", "ID",   ::nID    ,,nGroup )
     oInsp:AddItem( "", "Columnas", ::cActiveCol(), LISTA, nGroup,,,{|| ::acCols() },,,"SetActiveCol" )

     super:SetProperties( .t. )

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "nPen",        "Grueso",       ::nPen,          ,nGroup )
     oInsp:AddItem( "nClrPen",     "Color",        ::nClrPen, ACCION,nGroup,,,{||nColor := ChooseColor( ::nClrPen ), if( nColor != nil, (::nClrPen := nColor, ::Refresh()),),::nClrPen } )
     oInsp:AddItem( "nClrPane",    "Color Fondo",  ::nClrPane,ACCION,nGroup,,,{||nColor := ChooseColor( ::nClrPane ), if( nColor != nil, (::nClrPane := nColor, ::Refresh()),),::nClrPane } )
     oInsp:AddItem( "lTransparent","Transparente", ::lTransparent,  ,nGroup )
     oInsp:AddItem( "lEnable",     "Activado",     ::lEnable,,nGroup )
     //oInsp:AddItem( "lRoundRect",  "Redondeado",   ::lRoundRect,    ,nGroup )
     //oInsp:AddItem( "nRW",         "Ancho esquina",::nRW,           ,nGroup )
     //oInsp:AddItem( "nRH",         "Alto esquina", ::nRH,           ,nGroup )
     oInsp:AddItem( "lShowLines",  "Ver líneas",   ::lShowLines,    ,nGroup )
     oInsp:AddItem( "nRows",       "Filas",        ::nRows,         ,nGroup )
     oInsp:AddItem( "nCols",       "Columnas",     ::nCols,         ,nGroup )

     oInsp:GoTop()
     oInsp:Refresh()


return nil




******************************************************************************************************************
      METHOD aCols( aValue ) CLASS TC5RptItemDetail
******************************************************************************************************************

if aValue != nil
   ::axCols := aValue
endif

return ::axCols

******************************************************************************************************************
      METHOD acCols() CLASS TC5RptItemDetail
******************************************************************************************************************
local n
local acCols := {}

for n := 1 to len( ::aCols )
    aadd( acCols, "Columna " + alltrim(str(n)) )
next

return acCols


******************************************************************************************************************
      METHOD nRows ( nValue ) CLASS TC5RptItemDetail
******************************************************************************************************************
local nCol

if nValue != nil
   ::nxRows := nValue
   ::Refresh()
endif

return ::nxRows

******************************************************************************************************************
      METHOD nCols ( nValue ) CLASS TC5RptItemDetail
******************************************************************************************************************
local n

if nValue != nil
   ::nxCols := nValue
   asize( ::aCols, ::nxCols )
   for n := 1 to ::nxCols
       if empty( ::aCols[n] )
          ::aCols[n] := CColDetail():New( self )
       endif
   next
   ::ResizeCols()
   ::Refresh()
endif


return ::nxCols


******************************************************************************************************************
   METHOD ResizeCols() CLASS TC5RptItemDetail
******************************************************************************************************************
 local n
 local nL := ::aCoords[2]
 local nR := ::aCoords[4]
 local nDColumna  := (nR-nL) / ::nCols

 for n := 1 to ::nCols
     if empty( ::aCols[n]:nWidth )
        ::aCols[n]:nWidth := nDColumna
     endif
 next

return nil


CLASS CColDetail

      DATA oDetail
      DATA cxHeader        AS CHARACTER INIT ""
      DATA cxValue         AS CHARACTER INIT ""
      DATA nxWidth         AS NUMERIC   INIT 100

      DATA nxAlign         AS NUMERIC   INIT 1 // izda

      DATA cFaceName                    INIT "Verdana"
      DATA nWFont                       INIT 0
      DATA nHFont                       INIT -11
      DATA lUnder                       INIT .f.
      DATA lBold                        INIT .f.
      DATA lItalic                      INIT .f.
      DATA lStrike                      INIT .f.

      DATA nClrText        AS NUMERIC INIT CLR_BLACK
      DATA nClrPane        AS NUMERIC INIT CLR_WHITE

      METHOD New( oDetail, cHeader, cValue, nWidth ) CONSTRUCTOR
      METHOD SetProperties()
      METHOD cHeader( cValue ) SETGET
      METHOD cValue ( cValue ) SETGET
      METHOD nWidth ( nValue ) SETGET
      METHOD Refresh()         INLINE ::oDetail:Refresh()
      METHOD Paint( hDC, nT, nL, nW, nH )
      METHOD nAlign( nValue ) SETGET
      METHOD cAlign()         INLINE {"Izquierda","Centro","Derecha"}[::nAlign]

ENDCLASS

******************************************************************************************************************
   METHOD New( oDetail, cHeader, cValue, nWidth )  CLASS CColDetail
******************************************************************************************************************

    ::oDetail := oDetail
    ::cHeader := cHeader
    ::cValue  := cValue
    ::nWidth  := nWidth

return self

******************************************************************************************************************
   METHOD SetProperties() CLASS CColDetail
******************************************************************************************************************
Local nGroup, oInsp := Inspector()
local hDC, aFonts
local nColor


     oInsp:Reset()
     oInsp:oObject := self

     nGroup := oInsp:AddGroup( "Información" )
     oInsp:AddItem( "",    "Tipo", "Columna Detalle",,nGroup,,.F. )

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "cHeader",       "Cabecera",::cHeader,        ,nGroup )
     oInsp:AddItem( "cValue",        "Valor",   ::cValue,        ,nGroup )
     oInsp:AddItem( "nWidth",        "Ancho",   ::nWidth, SPINNER,nGroup )
     oInsp:AddItem( "nClrText","Color Texto", ::nClrText,  ACCION,nGroup,,,{||nColor := ChooseColor( ::nClrText ), if( nColor != nil, (::nClrText := nColor, ::Refresh()),),::nClrText } )
     oInsp:AddItem( "nClrPane","Color Fondo", ::nClrPane,  ACCION,nGroup,,,{||nColor := ChooseColor( ::nClrPane ), if( nColor != nil, (::nClrPane := nColor, ::Refresh()),),::nClrPane } )
     oInsp:AddItem( "nAlign",     "Alineado",   ::cAlign,  LISTA, nGroup,         ,        ,{|| {"Izquierda","Centro","Derecha"}}        ,        , ::nAlign         )

     nGroup := oInsp:AddGroup( "Fuente" )

     oInsp:AddItem( "cFaceName", "Nombre",  ::cFaceName, LISTA, nGroup,,,{||hDC := GetDC( oInsp:hWnd ),aFonts := GetFontNames(hDC), aFonts := asort( aFonts ),ReleaseDC(oInsp:hWnd,hDC), aFonts} )
     oInsp:AddItem( "nWFont",    "Ancho",   ::nWFont,,nGroup )
     oInsp:AddItem( "nHFont",    "Alto",    ::nHFont,,nGroup )
     oInsp:AddItem( "lItalic",   "Cursiva", ::lItalic,,nGroup )
     oInsp:AddItem( "lUnder",    "Subrayado", ::lUnder,,nGroup )
     oInsp:AddItem( "lStrike",   "Tachado", ::lStrike,,nGroup )
     oInsp:AddItem( "lBold",     "Negrita", ::lBold,,nGroup )

     oInsp:GoTop()
     oInsp:Refresh()


return nil

******************************************************************************************************************
      METHOD nAlign( nValue ) CLASS CColDetail
******************************************************************************************************************

if nValue != nil
   if valtype( nValue ) == "C"
      nValue := ascan( {"Izquierda","Centro","Derecha"}, nValue )
   endif
   DEFAULT nValue := 1
   ::nxAlign := nValue
endif

return ::nxAlign


******************************************************************************************************************
      METHOD cHeader( cValue ) CLASS CColDetail
******************************************************************************************************************

if cValue != nil
   ::cxHeader := cValue
   ::Refresh()
endif

return ::cxHeader

******************************************************************************************************************
      METHOD cValue ( cValue ) CLASS CColDetail
******************************************************************************************************************

if cValue != nil
   ::cxValue := cValue
endif

return ::cxValue

******************************************************************************************************************
      METHOD nWidth ( nValue ) CLASS CColDetail
******************************************************************************************************************

if nValue != nil
   ::nxWidth := nValue
   ::Refresh()
endif

return ::nxWidth

******************************************************************************************************************
  METHOD Paint( hDC, nT, nL, nW, nH ) CLASS CColDetail
******************************************************************************************************************
local hFont, hOldFont, nMode, nColor
local aRect := {nT, nL, nT+nH, nL+nW}

if aRect[4] > ::oDetail:nRight
   aRect[4] := ::oDetail:nRight
endif

 hFont  := CreateFont( { ::nHFont * ::oDetail:oWnd:nZoom/100,;
                         ::nWFont * ::oDetail:oWnd:nZoom/100,;
                          0,0, if(::lBold,700,400), ::lItalic,::lUnder,::lStrike, 0, 0, 0, 0, 0, ::cFaceName } )

 hOldFont := SelectObject( hDC, hFont )
 nMode    := SetBkMode   ( hDC, 1 )
 nColor   := SetTextColor( hDC, ::nClrText )
 FillSolidRect( hDC, aRect, ::nClrPane )


 DrawText( hDC, ::cHeader, aRect, 36 + {DT_LEFT,DT_CENTER,DT_RIGHT}[::nAlign] )

 SelectObject( hDC, hOldFont )
 SetBkMode   ( hDC, nMode    )
 SetTextColor( hDC, nColor   )
 DeleteObject( hFont )

return 0
