#include "fivewin.ch"
#include "wnddsgn.ch"
 #define LOGPIXELSY          90

CLASS TDsgnSay FROM TShape


      DATA lFlat
      DATA lMultiline
      DATA cAlign
      DATA lActive
      DATA nClrText
      DATA lModalFrame
      DATA lClientEdge
      DATA lStaticEdge
      DATA lSunken
      DATA lStaticFrame
      DATA hBmp
      DATA hIcon

      DATA lxAdjust
      DATA aLastSize
      DATA aRealSize

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD ShapeOver( nRow, nCol )
      METHOD IntersectRect( aRect )
      METHOD lAdjust( lNuevoValor ) SETGET
      METHOD Save2INI()
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD SetProps( oList )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnSay
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 16
      nRight  := nLeft + 79
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::cCaption      := "Text"
   ::nClrPane      := nil
   ::cAlign        := "left"
   ::lActive       := .t.
   ::lMultiline    := .f.
   ::lModalFrame   := .f.
   ::lClientEdge   := .f.
   ::lStaticEdge   := .f.
   ::lStaticFrame  := .f.
   ::lSunken       := .f.
   ::lBorder       := .f.
   ::hIcon         := nil
   ::nMinHeight    := 1
   ::nMinWidth     := 1
   ::lxAdjust      := .f.
  ::cObjName         := ::GetObjName()

   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

  ::aPropertiesPPC := { "cCaption"      ,;
                        "lBorder"       ,;
                        "nID"           ,;
                        "nTop"          ,;
                        "nLeft"         ,;
                        "nWidth"        ,;
                        "nHeight"       ,;
                        "nClrPane"      ,;
                        "nClrText"      }


   ::aProperties := { "cCaption"       ,;
                      "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lClientEdge"    ,;
                      "lStaticEdge"    ,;
                      "lStaticFrame"   ,;
                      "lSunken"        ,;
                      "lEditable"      ,;
                      "lFlat"          ,;
                      "lModalFrame"    ,;
                      "lMultiline"     ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nOption"        ,;
                      "oFont"          ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnSay
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color
local nAlign
local aVal := { DT_TOP, DT_VCENTER, DT_BOTTOM }
local aHal := { DT_LEFT, DT_CENTER, DT_RIGHT }
local oFont, hOldFont
local rcSize
local nHeight



if ::lAdjust .and. !empty( ::aRealSize )
   ::aRect[4]  := ::aRect[2] + ::aRealSize[1]
   ::aRect[3]  := ::aRect[1] + ::aRealSize[2]
endif

   if !empty( ::cFaceName ) .and. ::cFaceName != ::oWnd:oForm:cFaceName
      oFont := TFont():New( ::cFaceName, 0, -1 * abs(::nHeightFont) , .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
      hOldFont := SelectObject( hDC, oFont:hFont )
   endif

   if ::lStaticFrame
      Box( hDC, rc, CLR_WHITE )
      rc[1]++;rc[2]++
      Box( hDC, rc, CLR_WHITE )
      rc[1]--;rc[2]--
      rc[3]--;rc[4]--
      Box( hDC, rc, CLR_GRAY )
      rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
   endif

   nAlign := nOr({DT_LEFT,DT_CENTER,DT_RIGHT}[ ascan( {"LEFT","CENTER","RIGHT"}, upper(::cAlign))], DT_TOP, DT_WORDBREAK)

   if !::lActive
      rc2 := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      rc2[1]++;rc2[2]++;rc2[3]++;rc2[4]++
      color := SetTextColor( hDC, RGB(255,255,255) )
      DrawText( hDC, ::cCaption, rc2, nAlign )
      rc2[1]--;rc2[2]--;rc2[3]--;rc2[4]--
      SetTextColor( hDC, color )
      color = SetTextColor( hDC, GetSysColor( COLOR_GRAYTEXT ) )
   else
      rc2 := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      color = SetTextColor( hDC,  ::nClrText )
   endif

   if ::nClrPane != nil
      FillSolidRect( hDC, rc, ::nClrPane )
   endif

   SetBkMode(hDC, TRANSPARENT)

   if ::hBmp == nil .and. ::hIcon == nil

      rcSize := { rc2[1], rc2[2], rc2[3], rc2[4] }
      ::aRealSize := StrSize( hDC, ::cCaption, rcSize, nAlign )

      DrawText( hDC, ::cCaption, rc2, nAlign )

   endif

   SetTextColor( hDC, color )
   //SelectObject( hDC, hOldFont )

   rc2[1]-=3;rc2[2]-=3;rc2[3]+=3;rc2[4]+=3

   if ::lBorder
      Box( hDC, rc, 0 )
   endif

   if ::lModalFrame
      DrawEdge( hDC, rc, BDR_RAISEDOUTER, BF_RECT )
      rc[1]++;rc[2]++;rc[3]--;rc[4]--
      DrawEdge( hDC, rc, BDR_RAISEDINNER, BF_RECT )
      rc[1]++;rc[2]++;rc[3]++;rc[4]++
   endif

   if ::lClientEdge
      if ::lModalFrame
         rc[1]+=2;rc[2]+=2;rc[3]-=2;rc[4]-=2
      endif
      DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
      rc[1]+=1;rc[2]+=1;rc[3]-=1;rc[4]-=1
      DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
      rc[1]-=1;rc[2]-=1;rc[3]+=1;rc[4]+=1
      if ::lModalFrame
         rc[1]-=2;rc[2]-=2;rc[3]+=2;rc[4]+=2
      endif
   endif
   if ::lStaticEdge
      DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT ) //
   endif

   if ::lSunken
      if ::lClientEdge .and. !::lModalFrame
         rc[1]+=2;rc[2]+=2;rc[3]-=2;rc[4]-=2
      endif

      DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )

      if ::lClientEdge .and. !::lModalFrame
         rc[1]-=2;rc[2]-=2;rc[3]+=2;rc[4]+=2
      endif
   endif

   if oFont != nil
      SelectObject( hDC, hOldFont )
      oFont:End()
   endif


   if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
      ::DotsSelect( hDC )
   endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnSay
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Adjust"       ,,o:lxAdjust      ,,{|oMenuItem|::lAdjust( !::lxAdjust )             ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lModalFrame"  ,,o:lModalFrame   ,,{|oMenuItem|::lModalFrame    := !::lModalFrame   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lClientEdge"  ,,o:lClientEdge   ,,{|oMenuItem|::lClientEdge    := !::lClientEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lStaticEdge"  ,,o:lStaticEdge   ,,{|oMenuItem|::lStaticEdge    := !::lStaticEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lSunken"      ,,o:lSunken       ,,{|oMenuItem|::lSunken        := !::lSunken       ,::Refresh()},,,,,,,.F.,,,.F. )



   SEPARATOR


return nil

*************************************************************************************************
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnSay
*************************************************************************************************
 local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

 if PtInRect( nRow, nCol, {rc[1]-5,rc[2]-5,rc[3]+5,rc[4]+5} )
    if !::lStaticFrame
       return self
    else
       rc := {::aRect[1]+5,::aRect[2]+5,::aRect[3]-5,::aRect[4]-5}
       if !PtInRect( nRow, nCol, rc )
          return self
       endif
    endif
 endif

 return nil


***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TDsgnSay
***************************************************************************************************
local lIntersect := .f.

if ::lStaticFrame
   if aRect[1] > ::aRect[1] .and.;
      aRect[2] > ::aRect[1] .and.;
      aRect[3] < ::aRect[3] .and.;
      aRect[4] < ::aRect[4]
      return .f.
   endif
endif
if IntersectRect( aRect, ::aRect )
   lIntersect := .t.
endif

return lInterSect


***************************************************************************************************
  METHOD lAdjust( lNuevoValor ) CLASS TDsgnSay
***************************************************************************************************
local nW
local nH

if pcount() > 0
   nW := ::aRect[4]-::aRect[2]
   nH := ::aRect[3]-::aRect[1]

   if lNuevoValor
      ::aLastSize := {nW,nH}
      ::aRect[4]  := ::aRect[2] + ::aRealSize[1]
      ::aRect[3]  := ::aRect[1] + ::aRealSize[2]
   else
      ::aRect[4] := ::aRect[2] + ::aLastSize[1]
      ::aRect[3] := ::aRect[1] + ::aLastSize[2]
   endif
   ::lxAdjust := lNuevoValor

endif

return ::lxAdjust





***************************************************************************************************
  METHOD Save2INI() CLASS TDsgnSay
***************************************************************************************************

local cStr := ""
local cItem := ::ClassName()

//      DATA lFlat
//      DATA lMultiline
//      DATA nAlign
//      DATA lActive
//      DATA nClrText
//      DATA lModalFrame
//      DATA lClientEdge
//      DATA lStaticEdge
//      DATA lSunken
//      DATA lStaticFrame
//      DATA hBmp
//      DATA hIcon
//
//      DATA lxAdjust
//      DATA aLastSize
//      DATA aRealSize



cStr += "["+cItem+"]"                                            + CRLF
cStr += "nTop="         + ::cStrTop()                            + CRLF
cStr += "nLeft="        + ::cStrLeft()                           + CRLF
cStr += "nWidth="       + ::cStrWidth()                          + CRLF
cStr += "nHeight="      + ::cStrHeight()                         + CRLF
cStr += "lFlat="        + if(::lFlat,".T.",".F.")                + CRLF
cStr += "lMultiline="   + if(::lMultiline,".T.",".F.")           + CRLF
cStr += "cAlign="       + ::cAlign                               + CRLF
cStr += "cFaceName="    + ::cFaceName                            + CRLF
cStr += "nHFont="       + strtrim(::nHFont)                      + CRLF
cStr += "lUnder="       + if( ::lUnder,"Yes","No")               + CRLF
cStr += "lBold="        + if( ::lBold,"Yes","No")                + CRLF
cStr += "lItalic="      + if( ::lItalic,"Yes","No")              + CRLF
cStr += "lTransparent=" + if( ::lTransparent,"Yes","No")         + CRLF
cStr += "nClrText="     + strtrim(::nClrText)                    + CRLF
cStr += "cClrPane="     + strtrim(::nClrPane)                    + CRLF
cStr += "nGiro="        + strtrim(::nGiro)                       + CRLF
cStr += "lEnable="      + if( ::lEnable,"Yes","No")              + CRLF
cStr += "nID="          + strtrim(::nID)                         + CRLF+ CRLF

return cStr

return c


***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnSay
***************************************************************************************************
local cRet := ""
local cObject := ::cObjName
local cCaption := alltrim( ::cCaption )

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

   cObject := ::cObjName
   cHeader += "local " + cObject + CRLF

   cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " SAY " + cObject + ' PROMPT "' + cCaption + '" ;' + CRLF +;
           "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
           "                 OF " + cFrom + " TRANSPARENT FONT oFont" + CRLF

return cRet


***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnSay
***************************************************************************************************
local nGroup
local o := self
// ::aProperties := { "cCaption"         ,;
//                      "aDotsActives"   ,;
//                      "aRect"          ,;
//                      "lActive"        ,;
//                      "lBorder"        ,;
//                      "lCanSize"       ,;
//                      "lCanMove"       ,;
//                      "lClientEdge"    ,;
//                      "lStaticEdge"    ,;
//                      "lStaticFrame"   ,;
//                      "lSunken"        ,;
//                      "lEditable"      ,;
//                      "lFlat"          ,;
//                      "lModalFrame"    ,;
//                      "lMultiline"     ,;
//                      "lVisible"       ,;
//                      "nAlign"         ,;
//                      "nClrBorder"     ,;
//                      "nClrPane"       ,;
//                      "nClrText"       ,;
//                      "nOption"        ,;
//                      "oFont"          ,;
//                      "xMaxHeight"     ,;
//                      "xMaxWidth"      ,;
//                      "xMinHeight"     ,;
//                      "xMinWidth"      }

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lBorder","Border", ,nGroup )
oList:AddItem( "lActive","Active", ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "lCanMove","Can move", ,nGroup )
oList:AddItem( "lCanSize","Can size", ,nGroup )
oList:AddItem( "lClientEdge" ,"Client Edge", ,nGroup )
oList:AddItem( "lStaticEdge" ,"Static Edge", ,nGroup )
oList:AddItem( "lStaticFrame","Static Frame", ,nGroup )
oList:AddItem( "lSunken"     ,"Sunken", ,nGroup )
oList:AddItem( "cAlign"      ,"Align", "A",nGroup,,,{||{"Left","Center","Right"}} )
oList:AddItem( "nClrText"    ,"Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane"    ,"Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )
oList:AddItem( "cFaceName"   ,"FaceName", "A",nGroup,,,{|| aGetFontNamesEx() } )

//oList:AddItem( ,"Minimize Box", ,nGroup )
//oList:AddItem( ,"Overlaped Window", ,nGroup )
//oList:AddItem( ,"Palette Window", ,nGroup,,.f. )
//oList:AddItem( ,"Static Edge", ,nGroup )
//oList:AddItem( ,"Style", "Overlapped",,nGroup )
//oList:AddItem( ,"System Menu", .t.,,nGroup )
//oList:AddItem( ,"Title Bar", ,nGroup )
//oList:AddItem( ,"Tool Window", ,nGroup )
//oList:AddItem( ,"Topmost", ,nGroup )
//oList:AddItem( ,"Transparent", ,nGroup )
//oList:AddItem( ,"Vertical ScrollBar", ,nGroup )
//oList:AddItem( ,"Window Edge", ,nGroup )
//oList:AddItem( ,"Color Texto", CLR_BLACK,ACCION,nGroup )
//
//
//nGroup := oList:AddGroup( "Fuente" )
//oList:AddItem( ,"Nombre", "Ms Sans Serif", LISTA, nGroup,,,{||hDC := GetDC( oList:hWnd ),aFonts := GetFontNames(hDC), aFonts := asort( aFonts ),ReleaseDC(oList:hWnd,hDC), aFonts} )
//oList:AddItem( ,"Ancho", 8,,nGroup )
//oList:AddItem( ,"Alto", 10,,nGroup )
//oList:AddItem( ,"Italic", ,nGroup )
//oList:AddItem( ,"Underline", ,nGroup )
//oList:AddItem( ,"Strike", ,nGroup )
//oList:AddItem( ,"Bold", ,nGroup )
//
//
//
//nGroup := oList:AddGroup( "Behavior" )
//oList:AddItem( ,"Accept Files", ,nGroup )
//oList:AddItem( ,"Application Window", ,nGroup )
//oList:AddItem( ,"Disabled", ,nGroup )
//oList:AddItem( ,"NoInheritLayout", ,nGroup )
//oList:AddItem( ,"Right To Left Reading Order", ,nGroup )
//oList:AddItem( ,"Set Foreground", ,nGroup )
//oList:AddItem( ,"System Modal", ,nGroup )
//oList:AddItem( ,"Visible", .t.,,nGroup )


nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0



#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"


HB_FUNC ( STRSIZE )
{
	RECT  rct;
	rct.top    = hb_parvni( 3, 1 );
	rct.left   = hb_parvni( 3, 2 );
	rct.bottom = hb_parvni( 3, 3 );
	rct.right  = hb_parvni( 3, 4 );

	DrawText( ( HDC ) hb_parnl( 1 ), hb_parc( 2 ), -1, &rct, hb_parnl( 4 ) | DT_CALCRECT );

	hb_reta( 2 );

	hb_storvni( rct.right-rct.left, -1, 1 );
	hb_storvni( rct.bottom-rct.top, -1, 2 );
}



#pragma ENDDUMP
