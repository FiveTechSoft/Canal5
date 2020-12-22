#include "fivewin.ch"
#include "c5report.ch"

CLASS TC5RptItemEllipse FROM TC5RptItem

      DATA nPen          AS NUMERIC INIT 1
      DATA nClrPen       AS NUMERIC INIT 0
      DATA lTransparent  AS LOGICAL INIT .T.
      DATA lBorder       AS LOGICAL INIT .T.
      DATA nType                    INIT C5RECT
      DATA aEnablePoints AS ARRAY   INIT {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}

      DATA cProperty1    INIT       "nClrPen"
      DATA cProperty2    INIT       "nClrPane"
      DATA cProperty3    INIT       "nPen"
      DATA cProperty4    INIT       "nRadio"

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CONSTRUCTOR
      METHOD Load( cStr, lPaste, nPuntero ) CONSTRUCTOR
      METHOD LoadIni( oIni, cItem ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD Save()
      METHOD SaveToIni( oIni )
      METHOD SaveToXML    ( oIni )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD cItemName()  INLINE "Elipse (" + alltrim(str( ::nID )) + ")"
      METHOD IsOver( nRow, nCol )
      METHOD nRadio( nValue ) SETGET
      METHOD SetPropertyMain()
      METHOD CreateProps()

ENDCLASS

****************************************************************************************************************************
  METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CLASS TC5RptItemEllipse
****************************************************************************************************************************

   if nTop    == nil; nTop    := 0   ; endif
   if nLeft   == nil; nLeft   := 0   ; endif
   if lEnable == nil; lEnable := .t. ; endif

   DEFAULT nWidth := 50
   DEFAULT nHeight := 50

   ::oWnd       := oWnd
   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)
   ::lEnable    := lEnable
   ::nID        := ::GetNewID()
   ::nType      := C5ELIPSE
   ::aEnablePoints := {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
   ::cType      := "Elipse"

   ::lFromNew := .f.

  ::CreateProps()

return self

******************************************************************************************************************
      METHOD CreateProps() CLASS TC5RptItemEllipse
******************************************************************************************************************

   ::AddProp( "nRealTop",     "Arriba",       nil,  "Posición" )
   ::AddProp( "nRealLeft",    "Izquierda",    nil,  "Posición" )
   ::AddProp( "nRealWidth",   "Ancho",        nil,  "Posición" )
   ::AddProp( "nRealHeight",  "Alto",         nil,  "Posición" )

   ::AddProp( "nPen",         "Grueso",       nil,                    "Apariencia" )
   ::AddProp( "nClrPen",      "Color Borde",  {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "nClrPane",     "Color Fondo",  {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "lTransparent", "Transparente", nil,                    "Apariencia" )
   ::AddProp( "lEnable"     , "Activado"    , nil,                    "Apariencia" )
   ::AddProp( "lBorder"     , "Borde"       , nil,                    "Apariencia" )

return 0

******************************************************************************************************************
      METHOD Load( cStr, lPaste, nPuntero ) CLASS TC5RptItemEllipse
******************************************************************************************************************
local nLen
DEFAULT lPaste := .f.

    ::aCoords[1]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nTop
    ::aCoords[2]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nLeft
    ::aCoords[3]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nBottom
    ::aCoords[4]   := val( substr( cStr, nPuntero, 4 ))                   ; nPuntero += 4      // nRight
    if lPaste
       ::aCoords[ 1] += 20
       ::aCoords[ 2] += 20
       ::aCoords[ 3] += 20
       ::aCoords[ 4] += 20
    endif
    ::nPen         := val( substr( cStr, nPuntero, 2 ) )                  ; nPuntero += 2      //::nPen
    ::nClrPen      := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPen
    ::nClrPane      := val( substr( cStr, nPuntero, 8 ) )                 ; nPuntero += 8      //::nClrPane
    ::lTransparent  :=  if( substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::lBorder       :=  if( substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lBorder
    ::lEnable       :=  if( substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lBorder

    if lPaste
       ::nID        := ::GetNewID()
    else
       ::nID      := val( substr( cStr, nPuntero, 4 ) )
    endif

    nPuntero += 4

   ::lFromNew := .f.
   ::CreateProps()

return self

******************************************************************************************************************
      METHOD Save() CLASS TC5RptItemEllipse
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
cStr += ( if( ::lBorder,  ".t.",".f.") )
cStr += ( if( ::lEnable,  ".t.",".f.") )
cStr += ( str(::nID, 4)                     )

return cStr

******************************************************************************************************************
      METHOD SaveToIni( oIni, n )  CLASS TC5RptItemEllipse
******************************************************************************************************************
local cStr := ""
local cItem := "Item" + alltrim(str(n))

cStr += "["+cItem+"]"                                            + CRLF
cStr += "Type="         + "Ellipse"                              + CRLF
cStr += "nTop="         + strtrim(::aCoords[1])                  + CRLF
cStr += "nLeft="        + strtrim(::aCoords[2])                  + CRLF
cStr += "nWidth="       + strtrim(::aCoords[4]-::aCoords[2])     + CRLF
cStr += "nHeight="      + strtrim(::aCoords[3]-::aCoords[1])     + CRLF
cStr += "nPen="         + strtrim(::nPen)                        + CRLF
cStr += "nClrPen="      + strtrim(::nClrPen)                     + CRLF
cStr += "nClrPane="     + strtrim(::nClrPane)                    + CRLF
cStr += "lTransparent=" + if( ::lTransparent,"Yes","No")         + CRLF
cStr += "lBorder="      + if( ::lBorder,"Yes","No")              + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF+ CRLF

return cStr

******************************************************************************************************************
      METHOD SaveToXML( oIni, n )  CLASS TC5RptItemEllipse
******************************************************************************************************************

local buffer :=""

buffer += '<Item Name="Ellipse"' +' Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <nTop>'         + alltrim(str(::aCoords[1]))              + '</nTop>'         + CRLF
buffer += '   <nLeft>'        + alltrim(str(::aCoords[2]))              + '</nLeft>'        + CRLF
buffer += '   <nWidth>'       + alltrim(str(::aCoords[4]-::aCoords[2])) + '</nWidth>'       + CRLF
buffer += '   <nHeight>'      + alltrim(str(::aCoords[3]-::aCoords[1])) + '</nHeight>'      + CRLF
buffer += '   <nPen>'         + alltrim(str(::nPen))                    + '</nPen>'         + CRLF
buffer += '   <nClrPen>'      + alltrim(str(::nClrPen))                 + '</nClrPen>'      + CRLF
buffer += '   <nClrPane>'     + alltrim(str(::nClrPane))                + '</nClrPane>'     + CRLF
buffer += '   <lTransparent>' + if( ::lTransparent,"Yes","No")          + '</lTransparent>' + CRLF
buffer += '   <lBorder>'      + if( ::lBorder,"Yes","No")               + '</lBorder>'      + CRLF
buffer += '   <lEnable>'      + if( ::lEnable,"Yes","No")               + '</lEnable>'      + CRLF
buffer += '   <nID>'          + alltrim(str(::nID))                     + '</nID>'          + CRLF
buffer += '</Item>'                                                                        + CRLF

return buffer



******************************************************************************************************************
      METHOD LoadIni( oIni, cItem ) CLASS TC5RptItemEllipse
******************************************************************************************************************
local lTransparent, lRoundRect, lBorder, nW, nH, lEnable


  GET ::aCoords[1]                             SECTION cItem    ENTRY "nTop"         OF oIni DEFAULT 0
  GET ::aCoords[2]                             SECTION cItem    ENTRY "nLeft"        OF oIni DEFAULT 0
  GET nW                                       SECTION cItem    ENTRY "nWidth"       OF oIni DEFAULT 0
  GET nH                                       SECTION cItem    ENTRY "nHeight"      OF oIni DEFAULT 0
  GET ::nPen                                   SECTION cItem    ENTRY "nPen"         OF oIni DEFAULT 0
  GET ::nClrPen                                SECTION cItem    ENTRY "nClrPen"      OF oIni DEFAULT 0
  GET ::nClrPane                               SECTION cItem    ENTRY "nClrPane"     OF oIni DEFAULT 0
  GET       lTransparent                       SECTION cItem    ENTRY "lTransparent" OF oIni DEFAULT ""
  GET       lBorder                            SECTION cItem    ENTRY "lBorder"      OF oIni DEFAULT ""
  GET       lEnable                            SECTION cItem    ENTRY "lEnable"      OF oIni DEFAULT ""
  GET ::nID                                    SECTION cItem    ENTRY "nID"          OF oIni DEFAULT 0

  ::aCoords[3] := ::aCoords[1] + nH
  ::aCoords[4] := ::aCoords[2] + nW


  ::lTransparent := lTransparent == "Yes"
  ::lBorder      := lBorder      == "Yes"
  ::lEnable      := lEnable      == "Yes"

  ::CreateProps()

return self



******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemEllipse
******************************************************************************************************************

 local nMode
 local nT := ::nTop      + ::oWnd:nRTop
 local nL := ::nLeft     + ::oWnd:nRLeft
 local nB := ::nBottom   + ::oWnd:nRTop
 local nR := ::nRight    + ::oWnd:nRLeft
 local hPen
 local hOldPen
 local hBrush
 local hOldBrush
 local nH := ::nHeight
 local nW := ::nWidth

 if ::lMoviendo
    return Ellipse( hDC, nL,nT,nL+nW,nT+nH )
    return super:Paint( hDC )
 endif

 hPen    := CreatePen( PS_SOLID, ::nPen * ::oWnd:nZoom/100, ::nClrPen )
 hOldPen := SelectObject( hDC, hPen )
 hBrush  := CreateSolidBrush( ::nClrPane )

 if ::lTransparent
    hOldBrush := SelectObject( hDC, GetStockObject( 5 ))
 else
    hOldBrush := SelectObject( hDC, hBrush )
 endif

 Ellipse( hDC, nL,nT,nL+nW,nT+nH )

 SelectObject( hDC, hOldBrush )
 DeleteObject( hBrush )
 SelectObject( hDC, hOldPen )
 DeleteObject( hPen )


 if !::oWnd:lCaptured
   ::PaintPts( hDC )
 endif

return nil






******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemEllipse
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cortar"                ACTION ::oWnd:Cut()
   MENUITEM "Copiar"                ACTION ::oWnd:Copy()
   MENUITEM "Paste"                 ACTION ::oWnd:Paste()
   MENUITEM "Deshabilitar"          ACTION (::lEnable := .f., ::oWnd:Refresh())
   MENUITEM "Transparente"          ACTION (::lTransparent := !::lTransparent, ::oWnd:Refresh())
   MENUITEM "Color de línea"        ACTION (::nClrPen  := ChooseColor( ::nClrPen ), ::oWnd:Refresh())
   MENUITEM "Color de fondo"        ACTION (::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0


******************************************************************************************************************
      METHOD IsOver  ( nRow, nCol )    CLASS TC5RptItemEllipse
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

return  PtInRect( nRow, nCol, {nTop,nLeft,nBottom,nRight} )

******************************************************************************************************************
   METHOD nRadio( nValue )    CLASS TC5RptItemEllipse
******************************************************************************************************************

if valtype( nValue ) == "C"; nValue := val( nValue ); endif

if nValue != nil
   if nValue > 0
      ::aCoords[3] := ::aCoords[1]+nValue
      ::aCoords[4] := ::aCoords[2]+nValue
   endif
endif

return max(::aCoords[4]-::aCoords[2],::aCoords[3]-::aCoords[1])

******************************************************************************************************************
      METHOD SetPropertyMain()    CLASS TC5RptItemEllipse
******************************************************************************************************************


return 0



