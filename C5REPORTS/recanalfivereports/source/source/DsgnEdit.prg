#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnEdit FROM TShape

      DATA lFlat
      DATA lxMultiline
      DATA lRightVScroll
      DATA lDownHScroll
      DATA lxVScroll
      DATA lHScroll
      DATA nAlign
      DATA lActive
      DATA nClrText
      DATA lModalFrame
      DATA lClientEdge
      DATA lStaticEdge

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD SetProps( oList )
      METHOD lMultiline( lNewValue ) SETGET
      METHOD lVScroll( lNewValue ) SETGET

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnEdit
************************************************************************************************

   if nTop != nil
      if nBottom-nTop < 10 .or. nRight-nLeft < 10
         nBottom := nTop + 23
         nRight  := nLeft + 60
      endif
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::nAlign        := nOr(DT_SINGLELINE,DT_VCENTER)
   ::lActive       := .t.
   ::lxMultiline    := .f.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lxVScroll      := .f.
   ::lHScroll      := .f.
   ::lModalFrame   := .f.
   ::lClientEdge   := .f.
   ::lStaticEdge   := .f.
   ::lBorder       := .t.
  ::cObjName         := ::GetObjName()


   ::cCaption     := ""
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


  ::aProperties :=  { "aDotsActives"   ,;
                      "aRect"          ,;
                      "cCaption"       ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lDownHScroll"   ,;
                      "lEditable"      ,;
                      "lHScroll"       ,;
                      "lxMultiline"     ,;
                      "lRightVScroll"  ,;
                      "lStaticEdge"    ,;
                      "lxVScroll"       ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
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
  METHOD Paint( hDC ) CLASS TDsgnEdit
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color, nClr
local hOldFont
local hTheme, nState, oFontPPC

iMode := SetBkMode( hDC, TRANSPARENT )
color := SetTextColor( hDC, ::nClrText )


if ::oWnd:lPocketPc()

   FillSolidRect( hDC, rc, ::nClrPane, 0 )

//   DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

//   hOldFont := SelectObject( hDC, oFontPPC:hFont )




   rc[2] += 3
   DrawText( hDC, ::cCaption, rc, ::nAlign )

//   SelectObject( hDC, hOldFont  )

   //oFontPPC:End()

else

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "EDIT")

      if hTheme != nil
    //     hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
         nState := if(::lActive, ETS_NORMAL, ETS_DISABLED)

         C5_DrawThemeBackground( hTheme, hDC, EP_EDITTEXT, nState , rc )
         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
         rc[2] += 2
         //C5_DrawThemeText( hTheme, hDC, EP_EDITTEXT, nState, ::cCaption, nOr( DT_SINGLELINE, DT_VCENTER ), nil, rc )
          DrawText(hDC, ::cCaption, rc, nOr( DT_LEFT, DT_SINGLELINE, DT_VCENTER )  )
         C5_CloseThemeData()
  //       SelectObject( hDC, hOldFont )

      endif

   else


    //  hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

      if ::lxMultiline

          iMode := SetBkMode(hDC,TRANSPARENT)

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
          endif

          DrawText( hDC, ::cCaption, rcText, nOr(DT_LEFT, DT_TOP, DT_WORDBREAK ))


          if ::lHScroll
             ::PaintHScroll( hDC, ::lDownHScroll ,::lxVScroll, ::lRightVScroll )
          endif

      else

          rc2 := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

          FillSolidRect(hDC, rc, if(::lActive,::nClrPane,GetSysColor(COLOR_BTNFACE)) )

          iMode  := SetBkMode(hDC, TRANSPARENT)

          rc2[2] += 2
          rc2[1] += 1
          rc2[4] -= 2

          if !::lActive
             rc2[1]++; rc2[2]++; rc2[3]++; rc2[4]++
             color := SetTextColor( hDC, RGB(255,255,255) )
             DrawText( hDC, ::cCaption, rc2, nOr( DT_LEFT, DT_SINGLELINE, DT_VCENTER ))
             rc2[1]--; rc2[2]--; rc2[3]--; rc2[4]--
             SetTextColor( hDC, color )
             color := SetTextColor( hDC, GetSysColor( COLOR_GRAYTEXT ) )
          else
             rc2[2]+= 2
          endif

          DrawText(hDC, ::cCaption, rc2, nOr( DT_LEFT, DT_SINGLELINE )  )

      endif

      //SelectObject( hDC, hOldFont )

      if ::lModalFrame
         DrawEdge( hDC, rc, BDR_RAISEDOUTER, BF_RECT )
         rc[1]++; rc[2]++; rc[3]--; rc[4]--
         DrawEdge( hDC, rc, BDR_RAISEDINNER, BF_RECT )
         rc[1]--; rc[2]--; rc[3]++; rc[4]++
      endif

      if ::lClientEdge .or. ::lBorder

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

      if ::lStaticEdge
         DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
      endif

      if ::lFlat
         DrawEdge( hDC, rc, BDR_SUNKENOUTER, nOr(BF_RECT,BF_FLAT) )
      endif

   endif
   if ::lxVScroll
      ::PaintVScroll( hDC, ::lRightVScroll,::lHScroll, ::lDownHScroll )
   endif

endif

SetBkMode(hDC, iMode)
SetTextColor( hDC, color )

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnEdit
***************************************************************************************************
local oMenu
local o := self


    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lxMultiline"   ,,o:lxMultiline    ,,{|oMenuItem|::lxMultiline     := !::lxMultiline    ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lxVScroll"     ,,o:lxVScroll      ,,{|oMenuItem|::lxVScroll       := !::lxVScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHScroll"     ,,o:lHScroll      ,,{|oMenuItem|::lHScroll       := !::lHScroll      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lRightVScroll",,o:lRightVScroll ,,{|oMenuItem|::lRightVScroll  := !::lRightVScroll ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lDownHScroll" ,,o:lDownHScroll  ,,{|oMenuItem|::lDownHScroll   := !::lDownHScroll  ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive       ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lModalFrame"  ,,o:lModalFrame   ,,{|oMenuItem|::lModalFrame    := !::lModalFrame   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lClientEdge"  ,,o:lClientEdge   ,,{|oMenuItem|::lClientEdge    := !::lClientEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lStaticEdge"  ,,o:lStaticEdge   ,,{|oMenuItem|::lStaticEdge    := !::lStaticEdge   ,::Refresh()},,,,,,,.F.,,,.F. )

   SEPARATOR


return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnEdit
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lxVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnEdit
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lxVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )


***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnEdit
***************************************************************************************************
local cRet := ""
local   cObject := ::cObjName
local   cVar    := "c" + substr( cObject, 2 )

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

   cHeader += "local " + cObject + CRLF
   cHeader += "local " + cVar + ' := "' + alltrim( ::cCaption ) + '"' + CRLF

   cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " GET "  + cObject +  ' VAR ' + cVar + " ;" + CRLF +;
        "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
        "                 OF " + cFrom + " FONT oFont" + CRLF

return cRet



***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnEdit
***************************************************************************************************
local nGroup
local o := self

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lBorder","Border","L",nGroup )
oList:AddItem( "lActive","Active", ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )
oList:AddItem( "lCanMove","Can move", ,nGroup )
oList:AddItem( "lCanSize","Can size", ,nGroup )
oList:AddItem( "lMultiline" ,"Multiline","L" ,nGroup )
oList:AddItem( "lVScroll" ,"Vertical Scrollbar","L",nGroup )
oList:AddItem( "nClrText"    ,"Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane"    ,"Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )

nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0


***************************************************************************************************
  METHOD lMultiline( lNewValue )  CLASS TDsgnEdit
***************************************************************************************************

if pcount() > 0
   ::lxMultiline := lNewValue
   ::Refresh()
endif

return ::lxMultiline


***************************************************************************************************
  METHOD lVScroll( lNewValue )  CLASS TDsgnEdit
***************************************************************************************************

if pcount() > 0
   ::lxVScroll := lNewValue
   ::Refresh()
endif

return ::lxVScroll
