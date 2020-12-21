
#include "fivewin.ch"
#include "Informe.ch"


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