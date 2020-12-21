#include "fivewin.ch"
#include "fileio.ch"

#define VALID_ID        0
#define INVALID_ID      1
#define INVALID_CID     2
#define DUPLICATE_ID    3
#define DUPLICATE_CID   4


CLASS TIDTable

      DATA aIDs
      METHOD New() CONSTRUCTOR
      METHOD Save( cFile )
      METHOD Load( cFile )
      METHOD AddID( nID, cID )
      METHOD GetId( cSemilla )

      // -----------------------------
      METHOD Test()

ENDCLASS


METHOD New() CLASS TIDTable

     ::aIDs := {}

return self

**********************************************************
  METHOD Save( cFile, lOverWrite ) CLASS TIDTable
**********************************************************
local n
local nLen := len( ::aIDs )
local cIds := ""
local h

if cFile      == nil; cFile      := "";  endif
if lOverWrite == nil; lOverWrite := .t.; endif

for n := 1 to nLen
    cIds += alltrim(str(::aIDs[n,1]))+ CRLF + ::aIDS[n,2] + CRLF
next

if !empty( cFile )
   if file( cFile ) .and. !lOverWrite
      lOverWrite := MsgYesNo( "Existe el fichero " + cFile + ". " + CRLF + "¿Desea sobreescribirlo?","Atención")
      if !lOverWrite
         MsgStop( "Operación cancelada","Atención" )
         return .F.
      endif
   endif
   h := fcreate( cFile )
   if h == -1
      MsgStop( "Error al crear " + cFile, "Atención" )
      return 0
   endif
   fwrite( h, cIds )
   fclose( h )
endif

return cIds

**********************************************************
  METHOD Load( cFile ) CLASS TIDTable
**********************************************************
local h
local buffer, nSize
local cToken
local n := 1
local nLines
local nId, cID
local lDuplicados := .f.

if cFile      == nil; cFile      := "";  endif

if empty( cFile ) .or. !file( cFile )
   MsgStop( "No se encontro fichero de IDs","Atención" )
   return .f.
endif

nSize  := fsize( cFile )
buffer := space( nSize )
h      := fopen( cFile, FO_READ )
fread( h, @buffer, nSize )
fclose( h )

nLines := mlcount( buffer )

for n := 1 to nLines step 2
    nId := val( memoline( buffer,, n ))
    cId := memoline( buffer,,n+1)
    ::AddId( nID, cID )
next

return len( ::aIds )

**********************************************************
  METHOD AddID( nID, cID ) CLASS TIDTable
**********************************************************
local n, nLen

DEFAULT cID := ""

if nID == 0
   return INVALID_ID
endif

cID := alltrim( cID )

if at( " ", cID ) != 0
   return INVALID_CID
endif

nLen := len( ::aIDs )

if nLen > 0
   for n := 1 to nLen
       if !empty( cID )
          if cID == ::aIDS[n,2] .and. len( cID ) == len( ::aIDS[n,2] )
             return DUPLICATE_CID
          endif
       endif
   next
endif

aadd( ::aIDs, { nID, cID } )

return VALID_ID

******************************************
  METHOD GetId( cSemilla ) CLASS TIDTable
******************************************
//local nId := atail( ::aIDs



return nil




******************************************
  METHOD Test() CLASS TIDTable
******************************************

::AddId( 100, "ID_100" )
::AddId( 101, "ID_101" )
::AddId( 102, "ID_102" )
::AddId( 103, "ID_103" )
::AddId( 100, "ID_100" )

::Save( "Test.ids" )
? "len aids", len( ::aIDs )

asize( ::aIDs, 0 )
? "len aids", len( ::aIDs )

::Load( "Test.ids" )
? "len aids", len( ::aIDs )

Delete file "test.ids"

::Save( "test.ids" )

return nil


