#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#include "uxtheme_tmt.ch"
//#include "winuser.ch"

#define SRCCOPY 13369376

#define COLOR_HIGHLIGHT         13
#define HLINE   21
#define MK_MBUTTON        16


static nIdItem := 100

CLASS TDsgnMenuBar FROM TShape

      DATA nHLine

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD AddItem( cCaption )
      METHOD KeyDown( nKey, nFlags )
      METHOD Paint( hDC )
      METHOD nHeight()
      METHOD GetCoords()
      METHOD LButtonDown( nRow, nCol )
      METHOD Edit()             INLINE ::aShapes[::nOption]:Edit()
      METHOD GoLeft()
      //METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
      METHOD LostFocus()
      METHOD ContextMenu( nRow, nCol )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnMenuBar
************************************************************************************************

local o       := self

DEFAULT nTop := 0, nLeft := 0, nBottom := 0, nRight := 0

   ::nHLine         := HLINE

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::aDotsActives   := {0,0,0,0,0,0,0,0}
   ::aShapes        := {}
   ::bContextMenu   := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
   ::lCanSize := .f.
   ::lContainer     := .t.
   ::nClrPane       := GetSysColor( COLOR_BTNFACE )
   ::nClrText       := 0
   ::nOption        := 1
   ::bLClicked      := {|nRow, nCol| o:LButtonDown( nRow, nCol ) }
  ::cObjName         := ::GetObjName()

   if ::oWnd != nil
      ::oWnd:oForm:oMenu := self
   endif

   ::bKeyDown   := {|nKey,nFlags| o:KeyDown( nKey, nFlags ) }
   ::bLostFocus := {|| ::LostFocus() }

   ::aProperties :=  { "aDotsActives"   ,;
                       "aRect"          ,;
                       "aShapes"        ,;
                       "lCanSize" ,;
                       "lCanMove"       ,;
                       "lEditable"      ,;
                       "nOption"        ,;
                       "xMaxHeight"     ,;
                       "xMaxWidth"      ,;
                       "xMinHeight"     ,;
                       "xMinWidth"      }


  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self

************************************************************************************************
   METHOD AddItem( cCaption ) CLASS TDsgnMenuBar
************************************************************************************************

  aadd( ::aShapes, TDsgnMenuItem():New( cCaption ) )


return 0

************************************************************************************************
  METHOD GoLeft() CLASS TDsgnMenuBar
************************************************************************************************

  ::nOption --
  if ::nOption < 1
     ::nOption := len( ::aShapes )
  endif
  if ::aShapes[::nOption]:oMenuHijo != nil

     ::aShapes[::nOption]:oMenuHijo:Show()

     SetFocus(::aShapes[::nOption]:oMenuHijo:hWnd )
  else
     ::oWnd:oSelected := self
     SetFocus(::oWnd:hWnd)
  endif
  ::Refresh()

return 0

************************************************************************************************
  METHOD KeyDown( nKey, nFlags ) CLASS TDsgnMenuBar
************************************************************************************************
local nOption := ::nOption
local oPopup
local lControl := GetKeyState( VK_CONTROL )

do case
   case nKey == VK_LEFT
        nOption --
        if nOption < 1
           nOption := len( ::aShapes )
        endif
        if ::aShapes[::nOption]:oMenuHijo != nil
           ::aShapes[::nOption]:oMenuHijo:Hide()
        endif
        ::nOption := nOption
        ::oWnd:Refresh()
        if ::aShapes[::nOption]:oMenuHijo != nil
           ::aShapes[::nOption]:oMenuHijo:nOption := 1
           ::aShapes[::nOption]:oMenuHijo:Show()
           //SetFocus(::aShapes[::nOption]:oMenuHijo:hWnd )
        endif
        return .t.

   case nKey == VK_RIGHT
        if ::aShapes[::nOption]:oMenuHijo != nil
           ::aShapes[::nOption]:oMenuHijo:Hide()
        endif
        nOption ++
        if nOption > len( ::aShapes )
           if .t. //lControl
              ::AddItem("Item " + alltrim(str(len(::aShapes)+1)))
              ::nOption := nOption
              ::oWnd:Refresh()
              return .t.
           endif
           nOption := 1
        endif
        ::nOption := nOption
        ::oWnd:Refresh()
        if ::aShapes[::nOption]:oMenuHijo != nil
           ::aShapes[::nOption]:oMenuHijo:nOption := 1
           ::aShapes[::nOption]:oMenuHijo:Show()
           //SetFocus(::aShapes[::nOption]:oMenuHijo:hWnd )
        endif
        return .t.

   case !::oWnd:lPocketPc()  .and. nKey == VK_DOWN

        oPopup := ::aShapes[::nOption]:AddPopup()
        oPopup:oDsgnMenuBar := self

   case ::oWnd:lPocketPc()  .and. nKey == VK_UP

        oPopup := ::aShapes[::nOption]:AddPopup()
        oPopup:oDsgnMenuBar := self

   case nKey == VK_ESCAPE

        if ::aShapes[::nOption]:oMenuHijo != nil
           ::aShapes[::nOption]:oMenuHijo:Hide()
        endif

endcase

return .F.

************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnMenuBar
************************************************************************************************
local hTheme, hOldTheme, color
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local oItem
local hOldFont, mode
local oFontPPC
local hBmp

   for each oItem in ::aShapes
       oItem:oParent := self
       oItem:oWnd    := ::oWnd
   next

   ::GetCoords()

   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "REBAR" )
      if hTheme != nil
         color := CLR_WHITE //GetThemeColor( hTheme, RP_BAND, nil, TMT_EDGEFILLCOLOR )
         FillSolidRect( hDC, rc, color )
         C5_DrawThemeEdge( hTheme, hDC, RP_BAND, nil, {rc[1],rc[2],rc[3],rc[4]+2}, BDR_RAISEDOUTER, BF_RECT ) //
         C5_CloseThemeData()
      endif
   else
      if ::oWnd:lPocketPc()
         rc[3]--
         rc[4]--
      endif
      FillSolidRect( hDC, rc, CLR_WHITE )
   endif

   if ::oWnd:lPocketPc()
      oFontPPC := TFont():New( ::cFaceName, ::nWidthFont, ::nHeightFont, .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
      hOldFont := SelectObject( hDC, oFontPPC:hFont )
   else
      hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
   endif

   mode     := SetBkMode( hDC, TRANSPARENT )

   for each oItem in ::aShapes
       oItem:Paint( hDC )
   next

   SelectObject( hDC, hOldFont )
   SetBkMode( hDC, mode )
   if oFontPPC != nil
      oFontPPC:End()
   endif

   if ::oWnd:lPocketPc()
      rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      hBmp     := LoadBitmap( GetResources(), "keyboard" )
      DrawBitmap( hDC, hBmp, rc[1], rc[4]-35 )
      DeleteObject( hBmp )
   endif


return 0


************************************************************************************************
  METHOD nHeight() CLASS TDsgnMenuBar
************************************************************************************************
local nH := ::nHLine
local nW := 4
local nWidth := ::nWidth
local oItem

for each oItem in ::aShapes
    nW += oItem:nSize
    if nW > nWidth - 6
       nW := oItem:nSize
       nH += ::nHLine
    endif
next

return nH

************************************************************************************************
  METHOD GetCoords() CLASS TDsgnMenuBar
************************************************************************************************
local nH := ::nHLine
local nW := 4
local nWidth := ::nWidth
local oItem
local nTop, nLeft, nBottom, nRight

nTop    := ::nTop
nBottom := nTop + ::nHLine -2
nLeft   := ::nLeft + 6

for each oItem in ::aShapes
    nW += oItem:nSize
    if nW > nWidth - 6
       nW := oItem:nSize + 4
       nTop    := nBottom
       nBottom := nBottom + nH
       nLeft   := ::nLeft + 6
    endif
    nRight      := nLeft + oItem:nSize + 6
    oItem:aRect := { nTop, nLeft, nBottom, nRight }
    nLeft       := nRight
next

return nH

************************************************************************************************
   METHOD LButtonDown( nRow, nCol ) CLASS TDsgnMenuBar
************************************************************************************************
local oShape
local n, nLen
nLen := len(::aShapes)
::SetFocus()
for n := 1 to nLen
    oShape := ::aShapes[n]
    if oShape:ShapeOver( nRow, nCol ) != nil
       if ::aShapes[::nOption]:oMenuHijo != nil
          ::aShapes[::nOption]:oMenuHijo:Hide()
       endif
       ::nOption := n
       if oShape:oMenuHijo != nil
          oShape:oMenuHijo:Show()
          oShape:oMenuHijo:nOption := 1
          oShape:oMenuHijo:SetFocus()
       endif
       ::oWnd:Refresh()
       return .t.
    endif
next

return .f.

/*
***************************************************************************************************************
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TDsgnMenuBar
***************************************************************************************************************

   local nWParam := 0

   if lAnd( nKeys, MK_MBUTTON )
      if nDelta > 0
         nWParam := ::KeyDown( VK_UP )
      else
         nWParam := ::KeyDown( VK_DOWN )
      endif
   else
      if nDelta > 0
         nWParam := ::KeyDown( VK_UP )
      else
         nWParam := ::KeyDown( VK_DOWN )
      endif
   endif

return nil
*/

***************************************************************************************************************
   METHOD LostFocus() CLASS TDsgnMenuBar
***************************************************************************************************************

if ::aShapes[::nOption]:oMenuHijo != nil
   ::aShapes[::nOption]:oMenuHijo:Hide()
endif

return nil

***************************************************************************************************************
  METHOD ContextMenu( nRow, nCol ) CLASS TDsgnMenuBar
***************************************************************************************************************
local oShape
local lFind := .f.
local nLen := len( ::aShapes )
for n := 1 to nLen
    oShape := ::aShapes[n]
    if oShape:ShapeOver( nRow, nCol ) != nil
       lFind := .t.
       exit
    endif
next

if !lFind
   ::KeyDown( VK_RIGHT )
endif

return nil




************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************

CLASS TDsgnMenuItem FROM TShape

      DATA oMenuHijo
      DATA cxCaption
      DATA nSize
      DATA lSeparator
      DATA lHelp
      DATA lActive
      DATA lGrayed
      DATA cFileName
      DATA nAlign
      DATA oParent

      METHOD New( cCaption ) CONSTRUCTOR
      METHOD cCaption( cNew ) SETGET
      METHOD Paint( hDC )
      METHOD AddPopup()
      METHOD GenRC()

ENDCLASS

***********************************************************************************************
  METHOD New( cCaption ) CLASS TDsgnMenuItem
***********************************************************************************************


   super:New()

   ::cFileName   := ""
  // ::lCanMove    := .f.
   ::aDotsActives   := {0,0,0,0,0,0,0,0}
   ::lCanSize    := .f.
   ::lSeparator  := .f.
   ::lHelp       := .f.
   ::lActive     := .f.
   ::lGrayed     := .f.
   ::cCaption    := cCaption
   ::nAlign      := nOr( DT_SINGLELINE, DT_VCENTER )


   ::aProperties :=  { "aDotsActives"   ,;
                       "aRect"          ,;
                       "cCaption"       ,;
                       "lCanSize"       ,;
                       "lCanMove"       ,;
                       "lEditable"      ,;
                       "lSeparator"     ,;
                       "nSize"          ,;
                       "oMenuHijo"      ,;
                       "xMaxHeight"     ,;
                       "xMaxWidth"      ,;
                       "xMinHeight"     ,;
                       "xMinWidth"      }

return self

************************************************************************************************
   METHOD AddPopup() CLASS TDsgnMenuItem
************************************************************************************************

  local aPoint := { ::aRect[3],::aRect[2] }
  aPoint := ClientToScreen( ::oWnd:hWnd, aPoint )

  if ::oMenuHijo == nil
     ::oMenuHijo := TDsgnPopup():New()
     ::oMenuHijo:oHead := ::oMenuHijo
     ::oMenuHijo:oMenuItemParent := self
     ::oMenuHijo:AddItem( "SubItem " + alltrim(str(len( ::oMenuHijo:aItems )+1)) )
  else
     ::oMenuHijo:nOption := len(::oMenuHijo:aItems)
     ::oMenuHijo:Show()
     return ::oMenuHijo
  endif


  if !::oWnd:lPocketPc()
     SetWindowPos ( ::oMenuHijo:hWnd, -1, aPoint[1], aPoint[2], 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
  else
     SetWindowPos ( ::oMenuHijo:hWnd, -1, aPoint[1]-::oMenuHijo:aRect[3]-::oMenuHijo:aRect[1]+3, aPoint[2], 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
  endif

  SetFocus(::oMenuHijo:hWnd)

  ::oMenuHijo:Refresh()
  ::oMenuHijo:aRect := GetWndRect( ::oMenuHijo:hWnd )



return ::oMenuHijo

***********************************************************************************************
  METHOD cCaption( cNew ) CLASS TDsgnMenuItem
***********************************************************************************************
local hFont, hDC, oFontPPC

if cNew != nil
   ::cxCaption := cNew
   hDC   := GetDC( 0 )

   if ::oWnd != nil .and. ::oWnd:lPocketPc()
      oFontPPC := TFont():New( ::cFaceName, ::nWidthFont, ::nHeightFont, .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
      hFont := oFontPPC:hFont
   else
      hFont := GetStockObject( DEFAULT_GUI_FONT )
   endif

   ::nSize := 4 + GetTextWidth( hDC, strtran(::cxCaption,"&",""), hFont ) + 4
   ReleaseDC( 0, hDC )
   if oFontPPC != nil
      oFontPPC:End()
   endif
endif

return ::cxCaption

***********************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnMenuItem
***********************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hFont, hOldFont, hBmp, oFontPPC
local nWidth, nHeight
local hTheme, color, nClrtext
local lOption := ::oParent:aShapes[::oParent:nOption] == self
local lTemas := lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

   nWidth  := ::aRect[4]-::aRect[2]
   nHeight := ::oParent:nHLine

   if lTemas .and. !::oWnd:lPocketPc()
      hTheme := C5_OpenThemeData(::oWnd:hWnd, "MENU" )
      if lOption .and. ::oWnd:oSelected == ::oParent
         color := GetSysColor( COLOR_HIGHLIGHT )
         FillSolidRect( hDC, rc, color )
      endif
      C5_CloseThemeData( hTheme )
   else
      if lOption
         rc[1]++
         if ::oWnd:lPocketPC()
            FillSolidRect( hDC, rc, CLR_WHITE, 0 )
         else
            DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
         ENDIF
         rc[1]--
      endif
   endif

   if file( ::cFileName )
      rc[4] := rc[2] + 15
      nWidth  := rc[4]-rc[2]
      nHeight := rc[3]-rc[1]

      hBmp := ReadBitmap( hDC, ::cFileName )
      if hBmp != 0
         DrawMasked( hDC, hBmp, rc[1] + (nHeight/2) - (nBmpHeight(hBmp)/2), rc[2] + (nWidth/2)  - (nBmpWidth(hBmp)/2))
         DeleteObject( hBmp )
      endif
      rc[2] := rc[4]
      rc[4] := ::aRect[4]
   endif

   if lOption .and. ::oWnd:oSelected == ::oParent .and. lTemas
      nClrText := SetTextColor( hDC, CLR_WHITE )
   else
      nClrText := SetTextColor( hDC, 0 )
   endif

   rc[2] += 6
   DrawText(hDC, ::cCaption, rc, ::nAlign )

   SetTextColor( hDC, nClrText )


return 0

***********************************************************************************************
  METHOD GenRC() CLASS TDsgnMenuItem
***********************************************************************************************
local cRet := ""

   if ::oMenuHijo != nil
      cRet += ::oMenuHijo:GenRC( 1 )
   else
      cRet += space( 4 ) + "MENUITEM " + '"' + ::cCaption + '", ' + ::cStrID()
      if !::lActive
         cRet += ", INACTIVE"
      endif
      if ::lGrayed
         cRet += ", GRAYED"
      endif
      cRet += CRLF
    endif

return cRet

***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************

CLASS TDsgnPopup FROM TWindow

      CLASSDATA lRegistered AS LOGICAL

      DATA  aRect
      DATA  nOption
      DATA  aItems
      DATA  oDsgnMenuBar
      DATA  oMenuItemParent
      DATA  oHead
      DATA  oGet
      DATA  nHItem

      DATA cFaceName
      DATA nWidthFont
      DATA nHeightFont
      DATA lBold
      DATA lItalic
      DATA lUnderline
      DATA lStrikeOut



      METHOD New() CONSTRUCTOR
      METHOD Display()          INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
      METHOD Paint()
      METHOD AddItem( cCaption )
      METHOD ItemActive()       INLINE ::aItems[::nOption]
      METHOD GetNewSize()
      METHOD KeyDown( nKey, nFlags )
      METHOD SysKeyChar    ( nKey, nKeyFlags )
      METHOD Hide()
      METHOD LButtonDown( nRow, nCol )
      METHOD LDblClick( nRow, nCol )
      METHOD HandleEvent( nMsg, nWParam, nLParam )
      //METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
      METHOD Edit()
      METHOD LostFocusEdit()
      METHOD DelCurItem( )
      METHOD Show()
      METHOD GenRC( nLevel )

ENDCLASS

***************************************************************************************************************
   METHOD New() CLASS TDsgnPopup
***************************************************************************************************************

   ::nTop     := 10
   ::nLeft    := 10
   ::nBottom  := ::nTop + 3 + 3
   ::nRight   := ::nLeft + 20 + 22
   ::oWnd     := Aplicacion():oWnd
   ::nStyle   := nOr( WS_POPUP, WS_VISIBLE, WS_TABSTOP )

  ::cFaceName        := "Tahoma" // buscar el nombre de la del sistema
  ::nWidthFont       := 0
  ::nHeightFont      := -12
  ::lBold            := .f.
  ::lItalic          := .f.
  ::lUnderline       := .f.
  ::lStrikeOut       := .f.

   ::nOption  := 1
   ::aItems   := {}
   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   ::Create()

   ::aProperties := {"nOption",;
                     "aItems" }

return self


***********************************************************************************************
  METHOD Show() CLASS TDsgnPopup
***********************************************************************************************

  local aPoint
  local nTop
  local nLeft

  if !::oDsgnMenuBar:oWnd:lPocketPc()
     if ::oDsgnMenuBar != nil
        aPoint := {::oDsgnMenuBar:aShapes[::oDsgnMenuBar:nOption]:aRect[3],;
                   ::oDsgnMenuBar:aShapes[::oDsgnMenuBar:nOption]:aRect[2]}
        aPoint := ClientToScreen( ::oDsgnMenuBar:oWnd:hWnd, aPoint )
        SetWindowPos ( ::hWnd, -1, aPoint[1], aPoint[2], 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
     endif
  endif

  SetFocus(::hWnd)

  if ::oDsgnMenuBar:oWnd:lPocketPC()
     if ::oDsgnMenuBar != nil
        aPoint := {::oDsgnMenuBar:aShapes[::oDsgnMenuBar:nOption]:aRect[1],;
                   ::oDsgnMenuBar:aShapes[::oDsgnMenuBar:nOption]:aRect[2]}
        aPoint := ClientToScreen( ::oDsgnMenuBar:oWnd:hWnd, aPoint )
        SetWindowPos ( ::hWnd, -1, aPoint[1]-::nHeight+2, aPoint[2], 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
     else
        nTop  := ::oMenuItemParent:oMenuParent:aRect[1]+::oMenuItemParent:aRect[1] - 3
        nLeft := ::oMenuItemParent:oMenuParent:aRect[4]-4
        SetWindowPos( ::hWnd, -1, nTop-::nHeight+::nHItem, nLeft, 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
        ::aRect := GetWndRect( ::hWnd )
     endif
  endif

  ::Refresh()
  ::aRect := GetWndRect( ::hWnd )

return nil



***************************************************************************************************************
   METHOD AddItem( cCaption ) CLASS TDsgnPopup
***************************************************************************************************************
  local oItem := TDsgnPopupItem():New( cCaption )

  aadd( ::aItems, oItem )

  ::GetNewSize()

return oItem

***************************************************************************************************************
  METHOD GetNewSize() CLASS TDsgnPopup
***************************************************************************************************************
local nMaxW := 0
local nH    := 5
local oItem

for each oItem in ::aItems
    nMaxW := max( nMaxW, oItem:nSize )
    if oItem:lSeparator
       nH += 7
    else
       nH += oItem:nHeight
       ::nHItem := oItem:nHeight + 5
    endif
next

nMaxW := 30 + nMaxW + 23

SetWindowPos( ::hWnd, 0, 0, 0, nMaxW, nH, SWP_NOMOVE )
::aRect := GetWndRect( ::hWnd )

return 0


***************************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TDsgnPopup
***************************************************************************************************************
local nLen := len( ::aItems )
local nTop, nLeft
local oPopup := self
local lControl := GetKeyState( VK_CONTROL )

   do case
      case nKey == VK_SPACE

           ::aItems[::nOption]:ChangeState()
           ::GetNewSize()
           ::Show()

      case  nKey == VK_DOWN

           if ::oDsgnMenuBar:oWnd:lPocketPC()
              ::nOption++
              if ::nOption > nLen
                 if ::oDsgnMenuBar != nil
                    ::nOption := nLen
                    ::Hide()
                    ::oDsgnMenuBar:oWnd:SetFocus()
                 else
                    ::nOption := 1
                 endif
              endif
           else
              ::nOption ++
              if ::nOption > nLen
                 if .t.
                    ::AddItem( "SubItem " + alltrim(str(len(::aItems)+1)) )
                 else
                    ::nOption := 1
                 endif
              endif
           endif
           ::Refresh()
           return 1

      case nKey == VK_UP

           if ::oDsgnMenuBar:oWnd:lPocketPC()
              ::nOption --
              if ::nOption < 1
                 if .t.
                    ::nOption := 1
                    ::AddItem( "SubItem " + alltrim(str(len(::aItems)+1)) )
                    ::Show()
                 else
                    ::nOption := nLen
                 endif
              endif
           else
              ::nOption--
              if ::nOption < 1
                 if ::oDsgnMenuBar != nil
                    ::nOption := 1
                    ::Hide()
                    ::oDsgnMenuBar:oWnd:SetFocus()
                 else
                    ::nOption := nLen
                 endif
              endif
           endif
           ::Refresh()
           return 1

      case nKey == VK_RIGHT

           ::aItems[::nOption]:GoRight( .t. ) //lControl )

           return 1

      case nKey == VK_LEFT

           if ::oDsgnMenuBar != nil
              ::Hide()
              ::oDsgnMenuBar:GoLeft()
           else
              if ::oMenuItemParent != nil
                 SetFocus( ::oMenuItemParent:oMenuParent:hWnd )
                 ::Hide()
              endif
           endif

           return 1

      case nKey == VK_DELETE

           ::DelCurItem()
           ::Show()

           return 1

      case nKey == VK_ESCAPE

           do while oPopup:oDsgnMenuBar == nil
              oPopup:Hide()
              oPopup := oPopup:oMenuItemParent:oMenuParent
           enddo
           oPopup:Hide()
           oPopup:oDsgnMenuBar:oWnd:SetFocus()

      case nKey == VK_RETURN

           ::Edit()

   endcase

return super:KeyDown( nKey, nFlags )

***************************************************************************************************************
   METHOD Paint() CLASS TDsgnPopup
***************************************************************************************************************
local hBmp
local hOldBmp
local hDCMem   := CreateCompatibleDC( ::hDC )
local n
local nLen     := len( ::aItems )
local nTop     := 3
local nLeft    := 3
local nBottom
local nRight
local nHeight  := ::nHeight
local nMode
local nWidth   := ::nWidth
local oItem
local lTemas := lTemas() .and. !::oDsgnMenuBar:oWnd:lPocketPC()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
local hOldFont, oFontPPC

hBmp           := CreateCompatibleBitmap( ::hDC, nWidth, nHeight )
hOldBmp        := SelectObject( hDCMem, hBmp )

if ::oDsgnMenuBar:oWnd:lPocketPC()
   oFontPPC := TFont():New( ::cFaceName, ::nWidthFont, ::nHeightFont, .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
   hFont := oFontPPC:hFont
else
   hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

hOldFont := SelectObject( hDCMem, hFont )

for n := 1 to nLen
    oItem := ::aItems[n]
    oItem:oMenuParent := self
    if n > 1
       nTop := ::aItems[n-1]:aRect[3]
    endif
    nBottom     := nTop + if( oItem:lSeparator, 7, oItem:nHLine )
    nRight      := ::nWidth-3
    oItem:aRect := {nTop,nLeft,nBottom,nRight}
next

FillSolidRect( hDCMem, {0,0,nHeight-1,nWidth-1}, if( ::oDsgnMenuBar:oWnd:lPocketPC() ,CLR_WHITE,GetSysColor( COLOR_MENU )), if( lTemas, CLR_HGRAY,CLR_WHITE) )

if ::oDsgnMenuBar:oWnd:lPocketPC()
   Box( hDCMem, {0,0,nHeight-1,nWidth-1}, 0 )
else
   if !lTemas
      DrawFrameControl(hDCMem, {0,0,nHeight,nWidth}, DFC_BUTTON, DFCS_BUTTONPUSH  )
   endif
endif

nMode := SetBkMode( hDCMem, TRANSPARENT )
for n := 1 to nLen
    oItem := ::aItems[n]
    oItem:Paint( hDCMem, ::nOption == n .and. GetClassName( GetFocus() ) == "TDSGNPOPUP" )
next
SetBkMode( hDCMem, nMode )

BitBlt( ::hDC, 0, 0, ::nWidth, ::nHeight, hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
SelectObject( hDCMem, hOldFont )
DeleteObject( hBmp )
DeleteDC    ( hDCMem )

if oFontPPC != nil
   oFontPPC:End()
endif

return 0

***************************************************************************************************************
   METHOD Hide() CLASS TDsgnPopup
***************************************************************************************************************

if ::aItems[::nOption]:oMenuHijo != nil
   ::aItems[::nOption]:oMenuHijo:Hide()
endif

return super:Hide()

***************************************************************************************************************
   METHOD LDblClick( nRow, nCol ) CLASS TDsgnPopup
***************************************************************************************************************

   ::Edit()

return 0



***************************************************************************************************************
   METHOD LButtonDown( nRow, nCol ) CLASS TDsgnPopup
***************************************************************************************************************
local oItem, n
local nLen := len( ::aItems )

for n := 1 to nLen

    oItem := ::aItems[n]

    if PtInRect( nRow, nCol, oItem:aRect )

       if ::aItems[::nOption]:oMenuHijo != nil
          ::aItems[::nOption]:oMenuHijo:Hide()
       endif

       ::nOption := n

       if oItem:oMenuHijo != nil
          oItem:oMenuHijo:Show()
          SetFocus(oItem:oMenuHijo:hWnd)
       else
          if GetFocus() == ::hWnd
             if ::aItems[::nOption]:lImage
                if nCol < 30
                   ::aItems[::nOption]:GetImage()
                endif
             endif
          endif
          ::SetFocus()
       endif
       ::Refresh()
       exit
    endif

next

return 0

***************************************************************************************************************
  METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDsgnPopup
***************************************************************************************************************
local oMenu
local oAnt

do case
   case nMsg == 8 // WM_KILLFOCUS
        if ( GetClassName(nWParam) != "TDSGNPOPUP" ) .and. GetClassName(GetParent(nWParam)) != "TDSGNPOPUP"
           if ::oHead != nil
              ::oHead:Hide()
           endif
        endif

   //case nMsg == WM_MBUTTONDOWN
   //     ::LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   //     ::DelCurItem()
endcase

return super:HandleEvent( nMsg, nWParam, nLParam )

/*
***************************************************************************************************************
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TDsgnPopup
***************************************************************************************************************

   local nWParam := 0
   local aPos := GetCursorPos(::hWnd)
   aPos := ScreenToClient( ::hWnd, aPos )

   if GetFocus() != ::hWnd
      return nil
   endif
   if IsOverWnd( ::hWnd, aPos[1], aPos[2] )
      if aPos[2] <= 12
         ::KeyDown( VK_LEFT )
      else
         if aPos[2] >= ::nWidth - 12
            ::KeyDown( VK_RIGHT )
         else
            if nDelta > 0
               ::KeyDown( VK_UP )
            else
               ::KeyDown( VK_DOWN )
            endif
         endif
      endif
   endif
return nil
*/
***************************************************************************************************
   METHOD Edit() CLASS TDsgnPopup
***************************************************************************************************
local oFont
local bValid := {||.t.}
local uVar
local oItem := ::aItems[::nOption]
local nTop, nLeft, nWidth, nHeight
local o := self
local nClrPane := CLR_WHITE //GetSysColor( COLOR_HIGHLIGHT )
local nClrTextF := 0 //CLR_WHITE

uVar := padr(oItem:cCaption, 100 )


DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

if !oItem:lSeparator

   nTop    := oItem:aRect[1]+3
   nLeft   := oItem:aRect[2]+ 29
   nWidth  := oItem:aRect[4]- oItem:aRect[2] -30
   nHeight := oItem:aRect[3]- oItem:aRect[1] -5

   ::oGet := TGet():New( nTop+1,;
                         nLeft+1,;
                         { | u | If( PCount()==0, uVar, uVar:= u ) },;
                         o,nWidth-2,nHeight-2,,,nClrTextF,nClrPane,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   ::nLastKey := 0
   ::oGet:SetFocus()

   ::oGet:bValid := {|| .t. }

   ::oGet:bLostFocus := {|| o:LostFocusEdit() }

   ::oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE,;
    ( o:nLastKey := nKey, o:oGet:End()), ) }

endif

return nil

***************************************************************************************************
   METHOD LostFocusEdit() CLASS TDsgnPopup
***************************************************************************************************

  ::oGet:Assign()

  ::oGet:VarPut( ::oGet:oGet:VarGet())

  if ::nLastKey != VK_ESCAPE
     ::aItems[::nOption]:cCaption := alltrim( ::oGet:oGet:VarGet())
  endif

  ::oGet:End()
  ::GetNewSize()
  SysWait(0.1)
  SetFocus(::hWnd)
  SysWait(0.1)
  ::Refresh()

return nil

*****************************************************************************************************
*****************************************************************************************************
   METHOD SysKeyChar( nKey, nKeyFlags ) CLASS TDsgnPopup
*****************************************************************************************************

if ::oHead != nil
   ::oHead:Hide()
endif

return 0


*****************************************************************************************************
   METHOD DelCurItem() CLASS TDsgnPopup
*****************************************************************************************************
local nLen := len( ::aItems )


   if ::aItems[::nOption]:oMenuHijo != nil
      MsgInfo( "No se puede borrar elementos con menús asociados","Atención")
      return 0
   endif
   adel( ::aItems, ::nOption )
   asize( ::aItems, nLen - 1 )
   if ::nOption == nLen
      ::nOption --
   endif
   if ::nOption < 1
      ::oHead := nil
      if ::oDsgnMenuBar != nil
         SetFocus( ::oDsgnMenuBar:oWnd:hWnd )
         ::oMenuItemParent:oMenuHijo := nil
         ::oDsgnMenuBar:oWnd:oSelected := ::oDsgnMenuBar
      else
         SetFocus( ::oMenuItemParent:oMenuParent:hWnd )
         ::oMenuItemParent:oMenuHijo := nil
      endif
      return ::End()
   else
      ::GetNewSize()
      ::Refresh()
   endif

return nil

***************************************************************************************************************
   METHOD GenRC( nLevel ) CLASS TDsgnPopup
*****************************************************************************************************
local cRet := ""
local n, nLen

cRet += space( nLevel * 4 )+"POPUP " + '"' + ::oMenuItemParent:cCaption + '"' + CRLF
cRet += space( nLevel * 4 )+ "{" + CRLF

nLen := len( ::aItems )

for n := 1 to nLen
    cRet += ::aItems[n]:GenRC( nLevel + 1 )
next

cRet += space( nLevel * 4 ) + "}" + CRLF

return cRet

***************************************************************************************************************
***************************************************************************************************************
***************************************************************************************************************

CLASS TDsgnPopupItem

      DATA aRect
      DATA nSize
      DATA nHeight
      DATA cxCaption
      DATA oMenuParent
      DATA oMenuHijo
      DATA cImage
      DATA lImage
      DATA lSeparator
      DATA nHeight
      DATA nItemId
      DATA nHLine
      DATA nState
      DATA nMaxState
      DATA lDisable
      DATA lChecked
      DATA lGrayed

      DATA cFaceName
      DATA nWidthFont
      DATA nHeightFont
      DATA lBold
      DATA lItalic
      DATA lUnderline
      DATA lStrikeOut


      METHOD New     ( cCaption ) CONSTRUCTOR
      METHOD Paint   ( hDC, lPaintFocus )
      METHOD cCaption( cNewVal )    SETGET
      METHOD GetNewId( )            INLINE ++nIdItem
      METHOD GoRight( lAdd )
      METHOD ChangeState()
      METHOD GetImage()
      METHOD GenRC( nLevel )

ENDCLASS

***************************************************************************************************************
  METHOD New( cCaption ) CLASS TDsgnPopupItem
***************************************************************************************************************

  ::nSize       := 0
  ::nHeight     := HLINE
  ::cCaption    := cCaption
  ::cImage      := ""
  ::lImage      := .f.
  ::lSeparator  := .f.
  ::nItemId     := ::GetNewId()
  ::nHLine      := HLINE
  ::nState      := 1
  ::nMaxState   := 5
  ::lDisable    := .f.
  ::lChecked    := .f.
  ::lGrayed     := .f.

  ::cFaceName        := "Tahoma" // buscar el nombre de la del sistema
  ::nWidthFont       := 0
  ::nHeightFont      := -12
  ::lBold            := .f.
  ::lItalic          := .f.
  ::lUnderline       := .f.
  ::lStrikeOut       := .f.


return self

***********************************************************************************************
   METHOD GenRC( nLevel ) CLASS TDsgnPopupItem
***********************************************************************************************
local cRet := ""


if ::oMenuHijo != nil
   cRet += ::oMenuHijo:GenRC( nLevel  )
else

   cRet += space( (nLevel) * 4 ) + "MENUITEM "

   if ::lSeparator
      cRet += " SEPARATOR"
   else
      cRet += +'"' + ::cCaption + '"'
      cRet += ", " + alltrim(str( ::nItemID ) )
      if ::lChecked
         cRet += ", CHECKED"
      endif
      if ::lGrayed
         cRet += ", CHECKED"
      endif
   endif
   cRet += CRLF
endif

return cRet

***********************************************************************************************
  METHOD ChangeState() CLASS TDsgnPopupItem
***********************************************************************************************
local nState := ::nState + 1

if nState > ::nMaxState
   nState := 1
endif
::nState := nState

do case
   case nState == 1        // normal
        ::lSeparator := .f.
        ::lChecked   := .f.
        ::lImage     := .f.
        ::lDisable   := .f.

   case nState == 2       // checked
        ::lSeparator := .f.
        ::lChecked   := .t.
        ::lImage     := .f.
        ::lDisable   := .f.

   case nState == 3
        ::lSeparator := .f.
        ::lChecked   := .f.
        ::lImage     := .t.
        ::lDisable   := .f.

   case nState == 4
        ::lSeparator := .f.
        ::lChecked   := .f.
        ::lImage     := .t.
        ::lDisable   := .t.

   case nState == 5
        ::lSeparator := .t.
        ::lChecked   := .f.
        ::lImage     := .f.
        ::lDisable   := .f.

endcase

return 0

***********************************************************************************************
  METHOD cCaption( cNew ) CLASS TDsgnPopupItem
***********************************************************************************************
local hDC
local oFontPPC

if cNew != nil
   ::cxCaption := cNew
   hDC         := GetDC( 0 )
   if ::oMenuParent:oDsgnMenuBar:oWnd:lPocketPC()
      oFontPPC := TFont():New( ::cFaceName, ::nWidthFont, ::nHeightFont, .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
      hFont := oFontPPC:hFont
   else
      hFont := GetStockObject( DEFAULT_GUI_FONT )
   endif
   ::nSize     := GetTextWidth( hDC, ::cxCaption, hFont )
   ReleaseDC( 0, hDC )

   if ::oMenuParent:oDsgnMenuBar:oWnd:lPocketPC()
      oFontPPC:End()
   endif

endif

return ::cxCaption

***************************************************************************************************************
   METHOD Paint( hDC, lPaintFocus ) CLASS TDsgnPopupItem
***************************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local hFont, hOldFont, hBmp
local nWidth, nHeight
local hTheme, nColor, nClrtext
local lOption := ::oMenuParent:aItems[::oMenuParent:nOption]:nItemId == ::nItemId
local lTemas  := lTemas() .and. !::oMenuParent:oDsgnMenuBar:oWnd:lPocketPC()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
local oFont
local cImage := ::cImage
local nLeft := rc[2]

   if lPaintFocus == nil; lPaintFocus := .f.; endif

   nWidth  := ::aRect[4]-::aRect[2]
   nHeight := ::nHLine

   if ::lSeparator
      rc := {::aRect[1]+2,::aRect[2],::aRect[1]+3,::aRect[4]}
      FillSolidRect( hDC, rc, rgb( 172,168,153) )
      return 0
   endif

   if lPaintFocus
      nColor := GetSysColor( COLOR_HIGHLIGHT )
      FillSolidRect( hDC, rc, nColor )
   endif

   if ::cImage != "" .or. ::lImage
      nLeft   += 6
      rc[4]   := nLeft + 20
      nWidth  := rc[4]-nLeft
      nHeight := rc[3]-rc[1]

      hBmp := ReadBitmap( hDC, cImage )
      if hBmp == 0
         hBmp := LoadBitmap( GetResources(), "bmpmenu" )
      endif
      if hBmp != 0
         if ::lDisable
            DrawState( hDC, nil, hBmp, nLeft, rc[1] + (nHeight/2) - (nBmpHeight(hBmp)/2), 16, 16, nOr( 4, 32 ) )
         else
            DrawMasked( hDC, hBmp, rc[1] + (nHeight/2) - (nBmpHeight(hBmp)/2), nLeft, 16, 16 )
         endif
         DeleteObject( hBmp )
      endif
      rc[2] += 30
      rc[4] := ::aRect[4]
   else
      rc[2] += 30
      rc[4] := ::aRect[4]-15
   endif

   if ::lChecked
      hBmp := LoadBitmap( GetResources(), if( lPaintFocus,"bchecked","nchecked") )
      DrawMasked( hDC, hBmp, rc[1] + 7, ::aRect[2]+7 )
      DeleteObject( hBmp )
   endif

   if lPaintFocus
      nClrText := SetTextColor( hDC, if( ::lDisable, rgb( 172,168,153), CLR_WHITE ) )
   else
      nClrText := SetTextColor( hDC, if( ::lDisable, rgb( 172,168,153), 0 ) )
   endif

   DrawText(hDC, ::cCaption, rc, nOr( DT_VCENTER, DT_SINGLELINE ) )

   if ::oMenuHijo != nil
      hBmp := LoadBitmap( GetResources(), if( lPaintFocus, "armenu2","armenu1") )
      DrawMasked( hDC, hBmp, rc[1]+ 5, ::aRect[4] - 9 )
      DeleteObject( hBmp )
   endif

   SetTextColor( hDC, nClrText )

return 0

****************************************************************************************************
   METHOD GoRight( lAdd ) CLASS TDsgnPopupItem
****************************************************************************************************
local nTop, nLeft

if lAdd == nil; lAdd := .f.; endif

if ::oMenuHijo != nil
   ::oMenuHijo:Show()
   SetFocus( ::oMenuHijo:hWnd )
else
   if lAdd
      nTop  := ::oMenuParent:aRect[1]+::aRect[1] - 3
      nLeft := ::oMenuParent:aRect[4]-4
      ::oMenuHijo := TDsgnPopup():New()
      ::oMenuHijo:oHead := ::oMenuParent:oHead
      ::oMenuHijo:oMenuItemParent := self
      ::oMenuHijo:AddItem( "SubItem " + alltrim(str(len( ::oMenuHijo:aItems )+1)) )
      SetWindowPos( ::oMenuHijo:hWnd, -1, nTop, nLeft, 0, 0, nOr( SWP_NOSIZE, SWP_SHOWWINDOW ) )
      ::oMenuHijo:aRect := GetWndRect( ::oMenuHijo:hWnd )
      SetFocus( ::oMenuHijo:hWnd )
      ::oMenuParent:Refresh()
   endif
endif

return nil

****************************************************************************************************
   METHOD GetImage() CLASS TDsgnPopupItem
****************************************************************************************************
local cFiltro := "Imágenes (*.bmp *.gif *.jpg *.ico *.cur ) | *.bmp;*.gif;*.jpg;*.ico;*.cur; |"
local cFiles := cGetFile( cFiltro, "Selecciona imagen" )

::cImage := cFiles

::oMenuParent:Refresh()


return nil





#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

/*
HB_FUNC(  )
{

}
*/

HB_FUNC( DRAWSTATE )
{

hb_retl( DrawState( ( HDC )  hb_parnl( 1 ),
                    (HBRUSH) hb_parnl( 2 ),
                                      NULL,
                    (LPARAM) hb_parnl( 3 ),
                    (WPARAM)           0  ,
                             hb_parni( 4 ),
                             hb_parni( 5 ),
                             hb_parni( 6 ),
                             hb_parni( 7 ),
                             hb_parnl( 8 ) ) );
}

#pragma ENDDUMP
