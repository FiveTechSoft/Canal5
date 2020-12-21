#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#include "uxtheme_tmt.ch"
#define SRCCOPY 13369376
static hOldTheme

CLASS TDsgnBar FROM TShape

      DATA nSide
      DATA hTheme
      DATA hBmp
      DATA lTemas
      DATA l3D
      DATA lImages
      DATA lText

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nTipo ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD AddItem( cText, cFileName, lSeparator )
      METHOD KeyDown( nKey, nFlags )
      METHOD Destroy()
      METHOD MakeBar()
      METHOD ResizeItems()
      METHOD GoPrev()
      METHOD GoNext()
      METHOD DrawChevron( hDC )
      METHOD DeleteChild( o )
      METHOD ShapeOver( nRow, nCol )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nSide ) CLASS TDsgnBar
************************************************************************************************

local o := self
local aClient := {0,0,0,0}

DEFAULT nSide := TOPBAR

   if oWnd != nil
      aClient := oWnd:oForm:GetClientRect()
   endif

   do case
      case nSide == TOPBAR
           nTop    := aClient[1]
           nLeft   := aClient[2]
           nBottom := nTop + 40 //28
           nRight  := aClient[4]
   endcase

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lBorder        := .t.
   ::lCanMove       := .f.
   ::lCanSize       := .f.
   ::l3D            := .t.
   ::aDotsActives   := {0,0,0,0,0,0,0,0}
   ::nSide          := nSide
   ::hBmp           := 0
   ::lContainer     := .t.
   ::lTemas         := lTemas() .and. !::oWnd:lPocketPc()
   ::lImages        := .t.
   ::lText          := .t.
   ::nClrBorder     := 0
   ::nClrPane       := GetSysColor( COLOR_BTNFACE )
   ::aShapes         := {}
   ::bContextMenu   := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
   ::aProperties    := {""}
  ::cObjName         := ::GetObjName()

   if ::oWnd != nil
      ::oWnd:oForm:oBar := self
   endif

   ::bKeyChar := {|nKey,nFlags| o:KeyDown( nKey, nFlags ) }

   ::aProperties := { "lImages"        ,;
                      "lText"          ,;
                      "nSide"          }

  ::aProperties :=  { "aDotsActives"   ,;
                      "aRect"          ,;
                      "aShapes"        ,;
                      "lBorder"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lVisible"       ,;
                      "lImages"        ,;
                      "lText"          ,;
                      "nSide"          ,;
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
  METHOD AddItem( cText, cFileName, lSeparator, lPopup ) CLASS TDsgnBar
*************************************************************************************************
local oItem
local nLen := len( ::aShapes )
local nTop, nLeft, nBottom, nRight

DEFAULT cText := ""
DEFAULT cFileName := "bmps\bitmap.bmp"
DEFAULT lSeparator := .f.
DEFAULT lPopup := .f.

if nLen == 0
   nTop    := ::nTop  + 2
   nLeft   := ::nLeft + 10
   nBottom := ::nBottom - 2 //4
else
   nTop    := ::aShapes[nLen]:nTop
   nLeft   := ::aShapes[nLen]:nRight+1
   nBottom := ::aShapes[nLen]:nBottom
endif

nRight  := nLeft + if( lSeparator, 8, (::nHeight/2)*3 )

if lPopup
   nRight += 6 //14
endif


oItem := TItemBar():New( nTop, nLeft, nBottom, nRight, ::oWnd, self, , cFileName, lSeparator )

aadd( ::aShapes, oItem )

return nil



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnBar
*************************************************************************************************
local rc, n
local aClient := ::aRect
local oShape
local hDCMem, hOldBmp
local hTheme, color
local nRight
local lChangeTheme := .t.
local nTop, nLeft, nBottom
local oBtn

if ::hBmp == 0
   for each oBtn in ::aShapes
       oBtn:oWnd := ::oWnd
       oBtn:oParent := self
   next
endif

do case
   case ::nSide == TOPBAR
        nTop    := aClient[1]
        nLeft   := aClient[2]
        nBottom := nTop + 30 //28
        nRight  := aClient[4]
        ::aRect := {nTop, nLeft, nBottom, nRight}
endcase

/*
if lTemas() .and. !::oWnd:lPocketPc  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
   hTheme := C5_OpenThemeData(::oWnd:hWnd, "REBAR" )
   if hTheme != hOldTheme
      lChangeTheme := .t.
   endif
   C5_CloseThemeData()
endif
*/
if ::lTemas != lTemas() .and. !::oWnd:lPocketPc()  //.or. lChangeTheme
   ::ResizeItems()
   ::MakeBar()
   ::lTemas := lTemas() .and. !::oWnd:lPocketPc()
endif

if ::hBmp == 0

   hDCMem  := CreateCompatibleDC( ::oWnd:hDC )
   ::hBmp  := CreateCompatibleBitmap( ::oWnd:hDC, 1300, ::nHeight )
   hOldBmp := SelectObject( hDCMem, ::hBmp )

   do case
      case ::nSide == TOPBAR
           ::nRight := aClient[4]
      case ::nSide == LEFTBAR
           ::nBottom := aClient[3]
      case ::nSide == RIGHTBAR
           ::nLeft := aClient[4]-::nWidth
           ::nBottom := aClient[3]
      case ::nSide == DOWNBAR
           ::nTop := aClient[3]-::nHeight
   endcase


   //rc := {::nTop, ::nLeft, ::nBottom, ::nRight}
   rc := {0, 0, ::nHeight, 1300}

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "REBAR" )
      if hTheme != nil
         hOldTheme := hTheme
         color := GetThemeColor( hTheme, RP_BAND, nil, TMT_EDGEFILLCOLOR )
         FillSolidRect( hDCMem, rc, color )
         C5_DrawThemeBackground( hTheme, hDCMem, RP_GRIPPER, nil , {2,0, ::nHeight-4, 6} )

         C5_DrawThemeEdge( hTheme, hDCMem, RP_BAND, nil, {rc[1],rc[2],rc[3],rc[4]}, BDR_RAISEDOUTER, BF_RECT )
         C5_DrawThemeEdge( hTheme, hDCMem, RP_BAND, nil, {rc[1]+1,rc[2]+1,rc[3]-1,rc[4]-1}, BDR_RAISEDINNER, BF_RECT )
         C5_CloseThemeData()
      endif

   else
      FillSolidRect( hDCMem, rc, GetSysColor(COLOR_BTNFACE), 0 )

      rc[1]++
      rc[2]++

      DrawFrameControl(hDCMem, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )
   endif

   for n := 1 to len( ::aShapes )
       oShape := ::aShapes[n]
       nRight := oShape:Paint( hDCMem )
       if n < len( ::aShapes )
          if nRight + ::aShapes[n+1]:nWidth > aClient[4]-17
             ::DrawChevRon( hDC )
             exit
          endif
       endif
   next

   SelectObject( hDCMem, hOldBmp )
   BitBlt( hDC, ::nTop, ::nLeft, 1300, ::nHeight, hDCMem, 0, 0, SRCCOPY )
   DeleteDC( hDCMem )

endif

hDCMem  := CreateCompatibleDC( ::oWnd:hDC )
hOldBmp := SelectObject( hDCMem, ::hBmp )

StretchBlt( hDC, ::nLeft, ::nTop, aClient[4]-aClient[2], ::nHeight,;
            hDCMem,   0,       0, aClient[4]-aClient[2], ::nHeight, SRCCOPY )
//DrawBitmap(hDC, ::hBmp, ::nTop, ::nLeft )
SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )

for each oShape in ::aShapes
    if oShape:nItemId == ::oWnd:oSelected:nItemId
       oShape:DotsSelect( hDC )
       exit
    endif
next


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil

***************************************************************************************************
  METHOD DrawChevron( hDC ) CLASS TDsgnBar
***************************************************************************************************
local aClient := ::oWnd:oForm:GetClientRect()
local hTheme
local c := chr(187)
local rc := {aClient[1]-::nHeight,aClient[4]-17,aClient[1],aClient[4]}

if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
   hTheme := C5_OpenThemeData(::oWnd:hWnd, "REBAR" )
   C5_DrawThemeBackground( hTheme, hDC, RP_CHEVRON, CHEVS_HOT , rc )
   C5_CloseThemeData()
else
   DrawText( hDC, c, rc, nOr( DT_CENTER ) )
endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnBar
***************************************************************************************************
local oMenu
local o := self

MenuAddItem("Imágenes",,o:lImages == .t.,,{|oMenuItem| o:lImages := !o:lImages, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
MenuAddItem("Textos"  ,,o:lText   == .t.,,{|oMenuItem| o:lText   := !o:lText  , o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
MENUITEM "Altura"
MENU
   MenuAddItem("28",,o:nHeight == 28,,{|oMenuItem| o:nHeight := 28, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("32",,o:nHeight == 32,,{|oMenuItem| o:nHeight := 32, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("36",,o:nHeight == 36,,{|oMenuItem| o:nHeight := 36, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("40",,o:nHeight == 40,,{|oMenuItem| o:nHeight := 40, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("44",,o:nHeight == 44,,{|oMenuItem| o:nHeight := 44, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("48",,o:nHeight == 48,,{|oMenuItem| o:nHeight := 48, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("52",,o:nHeight == 52,,{|oMenuItem| o:nHeight := 52, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("56",,o:nHeight == 56,,{|oMenuItem| o:nHeight := 56, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("60",,o:nHeight == 60,,{|oMenuItem| o:nHeight := 60, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("64",,o:nHeight == 64,,{|oMenuItem| o:nHeight := 64, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("68",,o:nHeight == 68,,{|oMenuItem| o:nHeight := 68, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("70",,o:nHeight == 70,,{|oMenuItem| o:nHeight := 70, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("74",,o:nHeight == 74,,{|oMenuItem| o:nHeight := 74, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("78",,o:nHeight == 78,,{|oMenuItem| o:nHeight := 78, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("82",,o:nHeight == 82,,{|oMenuItem| o:nHeight := 82, o:ResizeItems(),o:MakeBar(),::oWnd:Refresh()},,,,,,,.F.,,,.F. )
ENDMENU


return nil


***************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TDsgnBar
***************************************************************************************************

do case
   case nKey == 43
        ::AddItem()
        ::MakeBar()
        ::oWnd:Refresh()
        return .t.

endcase

return .f.

***************************************************************************************************
   METHOD Destroy( nKey, nFlags ) CLASS TDsgnBar
***************************************************************************************************

if ::hBmp != nil
   DeleteObject( ::hBmp )
endif

return nil

***************************************************************************************************
   METHOD MakeBar() CLASS TDsgnBar
***************************************************************************************************

  DeleteObject( ::hBmp ); ::hBmp := 0

return nil

***************************************************************************************************
  METHOD ResizeItems() CLASS TDsgnBar
***************************************************************************************************
local oBtn, n
local nLen := len( ::aShapes )
local aClient := ::oWnd:oForm:GetClientRect()

::aRect[1] := aClient[1]-::nHeight
::aRect[3] := aClient[1]

for n := 1 to nLen

    ::aShapes[n]:nTop    := ::nTop    + 2 //4
    ::aShapes[n]:nBottom := ::nBottom - 2 //4
    ::aShapes[n]:nLeft   := if ( n == 1,::nLeft +10, ::aShapes[n-1]:nRight+1 )
    ::aShapes[n]:nRight  := ::aShapes[n]:nLeft + + if( ::aShapes[n]:lSeparator, 8, (::nHeight/2)*3 )
    if ::aShapes[n]:lPopup
       ::aShapes[n]:nRight += 6 //14
    endif
next

return nil



***************************************************************************************************
   METHOD GoPrev() CLASS TDsgnBar
***************************************************************************************************
local n, nLen, nFocus
nLen := len( ::aShapes )

for n := 1 to nLen
    if ::aShapes[n]:nItemId == ::oWnd:oSelected:nItemId
       nFocus := n-1
       if nFocus < 1
          nFocus := nLen
       endif
       ::oWnd:oSelected := ::aShapes[nFocus]
       exit
    endif
next

::oWnd:Refresh()


return nil

***************************************************************************************************
   METHOD GoNext() CLASS TDsgnBar
***************************************************************************************************
local n, nLen, nFocus
nLen := len( ::aShapes )

for n := 1 to nLen
    if ::aShapes[n]:nItemId == ::oWnd:oSelected:nItemId
       nFocus := n+1
       if nFocus > nLen
          nFocus := 1
       endif
       ::oWnd:oSelected := ::aShapes[nFocus]
       exit
    endif
next

::oWnd:Refresh()
return nil

***************************************************************************************************
  METHOD DeleteChild( o ) CLASS TDsgnBar
***************************************************************************************************
local n, nLen
local nBorrar := 0

nLen := len( ::aShapes )

for n := 1 to nLen
    if ::aShapes[n] == o
       nBorrar := n
       exit
    endif
next

if nBorrar != 0
   adel( ::aShapes, nBorrar )
   asize( ::aShapes, nLen-1)
   ::ResizeItems()
   ::MakeBar()
   ::oWnd:Refresh()
endif

return nil

**********************************************************************************
  METHOD ShapeOver( nRow, nCol ) CLASS TDsgnBar
**********************************************************************************
local oBtn, oOver
for each oBtn in ::aShapes
    oOver := oBtn:ShapeOver( nRow, nCol )
    if oOver != nil
       return oOver
    endif
next

if PtInRect( nRow, nCol, {::aRect[1]-5,::aRect[2]-5,::aRect[3]+5,::aRect[4]+5} )
   return self
endif

return nil




***************************************************************************************************
***************************************************************************************************
***************************************************************************************************

CLASS TItemBar FROM TShape

      DATA oParent
      DATA lSeparator
      DATA cFileName
      DATA nAlign
      DATA lPopup
      DATA nStyle
      DATA lPressed
      DATA lActive
      DATA lBorder

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, oBar, cCaption, cFileName, lSeparator ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD cGetFileName()
      METHOD KeyDown( nKey, nFlags )
      METHOD KeyChar( nKey, nFlags )
      METHOD Edit()

ENDCLASS

***************************************************************************************************************
  METHOD New( nTop, nLeft, nBottom, nRight, oWnd, oBar, cCaption, cFileName, lSeparator ) CLASS TItemBar
***************************************************************************************************************

       local o := self

       DEFAULT lSeparator := .f.
       DEFAULT cCaption   := "Button"

       super:New( nTop, nLeft, nBottom, nRight, oWnd )

       //::oParent        := oBar
       ::aDotsActives   := {0,0,0,0,0,0,0,0}
       ::bContextMenu   := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
       ::bKeyChar       := {|nKey,nFlags| o:KeyChar( nKey, nFlags ) }
       ::bKeyDown       := {|nKey,nFlags| o:KeyDown( nKey, nFlags ) }
       ::cCaption       := cCaption
       ::cFileName      := cFileName
       ::lActive        := .t.
       ::lBorder        := .t.
       ::lCanSize       := .f.
       ::lCanMove       := .f.
       ::lPopup         := .f.
       ::lPressed       := .f.
       ::lSeparator     := lSeparator
       ::nAlign         := nOr( DT_VCENTER, DT_CENTER, DT_END_ELLIPSIS )
       ::nStyle         := 1

       ::aProperties    := { "aDotsActives"   ,;
                             "aRect"          ,;
                             "cCaption"       ,;
                             "cFileName"      ,;
                             "lActive"        ,;
                             "lBorder"        ,;
                             "lCanSize" ,;
                             "lCanMove"       ,;
                             "lEditable"      ,;
                             "lPopup"         ,;
                             "lPressed"       ,;
                             "lSeparator"     ,;
                             "lVisible"       ,;
                             "nAlign"         ,;
                             "nClrText"       ,;
                             "nStyle"         ,;
                             "xMaxHeight"     ,;
                             "xMaxWidth"      ,;
                             "xMinHeight"     ,;
                             "xMinWidth"      }

  return self


*************************************************************************************************
  METHOD Paint( hDC ) CLASS TItemBar
*************************************************************************************************
local hOldBrush, hOldPen
local rc, mode
local hFont, hOldFont, hBmp
local hTheme := nil
local nWidth, nHeight
local nTop


   rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}

   hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "TOOLBAR")
      if hTheme != nil
         if ::lSeparator
            C5_DrawThemeBackground( hTheme, hDC, TP_SEPARATOR, TS_NORMAL , rc )
         else
            rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}
            if ::lPopup
               rc[4] -= 14
               C5_DrawThemeBackground( hTheme, hDC, TP_SPLITBUTTON, TS_HOT , rc )
               rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}
               rc[2] := rc[4] - 14
               C5_DrawThemeBackground( hTheme, hDC, TP_SPLITBUTTONDROPDOWN, TS_HOT , rc )
            else
               C5_DrawThemeBackground( hTheme, hDC, TP_BUTTON, TS_HOT , rc )
            endif*/
            rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}
            if ::oParent:lText
               rc[1] := rc[3] - 20
            endif
            if ::lPopup
               rc[4] -= 14
            endif
            if ::oParent:lText
               C5_DrawThemeText( hTheme, hDC, TP_BUTTON, TS_HOT, ::cCaption, ::nAlign, nil, rc )
            endif
            rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}
         endif
         C5_CloseThemeData()
      endif

   else

     FillSolidRect( hDC, rc, GetSysColor(COLOR_BTNFACE) )

     if ::oParent:l3D
        DrawEdge( hDC, rc, BDR_RAISEDINNER, BF_RECT )
     else
        DrawFrameControl(hDC, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )
     endif

     mode := SetBkMode( hDC, TRANSPARENT )
     rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}

     if ::oParent:lImages
        rc[1] := rc[3] - 20
     endif

     if ::oParent:lText
        DrawText(hDC, ::cCaption, rc, ::nAlign )
     endif

     SetBkMode( hDC, mode )

   endif

   if file( ::cFileName ) .and. !::lSeparator
      rc := {::aRect[1]-::oParent:aRect[1],::aRect[2]-::oParent:aRect[2],::aRect[3]-::oParent:aRect[1],::aRect[4]-::oParent:aRect[2]}
      nWidth  := rc[4]-rc[2]
      nHeight := rc[3]-rc[1]

      if ::lPopup
         nWidth -= 14
      endif
      hBmp := ReadBitmap( hDC, ::cFileName )
      if hBmp != 0
         if !empty( ::cCaption )
            rc[1] := rc[1] + ((nHeight/5)*2)
         else
            rc[1] := rc[1] + (nHeight/2)
         endif
         rc[1] := rc[1] - (nBmpHeight( hBmp ) /2 )
         if ::oParent:lImages
            DrawMasked( hDC, hBmp, rc[1], rc[2]+ nWidth/2 - nBmpWidth( hBmp ) /2 )
         endif
         DeleteObject( hBmp )
      endif

   endif

   SelectObject( hDC, hOldFont )

return rc[4]

***************************************************************************************************
  METHOD ContextMenu( nRow, nCol ) CLASS TItemBar
***************************************************************************************************
local oMenu
local o := self

MENUITEM "Fichero"    ACTION o:cGetFileName()
MENUITEM "lPopup"     ACTION ( o:lPopup     := !o:lPopup,     o:oParent:ResizeItems(),o:oParent:MakeBar(),o:oWnd:Refresh())
MENUITEM "l3D"        ACTION ( o:l3D        := !o:l3D,        o:oParent:ResizeItems(),o:oParent:MakeBar(),o:oWnd:Refresh())
MENUITEM "lSeparator" ACTION ( o:lSeparator := !o:lSeparator, o:oParent:ResizeItems(),o:oParent:MakeBar(),o:oWnd:Refresh())
SEPARATOR

return nil


***************************************************************************************************
  METHOD cGetFileName() CLASS TItemBar
***************************************************************************************************
local cFiltro := "Imágenes (*.bmp *.gif *.jpg *.ico *.cur ) | *.bmp;*.gif;*.jpg;*.ico;*.cur; |"
local cFiles := cGetFile( cFiltro, "Selecciona imagen" )

::cFileName := cFiles
::oParent:MakeBar()
::oWnd:Refresh()

return nil

***************************************************************************************************
   METHOD KeyChar( nKey, nFlags ) CLASS TItemBar
***************************************************************************************************

do case

   case nKey == VK_SPACE

        ::nStyle ++
        if ::nStyle > 3
           ::nStyle := 1
        endif
        do case
           case ::nStyle == 1
                ::lSeparator := .f.
                ::lPopup     := .f.
           case ::nStyle == 2
                ::lSeparator := .t.
                ::lPopup     := .f.
           case ::nStyle == 3
                ::lSeparator := .f.
                ::lPopup     := .t.
        endcase
        ::oParent:ResizeItems()
        ::oParent:MakeBar()
        ::oWnd:Refresh()


endcase

return .f.

***************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TItemBar
***************************************************************************************************

do case
   case nKey == VK_ADD
        ::oParent:AddItem()
        ::oParent:MakeBar()
        ::oWnd:Refresh()
        return .t.
   case nKey == VK_RIGHT .or. nKey == VK_DOWN
        ::oParent:GoNext()

   case nKey == VK_LEFT  .or. nKey == VK_UP
        ::oParent:GoPrev()

endcase

return .f.


***************************************************************************************************
   METHOD Edit() CLASS TItemBar
***************************************************************************************************
local oFont
local bValid := {||.t.}
local oShape := self
local uVar := padr(oShape:cCaption, 100)
local nClrPane := RGB( 241,241,235 )

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

if oShape:lEditable

                                                                                                                                       //16777215
   ::oWnd:oGet := TGet():New(oShape:nBottom - 19,oShape:nLeft+2,{ | u | If( PCount()==0, uVar, uVar:= u ) },oShape:oWnd,oShape:nWidth-3,17,,,0,nClrPane,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)



   //::oGet:oGet:Picture = cPicture

   ::oWnd:nLastKey := 0
   ::oWnd:oGet:SetFocus()

   if Upper( ::oWnd:oGet:ClassName() ) != "TGET"
      ::oWnd:oGet:Refresh()
   endif


   ::oWnd:oGet:bValid := {|| .t. }

   ::oWnd:oGet:bLostFocus := {|| (oShape:oWnd:oGet:Assign(),;
                            oShape:oWnd:oGet:VarPut( oShape:oWnd:oGet:oGet:VarGet()),;
                            oShape:cCaption := if( oShape:oWnd:nLastKey != VK_ESCAPE,;
                            (EnableUndo(),alltrim(oShape:oWnd:oGet:oGet:VarGet())),;
                            oShape:cCaption) ,;
                            If( oShape:oWnd:nLastKey != VK_ESCAPE,;
                                Eval( bValid, uVar, oShape:oWnd:nLastKey, Self ),;
                                Eval( bValid, nil, oShape:oWnd:nLastKey, Self ) ),;
                            oShape:oWnd:oGet:End(), DisableUndo(),oShape:oParent:ResizeItems(),;
                                                                  oShape:oParent:MakeBar(),;
                                                                  oShape:oWnd:Refresh()) }

   ::oWnd:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( oShape:oWnd:nLastKey := nKey, oShape:oWnd:oGet:End()), ) }

endif

return nil

/*

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

#define TOPBAR   1
#define LEFTBAR  2
#define RIGHTBAR 3
#define DOWNBAR  4
#define FLOATBAR 5

HB_FUNC_STATIC( TDSGNBAR_PAINT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   PHB_ITEM oWnd = ObjGetItem( Self, "oWnd" );
   PHB_ITEM oForm = ObjGetItem( oWnd, "oForm" );
   PHB_ITEM pTemp = ObjGetItem( Self, "GetClientRect" );
   RECT rc;
   int n;
   RECT rcClient;
   PHB_ITEM oShape;
   HDC hDC = GetObjNL( oWnd, "hDC" );
   HDC hDCMem ;
   HBITMAP hOldBmp;
   HBITMAP hBmp;
   HTEME hTheme;
   COLORREF color;
   int nRight, nSide;
   BOOL lChangeTheme;

   rcClient.top    = hb_arrayGetNI( pTemp, 1 );
   rcClient.left   = hb_arrayGetNI( pTemp, 2 );
   rcClient.bottom = hb_arrayGetNI( pTemp, 3 );
   rcClient.right  = hb_arrayGetNI( pTemp, 4 );

   if( (BOOL) GetObjNL( Self, "hBmp" ) == 0 )
   {
       hDCMem = CreateCompatibleDC( hDC );
       hBmp = CreateCompatibleBitmap( hDC, 1300, (int) GetObjNI(Self,"nHeight"));
       hb_itemPutNL( Self, hBmp );
       hOldBmp = (HBITMAP) SelectObject( hDCMem, hBmp );

       nSide = ObjGetNI( Self, "nSide" );
       switch(nSide)
       {
          case TOPBAR:
          {
             hb_itemPutNI( Self, ::nRight := aClient[4]
          }
      case ::nSide == LEFTBAR
           ::nBottom := aClient[3]
      case ::nSide == RIGHTBAR
           ::nLeft := aClient[4]-::nWidth
           ::nBottom := aClient[3]
      case ::nSide == DOWNBAR
           ::nTop := aClient[3]-::nHeight
   endcase


   //rc := {::nTop, ::nLeft, ::nBottom, ::nRight}
   rc := {0, 0, ::nHeight, 1300}

   if lTemas() .and. !::oWnd:lPocketPc  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "REBAR" )
      if hTheme != nil
         hOldTheme := hTheme
         color := GetThemeColor( hTheme, RP_BAND, nil, TMT_EDGEFILLCOLOR )
         FillSolidRect( hDCMem, rc, color )
         C5_DrawThemeBackground( hTheme, hDCMem, RP_GRIPPER, nil , {2,0, ::nHeight-4, 6} )

         C5_DrawThemeEdge( hTheme, hDCMem, RP_BAND, nil, {rc[1],rc[2],rc[3],rc[4]}, BDR_RAISEDOUTER, BF_RECT )
         C5_DrawThemeEdge( hTheme, hDCMem, RP_BAND, nil, {rc[1]+1,rc[2]+1,rc[3]-1,rc[4]-1}, BDR_RAISEDINNER, BF_RECT )
         C5_CloseThemeData()
      endif

   else
      FillSolidRect( hDCMem, rc, GetSysColor(COLOR_BTNFACE), 0 )

      rc[1]++
      rc[2]++

      DrawFrameControl(hDCMem, rc, DFC_BUTTON, DFCS_BUTTONPUSH  )
   endif

   for each oShape in ::aShapes
       nRight := oShape:Paint( hDCMem )
       n := hb_enumindex()
       if n < len( ::aShapes )
          if nRight + ::aShapes[n+1]:nWidth > aClient[4]-17
             ::DrawChevRon( hDC )
             exit
          endif
       endif
   next

   SelectObject( hDCMem, hOldBmp )
   BitBlt( hDC, ::nTop, ::nLeft, 1300, ::nHeight, hDCMem, 0, 0, SRCCOPY )
   DeleteDC( hDCMem )

endif

hDCMem  := CreateCompatibleDC( ::oWnd:hDC )
hOldBmp := SelectObject( hDCMem, ::hBmp )

StretchBlt( hDC, ::nLeft, ::nTop, aClient[4]-aClient[2], ::nHeight,;
            hDCMem,   0,       0, aClient[4]-aClient[2], ::nHeight, SRCCOPY )
//DrawBitmap(hDC, ::hBmp, ::nTop, ::nLeft )
SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )

for each oShape in ::aShapes
    if oShape:nItemId == ::oWnd:oSelected:nItemId
       oShape:DotsSelect( hDC )
       exit
    endif
next


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil

}

*/
