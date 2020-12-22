#include "fivewin.ch"
#include "c5report.ch"

CLASS TC5RptItemLine FROM TC5RptItem

      DATA cBmp
      DATA lxVertical
      DATA lxFree
      DATA nClrPen AS NUMERIC INIT CLR_BLACK
      DATA lPuntos AS LOGICAL INIT .F.
      DATA hRegion
      DATA nType              INIT C5LINE

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lVertical, lFree, lEnable ) CONSTRUCTOR
      METHOD Load( cStr, lPaste, nPuntero ) CONSTRUCTOR
      METHOD LoadIni( oIni, cItem ) CONSTRUCTOR

      METHOD Paint( hDC )
      METHOD CreaRegion( hDC )

      METHOD Save()
      METHOD SaveToIni( oIni )
      METHOD SaveToXML( oIni )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD IsOver( nRow, nCol )
      METHOD lVertical( lValue ) SETGET
      METHOD lFree( lValue ) SETGET
      METHOD cItemName()  INLINE "Linea (" + alltrim(str( ::nID )) + ")"
      METHOD GetCoords()
      METHOD CreateProps()

ENDCLASS

****************************************************************************************************************************
  METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lVertical, lFree, lEnable ) CLASS TC5RptItemLine
****************************************************************************************************************************

   if nWidth == nil .or. nHeight == nil
      DEFAULT nWidth := 1
      DEFAULT nHeight := 300
   endif

   lVertical :=  nWidth < nHeight
   lFree     := .f.
   lEnable   := .t.

   ::oWnd       := oWnd
   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)
   ::lEnable    := lEnable
   ::nID        := ::GetNewID()
   ::cType      := "Línea"

   ::lxVertical := lVertical
   ::lxFree     := lFree
   ::lFree      := lFree
   ::lVertical  := lVertical

   ::CreateProps()

return self


******************************************************************************************************************
      METHOD CreateProps() CLASS TC5RptItemLine
******************************************************************************************************************

   ::AddProp( "nRealTop",     "Arriba",       nil,  "Posición" )
   ::AddProp( "nRealLeft",    "Izquierda",    nil,  "Posición" )
   ::AddProp( "nRealWidth",   "Ancho",        nil,  "Posición" )
   ::AddProp( "nRealHeight",  "Alto",         nil,  "Posición" )

   ::AddProp( "nPen",         "Grueso",       nil,                    "Apariencia" )
   ::AddProp( "nClrPen",      "Color Borde",  {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "lFree",        "Libre",        nil,                    "Apariencia" )
   ::AddProp( "lEnable",      "Activado",     nil,                    "Apariencia" )
   ::AddProp( "lVertical",    "Vertical",     nil,                    "Apariencia" )
   ::AddProp( "lPuntos",      "Punteado",     nil,                    "Apariencia" )

return 0

******************************************************************************************************************
      METHOD lFree( lValue ) CLASS TC5RptItemLine
******************************************************************************************************************

if lValue != nil

   if lValue
      ::aEnablePoints := {.t.,.f.,.f.,.f.,.t.,.f.,.f.,.f.}
   else
      if ::lVertical
         ::aCoords[4] := ::aCoords[2]
         ::aEnablePoints := {.f.,.t.,.f.,.f.,.f.,.t.,.f.,.f.}
      else
         ::aCoords[3] := ::aCoords[1]
         ::aEnablePoints := {.f.,.f.,.f.,.t.,.f.,.f.,.f.,.t.}
      endif
   endif
   ::lxFree := lValue
endif

return ::lxFree


******************************************************************************************************************
      METHOD lVertical( lValue ) CLASS TC5RptItemLine
******************************************************************************************************************
local nWidth
local nHeight

if lValue != nil
   nWidth  := ::aCoords[4]-::aCoords[2]
   nHeight := ::aCoords[3]-::aCoords[1]

   if lValue
      if !::lxVertical
         ::aCoords[3] := ::aCoords[1]+nWidth
         ::aCoords[4] := ::aCoords[2]
      endif
      //::aCoords[4] := ::aCoords[2]
      ::aEnablePoints := {.f.,.t.,.f.,.f.,.f.,.t.,.f.,.f.}
   else
      if ::lxVertical
         ::aCoords[3] := ::aCoords[1]
         ::aCoords[4] := ::aCoords[2]+nHeight
      endif
      ::aEnablePoints := {.f.,.f.,.f.,.t.,.f.,.f.,.f.,.t.}
   endif

   ::lxFree := .f.
   ::lxVertical := lValue

endif

return ::lxVertical


******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemLine
******************************************************************************************************************

 local nMode
 local nT := ::nTop      + ::oWnd:nRTop
 local nL := ::nLeft     + ::oWnd:nRLeft
 local nB := ::nBottom   + ::oWnd:nRTop
 local nR := ::nRight    + ::oWnd:nRLeft
 local hPen    := CreatePen( if(::lPuntos,PS_DOT,PS_SOLID), ::nPen * ::oWnd:nZoom/100, ::nClrPen )
 local hOldPen := SelectObject( hDC, hPen )
 local hBrush := CreateSolidBrush( ::nClrPen )

 if !::oWnd:lCaptured
   ::PaintPts( hDC )
 endif

 if ::hRegion != nil
    DeleteObject( ::hRegion )
 endif

 ::hRegion := ::CreaRegion( hDC, {nT,nL,nB,nR} )

 if ::lFree
    FillRgn( hDC, ::hRegion, hBrush )
 endif

 SelectObject( hDC, hOldPen )
 DeleteObject( hPen )
 DeleteObject( hBrush )


return nil

******************************************************************************************************************
      METHOD CreaRegion( hDC, rc ) CLASS TC5RptItemLine
******************************************************************************************************************
local nT, nL, nB,nR
local hRegion

nT := rc[1]
nL := rc[2]
nB := rc[3]
nR := rc[4]

BeginPath( hDC )

if ::lFree
   Moveto( hDC, rc[2], rc[1] )
   Lineto( hDC, rc[4], rc[3] )
else
   if ::lVertical
      Moveto( hDC, rc[2], rc[1] )
      Lineto( hDC, rc[2], rc[3] )
   else
      Moveto( hDC, rc[2], rc[1] )
      Lineto( hDC, rc[4], rc[1] )
   endif
endif

EndPath( hDC )
if ::lFree
   WidenPath( hDC )
else
   StrokePath( hDC )
endif

hRegion := PathToRegion( hDC )


return hRegion


******************************************************************************************************************
      METHOD IsOver  ( nRow, nCol )   CLASS TC5RptItemLine
******************************************************************************************************************
local nTop, nLeft, nBottom, nRight
local lRet := .f.

if !::lFree

   nTop    := (::aCoords[1] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
   nLeft   := (::aCoords[2] + ::oWnd:aCoords[2])*::oWnd:nZoom/100
   nBottom := (::aCoords[3] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
   nRight  := (::aCoords[4] + ::oWnd:aCoords[2])*::oWnd:nZoom/100


   do case
      case ::lVertical
           lRet := PtInRect( nRow, nCol, {nTop,nLeft-3,nBottom,nRight+3} )
      otherwise // línea horizontal
           lRet := PtInRect( nRow, nCol, {nTop-3,nLeft,nBottom+3,nRight} )
   endcase
   return ::lEnable .and. lRet
endif

return ::lEnable .and. PtInRegion( ::hRegion, nCol, nRow )



******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemLine
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cortar" ACTION ::oWnd:Cut()
   MENUITEM "Copiar" ACTION ::oWnd:Copy()
   MENUITEM "Pegar" ACTION ::oWnd:Paste()


   MENUITEM "Disable" ACTION (::lEnable := .f., ::oWnd:Refresh())
   MENUITEM "Vertical"   ACTION (::lVertical := .t., ::oWnd:Refresh())
   MENUITEM "Horizontal" ACTION (::lVertical := .f., ::oWnd:Refresh())
   MENUITEM "Libre"      ACTION (::lFree     := .t., ::oWnd:Refresh())

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0

******************************************************************************************************************
      METHOD Save() CLASS TC5RptItemLine
******************************************************************************************************************

local cStr


 cStr :=  str(::nType,3)
 cStr +=  str(::aCoords[1],4)
 cStr +=  str(::aCoords[2],4)
 cStr +=  str(::aCoords[3],4)
 cStr +=  str(::aCoords[4],4)
 cStr += ( str(::nPen,3))
 cStr += ( str(::nClrPen,8))
 cStr += ( str(::nClrPane,8))
 cStr += ( if( ::lVertical,".t.",".f."))
 cStr += ( if( ::lFree,".t.",".f."))
 cStr += ( if( ::lPuntos,".t.",".f."))
 cStr += ( if( ::lEnable,".t.",".f."))
 cStr += ( str(::nID,4))

return cStr

******************************************************************************************************************
      METHOD SaveToIni( oIni, n )  CLASS TC5RptItemLine
******************************************************************************************************************
local cStr := ""
local cItem := "Item" + alltrim(str(n))


cStr += "["+cItem+"]"                                            + CRLF
cStr += "Type="         + "Line"                                 + CRLF
cStr += "nTop="         + strtrim(::aCoords[1])                  + CRLF
cStr += "nLeft="        + strtrim(::aCoords[2])                  + CRLF
cStr += "nWidth="       + strtrim(::aCoords[4]-::aCoords[2])     + CRLF
cStr += "nHeight="      + strtrim(::aCoords[3]-::aCoords[1])     + CRLF
cStr += "nPen="         + strtrim(::nPen)                        + CRLF
cStr += "nClrPen="      + strtrim(::nClrPen)                     + CRLF
cStr += "nClrPane="     + strtrim(::nClrPane)                    + CRLF
cStr += "lVertical="    + if( ::lVertical,"Yes","No")            + CRLF
cStr += "lFree="        + if( ::lFree,"Yes","No")                + CRLF
cStr += "lPuntos="      + if( ::lPuntos,"Yes","No")              + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF+ CRLF

return cStr

******************************************************************************************************************
      METHOD SaveToXML( oIni, n )  CLASS TC5RptItemLine
******************************************************************************************************************

local buffer :=""


buffer += '<Item Name="Line"' +' Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <nTop>'         + alltrim(str(::aCoords[1]))              + '</nTop>'         + CRLF
buffer += '   <nLeft>'        + alltrim(str(::aCoords[2]))              + '</nLeft>'        + CRLF
buffer += '   <nWidth>'       + alltrim(str(::aCoords[4]-::aCoords[2])) + '</nWidth>'       + CRLF
buffer += '   <nHeight>'      + alltrim(str(::aCoords[3]-::aCoords[1])) + '</nHeight>'      + CRLF
buffer += '   <nPen>'         + alltrim(str(::nPen))                    + '</nPen>'         + CRLF
buffer += '   <nClrPen>'      + alltrim(str(::nClrPen))                 + '</nClrPen>'      + CRLF
buffer += '   <nClrPane>'     + alltrim(str(::nClrPane))                + '</nClrPane>'     + CRLF
buffer += '   <lVertical>'    + if( ::lVertical,"Yes","No")             + '</lVertical>'    + CRLF
buffer += '   <lFree>'        + if( ::lFree,"Yes","No")                 + '</lFree>'        + CRLF
buffer += '   <lPuntos>'      + if( ::lPuntos,"Yes","No")               + '</lPuntos>'      + CRLF
buffer += '   <lEnable>'      + if( ::lEnable,"Yes","No")               + '</lEnable>'      + CRLF
buffer += '   <nID>'          + alltrim(str(::nID))                     + '</nID>'          + CRLF
buffer += '</Item>'                                                                        + CRLF

return buffer


******************************************************************************************************************
      METHOD LoadIni( oIni, cItem ) CLASS TC5RptItemLine
******************************************************************************************************************
local lPuntos, lVertical, lFree, nW, nH, lEnable


  GET ::aCoords[1]                             SECTION cItem    ENTRY "nTop"         OF oIni DEFAULT 0
  GET ::aCoords[2]                             SECTION cItem    ENTRY "nLeft"        OF oIni DEFAULT 0
  GET nW                                       SECTION cItem    ENTRY "nWidth"       OF oIni DEFAULT 0
  GET nH                                       SECTION cItem    ENTRY "nHeight"      OF oIni DEFAULT 0
  GET ::nPen                                   SECTION cItem    ENTRY "nPen"         OF oIni DEFAULT 0
  GET ::nClrPen                                SECTION cItem    ENTRY "nClrPen"      OF oIni DEFAULT 0
  GET ::nClrPane                               SECTION cItem    ENTRY "nClrPane"     OF oIni DEFAULT 0
  GET       lVertical                          SECTION cItem    ENTRY "lVertical"    OF oIni DEFAULT ""
  GET       lFree                              SECTION cItem    ENTRY "lFree"        OF oIni DEFAULT ""
  GET       lPuntos                            SECTION cItem    ENTRY "lPuntos"      OF oIni DEFAULT ""
  GET       lEnable                            SECTION cItem    ENTRY "lEnable"      OF oIni DEFAULT ""
  GET ::nID                                    SECTION cItem    ENTRY "nID"          OF oIni DEFAULT 0

  ::aCoords[3] := ::aCoords[1] + nH
  ::aCoords[4] := ::aCoords[2] + nW

  ::lxVertical    := lVertical    == "Yes"
  ::lxFree        := lFree        == "Yes"
  ::lPuntos       := lPuntos      == "Yes"
  ::lEnable       := lEnable      == "Yes"

  if ::lxFree
     ::aEnablePoints := {.t.,.f.,.f.,.f.,.t.,.f.,.f.,.f.}
  else
    if ::lxVertical
       ::aEnablePoints := {.f.,.t.,.f.,.f.,.f.,.t.,.f.,.f.}
    else
       ::aEnablePoints := {.f.,.f.,.f.,.t.,.f.,.f.,.f.,.t.}
    endif
  endif

  ::CreateProps()

return self



******************************************************************************************************************
      METHOD Load( cStr, lPaste, nPuntero ) CLASS TC5RptItemLine
******************************************************************************************************************

local nLen

DEFAULT lPaste := .f.

    ::aCoords[ 1] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nTop
    ::aCoords[ 2] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nLeft
    ::aCoords[ 3] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nBottom
    ::aCoords[ 4] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nRight
    if lPaste
       ::aCoords[ 1] += 20
       ::aCoords[ 2] += 20
       ::aCoords[ 3] += 20
       ::aCoords[ 4] += 20
    endif

    ::nPen        := val( substr( cStr, nPuntero, 3 ) )                 ; nPuntero += 3      //
    ::nClrText    := val( substr( cStr, nPuntero, 8 ) )                 ; nPuntero += 8      //
    ::nClrPane    := val( substr( cStr, nPuntero, 8 ) )                 ; nPuntero += 8      //
    ::lxVertical  := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3
    ::lxFree      := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3
    ::lPuntos     := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3
    ::lEnable     := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3

    if ::lxFree
       ::aEnablePoints := {.t.,.f.,.f.,.f.,.t.,.f.,.f.,.f.}
    else
      if ::lxVertical
         ::aEnablePoints := {.f.,.t.,.f.,.f.,.f.,.t.,.f.,.f.}
      else
         ::aEnablePoints := {.f.,.f.,.f.,.t.,.f.,.f.,.f.,.t.}
      endif
    endif

    if lPaste
       ::nID        := ::GetNewID()
    else
       ::nID      := val( substr( cStr, nPuntero, 4 ) )
    endif

    nPuntero += 4      //
  ::CreateProps()

return self


******************************************************************************************************************
      METHOD GetCoords() CLASS TC5RptItemLine
******************************************************************************************************************

if ::lFree
   return ::aCoords
endif

if ::lVertical
   return {::aCoords[1], ::aCoords[2]-1, ::aCoords[3], ::aCoords[4]+1}
else
   return {::aCoords[1]-1, ::aCoords[2], ::aCoords[3]+1, ::aCoords[4]}
endif

return ::aCoords



