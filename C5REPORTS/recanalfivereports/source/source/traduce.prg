/*
BOOL AdjustWindowRect(          LPRECT lpRect,
    DWORD dwStyle,
    BOOL bMenu
);
*/
#include "fivewin.ch"


function Translate()

local oDlg
local oCCode, cCode := space(1000)
local oTrans, cTrans := space(1000)
local oHBFunc
local oCLFunc
local oK, oC, oH


DEFINE DIALOG oDlg NAME "TRANSLATE"

    REDEFINE GET oCCode VAR cCode  ID 101 OF oDlg MULTILINE
    REDEFINE GET oTrans VAR cTrans ID 102 OF oDlg MULTILINE
    REDEFINE BUTTON oHBFunc        ID 103 OF oDlg ACTION ToCode( cCode, oTrans, .t. )
    REDEFINE BUTTON oCLFunc        ID 104 OF oDlg ACTION ToCode( cCode, oTrans, .f. )

ACTIVATE DIALOG oDlg CENTERED

return nil


function ToCode( cCode, oTrans, lHB )

local cName
local aParams
local nEn
local cAux
local cTrans := ""
local n
local cType
local cRet := ""
local cReturn := ""
local aParRet := {}
local cPar
local oTr := TTransFunc():New( cCode )
local nCOunt

if lHB
   cReturn := "HB_FUNC( " + UPPER(oTr:cName) + " )" + CRLF
else
   cReturn := "CLIPPER "+ UPPER(oTr:cName) + "( PARAMS )" + CRLF
endif
cReturn += "{" + CRLF

nCount := oTr:Count( "rect" )

for n := 1 to len( oTr:aParams )

    do case
       case "rect" $ oTr:aParams[n,1]
            cName := strtran(oTr:aParams[n,2],"*","")
            cReturn += space(5) + "RECT " + cName + ";" + CRLF
            cReturn += space(5) +cName + ".top = hb_parvni( " + strtrim( n ) + ", 1 );" + CRLF
            cReturn += space(5) +cName + ".left = hb_parvni( " + strtrim( n ) + ", 2 );" + CRLF
            cReturn += space(5) +cName + ".bottom = hb_parvni( " + strtrim( n ) + ", 3 );" + CRLF
            cReturn += space(5) +cName + ".right = hb_parvni( " + strtrim( n ) + ", 4 );" + CRLF + CRLF

       case "point" $ oTr:aParams[n,1]
            cName := strtran(oTr:aParams[n,2],"*","")
            cReturn += space(5) + "POINT " + cName + ";" + CRLF
            cReturn += space(5) +cName + ".x = hb_parvni( " + strtrim( n ) + ", 1 );" + CRLF
            cReturn += space(5) +cName + ".y = hb_parvni( " + strtrim( n ) + ", 2 );" + CRLF + CRLF

    end

next

do case
   case oTr:cReturn == "int"
        cReturn += space(5) +"hb_retni( "
   case oTr:cReturn == "bool"
        cReturn += space(5) +"hb_retl( "
   case left(oTr:cReturn,1) == "h"
        cReturn += space(5) +"hb_retnl( "
   otherwise
        cReturn += space(5) +"hb_ret( "
endcase

cReturn += oTr:cName + "( "

for n := 1 to len( oTr:aParams )
    cType := alltrim( oTr:aParams[n,1] )
    do case
       case cType == "hdc"
            cReturn += "(HDC) hb_parnl(" + strtrim(n) +")"

       case cType == "hwnd"
            cReturn += "(HWND) hb_parnl(" + strtrim(n) +")"

       case cType == "lptstr" .or. cType == "lpstr"
            cReturn += "hb_parc(" + strtrim(n) +")"

       case cType == "int" .or. cType == "uint"
            cReturn += "hb_parni(" + strtrim(n) +")"

       case "rect" $ cType
            cReturn += strtran( oTr:aParams[n,2], "*","&" )

       case "point" $ cType
            cReturn += strtran( oTr:aParams[n,2], "*","&" )

       case cType == "hbrush" .or. cType == "hpen" .or. cType == "hregion"
            cReturn += "hb_parnl(" + strtrim(n) +")"

       case cType == "bool"
            cReturn += "hb_parl(" + strtrim(n) +")"

       case cType == "dword"
            cReturn += "hb_parnl(" + strtrim(n) +")"


       otherwise
            cReturn += "(" + upper(oTr:aParams[n,1]) + ")" + "hb_parnl(" + strtrim(n) +")"


    endcase
    if n < len( oTr:aParams )
       cReturn += ", "
    endif
next

cReturn += "));" + CRLF
cReturn += "}"+ CRLF


if !lHB
   cReturn := strtran(cReturn,"hb_","_")
endif




oTrans:cText := cReturn
oTrans:Refresh()

return nil






static function strtrim(n);return alltrim(str(n))










CLASS TTransFunc

      DATA cStrFunc
      DATA cReturn
      DATA cName
      DATA aParams
      DATA aEquivale

      METHOD New( cStr ) CONSTRUCTOR
      METHOD SetStr( cStr )
      METHOD GetName()
      METHOD GetReturn()
      METHOD GetParams()
      METHOD GetType( n )
      METHOD GetNameParam( n )
      METHOD Count( cType )



ENDCLASS

*************************************************************************
  METHOD New( cStr ) CLASS TTransfunc
*************************************************************************

       ::SetStr( cStr )
       ::cName      := ::GetName()
       ::cReturn    := ::GetReturn()
       ::aParams    := {}
       ::GetParams()
       ::aEquivale := { {"atom"	                ,"parnl"},;
                        {"bool"	                ,"parl"},;
                        {"boolean"	             ,"parl"},;
                        {"byte"	                ,"parni"},;
                        {"callback"	             ,"parnl"},;
                        {"char"	                ,"parc"},;
                        {"colorref"	             ,"parnl"},;
                        {"const"	                ,""},;
                        {"critical_section"      ,""},;
                        {"dword"	                ,""},;
                        {"dword32"	             ,""},;
                        {"dword64"	             ,""},;
                        {"dword_ptr"	          ,""},;
                        {"float"	                ,""},;
                        {"haccel"	             ,"parnl"},;
                        {"handle"	             ,"parnl"},;
                        {"hbitmap"	             ,"parnl"},;
                        {"hbrush"	             ,"parnl"},;
                        {"hconv"	                ,"parnl"},;
                        {"hconvlist"	          ,"parnl"},;
                        {"hcursor"	             ,"parnl"},;
                        {"hdc"	                ,"parnl"},;
                        {"hddedata"	             ,"parnl"},;
                        {"hdesk"	                ,"parnl"},;
                        {"hdrop"	                ,"parnl"},;
                        {"hdwp"	                ,"parnl"},;
                        {"henhmetafile"	       ,"parnl"},;
                        {"hfile"	                ,"parnl"},;
                        {"hfont"	                ,"parnl"},;
                        {"hgdiobj"	             ,"parnl"},;
                        {"hglobal"	             ,"parnl"},;
                        {"hhook"	                ,"parnl"},;
                        {"hicon"	                ,"parnl"},;
                        {"himagelist"	          ,"parnl"},;
                        {"himc"	                ,"parnl"},;
                        {"hinstance"	          ,"parnl"},;
                        {"hkey"	                ,"parnl"},;
                        {"hkl"	                ,"parnl"},;
                        {"hlocal"	             ,"parnl"},;
                        {"hmenu"	                ,"parnl"},;
                        {"hmetafile"	          ,"parnl"},;
                        {"hmodule"	             ,"parnl"},;
                        {"hmonitor"	             ,"parnl"},;
                        {"hpalette"	             ,"parnl"},;
                        {"hpen"	                ,"parnl"},;
                        {"hrgn"	                ,"parnl"},;
                        {"hrsrc"	                ,"parnl"},;
                        {"hsz"	                ,"parnl"},;
                        {"hwinsta"	             ,"parnl"},;
                        {"hwnd"	                ,"parnl"},;
                        {"int"	                ,"parni"},;
                        {"int32"	                ,""},;
                        {"int64"	                ,""},;
                        {"int_ptr"	             ,""},;
                        {"langid"	             ,""},;
                        {"lcid"	                ,""},;
                        {"lctype"	             ,""},;
                        {"long"	                ,""},;
                        {"long32"	             ,""},;
                        {"long64"	             ,""},;
                        {"longlong"	             ,""},;
                        {"long_"	                ,""},;
                        {"lparam"	             ,""},;
                        {"lpbool"	             ,""},;
                        {"lpbyte"	             ,""},;
                        {"lpcolorref"	          ,""},;
                        {"lpcritical_section"    ,""},;
                        {"lpcstr"	             ,"parc"},;
                        {"lpctstr"	             ,"parc"},;
                        {"lpcvoid"	             ,""},;
                        {"lpcwstr"	             ,"parc"},;
                        {"lpdword"	             ,""},;
                        {"lphandle"	             ,""},;
                        {"lpint"	                ,""},;
                        {"lplong"	             ,""},;
                        {"lpstr"	                ,""},;
                        {"lptstr"	             ,""},;
                        {"lpvoid"	             ,""},;
                        {"lpword"	             ,""},;
                        {"lpwstr"	             ,""},;
                        {"lresult"	             ,""},;
                        {"luid"	                ,""},;
                        {"pbool"	                ,""},;
                        {"pboolean"	             ,""},;
                        {"pbyte"	                ,""},;
                        {"pchar"	                ,""},;
                        {"pcritical_section"	    ,""},;
                        {"pcstr"	                ,""},;
                        {"pctstr"	             ,""},;
                        {"pcwch"	                ,""},;
                        {"pcwstr"	             ,""},;
                        {"pdword"	             ,""},;
                        {"pfloat"	             ,""},;
                        {"phandle"	             ,""},;
                        {"phkey"	                ,""},;
                        {"pint"	                ,""},;
                        {"plcid"	                ,""},;
                        {"plong"	                ,""},;
                        {"pluid"	                ,""},;
                        {"pointer_32"	          ,""},;
                        {"pointer_64"	          ,""},;
                        {"pshort"	             ,""},;
                        {"pstr"	                ,""},;
                        {"ptbyte"	             ,""},;
                        {"ptbyte"	             ,""},;
                        {"ptchar"	             ,""},;
                        {"ptchar"	             ,""},;
                        {"ptstr"	                ,""},;
                        {"ptstr"	                ,""},;
                        {"puchar"	             ,""},;
                        {"puint"	                ,""},;
                        {"pulong"	             ,""},;
                        {"pushort"	             ,""},;
                        {"pvoid"	                ,""},;
                        {"pwchar"	             ,""},;
                        {"pword"	                ,""},;
                        {"pwstr"	                ,""},;
                        {"regsam"	             ,""},;
                        {"sc_handle"	          ,""},;
                        {"sc_lock"	             ,""},;
                        {"service_status_handle" ,""},;
                        {"short"	                ,""},;
                        {"size_t"	             ,""},;
                        {"ssize_ t"	             ,""},;
                        {"tbyte"	                ,""},;
                        {"tchar"	                ,""},;
                        {"uchar"	                ,""},;
                        {"uint"	                ,""},;
                        {"uint32"	             ,""},;
                        {"uint64"	             ,""},;
                        {"uint_ptr"	             ,""},;
                        {"ulong"	                ,""},;
                        {"ulong32"	             ,""},;
                        {"ulong64"	             ,""},;
                        {"ulonglong"	          ,""},;
                        {"ulong_ptr"	          ,""},;
                        {"unsigned"	             ,""},;
                        {"ushort"	             ,""},;
                        {"void"	                ,""},;
                        {"wchar"	                ,""},;
                        {"winapi"	             ,""},;
                        {"word"	                ,""},;
                        {"wparam"	             ,""} }





return self

*************************************************************************
  METHOD SetStr( cStrFunc ) CLASS TTransfunc
*************************************************************************
local n, cLine
local cStr := ""

  for n := 1 to mlcount( cStrFunc )
      cLine := memoline( cStrFunc, 255, n )
      if "//" $ cLine
         cLine := substr( cLine, 1, at("//", cLine )-1 )
      endif
      cStr += alltrim(cLine)
  next
  ::cStrFunc := cStr

return ::cStrFunc

*************************************************************************
  METHOD GetName()      CLASS TTransFunc
*************************************************************************
  local cName
  local nEn
  local cStr := ""
  local n
  local cLine

  nEn   := at( "(", ::cStrFunc )
  cName := right( substr( ::cStrFunc, 1, nEn-1), len(substr( ::cStrFunc, 1, nEn-1)) - rat(" ", substr( ::cStrFunc, 1, nEn-1) ) )

  return cName

*************************************************************************
  METHOD GetReturn()    CLASS TTransFunc
*************************************************************************
  local cReturn
  local nEn

  nEn := at( ::cName, ::cStrFunc )
  cReturn := alltrim(lower(left( ::cStrFunc, nEn-1)))

  return cReturn

*************************************************************************
  METHOD GetParams()    CLASS TTransFunc
*************************************************************************

   Local cParam
   Local nParent1, nParent2
   Local nPar, cPar
   Local cAnalizaLine := ::cStrFunc
   local cName
   local cType

   // buscar parámetros

   nParent1 := AT( "(", cAnalizaLine )
   nParent2 := AT( ")", cAnalizaLine )

   cParam := alltrim( substr( cAnalizaLine, nParent1, nParent2 - nParent1+1 ) )
   cParam := substr( cParam, 2 )
   cParam := substr( cParam, 1, len( cParam ) - 1 )

   if empty( cParam )
      return {}
   endif

   nPar := 1

   do while .t.

      cPar := strtoken( cParam, nPar, "," )

      if empty( cPar )
         exit
      endif

      cName := right( cPar, len( cPar ) - rat( " ", cPar ) )
      cType := lower(left( cPar, at( cName, cPar )-1 ))

      if left( cName, 2 ) == "lp"
         cName := "*" + substr( cName, 3 )
      endif

      aadd( ::aParams, {cType, cName} )

      nPar++

   enddo

return ::aParams



  return nil

*************************************************************************
  METHOD GetType( n )   CLASS TTransFunc
*************************************************************************
  local cType

  cType := ::aParams[n,1]

  return cType

*************************************************************************
  METHOD GetNameParam( n )   CLASS TTransFunc
*************************************************************************
  local cName

  cName := ::aParams[n,2]

  return cName

*************************************************************************
  METHOD Count( cType )   CLASS TTransFunc
*************************************************************************
  local nCount := 0
  local n

  for n := 1 to len( ::aParams )
      if lower(cType) $ ::aParams[n,1]
         nCount++
      endif
  next

  return nCount




