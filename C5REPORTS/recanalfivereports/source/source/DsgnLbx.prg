#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnLbx FROM TShape

      DATA aProperties


      DATA lFlat
      DATA lRightVScroll
      DATA lDownHScroll
      DATA lVScroll
      DATA lHScroll
      DATA nAlign
      DATA lActive
      DATA nClrText
      DATA lModalFrame
      DATA aList

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD SetProps( oList )


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnLbx
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 65
      nRight  := nLeft + 72
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::nAlign        := nOr(DT_SINGLELINE)
   ::lActive       := .t.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lVScroll      := .t.
   ::lHScroll      := .f.
   ::lBorder       := .t.
   ::lModalFrame   := .f.
   ::aList         := {""}
  ::cObjName         := ::GetObjName()

   ::cCaption     := "ListBox"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

   ::aProperties := { "cCaption"       ,;
                      "aDotsActives"   ,;
                      "aList"          ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lDownHScroll"   ,;
                      "lEditable"      ,;
                      "lFlat"          ,;
                      "lHScroll"       ,;
                      "lModalFrame"    ,;
                      "lRightVScroll"  ,;
                      "lVScroll"       ,;
                      "lVisible"       ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nOption"        ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif


return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnLbx
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color
local hTheme, nState
//local hOldFont, oFontPPC


iMode := SetBkMode(hDC,TRANSPARENT)
if ::oWnd:lPocketPc()

   FillSolidRect( hDC, rc, ::nClrPane, 0 )

   //DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

   //hOldFont := SelectObject( hDC, oFontPPC:hFont )

   SetBkMode( hDC, TRANSPARENT )
   color := SetTextColor( hDC, ::nClrText )

   rc[2] += 3
   DrawText( hDC, ::cCaption, rc, ::nAlign )

   //SelectObject( hDC, hOldFont  )
   SetTextColor(hDC, color)
   //oFontPPC:End()

else


   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "LISTVIEW")

      if hTheme != nil
         //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
         nState := if(::lActive, LIS_NORMAL, LIS_DISABLED)

         C5_DrawThemeBackground( hTheme, hDC, LVP_LISTITEM, nState , rc )
         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
         rc[2] += 3
         C5_DrawThemeText( hTheme, hDC, LVP_LISTITEM, nState, ::cCaption, nOr( DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()
         //SelectObject( hDC, hOldFont )

      endif

   else

       //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )


       FillSolidRect(hDC, rc, if(::lActive,::nClrPane,GetSysColor(COLOR_BTNFACE)) )

       rcText := {rc[1],rc[2],rc[3],rc[4]}

       if !::lActive
          rc[1]++; rc[2]++; rc[3]++; rc[4]++

          color := SetTextColor( hDC,  RGB(255,255,255) )
          DrawText( hDC, ::cCaption, rcText, nOr(DT_LEFT, DT_TOP, DT_WORDBREAK ) )
          rc[1]--; rc[2]--; rc[3]--; rc[4]--
          SetTextColor( hDC, color )
          color := SetTextColor( hDC, GetSysColor( COLOR_GRAYTEXT ) )
       else
          rcText[1]+=3; rcText[2]+=3
          color := SetTextColor( hDC, ::nClrText )
       endif

       DrawText( hDC, ::cCaption, rcText, nOr(DT_LEFT, DT_TOP, DT_WORDBREAK ))


       if ::lBorder

               rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
               if ::lModalFrame
                  rc[1]++; rc[2]++; rc[3]--; rc[4]--
               endif
               DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
               rc[1]++; rc[2]++; rc[3]--; rc[4]--
               DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
               rc[1]--; rc[2]--; rc[3]++; rc[4]++
               if ::lModalFrame
                  rc[1]-=2; rc[2]-=2; rc[3]+=2; rc[4]+=2
               endif
       endif
   endif
endif

if ::lVScroll
   ::PaintVScroll( hDC, ::lRightVScroll,::lHScroll, ::lDownHScroll )
endif

if ::lHScroll
   ::PaintHScroll( hDC, ::lDownHScroll ,::lVScroll, ::lRightVScroll )
endif

SetBkMode(hDC,iMode)

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil






***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnLbx
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lVScroll"     ,,o:lVScroll      ,,{|oMenuItem|::lVScroll       := !::lVScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHScroll"     ,,o:lHScroll      ,,{|oMenuItem|::lHScroll       := !::lHScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lRightVScroll",,o:lRightVScroll ,,{|oMenuItem|::lRightVScroll  := !::lRightVScroll ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lDownHScroll" ,,o:lDownHScroll  ,,{|oMenuItem|::lDownHScroll   := !::lDownHScroll  ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive       ,::Refresh()},,,,,,,.F.,,,.F. )

   SEPARATOR


return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnLbx
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnLbx
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )

***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnLbx
***************************************************************************************************
local cRet := ""
local cObject
local cVar
local caItems

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""


        cObject := ::cObjName
        cVar    := "c" + substr( cObject, 2 )
        caItems := "a" + substr( cObject, 2 )
        cHeader += "local " + cObject + CRLF
        cHeader += "local " + cVar + ' := "' + alltrim( ::cCaption ) + '"' + CRLF
        cHeader += "local " + caItems + ' := {"' + alltrim( ::cCaption )  + '"}' + CRLF


        cRet += "         @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " LISTBOX " + cObject + ' VAR ' + cVar + " ITEMS " + caItems + " ;" + CRLF +;
             "                  SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
             "                  OF " + cFrom  + CRLF

return cRet


***************************************************************************************************
   METHOD SetProps( oList ) CLASS TDsgnLbx
***************************************************************************************************
local nGroup
local o := self

//      DATA lFlat
//      DATA lRightVScroll
//      DATA lDownHScroll
//      DATA lVScroll
//      DATA lHScroll
//      DATA nAlign
//      DATA lActive
//      DATA nClrText
//      DATA lModalFrame
//      DATA nTipo
//      DATA aList

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lActive","Active","L" ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "lCanMove","Can move", "L",nGroup )
oList:AddItem( "lCanSize","Can size", "L",nGroup )
oList:AddItem( "aList","Items","B",nGroup,,,{|| InspectArray(o, "aList") })

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

