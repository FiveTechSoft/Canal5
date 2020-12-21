#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"

#define LWICON       0
#define LWREPORT     1
#define LWSMALLICON  2
#define LWLIST       3



CLASS TDsgnBrowse FROM TShape

      DATA aProperties


      DATA lFlat
      DATA lVScroll
      DATA lHScroll
      DATA lActive
      DATA nClrText
      DATA nClrPaneHdr
      DATA nClrTextHdr
      DATA lModalFrame
      DATA cDbf

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD nMinWidth( nVal ) SETGET
      METHOD nMinHeight( nVal ) SETGET
      METHOD Edit() VIRTUAL
      METHOD SetProps( oList )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnBrowse
************************************************************************************************

   if nTop != nil .and. ( nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 90
      nRight  := nLeft + 81
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::nClrPaneHdr   := rgb(222,207,198)
   ::nClrTextHdr   := 0
   ::lActive       := .t.
   ::lVScroll      := .t.
   ::lHScroll      := .t.
   ::lBorder       := .t.
   ::lBold         := .f.
   ::lModalFrame   := .f.
   ::nMinWidth     := 90
   ::nMinHeight    := 81

   ::cCaption     := ""
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

  ::aPropertiesPPC := { "cCaption"      ,;
                        "lBorder"       ,;
                        "nID"           ,;
                        "nTop"          ,;
                        "nLeft"         ,;
                        "nWidth"        ,;
                        "nHeight"       ,; // "nClrPaneHdr"   ,; "nClrTextHdr"   ,;
                        "nClrPane"      ,;
                        "nClrText"      ,;
                        "lVScroll"      ,;
                        "lHScroll"      }// "cFaceName",; "nWidthFont",;"nHeightFont",;"lBold",; "lItalic",; "lUnderline" ,; "lStrikeOut"    }



   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lHScroll"       ,;
                      "lVScroll"       ,;
                      "lVisible"       ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
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
  METHOD Paint( hDC ) CLASS TDsgnBrowse
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local nColor
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

    nColor := SetTextColor( hDC, ::nClrText )

    iMode := SetBkMode(hDC,TRANSPARENT)

    if ::lBorder
       if lThemes
          hTheme := C5_OpenThemeData(::oWnd:hWnd, "LISTVIEW")
          C5_DrawThemeBackground( hTheme, hDC, LVP_LISTITEM,LIS_NORMAL, rc )
          C5_CloseThemeData()
       else
          FillSolidRect(hDC, rc, if(::lActive,::nClrPane,GetSysColor(COLOR_BTNFACE)), 0 )
       endif
    else
       FillSolidRect(hDC, rc, if(::lActive,::nClrPane,GetSysColor(COLOR_BTNFACE)))
    endif

    rcText := {rc[1],rc[2],rc[3],rc[4]}

    if ::lModalFrame
       rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
       DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
       rc[1]++; rc[2]++; rc[3]--; rc[4]--
       DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
       rc[1]--; rc[2]--; rc[3]++; rc[4]++
    endif

   for n := 0 to 10

       nHItem := 15
       nWItem := ::nWidth

       nTop    := ::nTop  + ((n-1) * nHItem ) + 19
       nLeft   := ::nLeft + 1
       nRight  := nLeft   + nWItem
       nBottom := nTop    + nHItem

       if nBottom  > ::nBottom
          lCabenV := .f.
          Moveto( hDC, nLeft, nBottom - if( ::lHScroll,16,0) )
          Lineto( hDC, nRight - if( ::lVScroll,16,0), nBottom - if( ::lHScroll,16,0) )
          exit
       endif

       if nRight -20 > ::nRight
          lCabenH := .f.
       endif

       rc := { ::nTop+1, ::nLeft+1,::nTop+ 17,::nRight-1- if( !lCabenV,20,0) }

       if n == 0
          if ::oWnd:lPocketPc()

                rc := { ::nTop+1, ::nLeft+1,::nTop+ 17,::nLeft + 1 + 55 }
                DrawFrameControl( hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )
                rc := { ::nTop+2, ::nLeft+2,::nTop+ 15,::nLeft + 1 + 54 }
                FillSolidRect( hDC, rc, ::nClrPaneHdr )

                rc := { ::nTop+1, ::nLeft+1+1+54,::nTop+ 17,::nRight- if( !lCabenV,22,0) }
                DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )
                rc := { ::nTop+2, ::nLeft+1+1+55,::nTop+ 15,::nRight- if( !lCabenV,22,0) }
                FillSolidRect( hDC, rc, ::nClrPaneHdr )

          else

             if lThemes
                hTheme := C5_OpenThemeData(::oWnd:hWnd, "HEADER")
                rc := { ::nTop+2, ::nLeft+2,::nTop+ nHItem,::nLeft + 2 + 55 }
                C5_DrawThemeBackground( hTheme, hDC, HP_HEADERITEMLEFT, HILS_NORMAL, rc )
                rc := { ::nTop+2, ::nLeft+2+55+1 ,::nTop+nHItem,::nRight- if( !lCabenV,22,2) }
                C5_DrawThemeBackground( hTheme, hDC, HP_HEADERITEMLEFT, HILS_NORMAL, rc )
                C5_CloseThemeData()
             else
                FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE) )

                rc := { ::nTop+1, ::nLeft+1,::nTop+ 17,::nLeft + 1 + 55 }
                DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )

                rc := { ::nTop+1, ::nLeft+1+1+55,::nTop+ 17,::nRight- if( !lCabenV,20,0) }
                DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )

             endif

          endif

          DrawText( hDC, "STATE", { ::nTop+1, ::nLeft+5,::nTop+ 17,::nLeft + 1 + 55 }, nOr( DT_VCENTER, DT_SINGLELINE ) )
          DrawText( hDC, "ZIP", { ::nTop+1, ::nLeft+55+5,::nTop+ 17,::nRight      }, nOr( DT_VCENTER, DT_SINGLELINE ) )
          loop

       endif

       iMode := SetBkMode( hDC, TRANSPARENT )

       SetBkMode( hDC, iMode )

       if !lCabenV .or. !lCabenH
          DeleteObject( hBmp )
          exit
       endif

       if n == 4
          nColor := SetTextColor( hDC, CLR_WHITE )
          FillSolidRect( hDC, { nTop, nLeft, nTop + nHItem, nRight- if( ::lVScroll,16,0) }, CLR_BLUE )
       endif

       DrawText( hDC, {"NJ","FL","TN","NC","OR","KS","UT","NV","IL","KY"}[n], ;
               { nTop, nLeft+3, nTop + nHItem, nRight- if( ::lVScroll,16,0) }, nOr( DT_VCENTER, DT_SINGLELINE ) )

       DrawText( hDC, {"43426-5384",;
                       "15211-0627",;
                       "68437-1691",;
                       "14203-9055",;
                       "39961-7346",;
                       "02449-8932",;
                       "45082-2681",;
                       "34093-6640",;
                       "78184-7519",;
                       "80515-8016"}[n], ;
               { nTop, nLeft+56+3, nTop + nHItem, nRight- if( ::lVScroll,16,0) }, nOr( DT_VCENTER, DT_SINGLELINE ) )
       if n == 4
          SetTextColor( hDC, nColor )
       endif

       FillSolidRect( hDC, { nBottom - if( ::lHScroll,16,0) + nHItem ,nLeft,;
                   nBottom - if( ::lHScroll,16,0) + nHItem+1 ,nRight - if( ::lVScroll,16,0)}, CLR_HGRAY )

       //Moveto( hDC, nLeft, nBottom - if( ::lHScroll,16,0) + nHItem )
       //Lineto( hDC, nRight - if( ::lVScroll,16,0), nBottom - if( ::lHScroll,16,0)+ nHItem )

       DeleteObject( hBmp )

   next
   rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

   FillSolidRect( hDC, { rc[1],::nLeft+55, rc[3]- if( ::lHScroll,14,0), ::nLeft+55+1}, CLR_HGRAY )


//   SelectObject( hDC, hOldFont )
   SetTextColor( hDC, nColor )

   //if oFontPPC != nil
   //   oFontPPC:End()
   //endif
//   oFont:End()

   if ::lVScroll
      ::PaintVScroll( hDC, .t.,::lHScroll, ::lHScroll  )
   endif

   if ::lHScroll
      ::PaintHScroll( hDC, .t. ,::lVScroll, ::lVScroll )
   endif


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil



***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnBrowse
***************************************************************************************************
local oMenu
local o := self


return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnBrowse
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return if( ::lHScroll .or. ::lVScroll, max( 22, ::xMinWidth ), ::xMinWidth )

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TDsgnBrowse
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return if( ::lVScroll .or. ::lHScroll , max( 22, ::xMinHeight ), ::xMinHeight )



***************************************************************************************************
   METHOD SetProps( oList )  CLASS TDsgnBrowse
***************************************************************************************************
local nGroup
local o := self

nGroup := oList:AddGroup( "Appearence" )




oList:AddItem( "cObjName","Name", ,nGroup )
oList:AddItem( "lActive","Active","L" ,nGroup )
oList:AddItem( "cDbf","Dbf", "B",nGroup,,,{|| cGetFile( "DBFs (*.dbf ) | *.dbf |", "Selecciona dbf" )} )
oList:AddItem( "lCanMove","Can move", "L",nGroup )
oList:AddItem( "lCanSize","Can size", "L",nGroup )
oList:AddItem( "lHScroll","Horizontal scrollbar", "L",nGroup )
oList:AddItem( "lVScroll","Vertical scrollbar", "L",nGroup )
oList:AddItem( "nClrText","Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane","Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )
oList:AddItem( "nClrTextHdr","Header Text Color", "B",nGroup,,,{|| ChooseColor( o:nClrTextHdr )} )
oList:AddItem( "nClrPaneHdr","Header Back Color", "B",nGroup,,,{|| ChooseColor( o:nClrPaneHdr )} )


nGroup := oList:AddGroup(  "Position" )

oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0










