#include "fivewin.ch"
#define R2_XORPEN           7   // DPx
#define DEFAULT_GUI_FONT    17
#define DFC_BUTTON              4
#define DFCS_BUTTONPUSH        16

#define SELECCION                0
#define RESIZINGBOTTOM           1
#define RESIZINGRIGHT            2
#define MOVIENDO_ITEM            3
#define MULTIPLE_MOVIENDO_ITEM   4
#define RESIZING_ITEM_NW         5
#define RESIZING_ITEM_N          6
#define RESIZING_ITEM_NE         7
#define RESIZING_ITEM_E          8
#define RESIZING_ITEM_SE         9
#define RESIZING_ITEM_S          10
#define RESIZING_ITEM_SW         11
#define RESIZING_ITEM_W          12


#define ARROW  0
#define TEXTO  1
#define FIELD  2
#define LINE   3
#define BOX    4
#define IMAGE  5
#define BASE   6


#define GRUPO    "G"
#define CARACTER "C"
#define NUMERO   "N"
#define LOGICO   "L"
#define LISTA    "A"
#define ACCION   "B"

#define IDC_SIZENWSE              32642
#define IDC_SIZENESW              32643
#define IDC_SIZEALL               32646


static nActivo := ARROW
static nIdItem := 100
static oList
static oBar



function Informes()

local oWnd, o, oSp,  oPanel, oFont, nGroup, oMenu
local hDC, aFonts
local nTop := 20
local o1, o2, o3, o4, o5, o6, o7, o8

DEFINE FONT oFont NAME "Verdana" SIZE 0,-11
/*
MENU oMenu
     MENUITEM "Archivo"
     MENUITEM "Edición"
     MENUITEM "Formato"
     MENUITEM "Vista"
ENDMENU
*/
/*
DEFINE WINDOW oWnd COLOR 0, CLR_GRAY VSCROLL HSCROLL MDICHILD OF Aplicacion():oWnd


    oPanel := TPanel():New( 0, 0, 100, 300, oWnd )
    oWnd:oLeft := oPanel

    DEFINE BUTTONBAR oBar OF oPanel 3D SIZE 32, 32 RIGHT
    oBar:bLClicked := {||.t.}

      DEFINE BUTTON o1 OF oBar NAME "curarrow"              FLAT PRESSED ACTION (nActivo := ARROW,  o1:lPressed := !o1:lPressed,             , o1:Refresh())
       DEFINE BUTTON o2 OF oBar NAME "text"                  FLAT         ACTION (nActivo := TEXTO,          ResetBar(.f.), o2:lPressed := .t.)
       DEFINE BUTTON o3 OF oBar NAME "field"                 FLAT         ACTION (nActivo := FIELD,          ResetBar(.f.), o3:lPressed := .t.)
       DEFINE BUTTON o4 OF oBar NAME "image"                 FLAT         ACTION (nActivo := IMAGE,          ResetBar(.f.), o4:lPressed := .t.)
       DEFINE BUTTON o5 OF oBar NAME "line"                  FLAT         ACTION (nActivo := LINE,           ResetBar(.f.), o5:lPressed := .t.)
       DEFINE BUTTON o6 OF oBar NAME "box"                   FLAT         ACTION (nActivo := BOX,            ResetBar(.f.), o6:lPressed := .t.)
       DEFINE BUTTON o7 OF oBar NAME "base"                  FLAT GROUP   ACTION (nActivo := BASE,           ResetBar(.f.), o7:lPressed := .t.)
       DEFINE BUTTON o8 OF oBar NAME "grid"  ACTION oSp:SetGrid( !oSp:lGrid ) FLAT
       DEFINE BUTTON OF oBar                                  FLAT
       DEFINE BUTTON OF oBar                                  FLAT


    oList := TListProp():New( 2, 2, 200, 500, , {"","",""},{20, 100, 100}, oPanel, , , ,,,, oFont )

    oPanel:oClient := oList
    oList:nLineStyle := 2

    oSp := TSoporte():New( 0, oPanel:nWidth, oWnd )

    oSp:oInspect := oList

    o := TBanda():New(                       nTop,  0, 700, 100, oSp, "PageHeader" )
    o := TBanda():New(            nTop + 100 + 20,  0, 700, 400, oSp, "Detail" )
    o := TBanda():New( nTop + 100 + 20 + 400 + 20,  0, 700, 100, oSp, "PageFooter" )

    DEFINE SCROLLBAR oWnd:oHScroll HORIZONTAL   OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveLeft() ;
      // ON DOWN     oSp:MoveRight() ;
     //  ON PAGEUP   oSp:PanLeft() ;
     //  ON PAGEDOWN oSp:PanRight() ;
     //  ON THUMBPOS oSp:ThumbPos( ,nPos )

    DEFINE SCROLLBAR oWnd:oVScroll VERTICAL OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveUp() ;
       ON DOWN     oSp:MoveDown()

    oSp:SetProperties()
*/

ACTIVATE WINDOW oWnd MAXIMIZED

return nil
**********************************
 function ResetBar( lBar )
**********************************
 local n, nLen
 DEFAULT lBar := .t.

 nLen := len( oBar:aControls )
 for n := 1 to nLen
     oBar:aControls[n]:lPressed := .f.
     oBar:aControls[n]:Refresh()
 next
 if lBar
    oBar:aControls[1]:lPressed := .t.
    oBar:aControls[1]:Refresh()
    nActivo := ARROW
 endif

return nil


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


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptTextItem FROM TRptItem

      DATA cText
      DATA nClrText
      DATA cFaceName
      DATA nHFont
      DATA nWFont
      DATA lBold
      DATA lUnderline
      DATA lItalic
      DATA lStrike
      DATA nEscapement

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cText ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD SetProperties()

ENDCLASS

*******************************************************************************************************
  METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cText ) CLASS TRptTextItem
*******************************************************************************************************
    DEFAULT cText := "Label"

    super:New( nTop, nLeft, nBottom, nRight, oBanda )

    ::AddProperties( {"cText","nClrText","cFacename","nHFont","nWFont","lBold","lUnderline","lItalic","lStrike","nEscapement"} )

    ::cText      := cText
    ::nClrText   := 0
    ::cFaceName  := "Ms Sans Serif"
    ::nHFont     := -10
    ::nWFont     := 0
    ::lBold      := .f.
    ::lUnderline := .f.
    ::lItalic    := .f.
    ::lStrike    := .f.
    ::nEscapement := 0

return self


*******************************************************************************************************
  METHOD SetProperties() CLASS TRptTextItem
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup

     oInsp:Reset()

     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "cText",   "Texto", ::cText,,nGroup )
     oInsp:AddItem( "nClrText","Color", ::nClrText,,nGroup )
     oInsp:AddItem( "lBorder", "Borde", ::lBorder,,nGroup )

     nGroup := oInsp:AddGroup( "Fuente" )

     oInsp:AddItem( "cFaceName", "Nombre", ::cFaceName, LISTA, nGroup,,,{||hDC := GetDC( oInsp:hWnd ),aFonts := GetFontNames(hDC), aFonts := asort( aFonts ),ReleaseDC(oInsp:hWnd,hDC), aFonts} )
     oInsp:AddItem( "nWFont",    "Ancho", ::nWFont,,nGroup )
     oInsp:AddItem( "nHFont",    "Alto", ::nHFont,,nGroup )
     oInsp:AddItem( "lItalic",   "Cursiva", ::lItalic,,nGroup )
     oInsp:AddItem( "lUnderline","Subrayado", ::lUnderline,,nGroup )
     oInsp:AddItem( "lStrike",   "Tachado", ::lStrike,,nGroup )
     oInsp:AddItem( "lBold",     "Negrita", ::lBold,,nGroup )

     super:SetProperties( .f. )

     oInsp:Refresh()

return nil

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptTextItem
*******************************************************************************************************

local hFont := CreateFont( { ::nHFont, ::nWFont, ::nEscapement,;
                      0, if( ::lBold, 700, 400), ::lItalic,;
                      ::lUnderLine, ::lStrike, 0,;
                      0, 0,;
                      0, 0, ::cFaceName } )

//GetStockObject( DEFAULT_GUI_FONT )
local hOldFont
local oFont



hOldFont := SelectObject( hDC, hFont )

super:Paint( hDC )

TextOut( hDC, ::nTop+3, ::nLeft+3, ::cText )

SelectObject( hDC, hOldFont )
DeleteObject( hFont )


::PaintDots( hDC )


return self












*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptLineItem FROM TRptItem

      DATA nGrueso
      DATA nColor
      DATA nStyle
      DATA lVertical
      DATA lHorizontal

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda, nGrueso, nStyle, nColor ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD SetProperties()


ENDCLASS

*******************************************************************************************************
  METHOD New( nTop, nLeft, nBottom, nRight, oBanda, nGrueso, nStyle, nColor ) CLASS TRptLineItem
*******************************************************************************************************

DEFAULT nGrueso := 1
DEFAULT nStyle  := PS_SOLID
DEFAULT nColor  := 0

    super:New( nTop, nLeft, nBottom, nRight, oBanda )

    ::AddProperties( {"nGrueso","nColor","nStyle","lVertical","lHorizontal"} )

    ::nGrueso := nGrueso
    ::nStyle  := nStyle
    ::nColor  := nColor
    ::lVertical := .f.
    ::lHorizontal := .f.

return self

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptLineItem
*******************************************************************************************************

local hPen
local hOldPen

hPen    := CreatePen( ::nStyle, ::nGrueso, ::nColor )
hOldPen := SelectObject( hDC, hPen )

super:Paint( hDC )

if ::lVertical
   Moveto( hDC, ::nLeft, ::nTop )
   Lineto( hDC, ::nLeft, ::nBottom )
else
   if ::lHorizontal
      Moveto( hDC, ::nLeft, ::nTop )
      Lineto( hDC, ::nRight, ::nTop )
   else
      Moveto( hDC, ::nLeft, ::nTop )
      Lineto( hDC, ::nRight, ::nBottom )
   endif
endif

SelectObject( hDC, hOldPen )
DeleteObject( hPen )

::PaintDots( hDC )



return self

*******************************************************************************************************
  METHOD SetProperties() CLASS TRptLineItem
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup

     oInsp:Reset()
     oList:oObject := self
     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "nColor",     "Color", ::nColor,,nGroup )
     oInsp:AddItem( "nStyle",     "Estilo", ::nStyle,,nGroup )
     oInsp:AddItem( "nGrueso",    "Grueso", ::nGrueso,,nGroup )
     oInsp:AddItem( "lVertical",  "Vertical", ::lVertical,,nGroup )
     oInsp:AddItem( "lHorizontal","Horizontal", ::lHorizontal,,nGroup )

     super:SetProperties(.f.)
     oInsp:Refresh()

return nil


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptBoxItem FROM TRptLineItem

      METHOD Paint( hDC )
      METHOD SetProperties()

ENDCLASS

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptBoxItem
*******************************************************************************************************

local hPen
local hOldPen

hPen    := CreatePen( ::nStyle, ::nGrueso, ::nColor )
hOldPen := SelectObject( hDC, hPen )

Moveto( hDC, ::nLeft, ::nTop )
Lineto( hDC, ::nRight, ::nTop )
Lineto( hDC, ::nRight, ::nBottom )
Lineto( hDC, ::nLeft, ::nBottom )
Lineto( hDC, ::nLeft, ::nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )

::PaintDots( hDC )



return self

*******************************************************************************************************
  METHOD SetProperties() CLASS TRptBoxItem
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "nColor",  "Color", ::nColor,,nGroup )
     oInsp:AddItem( "nStyle",  "Estilo", ::nStyle,,nGroup )
     oInsp:AddItem( "nGrueso", "Grueso", ::nGrueso,,nGroup )

     super:SetProperties(.f.)

     oInsp:Refresh()

return nil


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptDataBaseItem FROM TRptItem

      DATA aFields
      DATA cBaseName
      DATA cPath

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD SetProperties()
      METHOD GetNameCampos()
      METHOD cGetName()

ENDCLASS

*******************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oBanda ) CLASS TRptDataBaseItem
*******************************************************************************************************

    super:New( nTop, nLeft, nBottom, nRight, oBanda )

    ::AddProperties( {"cPath","cBaseName"} )

    ::aFields   := {}
    ::cBaseName := ""
    ::cPath     := ""
    ::nBottom := ::nTop + 28
    ::nRight  := ::nLeft + 28

return self

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptDataBaseItem
*******************************************************************************************************
local hBitmap := LoadBitmap( GetResources(), "base" )

DrawFrameControl( hDC, {::nTop, ::nLeft, ::nBottom, ::nRight}, DFC_BUTTON, DFCS_BUTTONPUSH )
DrawBitmap( hDC, hBitmap, ::nTop+1, ::nLeft+1 )
DeleteObject( hBitmap )

::PaintDots( hDC )


return self

*******************************************************************************************************
  METHOD SetProperties() CLASS TRptDataBaseItem
*******************************************************************************************************
Local nGroup, oInsp := Inspector()
local hDC, aFonts
local cCampo := ""
local o := self
local aCampos := o:GetNameCampos()

if !empty( aCampos )
   cCampo := aCampos[1]
endif

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "cBaseName", "Nombre", ::cBaseName,ACCION,nGroup,,,{||o:cGetName()} )
     oInsp:AddItem( "cPath",     "Path", ::cPath,,nGroup )
     oInsp:AddItem( "",          "Campos", cCampo, LISTA, nGroup,,,{||aCampos}  )

     oInsp:Refresh()

return nil

*******************************************************************************************************
  METHOD cGetName() CLASS TRptDataBaseItem
*******************************************************************************************************
local cName := cGETFILE("Ficheros dbf|*.dbf*|","Seleccione un fichero",1,,.F.,.T.)

if file( cName )
   ::cBaseName := cFileName( cName )
   ::cPath := cFilePath( cName )
   ::oBanda:oWnd:AddTabla(  ::cBaseName, ::cPath  )
   ::SetProperties()
endif

return nil

*******************************************************************************************************
  METHOD GetNameCampos() CLASS TRptDataBaseItem
*******************************************************************************************************
local aCampos := {}
local aStruct := {}
local n, nLen

if file( ::cPath + ::cBaseName )
   use ( ::cPath + ::cBaseName ) ALIAS base NEW
   aStruct := base->(DbStruct())
   nLen := len( aStruct )
   for n := 1 to nLen
       aadd( aCampos, aStruct[n,1] )
   next
   dbclosearea("base")
endif
return aCampos


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptFieldItem FROM TRptItem

      DATA cField
      DATA cBaseName
      DATA cPath
      DATA cPicture

      DATA nClrText
      DATA cFaceName
      DATA nHFont
      DATA nWFont
      DATA lBold
      DATA lUnderline
      DATA lItalic
      DATA lStrike
      DATA nEscapement

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cField, cBaseName ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD SetProperties()
      METHOD GetPictures()
      METHOD GetTablas()
      METHOD GetNames()

ENDCLASS

*******************************************************************************************************
  METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cField, cBaseName ) CLASS TRptFieldItem
*******************************************************************************************************
    DEFAULT cField := "", cBaseName := ""

    super:New( nTop, nLeft, nBottom, nRight, oBanda )


    ::AddProperties( {"cField","cBaseName","cPath","cPicture","cText","nClrText","cFacename","nHFont","nWFont","lBold","lUnderline","lItalic","lStrike","nEscapement"} )

    ::cField     := ""
    ::cBaseName  := ""
    ::cPath      := ""
    ::cPicture   := ""

    ::nClrText   := 0
    ::cFaceName  := "Ms Sans Serif"
    ::nHFont     := 8
    ::nWFont     := 10
    ::lBold      := .f.
    ::lUnderline := .f.
    ::lItalic    := .f.
    ::lStrike    := .f.
    ::nEscapement := 0

return self


*******************************************************************************************************
  METHOD SetProperties() CLASS TRptFieldItem
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup
local o := self
local aFormatos := o:GetPictures()
     ::cPicture := aFormatos[1]

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )
     oInsp:AddItem( "cField",    "Campo",  ::cField, LISTA, nGroup,,,{|| o:GetNames()  })
     oInsp:AddItem( "cBaseName", "Tabla",   ::cBaseName, LISTA, nGroup,,,{|| o:GetTablas() }, )
     oInsp:AddItem( "cPicture",  "Picture", ::cPicture, LISTA, nGroup,,,{|| aFormatos })

     nGroup := oInsp:AddGroup( "Fuente" )

     oInsp:AddItem( "cFaceName", "Nombre", ::cFaceName, LISTA, nGroup,,,{|| aGetFontNames() } )
     oInsp:AddItem( "nWFont",    "Ancho", ::nWFont,,nGroup )
     oInsp:AddItem( "nHFont",    "Alto", ::nHFont,,nGroup )
     oInsp:AddItem( "lItalic",   "Italic", ::lItalic,,nGroup )
     oInsp:AddItem( "lUnderline","Underline", ::lUnderline,,nGroup )
     oInsp:AddItem( "lStrike",   "Strike", ::lStrike,,nGroup )
     oInsp:AddItem( "lBold",     "Bold", ::lBold,,nGroup )

     super:SetProperties( .f. )

     oInsp:Refresh()

return nil

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptFieldItem
*******************************************************************************************************

local hFont := GetStockObject( DEFAULT_GUI_FONT )
local hOldFont

hOldFont := SelectObject( hDC, hFont )

super:Paint( hDC )

TextOut( hDC, ::nTop+3, ::nLeft+3, ::cField )

SelectObject( hDC, hOldFont )

::PaintDots( hDC )


return self


*******************************************************************************************************
      METHOD GetPictures() CLASS TRptFieldItem
*******************************************************************************************************
local q := Chr(34)
local aFormat := array(30)

aFormat[1] = "Sin formato"
aFormat[2] = "0"
aFormat[3] = "0.00"
aFormat[4] = "#,##0"
aFormat[5] = "#,##0.00"
aFormat[6] = "#,##0\ " + q + "$" + q + ";\-#,##0\ " + q + "$" + q
aFormat[7] = "#,##0\ " + q + "$" + q + ";[Red]\-#,##0\ " + q + "$" + q
aFormat[8] = "#,##0.00\ " + q + "$" + q + ";\-#,##0.00\ " + q + "$" + q
aFormat[9] = "#,##0.00\ " + q + "$" + q + ";[Red]\-#,##0.00\ " + q + "$" + q
aFormat[10] = "0%"
aFormat[11] = "0.00%"
aFormat[12] = "0.00E+00"
aFormat[13] = "dd/mm/yy"
aFormat[14] = "dd/\ mmm\ yy"
aFormat[15] = "dd/\ mmm"
aFormat[16] = "mmm\ yy"
aFormat[17] = "h:mm\ AM/PM"
aFormat[18] = "h:mm:ss\ AM/PM"
aFormat[19] = "hh:mm"
aFormat[20] = "hh:mm:ss"
aFormat[21] = "dd/mm/yy\ hh:mm"
aFormat[22] = "##0.0E+0"
aFormat[23] = "mm:ss"
aFormat[24] = "@"
aFormat[25] = "#,##0.000"
aFormat[26] = "#,##0.0000"
aFormat[27] = "#,##0.00000"
aFormat[28] = "#,##0.000000"
aFormat[29] = "#,##0.0000000"
aFormat[30] = "#,##0.0"

return aFormat

*******************************************************************************************************
      METHOD GetTablas() CLASS TRptFieldItem
*******************************************************************************************************
local aTablas := {}
local n, nLen

nLen := len(::oBanda:oWnd:aTablas)

for n := 1 to nLen
    aadd( aTablas,::oBanda:oWnd:aTablas[n,1] )
next

return aTablas

*******************************************************************************************************
      METHOD GetNames() CLASS TRptFieldItem
*******************************************************************************************************
local aCampos := {}
local aStruct := {}
local n, nLen

if file( ::cPath + ::cBaseName )
   use ( ::cPath + ::cBaseName ) ALIAS base NEW
   aStruct := base->(DbStruct())
   nLen := len( aStruct )
   for n := 1 to nLen
       aadd( aCampos, aStruct[n,1] )
   next
   dbclosearea("base")
endif
return aCampos


*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

CLASS TRptImageItem FROM TRptItem

      DATA cFileName
      DATA lAdjust

      METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cFileName ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD SetProperties()

ENDCLASS

*******************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oBanda, cFileName ) CLASS TRptImageItem
*******************************************************************************************************

    DEFAULT cFileName := "genie"

    super:New( nTop, nLeft, nBottom, nRight, oBanda )

    ::AddProperties( { "cFileName","lAdjust" } )

    ::cFileName := cFileName

return self

*******************************************************************************************************
  METHOD Paint( hDC ) CLASS TRptImageItem
*******************************************************************************************************
local hBitmap
if "." $ ::cFileName
   hBitmap := ReadBitmap( 0, ::cFileName )
else
   hBitmap := LoadBitmap( GetResources(), ::cFileName )
endif

if hBitmap != 0
   DrawBitmap( hDC, hBitmap, ::nTop+1, ::nLeft+1 )
   DeleteObject( hBitmap )
else
   super:Paint( hDC )
endif

::PaintDots( hDC )

return self

*******************************************************************************************************
  METHOD SetProperties() CLASS TRptImageItem
*******************************************************************************************************

local oInsp := Inspector()
local hDC, aFonts
local nGroup

     oInsp:Reset()
     oList:oObject := self

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "cFileName","Nombre", ::cFileName,,nGroup )
     oInsp:AddItem( "lAdjust",  "Ajustar", ::lAdjust,,nGroup )

     super:SetProperties(.f.)

     oInsp:refresh()

return nil





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


*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

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
      METHOD Destroy()   INLINE DeleteObject( ::hMinus ), DeleteObject( ::hPlus ), super:Destroy()

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
                 aRect := { aPoint[1], aPoint[2], 	aPoint[1]+1 , aPoint[2] + +( aClient[4]-aClient[2]) }

            case ::nState == RESIZINGRIGHT

                 aPoint := {24, nCol+::nLeft }
                 aPoint := ClientToScreen( ::oWnd:hWnd, aPoint )
                 aRect := { aPoint[1], aPoint[2],	aPoint[1]+( aClient[3]-aClient[1])-25 , aPoint[2] + 1 }

            otherwise

                 aRect := { ::nOldRow, ::nOldCol,	nRow , nCol }

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

return Super:GotFocus()


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

::oBrush:End()

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












function Inspector()
return oList


function aGetFontNames()

local oInsp := Inspector()
local hDC := GetDC( oInsp:hWnd )
local aFonts := GetFontNames(hDC)
aFonts := asort( aFonts )
ReleaseDC(oInsp:hWnd,hDC)

return  aFonts

