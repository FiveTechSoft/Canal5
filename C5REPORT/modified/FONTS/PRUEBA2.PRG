#include "fivewin.ch"
#include "hbxml.ch"

static oWnd

function main()

local oBar

DEFINE WINDOW oWnd
  DEFINE BUTTONBAR oBar OF oWnd
     DEFINE BUTTON OF oBar ACTION Connect()



ACTIVATE WINDOW oWnd

return nil

function Connect()

  ? WinExec( "c5report.exe " + str(oWnd:hWnd) + " paco" + "qeqrwe12341" )

return nil


CLASS TC5Collection

      DATA aItems AS ARRAY INIT {}
      METHOD New() CONSTRUCTOR
      METHOD AddItem( cTabla, cCampo, cDescrip )
      METHOD Save( cFileName )
      METHOD Load( cFileName )

ENDCLASS

************************************************************************
  METHOD New() CLASS TC5Collection
************************************************************************

return self

************************************************************************
  METHOD AddItem( cTabla, cCampo, cDescrip )CLASS TC5Collection
************************************************************************

local oItem := TC5CollItem():New( cTabla, cCampo, cDescrip )
aadd( ::aItems, oItem )

return oItem

************************************************************************
  METHOD Save( cFileName )CLASS TC5Collection
************************************************************************
local n, nLen
local oIni
local buffer
local nmanejador

  if file( cFileName )
     DeleteFile( cFileName )
  endif

  nmanejador:=FCREATE(cFileName, 0)

  buffer := '<?xml version="1.0" encoding="ISO-8859-1"?>' + CRLF

  buffer+='<Fields xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../xsd/1002.xsd">'+CRLF
  buffer+='<nItems>'  + alltrim(str(len(::aItems)))+ '</nItems>'  + CRLF

  for n := 1 to len( ::aItems )
      buffer += ::aItems[n]:Save( n )
  next n

  buffer+='</Fields>'

  FWRITE(nManejador, alltrim(buffer))
  FCLOSE(nManejador)

return 0

************************************************************************
  METHOD Load( cFileName )CLASS TC5Collection
************************************************************************
local hFile
local oXmlDoc
local oNodo
local n
local nItems

    hFile := FOpen( cFileName )

    If hFile = -1
       MsgStop( cFileName, "No se pudo abrir el fichero" + cFileName )
       return 0
    endif


    oXmlDoc := TXmlDocument():New( hFile )

    if oXmlDoc:nStatus != HBXML_STATUS_OK
       cError := "Error While Processing File: " + AllTrim( Str( oxmlDoc:nLine ) ) + " # "+;
                 "Error: " + HB_XmlErrorDesc( oxmlDoc:nError ) + " # " +;
                 "Tag Error on tag: " + oxmlDoc:oErrorNode:cName + " # " +;
                 "Tag Begin on line: " + AllTrim( Str( oxmlDoc:oErrorNode:nBeginLine ) )
       MsgStop( cFileName, cError )
       return 0
    endif

     if( oNodo := oXmlDoc:FindFirst( "nItems" ) ) != NIL
         nItems := val(oNodo:cData)
         for n := 1 to nItems
             oNodo := oXmlDoc:FindFirst( "Item" + alltrim(str(n)) )
             if oNodo != nil

             endif
         next
     endif



   fClose( hFile )

return 0





return 0










CLASS TC5CollItem

      DATA cTabla
      DATA cCampo
      DATA cDescrip
      METHOD New( cTabla, cCampo, cDescrip ) CONSTRUCTOR
      METHOD Save( n )

ENDCLASS

************************************************************************
  METHOD New( cTabla, cCampo, cDescrip ) CLASS TC5CollItem
************************************************************************

 ::cTabla   := cTabla
 ::cCampo   := cCampo
 ::cDescrip := cDescrip

return self

************************************************************************
  METHOD Save( n ) CLASS TC5CollItem
************************************************************************
local buffer :=""

DEFAULT lForeGround := ::lForeGround

buffer += '<Item Num="' + alltrim(str(n)) + '">' + CRLF
buffer += '   <cTabla>'       + ::cTabla   + '</cTabla>'         + CRLF
buffer += '   <cCampo>'       + ::cCampo   + '</cCampo>'         + CRLF
buffer += '   <cDescrip>'     + ::cDescrip + '</cDescrip>'       + CRLF
buffer += '</Item>' + CRLF

return buffer

