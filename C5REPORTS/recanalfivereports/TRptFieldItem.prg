#include "fivewin.ch"
#include "Informe.ch"



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
