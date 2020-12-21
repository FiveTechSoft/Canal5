/*--------------------------------------------------------------------------
   Clase           : TListProp
   Autor           : Paco Garcia
   Fecha           : 05.05.2011
   Description     : Inspector de Propiedades
   Nota            : La clase ha estado modificada para adaptarla a la
                     libreria. Gracias Paco por tu contribuci�n
---------------------------------------------------------------------------*/

#include "FiveWin.ch"
#include "InKey.ch"
#include "Set.ch"
#include "Constant.ch"
*#include '.\include\myrpt.ch'

#define GRUPO    "G"
#define CARACTER "C"
#define NUMERO   "N"
#define LOGICO   "L"
#define LISTA    "A"
#define ACCION   "B"
#define SPINNER  "S"

#define CLR_BACKGROUND   rgb(173,197,229)

#define BAR_TOP               1
#define BAR_LEFT              2
#define BAR_RIGHT             3
#define BAR_DOWN              4
#define BAR_FLOAT             5
#define BAR_HEIGHT           28

#define GW_HWNDFIRST          0
#define GW_HWNDLAST           1
#define GW_HWNDNEXT           2
#define GWL_STYLE           -16

#define HWND_BROADCAST    65535  // 0xFFFF

#define CS_DBLCLKS            8
#define COLOR_ACTIVECAPTION   2
#define COLOR_WINDOW          5
#define COLOR_CAPTIONTEXT     9
#define COLOR_HIGHLIGHT      13
#define COLOR_HIGHLIGHTTEXT  14
#define COLOR_BTNFACE        15
#define COLOR_BTNTEXT        18

#define WM_SETFONT           48  // 0x30

// Lines Styles
#define LINES_NONE            0
#define LINES_BLACK           1
#define LINES_GRAY            2
#define LINES_3D              3
#define LINES_DOTED           4
#define LINES_V_BLACK         5
#define LINES_V_GRAY          6
#define LINES_H_BLACK         7
#define LINES_H_GRAY          8

#define TA_LEFT               0
#define TA_RIGHT              2

#define ETO_OPAQUE            2
//#define ETO_CLIPPED         4

#define SM_CYHSCROLL          3

#define MK_MBUTTON           16

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

 #define DT_TOP                   0
#define DT_LEFT                  0
#define DT_CENTER                1
#define DT_RIGHT                 2
#define DT_VCENTER               4
#define DT_BOTTOM                8
#define DT_WORDBREAK             16
#define DT_SINGLELINE            32
#define DT_EXPANDTABS            64
#define DT_TABSTOP               128
#define DT_NOCLIP                256
#define DT_EXTERNALLEADING       512
#define DT_CALCRECT              1024
#define DT_NOPREFIX              2048
#define DT_INTERNAL              4096
#define DT_EDITCONTROL           8192
#define DT_PATH_ELLIPSIS         16384
#define DT_END_ELLIPSIS          32768
#define DT_MODIFYSTRING          65536
#define DT_RTLREADING            131072
#define DT_WORD_ELLIPSIS         262144
#define DT_NOFULLWIDTHCHARBREAK  524288
#define DT_HIDEPREFIX            1048576
#define DT_PREFIXONLY            2097152

static uVarItem
static aCLient
static oTimer
static oMenu

#define CVARNAME   ::aItems[ nItem,  1 ]
#define TIPO       ::aItems[ nItem,  2 ]
#define NOMBRE     ::aItems[ nItem,  3 ]
#define VALOR      ::aItems[ nItem,  4 ]
#define NUMGRUPO   ::aItems[ nItem,  5 ]
#define ABIERTO    ::aItems[ nItem,  6 ]
#define NUMITEM    ::aItems[ nItem,  7 ]
#define ENABLE     ::aItems[ nItem,  8 ]
#define BACTION    ::aItems[ nItem,  9 ]
#define BVALIDAR   ::aItems[ nItem, 10 ]
#define OPTION     ::aItems[ nItem, 11 ]
#define XSETGET    ::aItems[ nItem, 12 ]
#define XPICTURE   ::aItems[ nItem, 13 ]
#define ACTUALIZA  ::aItems[ nItem, 14 ]

*--------------
CLASS TItemProp
*--------------
    DATA aProperty

    METHOD SetValid( bValid )       INLINE ::aProperty[ 10 ] := bValid
    METHOD SetPicture( cPicture )   INLINE ::aProperty[ 13 ] := cPicture
    METHOD SetTable ( bTable  )     INLINE ::aProperty[  9 ] := bTable
    METHOD SetAction( bAction )     INLINE ::aProperty[  9 ] := bAction
    METHOD SetWhen  ( bWhen   )     INLINE ::aProperty[  8 ] := bWhen
    METHOD SetUpdate()              INLINE ::aProperty[ 14 ] := {|| .t. }

    METHOD New( aProperty )  CONSTRUCTOR

ENDCLASS

*--------------------------------------
METHOD New( aProperty ) CLASS TItemProp
*--------------------------------------
    ::aProperty := aProperty

RETU SELF

*---------------------------------
CLASS TListProp FROM TGridExtended
*---------------------------------

      CLASSDATA lRegistered AS LOGICAL

      DATA aGroups
      DATA aItems
      DATA hMinus
      DATA hPlus
      DATA nTipoSort
      DATA nGrupos
      DATA nItem
      DATA aRectBtn
      DATA oObject
      DATA oDlg

      DATA oGet
      DATA oSpinner
      DATA lModify
      DATA bModify

      METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CONSTRUCTOR

      METHOD AddGroup( cGroup ) INLINE ::AddItem( "", cGroup,"",GRUPO,++::nGrupos), ::nGrupos
      METHOD AddItem( cVarName, cName, uVal, nTipo, nGroup, lAbierto, bEnable, bAction, bValid, nOption, xSETGET, cPicture, bUpdate )
      METHOD GetLine()
      METHOD nGetElement( n )
      METHOD CalcLen()
      METHOD Open( lOpen )
      METHOD OpenClose( nRow, nCol )
      METHOD Click( nRow, nCol )

      METHOD Teclas( nKey, nFlags )
      METHOD wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar )
      METHOD PaintBtn( hDC, aRect, nItem )
      METHOD Sort()
      METHOD OpenAll()
      METHOD CloseAll()
      METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems, bAction )
      METHOD GetAction( nItem )
      METHOD SetObject( oObject )
      METHOD aGetRectSel()
      METHOD Reset()
      METHOD ReSize( nSizeType, nWidth, nHeight )
      METHOD Validar( nItem )
      METHOD GoNextCtrl() VIRTUAL
//      METHOD GetDlgCode( nLastKey )
      METHOD KeyDown( nKey, nFlags )
      METHOD PierdeFoco()
      METHOD LButtonDown( nRow, nCol, nKeyFlags )

      METHOD SetModify( lModify )   INLINE ( ::lModify := lModify, Eval( ::bModify ) )

      METHOD SetValue( cVarName, uValue )

ENDCLASS

METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CLASS TListProp

    local o := self
    local oBar, oHand

lPixel := .t.

DEFAULT bValid   := {||.t.}

       ::Super:New( nRow, nCol, nWidth, nHeigth, bLine, {"","",""}, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions )

       ::nItem     := 0
       ::nGrupos   := 0
       ::aItems    := {}
       ::aHeaders  := {"","",""}
       ::aColSizes := {20, 100, 160}
       ::aJustify  := {.f., .f., .f.}
       ::bLogicLen := {|| o:CalcLen() }
       ::nAt := 0
       ::bGoTop    = { || ::nAt := 1 }
       ::bGoBottom = { || ::nAt := Eval( ::bLogicLen, Self ) }
       ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                  ::nAt := Min( Max( ::nAt, 1 ), Eval( ::bLogicLen, Self ) ),;
                  ::nAt - nOld }
       ::hMinus := LoadBitmap( GetResources(), "minus" )
       ::hPlus  := LoadBitmap( GetResources(), "plus" )
       ::bKeyDown := {|nKey, nFlags| o:Teclas( nKey, nFlags ) }
       ::aGroups := {}

       ::bLine := {|| o:GetLine() }
       ::bLClicked := {|nRow,nCol| o:Click( nRow, nCol ) }
       ::bLDblClick := {|nRow,nCol| o:Click( nRow, nCol ) }
       ::nTipoSort := 1 // categorias
       ::lModify := .f.       // CAF
       ::bModify := {|| NIL }  // CAF

       DEFINE CURSOR oHand HAND

       DEFINE BUTTONBAR oBar OF SELF SIZE 26,27 _3D
                        oBar:bRClicked := {|| NIL }
                        oBar:bLClicked := {|| NIL }

       DEFINE BUTTON OF oBar  NAME "btn1"        NOBORDER //TOOLTIP TXT_TIP_CATEGORY   ACTION ( o:nTipoSort := 1,::Sort(), ::GoTop(),o:SetFocus(),o:Refresh())
       DEFINE BUTTON OF oBar  NAME "btn2"        NOBORDER //TOOLTIP TXT_TIP_SORT       ACTION ( o:nTipoSort := 2,::Sort(), ::GoTop(),o:SetFocus(),o:Refresh())
       DEFINE BUTTON OF oBar  NAME "plus" GROUP  NOBORDER //TOOLTIP TXT_TIP_EXPAND     ACTION ::OpenAll()
       DEFINE BUTTON OF oBar  NAME "minus"       NOBORDER //TOOLTIP TXT_TIP_CLOSE_ALL  ACTION ::CloseAll()

       AEval( oBar:aControls,  {|x| x:oCursor := oHand } )

       ::aRectBtn := {}
       ::bLostFocus := {|| ::PierdeFoco() }


return self


METHOD PierdeFoco() CLASS TListProp
local hFocus := GetFocus()


return 0

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TListProp


return ::Super:LButtonDown( nRow, nCol, nKeyFlags )

METHOD KeyDown( nKey, nFlags ) CLASS TListProp



return ::Super:KeyDown( nKey, nFlags )

*********************************************************************
  METHOD Sort() CLASS TListProp
*********************************************************************

if ::nTipoSort == 1
   ::aItems := ASORT(::aItems,,, { |x, y| x[7] < y[7] })
else
   ::aItems := ASORT(::aItems,,, { |x, y| x[3] < y[3] })
endif

return nil

*********************************************************************
    METHOD SetValue( cVarName, uValue ) CLASS TListProp
*********************************************************************
    LOCAL nPos

    cVarName := Upper( cVarName )

    nPos := Ascan( ::aItems , {|x| Upper(x[1]) == cVarName } )

    IF nPos > 0
       ::aItems[nPos][4] := uValue
       ::SetModify( .T. )
    ENDIF

RETU NIL


*********************************************************************
    METHOD aGetRectSel() CLASS TListProp
*********************************************************************
local nTop, nLeft, nBottom, nRight
local aRect := GetClientRect(::hWnd)


   nTop    := (::nRowPos)*::nHLine
   nLeft   := ::aColSizes[1]+::aColsizes[2]
   nBottom := nTop + ::nHLine
   nRight  := aRect[4]

return {nTop, nLeft, nBottom, nRight}


****************************************************************************************************************
   METHOD AddItem( cVarName, cName, uVal, nTipo, nGroup, lAbierto, bEnable, bAction, bValid, nOption, xSETGET, cPicture, bUpdate ) CLASS TListProp
****************************************************************************************************************
   LOCAL aProperty

DEFAULT lAbierto := .t.
DEFAULT nTipo   := CARACTER, nGroup := 1
DEFAULT bEnable := {|| .t.} // CAF
DEFAULT bAction := .f.
DEFAULT bValid  := {|| .t. }
DEFAULT bUpdate := {|| .f. } // CAF


if valtype(uVal) == "L"
   nTipo := LOGICO
endif

::nItem += 5

    aProperty := { cVarName, nTipo, cName, uVal, nGroup, lAbierto, ::nItem, bEnable, bAction, bValid, nOption, xSETGET, cPicture, bUpdate }

    aadd( ::aItems, aProperty )

RETU TItemProp():New( aProperty )



*********************************************************************
      METHOD GetLine() CLASS TListProp
*********************************************************************
local aLine := {"",""}
local nItem := ::nGetElement( ::nAt )
local lGrupo
local uVal

if nItem == 0
   return nil
endif

lGrupo := TIPO == GRUPO

if lGrupo
   aLine := {if(ABIERTO,::hMinus,::hPlus), NOMBRE, cValToChar(VALOR) }
else
   uVal  := VALOR
   if valtype( uVal ) == "N"
      uVal := str(uVal,10)
   endif
   if ValType( XPICTURE ) == 'C'              // CAF
      uVal  := Transform( VALOR, XPICTURE )   // CAF
     else                                     // CAF
      uVal  := cValToChar(VALOR)
   endif
   if uVal == ".T."
      uVal := "Si"
   else
      if uVal == ".F."
         uVal := "No"
      endif
   endif
   aLine := {0, NOMBRE, uVal }
endif

return aLine


*********************************************************************
      METHOD nGetElement( n ) CLASS TListProp
*********************************************************************
local nLenItems := len( ::aItems )
local nCount := 0
local lOpened := .t.
local nItem
local lGrupo

if ::nTipoSort == 1 // grupos
   for nItem := 1 to nLenItems
       if TIPO == GRUPO
          nCount++
          lOpened := ABIERTO
       else
          if lOpened
             nCount++
          endif
       endif
       if nCount == n
          return nItem
       endif
    next
else // sin grupos
   for nItem := 1 to nLenItems
       if TIPO != GRUPO
          nCount++
       endif
       if nCount == n
          return nItem
       endif
    next
endif

return 0

*********************************************************************
      METHOD CalcLen() CLASS TListProp
*********************************************************************
local nLen := len( ::aItems )
local nCount := 0
local nGroup := 0
local lOpened := .t.
local nItem

if ::nTipoSort == 2
   nCount = nLen - ::nGrupos
else
   for nItem := 1 to nLen
       if TIPO == GRUPO
          nCount++
          lOpened := ABIERTO
       else
          if lOpened
             nCount++
          endif
       endif
   next
endif

return nCount



************************************************************************************
   METHOD Open( lOpen ) CLASS TListProp
************************************************************************************
local nItem := ::nGetElement( ::nAt )

DEFAULT lOpen := .t.

if TIPO != GRUPO
   return nil
endif

ABIERTO := lOpen
::Refresh()


return nil

************************************************************************************
   METHOD OpenClose( nRow, nCol ) CLASS TListProp
************************************************************************************
local nItem := ::nGetElement( ::nAt )
local lOpen := .t.

if TIPO != GRUPO
   return nil
endif


if nCol != nil
   if nCol <= ::aColsizes[1]
      ABIERTO := !ABIERTO
      ::Refresh()
   endif

endif

return nil

#define SWP_NOSIZE          1
#define SWP_NOMOVE          2
#define SWP_FRAMECHANGED    32 //0x020  /* The frame changed: send WM_NCCALCSIZE */
#define CB_SHOWDROPDOWN           335

************************************************************************************
   METHOD Click( nRow, nCol,lEditCol ) CLASS TListProp
************************************************************************************
local nItem := ::nGetElement( ::nAt )
local aRect, oLbx, cVar, aItems, cAux
local oDlg, aPos,n, cPos
local o := self
local oFont
local cType := "A"
local uVar
local hDC
local lGrupo := TIPO == GRUPO
local bValid := {||.t.}           //? !empty( ::aRectBtn ) , PtInRect( nRow, nCol, ::aRectBtn ) ,    nRow < 0
local nMax := 0
local uOldVar


DEFAULT lEditCol := .f.

SetFocus(::hWnd)

   if  (::oGet     != nil .and. IsWindowVisible( ::oGet:hWnd   ))   .or.;
       (::oSpinner != nil .and. IsWindowVisible( ::oSpinner:hWnd ))

   endif



if Eval( ENABLE )  // CAF

   if lGrupo .and. nCol <= ::aColsizes[1]
      ABIERTO := !ABIERTO
      ::Refresh()
      return nil
   endif

   if !empty( ::aRectBtn )

      ReleaseCapture()

      if PtInRect( nRow, nCol, ::aRectBtn ) .or. nRow < 0 .OR. TIPO == LISTA

         do case
            case TIPO == LOGICO

                 IF Eval( BVALIDAR, !VALOR )  // CAF

                    VALOR     := !VALOR

                    ::SetModify( .T. )   // CAF

                    ::DrawSelect()
                    if !empty( ::oObject )
                       if !empty( CVARNAME )
                          if valtype( ::oObject ) == "O"
                             OSend( ::oObject, "_" + alltrim( CVARNAME ), VALOR )
                             OSend( ::oObject, "Refresh")
                          else
                             ASend( ::oObject, "_" + alltrim( CVARNAME ), VALOR )
                             ASend( ::oObject, "Refresh")
                          endif
                       endif
                    endif

                    IF Eval( ACTUALIZA )
                       ::Refresh()
                    ENDIF

                 ENDIF

            case TIPO == LISTA

                 aRect := ::aGetRectSel()

                 if BACTION != NIL
//                  Si lo quiero ordenado, se lo paso ya ordenado pues...
*                   aItems := asort(eval( BACTION ))

                    aItems := Eval( BACTION )

                    if !empty( OPTION )
                       cVar := aItems[ OPTION ]
                    else
                       cVar   := VALOR
                    endif

                 endif

*CAF                 SetItem( cVar )
*dbg( cVar )
                 uOldVar := cVar

                 if ::oGet     != nil; ::oGet:Hide();     endif
                 if ::oSpinner != nil; ::oSpinner:Hide(); endif

                 if !empty( aItems )
                    xSetItem( cVar )
                    MENU oMenu POPUP
                    for n := 1 to len( aItems )
                        cAux := "{|oMenuItem| xSetItem('"+ALLTRIM(aItems[n])+"')}"
                        MenuAddItem (aItems[n],, .f.,, &(cAux) ,,,,,,, .F. )
                        if cVar == aItems[n]
                           cPos := str(n-1)
                        endif
                    next
                    ENDMENU
                    if !empty( cPos )
                       SetMenuDefaultItem( oMenu:hMenu, val(cPos))
                    endif
                    ACTIVATE POPUP oMenu AT aRect[3], aRect[2] OF Self
                    oMenu := nil
                 endif

                 cVar := xGetItem()

                 if !empty(cVar ) .and. uOldVar != cVar

                   if Eval( BVALIDAR, cVar )  // CAF

                      ::SetModify( .T. )   // CAF

                      if XSETGET != nil
                         if valtype( ::oObject ) == "O"
                            oSend( ::oObject,"_" + XSETGET, cVar )
                         else
                            ASend( ::oObject,"_" + XSETGET, cVar )
                         endif
                      else
                         if valtype( ::oObject ) == "O"
                            oSend( ::oObject,"_" + CVARNAME, cVar )
                         else
                            aSend( ::oObject,"_" + CVARNAME, cVar )
                         endif
                      endif
                      VALOR     := cVar
                      if valtype( ::oObject ) == "O"
                         ::oObject:Refresh()
                      else
                         asend(::oObject,"Refresh" )
                      endif

                      ::Refresh()

                   endif
                 endif


            case TIPO == ACCION

                  uVar := eval( BACTION, VALOR )

                  if uVar != VALOR

                   if Eval( BVALIDAR, uVar )  // CAF

                     VALOR := uVar

                     if valtype( ::oObject ) == "O"
                        oSend( ::oObject,"_" + CVARNAME, VALOR )
                        oSend( ::oObject,"Refresh" )
                     else
                        aSend( ::oObject,"_" + CVARNAME, VALOR )
                        aSend( ::oObject,"Refresh" )
                     endif

                     ::SetModify( .T. )   // CAF

                     IF Eval( ACTUALIZA ) // CAF
                        ::Refresh()
                     ENDIF

                   endif

                  endif

                  ::Refresh()

                 return VALOR

         endcase
      endif
   else

      if (nCol > ::aColSizes[1]+::aColSizes[2] .OR. lEditCol ) .and. !lGrupo

         ::EditCol( VALOR, nItem, XPICTURE )

      else


      endif

   endif

endif

return .t.

function xSetItem( uVal )
uVarItem := uVal
return uVarItem

function xGetItem()
return uVarItem

function xSelectItem( cPos )

if oMenu != nil .and. oMenu:hMenu != nil
   Tone(1000,1)
   SetMenuDefaultItem( oMenu:hMenu, val(cPos))
   oTimer:End()
endif

return nil


************************************************************************************************************
  METHOD EditCol( uVar, nItem2, cPicture, bValid, nClrFore, nClrBack, aItems, bAction ) CLASS TListProp
************************************************************************************************************

   local oFont
   local uTemp
   local aPos
   local cType
   local nWidth, nHeight
   local nTop, nLeft, nBottom, nRight
   local nItem := ::nGetElement( ::nAt )
   local o := Self
   local aRect
   uTemp   := uVar
   nTop    := (::nRowPos)*::nHLine+2
   nLeft   := ::aColSizes[1]+::aColsizes[2]+1
   nBottom := nTop + ::nHLine-5
   nRight  := nLeft + ::aColSizes[3]
   aRect   := ::aGetRectSel()
   nTop    := aRect[1]+2
   nLeft   := aRect[2]
   nBottom := aRect[3]-2
   nRight  := aRect[4]

   cType   := ValType( uVar )
   if cType == "C"
      uVar := padr(uVar,100)
   endif

   DEFAULT bValid   := nil

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nInpWidth,::oFont:nInpHeight, .f., ::oFont:lBold )
   endif

   if ::oGet     != nil; ::oGet:Hide();     endif
   if ::oSpinner != nil; ::oSpinner:Hide(); endif

   if TIPO == SPINNER

      if ::oSpinner <> nil  // CAF                                                                                     //
         ::oSpinner:End()   // CAF
         ::oSpinner := NIL  // CAF
      endif                 // CAF

      if ::oSpinner == nil                                                                                      //
         ::oSpinner := TGet2():New(nTop + 1,nLeft + 1,{ | u | If(PCount()==0,uVar,uVar:= u ) },Self,nRight-nLeft-20,nBottom-nTop, cPicture,       ,::nClrText,::nClrPane,oFont,     .F.,        ,    .T.,    ,     .F.,      ,     .F.,    .F.,         ,       .F.,       .F.,       .T.,,      .t.,{||::oSpinner++, ::Refresh()}, {||::oSpinner--, ::Refresh()}, {||0}, {||3600} )
         ::oSpinner:bLostFocus := {|| ::oSpinner:Hide() }
      endif

      ::oSpinner:SetFocus()

   else

//     La version anterior Cremos y ocultamos el oGet, pero si cambiamos
//     los picture da problemas. Total si existe, lo cierro, creo uno nuevo
//     y listos...

       if ::oGet <> nil   // CAF
          ::oGet:End()    // CAF
          ::oGet := NIL   // CAF
       endif              // CAF

       ::oGet := TGet2():New( nTop + 1, nLeft + 1, { | u | If( PCount()==0, uVar, uVar:= u ) }, Self, nRight-nLeft, nBottom-nTop, cPicture,, ::nClrText, ::nClrPane, oFont, .F.,, .T.,, .F.,, .F., .F.,, .F., .F., .T., )
       ::oGet:bLostFocus := {|| ::oGet:Hide() }

       ::oGet:SetFocus()

   endif


return uVar

************************************************************************************
   METHOD GetAction( nItem ) CLASS TListProp
************************************************************************************



return nil

************************************************************************************
   METHOD Teclas( nKey, nFlags ) CLASS TListProp
************************************************************************************
local nItem := ::nGetElement(::nAt)
local lGrupo := TIPO == GRUPO
local uVal
local oGet

do case
   case nKey == VK_SPACE

        if lGrupo
           ABIERTO := !ABIERTO
           ::Refresh()
        else
           if TIPO == LISTA
              ::Click(-1)
           else
              if TIPO == LOGICO
                 ::Click( -1 )
                 ::DrawSelect()
              endif
           endif
        endif

   case nKey == VK_F4

        if TIPO == LISTA
           ::Click(-1)
        endif

   case nKey == VK_RETURN

       if TIPO == LISTA
          ::Click(-1)
       else

          if TIPO == SPINNER
             oGet := ::oSpinner
          else
             oGet := ::oGet
          endif

          if oGet != nil

             if IsWindowVisible( oGet:hWnd )

                oGet:Assign()

                IF Eval( BVALIDAR, oGet:oGet:VarGet() )

                   oGet:VarPut( oGet:oGet:VarGet())
                   uVal := oGet:VarGet()
                   if valtype( uVal ) == "C"
                      if !empty( trim( uVal ) )
                         uVal := trim( uVal )
                      endif
                   endif
                   if valtype( ::oObject ) == "O"
                      oSend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
                   else
                      ASend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
                   endif

                   IF !( VALOR == uVal )
                       ::SetModify( .T. )   // CAF
                   ENDIF

                   VALOR := uVal

                   ::DrawSelect()  // CAF

                   IF Eval( ACTUALIZA ) // CAF
                      ::Refresh()
                   ENDIF

                   if ::oGet != nil;     ::oGet:Refresh();     endif
                   if ::oSpinner != nil; ::oSpinner:Refresh(); endif
                   oGet:Hide()
                   SetFocus(::hWnd)

                ENDIF

*                oReport():Refresh()
*Dbg( 'oReport:Refresh()' )
             else
                ::Click(-1,-1,.t.)
             endif
          else
             ::Click(-1,-1,.t.)
          endif
       endif

   case lGrupo .and. nKey == VK_SUBTRACT

        if ABIERTO
           ABIERTO := .f.
           ::Refresh()
        endif

   case lGrupo .and. nKey == VK_ADD
        if !ABIERTO
           ABIERTO := .t.
           ::Refresh()
        endif

   case nKey == VK_ESCAPE

        if ::oGet     != nil; ::oGet:Hide();     endif
        if ::oSpinner != nil; ::oSpinner:Hide(); endif

endcase


return nil

************************************************************************************
METHOD wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar ) CLASS TListProp
************************************************************************************

local nItem, aRect
local lGrupo := .f.
local lHDC := .f.
DEFAULT lBar := .f.

::Super:wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar )


if lBar

   nItem := ::nGetElement( ::nAt )

   if ! Eval( ENABLE ) // CAF
      return nil
   endif

   aRect := GetClientRect( ::hWnd )

   if ::hDC == nil
      ::hDC := ::GetDC()
      lHDC := .t.
   endif

   aRect[1] := (nRowPos)*::nHLine
   aRect[3] := aRect[1]+::nHLine
   aRect[4] := aRect[4]-1

   ::PaintBtn( ::hDC, aRect, nItem )

   if lHDC
      ::ReleaseDC()
   endif

endif

return nil

#define OBM_COMBO           32738
#define SRCCOPY 13369376
****************************************************************************************
  METHOD PaintBtn( hDC, aRect, nItem ) CLASS TListProp
****************************************************************************************
local nTipo := TIPO
local hBmp
local nMedH := (aRect[3]-aRect[1]) / 2
local nMedW := (aRect[4]-aRect[2]) / 2
local nTop  := aRect[1] + nMedH
local nLeft := aRect[4] - 20


aRect[2] := aRect[4]-( aRect[3]-aRect[1])
do case
   case nTipo == LOGICO

        aRect[1] := nTop  - 6
        aRect[2] := nLeft - 6
        aRect[3] := nTop  + 7
        aRect[4] := nLeft + 7

        DrawFrameControl( hDC, aRect, 4, if(VALOR,1024,0)  )//+16384
        ::aRectBtn := aRect

   case nTipo == LISTA

        aRect[1]+=1
        aRect[2]+=1
        aRect[3]-=1
        aRect[4]-=1
        aRect[2] := aRect[4]-18

        hBmp := LoadBitmap( , OBM_COMBO )
        DrawFrameControl( hDC, aRect, 4, 16 ) //+16384
        DrawMasked( hDC, hBmp, nTop -5, aRect[2]+3 )
        //aRect[1]+5, aRect[2]+5 )
        DeleteObject( hBmp )
        ::aRectBtn := aRect

        case TIPO == ACCION

        DrawFrameControl( hDC, aRect, 4, 16 )//+16384
        SetBkMode( hDC, 1 )
        TextOut( hDC, aRect[1]+2, aRect[2]+5, "...")
        ::aRectBtn := aRect

   otherwise

        ::aRectBtn := {}

endcase

return nil
******************************************************************************
      METHOD OpenAll() CLASS TListProp
******************************************************************************
local nItem
for nItem := 1 to len( ::aItems )
    if TIPO == GRUPO
       ABIERTO := .t.
    endif
next
::GoTop()
::Refresh()

return nil
******************************************************************************
      METHOD CloseAll() CLASS TListProp
******************************************************************************
local nItem
for nItem := 1 to len( ::aItems )
    if TIPO == GRUPO
       ABIERTO := .f.
    endif
next
::GoTop()
::Refresh()

return nil



****************************************************************************************
  METHOD Validar( nItem ) CLASS TListProp
****************************************************************************************
local uVal

DEFAULT nItem := ::nAt


if ::oGet != nil

   if nItem <= len( ::aItems ) .and. !empty( CVARNAME )

      uVal := ::oGet:VarGet()
      if valtype( ::oObject ) == "O"
         oSend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
      else
         ASend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
      endif
      VALOR := uVal

   endif

   if BVALIDAR != nil
      eval( BVALIDAR, VALOR )
   endif

*CAF   oReport():Refresh()
*dbg(  ' oReport():Refresh()' )

endif

return .t.

****************************************************************************************
  METHOD Reset( ) CLASS TListProp
****************************************************************************************
local n, nItem, nLen

asize(::aItems, 0 )
asize(::aGroups, 0 )
::aItems  := {}
::aGroups := {}
::nAt     := 0
::nItem   := 0
::nGrupos := 0
::lModify := .F.   // CAF

::GoTop()

return nil


****************************************************************************************
  METHOD SetObject( oObject ) CLASS TListProp
****************************************************************************************
local n, nItem, nLen

asize(::aItems, 0 )
asize(::aGroups, 0 )
::nItem := 0
::nGrupos := 0

::oObject := oObject

nLen := len( oObject:aProperties )
nItem := 1
aadd( ::aItems, array(8) )
TIPO     := GRUPO
NOMBRE   := oObject:ClassName()
VALOR    := ""
NUMGRUPO :=  ++::nGrupos
ABIERTO  := .T.
NUMITEM  := ( ::nItem += 5 )
ENABLE   := {|| .T. } // CAF
BACTION  := {||.T.}

for n := 1 to nLen
    nItem := n+1
    aadd( ::aItems, array(8) )
    TIPO     := valtype( OSend( oObject, oObject:aProperties[n] ) )
    NOMBRE   := oObject:aProperties[n]
    VALOR    := OSend( oObject, oObject:aProperties[n] )
    NUMGRUPO := ::nGrupos
    ABIERTO  := .T.
    NUMITEM  := ( ::nItem += 5 )
    ENABLE   := {|| .T. } // CAF
    BACTION  := {||.T.}
next

::GoTop()
::Refresh()

return nil

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TListProp
local aC := GetClientRect( ::hWnd )
local nWC := aC[4]-aC[2]
local nW := ::aColSizes[1]+::aColSizes[2]

   ::aColSizes[3] := nWC - nW

return ::Super:ReSize( nSizeType, nWidth, nHeight )




CLASS TGridExtended FROM TControl

   DATA   cAlias, cField, uValue1, uValue2
   DATA   bLine, bSkip, bGoTop, bGoBottom, bLogicLen, bChange
   DATA   nRowPos, nColPos, nLen, nAt, nColAct
   DATA   nMaxFilter      // Maximum number of records to count
                          // on indexed filters
   DATA   lHitTop, lHitBottom, lCaptured, lMChange
   DATA   lAutoEdit, lAutoSkip
   DATA   lCellStyle AS LOGICAL INIT .f.
   DATA   aHeaders, aColSizes
   DATA   nClrBackHead, nClrForeHead
   DATA   nClrBackFocus, nClrForeFocus
   DATA   aJustify, aActions
   DATA   oGet
   DATA   nLineStyle
   DATA   lIconView, aIcons, bIconDraw, bIconText
   DATA   nIconPos, nVScrollPos
   DATA   nHLine

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1,;
                    uVal2, bChange, bLDblClick, bRClick, oFont,;
                    oCursor, nClrFore, nClrBack, cMsg, lUpdate,;
                    cAlias, bWhen, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD nAtCol( nCol )
   METHOD nAtIcon( nRow, nCol )

   METHOD LDblClick( nRow, nCol, nKeyFlags )
   METHOD Default()

   METHOD Display()

   METHOD DrawIcons()

   METHOD DrawLine( nRow ) INLINE ;
               ::wBrwLine( ::hWnd, ::hDC, If( nRow == nil, ::nRowPos, nRow ), ;
               Eval( ::bLine, Self ), ::GetColSizes(), ::nColPos,;
               ::nClrText, ::nClrPane,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),;
               ValType( ::aColSizes ) == "B", ::aJustify, nil, ::nLineStyle,,, ::oVScroll,;
               ::bLogicLen  )

   METHOD DrawSelect()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD GetColSizes() INLINE ;
          If( ValType( ::aColSizes ) == "A", ::aColSizes, Eval( ::aColSizes, Self ) )

   METHOD GetDlgCode( nLastKey )

   METHOD GoUp()
   METHOD GoDown()
   METHOD GoLeft()
   METHOD GoRight()
   METHOD GoTop()
   METHOD GoBottom()

   METHOD GotFocus() INLINE ::Super:GotFocus(),;
                  If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                      ! ::lIconView, ::DrawSelect(),)

   METHOD HScroll( nWParam, nLParam )

   MESSAGE DrawIcon METHOD _DrawIcon( nIcon, lFocused )

   METHOD Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::Default()
   METHOD IsColVisible( nCol )
   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )
   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )


   METHOD LostFocus( hCtlFocus ) INLINE ::Super:LostFocus( hCtlFocus ),;
                   If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                   ! ::lIconView, ::DrawSelect(),)

   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD Paint()

   METHOD ReSize( nSizeType, nWidth, nHeight )

   //METHOD nRowCount() INLINE nWRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ) ) - 1
   METHOD nRowCount() INLINE aClient := GetClientRect(::hWnd), int( ( aClient[3]-aClient[1]) / ::nHLine )-1

   METHOD SetArray( aArray )
   METHOD SetCols( aData, aHeaders, aColSizes )
   METHOD ShowSizes()
   METHOD Skip( n )
   METHOD VertLine( nColPos, nColInit )
   METHOD VScroll( nWParam, nLParam )

   METHOD VSetPos( nPos ) INLINE ::nVScrollPos := nPos,;
                                 ::oVScroll:SetPos( iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                         nPos,;
                                                         Int( nPos * VSCROLL_MAXVALUE / ::nLen ) ) )

   METHOD VThumbPos( nPos ) INLINE ::nVScrollPos := ::VGetThumbPos( nPos ),;
                                   ::oVScroll:SetPos( nPos )

   METHOD VGetPos()       INLINE ::nVScrollPos

   METHOD VSetRange()     INLINE ::nVScrollPos := 1,;
                                 ::oVScroll:SetRange( Min( 1, ::nLen ), Min( VSCROLL_MAXVALUE, ::nLen ) )

   METHOD VGetMax()       INLINE ::oVScroll:nMax * iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                        1,;
                                                        ::nLen / VSCROLL_MAXVALUE )

   METHOD VGoDown()       INLINE ::VSetPos( ::nVScrollPos + 1 )
   METHOD VGoUp()         INLINE ::VSetPos( ::nVScrollPos - 1 )

   METHOD VGetThumbPos( nPos ) INLINE iif( ::nLen <= VSCROLL_MAXVALUE,;
                                           nPos,;
                                           Int( nPos * ::nLen / VSCROLL_MAXVALUE ) )

    METHOD VGoBottom() INLINE ::VSetPos( ::nLen )

    METHOD VGoTop() INLINE ::VSetPos( 1 )

    METHOD wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, aColSizes, oWnd,;
            cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
            oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
            lPixel, bWhen, lDesign, bValid, bLClick, aActions ) CLASS TGridExtended

#ifdef __XPP__
   #undef New
#endif

   DEFAULT nRow := 0, nCol := 0, nHeigth := 100, nWidth := 100,;
           oWnd := GetWndDefault(), oFont := oWnd:oFont, nClrFore := CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., cAlias := Alias(), lPixel := .f.,;
           lDesign  := .f., bValid := {||.t.}

   #ifdef __XPP__
      DEFAULT cAlias := ""
   #endif
   ::aProperties := {"nTop","nLeft","nBottom","nRight","nClrPane","nClrText","nColPos","nId","lAutoEdit","nHLine","lCellStyle","cAlias"}
   ::cCaption   = ""
   ::nTop       = nRow * If( lPixel, 1, BRSE_CHARPIX_H ) // 14
   ::nLeft      = nCol * If( lPixel, 1, BRSE_CHARPIX_W )  //8
   ::nBottom    = ::nTop + nHeigth - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::oWnd       = oWnd
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1

   ::nStyle     = nOr( WS_CHILD, WS_VSCROLL, ;
                       WS_VISIBLE, WS_TABSTOP,;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )  // WS_HSCROLL, WS_BORDER


   ::nId        = ::GetNewId()
   ::cAlias     = cAlias
   ::bLine      = bLine
   ::lAutoEdit  = .f.
   ::lAutoSkip  = .f.
   ::lIconView  = .f.
   ::lCellStyle = .f.
   ::nIconPos   = 0
   ::nHLine     := 27  // 23 CAF
   ::bLogiclen  = { || 0 }  // CAF

   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nLen       = 0
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor

   //::nLineStyle    := LINES_3D
   ::nLineStyle    := LINES_GRAY
   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := GetSysColor( COLOR_BTNTEXT )
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := CLR_WHITE

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::nVScrollPos   = 0

   ::SetColor( nClrFore, nClrBack )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      if oFont != nil
         ::SetFont( oFont )
      endif
      ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      ::oFont := oFont
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                 bChange, bLDblClick, bRClick, oFont, oCursor,;
                 nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                 bWhen, bValid, bLClick, aActions ) CLASS TGridExtended

   DEFAULT oDlg := GetWndDefault(), nClrFore := CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_WINDOW ), lUpdate := .f., cAlias := Alias()

   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::nId        = nId
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::cAlias     = cAlias
   ::oWnd       = oDlg
   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nClrPane   = CLR_LIGHTGRAY
   ::nClrText   = CLR_WHITE
   ::nLen       = 0
   ::lDrag      = .f.
   ::lCaptured  = .f.
   ::lVisible   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.

   ::bLine      = bLine
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor
   ::oFont      = oFont

   ::nLineStyle    := LINES_GRAY
   //::nLineStyle    := LINES_3D
   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := CLR_BLACK
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := CLR_WHITE

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::lAutoEdit     = .f.
   ::lAutoSkip     = .f.
   ::lIconView     = .f.
   ::lCellStyle    = .f.
   ::nIconPos      = 0
   ::nVScrollPos   = 0
   ::bLogiclen     = { || 0 }  // CAF

   ::SetColor( nClrFore, nClrBack )

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   oDlg:DefControl( Self )

return Self



//----------------------------------------------------------------------------//

METHOD DrawSelect() CLASS TGridExtended

   if ::lCellStyle
      ::DrawLine()
      ::wBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle,;
                ::nColAct, ::lFocused, ::oVScroll, ::bLogicLen )
   else
      ::wBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle, nil,;
                ::lFocused, ::oVScroll, ::bLogicLen, .t. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DrawIcons() CLASS TGridExtended

   local nWidth := ::nWidth(), nHeight := ::nHeight()
   local nRow := 10, nCol := 10
   local n := 1, nIcons := Int( nWidth / 50 ) * Int( nHeight / 50 )
   local hIcon := ExtractIcon( "user.exe", 0 )
   local oFont, cText

   DEFINE FONT oFont NAME GetSysFont() SIZE 0, -8 UNDERLINE

   SelectObject( ::hDC, oFont:hFont )
   SetBkColor( ::hDC, CLR_BLUE )
   SetTextColor( ::hDC, CLR_WHITE )

   while n <= nIcons .and. ! ( ::cAlias )->( EoF() )
      if ::bIconDraw != nil .and. ::aIcons != nil
         hIcon = ::aIcons[ Eval( ::bIconDraw, Self ) ]
      endif
      DrawIcon( ::hDC, nRow, nCol, hIcon )
      if ::bIconText != nil
         cText = cValToChar( Eval( ::bIconText, Self ) )
      else
         cText = Str( ( ::cAlias )->( RecNo() ) )
      endif
      DrawText( ::hDC, cText, { nRow + 35, nCol - 5, nRow + 48, nCol + 40 },;
                1 )
      nCol += 50
      if nCol >= nWidth - 32
         nRow += 50
         nCol  = 10
      endif
      ( ::cAlias )->( DbSkip() )
      n++
   end
   ( ::cAlias )->( DbSkip( 1 - n ) )

   oFont:End()

return nil

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TGridExtended
local aC := GetClientRect( ::hWnd )
local nWC := aC[4]-aC[2]
local nW := ::aColSizes[1]+::aColSizes[2]

   ::nRowPos = Min( ::nRowPos, Max( ::nRowCount(), 1 ) )
   ::aColSizes[3] := nWC - nW

return ::Super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SetArray( aArray ) CLASS TGridExtended

   ::nAt       = 1
   ::cAlias    = "ARRAY"
   // ::bLine     = { || { aArray[ ::nAt ] } }
   ::bLogicLen = { || ::nLen := Len( aArray ) }
   ::bGoTop    = { || ::nAt := 1 }
   ::bGoBottom = { || ::nAt := Eval( ::bLogicLen, Self ) }
   ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                  ::nAt := Min( Max( ::nAt, 1 ), Eval( ::bLogicLen, Self ) ),;
                  ::nAt - nOld }
return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TGridExtended

   local n := 1, nSkipped := 1, nLines
   local aInfo := ::DispBegin()

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   if ::lIconView
      ::DrawIcons()
      return 0
   endif

   if ::nRowPos == 1 .and. ! Empty( ::cAlias ) .and. ;
      Upper( ::cAlias ) != "ARRAY"
      if ! ( ::cAlias )->( EoF() )
         ( ::cAlias )->( DbSkip( -1 ) )
         if ! ( ::cAlias )->( BoF() )
            ( ::cAlias )->( DbSkip() )
         endif
      endif
   endif

   ::wBrwLine( ::hWnd, ::hDC, 0, ::aHeaders, ::GetColSizes(),;
               ::nColPos, ::nClrForeHead, ::nClrBackHead,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                  ::aJustify, nil, ::nLineStyle,,, ::oVScroll, ::bLogicLen )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) > 0

      ::Skip( 1 - ::nRowPos )

      #ifndef __CLIPPER__
         nLines = ::nRowCount()
         while n <= nLines .and. nSkipped == 1
            ::DrawLine( n )
            nSkipped = ::Skip( 1 )
            if nSkipped == 1
               n++
            endif
         end
         ::Skip( ::nRowPos - n )
      #else
          // WBrwPane() returns the n� of visible rows
          // WBrwPane recieves at aColSizes the Array or a Block
          // to get dinamically the Sizes !!!
         ::Skip( ::nRowPos - wBrwPane( ::hWnd, ::hDC, Self, ::bLine,;
              ::aColSizes, ::nColPos, ::nClrText, ::nClrPane,;
              If( ::oFont != nil, ::oFont:hFont, 0 ), ::aJustify, ::nLineStyle ) )
      #endif

      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif

      ::DrawSelect()
   endif

   if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
      ::lHitTop    = ( ::cAlias )->( BoF() )
      ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

   ::DispEnd( aInfo )

return 0

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TGridExtended

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1
            ::nRowPos--
         else
            WBrwScroll( ::hWnd, -1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::nHLine )
         endif
      else
         ::lHitTop = .t.
      endif
      ::DrawSelect()
      if ::oVScroll != nil
         ::VGoUp()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TGridExtended

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            WBrwScroll( ::hWnd, 1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::nHLine )
         endif
      else
         ::lHitBottom = .t.
      endif
      ::DrawSelect()
      if ::oVScroll != nil
         ::VGoDown()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoLeft()  CLASS TGridExtended

   if ::nColAct > 1
      if ::lCellStyle .and. ::IsColVisible( ::nColAct-1 )
         ::nColAct--
         ::DrawSelect()
      else
         ::nColPos--
         ::nColAct--
         ::Refresh()
      endif
      if ::oHScroll != nil
         ::oHScroll:GoUp()
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoRight() CLASS TGridExtended

   local lColVisible

   if ::nColAct < Len( ::GetColSizes() )
      lColVisible = ::IsColVisible( ::nColAct + 1 )
      ::nColAct++
      do while ! ::IsColVisible( ::nColAct ) .and. ::nColPos < ::nColAct
         ::nColPos++
      enddo
      if ! ::lCellStyle
         ::nColPos := ::nColAct
         ::Refresh()
      else
         if lColVisible
            ::DrawSelect()
         else
            ::Refresh()
         endif
      endif
      if ::oHScroll != nil
         ::oHScroll:GoDown()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TGridExtended

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      Eval( ::bGoTop, Self )
      ::lHitTop = .t.
      ::lHitBottom = .f.
      ::nRowPos = 1
      ::Refresh( .f. )
      if ::oVScroll != nil
         ::VGoTop()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TGridExtended

   local nSkipped
   local nLines := ::nRowCount()
   local n

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::lHitBottom = .t.
      ::lHitTop    = .f.

      Eval( ::bGoBottom, Self )

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      ::GetDC()
      for n = 1 to -nSkipped
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()
      ::ReleaseDC()
      if ::oVScroll != nil
         ::nLen = Eval( ::bLogicLen, Self )
         if ::VGetMax() != ::nLen
            ::VSetRange()
         endif
         ::VGoBottom()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TGridExtended

   local nClickRow := nWRow( ::hWnd, ::hDC, nRow,;
                             If( ::oFont != nil, ::oFont:hFont, 0 ), ::nHLine )
   local nBrwCol

   if nClickRow == ::nRowPos .and. ::nLen > 0
      nBrwCol = ::nAtCol( nCol )
      if ::lAutoEdit
         ::Edit( nBrwCol )
      else
         return ::Super:LDblClick( nRow, nCol, nKeyFlags )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function nWRow( hWnd, hDC, nRow, oFont, nHLine )
local aRect := GetClientRect( hWnd )

nRow := int( nRow/nHLine)

return nRow

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TGridExtended

   local nClickRow, nSkipped
   local nColPos := 0, nColInit := ::nColPos - 1
   local nAtCol

   SetFocus(::hWnd)

   if ::oGet != nil
      ::oGet:Hide()
   endif

   if ::lDrag
      return ::Super:LButtonDown( nRow, nCol, nKeyFlags )
   endif

   nClickRow = nWRow( ::hWnd, ::hDC, nRow, If( ::oFont != nil, ::oFont:hFont, 0 ),::nHline )

   if ::nLen < 1 .and. nClickRow != 0
      return nil
   endif

   if ::lMChange .and. AScan( ::GetColSizes(),;
             { | nColumn | nColPos += nColumn,;
                           nColInit++,;
                           nCol >= nColPos - 1 .and. ;
                           nCol <= nColPos + 1 }, ::nColPos ) != 0
      if ! ::lCaptured
         ::lCaptured = .t.
         ::Capture()
         ::VertLine( nColPos, nColInit )
      endif
      return nil
   endif

   ::SetFocus()

   if nClickRow == 0 .and. Valtype(nKeyFlags) == "N"
      if ::aActions != nil .and. ;
         ( nAtCol := ::nAtCol( nCol ) ) <= Len( ::aActions )
            if ::aActions[ nAtCol ] != nil
               ::wBrwLine( ::hWnd, ::GetDC(), 0, ::aHeaders, ::GetColSizes(),;
                         ::nColPos, ::nClrForeHead, ::nClrBackHead,;
                         If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                         ::aJustify, nAtCol, ::nLineStyle,,, ::oVScroll, ::bLogicLen )
               ::ReleaseDC()
               Eval( ::aActions[ nAtCol ], Self, nRow, nCol )
               ::wBrwLine( ::hWnd, ::GetDC(), 0, ::aHeaders, ::GetColSizes(),;
                         ::nColPos, ::nClrForeHead, ::nClrBackHead,;
                         If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                         ::aJustify,, ::nLineStyle,,, ::oVScroll, ::bLogicLen )
               ::ReleaseDC()
            else
               MsgBeep()
            endif
      else
         MsgBeep()
      endif
   endif

   if nClickRow > 0 .and. nClickRow != ::nRowPos .and. ;
      nClickRow < ::nRowCount() + 1
      ::DrawLine()
      nSkipped  = ::Skip( nClickRow - ::nRowPos )
      ::nRowPos += nSkipped
      if ::oVScroll != nil
         ::VSetPos( ::VGetPos() + nSkipped )
      endif
      if ::lCellStyle
           ::nColAct := ::nAtCol( nCol )
           if ::oHScroll != nil
              ::oHScroll:SetPos(::nColAct)
           endif
      endif
      ::DrawSelect()
      ::lHitTop = .f.
      ::lHitBottom = .f.
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   else
      if ::lCellStyle
           ::nColAct := ::nAtCol( nCol )
           if ::oHScroll != nil
              ::oHScroll:SetPos(::nColAct)
           endif
           ::Refresh(.f.)
      endif
   endif

   ::Super:LButtonDown( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TGridExtended
local aC := GetClientRect( ::hWnd )
local nWC := aC[4]-aC[2]
local nW := ::aColSizes[1]+::aColSizes[2]

   if ::lDrag
      return ::Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()
      ::aColSizes[3] := nWC - nW
      ::VertLine()
      ::Refresh()
   endif

   ::Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TGridExtended

   local n, aFields
   local cAlias := Alias()
   local nElements, nTotal := 0

   DEFAULT ::aHeaders := {}, ::aColSizes := {}

   if ::bLine == nil
      if Empty( ::cAlias )
         ::cAlias = cAlias
      else
         cAlias = ::cAlias
      endif
      ::bLine  = {|| {} }
      if ::aJustify == nil
         ::aJustify = Array( nElements := Len( Eval( ::bLine, Self ) ) )
         for n = 1 to nElements
             ::aJustify[ n ] = ( ValType( ( cAlias )->( FieldGet( n ) ) ) == "N" )
         next
      endif
   endif

   DEFAULT nElements := Len( Eval( ::bLine, Self ) )

   if Len( ::aHeaders ) < nElements
      if ::Cargo == nil
         ::aHeaders = Array( nElements )
         for n = 1 to nElements
             ::aHeaders[ n ] = ( cAlias )->( FieldName( n ) )
         next
      else
         ::aHeaders = { "" }
      endif
   endif

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = Afill(Array( nElements ), 0 )
      aFields = Eval( ::bLine, Self )
      for n = 1 to nElements
          ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                   15,; // Bitmap handle
                                   GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ),;
                                   If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
      next
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_VSCROLL ) .or. ;
      GetClassName( ::hWnd ) == "ListBox"
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
      ::nLen := Eval( ::bLogicLen, Self )
      ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )
      ::VSetRange()
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_HSCROLL )
      if ::Cargo == nil // it is not a tree
         DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
            RANGE 1, Len( ::GetColSizes() )
         AEval( ::GetColSizes(), { | nSize | nTotal += nSize } )
         ::oHScroll:SetPage( nTotal / ::nWidth() )
      endif
   endif

   if ::uValue1 != nil
      Eval( ::bGoTop, Self )
   endif
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TGridExtended

   do case
      case nKey == VK_UP
           ::GoUp()

      case nKey == VK_DOWN
           ::GoDown()

      case nKey == VK_LEFT
           ::GoLeft()

      case nKey == VK_RIGHT
           ::GoRight()

      case nKey == VK_HOME
           ::GoTop()

      case nKey == VK_END
           ::GoBottom()

      case nKey == VK_PRIOR
           if GetKeyState( VK_CONTROL )
              ::GoTop()
           else
              ::PageUp()
           endif

      case nKey == VK_NEXT
           if GetKeyState( VK_CONTROL )
              ::GoBottom()
           else
              ::PageDown()
           endif

      otherwise
           return ::Super:KeyDown( nKey, nFlags )
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TGridExtended

   do case
      case nKey == K_PGUP
           ::oVScroll:PageUp()

      case nKey == K_PGDN
           ::oVScroll:PageDown()

      otherwise
           return ::Super:KeyChar( nKey, nFlags )
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TGridExtended

   local nSkipped

   DEFAULT nLines := ::nRowCount()

   nSkipped = ::Skip( -nLines )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1
            if ::oVScroll != nil
               ::VSetPos( 1 )
            endif
         else

            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )

            if ::oVScroll != nil
               ::VSetPos( ::VGetPos() + nSkipped )
            endif

         endif
         ::Refresh( .f. )
         if ::bChange != nil
            Eval( ::bChange, Self )
         endif

      endif

   else
      if ::oVScroll != nil
         ::VGoTop()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TGridExtended

   local nSkipped, n

   DEFAULT nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::GetDC()
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::ReleaseDC()
                 ::Skip( 1 )
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.
              if ::oVScroll != nil
                 ::VGoBottom()
              endif

         otherwise
              ::GetDC()
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::ReleaseDC()
              ::Skip( ::nRowPos )
      endcase
      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

      if ::oVScroll != nil
         if ! ::lHitBottom
            ::VSetPos( ::VGetPos() + nSkipped - ( nLines - ::nRowPos ) )
         else
            ::VGoBottom()
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TGridExtended

   local nLines := ::nRowCount()
   local nLen

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrHandle  := nLParam
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   if nScrHandle == 0                   // Window ScrollBar
      if ::oVScroll != nil
                  do case
                  case nScrollCode == SB_LINEUP
                          ::GoUp()

                  case nScrollCode == SB_LINEDOWN
                          ::GoDown()

                  case nScrollCode == SB_PAGEUP
                          ::PageUp()

                  case nScrollCode == SB_PAGEDOWN
                          ::PageDown()

                  case nScrollCode == SB_TOP
                          ::GoTop()

                  case nScrollCode == SB_BOTTOM
                          ::GoBottom()

                  case nScrollCode == SB_THUMBPOSITION
               if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
                          return 0
                          endif

               if nPos <= 1
                          ::GoTop()
                          elseif nPos == ::oVScroll:GetRange()[ 2 ]
                          ::GoBottom()
                          else
                          CursorWait()
                  ::Skip( ::VGetThumbPos( nPos ) - ::VGetPos() )
                          ::lHitTop = .f.
                          ::lHitBottom = .f.
                          CursorArrow()
                          endif
               ::VThumbPos( nPos )

               nLen = Eval( ::bLogicLen, Self )
                          if nPos - ::oVScroll:nMin < nLines
                          ::nRowPos = 1
                          endif
                          if ::oVScroll:nMax - nPos < Min( nLines, nLen )
                          ::nRowPos = Min( nLines, nLen ) - ( ::oVScroll:nMax - nPos )
                          endif
                          ::Refresh( .f. )
                          if ::bChange != nil
                          Eval( ::bChange, Self )
                          endif

                  otherwise
                          return nil
                          endcase
                          endif
                  endif

return 0

//----------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TGridExtended

   local nCol := ::nColPos

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrHandle  := nLParam
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if ::oGet != nil .and. ! Empty( ::oGet:hWnd )
      ::oGet:Hide()
   endif

   do case
      case nScrollCode == SB_LINEUP
           ::GoLeft()

      case nScrollCode == SB_LINEDOWN
           ::GoRight()

      case nScrollCode == SB_PAGEUP
           while ::nColPos > 1 .and. ;
                (::IsColVisible( nCol ) .or. ::nColPos == nCol)
              ::nColPos--
           end
           ::nColAct := ::nColPos
           ::oHScroll:SetPos( ::nColAct )
           ::Refresh( .f. )

      case nScrollCode == SB_PAGEDOWN
           while nCol < Len( ::GetColSizes() ) .and. ;
                (::IsColVisible( nCol ) .or. ::nColPos == nCol)
              nCol++
           end
           ::nColPos := nCol
           ::nColAct := nCol
           ::oHScroll:SetPos( nCol )
           ::Refresh( .f. )

      case nScrollCode == SB_TOP
           ::nColPos = 1
           ::nColAct = 1
           ::oHScroll:SetPos( 1 )
           ::Refresh( .f. )

      case nScrollCode == SB_BOTTOM
           ::nColPos = Len( ::GetColSizes() )
           ::nColAct = ::nColPos
           ::oHScroll:SetPos( ::nColPos )
           ::Refresh( .f. )

      case nScrollCode == SB_THUMBPOSITION
           ::nColPos = nPos
           ::nColAct = ::nColPos
           ::oHScroll:SetPos( nPos )
           ::Refresh( .f. )

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TGridExtended

retu Eval( ::bSkip, n, Self )

//----------------------------------------------------------------------------//

static function GenLocal( aArray, nPos )

return { || If( nPos <= Len( aArray ), aArray[ nPos ], "  " ) }

static function GenBlock( bLine, nPos ) ;  return { || Eval( bLine )[ nPos ] }

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TGridExtended

   local nColPos := 0
   local aColSizes

   if ::lDrag
      return ::Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::lCaptured
      CursorWE()
      ::VertLine( nCol )
      return 0
   endif
   aColSizes := ::GetColSizes()
   if ::lMChange .and. AScan( aColSizes,;
              { | nColumn | nColPos += nColumn,;
                            nCol >= nColPos - 1 .and. ;
                            nCol <= nColPos + 1 }, ::nColPos ) != 0
      if nColPos > aColSizes[1]+2
         CursorWE()
      endif
   else
      if !empty( ::aRectBtn ) .and. PtInRect( nRow, nCol, ::aRectBtn )
         CursorHand()
      else
         ::Super:MouseMove( nRow, nCol, nKeyFlags )
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TGridExtended

   local aPos := { nYPos, nXPos }

   aPos = ScreenToClient( ::hWnd, aPos )

//   if aPos[ 1 ] > ::nHeight * 0.80
//      if nDelta > 0
//         ::GoLeft()
//      else
//         ::GoRight()
//      endif
//   else
      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            ::PageUp()
         else
            ::PageDown()
         endif
      else
         if nDelta > 0
            ::GoUp()
         else
            ::GoDown()
         endif
      endif
//   endif

return nil

//----------------------------------------------------------------------------//

#ifndef __HARBOUR__
Dll32 Static Function GetMsgInfo() AS LONG PASCAL ;
      FROM "GetMessageExtraInfo" LIB "User32.dll"
#endif

//----------------------------------------------------------------------------//

METHOD VertLine( nColPos, nColInit ) CLASS TGridExtended

   local oRect, aSizes, nFor

   static nCol, nWidth, nMin, nOldPos := 0

   if nColInit != nil
      nCol    = nColInit
      nWidth  = nColPos
      nOldPos = 0
      nMin := 0
      aSizes := ::GetColSizes()

      FOR nFor := ::nColPos TO nColInit - 1
          nMin += aSizes[nFor]
      NEXT

      nMin += 5
   endif

   if nColPos == nil .and. nColInit == nil   // We have finish draging
      ::aColSizes[ nCol ] -= ( nWidth - nOldPos )
      ::Refresh()
   endif

   if nColPos != nil
     nColPos := Max(nColPos, nMin)
   endif

   oRect = ::GetRect()
   ::GetDC()
   if nOldPos != 0
      InvertRect( ::hDC, { 0, nOldPos - 2, oRect:nBottom, nOldPos + 2 } )
      nOldPos = 0
   endif
   if nColPos != nil .and. ( nColPos - 2 ) > 0
      InvertRect( ::hDC, { 0, nColPos - 2, oRect:nBottom, nColPos + 2 } )
      nOldPos = nColPos
   endif
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD nAtCol( nColPixel ) CLASS TGridExtended

   local nColumn := ::nColPos - 1
   local aSizes  := ::GetColSizes()
   local nPos    := 0

   DEFAULT nColPixel := 0

   while nPos < nColPixel .and. nColumn < Len( aSizes )
      nPos += aSizes[ nColumn + 1 ]
      nColumn++
   end

return nColumn

//----------------------------------------------------------------------------//

METHOD nAtIcon( nRow, nCol ) CLASS TGridExtended

   local nIconsByRow := Int( ::nWidth() / 50 )

   nRow -= 9
   nCol -= 1

   if ( nCol % 50 ) >= 9 .and. ( nCol % 50 ) <= 41
      return Int( ( nIconsByRow * Int( nRow / 50 ) ) + Int( nCol / 50 ) ) + 1
   else
      return 0
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Display() CLASS TGridExtended

   local nRecs

   ::BeginPaint()
   if ::oVScroll != nil   // They generate WM_PAINT msgs when range 0
      nRecs := Eval( ::bLogicLen, Self )
      if ::VGetMax() != nRecs .or. nRecs != ::nLen
         ::nLen := nRecs
         ::VSetRange()
         ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ), .t. )
      endif
   endif                  // so here we avoid 'flicking'
   if ::oHScroll != nil
      //::oHScroll:SetRange( 1, Len( ::GetColSizes() ) )
      ::oHScroll:SetRange( 0, 0 )
   endif
   ::Paint()
   ::EndPaint()

return 0

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TGridExtended

   // This method is very similar to TControl:GetDlgCode() but it is
   // necessary to have WHEN working

   if .not. ::oWnd:lValidating
      if nLastKey == VK_UP .or. nLastKey == VK_DOWN ;
         .or. nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      else
         ::oWnd:nLastKey = 0
      endif
   endif

return If( IsWindowEnabled( ::hWnd ), DLGC_WANTALLKEYS, 0 )

//----------------------------------------------------------------------------//

METHOD SetCols( aData, aHeaders, aColSizes ) CLASS TGridExtended

   local aFields
   local nElements, n

   nElements   := Len( aData )

   ::aHeaders  := If( aHeaders  != nil, aHeaders, ::aHeaders )
   ::aColSizes := If( aColSizes != nil, aColSizes, {} )
   ::bLine     := {|| _aData( aData ) }
   ::aJustify  := AFill( Array( nElements ), .F. )

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = AFill( Array( nElements ), 0 )
      aFields = Eval( ::bLine, Self )
      for n = 1 to nElements
          ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                   15,; // Bitmap handle
                                   GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ),;
                                   If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
      next
   endif

   if ::oHScroll != nil
      ::oHScroll:nMax := ::GetColSizes()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowSizes() CLASS TGridExtended

   local cText := ""

   AEval( ::aColSizes,;
          { | v,e | cText += ::aHeaders[ e ] + ": " + Str( v, 3 ) + CRLF } )

   MsgInfo( cText )

return nil

//----------------------------------------------------------------------------//

METHOD _DrawIcon( nIcon, lFocused ) CLASS TGridExtended

   local nIconsByRow := Int( ::nWidth() / 50 )
   local nRow := Int( --nIcon / nIconsByRow )
   local nCol := If( nRow > 0, nIcon % ( nRow * nIconsByRow ), nIcon )

   DEFAULT lFocused := .f.

   if lFocused
      DrawIconFocus( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                     ExtractIcon( "user.exe" ) )
   else
      DrawIcon( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                ExtractIcon( "user.exe" ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD IsColVisible( nCol ) CLASS TGridExtended

   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth

   nCols     := Len( ::GetColSizes() )
   nFirstCol := ::nColPos
   nLastCol  := nFirstCol
   nWidth    := 0
   nBrwWidth := ::nWidth - If( ::oVScroll != nil, 16, 0 )

   if nCol < nFirstCol
      return .f.
   endif

   while nWidth < nBrwWidth .and. nLastCol <= nCol
      nWidth += ::GetColSizes()[ nLastCol ]
      nLastCol++
   end

   if nCol <= --nLastCol

      // La columna es solo visible en parte por ser muy larga
      if nWidth > nBrwWidth
          return .f.
      endif

      return .t.

   endif

return .F.

//----------------------------------------------------------------------------//

static function _aData( aFields )

  local aFld
  local nFor, nLen

  nLen = Len( aFields )
  aFld = Array( nLen )

  for nFor = 1 to nLen
     aFld[ nFor ] = Eval( aFields[ nFor ] )
  next

return aFld

//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar ) CLASS TGridExtended
   local nTxtHeight, hOldFont
   local nColStart  := -1
   local nWidth     := WndWidth( hWnd ) - If( oVScroll != nil .and. ;
                       Eval( bLogicLen ) > 1,;
                       GetSysMetrics( SM_CYHSCROLL ) + 3, 0 )
   local nRow := nRowPos, nTop, nBottom, nLeft, nRight, n
   local lReleaseDC := .f.
   local nForeColor, nBackColor
   local  hPen, hOld, hBrush
   local hFontBold, nLenText
   local nItem

   DEFAULT lTree := .f., lBar := .f.

   if Empty( hDC )
      hDC = GetDC( hWnd )
      lReleaseDC = .t.
   endif

   if valtype( aValues[1]) == "N" .and. n == 2 .and. aValues[1] != 0
      hFontBold  := CreateBold( hFont )
      hOldFont   = SelectObject( hDC, hFontBold )
   else
      hOldFont   = SelectObject( hDC, hFont )
   endif

   nTxtHeight = ::nHLine //GetTextHeight( hWnd, hDC ) + 1

   nTop    = nTxtHeight * nRow
   nBottom = nTop + nTxtHeight - 1

   SetTextColor( hDC, If( ValType( nClrText ) == "B",;
                 nClrText := Eval( nClrText ), nClrText ) )
   SetBkColor( hDC, If( ValType( nClrPane ) == "B",;
               nClrPane := Eval( nClrPane ), nClrPane ) )

   for n := nColPos to Len( aValues )

      if valtype( aValues[1]) == "N" .and. n == 2 .and. aValues[1] != 0
         hFontBold  := CreateBold( hFont )
         hOldFont   = SelectObject( hDC, hFontBold )
      else
         hOldFont   = SelectObject( hDC, hFont )
      endif

      nLeft   = nColStart + 1
      nRight  = Min( nColStart := ( nLeft + aColSizes[ n ] - 1 ), nWidth )
      if nLeft > nWidth
         exit
      endif
      if n == Len( aValues )
         nRight = nWidth
      endif

      if ValType( aValues[ n ] ) == "N" .or. nRowPos == 0
         if n <= 1
            hBrush = CreateSolidBrush( rgb(173,197,229) ) // rgb(173,197,229) ) //rgb(212,208,200)
         else
            //if lBar .and. n == 3
            //   hBrush = CreateSolidBrush( ::nClrPane )
            //else
               hBrush = CreateSolidBrush( GetBkColor( hDC ) )
            //endif
         endif
         hOld   = SelectObject( hBrush )
         FillRect( hDC, { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                   LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. nLineStyle == ;
                   LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, hBrush )
         DrawMasked( hDC, aValues[ n ], nTop+3, nLeft + 0 )
         SelectObject( hOld )
         DeleteObject( hBrush )
      else
         if nColAct != nil .and. n == nColAct
            SetTextColor( hDC, nClrText )
            SetBkColor( hDC, nClrPane )
         else
            if nRowPos != 0
               if n == 3
                  SetTextColor( hDC, ::nClrText )
                  if aValues[1] != 0
                     SetBkColor( hDC, CLR_BACKGROUND ) // rgb(173,197,229) ) //rgb(212,208,200) )
                  else
                     SetBkColor( hDC, ::nClrPane )
                  endif
               else
                  SetTextColor( hDC, If( nColAct != nil, GetSysColor( COLOR_BTNTEXT ), if( aValues[1] != 0,::nClrText,nClrText) ) )
                  //SetBkColor( hDC, If( nRowPos == 0, rgb(212,208,200) , If( nColAct == nil, if( aValues[1] != 0,rgb(212,208,200),nClrPane), GetSysColor( COLOR_WINDOW ) ) ) )
                  SetBkColor( hDC, If( nRowPos == 0, CLR_BACKGROUND , If( nColAct == nil, if( aValues[1] != 0,CLR_BACKGROUND,nClrPane), GetSysColor( COLOR_WINDOW ) ) ) )
               endif
            endif
         endif

         nItem := ::nGetElement(::nAt) // CAF
*         if nRowPos != 0 .and. !::aItems[::nGetElement(::nAt),8] .and. n > 2
        * if nRowPos != 0 .and. ! Eval( ENABLE )  .and. n > 2  // CAF
        *    SetTextColor( hDC, CLR_GRAY )
        * endif

         if ! lTree
            //if nRowPos == 0 .and. IsAppThemed()
            //   DrawHeader( hWnd, hDC, nTop - 1, nLeft, nBottom, nRight, aValues[ n ] )
            //else
            //nLeft -= 1
            //nRight -= 1
            if aJustify != nil .and. aJustify[ n ]
               SetTextAlign( hDC, TA_RIGHT )
               ExtTextOut( hDC, nTop, nRight - 2,;
                           { nTop, nLeft, nBottom, nRight + If( (nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) },; //socs + If((nLineStyle == LINES_NONE .OR. nLineStyle == LINES_H_GRAY .OR. nLineStyle == LINES_H_BLACK) .AND. nRowPos#0 ,2,0),;
                           "" )
               DrawText( hDC, cValToChar( aValues[n] ), { nTop, nLeft+3, nBottom, nRight + If( (nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, nOr( DT_VCENTER, DT_RIGHT,DT_SINGLELINE ) )

            else
               //SetTextAlign( hDC, TA_LEFT )
               ExtTextOut( hDC, nTop, nLeft + 2,;
                           { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) },;
                           "" )
               DrawText( hDC, cValToChar( aValues[n] ), { nTop, nLeft+3, nBottom, nRight + If( (nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, nOr( DT_VCENTER, DT_END_ELLIPSIS,DT_SINGLELINE ) )


            endif
            if n == 3 .and. at( "color",lower(aValues[2])) != 0
               FillSolidRect( hDC, { nTop, nLeft, nBottom, nRight }, val( aValues[3] ) )
            endif
            if lBar
               if n == 2 .and. aValues[1] != 0
                  nLenText := GetTextWidth( hDC, aValues[n], hFontBold )
                  DrawFocusRect( hDC, nTop+3, nLeft, nTop+18, nLeft+nLenText + 8 )
               endif
            endif

            //endif
         else
            DrawText( hDC, cValToChar( aValues[ n ] ),;
                      { nTop, nLeft + 4, nBottom, nRight } )
         endif
      endif
      if ! lTree
         if nRowPos == 0
            //if ! IsAppThemed()
               //WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
               //WndBoxRaised( hDC, nTop, nLeft, nBottom - 1, nRight - 1 )
            //endif
         else
            nLeft += 1
            do case
               case nLineStyle == LINES_BLACK
                    WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )

               case nLineStyle == LINES_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_BACKGROUND )//rgb(212,208,200) )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nTop - 2 )
                    LineTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_3D
                    WndBoxRaised( hDC, nTop, nLeft, nBottom, nRight )

               case nLineStyle == LINES_DOTED
                    SetTextColor( hDC, CLR_BLACK )
                    FrameDot( hDC, nTop - 1, nLeft - 1, nBottom, nRight )

               case nLineStyle == LINES_V_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 1, nTop - 2 )
                    LineTo( hDC, nLeft - 1, nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_V_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 1, nTop - 2 )
                    LineTo( hDC, nLeft - 1, nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )
            endcase
         endif
      endif

      if nColPos > nWidth
         exit
      endif
      SelectObject( hDC, hOldFont )
      if hFontBold != nil
         DeleteObject( hFontBold )
      endif

   next



   if lReleaseDC
      ReleaseDC( hWnd, hDC )
   endif

return nil


#endif

//----------------------------------------------------------------------------//

CLASS TComboBox2 FROM TComboBox

      CLASSDATA lRegistered AS LOGICAL

      METHOD KeyDown( nKey, nFlags )

ENDCLASS


METHOD KeyDown( nKey, nFlags ) CLASS TComboBox2

if nKey == VK_RETURN .or. nKey == VK_ESCAPE
   ::Close()
   return ::oWnd:Teclas( nKey, nFlags )
endif

return ::Super:KeyDown( nKey, nFlags )


CLASS TGet2 FROM TGet

      CLASSDATA lRegistered AS LOGICAL

      METHOD KeyDown( nKey, nFlags )

ENDCLASS

METHOD KeyDown( nKey, nFlags ) CLASS TGet2

   if nKey == VK_UP .OR. nKey == VK_DOWN
      ::oWnd:KeyDown( nKey, nFlags )
      ::oWnd:SetFocus()
      ::oWnd:Refresh()
      return 0
   endif

   if nKey == VK_RETURN .or. nKey == VK_ESCAPE
      ::oWnd:Teclas( nKey )
      return 0
   endif

return ::Super:KeyDown( nKey, nFlags )


#pragma BEGINDUMP

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"


HB_FUNC( CREATEBOLD )
{
        LOGFONT lf;
      GetObject( ( HFONT ) hb_parnl( 1 ) , sizeof( LOGFONT ), &lf );
      lf.lfWeight = FW_BOLD;
                  hb_retnl( (LONG) CreateFontIndirect( &lf ));
}

HB_FUNC( WBRWSCROLL ) // ( hWnd, nRows, hFont ) --> nil
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int wRows  = hb_parni( 2 );
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   int nHLine = hb_parni( 4 );
   RECT rct;
   TEXTMETRIC tm;

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );
   GetTextMetrics( hDC, &tm );
   tm.tmHeight = nHLine;

   rct.top += tm.tmHeight;
   //rct.bottom -= ( ( rct.bottom - rct.top ) % tm.tmHeight );

   ScrollWindowEx( hWnd, 0, -( tm.tmHeight * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

HB_FUNC( DRAWFRAMECONTROL )
{
      RECT rc;
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);

       hb_retl( DrawFrameControl( (HDC) hb_parnl( 1 ), &rc, hb_parni( 3 ), hb_parni( 4 ) ) );
}
HB_FUNC( DRAWFOCUSRECT )  //RECT

{
   RECT rct ;
   HDC  hDC = ( HDC ) hb_parni( 1 );

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   DrawFocusRect( hDC, &rct );

}



HB_FUNC( HWNDCOMBO )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndCombo ) ;
}

HB_FUNC( HWNDCOMBOEDIT )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndItem ) ;
   //hb_retnl( (LONG)cbi.hwndList ) ;
}

HB_FUNC( HWNDCOMBOLIST )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndList ) ;
}

// Add Funtions...

HB_FUNC( PTINRECT )
{
   POINT pt;
   RECT  rct;

   pt.y = hb_parnl( 1 );
   pt.x = hb_parnl( 2 );

   rct.top    = hb_parvni( 3, 1 );
   rct.left   = hb_parvni( 3, 2 );
   rct.bottom = hb_parvni( 3, 3 );
   rct.right  = hb_parvni( 3, 4 );

   hb_retl( PtInRect( &rct, pt ) );
}

void FillSolidRect(HDC hDC, LPCRECT lpRect, COLORREF clr)
{
   SetBkColor(hDC, clr);
   ExtTextOut(hDC, 0, 0, ETO_OPAQUE, lpRect, NULL, 0, NULL);
}

HB_FUNC( FILLSOLIDRECT )
{
    RECT rct;
    COLORREF nColor;
    HPEN hPen, hOldPen;
    HDC hDC = ( HDC ) hb_parnl( 1 );
    rct.top    = hb_parvni( 2, 1 );
    rct.left   = hb_parvni( 2, 2 );
    rct.bottom = hb_parvni( 2, 3 );
    rct.right  = hb_parvni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right, rct.top );
       LineTo( hDC, rct.right, rct.bottom );
       LineTo( hDC, rct.left, rct.bottom );
       LineTo( hDC, rct.left, rct.top );
       SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }
}

HB_FUNC( SETMENUDEFAULTITEM )
{
    hb_retl( SetMenuDefaultItem( (HMENU) hb_parnl( 1 ), hb_parni( 2 ), 1));
}

#pragma ENDDUMP
