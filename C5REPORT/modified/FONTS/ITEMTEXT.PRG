#include "fivewin.ch"
#include "c5report.ch"


CLASS TC5RptItemText FROM TC5RptItem

      DATA nxAlign       AS NUMERIC INIT 1
      DATA cCaption
      DATA nColor
      DATA nHText        AS NUMERIC INIT 0
      DATA cFaceName
      DATA nWFont        AS NUMERIC INIT 0
      DATA nHFont
      DATA lUnder
      DATA lBold
      DATA lItalic
      DATA lStrike
      DATA nClrText      AS NUMERIC INIT CLR_BLACK
      DATA aEnablePoints AS ARRAY   INIT {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
      DATA nType                    INIT C5TEXTO


      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cCaption, nClrText, nClrPane, cFaceName, nWFont, nHFont, lBold,;
                  lItalic, lStrike, lEnable ) CONSTRUCTOR

      METHOD Load( cStr, lPaste, nPuntero ) CONSTRUCTOR
      METHOD LoadIni( oIni, cItem ) CONSTRUCTOR

      METHOD Paint( hDC )
      METHOD EditText( )
      METHOD Save()
      METHOD SaveToIni( lForeGroune, oIni)
      METHOD SaveToXML( lForeGroune, oIni)

      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD SelectFont()
      METHOD cItemName()      INLINE "Texto (" + alltrim(str( ::nID )) + ")"
      METHOD nAlign( nValue ) SETGET
      METHOD cAlign()         INLINE {"Izquierda","Centro","Derecha","Multilinea"}[::nAlign]
      METHOD IncFont()        INLINE ::nHFont+=1, ::Refresh()
      METHOD DecFont()        INLINE ::nHFont := max( ::nHFont-1, 4 ), ::Refresh()
      METHOD GetTextLenght()
      METHOD GetType()        INLINE ::cType
      METHOD GetID()          INLINE ::nID
      METHOD CreateProps()

ENDCLASS


******************************************************************************************************************************
      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cCaption, nClrText, nClrPane, cFaceName, nWFont, nHFont, lBold,;
                  lUnder, lItalic, lStrike, lEnable ) CLASS TC5RptItemText
******************************************************************************************************************

   if cCaption   == nil; cCaption   := " "      ; endif
   if lEnable    == nil; lEnable    :=       .t.; endif
   if cFaceName  == nil; cFaceName  := "Verdana"; endif
   if nWFont     == nil; nWFont     := 0        ; endif
   if nHFont     == nil; nHFont     := 11       ; endif
   if lBold      == nil; lBold      := .f.      ; endif
   if lUnder     == nil; lUnder     := .f.      ; endif
   if lItalic    == nil; lItalic    := .f.      ; endif
   if lStrike    == nil; lStrike    := .f.      ; endif
   if lEnable    == nil; lEnable    := .f.      ; endif

   if lFixed()
      cFaceName  :=  oReport():cFaceName
      nHFont     :=  oReport():nHFont
      lBold      :=  oReport():lBold
      lUnder     :=  oReport():lUnder
      lItalic    :=  oReport():lItalic
      lStrike    :=  oReport():lStrike
      ::nClrText :=  oReport():nxClrText
      ::nClrPane :=  oReport():nxClrPane
   endif

Dbg( 'cFaceName ' , cFaceName )
Dbg( 'nWFont ' , cValToChar(nWFont))
Dbg( 'nHFont ' , cValToChar(nHFont))

   DEFAULT nWidth  := 150
   DEFAULT nHeight := 24

   ::oWnd       := oWnd

   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)

Dbg( '::aCoords[1] ' + cValToChar(::aCoords[1] ) + CRLF + ;
     '::aCoords[2] ' + cValToChar(::aCoords[2] ) + CRLF + ;
     '::aCoords[3] ' + cValToChar(::aCoords[3] ) + CRLF + ;
     '::aCoords[4] ' + cValToChar(::aCoords[4] ) )


   ::cCaption   := cCaption
   ::lEnable    := lEnable
   ::cFaceName  := cFaceName
   ::nWFont     := nWFont
   ::nHFont     := nHFont
   ::lUnder     := lUnder
   ::lBold      := lBold
   ::lItalic    := lItalic
   ::lStrike    := lStrike
   ::cType      := "Texto"

   ::nID        := ::GetNewID()

   if at( CRLF, ::cCaption ) != 0
      ::nAlign := 4
   endif

   ::CreateProps()



return self

******************************************************************************************************************
      METHOD CreateProps() CLASS TC5RptItemText
******************************************************************************************************************


   ::AddProp( "nRealTop",     "Arriba",       nil,  "Posición" )
   ::AddProp( "nRealLeft",    "Izquierda",    nil,  "Posición" )
   ::AddProp( "nRealWidth",   "Ancho",        nil,  "Posición" )
   ::AddProp( "nRealHeight",  "Alto",         nil,  "Posición" )

   ::AddProp( "cCaption",     "Texto",        {|c|EditText(c)},  "Apariencia", ACCION )
   ::AddProp( "nClrText",     "Color Texto",  {||ChooseColor()}, "Apariencia", ACCION )
   ::AddProp( "nClrPane",     "Color Fondo",  {||ChooseColor()}, "Apariencia", ACCION )
   ::AddProp( "lTransparent", "Transparente", nil,               "Apariencia" )
   ::AddProp( "lEnable"     , "Activado"    , nil,               "Apariencia" )
   ::AddProp( "nAlign"      , "Alineación"  , nil,               "Apariencia" )
   ::AddProp( "nGiro"       , "Giro"        , nil,               "Apariencia" )

   ::AddProp( "cFaceName"   , "Tipo letra"  , {||C5GetFontNames()}, "Fuente", LISTA )
   ::AddProp( "nHFont"      , "Altura"      , nil,                  "Fuente" )
   ::AddProp( "lItalic"     , "Cursiva"     , nil,                  "Fuente" )
   ::AddProp( "lUnder"      , "Subrayado"   , nil,                  "Fuente" )
   ::AddProp( "lStrike"     , "Tachado"     , nil,                  "Fuente" )
   ::AddProp( "lBold"       , "Negrita"     , nil,                  "Fuente" )

return 0

******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItemText
******************************************************************************************************************

 local hFont
 local hOldFont
 local nMode
 local nT         := ::nTop      + ::oWnd:nRTop
 local nL         := ::nLeft     + ::oWnd:nRLeft
 local nB         := ::nBottom   + ::oWnd:nRTop
 local nR         := ::nRight    + ::oWnd:nRLeft
 local nRet
 local hPenDotted
 local hOldPen
 local nColor
 local oFont := TFont():New( ::cFaceName,;
          0,;
          -::nHFont*::oWnd:nZoom/100,;
          .f.,;
          ::lBold,;
          ::nGiro*10,;
          0,;
          0,;
          ::lItalic,;
          ::lUnder,;
          ::lStrike,;
          0,;
          0,;
          0,;
          0 )


Dbg( 'PINTO TEXTE'                +                 CRLF + ;
     'cFaceName '                 + cValToChar(::cFaceName                  ) + CRLF +;
     'nHFont '                    + cValToChar(::nHFont                     ) + CRLF +;
     'oWnd:nZoom '                + cValToChar(::oWnd:nZoom                 ) + CRLF +;
     '-::nHFont*::oWnd:nZoom/100' + cValToChar(-::nHFont*::oWnd:nZoom/100 ) )


 if ::lMoviendo
    return super:Paint( hDC )
 endif

 if ::nGiro != 0
    nB := ((::aCoords[1]+20) * ::oWnd:nZoom/100) + ::oWnd:nRTop
    nR := ((::aCoords[2]+20) * ::oWnd:nZoom/100) + ::oWnd:nRLeft
 endif

 //hFont  := CreateFont( { -::nHFont * ::oWnd:nZoom/100,;
 //                        0,; //::nWFont * ::oWnd:nZoom/100
 //                         ::nGiro*10,0, if(::lBold,700,400), ::lItalic,::lUnder,::lStrike, 0, 0, 0, 0, 0, ::cFaceName } )


 hOldFont := SelectObject( hDC, oFont:hFont )
 nMode    := SetBkMode   ( hDC, 1 )
 nColor   := SetTextColor( hDC, ::nClrText )

 //if ::nGiro != 0
 //   nRet := Begin_rotate( hDC, 360-::nGiro, nT, nL )
 //endif

 if !::lTransparent
    FillSolidRect( hDC, {nT, nL, nB, nR}, ::nClrPane )
 endif

 //DrawText( hDC, ::cCaption, {nT, nL, nB, nR}, DT_NOCLIP )
 DrawText( hDC, ::cCaption, {nT, nL, nB, nR}, if( ::nAlign != 4,36,0) + {DT_LEFT,DT_CENTER,DT_RIGHT,0}[::nAlign]+DT_NOCLIP  )

 //if ::nGiro != 0
 //   End_Rotate( hDC, nRet )
 //endif

 SetBkMode( hDC, nMode )
 SetTextColor( hDC, nColor )
 SelectObject( hDC, hOldFont  )
 //DeleteObject( hFont )
 oFont:End()

 if Empty( ::cCaption  ) .or. ::nGiro != 0 .or. (::oWnd:oSelected != nil .and. ::oWnd:oSelected:nID == ::nID)
    hPenDotted := CreatePen( 2, 1, RGB(201,201,201) )
    hOldPen := SelectObject( hDC, hPenDotted )
    Moveto( hDC, nL, nT )
    Lineto( hDC, nR, nT )
    Lineto( hDC, nR, nB )
    Lineto( hDC, nL, nB )
    Lineto( hDC, nL, nT )
    SelectObject( hDC, hOldPen )
    DeleteObject( hPenDotted )
 endif



 if ::nGiro == 0
    ::PaintPts( hDC )
 endif

return nil

******************************************************************************************************************
      METHOD EditText()   CLASS TC5RptItemText
******************************************************************************************************************
local cOldVar
local rc
local cText := ::cCaption
local oFont
local o := self
local lOk := .f.
local oDlg
local cVar1 := padr( ::cCaption, 1000 )
local oGet1
local oBtn1
local oBtn2
local oBtn3

DEFINE DIALOG oDlg ;
       FROM 259, 146 TO 611, 744 PIXEL ;
       TITLE "Editar texto"

       @ 25, 28 GET oGet1 VAR cVar1 ;
             SIZE 249, 105 PIXEL OF oDlg MULTILINE

       @ 143, 153 BUTTON oBtn1 PROMPT "Aceptar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (lOk := .t., oDlg:End())

       @ 143, 199 BUTTON oBtn2 PROMPT "Cancelar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (oDlg:End())

       @ 143, 244 BUTTON oBtn3 PROMPT "Ayuda" ;
             SIZE 44, 12 PIXEL OF oDlg

ACTIVATE DIALOG oDlg CENTERED


if lOk
   ::cCaption := cVar1
   ::oWnd:Refresh()
endif




return ::cCaption

******************************************************************************************************************
      METHOD Save() CLASS TC5RptItemText
******************************************************************************************************************

local cStr



 cStr := str(::nType,3)
 cStr += str(::aCoords[1],4)
 cStr += str(::aCoords[2],4)
 cStr += str(::aCoords[3],4)
 cStr += str(::aCoords[4],4)
 cStr += ( str( len(::cCaption) ,5 )+ ::cCaption  )
 cStr += ( str( len(::cFaceName),3 )+ ::cFaceName ) // cStr += ( str(::nWFont, 5) )
 cStr += ( str(::nHFont, 5) )
 cStr += ( if( ::lUnder,        ".t.",".f.") )
 cStr += ( if( ::lBold,         ".t.",".f.") )
 cStr += ( if( ::lItalic,       ".t.",".f.") )
 cStr += ( if( ::lTransparent,  ".t.",".f.") )
 cStr += ( str(::nClrText,8)                 )
 cStr += ( str(::nClrPane,8)                 )
 cStr += ( str(::nGiro,3)                    )
 cStr += ( str(::nAlign,1)                   )
 cStr += ( if( ::lEnable,       ".t.",".f.") )
 cStr += ( str(::nID,4)                      )


return cStr

******************************************************************************************************************
      METHOD SaveToIni( oIni, n ) CLASS TC5RptItemText
******************************************************************************************************************
local cStr := ""
local cItem := "Item" + alltrim(str(n))


cStr += "["+cItem+"]"                                            + CRLF
cStr += "Type="         + "Text"                                 + CRLF
cStr += "nTop="         + strtrim(::aCoords[1])                  + CRLF
cStr += "nLeft="        + strtrim(::aCoords[2])                  + CRLF
cStr += "nWidth="       + strtrim(::aCoords[4]-::aCoords[2])     + CRLF
cStr += "nHeight="      + strtrim(::aCoords[3]-::aCoords[1])     + CRLF
cStr += "cCaption="     + strtran( ::cCaption, CRLF, chr(255) )  + CRLF
cStr += "cFaceName="    + ::cFaceName                            + CRLF
cStr += "nHFont="       + strtrim(::nHFont)                      + CRLF
cStr += "lUnder="       + if( ::lUnder,"Yes","No")               + CRLF
cStr += "lBold="        + if( ::lBold,"Yes","No")                + CRLF
cStr += "lItalic="      + if( ::lItalic,"Yes","No")              + CRLF
cStr += "lTransparent=" + if( ::lTransparent,"Yes","No")         + CRLF
cStr += "nClrText="     + strtrim(::nClrText)                    + CRLF
cStr += "cClrPane="     + strtrim(::nClrPane)                    + CRLF
cStr += "nGiro="        + strtrim(::nGiro)                       + CRLF
cStr += "nAlign="       + strtrim(::nAlign)                      + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF+ CRLF

return cStr

******************************************************************************************************************
      METHOD SaveToXML( oIni, n )  CLASS TC5RptItemText
******************************************************************************************************************

local buffer :=""


buffer += '<Item Name="Text"' +' Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <nTop>'         + alltrim(str(::aCoords[1]))              + '</nTop>'         + CRLF
buffer += '   <nLeft>'        + alltrim(str(::aCoords[2]))              + '</nLeft>'        + CRLF
buffer += '   <nWidth>'       + alltrim(str(::aCoords[4]-::aCoords[2])) + '</nWidth>'       + CRLF
buffer += '   <nHeight>'      + alltrim(str(::aCoords[3]-::aCoords[1])) + '</nHeight>'      + CRLF
buffer += '   <cCaption>'     + strtran( ::cCaption, CRLF, chr(255) )   + '</cCaption>'     + CRLF
buffer += '   <cFaceName>'    + ::cFaceName                             + '</cFaceName>'    + CRLF
buffer += '   <nHFont>'       + alltrim(str(::nHFont))                  + '</nHFont>'       + CRLF
buffer += '   <lUnder>'       + if( ::lUnder,"Yes","No")                + '</lUnder>'       + CRLF
buffer += '   <lBold>'        + if( ::lBold,"Yes","No")                 + '</lBold>'        + CRLF
buffer += '   <lItalic>'      + if( ::lItalic,"Yes","No")               + '</lItalic>'      + CRLF
buffer += '   <lTransparent>' + if( ::lTransparent,"Yes","No")          + '</lTransparent>' + CRLF
buffer += '   <nClrText>'     + alltrim(str(::nClrText))                + '</nClrText>'     + CRLF
buffer += '   <nClrPane>'     + alltrim(str(::nClrPane))                + '</nClrPane>'     + CRLF
buffer += '   <nGiro>'        + alltrim(str(::nGiro))                   + '</nGiro>'        + CRLF
buffer += '   <nAlign>'       + alltrim(str(::nAlign))                  + '</nAlign>'       + CRLF
buffer += '   <lEnable>'      + if( ::lEnable,"Yes","No")               + '</lEnable>'      + CRLF
buffer += '   <nID>'          + alltrim(str(::nID))                     + '</nID>'          + CRLF
buffer += '</Item>'                                                                        + CRLF

return buffer


******************************************************************************************************************
      METHOD LoadIni( oIni, cItem ) CLASS TC5RptItemText
******************************************************************************************************************
local lUnder, lBold, lItalic, lTransparent, cCaption, nW, nH, lEnable


  GET ::aCoords[1]                             SECTION cItem    ENTRY "nTop"         OF oIni DEFAULT 0
  GET ::aCoords[2]                             SECTION cItem    ENTRY "nLeft"        OF oIni DEFAULT 0
  GET nW                                       SECTION cItem    ENTRY "nWidth"       OF oIni DEFAULT 0
  GET nH                                       SECTION cItem    ENTRY "nHeight"      OF oIni DEFAULT 0
  GET ::nHFont                                 SECTION cItem    ENTRY "nHFont"       OF oIni DEFAULT 0
  GET            cCaption                      SECTION cItem    ENTRY "cCaption"     OF oIni DEFAULT ""
  GET ::cFaceName                              SECTION cItem    ENTRY "cFaceName"    OF oIni DEFAULT ""
  GET       lUnder                             SECTION cItem    ENTRY "lUnder"       OF oIni DEFAULT ""
  GET       lBold                              SECTION cItem    ENTRY "lBold"        OF oIni DEFAULT ""
  GET       lItalic                            SECTION cItem    ENTRY "lItalic"      OF oIni DEFAULT ""
  GET       lTransparent                       SECTION cItem    ENTRY "lTransparent" OF oIni DEFAULT ""
  GET ::nClrText                               SECTION cItem    ENTRY "nClrText"     OF oIni DEFAULT 0
  GET ::nClrPane                               SECTION cItem    ENTRY "cClrPane"     OF oIni DEFAULT 0
  GET ::nGiro                                  SECTION cItem    ENTRY "nGiro"        OF oIni DEFAULT 0
  GET ::nAlign                                 SECTION cItem    ENTRY "nAlign"       OF oIni DEFAULT 0
  GET       lEnable                            SECTION cItem    ENTRY "lEnable"      OF oIni DEFAULT ""
  GET ::nID                                    SECTION cItem    ENTRY "nID"          OF oIni DEFAULT 0

  ::aCoords[3] := ::aCoords[1] + nH
  ::aCoords[4] := ::aCoords[2] + nW


  ::lUnder       := lUnder       == "Yes"
  ::lBold        := lBold        == "Yes"
  ::lItalic      := lItalic      == "Yes"
  ::lTransparent := lTransparent == "Yes"
  ::cCaption     := strtran( cCaption, chr(255) ,CRLF )
  ::lEnable      := lEnable      == "Yes"

  ::CreateProps()

return self




******************************************************************************************************************
      METHOD Load( cStr, lPaste, nPuntero ) CLASS TC5RptItemText
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

    nLen   := val( substr( cStr, nPuntero, 5 ))                        ; nPuntero += 5
    ::cCaption := substr( cStr, nPuntero ,nLen )                       ; nPuntero += nLen   //::cCaption

    nLen  := val( substr( cStr, nPuntero, 3 ) )                        ; nPuntero += 3
    ::cFaceName := substr( cStr, nPuntero ,nLen  )                     ; nPuntero += nLen   // ::cFaceName    //::nWFont   := val( substr( cStr, nPuntero, 5 ) )                    ; nPuntero += 5      //

    ::nHFont       := val( substr( cStr, nPuntero, 5 ) )                   ; nPuntero += 5      //
    ::lUnder       := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)   ; nPuntero += 3      //
    ::lBold        := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)   ; nPuntero += 3      //
    ::lItalic      := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)   ; nPuntero += 3      //
    ::lTransparent := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)   ; nPuntero += 3      //
    ::nClrText     := val( substr( cStr, nPuntero, 8 ) )                   ; nPuntero += 8      //
    ::nClrPane     := val( substr( cStr, nPuntero, 8 ) )                   ; nPuntero += 8      //
    ::nGiro        := val( substr( cStr, nPuntero, 3 ) )                   ; nPuntero += 3      //
    ::nAlign       := val( substr( cStr, nPuntero, 1 ) )                   ; nPuntero += 1      //
    ::lEnable      := if(  substr( cStr, nPuntero, 3 ) == ".t.",.t.,.f.)   ; nPuntero += 3      //

    if lPaste
       ::nID        := ::GetNewID()
    else
       ::nID      := val( substr( cStr, nPuntero, 4 ) )
    endif

    nPuntero += 4      //
    ::CreateProps()

return self

******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItemText
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cortar"       ACTION ::oWnd:Cut()
   MENUITEM "Copiar"       ACTION ::oWnd:Copy()
   MENUITEM "Pegar"        ACTION ::oWnd:Paste()

   MENUITEM "Deshabilitar" ACTION (::lEnable := .f., ::oWnd:Refresh())

   MENUITEM "Fuente"             ACTION ::SelectFont()
   MENUITEM "Color de texto"     ACTION ( ::nClrText := ChooseColor( ::nClrText ), ::oWnd:Refresh())
   MENUITEM "Color de Fondo"     ACTION ( ::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())
   MENUITEM "Editar texto"       ACTION ( ::EditText(), ::oWnd:Refresh() )

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0




******************************************************************************************************************
   METHOD SelectFont()  CLASS TC5RptItemText
******************************************************************************************************************

   local aFont, oFont
   local nRGBColor := ::nClrText

   //DATA cFaceName, nWFont, nHFont, lUnder, lBold, lItalic


   aFont := ChooseFont( { ::nHFont,::nWFont,0,0,if(::lBold,700,400),::lItalic,::lUnder,::lStrike,0,0,0,0,0,::cFaceName }, @nRGBColor )

   if ! Empty( aFont[ LF_FACENAME ] ) // the user pressed Esc
      ::cFaceName := aFont[ LF_FACENAME ]
      ::nHFont    := aFont[ 1 ]
      ::nWFont    := aFont[ 2 ]
      ::lBold     := ! ( aFont[ 5 ] == FW_NORMAL )
      ::lItalic   := aFont[ 6 ]
      ::lUnder    := aFont[ 7 ]
      ::lStrike   := aFont[ 8 ]
      ::nClrText  := nRGBColor
   endif
   ::oWnd:Refresh()

return 0





******************************************************************************************************************
      METHOD nAlign( nValue ) CLASS TC5RptItemText
******************************************************************************************************************

if nValue != nil
   if valtype( nValue ) == "C"
      nValue := ascan( {"Izquierda","Centro","Derecha","Multilinea"}, nValue )
   endif
   DEFAULT nValue := 1
   ::nxAlign := nValue
endif

return ::nxAlign

******************************************************************************************************************
      METHOD GetTextLenght() CLASS TC5RptItemText
******************************************************************************************************************
local nLen := 0
local  hFont  := CreateFont( { -::nHFont ,;
                         0,;
                          0,0, if(::lBold,700,400), ::lItalic,::lUnder,::lStrike, 0, 0, 0, 0, 0, ::cFaceName } )


nLen := GetTextWidth( 0, ::cCaption, hFont )

DeleteObject( hFont )



return nLen



