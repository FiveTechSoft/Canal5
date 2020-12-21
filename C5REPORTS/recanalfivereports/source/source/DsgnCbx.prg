#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnCbx FROM TShape

      DATA lFlat
      DATA lRightVScroll
      DATA lDownHScroll
      DATA lVScroll
      DATA lHScroll
      DATA nAlign
      DATA lActive
      DATA nClrText
      DATA lModalFrame
      DATA nTipo
      DATA aList

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD ShapeOver( nRow, nCol )
      METHOD IntersectRect( aRect )
      METHOD PaintContour( hDC )
      METHOD Inspect( cDataName )
      METHOD GenPrg( lDialog, cFrom, cHeader )
      METHOD SetProps( oList )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnCbx
************************************************************************************************

   if nTop != nil .and. ( nBottom-nTop < 10 .or. nRight-nLeft < 10 )
      nBottom := nTop + 21
      nRight  := nLeft + 82
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := 0
   ::nClrBorder    := 0
   ::nClrPane      := CLR_WHITE
   ::nAlign        := nOr(DT_SINGLELINE,DT_VCENTER)
   ::lActive       := .t.
   ::lRightVScroll := .t.
   ::lDownHScroll  := .t.
   ::lVScroll      := .t.
   ::lHScroll      := .f.
   ::lBorder       := .t.
   ::lModalFrame   := .f.
   ::nMinHeight    := 21
   ::cCaption      := "ComboBox"
   ::bContextMenu  := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
   ::aList         := {""}
  ::cObjName         := ::GetObjName()

  ::aPropertiesPPC := { "nTipo"      ,;
                        "nID"            ,;
                        "nTop"           ,;
                        "nLeft"          ,;
                        "nWidth"         ,;
                        "nHeight"        }

  ::aProperties :=  { "aDotsActives"   ,;
                      "aList"          ,;
                      "aRect"          ,;
                      "cCaption"       ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lDownHScroll"   ,;
                      "lEditable"      ,;
                      "lHScroll"       ,;
                      "lRightVScroll"  ,;
                      "lVScroll"       ,;
                      "lVisible"       ,;
                      "nClrBorder"     ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nOption"        ,;
                      "nTipo"          ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }


   ::nTipo         := "DropDown"

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif


return self

*************************************************************************************************
  METHOD PaintContour( hDC ) CLASS TDsgnCbx
*************************************************************************************************
local hPen := ExtCreatePen( 2, 0 )
local hOldPen := SelectObject( hDC, hPen )

Moveto( hDC, ::nLeft,  ::nTop )
Lineto( hDC, ::nRight, ::nTop )
Lineto( hDC, ::nRight, ::nTop + 21 )
Lineto( hDC, ::nLeft,  ::nTop + 21 )
Lineto( hDC, ::nLeft,  ::nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )


return nil

*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnCbx
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2
local rcText
local iMode
local color
local nTop, nLeft, nBottom, nRight
local hTheme, nState
local hBmp

local hFont, hOldFont, oFontPPC

if ::oWnd:lPocketPc()

   rc := {::aRect[1],::aRect[2],::aRect[1]+22,::aRect[4]}

   FillSolidRect( hDC, rc, ::nClrPane, 0 )

   hBmp     := LoadBitmap( GetResources(), "arrow" )
   DrawMasked( hDC, hBmp, rc[1]+8, rc[4]-13 )
   DeleteObject( hBmp )

//   DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12

//   hOldFont := SelectObject( hDC, oFontPPC:hFont )

   SetBkMode( hDC, TRANSPARENT )
   color := SetTextColor( hDC, ::nClrText )

   rc[2] += 3
   rc[4] -= 13
   DrawText( hDC, ::cCaption, rc, ::nAlign )

   if ::nTipo == "Simple"
      rc := {::aRect[1]+22,::aRect[2],::aRect[3],::aRect[4]}
      FillSolidRect( hDC, rc, ::nClrPane, 0 )
   endif




//   SelectObject( hDC, hOldFont  )
   SetTextColor(hDC, color)
//   oFontPPC:End()



else


   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()


      hTheme := C5_OpenThemeData(::oWnd:hWnd, "EDIT")
      if hTheme != nil
//         hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
         nState := if(::lActive, ETS_NORMAL, ETS_DISABLED)
         rc := {::aRect[1],::aRect[2],::aRect[1]+22,::aRect[4]}
         C5_DrawThemeBackground( hTheme, hDC, EP_EDITTEXT, nState , rc )
         if ::nTipo == "Simple"
            rc := {::aRect[1]+22,::aRect[2],::aRect[3],::aRect[4]}
            C5_DrawThemeBackground( hTheme, hDC, EP_EDITTEXT, nState , rc )
         endif
         rc := {::aRect[1],::aRect[2],::aRect[1]+22,::aRect[4]}
         rc[2] += 3
         C5_DrawThemeText( hTheme, hDC, EP_EDITTEXT, nState, ::cCaption, nOr( DT_VCENTER, DT_SINGLELINE ), nil, rc )
         C5_CloseThemeData()
//         SelectObject( hDC, hOldFont )

      endif

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "COMBOBOX")

      if ::nTipo != "Simple"
         if hTheme != nil
            rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
            nState := if(::lActive, CBXS_NORMAL, CBXS_DISABLED)
            rc[1] += 2
            rc[3] := rc[1] +18
            rc[4] -= 2
            rc[2] := rc[4]-15
            C5_DrawThemeBackground( hTheme, hDC, CP_DROPDOWNBUTTON, nState , rc )
            C5_CloseThemeData()

         endif
      endif

   else


//      hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

       iMode := SetBkMode(hDC,TRANSPARENT)
       if ::nTipo != "Simple"
          rc[3] := rc[1] + 21
       endif

       FillSolidRect(hDC, rc, if(::lActive,CLR_WHITE,GetSysColor(COLOR_BTNFACE)) )

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

               rc := {::aRect[1],::aRect[2],::aRect[1]+ 21,::aRect[4]}

               if ::lModalFrame
                  rc[1]++; rc[2]++; rc[3]--; rc[4]--
               endif

               DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
               rc[1]++; rc[2]++; rc[3]--; rc[4]--
               DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
               rc[1]--; rc[2]--; rc[3]++; rc[4]++

               if ::nTipo == "Simple"
                  rc := {::aRect[1]+21,::aRect[2],::aRect[3],::aRect[4]}

                  DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
                  rc[1]++; rc[2]++; rc[3]--; rc[4]--
                  DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
                  rc[1]--; rc[2]--; rc[3]++; rc[4]++

               endif

               if ::lModalFrame
                  rc := {::aRect[1],::aRect[2],::aRect[1]+ 21,::aRect[4]}
                  rc[1]-=2; rc[2]-=2; rc[3]+=2; rc[4]+=2
               endif
       endif
       nTop    := rc[1]+2
       nLeft   := rc[4]-19
       nBottom := rc[3]-2
       nRight  := rc[4]-2

       if ::nTipo != "Simple"
          DrawFrameControl(hDC, { nTop  ,;
                               nLeft   ,;
                               nBottom     ,;
                               nRight        }, DFC_SCROLL, DFCS_SCROLLDOWN)
       endif
   endif

endif

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil

*************************************************************************************************
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnCbx
*************************************************************************************************
local rc

 if ::nTipo == "Simple"
    rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
 else
    rc := {::aRect[1],::aRect[2],::aRect[1]+21,::aRect[4]}
 endif

 if PtInRect( nRow, nCol, rc )
    return self
 endif

 return nil




***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnCbx
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive       ,::Refresh()},,,,,,,.F.,,,.F. )
    MENUITEM "Tipo"
    MENU
       MenuAddItem("Simple"      ,,o:nTipo == "Simple"      ,,{|oMenuItem|::nTipo         := "Simple"         ,::Refresh()},,,,,,,.F.,,,.F. )
       MenuAddItem("DropDown"    ,,o:nTipo == "DropDown"    ,,{|oMenuItem|::nTipo         := "DropDown"       ,::Refresh()},,,,,,,.F.,,,.F. )
       MenuAddItem("DropDownList",,o:nTipo == "DropDownList",,{|oMenuItem|::nTipo         := "DropDownList"   ,::Refresh()},,,,,,,.F.,,,.F. )

    ENDMENU

   SEPARATOR


return nil


***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TDsgnCbx
***************************************************************************************************
local lIntersect := .f.
local rc

if ::nTipo == "Simple"
   rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
else
   rc := {::aRect[1],::aRect[2],::aRect[1]+21,::aRect[4]}
endif

if IntersectRect( aRect, rc )
   lIntersect := .t.
endif

return lInterSect

**********************************************************************************
  METHOD Inspect( cDataName ) CLASS TDsgnCbx
**********************************************************************************

local o := self

   do case
      case cDataName == "nTipo"
           return { "DropDown","DropDownList","Simple" }
   endcase

return nil


***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnCbx
***************************************************************************************************
local cRet := ""
local cObject
local cVar
local cAItems


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


        cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " COMBOBOX " + cObject + ' VAR ' + cVar + " ITEMS " + caItems + " ;" + CRLF +;
             "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
             "                 OF " + cFrom  + CRLF

return cRet

***************************************************************************************************
   METHOD SetProps( oList ) CLASS TDsgnCbx
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



***********************************************************************************************
  function InspectArray( o, aName )
***********************************************************************************************
local c := ""
local nLines
local n
local aList := OSend( o, aName )

for n := 1 to len( aList )
    c += aList[n] + CRLF
next

MemoEdit2( @c, "Escriba un elemento por línea")

nLines := mlcount(c)
if nLines == 0
   return {}
endif

aList := {}

for n := 1 to nLines
    aadd( aList, rtrim(memoline(c,,n)))
next

oSend( o, "_" + aName,  aList )

return aList
