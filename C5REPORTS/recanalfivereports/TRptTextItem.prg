

#include "fivewin.ch"
#include "Informe.ch"

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


