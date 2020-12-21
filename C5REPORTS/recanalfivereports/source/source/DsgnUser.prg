#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnUser FROM TShape

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
      DATA cStyle
      DATA cClassName


      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnUser
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 65
      nRight  := nLeft + 72
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::cClassName    := ""
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_HGRAY
   ::lActive       := .t.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lVScroll      := .f.
   ::lHScroll      := .f.
   ::lBorder       := .t.
   ::lModalFrame   := .f.
   ::cStyle        := "WS_CHILD | WS_VISIBLE | WS_BORDER | WS_TABSTOP"
  ::cObjName         := ::GetObjName()

   ::cCaption     := ""
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

  ::aPropertiesPPC := { "cCaption"      ,;
                        "cClassName"    ,;
                        "cStyle"        ,;
                        "lBorder"       ,;
                        "lHScroll"      ,;
                        "lVScroll"      ,;
                        "nID"           ,;
                        "nTop"          ,;
                        "nLeft"         ,;
                        "nWidth"        ,;
                        "nHeight"       ,;
                        "nClrPane"      ,;
                        "nClrText"      }

   ::aProperties := { "cCaption"       ,;
                      "cClassName"     ,;
                      "cStyle"         ,;
                      "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize"       ,;
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
  METHOD Paint( hDC ) CLASS TDsgnUser
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color
local hTheme, nState
//local hOldFont, oFontPPC


if ::oWnd:lPocketPc()

   FillSolidRect( hDC, rc, ::nClrPane, if(::lBorder,0,nil) )

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

         if ::lBorder
            rc[1]++; rc[2]++; rc[3]--; rc[4]--
         endif

         FillSolidRect(hDC, rc, ::nClrPane )

         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
         rc[2] += 3
         C5_DrawThemeText( hTheme, hDC, LVP_LISTITEM, nState, ::cCaption, nOr( DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()
         //SelectObject( hDC, hOldFont )

      endif

   else



       //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

       iMode := SetBkMode(hDC,TRANSPARENT)
       FillSolidRect(hDC, rc, ::nClrPane )

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
       SetBkMode(hDC,iMode)

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


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil






***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnUser
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
  METHOD nMinWidth( nVal ) CLASS TDsgnUser
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnUser
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )



