#define _FOLDER_CH
#define _ODBC_CH
#define _TREE_CH

#include "FiveWin.ch"
#include "InKey.ch"
#include "Set.ch"
#include "Constant.ch"
#include "Report.ch"
#include "c5report.ch"


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

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
   #xtranslate   _DbSkipper => DbSkipper
#endif

#ifdef __HARBOUR__
   #xtranslate   _DbSkipper => DbSkipper
#endif

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

extern DBSKIP

static aCLient



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



CLASS TListProp FROM TGridExtended

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
      DATA oCombo
      DATA oSpinner

      METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CONSTRUCTOR

      METHOD AddGroup( cGroup ) INLINE ::AddItem( "", cGroup,"",GRUPO,++::nGrupos), ::nGrupos
      METHOD AddItem( cVarName, cName, uVal, nTipo, nGroup, lAbierto, lEnable, bAction, bValid, nOption, xSETGET )
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

ENDCLASS

METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CLASS TListProp

local o := self
local oBar
lPixel := .t.


DEFAULT bValid := {||.t.}

       super:New( nRow, nCol, nWidth, nHeigth, bLine, {"","",""}, ;
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


       DEFINE BUTTONBAR oBar OF SELF SIZE 21,20
       oBar:bLClicked := {||.t.}
       oBar:SetColor( 0, GetSysColor(15) )

       DEFINE BUTTON OF oBar  NAME "btn1" NOBORDER TOOLTIP "Categorias" ACTION ( o:nTipoSort := 1,::Sort(), ::GoTop(),o:SetFocus(),o:Refresh())
       DEFINE BUTTON OF oBar  NAME "btn2" NOBORDER TOOLTIP "Alfabético" ACTION ( o:nTipoSort := 2,::Sort(), ::GoTop(),o:SetFocus(),o:Refresh())
       DEFINE BUTTON OF oBar  NAME "btn3" GROUP NOBORDER TOOLTIP "Propiedades"
       //DEFINE BUTTON OF oBar  NAME "btn4" GROUP NOBORDER TOOLTIP "Eventos"
       DEFINE BUTTON OF oBar  NAME "plus" NOBORDER TOOLTIP "Abrir todas"  ACTION ::OpenAll()
       DEFINE BUTTON OF oBar  NAME "minus"       NOBORDER TOOLTIP "Cerrar todas" ACTION ::CloseAll()

       ::oHScroll:SetRange(1,1)

       ::aRectBtn := {}
       ::bLostFocus := {|| ::PierdeFoco() }


return self


METHOD PierdeFoco() CLASS TListProp
local hFocus := GetFocus()

//if ::oCombo != nil
//
//   if IsWindowVisible(::oCombo:hWnd )
//      ::oCombo:Close()
//      ::oCombo:Hide()
//   endif
//   //if hFocus == ::oCombo:hWnd .or.;
//   //   hFocus == hWndComboEdit( ::oCombo:hWnd ) .or.;
//   //   hFocus == hWndComboList( ::oCombo:hWnd )
//   //endif
//endif
      //tone(1000,1)
      //tone(100,1)

return 0

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TListProp


return super:LButtonDown( nRow, nCol, nKeyFlags )

METHOD KeyDown( nKey, nFlags ) CLASS TListProp


//       do case
         if ( nKey == VK_UP .or. nKey == VK_DOWN ) //.and. (::oCombo   != nil .and. IsWindowVisible( ::oCombo:hWnd ))

                return 1
         endif

         if nKey == VK_ESCAPE
               if ::oCombo != nil
                  ::oCombo:Close()
                  ::oCombo:Hide()
               endif
               return 0
         endif

   if ((::oCombo   != nil .and. IsWindowVisible( ::oCombo:hWnd ))   .or.;
       (::oGet     != nil .and. IsWindowVisible( ::oGet:hWnd   ))   .or.;
       (::oSpinner != nil .and. IsWindowVisible( ::oSpinner:hWnd )) )

   endif

return super:KeyDown( nKey, nFlags )



//METHOD GetDlgCode( nLastKey ) CLASS TListProp
//
//   // This method is very similar to TControl:GetDlgCode() but it is
//   // necessary to have WHEN working
//
//   if .not. ::oWnd:lValidating
//      if nLastKey == VK_UP .or. nLastKey == VK_DOWN
//         ::oWnd:nLastKey = 0
//      endif
//   endif
//
//return If( IsWindowEnabled( ::hWnd ), DLGC_WANTALLKEYS, 0 )


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
   METHOD AddItem( cVarName, cName, uVal, nTipo, nGroup, lAbierto, lEnable, bAction, bValid, nOption, xSETGET ) CLASS TListProp
****************************************************************************************************************
DEFAULT lAbierto := .t.
DEFAULT nTipo := CARACTER, nGroup := 1
DEFAULT lEnable := .t.
DEFAULT bAction := .f.

if valtype(uVal) == "L"
   nTipo := LOGICO
endif

::nItem += 5

aadd( ::aItems, { cVarName, nTipo, cName, uVal, nGroup, lAbierto, ::nItem, lEnable, bAction, bValid, nOption, xSETGET } )

return nil



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
   uVal  := cValToChar(VALOR)
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
   METHOD Click( nRow, nCol, lEditCol ) CLASS TListProp
************************************************************************************
local nItem := ::nGetElement( ::nAt )
local aRect, oLbx, cVar, aItems
local oDlg, aPos,n
local o := self
local oFont
local cType := "A"
local uVar
local hDC
local lGrupo := TIPO == GRUPO
local bValid := {||.t.}           //? !empty( ::aRectBtn ) , PtInRect( nRow, nCol, ::aRectBtn ) ,	 nRow < 0
local nMax := 0

DEFAULT lEditCol := .f.

SetFocus(::hWnd)

   if ((::oCombo   != nil .and. IsWindowVisible( ::oCombo:hWnd ))   .or.;
       (::oGet     != nil .and. IsWindowVisible( ::oGet:hWnd   ))   .or.;
       (::oSpinner != nil .and. IsWindowVisible( ::oSpinner:hWnd )) )

       //if(::oCombo   != nil, ::oCombo  :Hide(),)
       //if(::oGet     != nil, ::oGet    :Hide(),)
       //if(::oSpinner != nil, ::oSpinner:Hide(),)

   endif



if ENABLE

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

                 VALOR := !VALOR
                 ::DrawSelect()
                 if !empty( ::oObject )
                    if !empty( CVARNAME )
                       OSend( ::oObject, "_" + alltrim( CVARNAME ), VALOR )
                       oSend( ::oObject, "Refresh")
                    endif
                 endif

            case TIPO == LISTA

                 aRect := ::aGetRectSel()

                 if BACTION != NIL
                    aItems := eval( BACTION )
                    if OPTION != nil
                       cVar := aItems[ OPTION ]
                    else
                       cVar   := VALOR
                    endif
                 endif

                 if ::oGet     != nil; ::oGet:Hide();     endif
                 if ::oSpinner != nil; ::oSpinner:Hide(); endif

                 if ::oCombo == nil

                    DEFINE FONT oFont NAME "Ms OutLook" SIZE 10, aRect[3]-aRect[1]-8

                    ::oCombo := TComboBox2():New( aRect[1], aRect[2], { | u | If( PCount()==0, cVar, cVar:= u ) }, aItems, aRect[4]-aRect[2], 510, o,,,,,, .T., oFont,, .F.,, .F.,,, 2,, )
                    ::oCombo:bLostFocus := {|| if( GetFocus() != hWndComboList(::oCombo:hWnd),(::oCombo:Close(),::oCombo:Hide()),) }
                    //::oCombo:bCloseUp   := {|| if( GetFocus() != ::oCombo:hWnd,( tone(1999,1),::oCombo:Close(),::oCombo:Hide()),) }

                    uVar := cVar

                    SendMessage( HWNDCOMBOEDIT( ::oCombo:hWnd ), 48, ::oFont:hFont, 0 )
                    SendMessage( HWNDCOMBOLIST( ::oCombo:hWnd ), 48, ::oFont:hFont, 0 )
                    //SendMessage( ::oCombo:hWnd , CB_SHOWDROPDOWN, 1, 0 )

                    ::oCombo:Show()
                    //SendMessage El_Combo.hwnd, CB_SETDROPPEDWIDTH, Maximo + 12, 0

                 else

                    ::oCombo:Move( aRect[1], aRect[2], aRect[4]-aRect[2], 510,.f.)
                    ::oCombo:SetItems( aItems )
                    ::oCombo:Set( cVar )
                    ::oCombo:Show()


                 endif
                 for n := 1 to len(aItems)
                     nMax := max( nMax, GetTextWidth( 0, aItems[n], ::oFont:hFont ) )
                 next
                 SendMessage( ::oCombo:hwnd, 0x0160, nMax + 12, 0 )
                 //::oCombo:Open()

            case TIPO == ACCION

                  VALOR := eval( BACTION )
                  ::Refresh()

                 return VALOR

         endcase
      endif
   else

      if (nCol > ::aColSizes[1]+::aColSizes[2] .OR. lEditCol ) .and. !lGrupo

         ::EditCol( VALOR, nItem )

      else




      endif

   endif

endif

return .t.

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

   if ::oCombo   != nil; ::oCombo:Hide();   endif
   if ::oGet     != nil; ::oGet:Hide();     endif
   if ::oSpinner != nil; ::oSpinner:Hide(); endif

   if TIPO == SPINNER

      if ::oSpinner == nil                                                                                      //
         ::oSpinner := TGet2():New(nTop + 1,nLeft + 1,{ | u | If(PCount()==0,uVar,uVar:= u ) },Self,nRight-nLeft-20,nBottom-nTop,    ,       ,::nClrText,::nClrPane,oFont,     .F.,        ,    .T.,    ,     .F.,      ,     .F.,    .F.,         ,       .F.,       .F.,       .T.,,      .t.,{||::oSpinner++, ::Refresh()}, {||::oSpinner--, ::Refresh()}, {||0}, {||3600} )
         ::oSpinner:bLostFocus := {|| ::oSpinner:Hide() }
      else
         ::oSpinner:cText( uVar )
         ::oSpinner:Move(nTop + 1,nLeft + 1,nRight-nLeft,nBottom-nTop,.f.)
         ::oSpinner:Show()
      endif
      ::oSpinner:SetFocus()

   else
       if ::oGet == nil
          ::oGet := TGet2():New( nTop + 1, nLeft + 1, { | u | If( PCount()==0, uVar, uVar:= u ) }, Self, nRight-nLeft, nBottom-nTop,,, ::nClrText, ::nClrPane, oFont, .F.,, .T.,, .F.,, .F., .F.,, .F., .F., .T., )
          ::oGet:bLostFocus := {|| ::oGet:Hide() }
       else
          ::oGet:cText( uVar )
          ::oGet:Move(nTop + 1,nLeft + 1,nRight-nLeft,nBottom-nTop,.t.)
          ::oGet:Show()
          SysRefresh()
       endif
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
          if ::oCombo != nil
             if IsWindowVisible( ::oCombo:hWnd )
                if XSETGET != nil
                   uVal := ::oCombo:VarGet()
                   oSend( ::oObject,"_" + XSETGET, uVal )
                else
                   uVal := ::oCombo:VarGet()
                   oSend( ::oObject,"_" + CVARNAME, uVal )
                endif
                VALOR := uVal
                ::oObject:Refresh()
                ::oCombo:Close()
                ::oCombo:Hide()
                SetFocus(::hWnd)
             else
                ::Click(-1)
                ::oCombo:Open()
             endif
          else
             ::Click(-1)
             ::oCombo:Open()
          endif
       else

          if TIPO == SPINNER
             oGet := ::oSpinner
          else
             oGet := ::oGet
          endif

          if oGet != nil

             if IsWindowVisible( oGet:hWnd )
                oGet:Assign()
                oGet:VarPut( oGet:oGet:VarGet())
                uVal := oGet:VarGet()
                if valtype( uVal ) == "C"
                   if !empty( trim( uVal ) )
                      uVal := trim( uVal )
                   endif
                endif
                oSend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
                VALOR := uVal
                if ::oGet != nil;     ::oGet:Refresh();     endif
                if ::oSpinner != nil; ::oSpinner:Refresh(); endif
                oGet:Hide()
                SetFocus(::hWnd)
                oReport():Refresh()
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

        if ::oCombo   != nil; ::oCombo:Hide();   endif
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

super:wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, lBar )


if lBar

   nItem := ::nGetElement( ::nAt )

   if !ENABLE
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
      oSend( ::oObject,"_" + CVARNAME, uVal ) //valorize( ::oGet:VarGet, CVARNAME ))
      VALOR := uVal

   endif

   if BVALIDAR != nil
      eval( BVALIDAR, VALOR )
   endif
   oReport():Refresh()

endif

return .t.

****************************************************************************************
  METHOD Reset( ) CLASS TListProp
****************************************************************************************
local n, nItem, nLen

asize(::aItems, 0 )
asize(::aGroups, 0 )
::aItems := {}
::aGroups := {}
::nItem := 0
::nGrupos := 0

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
ENABLE   := .T.
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
    ENABLE   := .T.
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

return Super:ReSize( nSizeType, nWidth, nHeight )




CLASS TGridExtended FROM TControl

   DATA   cAlias, cField, uValue1, uValue2
   DATA   bLine, bSkip, bGoTop, bGoBottom, bLogicLen, bChange, bAdd
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

   METHOD lCloseArea() INLINE ;
             If( ! Empty( ::cAlias ), ( ::cAlias )->( DbCloseArea() ),),;
             If( ! Empty( ::cAlias ), ::cAlias := "",), .t.

   METHOD LDblClick( nRow, nCol, nKeyFlags )
   METHOD Default()

   METHOD BugUp() INLINE ::UpStable()

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

   METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                    aItems, bAction )

   METHOD Edit( nCol, lModal )

   METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                   aItems, bAction )

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

   METHOD GotFocus() INLINE Super:GotFocus(),;
                  If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                      ! ::lIconView, ::DrawSelect(),)

   METHOD HScroll( nWParam, nLParam )

   MESSAGE DrawIcon METHOD _DrawIcon( nIcon, lFocused )

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()
   METHOD IsColVisible( nCol )
   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )
   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )


   METHOD LostFocus( hCtlFocus ) INLINE Super:LostFocus( hCtlFocus ),;
                   If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                   ! ::lIconView, ::DrawSelect(),)

   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD Paint()

   METHOD RecAdd() INLINE If( ::bAdd != nil, Eval( ::bAdd, Self ),)

   MESSAGE RecCount METHOD _RecCount( uSeekValue )

   METHOD Report( cTitle, lPreview )

   METHOD ReSize( nSizeType, nWidth, nHeight )

   //METHOD nRowCount() INLINE nWRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ) ) - 1
   METHOD nRowCount() INLINE aClient := GetClientRect(::hWnd), int( ( aClient[3]-aClient[1]) / ::nHLine )-1

   METHOD SetArray( aArray )
   METHOD SetCols( aData, aHeaders, aColSizes )
   METHOD SetFilter( cField, uVal1, uVal2 )
   METHOD SetTree( oTree )
   METHOD ShowSizes()
   METHOD Skip( n )
   METHOD UpStable()
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
   ::nStyle     = nOr( WS_CHILD, WS_VSCROLL, WS_HSCROLL,;
                       WS_BORDER, WS_VISIBLE, WS_TABSTOP,;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        = ::GetNewId()
   ::cAlias     = cAlias
   ::bLine      = bLine
   ::lAutoEdit  = .f.
   ::lAutoSkip  = .f.
   ::lIconView  = .f.
   ::lCellStyle = .f.
   ::nIconPos   = 0
   ::nHLine     := 23
   ::SetFilter( cField, uVal1, uVal2 )

   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

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

   ::SetColor( nClrFore, nClrBack )

   ::SetFilter( cField, uVal1, uVal2 )
   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

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

METHOD Edit( nCol, lModal ) CLASS TGridExtended

   local uTemp, cType, lAutoSave, lContinue

   DEFAULT nCol := 1, lModal := .t.

   DO
      uTemp = Eval( ::bLine, Self )[ nCol ]
      if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
         lAutoSave = ( cValToChar( ( ::cAlias )->( FieldGet( nCol ) ) ) == uTemp )
         if ( ::cAlias )->( RLock() )
            if lContinue := ::lEditCol( nCol, @uTemp )
               if lAutoSave
                  cType = ValType( ( ::cAlias )->( FieldGet( nCol ) ) )
                  do case
                     case cType == "D"
                        ( ::cAlias )->( FieldPut( nCol, CToD( uTemp ) ) )

                     case cType == "L"
                        ( ::cAlias )->( FieldPut( nCol, Upper( uTemp ) == ".T." ) )

                     case cType == "N"
                        ( ::cAlias )->( FieldPut( nCol, Val( uTemp ) ) )

                     otherwise
                        ( ::cAlias )->( FieldPut( nCol, uTemp ) )
                  endcase
               endif
               ::DrawSelect()
            endif
            ( ::cAlias )->( DbUnLock() )
         else
            MsgStop( "Record locked!", "Please, try again" )
         endif
      else
         ::lEditCol( nCol, @uTemp )
      endif
      if lContinue .and. ::lAutoSkip
         if nCol < Len( Eval( ::bLine, Self ) )
            ::GoRight()
            nCol++
         else
            ::nColPos = 1
            nCol = 1
            ::GoDown()
         endif
      endif
   UNTIL ! ( ::lAutoSkip .and. lContinue )

return nil

//----------------------------------------------------------------------------//

METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems,;
                bAction ) CLASS TGridExtended

   local oFont
   local uTemp
   local aDim, aPos
   local cType
   local nWidth, nHeight

   DEFAULT nCol := ::nColAct

   uTemp   := uVar
   aDim    := aBrwPosRect( ::hWnd, ::nRowPos, ::aColSizes, ::nColPos, nCol,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ) )
   aPos    := { aDim[ 1 ], aDim[ 2 ] }
   cType   := ValType( uVar )

   nWidth  := aDim[ 4 ] - aDim[ 2 ]
   nWidth  := ::aColSizes[nCol]
   nHeight := aDim[ 3 ] - aDim[ 1 ]

   ScreenToClient( Self:hWnd, aPos )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFAULT nClrFore := ::nClrText ,;
           nClrBack := ::nClrPane ,;
           bValid   := {|| .t. }

   if ::oGet != nil .AND. ! Empty( ::oGet:hWnd )
      ::oGet:Hide()
   endif

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nInpWidth,;
                           ::oFont:nInpHeight, .f., ::oFont:lBold )
   endif

   do case
      case cType == "L"
           DEFAULT aItems := { ".T.", ".F." }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE  Min(100,Max(nWidth,50)), 100 OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      case aItems != nil

           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE nWidth, Max( 200, Len( aItems ) * 25 ) OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      otherwise
          @ aPos[ 1 ] + 1, aPos[ 2 ] + 1 GET ::oGet VAR uVar ;
               SIZE nWidth, nHeight ;
               OF Self ;
               FONT oFont COLOR nClrFore, nClrBack ;
               PIXEL

          ::oGet:oGet:Picture = cPicture
   endcase

   ::nLastKey := 0
   #ifndef __XPP__
      ::oGet:Set3dLook()
   #endif
   ::oGet:SetFocus()

   if Upper( ::oGet:ClassName() ) != "TGET"
      ::oGet:Refresh()
   endif

   ::oGet:bLostFocus := {|| If( Upper( ::oGet:ClassName() ) == "TGET",;
      ( ::oGet:Assign(), ::oGet:VarPut( ::oGet:oGet:VarGet())),;
      ::oGet:VarPut( If( cType == "L", ( uVar == aItems[ 1 ] ), ::oGet:VarGet() ) ) ),;
      If( Self:nLastKey != VK_ESCAPE,;
      Eval( bValid, uVar, Self:nLastKey, Self ),;
      Eval( bValid, nil, Self:nLastKey, Self ) ),;
      ::oGet:End() }

   ::oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. ;
                                     nKey == VK_ESCAPE,;
                        ( Self:nLastKey := nKey, ::oGet:End()), ) }
return .f.

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TGridExtended
local aC := GetClientRect( ::hWnd )
local nWC := aC[4]-aC[2]
local nW := ::aColSizes[1]+::aColSizes[2]

   ::nRowPos = Min( ::nRowPos, Max( ::nRowCount(), 1 ) )
   ::aColSizes[3] := nWC - nW

return Super:ReSize( nSizeType, nWidth, nHeight )

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

METHOD SetTree( oTree ) CLASS TGridExtended

   local oItem := oTree:oFirst

   ::lMChange   = .f.
   ::bLine      = { || oItem:GetLabel() }
   ::aColSizes  = { || oItem:ColSizes() }
   ::bGoTop     = { || oItem := oTree:oFirst }
   ::bGoBottom  = { || oItem := oTree:GetLast() }
   ::bSkip      = { | n | oItem := oItem:Skip( @n ), ::Cargo := oItem, n }
   ::bLogicLen  = { || ::nLen := oTree:nCount() }
   ::bLDblClick = { || If( oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }
   ::Cargo      = oItem
   ::bKeyChar   = { | nKey | If( nKey == 13 .and. oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }

   if ::oHScroll != nil
      ::oHScroll:SetRange( 0, 0 )
      ::oHScroll = nil
   endif

   oTree:Draw()

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
          // WBrwPane() returns the nº of visible rows
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

METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                 aItems, bAction ) CLASS TGridExtended

   local oDlg, oGet, oFont, oBtn, oBtnAction
   local nWidth := ::aColSizes[ nCol ]
   local uTemp
   local aDim
   local lOk
   local cType

   DEFAULT nClrFore := ::nClrText ,;
           nClrBack := ::nClrPane ,;
           nCol := ::nColAct

   uTemp  := uVar
   aDim   := aBrwPosRect( ::hWnd, ::nRowPos, ::aColSizes, ::nColPos, nCol,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ) )
   aDim[ 1 ] = aDim[ 1 ] + 1
   lOk    := .f.
   cType  := ValType( uVar )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFINE DIALOG oDlg FROM aDim[ 1 ], aDim[ 2 ] TO aDim[ 3 ], aDim[ 4 ] ;
      STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nInpWidth,;
                           ::oFont:nInpHeight, .f., ::oFont:lBold )
   endif

   // if we use uTemp instead of uVar, then VALID does not work!
   // because VALID is issued on uVar. !!!

   do case
      case cType == "L"
           DEFAULT aItems := { "Si", "No" }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      case aItems != nil
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      otherwise
         @  0, 0 GET oGet VAR uVar ; // we have to use here uVar to use VALID !!!
         SIZE aDim[ 4 ] - aDim[ 2 ] - If( bAction != nil, 12, 0 ),;
         aDim[ 3 ] - aDim[ 1 ]  OF oDlg ;
         FONT oFont COLOR nClrFore, nClrBack

         oGet:oGet:Picture = cPicture

         if bAction != nil
            @ 0, 0 BUTTON oBtnAction PROMPT "" OF oDlg SIZE 12, 12
            oBtnAction:bAction = { || oGet:VarPut( Eval( bAction, uVar, Self ) ),;
                                      oDlg:End(), lOk := .t.  }
         endif
   endcase

   oGet:bValid = bValid

   @ 10, 0 BUTTON oBtn PROMPT "" ACTION ( oDlg:End(), lOk := .t. ) OF oDlg DEFAULT

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   if ! lOk
      uVar = uTemp
   else
      if cType == "L"
         uVar = ( uVar == aItems[ 1 ] )
      endif
   endif

return lOk

//----------------------------------------------------------------------------//

static function DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   oDlg:Move( aDim[ 1 ] + 1, aDim[ 2 ] + 1,;
              aDim[ 4 ] - aDim[ 2 ], aDim[ 3 ] - aDim[ 1 ] )

   do case
      case cType == "L"
           oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] + 3, 50 )

      case oBtnAction != nil
           oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] - 14,;
                      aDim[ 3 ] - aDim[ 1 ] + 6 )
           oBtnAction:Move( 0, aDim[ 4 ] - aDim[ 2 ] - 15, 15,;
           aDim[ 3 ] - aDim[ 1 ] )

    otherwise
           oGet:Move( -2, 0 )
   endcase

return nil

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
         return Super:LDblClick( nRow, nCol, nKeyFlags )
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
      return Super:LButtonDown( nRow, nCol, nKeyFlags )
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

   Super:LButtonDown( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TGridExtended
local aC := GetClientRect( ::hWnd )
local nWC := aC[4]-aC[2]
local nW := ::aColSizes[1]+::aColSizes[2]

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()
      ::aColSizes[3] := nWC - nW
      ::VertLine()
      ::Refresh()
   endif

   Super:LButtonUp( nRow, nCol, nFlags )

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
      ::bLine  = { || _aFields( Self ) }
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
           return Super:KeyDown( nKey, nFlags )
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
           return Super:KeyChar( nKey, nFlags )
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

   if ::bSkip != nil
      return Eval( ::bSkip, n, Self )
   endif

return ( ::cAlias )->( _DBSkipper( n ) )

//----------------------------------------------------------------------------//

static function BrwGoBottom( uExpr )

   local lSoftSeek := Set( _SET_SOFTSEEK, .t. )

   if ValType( uExpr ) == "C"
      DbSeek( SubStr( uExpr, 1, Len( uExpr ) - 1 ) + ;
              Chr( Asc( SubStr( uExpr, Len( uExpr ) ) ) + 1 ) )
   else
      DbSeek( uExpr + 1 )
   endif
   DbSkip( -1 )

   Set( _SET_SOFTSEEK, lSoftSeek )

return nil

//----------------------------------------------------------------------------//

// To simulate Filters using INDEXES         -they go extremely fast!-

static function BuildSkip( cAlias, cField, uValue1, uValue2 )

   local bSkipBlock
   local cType := ValType( uValue1 )

   do case
      case cType == "C"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= '" + uValue1 + "' .and." + ;
           cField + "<= '" + uValue2 + "' }" ) ) ) }

      case cType == "D"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= CToD( '" + DToC( uValue1 ) + "') .and." + ;
            cField + "<= CToD( '" + DToC( uValue2 ) + "') }" ) ) ) }

      case cType == "N"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }

      case cType == "L"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }
   endcase

return bSkipBlock

//----------------------------------------------------------------------------//

static function BrwGoTo( n, bWhile )

   local nSkipped := 0, nDirection := If( n > 0, 1, -1 )

   while nSkipped != n .and. Eval( bWhile ) .and. ! EoF() .and. ! BoF()
      DbSkip( nDirection )
      nSkipped += nDirection
   enddo

   do case
      case EoF()
         DbSkip( -1 )
         nSkipped += -nDirection

      case BoF()
         DbGoTo( RecNo() )
         nSkipped++

      case ! Eval( bWhile )
         DbSkip( -nDirection )
         nSkipped += -nDirection
   endcase

return nSkipped

//----------------------------------------------------------------------------//
// Many thanks to Kathy Hayes

METHOD _RecCount( uSeekValue ) CLASS TGridExtended

   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRecs  := 1
   local bField := &( "{ || " + ::cField + "}" )

   if .not. ( ::cAlias )->( DbSeek( uSeekValue, .t. ) )
      if ( ::cAlias )->( Eval( bField, Self ) ) > ::uValue2 ;
         .or. ( ::cAlias )->( EoF() )
         nRecs := 0
      endif
   endif

   // When Filters show a lot of records, the application
   // may loose a lot of time counting. nMaxFilter controls this
   if ::nMaxFilter == nil
      while ::Skip( 1 ) == 1
         nRecs++
      end
   else
      while ::Skip( 1 ) == 1 .and. nRecs < ::nMaxFilter
         nRecs++
      end
   endif

   ( ::cAlias )->( DbGoTo( nRecNo ) )

return nRecs

//----------------------------------------------------------------------------//

static function GenLocal( aArray, nPos )

return { || If( nPos <= Len( aArray ), aArray[ nPos ], "  " ) }

static function GenBlock( bLine, nPos ) ;  return { || Eval( bLine )[ nPos ] }

//----------------------------------------------------------------------------//

METHOD Report( cTitle, lPreview ) CLASS TGridExtended

   local oRpt
   local nRecNo := If( Upper( ::cAlias ) != "ARRAY", ( ::cAlias )->( RecNo() ), 0 )
   local aData  := Eval( ::bLine, Self )
   local n
   local nCharWidth

   nCharWidth := GetTextWidth( 0, "B", If( ::oFont != nil, ::oFont:hFont, 0 ))

   DEFAULT cTitle := ::oWnd:cTitle, lPreview := .t.

   if lPreview
      REPORT oRpt TITLE cTitle PREVIEW ;
         HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
         FOOTER "Page: " + Str( oRpt:nPage, 3 )
   else
      REPORT oRpt TITLE cTitle ;
         HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
         FOOTER "Page: " + Str( oRpt:nPage, 3 )
   endif

   if Empty( oRpt ) .or. oRpt:oDevice:hDC == 0
      return nil
   else
      Eval( ::bGoTop, Self )
   endif

   if ::aColSizes == nil
      ::aColSizes = Array( Len( aData ) )
      for n = 1 to Len( aData )
         ::aColSizes[ n ] = 80
      next
   else
      if Len( ::aColSizes ) < Len( aData )
         n = Len( ::aColSizes )
         while n++ < Len( aData )
            AAdd( ::aColSizes, 80 )
         end
      endif
   endif

   for n = 1 to Len( aData )
      if ValType( aData[ n ] ) != "N"
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { GenBlock( ::bLine, n ) },;
                         Int( ::aColSizes[ n ]/ nCharWidth ),,,,,,,,, oRpt ) )
      else
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { { || "   " } },;
                         Int( ::aColSizes[ n ] / nCharWidth ),,,,,,,,, oRpt ) )
      endif
   next
   ENDREPORT

   oRpt:bSkip = { || oRpt:Cargo := ::Skip( 1 ) }
   oRpt:Cargo = 1

   ACTIVATE REPORT oRpt ;
      WHILE If( Upper( ::cAlias ) == "ARRAY",;
                oRpt:nCounter < Eval( ::bLogicLen, Self ),;
                oRpt:Cargo == 1 )

   if Upper( ::cAlias ) != "ARRAY"
      ( ::cAlias )->( DbGoTo( nRecNo ) )
   endif
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD UpStable() CLASS TGridExtended

   local nRow   := ::nRowPos
   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRows  := ::nRowCount()
   local n      := 1
   local lSkip  := .t.

   ::nRowPos    = 1
   ::GoTop()
   ::lHitTop    = .f.
   ::lHitBottom = .f.

   while ! ( ::cAlias )->( EoF() )
      if n > nRows
         ( ::cAlias )->( DbGoTo( nRecNo ) )
         ::nRowPos = nRow
         lSkip     = .f.
         exit
      endif
      if nRecNo == ( ::cAlias )->( RecNo() )
         ::nRowPos = n
         exit
      else
         ( ::cAlias )->( DbSkip() )
      endif
      n++
   end

   if lSkip
      ( ::cAlias )->( DbSkip( -::nRowPos ) )
   endif

   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFilter( cField, uVal1, uVal2 ) CLASS TGridExtended

   local cIndexType

   DEFAULT uVal2 := uVal1

   ::cField     = cField
   ::uValue1    = uVal1
   ::uValue2    = uVal2

   if uVal1 != nil
      cIndexType := ( ::cAlias )->( ValType( &( IndexKey() ) ) )
      if ( ::cAlias )->( ValType( &cField ) ) != cIndexType .or. ;
         ValType( uVal1 ) != cIndexType .or. ;
         ValType( uVal2 ) != cIndexType
         MsgAlert( "TGridExtended SetFilter() types don't match with current Index Key type!" )
      endif
   endif

   // Posibility of using FILTERs based on INDEXES!!!

   if ! Empty( ::cAlias )

      ::bGoTop     = If( uVal1 != nil, { || ( ::cAlias )->( DbSeek( uVal1, .t. ) ) },;
                                    { || ( ::cAlias )->( DbGoTop() ) } )

      ::bGoBottom  = If( uVal2 != nil, { || ( ::cAlias )->( BrwGoBottom( uVal2 ) ) },;
                                    { || ( ::cAlias )->( DbGoBottom() ) } )

      ::bSkip      = If( uVal1 != nil, BuildSkip( ::cAlias, cField, uVal1, uVal2 ),;
                      { | n | ( ::cAlias )->( _DbSkipper( n ) ) } )

      ::bLogicLen  = If( uVal1 != nil,;
                      { || ( ::cAlias )->( Self:RecCount( uVal1 ) ) },;
                      { || ( ::cAlias )->( RecCount() ) } )

      ::nLen       = Eval( ::bLogicLen, Self )

      ::lHitTop    = .f.
      ::lHitBottom = .f.

      if uVal1 != nil
         Eval( ::bGoTop, Self )
      endif
   else
      ::bLogiclen = { || 0 }
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TGridExtended

   local nColPos := 0
   local aColSizes

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
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
         Super:MouseMove( nRow, nCol, nKeyFlags )
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

function _aFields( Self )

   local aFld, aSizes, cAlias := ::cAlias
   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth
   local uVal

   if Empty( cAlias )
      return {}
   endif

   if Len( ::aColSizes ) == 0
      return Array( ( cAlias )->( Fcount() ) )
   endif

  aSizes    = ::aColSizes
  nCols     = Len( aSizes )
  nFirstCol = ::nColPos
  nLastCol  = nFirstCol
  nWidth    = 0
  nBrwWidth = ::nWidth()
  aFld      = Array( nCols )

  AFill( aFld, "" ) // , 1, nFirstCol - 1 )

  while nWidth < nBrwWidth .and. nLastCol <= nCols
     nWidth += aSizes[ nLastCol ]
     if ValType( ( cAlias )->( FieldGet( nLastCol ) ) ) == "M"
        aFld[ nLastCol ] = If( ! Empty( ( cAlias )->( ;
              FieldGet( nLastCol ) ) ), "<Memo>", "<memo>" )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     else
        aFld[ nLastCol ] = cValToChar( ( cAlias )->( FieldGet( nLastCol ) ) )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     endif
  end

return aFld

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
            hBrush = CreateSolidBrush( rgb(212,208,200) )
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
                     SetBkColor( hDC, rgb(212,208,200) )
                  else
                     SetBkColor( hDC, ::nClrPane )
                  endif
               else
                  SetTextColor( hDC, If( nColAct != nil, GetSysColor( COLOR_BTNTEXT ), if( aValues[1] != 0,::nClrText,nClrText) ) )
                  SetBkColor( hDC, If( nRowPos == 0, rgb(212,208,200) , If( nColAct == nil, if( aValues[1] != 0,rgb(212,208,200),nClrPane), GetSysColor( COLOR_WINDOW ) ) ) )
               endif
            endif
         endif

         if nRowPos != 0 .and. !::aItems[::nGetElement(::nAt),8] .and. n > 2
            SetTextColor( hDC, CLR_GRAY )
         endif

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
                    hPen = CreatePen( PS_SOLID, 1, rgb(212,208,200) )
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



/*

static function aBrwPosRect( hWnd, nRow, aColSizes, nColPos, nCol, hFont )

   local hDC        := GetDC( hWnd )
   local hOldFont   := SelectObject( hDC, hFont )
   local nTxtHeight := GetTextHeight( hWnd, hDC ) + 1
   local nTop       := nTxtHeight * nRow
   local nLeft      := 0
   local n

   for n := nColPos TO nCol - 1
      nLeft += aColSizes[ n ]
   next

   SelectObject( hDC, hOldFont )
   ReleaseDC( hWnd, hDC )

return { nTop-1, nLeft-1, nTop + nTxtHeight - 1, nLeft + aColSizes[ nCol ] - 2 }

*/

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

return super:KeyDown( nKey, nFlags )


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

return Super:KeyDown( nKey, nFlags )


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
      rc.top    = hb_parni( 2, 1);
      rc.left   = hb_parni( 2, 2);
      rc.bottom = hb_parni( 2, 3);
      rc.right  = hb_parni( 2, 4);

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




#pragma ENDDUMP

function valorize( cVal, cVarname )
local cType := upper(left(cVarName,1))


do case
   case cType == "C"
        return cVal

   case cType == "L"
        return cVal

   case cType == "N"
        if valtype( cVal ) == "N"
           return cVal
        else
           return val( cVal )
        endif
endcase

return ""





