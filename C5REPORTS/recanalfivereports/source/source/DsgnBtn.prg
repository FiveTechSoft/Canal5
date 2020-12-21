#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnBtn FROM TShape

      DATA lFlat
      DATA lDefault
      DATA cAlign
      DATA nTipo
      DATA lChecked
      DATA lActive
      DATA lPressed
      DATA lHotTrack
      DATA cAction
      DATA nRadMenu


      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nTipo ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD PaintBtn( hDC )
      METHOD PaintCheck( hDC )
      METHOD PaintRadio( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD Inspect( cDataName )
      METHOD GenPrg( lDialog, cfrom, cHeader, cFunciones )
      METHOD SetProps( oList )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nTipo ) CLASS TDsgnBtn
************************************************************************************************

DEFAULT nTipo := BOTON

::lGroup   := .f.

if nTop != nil
   if nBottom-nTop < 10 .or. nRight-nLeft < 10
      do case
         case nTipo == BOTON
              nBottom    := nTop + 23
              nRight     := nLeft + 75

         case nTipo == CHECK
              nBottom    := nTop + 16
              nRight     := nLeft + 62

         case nTipo == RADIODSGN
              nBottom    := nTop + 16
              nRight     := nLeft + 62
              ::nRadMenu := 1


      endcase
   endif
endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat        := .f.
   ::lDefault     := .f.
   ::nClrBorder   := 0

   ::nTipo        := nTipo
   ::lChecked     := .f.
   ::lActive      := .t.
   ::lPressed     := .f.
   ::lHotTrack    := .f.
   ::cAction      := space(100)

   do case
      case ::nTipo == BOTON

           ::nClrPane := rgb(222,207,198)
           ::cAlign   := "center"

      case ::nTipo == CHECK
           ::nClrPane := CLR_WHITE
           ::cAlign   := "left"

      case ::nTipo == RADIODSGN
           ::nClrPane := CLR_WHITE
           ::cAlign   := "left"
   endcase

   ::cCaption     := "botón"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }



  ::aProperties :=    { "cCaption"       ,;
                        "cAlign"         ,;
                        "aDotsActives"   ,;
                        "cObjName"       ,;
                        "aRect"          ,;
                        "lActive"        ,;
                        "lBorder"        ,;
                        "lCanSize"       ,;
                        "lCanMove"       ,;
                        "lEditable"      ,;
                        "lFlat"          ,;
                        "lVisible"       ,;
                        "nClrBorder"     ,;
                        "nClrPane"       ,;
                        "nClrText"       ,;
                        "nTipo"          ,;
                        "nTop","nLeft","nBottom","nRight" }

  if ::nTipo == BOTON
     aadd( ::aProperties, "cAction" )
  else
     aadd( ::aProperties, "lChecked" )
  endif

  if ::nTipo == RADIODSGN
     aadd( ::aProperties, "lGroup" )
  endif

  ::cObjName         := ::GetObjName()
  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self

*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnBtn
*************************************************************************************************

local oFont := ::oWnd:oForm:GetFontEx()
local hFont := oFont:hFont
local hOldFont := SelectObject( hDC, hFont )

   do case
      case ::nTipo == BOTON
           ::PaintBtn( hDC )
      case ::nTipo == CHECK
           ::PaintCheck( hDC )
      case ::nTipo == RADIODSGN
           ::PaintRadio( hDC )

      otherwise
           super:Paint( hDC )
   endcase

SelectObject( hDC, hOldFont )
oFont:End()


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil


*************************************************************************************************
  METHOD PaintBtn( hDC ) CLASS TDsgnBtn
*************************************************************************************************
local hOldBrush, hOldPen
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hTheme := nil
local nClrPane := ::nClrPane
local hFont, hOldFont, oFontPPC
local nAlign, color

if nClrPane == nil ; nClrPane := rgb(222,207,198) ; endif

if ::oWnd:lPocketPc()

   FillSolidRect( hDC, rc, nClrPane, 0 )

   //if ::lBold == nil; ::lBold := .t. ; endif
                                                                         //lFromUser
   //oFontPPC := TFont():New( ::cFaceName, ::nWidthFont, ::nHeightFont, .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )

   //hOldFont := SelectObject( hDC, oFontPPC:hFont )

   SetBkMode( hDC, TRANSPARENT )
   color := SetTextColor( hDC, CLR_BLACK )

   DrawText( hDC, ::cCaption, rc, nOr( DT_SINGLELINE , DT_VCENTER, DT_CENTER, DT_END_ELLIPSIS ))

   //SelectObject( hDC, hOldFont  )
   SetTextColor(hDC, color)

   //oFontPPC:End()

   if ::lDefault
      rc[1]++;      rc[2]++;      rc[3]--;      rc[4]--
      Box(hDC, rc, 0 )
   endif

else

   //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")

      if hTheme != nil

         C5_DrawThemeBackground( hTheme, hDC, BP_PUSHBUTTON, nil , rc )
         C5_DrawThemeText( hTheme, hDC, BP_PUSHBUTTON, PBS_NORMAL, ::cCaption, nOr( DT_VCENTER, DT_CENTER, DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()

      endif

   else

     FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE) )

     if ::lFlat

        DrawFrameControl(hDC, rc, DFC_BUTTON, nOr(DFCS_BUTTONPUSH, DFCS_FLAT ))
        hOldBrush := SelectObject( hDC, GetStockObject( NULL_BRUSH ))
        hOldPen   := SelectObject( hDC, GetStockObject( WHITE_PEN ) )
        Rectangle( hDC, rc[1]+1, rc[2]+1, rc[3]-1, rc[4]-1 )
        SelectObject( hDC, hOldPen )
        SelectObject( hDC, hOldBrush )

     else

        if ::lDefault

           FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE), 0 )

           rc[1]++
           rc[2]++
           //rc[3]--
           //rc[4]--

        endif

        DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )

     endif

     rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
     SetBkMode( hDC, TRANSPARENT )
     do case
        case ::cAlign == "left"
             nAlign := nOr( DT_SINGLELINE, DT_VCENTER )
        case ::cAlign == "center"
             nAlign := nOr( DT_SINGLELINE, DT_VCENTER, DT_CENTER )
        case ::cAlign == "right"
             nAlign := nOr( DT_SINGLELINE, DT_VCENTER, DT_RIGHT )
     endcase
     DrawText(hDC, ::cCaption, rc, nAlign )


   endif

endif

//SelectObject( hDC, hOldFont )

return nil

*************************************************************************************************
  METHOD PaintCheck( hDC ) CLASS TDsgnBtn
*************************************************************************************************
local hOldBrush, hOldPen
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local iMode
local hTheme := nil
local nState
local hFont, hOldFont, oFontPPC
local nClrPane := ::nClrPane
local hBmp
local nLeft, color

if ::oWnd:lPocketPc()

   if ::cAlign == "left"
      nLeft := rc[2]
   else
      nLeft := rc[4]- 20
   endif

   FillSolidRect( hDC, rc, nClrPane )

   hBmp     := LoadBitmap( GetResources(), if(::lChecked,"chkonppc","chkofppc" ) )
   DrawMasked( hDC, hBmp, rc[1]+(::nHeight/2)-8, nLeft )
   DeleteObject( hBmp )

   //DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

   //hOldFont := SelectObject( hDC, oFontPPC:hFont )

   SetBkMode( hDC, TRANSPARENT )
   color := SetTextColor( hDC, CLR_BLACK )

   if ::cAlign == "left"
      rc[2] += 20
   endif

   DrawText(hDC, ::cCaption, rc, nOr(DT_SINGLELINE,DT_VCENTER) )

   //SelectObject( hDC, hOldFont  )
   SetTextColor(hDC, color)
   //oFontPPC:End()


else

   //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")

      if hTheme != nil

          nState := if(::lActive, if(::lPressed, CBS_CHECKEDPRESSED, if(::lHotTrack,CBS_CHECKEDHOT,CBS_CHECKEDNORMAL)),;
                        CBS_CHECKEDDISABLED)

         if ::cAlign == "left"
            rc[4] := rc[2] + 20
         else
            rc[2] := rc[4] - 20
         endif

         C5_DrawThemeBackground( hTheme, hDC, BP_CHECKBOX, if( ::lChecked,CBS_CHECKEDNORMAL,CBS_UNCHECKEDNORMAL ) , rc )
         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
         if ::cAlign == "left"
            rc[2] += 20
         else
            rc[4] -= 20
         endif
         C5_DrawThemeText( hTheme, hDC, BP_CHECKBOX, CBS_CHECKEDNORMAL, ::cCaption, nOr( DT_VCENTER, DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()

      endif

   else

     if nClrPane == nil
        nClrPane := GetSysColor(COLOR_BTNFACE)
     endif

     FillSolidRect( hDC, rc, nClrPane )

     iMode := SetBkMode( hDC, TRANSPARENT )

     if ::cAlign == "left"
        rc[2] += 20
     endif

     DrawText(hDC, ::cCaption, rc, nOr(DT_SINGLELINE,DT_VCENTER) )
     SetBkMode( hDC, iMode )

     rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

     rc[1] := rc[1] + ((rc[3]-rc[1])/2)-6
     rc[3] := rc[1] + 14

     if ::cAlign == "left"
        rc[4] := rc[2] + 20
     else
        rc[2] := rc[4] - 20
     endif

     DrawFrameControl(hDC, rc, DFC_BUTTON, nOr( DFCS_BUTTONCHECK,;
                                                if(::lFlat,DFCS_FLAT,0 ),;
                                                if(::lChecked,DFCS_CHECKED,0),;
                                                if( ::lActive,0,DFCS_INACTIVE) ))
   endif

endif

return nil

*************************************************************************************************
  METHOD PaintRadio( hDC ) CLASS TDsgnBtn
*************************************************************************************************
local hOldBrush, hOldPen
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local iMode
local hTheme := nil
local hFont, hOldFont, oFontPPC
local nClrPane := ::nClrPane
local hBmp, nLeft, color

if ::oWnd:lPocketPc()

   if ::cAlign == "left"
      nLeft := rc[2]
   else
      nLeft := rc[4]- 20
   endif

   FillSolidRect( hDC, rc, nClrPane )

   hBmp     := LoadBitmap( GetResources(), if(::lChecked,"radonppc","radofppc" ) )
   DrawMasked( hDC, hBmp, rc[1]+(::nHeight/2)-8, nLeft )
   DeleteObject( hBmp )

   //DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

   //hOldFont := SelectObject( hDC, oFontPPC:hFont )

   SetBkMode( hDC, TRANSPARENT )
   color := SetTextColor( hDC, CLR_BLACK )

   if ::cAlign == "left"
      rc[2] += 20
   endif

   DrawText(hDC, ::cCaption, rc, nOr(DT_SINGLELINE,DT_VCENTER) )

   //SelectObject( hDC, hOldFont  )
   SetTextColor(hDC, color)
   //oFontPPC:End()

else

   //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")

      if hTheme != nil

         if ::cAlign == "left"
            rc[4] := rc[2] + 20
         else
            rc[2] := rc[4] - 20
         endif

         C5_DrawThemeBackground( hTheme, hDC, BP_RADIOBUTTON, if( ::lChecked,RBS_CHECKEDNORMAL,RBS_UNCHECKEDNORMAL ) , rc )
         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

         if ::cAlign == "left"
            rc[2] := rc[2] + 20
         else
            rc[4] := rc[4] - 20
         endif

         C5_DrawThemeText( hTheme, hDC, BP_RADIOBUTTON, RBS_CHECKEDNORMAL, ::cCaption, nOr( DT_VCENTER, DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()

      endif

   else
     FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE) )

     //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

     if ::cAlign == "left"
        rc[2] := rc[2] + 20
     endif

     iMode := SetBkMode( hDC, TRANSPARENT )
     DrawText(hDC, ::cCaption, rc, nOr(DT_SINGLELINE,DT_VCENTER) )
     SetBkMode( hDC, iMode )
     //SelectObject( hDC, hOldFont )

     rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
     rc[1] := rc[1] + ((rc[3]-rc[1])/2)-7
     rc[3] := rc[1] + 14

     if ::cAlign == "left"
        rc[4] := rc[2] + 20
     else
        rc[2] := rc[4] - 20
     endif

     DrawFrameControl(hDC, rc, DFC_BUTTON, nOr( DFCS_BUTTONRADIO,;
                                                if(::lFlat,DFCS_FLAT,0),;
                                                if(::lChecked,DFCS_CHECKED,0),;
                                                if(::lActive,0,DFCS_INACTIVE) ))
   endif
endif

return nil




***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnBtn
***************************************************************************************************
local oMenu



   MENUITEM "Flat"             ACTION ::lFlat     := !::lFlat    , ::Refresh()
   if ::nTipo == BOTON
      MENUITEM "Default"       ACTION ::lDefault  := !::lDefault , ::Refresh()
   endif
   if ::nTipo == CHECK .or. ::nTipo == RADIODSGN
      MENUITEM "Checked"       ACTION ::lChecked  := !::lChecked , ::Refresh()
   endif

   SEPARATOR


return nil

**********************************************************************************
  METHOD Inspect( cDataName, oInspector ) CLASS TDsgnBtn
**********************************************************************************

local o := self
local uVal

   do case
      case cDataName == "cAlign"
           do case
              case ::nTipo == BOTON
                   return { "left","center","right" }
              case ::nTipo == CHECK .or. ::nTipo == RADIODSGN
                   return { "left","right" }
           endcase

      case cDataName == "cAction"

           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif

           return {|cDataName| oSend( self, "_" + cDataName, MemoEdit2( o:cAction ) ) }
   endcase

return super:Inspect( cDataName, oInspector )

**********************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnBtn
**********************************************************************************
local cRet := ""
local cObject
local nNum
local cVar

cObject := ::cObjName

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""


        do case
           case ::nTipo == BOTON

                cHeader += "local " + cObject + CRLF

                cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " BUTTON " + cObject + ' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                        "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                        '                 ACTION ' + GetFunctionName( ::cAction )  + ' ;' + CRLF +;
                        "                 OF " + cFrom + CRLF

                cFunciones += ::cAction + CRLF

           case ::nTipo == CHECK

                cHeader += "local " + cObject + CRLF
                cVar    := "l" + substr( cObject, 2 )
                cHeader += "local " + cVar + " := " + if( ::lChecked, ".T.",".F." ) + CRLF

                cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " CHECKBOX " + cObject + " VAR " + cVar +' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                        "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                        "                 OF " + cFrom + CRLF

           case ::nTipo == RADIODSGN

                cHeader += "local " + cObject + CRLF
                cVar    := "n" + substr( cObject, 2 )
                cHeader += "local " + cVar + " := 1"  + CRLF

                if ::lGroup

                   //#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
                   //             [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
                   //             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
                   //             [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
                   //             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
                   //             [ COLOR <nClrFore> [,<nClrBack>] ] ;
                   //             [ MESSAGE <cMsg> ] ;
                   //             [ <update: UPDATE> ] ;
                   //             [ WHEN <uWhen> ] ;
                   //             [ SIZE <nWidth>, <nHeight> ] ;
                   //             [ VALID <uValid> ] ;
                   //             [ <lDesign: DESIGN> ] ;
                   //             [ <lLook3d: 3D, _3D> ] ;
                   //             [ <lPixel: PIXEL> ] ;

                   cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " RADIO " + cObject + " VAR " + cVar + " ;" + CRLF +;
                           '                 PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                           "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                           "                 OF " + cFrom + CRLF

                else

                   cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " RADIOITEM " + cObject + ' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                           "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                           "                 OF " + cFrom + CRLF
                endif

        endcase

return cRet


***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnBtn
***************************************************************************************************
local nGroup
local o := self

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lActive","Active","L" ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "lCanMove","Can move", "L",nGroup )
oList:AddItem( "lCanSize","Can size", "L",nGroup )


nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0



****************************************************************************************************
  function GetFunctionName( cAction )
****************************************************************************************************

local nAt := at( "function", lower( cAction ) )
local nIni
local nEnd
local cRet := ""

if nAt != 0
   nEnd := at( ")", cAction)
endif

if nAt != 0 .and. nEnd != 0
   nIni := nAt + len( "function" )
   cRet := substr( cAction, nIni, nEnd-nIni+1 )
endif


if empty( cRet )
   cRet := 'MsgInfo( "Action" )'
endif

return cRet



****************************************************************************************************
  function nGetNum( cStr )
****************************************************************************************************
local n

cStr := UPPER( cStr )

for n := 65 to 90
    cStr := strtran( cStr, chr( n ),"" )
next

return val( cStr )

****************************************************************************************************
  function cGetStr( cStr )
****************************************************************************************************
local n

for n := 48 to 57
    cStr := strtran( cStr, chr( n ),"" )
next

return alltrim(cStr)



function MemoEdit2( cText, cTitle, nTop, nLeft, nBottom, nRight )

   local oFont, oDlg, oMemo, oBtnOk, oBtnCancel, oBtnHelp

   local uTemp := ''
   local lOk   := .f.

   DEFAULT nTop := 9, nLeft := 9, nBottom := 23, nRight := 68.5,;
           cTitle := "MemoEdit"

   DEFINE FONT oFont NAME "Courier New" SIZE 0, -12

   DEFINE DIALOG oDlg FROM nTop, nLeft TO nBottom, nRight ;
      TITLE cTitle FONT oFont

      uTemp := cText
      @ 4, 3 GET oMemo VAR uTemp MEMO OF oDlg PIXEL SIZE 100, 100 FONT oFont
     // oMemo:bGotFocus = { || oMemo:SetSel( 0, 0 ) }



   @ 110, 134 BUTTON oBtnOk PROMPT "&Ok" SIZE 36, 13 PIXEL ;
      ACTION ( cText := uTemp , ;
               lOk := .t., oDlg:End() )

   @ 78, 176 BUTTON oBtnCancel PROMPT "&Cancel" SIZE 36, 13 PIXEL ;
      ACTION oDlg:End()

   //@ 78, 176 BUTTON oBtnHelp PROMPT "&Help" SIZE 36, 13 PIXEL ;
   //   ACTION HelpTopic()

   ACTIVATE DIALOG oDlg CENTERED ;
      ON INIT (  ;
                oMemo:SetSize( oDlg:nWidth() - 17, oDlg:nHeight() - 77 ),;
                oBtnOk:nTop      := oDlg:nHeight() - 64,;
                oBtnOk:nLeft     := oDlg:nWidth() - 167,;
                oBtnCancel:nTop  := oDlg:nHeight() - 64,;
                oBtnCancel:nLeft := oDlg:nWidth() - 84 )
                //oBtnHelp:nTop    := oDlg:nHeight() - 64,;
                //oBtnHelp:nLeft   := oDlg:nWidth() -  84 )


   oFont:End()


return cText

