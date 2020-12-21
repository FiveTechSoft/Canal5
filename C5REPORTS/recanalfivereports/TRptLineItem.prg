
#include "fivewin.ch"
#include "Informe.ch"


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
