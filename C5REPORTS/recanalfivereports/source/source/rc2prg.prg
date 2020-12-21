// Windows RC to PRG file conversor utility - Developed by our friend Oliver


#include 'Fivewin.Ch'
#include "fileio.ch"

#define CRSM " ;"+chr(13)+chr(10)
#define TAB space(8)
#define FNTX 14
#define FNTY 7

Function Rc2prg()

   cFile := cGetFile("Fichero rc | *.rc", "Selecciona fichero rc" )

   if file( cFile )
      Analiza( cFile )
   else
      MsgInfo( "No encontrado " + cFile + ". Por favor, corrija","Atención" )
   endif

return nil
//--------------------------------------------------------------//
// Dialog-Coordinates

Function xCo(c,x)
if x == NIL
   return Ltrim(str((Val(c)*FNTX)/8,6,0))
endif
return Ltrim(str(val(c)+(((Val(c)+Val(x))*FNTX)/8),6,0))


Function yCo(c,x)
if x == NIL
   return Ltrim(str((Val(c)*FNTY)/4,6, 0))
endif
return Ltrim(str(val(c)+(((Val(c)+Val(x))*FNTY)/4),6,0))


function analiza( cFile )

   local nSize, buffer, h
   local n, nLines, nEn, cToken, nEn2, nLen
   local n2
   local cId := ""
   local nFind            := 0
   local oDlg
   local oControl
   local cStr             := ""
   local aTokens          := {}
   local nItem            := 1

   local aDlgs            := {}
   local aBmps            := {}
   local cBitmap          := ""
   local aIcons           := {}
   local aCursors         := {}
   local aMenus           := {}
   local lVale

   local oTree, oItem1, oItem2, oItem3, oItem4
   local oImageList
   local oWnd := Aplicacion():oWnd
   local oBrush
   local oRC
   local oBar
   local aInfoDlgs := {"CAPTION",;
                       "CHARACTERISTICS",;
                       "CLASS",;
                       "EXSTYLE",;
                       "FONT",;
                       "LANGUAGE",;
                       "MENU",;
                       "STYLE",;
                       "VERSION"}

   local aControles := {"AUTO3STATE",;
                        "AUTOCHECKBOX",;
                        "AUTORADIOBUTTON",;
                        "CHECKBOX",;
                        "COMBOBOX",;
                        "CONTROL",;
                        "CTEXT",;
                        "DEFPUSHBUTTON",;
                        "EDITTEXT",;
                        "GROUPBOX",;
                        "ICON",;
                        "LISTBOX",;
                        "LTEXT",;
                        "PUSHBOX",;
                        "PUSHBUTTON",;
                        "RADIOBUTTON",;
                        "RTEXT",;
                        "SCROLLBAR",;
                        "STATE3"}

   nSize  := fsize( cFile )
   buffer := space( nSize )
   h      := fopen( cFile, FO_READ )
   fread( h, @buffer, nSize )
   fclose( h )

   buffer := " " + strtran( buffer, CRLF, " " ) + " "
   buffer := strtran( buffer, "{", " BEGIN" )
   buffer := strtran( buffer, "}", " END" )
   do while .t.
      nLen := len( buffer )
      buffer := strtran( buffer, " ,","" )
      if nLen == len( buffer )
         exit
      endi
   enddo
   buffer := strtran( buffer, ",", ", " )

   do while .t.
      nLen := len( buffer )
      buffer := strtran( buffer, " |","|" )
      buffer := strtran( buffer, "| ","|" )
      if nLen == len( buffer )
         exit
      endif
   enddo

do while .t.

   nEn := at( " DIALOG ", buffer )

   if nEn == 0
      exit
   else
      cId := PrevItem( buffer, nEn )
   endif

   buffer := substr( buffer, nEn + 8 )

   nEn2 := at( " BEGIN", buffer )
   cStr := substr( buffer, 1, nEn2 )+ " "
   aTokens := GetTokens( cStr )
   if empty( aTokens )
      loop
   endif

   nFind := 0
   for n2 := 1 to len( aTokens )
       if ascan( aInfoDlgs, aTokens[n2] ) != 0
          nFind := n2
          exit
       endif
   next

   if nFind == 0
      loop
   endif

   oDlg := TRCDialog():New()
   oDlg:nID  := cId

   nLen := len( aTokens )
   n := 2

   cToken := aTokens[n]
   do while isalpha( left( alltrim(cToken), 1 ) )
      n++
      cToken := aTokens[n]
   enddo

   oDlg:nLeft := strtran( cToken,",","")

   n++
   cToken := aTokens[n]
   oDlg:nTop := strtran( cToken,",","")

   n++
   cToken := aTokens[n]
   oDlg:nWidth := strtran( cToken,",","")

   n++
   cToken := aTokens[n]
   oDlg:nHeight := strtran( cToken,",","")

   do while n < nLen

      n++
      cToken := aTokens[n]

      do case
         case cToken == "CAPTION"

              n++
              cToken := aTokens[n]
              oDlg:cCaption := cToken

         case cToken == "CHARACTERISTICS"

              n++
              cToken := aTokens[n]
              oDlg:nCharacteristics := cToken

         case cToken == "CLASS"

              n++
              cToken := aTokens[n]
              oDlg:cClass := cToken

         case cToken == "EXSTYLE"

              n++
              cToken := aTokens[n]
              oDlg:cExStyle := cToken

         case cToken == "FONT"

              n++
              cToken := aTokens[n]
              oDlg:nPointSize := cToken
              n++
              cToken := aTokens[n]
              oDlg:cFaceName := cToken

         case cToken == "LANGUAGE"

              n++
              cToken := aTokens[n]
              oDlg:cLanguage := cToken

         case cToken == "MENU"

              n++
              cToken := aTokens[n]
              oDlg:cMenuName := cToken

         case cToken == "STYLE"

              n++
              cToken := aTokens[n]
              oDlg:cStyle := cToken

         case cToken == "VERSION"

              n++
              cToken := aTokens[n]
              oDlg:nVersion := cToken

         case cToken == "DIALOG"


      endcase

   enddo

   nEn     := at( "BEGIN", buffer )
   nEn2    := at( " END", buffer )
   cStr    := substr( buffer, nEn, nEn2-nEn ) + " "

   aTokens := GetTokens( cStr )
   nLen    := len( aTokens )
   cStr    := ""
   n       := 1
   nFind   := 0
   nItem   := 1

   do while nItem <= nLen

      cToken := aTokens[nItem]
      nFind := ascan( aControles, cToken )

      if nFind > 0
         oControl := TRCControl():New()
         do case
            case nFind == 6 //CONTROL

                 oControl:cClass   := strtran(cToken,",","")
                 oControl:cCaption := strtran(aTokens[nItem+1],",","")
                 oControl:nId      := strtran(aTokens[nItem+2],",","")
                 oControl:cType    := strtran(aTokens[nItem+3],",","")
                 oControl:cStyle   := strtran(aTokens[nItem+4],",","")
                 oControl:nLeft    := strtran(aTokens[nItem+5],",","")
                 oControl:nTop     := strtran(aTokens[nItem+6],",","")
                 oControl:nWidth   := strtran(aTokens[nItem+7],",","")
                 oControl:nHeight  := strtran(aTokens[nItem+8],",","")
                 nItem += 8

                 if right( oControl:nHeight, 1 ) == ","
                    oControl:cExStyle   := strtran(aTokens[nItem+1],",","")
                    nItem++
                 endif

            otherwise

                 oControl:cClass   := strtran(cToken,",","")

                 if nFind != 5 .and. nFind != 9 .and. nFind != 12
                    oControl:cCaption := strtran(aTokens[nItem+1],",","")
                    nItem++
                 endif

                 oControl:nId      := strtran(aTokens[nItem+1],",","")
                 oControl:nLeft    := strtran(aTokens[nItem+2],",","")
                 oControl:nTop     := strtran(aTokens[nItem+3],",","")
                 oControl:nWidth   := strtran(aTokens[nItem+4],",","")
                 oControl:nHeight  := strtran(aTokens[nItem+5],",","")
                 nItem += 5

                 if right( oControl:nHeight, 1 ) == ","
                    oControl:cStyle   := strtran(aTokens[nItem+1],",","")
                    nItem++
                    if right( oControl:cStyle, 1 ) == ","
                       oControl:cExStyle   := strtran(aTokens[nItem+1],",","")
                       nItem++
                    endif
                 endif

         endcase
         aadd( oDlg:aControls, oControl )
      endif
      nItem++
   enddo

   aadd( aDlgs, oDlg )

enddo

nSize  := fsize( cFile )
buffer := space( nSize )
h      := fopen( cFile, FO_READ )
fread ( h, @buffer, nSize )
fclose( h )

buffer := " " + strtran( buffer, CRLF, " " ) + " "
nEn := at( " BITMAP ", buffer )

do while .t.

   if nEn == 0
      exit
   else
      cId := PrevItem( buffer, nEn )
      aTokens := GetTokens( substr( buffer, nEn, 300 ) )
      lVale := .t.
      nLen := min( 10, len( aTOkens ))
      for n := 1 to nLen
          if aTokens[n] == "{"
             lVale := .f.
             exit
          endif
      next
      if lVale
         cBitmap := GetNextString( buffer, nEn )
         aadd( aBmps, { cId, cBitmap } )
      endif
   endif

   buffer := substr( buffer, nEn + 8 )
   nEn := at( " BITMAP ", buffer )

enddo


nSize  := fsize( cFile )
buffer := space( nSize )
h      := fopen( cFile, FO_READ )
fread ( h, @buffer, nSize )
fclose( h )


buffer := " " + strtran( buffer, CRLF, " " ) + " "
nEn := at( " ICON ", buffer )
do while .t.

   if nEn == 0
      exit
   else
      cId := PrevItem( buffer, nEn )
      aTokens := GetTokens( substr( buffer, nEn, 300 ) )
      lVale := .t.
      nLen := min( 6, len( aTOkens ))
      for n := 1 to nLen
          if aTokens[n] == "{"
             lVale := .f.
             exit
          endif
      next
      nLen := min( 3, len( aTOkens ))
      for n := 1 to nLen
          if at( ",", aTokens[n]) != 0
             lVale := .f.
             exit
          endif

      next
      if lVale
         aadd( aIcons, { cId, GetNextString( buffer, nEn ) } )
      endif

   endif
   buffer := substr( buffer, nEn + 8 )
   nEn := at( " ICON ", buffer )
enddo

nSize  := fsize( cFile )
buffer := space( nSize )
h      := fopen( cFile, FO_READ )
fread ( h, @buffer, nSize )
fclose( h )


buffer := " " + strtran( buffer, CRLF, " " ) + " "
nEn := at( " CURSOR ", buffer )
do while .t.

   if nEn == 0
      exit
   else
      cId := PrevItem( buffer, nEn )
      aTokens := GetTokens( substr( buffer, nEn, 300 ) )
      lVale := .t.
      nLen := min( 6, len( aTOkens ))
      for n := 1 to nLen

          if aTokens[n] == "{"
             lVale := .f.
             exit
          endif
      next
      if lVale
         aadd( aCursors, { cId, GetNextString( buffer, nEn ) } )
      endif
   endif
   buffer := substr( buffer, nEn + 8 )
   nEn := at( " CURSOR ", buffer )

enddo

/*
nSize  := fsize( cFile )
buffer := space( nSize )
h      := fopen( cFile, FO_READ )
fread ( h, @buffer, nSize )
fclose( h )

buffer := " " + strtran( buffer, CRLF, " " ) + " "

nEn :=  at( " MENUITEM ", buffer )
nEn := rat( " MENU ", substr( buffer, 1, nEn ) )

do while .t.

   if nEn == 0
      exit
   else
      cId := PrevItem( buffer, nEn )
   endif

enddo
*/


     oImageList = TImageList():New(16,16,"toolbar\image2.bmp")

     DEFINE BRUSH oBrush STYLE "NULL"

     DEFINE WINDOW oRC TITLE cFile OF oWnd MDICHILD  BRUSH obrush

            DEFINE BUTTONBAR oBar OF oRC 3D SIZE 25, 25

                   DEFINE BUTTON OF oBar NAME "plus"    NOBORDER  TOOLTIP "Expandir"    ACTION oTree:ExpandAll()
                   DEFINE BUTTON OF oBar NAME "minus"   NOBORDER  TOOLTIP "Contraer"    ACTION oTree:ColapseAll()
                   DEFINE BUTTON OF oBar NAME "props"   NOBORDER  TOOLTIP "Propiedades"

            oTree := TTreeView():New( oBar:nHeight, 1, oRC, 0, CLR_WHITE,.t., .f., 200, 1000 )

            oTree:SetImageList( oImageList )

            if len( aDlgs ) > 0
               oItem1 := TTVItem():New( oTree,, "Dialogos", 0, .t., oTree,,"",.t. )

               for n := 1 to len( aDlgs )
                   oItem2 := TTVItem():New( oTree,, aDlgs[n]:nID, 0, .t., oItem1,0,"",.t. )
               next
            endif

            if len( aBmps ) > 0
               oItem1 := TTVItem():New( oTree,, "Bitmaps", 9, .t., oTree,,"",.t. )
               for n := 1 to len( aBmps )
                   oItem2 := TTVItem():New( oTree,, aBmps[n,1] , 9, .t., oItem1,,"",.t. )
                   oItem2:Cargo := aBmps[n,2]
               next
            endif
            if len( aIcons ) > 0
               oItem1 := TTVItem():New( oTree,, "Iconos", 16, .t., oTree,,"",.t. )
               for n := 1 to len( aIcons )
                   oItem2 := TTVItem():New( oTree,, aIcons[n,1], 16, .t., oItem1,,"",.t. )
                   oItem2:Cargo := aIcons[n,2]
               next
            endif

            if len( aCursors ) > 0
               oItem1 := TTVItem():New( oTree,, "Cursores", 9, .t., oTree,,"",.t. )
               for n := 1 to len( aCursors )
                   oItem2 := TTVItem():New( oTree,, aCursors[n,1], 9, .t., oItem1,,"",.t. )
                   oItem2:Cargo := aCursors[n,2]
               next
            endif

            oRC:oClient := oTree

      ACTIVATE WINDOW oRC ON INIT oRC:Resize() VALID( oRC := nil, oImageList:End(),.T.)


   return nil





return nil

function GetDibu( cDibu, cStyle )
local nDibu := 15

cDibu := upper( cDibu )

do case
   case at( "PUSHBUTTON", cDibu ) != 0
        nDibu := 1

   case at( "EDIT", cDibu ) != 0
        nDibu := 2

   case at( "TEXT", cDibu ) != 0
        nDibu := 3

   case at( "LISTBOX", cDibu ) != 0
        nDibu := 4

   case at( "COMBO", cDibu ) != 0
        nDibu := 5

   case at( "CONTROL", cDibu ) != 0


        do case
           case at( "CHECKBOX", cStyle ) != 0
                nDibu := 8
           case at( "RADIO", cStyle )    != 0
                nDibu := 7
           case at( "GROUPBOX", cStyle ) != 0
                nDibu := 6
           case at( "CBS", cStyle )      != 0
                nDibu := 5
           case at( "LBX", cStyle )      != 0
                nDibu := 4
           case at( "ES_", cStyle )      != 0
                nDibu := 2
           case at( "SS_", cStyle )      != 0
                nDibu := 3
           case at( "FOLDER", cStyle )   != 0
                nDibu := 14
           otherwise
                nDibu := 15
        endcase

endcase


return nDibu






#define BUSCANDO           0
#define ALMACENANDO        1
#define ALMACENANDO_STRING 2
***********************************************************************************************
 static function GetTokens( cStr )
***********************************************************************************************
local cToken  := ""
local c       := ""
local aTokens := {}
local nLen    := len( cStr )
local n       := 1
local nState  := BUSCANDO
local lFirst  := .t.

do while n <= nLen

   c := substr( cStr, n, 1 )

   do case
      case nState == BUSCANDO

           if c == '"'
             cToken += c
             nState := ALMACENANDO_STRING
           else
             if c != " "
                nState := ALMACENANDO
                cToken += c
             endif
           endif

      case nState == ALMACENANDO

           if c == " "
              if cToken != ","
                 aadd( aTokens, alltrim(cToken) )
              endif
              cToken := ""
              nState := BUSCANDO
           else
              cToken += c
           endif

      case nState == ALMACENANDO_STRING

           cToken += c

           if c == '"'
              if cToken != ","
                 aadd( aTokens, alltrim(cToken) )
              endif
              cToken := ""
              nState := BUSCANDO
           endif

   endcase

   n++

enddo

return aTokens


************************************************************************************************
  static function PrevItem( cString, nPos )
************************************************************************************************
local cStr := ""
local n := 1
local c

do while .t.
   c := substr( cString, nPos-n, 1 )
   if c == " "
      n++
   else
      exit
   endif
enddo

cStr += c
n++
do while .t.
   c := substr( cString, nPos-n, 1 )
   if c != " "
      n++
      cStr := c + cStr
   else
      exit
   endif
enddo

return cStr

************************************************************************************************
  static function GetNextString( cString, nPos )
************************************************************************************************
local cStr := ""
local n := nPos
local c

do while n < len( cString ) // paso hasta encontrar el principio de la cadena
   c := substr( cString, n, 1 )
   if c != '"'
      n++
   else
      exit
   endif
enddo
cStr += c
n++
do while n < len( cString )
   c := substr( cString, n, 1 )
   if c != '"'
      n++
      cStr += c
   else
      cStr += c
      exit
   endif
enddo

return cStr



CLASS TRCDialog

      DATA nId
      DATA nTop
      DATA nLeft
      DATA nWidth
      DATA nHeight
      DATA cCaption
      DATA nCharacteristics
      DATA cClass
      DATA cExStyle
      DATA nPointSize
      DATA cFaceName
      DATA cLanguage
      DATA cSubLanguage
      DATA cMenuName
      DATA cStyle
      DATA nVersion

      DATA aControls

      METHOD New() CONSTRUCTOR

ENDCLASS

***********************************************************************************************
  METHOD New() CLASS TRCDialog
***********************************************************************************************

  ::aControls         := {}
  ::nId               := ""
  ::nTop              := ""
  ::nLeft             := ""
  ::nWidth            := ""
  ::nHeight           := ""
  ::cCaption          := ""
  ::nCharacteristics  := ""
  ::cClass            := ""
  ::cExStyle          := ""
  ::nPointSize        := ""
  ::cFaceName         := ""
  ::cLanguage         := ""
  ::cSubLanguage      := ""
  ::cMenuName         := ""
  ::cStyle            := ""
  ::nVersion          := ""



return self


CLASS TRCControl

      DATA cType
      DATA nId
      DATA nTop
      DATA nLeft
      DATA nWidth
      DATA nHeight
      DATA cCaption
      DATA cStyle
      DATA cExStyle
      DATA cClass
      METHOD New() CONSTRUCTOR

ENDCLASS

***********************************************************************************************
  METHOD New() CLASS TRCControl
***********************************************************************************************

  ::cType     := ""
  ::nId       := ""
  ::nTop      := ""
  ::nLeft     := ""
  ::nWidth    := ""
  ::nHeight   := ""
  ::cCaption  := ""
  ::cStyle    := " "
  ::cExStyle  := ""
  ::cClass    := ""



return self

#define ID_LABEL    110
#define ID_DATA     120
#define ID_PROPS    130
function OInspect( oObject )

   local oDlg, oLbx, oSay, oGet
   local cProp := ""
   local aObjData, cData, uData
   local n

   DEFINE DIALOG oDlg RESOURCE "Inspector"

   REDEFINE SAY oSay ID ID_LABEL OF oDlg

   aObjData = aOData( oObject )
   for n = 1 to Len( aObjData )
      cData = aObjData[ n ]
      uData = OSend( oObject, cData )
      aObjData[ n ] = PadR( cChr2Data( cData ), 17 ) + Chr( 9 ) + ;
                      ValType( uData ) + "  " + cValToChar( uData )
   next

   uData = OSend( oObject, aObjData[ 1 ] )
   REDEFINE GET oGet VAR uData ID ID_DATA  OF oDlg

   REDEFINE LISTBOX oLbx VAR cProp ITEMS aObjData ;
      ID ID_PROPS OF oDlg ;
      ON CHANGE ( oSay:cTitle := cProp,;
                  oGet:VarPut( OSend( oObject, cProp ) ), oGet:Refresh() )

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
