#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"

#define LWICON       1
#define LWSMALLICON  2
#define LWLIST       3
#define LWREPORT     4

CLASS TDsgnTreeView FROM TShape

      DATA aProperties

      DATA lRightVScroll
      DATA lDownHScroll
      DATA lVScroll
      DATA lHasButtons
      DATA lHasLines
      DATA lHScroll
      DATA lActive
      DATA nClrText
      DATA lModalFrame
      DATA nStyle

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET
      METHOD DrawLine( hDC, nTop, nIndent )


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnTreeView
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 90
      nRight  := nLeft + 81
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lHasButtons   := .t.
   ::lHasLines     := .t.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::lActive       := .t.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lVScroll      := .f.
   ::lHScroll      := .f.
   ::lBorder       := .f.
   ::lModalFrame   := .t.
   ::nStyle        := LWREPORT //LWLIST  //LWSMALLICON  //LWICON
   ::nMinWidth     := 64
  ::cObjName         := ::GetObjName()


   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize"       ,;
                      "lCanMove"       ,;
                      "lDownHScroll"   ,;
                      "lEditable"      ,;
                      "lHScroll"       ,;
                      "lHasButtons"    ,;
                      "lHasLines"      ,;
                      "lModalFrame"    ,;
                      "lRightVScroll"  ,;
                      "lVScroll"       ,;
                      "lVisible"       ,;
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
  METHOD Paint( hDC ) CLASS TDsgnTreeView
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hBmp
local rcText
local lCabenV := .t.
local lCabenH := .t.
local nTop    := rc[1]+3
local nLeft   := rc[2]+1
local nBottom := rc[3]
local nRight  := rc[4]
local n
//local hOldFont
local hTheme

if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

   hTheme := C5_OpenThemeData(::oWnd:hWnd, "TREEVIEW")

   if hTheme != nil
      //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

      C5_DrawThemeBackground( hTheme, hDC, TVP_BRANCH, , rc )

      hBmp := LoadBitmap( GetResources(), "smyell" )


      ::DrawLine( hDC, 1, 1, hBmp )
      ::DrawLine( hDC, 2, 2, hBmp )
      ::DrawLine( hDC, 3, 3, hBmp )
      ::DrawLine( hDC, 4, 3, hBmp )
      ::DrawLine( hDC, 5, 2, hBmp )
      ::DrawLine( hDC, 6, 1, hBmp )

      DeleteObject( hBmp )


      C5_CloseThemeData()
      //SelectObject( hDC, hOldFont )

   endif

else

    //hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

    if ::lBorder
       FillSolidRect(hDC, rc, if(::lActive,CLR_WHITE,GetSysColor(COLOR_BTNFACE)), 0 )
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

    hBmp := LoadBitmap( GetResources(), "smyell" )


    ::DrawLine( hDC, 1, 1, hBmp )
    ::DrawLine( hDC, 2, 2, hBmp )
    ::DrawLine( hDC, 3, 3, hBmp )
    ::DrawLine( hDC, 4, 3, hBmp )
    ::DrawLine( hDC, 5, 2, hBmp )
    ::DrawLine( hDC, 6, 1, hBmp )

    DeleteObject( hBmp )

    //SelectObject( hDC, hOldFont )


endif

if ::lVScroll
   ::PaintVScroll( hDC, ::lRightVScroll,::lHScroll , ::lDownHScroll  )
endif

if ::lHScroll
   ::PaintHScroll( hDC, ::lDownHScroll ,::lVScroll , ::lRightVScroll )
endif

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil



***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnTreeView
***************************************************************************************************
local oMenu
local o := self


    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder          ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lVScroll"     ,,o:lVScroll      ,,{|oMenuItem|::lVScroll       := !::lVScroll         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHScroll"     ,,o:lHScroll      ,,{|oMenuItem|::lHScroll       := !::lHScroll         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lRightVScroll",,o:lRightVScroll ,,{|oMenuItem|::lRightVScroll  := !::lRightVScroll    ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lDownHScroll" ,,o:lDownHScroll  ,,{|oMenuItem|::lDownHScroll   := !::lDownHScroll     ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lModalFrame"  ,,o:lModalFrame   ,,{|oMenuItem|::lModalFrame    := !::lModalFrame      ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive          ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHasLines"    ,,o:lHasLines     ,,{|oMenuItem|::lHasLines      := !::lHasLines        ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lHasButtons"  ,,o:lHasButtons   ,,{|oMenuItem|::lHasButtons    := !::lHasButtons      ,::Refresh()},,,,,,,.F.,,,.F. )

   SEPARATOR


return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnTreeView
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnTreeView
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )


***************************************************************************************************
  METHOD DrawLine( hDC, nItem, nIndent, hBmp ) CLASS TDsgnTreeView
***************************************************************************************************
local nHItem  := 18
local nTop    := ::nTop + 2 + (nItem-1)*nHitem
local nLeft   := ::nLeft + 1
local aText   := {"Expanded node", "Expanded node", "Leaf","Leaf","Collapsed Node","Leaf"}
local cText
local hBmp2
local aLines := {"lines1","lines2","lines3","lines4","lines5"}
local hTheme := nil
local lThemes := lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()


   if nTop + nHItem > ::nBottom
      return nil
   endif



   if ::lHasLines
      if nItem <= len( aLines )
         hBmp2 := LoadBitmap( GetResources(),aLines[nItem] )
         DrawMasked( hDC, hBmp2, nTop, nLeft )
         DeleteObject( hBmp2 )
         if lThemes
            hTheme := C5_OpenThemeData(::oWnd:hWnd, "TREEVIEW")
            if nItem == 2
               rc := {nTop+5,nLeft+4,nTop+9+5,nLeft+4+9}
               C5_DrawThemeBackground( hTheme, hDC, TVP_GLYPH,GLPS_OPENED , rc )
            else
               if nItem == 5
                  rc := {nTop+5,nLeft+4,nTop+5+9,nLeft+4+9}
                  C5_DrawThemeBackground( hTheme, hDC, TVP_GLYPH,GLPS_CLOSED , rc )
               endif
            endif
            C5_CloseThemeData()
         endif
      endif
   endif
   nLeft   := ::nLeft + 1 + (nIndent-1)*19

   if lThemes
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "BUTTON")
   endif

   if ::lHasButtons
      rc := {nTop+3,nLeft+2,nTop+16,nLeft+13}
      if lThemes
         if hTheme != nil
            C5_DrawThemeBackground( hTheme, hDC, BP_CHECKBOX,CBS_UNCHECKEDNORMAL , rc )
         endif
      else
         DrawFrameControl(hDC, rc, DFC_BUTTON, nOr( DFCS_BUTTONCHECK,DFCS_FLAT))
      endif
      nLeft += 16
   endif

   if nItem <= len( aText )
      cText := aText[nItem]
      DrawText( hDC, cText,{nTop,nLeft+22,nTop+nHItem,::nRight-2},nOr( DT_SINGLELINE, DT_VCENTER) )
   endif
   DrawMasked( hDC, hBmp, nTop, nLeft )

  if lThemes
     C5_CloseThemeData()
  endif


return nil
