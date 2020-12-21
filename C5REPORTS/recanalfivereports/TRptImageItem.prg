#include "fivewin.ch"
#include "Informe.ch"



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
