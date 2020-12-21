#include "fivewin.ch"
#include "Informe.ch"



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

