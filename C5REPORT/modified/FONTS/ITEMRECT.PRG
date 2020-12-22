#include "fivewin.ch"
#include "c5report.ch"

CLASS TC5RptItemRect FROM TC5RptItem

      DATA lxRoundRect   AS LOGICAL INIT .F.
      DATA nxRW          AS NUMERIC INIT 10
      DATA nxRH          AS NUMERIC INIT 10
      DATA nxPen         AS NUMERIC INIT 1
      DATA nxClrPen      AS NUMERIC INIT 0
      DATA lxTransparent AS LOGICAL INIT .T.
      DATA lxBorder      AS LOGICAL INIT .T.
      DATA nType                    INIT C5RECT
      DATA aEnablePoints AS ARRAY   INIT {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
      DATA nClrPane2
      DATA lGrad         AS LOGICAL INIT .F.
      DATA cTypeGrad     AS CHARACTER INIT "Horizontal"
      DATA lMidRound     AS LOGICAL INIT .F.
      DATA lOnlyCorners  AS LOGICAL INIT .F.

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CONSTRUCTOR
      METHOD Load( cStr, lPaste, nPuntero ) CONSTRUCTOR
      METHOD LoadIni( oIni, cItem ) CONSTRUCTOR

      METHOD Paint( hDC )
      METHOD Save()
      METHOD SaveToIni( oIni )
      METHOD SaveToXML( oIni )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD IsOver( nRow, nCol )

      METHOD lRoundRect   ( lValue ) SETGET
      METHOD nRW          ( NValue ) SETGET
      METHOD nRH          ( NValue ) SETGET
      METHOD nPen         ( NValue ) SETGET
      METHOD nClrPen      ( NValue ) SETGET
      METHOD lTransparent ( lValue ) SETGET
      METHOD lBorder      ( lValue ) SETGET
      METHOD cItemName()  INLINE "Rectángulo (" + alltrim(str( ::nID )) + ")"
      METHOD CreateProps()

ENDCLASS

****************************************************************************************************************************
  METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, lEnable ) CLASS TC5RptItemRect
****************************************************************************************************************************

   if nTop    == nil; nTop    := 0   ; endif
   if nLeft   == nil; nLeft   := 0   ; endif
   if lEnable == nil; lEnable := .t. ; endif

   DEFAULT nWidth := 150
   DEFAULT nHeight := 60

   ::oWnd       := oWnd
   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)
   ::lEnable    := lEnable
   ::nID        := ::GetNewID()
   ::cType      := "Rectángulo"
   ::lFromNew   := .f.
   ::nClrPane2  := ::nClrPane
   ::lGrad      := .f.
   ::cTypeGrad  := "Horizontal"
   ::CreateProps()

return self

******************************************************************************************************************
      METHOD CreateProps() CLASS TC5RptItemRect
******************************************************************************************************************

   ::AddProp( "nRealTop",     "Arriba",       nil,  "Posición" )
   ::AddProp( "nRealLeft",    "Izquierda",    nil,  "Posición" )
   ::AddProp( "nRealWidth",   "Ancho",        nil,  "Posición" )
   ::AddProp( "nRealHeight",  "Alto",         nil,  "Posición" )

   ::AddProp( "nPen",         "Grueso",       nil,                    "Apariencia" )
   ::AddProp( "nClrPen",      "Color Borde",  {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "nClrPane",     "Color Fondo",  {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "nClrPane2",    "Color Fondo2", {|n| ChooseColor(n) },  "Apariencia", ACCION )
   ::AddProp( "lTransparent", "Transparente", nil,                    "Apariencia" )
   ::AddProp( "lEnable"     , "Activado"    , nil,                    "Apariencia" )
   ::AddProp( "lBorder"     , "Borde"       , nil,                    "Apariencia" )
   ::AddProp( "lGrad"       , "Degradado"   , nil,                    "Apariencia" )
   ::AddProp( "cTypeGrad"   , "Tipo degradado", {|| {"Vertical","Horizontal"}},"Apariencia", LISTA )
   ::AddProp( "lRoundRect"  , "Redondeado"  , nil,                    "Apariencia" )
   ::AddProp( "lMidRound"   , "Mitad superior", nil,                  "Apariencia" )
   ::AddProp( "nRW" ,         "Ancho esquina", nil,                   "Apariencia" )
   ::AddProp( "nRH" ,         "Alto esquina", nil,                    "Apariencia" )
   ::AddProp( "lOnlyCorners", "Solo esquinas", nil,                   "Apariencia" )

return 0


******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemRect
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
 local oBrush
 local nClrPane2 := ::nClrPane2
 local nRadH := ::nRH* ::oWnd:nZoom/100
 local nRadW := ::nRW * ::oWnd:nZoom/100

 if ::lMoviendo
    return super:Paint( hDC )
 endif

 hPen    := ExtCreatePen( ::nPen * ::oWnd:nZoom/100, ::nClrPen )
 //hBrush  := CreateSolidBrush( ::nClrPane )
 if !::lGrad
    nClrPane2 := ::nClrPane
 endif

 if ::cTypeGrad == "Vertical"
    oBrush   := TBrushEx():New( 3, nB-nT, ::nClrPane, nClrPane2, .t. )
 else
    oBrush   := TBrushEx():New( nR-nL, 3, ::nClrPane, nClrPane2, .f. )
 endif

 if !::lBorder
    hOldPen := SelectObject( hDC, GetStockObject(8))
 else
    hOldPen := SelectObject( hDC, hPen )
 endif

 if ::lTransparent
    hOldBrush := SelectObject( hDC, GetStockObject( 5 ))
 else
    hOldBrush := SelectObject( hDC, oBrush:hBrush )
 endif

 SetBrushOrg( hDC, oBrush:hBrush, nL, nT )

 if ::lRoundRect
    if ::lMidRound
       MidRoundRect( hDC, {nT, nL, nB, nR}, nRadW )
    else
       RoundRect( hDC, nT, nL, nB, nR, nRadW, nRadH )
    endif
 else
    if ::lOnlyCorners

       if !::lTransparent
          FillRect( hDC, {nT, nL, nB, nR},oBrush:hBrush )
       endif

       BeginPath( hDC )

       MoveTo( hDC, nL,       nT+nRadH )
       LineTo( hDC, nL,       nT )
       LineTo( hDC, nL+nRadW, nT )

       MoveTo( hDC, nR-nRadW, nT )
       LineTo( hDC, nR,       nT )
       LineTo( hDC, nR,       nT+nRadH )

       MoveTo( hDC, nR, nB-nRadH )
       LineTo( hDC, nR, nB )
       LineTo( hDC, nR-nRadW, nB )

       MoveTo( hDC, nL, nB-nRadH )
       LineTo( hDC, nL, nB )
       LineTo( hDC, nL+nRadW, nB )

       EndPath( hDC )
       StrokePath( hDC )

    else
       Rectangle( hDC, nT, nL, nB, nR )
    endif
 endif

 SelectObject( hDC, hOldBrush )
 //DeleteObject( hBrush )
 oBrush: End()

 SelectObject( hDC, hOldPen )
 DeleteObject( hPen )


 if !::oWnd:lCaptured
   ::PaintPts( hDC )
 endif

return nil



******************************************************************************************************************
      METHOD IsOver  ( nRow, nCol )   CLASS TC5RptItemRect
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

return  PtInRect( nRow, nCol, {nTop,nLeft,nBottom,nRight} ) .and.;
        if( !::lTransparent,.t., !PtInRect( nRow, nCol, {nTop+5,nLeft+5,nBottom-5,nRight-5} ))




******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemRect
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cortar"                ACTION ::oWnd:Cut()
   MENUITEM "Copiar"                ACTION ::oWnd:Copy()
   MENUITEM "Paste"                 ACTION ::oWnd:Paste()

   MENUITEM "Deshabilitar"          ACTION (::lEnable := .f., ::oWnd:Refresh())

   MENUITEM "Transparente"          ACTION (::lTransparent := !::lTransparent, ::oWnd:Refresh())
   MENUITEM "Esquinas redondeadas"  ACTION (::lRoundRect := !::lRoundRect, ::oWnd:Refresh())
   MENUITEM "Color de línea"        ACTION (::nClrPen  := ChooseColor( ::nClrPen ), ::oWnd:Refresh())
   MENUITEM "Color de fondo"        ACTION (::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0

******************************************************************************************************************
      METHOD Save( ) CLASS TC5RptItemRect
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
cStr += ( if( ::lRoundRect,  ".t.",".f.") )
cStr += ( if( ::lBorder,  ".t.",".f.") )
cStr += ( str(::nRW, 3)                     )
cStr += ( str(::nRH, 3)                     )
cStr += ( str(::nClrPane2,8)                )
cStr += ( if( ::lGrad,  ".t.",".f.") )
cStr += ( str( len(::cTypeGrad) ,2 )+ ::cTypeGrad  )
cStr += ( if( ::lMidRound,  ".t.",".f.") )
cStr += ( if( ::lOnlyCorners,  ".t.",".f.") )
cStr += ( if( ::lEnable,  ".t.",".f.") )
cStr += ( str(::nID, 4)                     )

return cStr

******************************************************************************************************************
      METHOD SaveToIni( oIni, n )  CLASS TC5RptItemRect
******************************************************************************************************************
local cStr := ""
local cItem := "Item" + alltrim(str(n))


cStr += "["+cItem+"]"                                            + CRLF
cStr += "Type="         + "Rectangle"                            + CRLF
cStr += "nTop="         + strtrim(::aCoords[1])                  + CRLF
cStr += "nLeft="        + strtrim(::aCoords[2])                  + CRLF
cStr += "nWidth="       + strtrim(::aCoords[4]-::aCoords[2])     + CRLF
cStr += "nHeight="      + strtrim(::aCoords[3]-::aCoords[1])     + CRLF
cStr += "nPen="         + strtrim(::nPen)                        + CRLF
cStr += "nClrPen="      + strtrim(::nClrPen)                     + CRLF
cStr += "nClrPane="     + strtrim(::nClrPane)                    + CRLF
cStr += "lTransparent=" + if( ::lTransparent,"Yes","No")         + CRLF
cStr += "lRoundRect="   + if( ::lRoundRect,"Yes","No")           + CRLF
cStr += "lBorder="      + if( ::lBorder,"Yes","No")              + CRLF
cStr += "nRadioW="      + strtrim(::nRW)                         + CRLF
cStr += "nRadioH="      + strtrim(::nRW)                         + CRLF
cStr += "nClrPane2="    + strtrim(::nClrPane2)                   + CRLF
cStr += "lGrad="        + if( ::lGrad,"Yes","No")                + CRLF
cStr += "cTypeGrad="    + ::cTypeGrad                            + CRLF
cStr += "lMidRound="    + if( ::lMidRound,"Yes","No")            + CRLF
cStr += "lOnlyCorners=" + if( ::lOnlyCorners,"Yes","No")         + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF+ CRLF

return cStr

******************************************************************************************************************
      METHOD SaveToXML( oIni, n )  CLASS TC5RptItemRect
******************************************************************************************************************

local buffer :=""


buffer += '<Item Name="Rectangle"' +' Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <nID>'          + alltrim(str(::nID))                     + '</nID>'          + CRLF
buffer += '   <nTop>'         + alltrim(str(::aCoords[1]))              + '</nTop>'         + CRLF
buffer += '   <nLeft>'        + alltrim(str(::aCoords[2]))              + '</nLeft>'        + CRLF
buffer += '   <nWidth>'       + alltrim(str(::aCoords[4]-::aCoords[2])) + '</nWidth>'       + CRLF
buffer += '   <nHeight>'      + alltrim(str(::aCoords[3]-::aCoords[1])) + '</nHeight>'      + CRLF
buffer += '   <nPen>'         + alltrim(str(::nPen))                    + '</nPen>'         + CRLF
buffer += '   <nClrPen>'      + alltrim(str(::nClrPen))                 + '</nClrPen>'      + CRLF
buffer += '   <nClrPane>'     + alltrim(str(::nClrPane))                + '</nClrPane>'     + CRLF
buffer += '   <lTransparent>' + if( ::lTransparent,"Yes","No")          + '</lTransparent>' + CRLF
buffer += '   <lRoundRect>'   + if( ::lRoundRect,"Yes","No")            + '</lRoundRect>'   + CRLF
buffer += '   <lBorder>'      + if( ::lBorder,"Yes","No")               + '</lBorder>'      + CRLF
buffer += '   <nRadioW>'      + alltrim(str(::nRW))                     + '</nRadioW>'      + CRLF
buffer += '   <nRadioH>'      + alltrim(str(::nRH))                     + '</nRadioH>'      + CRLF
buffer += '   <nClrPane2>'    + alltrim(str(::nClrPane2))               + '</nClrPane2>'    + CRLF
buffer += '   <lGrad>'        + if( ::lGrad,"Yes","No")                 + '</lGrad>'        + CRLF
buffer += '   <cTypeGrad>'    + ::cTypeGrad                             + '</cTypeGrad>'    + CRLF
buffer += '   <lMidRound>'    + if( ::lMidRound,"Yes","No")             + '</lMidRound>'    + CRLF
buffer += '   <lOnlyCorners>' + if( ::lOnlyCorners,"Yes","No")          + '</lOnlyCorners>' + CRLF
buffer += '   <lEnable>'      + if( ::lEnable,"Yes","No")               + '</lEnable>' + CRLF
buffer += '</Item>'                                                                         + CRLF

return buffer


******************************************************************************************************************
      METHOD LoadIni( oIni, cItem ) CLASS TC5RptItemRect
******************************************************************************************************************
local lEnable, lOnlyCorners, lTransparent, lRoundRect, lBorder, lGrad, lMidRound, nW, nH

  GET ::aCoords[1]                             SECTION cItem    ENTRY "nTop"         OF oIni DEFAULT 0
  GET ::aCoords[2]                             SECTION cItem    ENTRY "nLeft"        OF oIni DEFAULT 0
  GET nW                                       SECTION cItem    ENTRY "nWidth"       OF oIni DEFAULT 0
  GET nH                                       SECTION cItem    ENTRY "nHeight"      OF oIni DEFAULT 0
  GET ::nPen                                   SECTION cItem    ENTRY "nPen"         OF oIni DEFAULT 0
  GET ::nClrPen                                SECTION cItem    ENTRY "nClrPen"      OF oIni DEFAULT 0
  GET ::nClrPane                               SECTION cItem    ENTRY "nClrPane"     OF oIni DEFAULT 0
  GET       lTransparent                       SECTION cItem    ENTRY "lTransparent" OF oIni DEFAULT ""
  GET       lRoundRect                         SECTION cItem    ENTRY "lRoundRect"   OF oIni DEFAULT ""
  GET       lBorder                            SECTION cItem    ENTRY "lBorder"      OF oIni DEFAULT ""
  GET ::nRW                                    SECTION cItem    ENTRY "nRadioW"      OF oIni DEFAULT 0
  GET ::nRH                                    SECTION cItem    ENTRY "nRadioH"      OF oIni DEFAULT 0
  GET ::nClrPane2                              SECTION cItem    ENTRY "nClrPane2"    OF oIni DEFAULT 0
  GET       lGrad                              SECTION cItem    ENTRY "lGrad"        OF oIni DEFAULT ""
  GET ::cTypeGrad                              SECTION cItem    ENTRY "cTypeGrad"    OF oIni DEFAULT ""
  GET   lMidRound                              SECTION cItem    ENTRY "lMidRound"    OF oIni DEFAULT ""
  GET   lOnlyCorners                           SECTION cItem    ENTRY "lOnlyCorners" OF oIni DEFAULT ""
  GET   lEnable                                SECTION cItem    ENTRY "lEnable"      OF oIni DEFAULT ""
  GET ::nID                                    SECTION cItem    ENTRY "nID"          OF oIni DEFAULT 0

  ::aCoords[3] := ::aCoords[1] + nH
  ::aCoords[4] := ::aCoords[2] + nW

  ::lxTransparent := lTransparent == "Yes"
  ::lxRoundRect   := lRoundRect   == "Yes"
  ::lxBorder      := lBorder      == "Yes"
  ::lGrad         := lGrad        == "Yes"
  if empty(::cTypeGrad)
     ::cTypeGrad := "Horizontal"
  endif
  ::lMidRound     := lMidRound    == "Yes"
  ::lOnlyCorners  := lOnlyCorners == "Yes"
  ::lEnable       := lEnable      == "Yes"

  ::CreateProps()

return self



******************************************************************************************************************
      METHOD Load( cStr, lPaste, nPuntero ) CLASS TC5RptItemRect
******************************************************************************************************************
local nLen
local cVersion := ReportVersion()
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

    ::nxPen         := val( substr( cStr, nPuntero, 2 ) )                  ; nPuntero += 2      //::nPen
    ::nxClrPen      := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPen
    ::nClrPane      := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPane
    ::lxTransparent :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::lxRoundRect   :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::lxBorder      :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::nxRW          := val( substr( cStr, nPuntero, 3 ) )                  ; nPuntero += 3      //::nPen
    ::nxRH          := val( substr( cStr, nPuntero, 3 ) )                  ; nPuntero += 3      //::nPen

    ::nClrPane2     := val( substr( cStr, nPuntero, 8 ) )                  ; nPuntero += 8      //::nClrPane
    ::lGrad         := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)  ; nPuntero += 3      //::lTransparent
    nLen            := val( substr( cStr, nPuntero, 2 ))                   ; nPuntero += 2
    ::cTypeGrad     := substr( cStr, nPuntero ,nLen )                      ; nPuntero += nLen
    ::lMidRound     :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::lOnlyCorners  :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent
    ::lEnable       :=  if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.) ; nPuntero += 3      //::lTransparent


    if lPaste
       ::nID        := ::GetNewID()
    else
       ::nID      := val( substr( cStr, nPuntero, 4 ) )
    endif

    nPuntero += 4      //

   ::lFromNew := .f.

   ::CreateProps()

return self




******************************************************************************************************************
   METHOD lRoundRect   ( lValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if lValue != nil
   ::lxRoundRect := lValue
endif
return ::lxRoundRect

******************************************************************************************************************
   METHOD nRW( nValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if nValue != nil
   ::nxRW := nValue
endif
return ::nxRW

******************************************************************************************************************
   METHOD nRH( nValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if nValue != nil
   ::nxRH := nValue
endif
return ::nxRH

******************************************************************************************************************
   METHOD nPen( nValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if nValue != nil
   ::nxPen := nValue
endif
return ::nxPen

******************************************************************************************************************
   METHOD nClrPen( nValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if nValue != nil
   ::nxClrPen := nValue
endif
return ::nxClrPen

******************************************************************************************************************
   METHOD lTransparent ( lValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if lValue != nil
   ::lxTransparent := lValue
endif
return ::lxTransparent

******************************************************************************************************************
   METHOD lBorder ( lValue ) CLASS TC5RptItemRect
******************************************************************************************************************

if lValue != nil
   ::lxBorder := lValue
endif
return ::lxBorder

