#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#include "uxtheme_tmt.ch"

CLASS TDsgnGrp FROM TShape

      DATA nAlign
      DATA lActive
      DATA nClrText

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD ShapeOver( nRow, nCol )
      METHOD IntersectRect( aRect )
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD SetProps( oList )


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnGrp
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 65
      nRight  := nLeft + 72
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )
  ::cObjName         := ::GetObjName()

   ::nClrText      := 0
   ::lActive       := .t.

   ::cCaption     := "GroupBox"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

   ::aProperties := { "cCaption"       ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
                      "nClrBorder"     ,;
                      "nClrText"       ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      ,;
                      "aDotsActives"   ,;
                      "aRect"          }


  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self


*************************************************************************************************
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnGrp
*************************************************************************************************
 local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

 if PtInRect( nRow, nCol, {rc[1]-5,rc[2]-5,rc[3]+5,rc[4]+5} )
    rc := {::aRect[1]+15,::aRect[2]+5,::aRect[3]-5,::aRect[4]-5}
    if !PtInRect( nRow, nCol, rc )
       return self
    endif
 endif

 return nil



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnGrp
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local color, iMode, colortext
local hTheme := nil
local nClrText := 0
local cCaption := if( ::cCaption == "" , ::cCaption, " " + ::cCaption + " " )
local hFont, hOldFont, oFontPPC

if ::oWnd:lPocketPc()

   rc[1] += 6
   Box(hdc, rc, 0 )
   if !empty( ::cCaption )

//      DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

//      hOldFont := SelectObject( hDC, oFontPPC:hFont )

      color := SetTextColor( hDC, CLR_BLACK )
      iMode    := SetBkMode( hDC, OPAQUE )
      TextOut( hDC,  rc[1]-6, rc[2]+4, cCaption )
      SetBkMode( hDC, iMode )
//      SelectObject( hDC, hOldFont  )
      SetTextColor(hDC, color)
//      oFontPPC:End()
   endif


else

//    hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

//    hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
    color    := SetBkColor( hDC, GetSysColor(COLOR_BTNFACE))
    iMode    := SetBkMode( hDC, OPAQUE )

    if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

       hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")

       if hTheme != nil

          rc[1]+=6
          C5_DrawThemeBackground   ( hTheme, hDC, BP_GROUPBOX, if(::lActive, GBS_NORMAL,GBS_DISABLED ) , rc )
          nClrText := SetTextColor( hDC, GetThemeColor( hTheme,BP_GROUPBOX,GBS_NORMAL, TMT_TEXTCOLOR ) )
          // cambiar por DrawText
          TextOut( hDC,  rc[1]-6, rc[2]+4, cCaption )
          //C5_DrawThemeText( hTheme, hDC, BP_GROUPBOX, if(::lActive, GBS_NORMAL,GBS_DISABLED ), ::cCaption, nOr( DT_SINGLELINE ), nil, rc )
          C5_CloseThemeData()

       endif

    else
       rc[1] += 6
       DrawEdge(hDC, rc, EDGE_ETCHED , BF_RECT )
       TextOut( hDC,  rc[1]-6, rc[2]+4, cCaption )
    endif

    SetTextColor( hDC, nClrText )
//    SelectObject( hDC, hOldFont )
    SetBkMode( hDC, iMode )
    SetBkColor( hDC, color )

endif

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnGrp
***************************************************************************************************
local oMenu
local o := self

  /*  MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lMultiline"   ,,o:LMultiline    ,,{|oMenuItem|::lMultiline     := !::lMultiline    ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lVScroll"     ,,o:lVScroll      ,,{|oMenuItem|::lVScroll       := !::lVScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHScroll"     ,,o:lHScroll      ,,{|oMenuItem|::lHScroll       := !::lHScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lRightVScroll",,o:lRightVScroll ,,{|oMenuItem|::lRightVScroll  := !::lRightVScroll ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lDownHScroll" ,,o:lDownHScroll  ,,{|oMenuItem|::lDownHScroll   := !::lDownHScroll  ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lModalFrame"  ,,o:lModalFrame   ,,{|oMenuItem|::lModalFrame    := !::lModalFrame   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lClientEdge"  ,,o:lClientEdge   ,,{|oMenuItem|::lClientEdge    := !::lClientEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lStaticEdge"  ,,o:lStaticEdge   ,,{|oMenuItem|::lStaticEdge    := !::lStaticEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
  */
   SEPARATOR


return nil

***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TDsgnGrp
***************************************************************************************************
local lIntersect := .f.

if aRect[1] > ::aRect[1] .and.;
   aRect[2] > ::aRect[2] .and.;
   aRect[3] < ::aRect[3] .and.;
   aRect[4] < ::aRect[4]
   return .f.
endif

if IntersectRect( aRect, ::aRect )
   lIntersect := .t.
endif

return lInterSect

***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnGrp
***************************************************************************************************
local cRet := ""
local cObject
local cVar

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""


  cObject := ::cObjName
  cVar    := "c" + substr( cObject, 2 )

  cHeader += "local " + cObject + CRLF

  cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " GROUP " + cObject + " TO " + ::cStrBottom(lDialog) + ", " + ::cStrRight(lDialog) + " ;" + CRLF +;
          '                 PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
          "                 PIXEL ; " + CRLF +;
          "                 OF " + cFrom + " TRANSPARENT" + CRLF

return cRet


***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnGrp
***************************************************************************************************
local nGroup
local o := self

   ::aProperties := { "cCaption"       ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
                      "nClrBorder"     ,;
                      "nClrText"       ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      ,;
                      "aDotsActives"   ,;
                      "aRect"          }

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lActive","Active", ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "nClrText"    ,"Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane"    ,"Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )

nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0


