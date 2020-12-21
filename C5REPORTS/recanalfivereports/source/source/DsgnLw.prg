#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"

#define LWICON       0
#define LWREPORT     1
#define LWSMALLICON  2
#define LWLIST       3



CLASS TDsgnListView FROM TShape

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
      DATA nStyle

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnListView
************************************************************************************************

   if nTop != nil .and. ( nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 90
      nRight  := nLeft + 81
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::nAlign        := nOr(DT_SINGLELINE,DT_VCENTER,DT_CENTER)
   ::lActive       := .t.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lVScroll      := .t.
   ::lHScroll      := .t.
   ::lBorder       := .t.
   ::lModalFrame   := .f.
   ::nStyle        := LWREPORT //LWLIST  //LWSMALLICON  //LWICON
  ::cObjName         := ::GetObjName()

   ::cCaption     := "ListView"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lDownHScroll"   ,;
                      "lEditable"      ,;
                      "lHScroll"       ,;
                      "lModalFrame"    ,;
                      "lRightVScroll"  ,;
                      "lVScroll"       ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nStyle"         ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif



return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnListView
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color
local hOldFont
local nHItem
local nWItem
local nTop := 0
local nLeft := 0
local nBottom := 0
local nRight := 0
local hBmp, nWBmp
local lCabenV := .t.
local lCabenH := .t.
local n
local nCol   := 0
local nCount := 0
local lTheme
local hTheme
local lThemes := lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

    //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

    iMode := SetBkMode(hDC,TRANSPARENT)


    if lThemes

    endif



    if ::lBorder
       if lThemes
          hTheme := C5_OpenThemeData(::oWnd:hWnd, "LISTVIEW")
          C5_DrawThemeBackground( hTheme, hDC, LVP_LISTITEM,LIS_NORMAL, rc )
          C5_CloseThemeData()
       else
          FillSolidRect(hDC, rc, if(::lActive,CLR_WHITE,GetSysColor(COLOR_BTNFACE)), 0 )
       endif
    else
       FillSolidRect(hDC, rc, if(::lActive,CLR_WHITE,GetSysColor(COLOR_BTNFACE)))
    endif

    rcText := {rc[1],rc[2],rc[3],rc[4]}

    if ::lModalFrame
       rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
       DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
       rc[1]++; rc[2]++; rc[3]--; rc[4]--
       DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
       rc[1]--; rc[2]--; rc[3]++; rc[4]++
    endif

   for n := 1 to 6


       do case
          case ::nStyle == LWICON

               hBmp := LoadBitmap( GetResources(), {"Yellow","Red","Green","Magenta","Cyan","Blue"}[n] )

               nHItem := 50
               nWItem := 75

               nLeft   := ::nLeft + (( n-1 ) * nWItem )
               nRight  := nLeft + nWItem
               nTop    := ::nTop + 5
               nBottom := nTop + nHItem

               if nRight - 20 > ::nRight
                  lCabenH := .f.
               endif

               if nBottom  > ::nBottom - 20
                  lCabenV := .f.
               endif

               if !lCabenV .or. !lCabenH
                  DeleteObject( hBmp )
                  exit
               endif

               nLeft   := ::nLeft + ( n - 1 ) * nWItem +  nWitem /2 - nBmpWidth( hBmp ) / 2
               nRight  := nLeft + nWItem
               nTop    := ::nTop + 5
               nBottom := nTop + nHItem

               DrawMasked( hDC, hBmp, nTop, nLeft )
               DeleteObject( hBmp )
               DrawText( hDC, {"Yellow","Red","Green","Magenta","Cyan","Blue"}[n], ;
                       { nBottom - 15, ::nLeft + ( n-1 )*nWItem, nBottom, ::nLeft +  n*nWItem }, nOr( DT_VCENTER, DT_CENTER ) )

          case ::nStyle == LWSMALLICON .or. ::nStyle == LWREPORT


               hBmp := LoadBitmap( GetResources(), {"smyell","smred","smgreen","smmagen","smcyan","smblue"}[n] )

               nHItem := 21
               nWItem := ::nWidth

               nTop    := ::nTop  + ((n-1) * nHItem ) + if( ::nStyle == LWREPORT, 19,0)
               nLeft   := ::nLeft + 1
               nRight  := nLeft   + nWItem
               nBottom := nTop    + nHItem

               if nBottom  > ::nBottom
                  lCabenV := .f.
               endif

               if nRight -20 > ::nRight
                  lCabenH := .f.
               endif

               if ::nStyle == LWREPORT .and. n == 6

                  rc := { ::nTop+1, ::nLeft+1,::nTop+ 17,::nRight-1- if( !lCabenV,20,0) }

                  if lThemes
                     hTheme := C5_OpenThemeData(::oWnd:hWnd, "HEADER")
                     rc := { ::nTop+2, ::nLeft+2,::nTop+ nHItem,::nLeft + 2 + 80 }
                     C5_DrawThemeBackground( hTheme, hDC, HP_HEADERITEMLEFT, HILS_NORMAL, rc )
                     rc := { ::nTop+2, ::nLeft+2+80+1 ,::nTop+nHItem,::nRight- if( !lCabenV,22,2) }
                     C5_DrawThemeBackground( hTheme, hDC, HP_HEADERITEMLEFT, HILS_NORMAL, rc )
                     C5_CloseThemeData()
                  else
                     FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE) )

                     rc := { ::nTop+1, ::nLeft+1,::nTop+ 17,::nLeft + 1 + 80 }
                     DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )

                     rc := { ::nTop+1, ::nLeft+1+1+80,::nTop+ 17,::nRight- if( !lCabenV,20,0) }
                     DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )

                  endif
                  iMode := SetBkMode( hDC, TRANSPARENT )

                  DrawText( hDC, "Colores", { ::nTop+1, ::nLeft+5,::nTop+ 17,::nLeft + 1 + 80 }, nOr( DT_VCENTER, DT_SINGLELINE ) )

                  SetBkMode( hDC, iMode )

               endif

               if !lCabenV .or. !lCabenH
                  DeleteObject( hBmp )
                  exit
               endif

               DrawMasked( hDC, hBmp, nTop+1, nLeft )
               DrawText( hDC, {"Yellow","Red","Green","Magenta","Cyan","Blue"}[n], ;
                       { nTop, nLeft + 20, nTop + nHItem, nRight-20 }, nOr( DT_VCENTER, DT_SINGLELINE ) )
               DeleteObject( hBmp )

          case ::nStyle == LWLIST

               hBmp := LoadBitmap( GetResources(), {"smyell","smred","smgreen","smmagen","smcyan","smblue"}[n] )

               nHItem := 17
               nWItem := 100

               if nTop + nHItem + 20 > ::nBottom
                  nCol := nCol + 1
                  nCount := 0
               endif
               nCount++

               nTop    := ::nTop  + ((nCount-1)*nHItem )
               nLeft   := ::nLeft + (nCol*nWItem)+1
               nBottom := nTop    + nHItem
               nRight  := nLeft   + nWItem

               if nBottom  > ::nBottom
                  lCabenV := .f.
               endif

               if nRight -20 > ::nRight
                  DeleteObject( hBmp )
                  lCabenH := .f.
                  exit
               endif

               DrawMasked( hDC, hBmp, nTop+1, nLeft )
               DrawText( hDC, {"Yellow","Red","Green","Magenta","Cyan","Blue"}[n], ;
                       { nTop, nLeft + 20, nTop + nHItem, nRight-20 }, nOr( DT_VCENTER, DT_SINGLELINE ) )
               DeleteObject( hBmp )

       endcase

   next


    //SelectObject( hDC, hOldFont )

    if ::lVScroll .and. !lCabenV
       ::PaintVScroll( hDC, ::lRightVScroll,::lHScroll .and. !lCabenH, ::lDownHScroll  )
    endif

    if ::lHScroll .and. !lCabenH
       ::PaintHScroll( hDC, ::lDownHScroll ,::lVScroll .and. !lCabenV, ::lRightVScroll )
    endif


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil



***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnListView
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat            ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder          ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lVScroll"     ,,o:lVScroll      ,,{|oMenuItem|::lVScroll       := !::lVScroll         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHScroll"     ,,o:lHScroll      ,,{|oMenuItem|::lHScroll       := !::lHScroll         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lRightVScroll",,o:lRightVScroll ,,{|oMenuItem|::lRightVScroll  := !::lRightVScroll    ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lDownHScroll" ,,o:lDownHScroll  ,,{|oMenuItem|::lDownHScroll   := !::lDownHScroll     ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lModalFrame"  ,,o:lModalFrame   ,,{|oMenuItem|::lModalFrame    := !::lModalFrame      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive          ,::Refresh()},,,,,,,.F.,,,.F. )
    MENUITEM "Estilo"
    MENU
    MenuAddItem("Icon"         ,,                ,,{|oMenuItem|::nStyle         :=  LWICON      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("Small Icon"   ,,                ,,{|oMenuItem|::nStyle         :=  LWSMALLICON ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("List"         ,,                ,,{|oMenuItem|::nStyle         :=  LWLIST      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("Report"       ,,                ,,{|oMenuItem|::nStyle         :=  LWREPORT    ,::Refresh()},,,,,,,.F.,,,.F. )
    ENDMENU

   SEPARATOR


return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnListView
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnListView
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )




