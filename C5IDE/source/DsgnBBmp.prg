#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnBtnBmp FROM TShape

      DATA lFlat
      DATA lDefault
      DATA lActive
      DATA cAlign
      DATA lPressed
      DATA lHotTrack
      DATA cFileName

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nTipo ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD PaintBtn( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD Inspect( cDataName )
      METHOD GenPrg( lDialog, cFrom )
      METHOD SetProps( oList )


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nTipo ) CLASS TDsgnBtnBmp
************************************************************************************************

DEFAULT nTipo := BOTON

if nTop != nil
   if nBottom-nTop < 10 .or. nRight-nLeft < 10
      nBottom    := nTop + 60
      nRight     := nLeft + 60
   endif
endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat        := .f.
   ::lActive      := .t.
   ::lBorder      := .t.
   ::lDefault     := .f.
   ::nClrBorder   := 0
   ::cFileName    := ""
   ::lPressed     := .f.
   ::lHotTrack    := .f.

   ::nClrPane := rgb(222,207,198)
   ::cAlign   := "center"
   ::cCaption     := "boton"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

  ::aPropertiesPPC := { "cCaption"       ,;
                        "cAlign"         ,;
                        "cFileName"      ,;
                        "nID"            ,;
                        "nTop"           ,;
                        "nLeft"          ,;
                        "nWidth"         ,;
                        "nHeight"        }    // ,; "nClrPane",; "nClrText"        }
                        /*
                        "cFaceName"      ,;
                        "nWidthFont"     ,;
                        "nHeightFont"    ,;
                        "lBold"          ,;
                        "lItalic"        ,;
                        "lUnderline"     ,;
                        "lStrikeOut"
                        */

  ::aProperties :=    { "cCaption"       ,;
                        "cFileName"      ,;
                        "aDotsActives"   ,;
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
                        "nTop","nLeft","nBottom","nRight",;
                        "xMaxHeight"     ,;
                        "xMaxWidth"      ,;
                        "xMinHeight"     ,;
                        "xMinWidth"      }

  ::cObjName         := ::GetObjName()

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif


return self

*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnBtnBmp
*************************************************************************************************

  ::PaintBtn( hDC )

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil


*************************************************************************************************
  METHOD PaintBtn( hDC ) CLASS TDsgnBtnBmp
*************************************************************************************************
local hOldBrush, hOldPen
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hTheme := nil
local nClrPane := ::nClrPane
local hFont, hOldFont, oFontPPC, oFont
local nAlign
local hBmp
local szcy := 0
local szcx := 0
local nRow, nCol
local xLayout := 0
local yLayout := 0
local iMode

if nClrPane == nil ; nClrPane := rgb(222,207,198) ; endif

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")

      if hTheme != nil

         C5_DrawThemeBackground( hTheme, hDC, BP_PUSHBUTTON, nil , rc )
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
  endif

::cFileName := alltrim(::cFileName )

if "." $ ::cFileName
   hBmp := ReadBitmap( 0, ::cFileName )
else
   hBmp := LoadBitmap( GetResources(), ::cFileName )
endif

szcy := 12

if !empty( ::cCaption )

    oFont := ::oWnd:oForm:GetFontEx()
    hFont := oFont:hFont
    szcx := GetTextWidth( hDC, strtran(::cCaption,"&",""), hFont )
    oFont:End()
    hOldFont := SelectObject( hDC, hFont )
    do case
       case ::cAlign == "top"

            yLayout := -szcy + 2
            nRow := rc[3] - rc[1] - szcy - 4
            nCol := ( ( rc[4] - rc[2] ) / 2 ) - ( szcx / 2 )

       case ::cAlign == "left"

            xLayout := -szcx + 4
            nRow := ( ( rc[3] - rc[1] ) / 2 ) - ( szcy / 2 )
            nCol := rc[4] - rc[2] - szcx - 8

       case ::cAlign == "bottom"
            yLayout := szcy - 2
            nRow := 4
            nCol := ( ( rc[4] - rc[2] ) / 2 ) - ( szcx / 2 )

       case ::cAlign == "right"
            xLayout := szcx - 4
            nRow := ( ( rc[3] - rc[1] ) / 2 ) - ( szcy / 2 )
            nCol := 8

       otherwise

            nRow := ( ( rc[3] - rc[1] ) / 2 ) - ( szcy / 2 )
            nCol := ( ( rc[4] - rc[2] ) / 2 ) - ( szcx / 2 )

    endcase

    iMode := SetBkMode( hDC, TRANSPARENT )
    TextOut( hDC, rc[1]+nRow, rc[2]+nCol, ::cCaption )
    hOldFont := SelectObject( hDC, hOldFont )
    SetBkMode( hDC, iMode )

endif

if hBmp != 0
   DrawMasked( hDC, hBmp, (rc[1] + (( rc[3]-rc[1])/2) - nBmpHeight( hBmp )/2)+ yLayout ,;
                          (rc[2] + (( rc[4]-rc[2])/2) - nBmpWidth ( hBmp )/2)+ xLayout )  //  + xLayout
   DeleteObject( hBmp )
endif

//SelectObject( hDC, hOldFont )

/*
if oFontPPC != nil
   oFontPPC:End()
endif
*/

//oFont:End()

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnBtnBmp
***************************************************************************************************
local oMenu

return nil

**********************************************************************************
  METHOD Inspect( cDataName ) CLASS TDsgnBtnBmp
**********************************************************************************

local o := self
local uVal

   do case
      case cDataName == "cAlign"
           return { "top","left","bottom","right","center" }

      case cDataName == "cFileName"
           return {|| o:cGetFileName() }
   endcase

return nil

**********************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnBtnBmp
**********************************************************************************
local cRet := ""
local cObject := ::cObjName

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

        cHeader += "local " + cObject + CRLF

        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " BUTTONBMP " + cObject + ' ;' + CRLF +;
                "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                '         ACTION MsgInfo( "action") ;' + CRLF +;
                "         BITMAP " + alltrim( ::cFileName) + " ; " +;
                if( !empty(::cCaption), CRLF + "         PROMPT " + '"' + alltrim( ::cCaption ) + '" ;' + CRLF,CRLF) + ;
                "         OF " + cFrom  + CRLF


return cRet




***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnBtnBmp
***************************************************************************************************
local nGroup
local o := self
//::aProperties :=    { "cCaption"       ,;
//                        "cAlign"         ,;
//                        "aDotsActives"   ,;
//                        "cObjName"       ,;
//                        "aRect"          ,;
//                        "lActive"        ,;
//                        "lBorder"        ,;
//                        "lCanSize"       ,;
//                        "lCanMove"       ,;
//                        "lEditable"      ,;
//                        "lFlat"          ,;
//                        "lVisible"       ,;
//                        "nClrBorder"     ,;
//                        "nClrPane"       ,;
//                        "nClrText"       ,;
//                        "nTipo"          ,;
//                        "nTop","nLeft","nBottom","nRight" }

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lActive","Active","L" ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "cAlign"  ,"Image align", "A",nGroup,,,{||{"top","left","bottom","right","center"}} )
oList:AddItem( "lCanMove","Can move", "L",nGroup )
oList:AddItem( "lCanSize","Can size", "L",nGroup )
oList:AddItem( "cFileName","Image", "B",nGroup,,,{|| cGetFile( "Imágenes (*.bmp *.gif *.jpg ) | *.bmp;*.gif;*.jpg; |", "Selecciona imagen" )} )

nGroup := oList:AddGroup(  "Position" )

oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0










