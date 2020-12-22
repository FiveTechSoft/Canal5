#include "fivewin.ch"

                                                                                               #define DT_BOTTOM                            8
                                                                                               #define DT_CALCRECT                       1024
                                                                                               #define DT_CENTER                            1
                                                                                               #define DT_END_ELLIPSIS             0x00008000
                                                                                               #define DT_EXPANDTABS                       64
                                                                                               #define DT_EXTERNALLEADING                 512
                                                                                               #define DT_INTERNAL                       4096
                                                                                               #define DT_LEFT                              0
                                                                                               #define DT_NOCLIP                          256
                                                                                               #define DT_NOPREFIX                       2048
                                                                                               #define DT_RIGHT                             2
                                                                                               #define DT_SINGLELINE                       32
                                                                                               #define DT_TABSTOP                         128
                                                                                               #define DT_TOP                               0
                                                                                               #define DT_VCENTER                           4
                                                                                               #define DT_WORDBREAK                        16
                                                                                               #define DT_WORD_ELLIPSIS            0x00040000

static oWnd


function main( nTop, nLeft, nWidth, nHeight, lDisenio )

local oBar
local oReport

if lDisenio == nil; lDisenio := .t.; endif
if nTop     == nil; nTop     := 60; endif
if nLeft    == nil; nLeft    := 260; endif
if nWidth   == nil; nWidth   := 600; endif
if nHeight  == nil; nHeight  := 800; endif


    if lDisenio
       DEFINE WINDOW oWnd TITLE "Reports" COLOR 0, rgb( 240,248,255)


           DEFINE BUTTONBAR oBar OF oWnd 3D

              DEFINE BUTTON OF oBar ACTION oReport:Nuevo() FILE "smallbmp\Nuevo.bmp"         NOBORDER
              DEFINE BUTTON OF oBar ACTION oReport:Abrir() FILE "smallbmp\abrir.bmp"         NOBORDER
              DEFINE BUTTON OF oBar ACTION oReport:Save()  FILE "smallbmp\save.bmp"          NOBORDER

              DEFINE BUTTON OF oBar ACTION oReport:Cut()   FILE "smallbmp\cut.bmp"           NOBORDER  GROUP
              DEFINE BUTTON OF oBar ACTION oReport:Copy()  FILE "smallbmp\copy.bmp"          NOBORDER
              DEFINE BUTTON OF oBar ACTION oReport:Paste() FILE "smallbmp\paste.bmp"         NOBORDER  GROUP

              DEFINE BUTTON OF oBar ACTION AddItem( 1, oReport )   FILE "btns\2.bmp"
              DEFINE BUTTON OF oBar ACTION AddItem( 9, oReport )   FILE "btns\21.bmp"
              DEFINE BUTTON OF oBar ACTION AddItem(13, oReport )   FILE "btns\1.bmp"
                                                                     //
              DEFINE BUTTON OF oBar ACTION oReport:Align(1) FILE "smallbmp\top.bmp"          NOBORDER  GROUP
              DEFINE BUTTON OF oBar ACTION oReport:Align(2) FILE "smallbmp\left.bmp"         NOBORDER
              DEFINE BUTTON OF oBar ACTION oReport:Align(3) FILE "smallbmp\down.bmp"         NOBORDER
              DEFINE BUTTON OF oBar ACTION oReport:Align(4) FILE "smallbmp\right.bmp"        NOBORDER

              DEFINE BUTTON PROMPT  "1" OF oBar  ACTION oReport:Zoom(1) GROUP
              DEFINE BUTTON PROMPT  "2" OF oBar  ACTION oReport:Zoom(2)
              DEFINE BUTTON PROMPT  "3" OF oBar  ACTION oReport:Zoom(3)
              DEFINE BUTTON PROMPT  "4" OF oBar  ACTION oReport:Zoom(4)
              DEFINE BUTTON PROMPT  "5" OF oBar  ACTION oReport:Zoom(5)
              DEFINE BUTTON PROMPT  "6" OF oBar  ACTION oReport:Zoom(6)
              DEFINE BUTTON PROMPT  "7" OF oBar  ACTION oReport:Zoom(7)
              DEFINE BUTTON PROMPT  "8" OF oBar  ACTION oReport:Zoom(8)
              DEFINE BUTTON PROMPT  "9" OF oBar  ACTION oReport:Zoom(9)
              DEFINE BUTTON PROMPT "10" OF oBar ACTION oReport:Zoom(10)


              DEFINE BUTTON OF oBar ACTION (oReport:lDisenio := !oReport:lDisenio,oReport:Refresh()) GROUP


    endif

    oReport := TC5Report():New( nTop, nLeft, nWidth, nHeight, oWnd )
    oReport:lDisenio := lDisenio

    if lDisenio
       ACTIVATE WINDOW oWnd MAXIMIZED
    endif

return 0

function AddItem( nType, oReport )
                                                                                                           //"bmps\image11_2.bmp"
local oItem := TC5RptItem():New( oReport, 10,    10,    69,     35, "Prueba item", "bmps\image11.bmp" ,  ,,        ,       , nType )
                       //      ( oWnd,  nTop, nLeft, nWidth, nHeight, cPrompt, cBmp, bAction, cBmpOver, lEnable, nColor, nType )
oReport:AddItem( oItem )
oReport:Refresh()

return nil








CLASS TC5Report FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aItems            AS ARRAY INIT {}
      DATA aConectings       AS ARRAY INIT {}
      DATA oOver
      DATA oSelected
      DATA nOldRow
      DATA nOldCol
      DATA nPtOver           AS NUMERIC INIT 0
      DATA oGet
      DATA aUndo             AS ARRAY   INIT {}
      DATA lDisenio          AS LOGICAL INIT .F.
      DATA aFocusRect        AS ARRAY   INIT {}
      DATA lSelecteds        AS LOGICAL INIT .F.
      DATA hBmpMem
      DATA aSize             AS ARRAY   INIT {0,0}
      DATA lConecting        AS LOGICAL INIT .F.
      DATA hGiro
      DATA nOldAngulo
      DATA aOldPoints
      DATA nRadio
      DATA nZoom             AS NUMERIC INIT 1
      DATA aOrgSize          AS ARRAY INIT {0,0}

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR
      METHOD Redefine( nId, oWnd ) CONSTRUCTOR
      METHOD AddItem( oItem ) INLINE aadd(::aItems, oItem ), ::Refresh(.f.)

      METHOD Destroy()        INLINE DeleteObject( ::hBmpMem ), DestroyCursor(::hGiro),super:Destroy()
      METHOD Display() INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Paint()
      METHOD LButtonDown( nRow, nCol )
      METHOD MouseMove( nRow, nCol )
      METHOD LButtonUp( nRow, nCol )
      METHOD LDblClick( nRow, nCol, nKeyFlags )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD KeyDown( nKey, nFlags )
      METHOD GetOver( nRow, nCol )
      METHOD HandleEvent( nMsg, nWParam, nLParam ) INLINE if( nMsg == 20, 1, super:HandleEvent( nMsg, nWParam, nLParam ) )
      METHOD Nuevo()
      METHOD Abrir()
      METHOD Save()
      METHOD Load( cIdDiagram )

      METHOD Copy(lClipBoard)
      METHOD Paste()
      METHOD Cut()
      METHOD Delete()
      METHOD Reset()        INLINE asize(::aItems,0), ::Refresh(.t.)
      METHOD Zoom( nZoom )
      METHOD nFactorZoom()

      METHOD Align( nType )
      METHOD AlCenter()
      METHOD SelectAll()

      METHOD MoveItem( cDir )

ENDCLASS

***********************************************************************************************************
      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrText, nClrPane ) CLASS TC5Report
***********************************************************************************************************

  if nClrText  == nil ; nClrText     := CLR_BLACK ; endif
  if nClrPane  == nil ; nClrpane     := CLR_WHITE ; endif

msginfo( 'Ep', Procname(0) )

  ::oWnd       := oWnd
  ::nTop       := nTop
  ::nLeft      := nLeft
  ::nBottom    := ::nTop + nHeight
  ::nRight     := ::nLeft + nWidth
  ::aOrgSize   := {nWidth,nHeight}

  ::aItems     := {}
  ::nClrText   := nClrText
  ::nClrPane   := nClrPane
  ::hGiro   := LoadCursor(GetResources(),"giro")

  ::nStyle  := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER )

  ::nId     := ::GetNewId()
  ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )


  if ! Empty( oWnd:hWnd )
     ::Create()
     ::lVisible = .t.
     oWnd:AddControl( Self )
  else
     oWnd:DefControl( Self )
     ::lVisible  = .f.
  endif

return self

***********************************************************************************************************************************
  METHOD Redefine( nId, oWnd, nClrText, nClrPane ) CLASS TC5Report
***********************************************************************************************************************************

  if nClrText  == nil ; nClrText     := CLR_BLACK        ; endif
  if nClrPane  == nil ; nClrpane     := rgb(240,248,255) ; endif

  ::oWnd       := oWnd
  ::nId        := nId

  ::aItems     := {}
  ::nClrText   := nClrText
  ::nClrPane   := nClrPane

  ::Register()

  ::oWnd:DefControl( Self )
  ::lVisible  = .f.

return self



***********************************************************************************************************
      METHOD LButtonDown( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local oOver := ::GetOver( nRow, nCol )
local nLen := len(::aItems)
local n
local oItem
local x, y, h

SetFocus(::hWnd)

::Capture()

if !::lDisenio
   ::lCaptured := .t.
   ::oOver     := oOver
   if ::oOver != nil
      ::Refresh()
   endif
else
   ::nOldRow    := nRow
   ::nOldCol    := nCol
   if oOver != nil
      ::oOver     := oOver
      ::oSelected := oOver
      if ::lSelecteds
         for n := 1 to nLen
             oItem := ::aItems[n]
             if oItem:lSelected
                //oItem:aOldPos := {oItem:nTop, oItem:nLeft, oItem:nWidth, oItem:nHeight}
                oItem:aOldPos := {oItem:nTop, oItem:nLeft, oItem:nWidth, oItem:nHeight}
             endif
         next
      else
         ::oOver:aOldPos   := {::oOver:nTop, ::oOver:nLeft, ::oOver:nWidth, ::oOver:nHeight}
      endif
      ::lCaptured := .t.
      CursorArrow()
      ::Refresh(.f.)

   else
      if ::oSelected != nil
         ::nPtOver := ::oSelected:IsOverPt( nRow, nCol )
      endif
      if ::nPtOver != 0
         ::oSelected:aOldPos := {::oSelected:nTop, ::oSelected:nLeft, ::oSelected:nWidth, ::oSelected:nHeight}
         ::lCaptured := .t.
      else
         ::lCaptured := .t.
         ::oSelected := nil
      endif
      ::Refresh(.f.)
      if ::oSelected != nil
         ::aOldPoints := {}
         for n := 1 to len(::oSelected:aPoints)
             aadd( ::aOldPoints, {::oSelected:aPoints[n,1],::oSelected:aPoints[n,2]} )
         next
      endif
   endif
endif

return 0

***********************************************************************************************************
      METHOD MouseMove( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local oOldOver := ::oOver
local nLen
local n, n2
local oItem
local h, nDH
local nY
local nX
local x, y
local radio

if nRow > 32768 ;   nRow -= 65535; endif
if nCol > 32768 ;   nCol -= 65535; endif


if ::lCaptured

   if ::lDisenio

      if ::oOver != nil
         nLen := len(::aItems)
         CursorHand()

         if ::lSelecteds
            for n := 1 to nLen
                oItem := ::aItems[n]
                if oItem:lSelected
                   oItem:nTop     := oItem:aOldPos[1]+( nRow - ::nOldRow  )
                   oItem:nLeft    := oItem:aOldPos[2]+( nCol - ::nOldCol  )
                   oItem:nBottom  := oItem:nTop +  oItem:aOldPos[4]
                   oItem:nRight   := oItem:nLeft + oItem:aOldPos[3]
                endif
            next
         else
            ::oOver:nTop     := (::oOver:aOldPos[1]+( nRow - ::nOldRow  ))/::nFactorZoom()
            ::oOver:nLeft    := (::oOver:aOldPos[2]+( nCol - ::nOldCol  ))/::nFactorZoom()
            ::oOver:nBottom  := (::oOver:nTop  +  ::oOver:aOldPos[4]     )/::nFactorZoom()
            ::oOver:nRight   := (::oOver:nLeft + ::oOver:aOldPos[3]      )/::nFactorZoom()
         endif
      else

         if ::oSelected != nil
            if ::nPtOver != 0
               do case
                  case ::nPtOver == 1
                       ::oSelected:nTop    := (::oSelected:aOldPos[1]+( nRow - ::nOldRow  )                       )/::nFactorZoom()
                       ::oSelected:nLeft   := (::oSelected:aOldPos[2]+( nCol - ::nOldCol  )                       )/::nFactorZoom()
                  case ::nPtOver == 2
                       ::oSelected:nTop    := (::oSelected:aOldPos[1]+( nRow - ::nOldRow  )                       )/::nFactorZoom()
                  case ::nPtOver == 3
                       ::oSelected:nTop    := (::oSelected:aOldPos[1]+( nRow - ::nOldRow  )                       )/::nFactorZoom()
                       ::oSelected:nRight  := (::oSelected:aOldPos[2]+::oSelected:aOldPos[3]+( nCol - ::nOldCol  ))/::nFactorZoom()
                  case ::nPtOver == 4
                       ::oSelected:nRight  := (::oSelected:aOldPos[2]+::oSelected:aOldPos[3]+( nCol - ::nOldCol  ))/::nFactorZoom()
                  case ::nPtOver == 5
                       ::oSelected:nBottom := (::oSelected:aOldPos[1]+::oSelected:aOldPos[4]+( nRow - ::nOldRow  ))/::nFactorZoom()
                       ::oSelected:nRight  := (::oSelected:aOldPos[2]+::oSelected:aOldPos[3]+( nCol - ::nOldCol  ))/::nFactorZoom()
                  case ::nPtOver == 6
                       ::oSelected:nBottom := (::oSelected:aOldPos[1]+::oSelected:aOldPos[4]+( nRow - ::nOldRow  ))/::nFactorZoom()
                  case ::nPtOver == 7
                       ::oSelected:nBottom := (::oSelected:aOldPos[1]+::oSelected:aOldPos[4]+( nRow - ::nOldRow  ))/::nFactorZoom()
                       ::oSelected:nLeft   := (::oSelected:aOldPos[2]+( nCol - ::nOldCol  )                       )/::nFactorZoom()
                  case ::nPtOver == 8
                       ::oSelected:nLeft   := (::oSelected:aOldPos[2]+( nCol - ::nOldCol  )                       )/::nFactorZoom()
               endcase

            endif
         else
            // Seleccionando
            ::aFocusRect := {min(::nOldRow,nRow), min(::nOldCol,nCol), max(::nOldRow,nRow), max(::nOldCol,nCol)}
            ::Refresh()
         endif

      endif
      ::Refresh(.F.)
   endif

else

   if !::lDisenio
      ::oOver := ::GetOver( nRow, nCol )
      if ::oOver != nil .or. ::oOver != oOldOver
         ::Refresh()
      endif
      if ::oOver != nil
         CursorHand()
      endif
   else
      if ::oSelected != nil
         ::nPtOver := ::oSelected:IsOverPt( nRow, nCol )
      endif
      if ::nPtOver != 0
         do case
            case ::nPtOver == -1
                 SetCursor( ::hGiro )
            case ::nPtOver == 1   // NW
                 CursorNW()
            case ::nPtOver == 2   // N
                 CursorNS()
            case ::nPtOver == 3   // NE
                 CursorNE()
            case ::nPtOver == 4   // E
                 CursorWE()
            case ::nPtOver == 5   // SE
                 CursorNW()
            case ::nPtOver == 6   // S
                 CursorNS()
            case ::nPtOver == 7   // SW
                 CursorNE()
            case ::nPtOver == 8   // W
                 CursorWE()
         endcase
      else
         CursorArrow()
      endif
   endif
endif


return 0

***********************************************************************************************************
      METHOD LButtonUp( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local oOldOver := ::oOver
local n
local nLen := len(::aItems )

ReleaseCapture()

if ::lCaptured
   ::nOldRow   := nil
   ::nOldCol   := nil
   ::lCaptured := .f.
   ::nPtOver   := 0
   ::oOver     := nil
   if !::lDisenio
      if oOldOver != nil
         if oOldOver:bAction != nil
            eval(oOldOver:bAction)
         endif
      endif
   else

      if !empty(::aFocusRect)
         //Selecciono items
         for n := 1 to nLen
             ::aItems[n]:lSelected := IntersectRect( ::aFocusRect, {::aItems[n]:nTop,::aItems[n]:nLeft,::aItems[n]:nBottom,::aItems[n]:nRight} )
             if ::aItems[n]:lSelected
                ::lSelecteds := .t.
             endif
         next
      else
         if oOldOver != nil .and. oOldOver:lSelected
            ::lSelecteds := .f.
         else
            for n := 1 to nLen
                ::aItems[n]:lSelected := .f.
                ::aItems[n]:aOldPos := {0,0,0,0}
            next

         endif
      endif
   endif
   ::Refresh(.F.)
endif
::aFocusRect := {}

return 0

***********************************************************************************************************
      METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TC5Report
***********************************************************************************************************
local n
local nLen
local oOver := ::GetOver( nRow, nCol )
local lEntra := .f.
local oMenu

//::LButtonDown( nRow, nCol )
//::LButtonUp( nRow, nCol )

//if oOver == nil
//   return 0
//endif

MENU oMenu POPUP
   if oOver != nil
      MENUITEM "Cut" ACTION ::Cut()
      MENUITEM "Copy" ACTION ::Copy()
   endif
   MENUITEM "Paste" ACTION ::Paste()
ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF Self



return 0

***********************************************************************************************************
      METHOD LDblClick( nRow, nCol, nKeyFlags )  CLASS TC5Report
***********************************************************************************************************

if ::oSelected == nil
   return 0
endif

if PtInRect( nRow, nCol, ::oSelected:aText )
   ::oSelected:EditText()
else
   if PtInRect( nRow, nCol, ::oSelected:aBmp )
      ::oSelected:EditBmp(GetKeyState(VK_CONTROL))
   endif
endif

return 0

***********************************************************************************************************
      METHOD KeyDown( nKey, nFlags )  CLASS TC5Report
***********************************************************************************************************

 do case
    case nKey == VK_UP
         ::MoveItem( "up" )
    case nKey == VK_DOWN
         ::MoveItem( "down" )
    case nKey == VK_LEFT
         ::MoveItem( "left" )
    case nKey == VK_RIGHT
         ::MoveItem( "right" )
    case nKey == VK_DELETE
         ::Delete()
    case (nKey == asc("C").or. nKey ==asc("c")) .and. GetKeyState(VK_CONTROL)
         ::Copy()
    case (nKey == asc("V").or. nKey ==asc("v")) .and. GetKeyState(VK_CONTROL)
         ::Paste()
    case (nKey == asc("X").or. nKey ==asc("x")) .and. GetKeyState(VK_CONTROL)
         ::Cut()

 endcase



return 0


***********************************************************************************************************
      METHOD GetOver( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
 local n
 local nLen := len( ::aItems )

 for n := nLen to 1 step -1

     if ::aItems[n]:IsOver( nRow, nCol )
        return ::aItems[n]
     endif
 next

 return nil

***********************************************************************************************************
      METHOD Paint() CLASS TC5Report
***********************************************************************************************************
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local rc      := GetClientRect(::hWnd)
local hBmpMem
local hOldBmp
local n
local nLen := len( ::aItems )
//local oBrush := TBrush():New(,,"brush.bmp")

if rc[4]-rc[2] != ::aSize[1] .or. rc[3]-rc[1] != ::aSize[2]
   if ::hBmpMem == nil
      DeleteObject( ::hBmpMem )
   endif
   ::aSize := {rc[4]-rc[2], rc[3]-rc[1]}
   ::hBmpMem := CreateCompatibleBitmap( hDC, ::aSize[1], ::aSize[2] )
endif

hOldBmp := SelectObject( hDCMem, ::hBmpMem )


FillSolidRect( hDCMem, rc, ::nClrPane )
//FillRect(hDCMem, rc, oBrush:hBrush )

//oBrush:End()

for n := 1 to nLen
    if ::oSelected != nil .and. ::oSelected:nId == ::aItems[n]:nID
    else
       ::aItems[n]:Paint( hDCMem )
    endif
next
if ::oSelected != nil
   ::oSelected:Paint( hDCMem )
endif

if !empty(::aFocusRect)
   DrawFocusRect(hDCMem, ::aFocusRect[1], ::aFocusRect[2], ::aFocusRect[3], ::aFocusRect[4] )
endif



BitBlt( ::hDC, 0, 0, rc[4]-rc[2], rc[3]-rc[1], hDCMem, 0, 0, 13369376 )
SelectObject( hDCMem, hOldBmp )
DeleteDC( hDC )
DeleteDC( hDCMem )

return 0

***********************************************************************************************************************************
      METHOD Nuevo() CLASS TC5Report
***********************************************************************************************************************************

if MsgYesNo( "¿Desea salvar el documento activo?")
   ::Save()
endif
::Reset()

return 0

***********************************************************************************************************************************
      METHOD Abrir() CLASS TC5Report
***********************************************************************************************************************************


return 0

***********************************************************************************************************************************
      METHOD Save() CLASS TC5Report
***********************************************************************************************************************************
local aStruct := {{"IDDIAG" ,"C",  5,0},;
                  {"TYPE"   ,"N",  2,0},;
                  {"TEXT"   ,"C", 60,0},;
                  {"BMP"    ,"C", 30,0},;
                  {"BMPOVER","C", 30,0},;
                  {"TOP"    ,"N",  4,0},;
                  {"LEFT"   ,"N",  4,0},;
                  {"WIDTH"  ,"N",  4,0},;
                  {"HEIGHT" ,"N",  4,0},;
                  {"CACTION","C", 80,0},;
                  {"FOTO",   "C", 60,0}}
local n

if !file( "menudiag.dbf" )
   DbCreate( "menudiag.dbf", aStruct )
endif

DbUseArea( .T., nil, "menudiag", "menudiag", .T. )

for n := 1 to len( ::aItems )
     menudiag->(DbAppend())
     //menudiag->IDDIAG     := //::GetID()
     menudiag->TYPE       := ::aItems[n]:nType
     menudiag->TEXT       := ::aItems[n]:cPrompt
     menudiag->BMP        := ::aItems[n]:cBmp
     menudiag->BMPOVER    := ::aItems[n]:cBmpOver
     menudiag->TOP        := ::aItems[n]:nTop
     menudiag->LEFT       := ::aItems[n]:nLeft
     menudiag->WIDTH      := ::aItems[n]:nWidth
     menudiag->HEIGHT     := ::aItems[n]:nHeight
     menudiag->CACTION    := ::aItems[n]:cAction
  //   menudiag->FOTO       := //::GetThumbNail()
next

DbCloseArea("menudiag")

return 0

***********************************************************************************************************************************
      METHOD Load( cIdDiagram ) CLASS TC5Report
***********************************************************************************************************************************
local oItem

asize(::aItems, 0 )
::Refresh()

DbUseArea( .T., nil, "menudiag", "menudiag", .T. )

// localizar los ids del cIdDiagram

do while !menudiag->( EOF() ) .and. menudiag->IDDIAG == cIdDiagram

     oItem := TC5RptItem():New( self, menudiag->TOP    ,;
                                    menudiag->LEFT   ,;
                                    menudiag->WIDTH  ,;
                                    menudiag->HEIGHT ,;
                                    menudiag->TEXT   ,;
                                    menudiag->BMP    ,;
                                    menudiag->cAction,;
                                    menudiag->BMPOVER,;
                                    .t.,,             ;
                                    menudiag->TYPE )
     ::AddItem( oItem )

     menudiag->(DbSkip())

enddo

DbCloseArea("menudiag")

return 0






***********************************************************************************************************************************
   METHOD Copy(lClipBoard) CLASS TC5Report
***********************************************************************************************************************************
local cStr := ""
local oClp
local n
local nLen := len(::aItems)
local oItem

if lClipBoard == nil; lClipBoard := .t.; endif

if ::oSelected == nil .and. !::lSelecteds
   ? "Seleccione un elemento"
   return 0
endif

if ::lSelecteds
   for n := 1 to nLen
       oItem := ::aItems[n]
       if oItem:lSelected
          cStr +=     oItem:ClassName()          + "|"
          cStr += astr(oItem:nTop)               + "|"
          cStr += astr(oItem:nLeft)              + "|"
          cStr += astr(oItem:nWidth)             + "|"
          cStr += astr(oItem:nHeight)            + "|"
          cStr += alltrim(oItem:cPrompt)         + "|"
          cStr += alltrim(oItem:cBmp)            + "|"
          cStr += alltrim(oItem:cBmpOver)        + "|"
          cStr += if(oItem:lEnable,".t.",".f.")  + "|"
          cStr += astr( oItem:nColor )           + "|"
          cStr += astr( oItem:nType )            + "|" + CRLF
       endif
   next
else
   cStr +=     ::oSelected:ClassName()          + "|"
   cStr += astr(::oSelected:nTop)               + "|"
   cStr += astr(::oSelected:nLeft)              + "|"
   cStr += astr(::oSelected:nWidth)             + "|"
   cStr += astr(::oSelected:nHeight)            + "|"
   cStr += alltrim(::oSelected:cPrompt)         + "|"
   cStr += alltrim(::oSelected:cBmp)            + "|"
   cStr += alltrim(::oSelected:cBmpOver)        + "|"
   cStr += if(::oSelected:lEnable,".t.",".f.")  + "|"
   cStr += astr( ::oSelected:nColor )           + "|"
   cStr += astr( ::oSelected:nType )            + "|"
endif

if lClipBoard
   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if oClp:Open()
      oClp:Clear()
      oClp:SetText( cStr )
      oClp:End()
   else
      MsgAlert( "The clipboard is not available now!" )
   endif
endif

return cStr

***********************************************************************************************************************************
   METHOD Paste(cStr) CLASS TC5Report
***********************************************************************************************************************************
local oClp
local aParams
local oItem
local lClipBoard := .t.
local nLines := 0
local cLine := ""
local n
if cStr != nil
   lClipBoard := .f.
endif


if lClipBoard
   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if oClp:Open()
      cStr := oClp:GetText()
      oClp:End()
   else
      MsgAlert( "The clipboard is not available now!" )
   endif
endif



if left( cStr, 8 ) != "TC5RptItem"
   ? "formato no válido","Corrija"
   return 0
endif

SetFocus(::hWnd)

nLines := strcount( cStr, CRLF )

if nLines > 1
   for n := 1 to len(::aItems)
       ::aItems[n]:lSelected := .f.
   next
   for n := 1 to nLines
       cLine := alltrim(memoline(cStr,500,n))
       aParams := aSplit( cLine, "|" )
       oItem := TC5RptItem():New( self, val(aParams[2])-10, val(aParams[3])-10, val(aParams[4]),val(aParams[5]),aParams[6], aParams[7] ,  , aParams[8],aParams[9]==".t." ,val(aParams[10]),val(aParams[11]))
       oItem:lSelected := .t.
       ::AddItem( oItem )
   next
   ::lSelecteds := .t.

else
   aParams := aSplit( cStr, "|" )
   oItem := TC5RptItem():New( self, 10, 10, val(aParams[4]),val(aParams[5]),aParams[6], aParams[7] ,  , aParams[8],aParams[9]==".t." ,val(aParams[10]),val(aParams[11]))
   ::AddItem( oItem )
endif

return 0

***********************************************************************************************************************************
   METHOD Cut() CLASS TC5Report
***********************************************************************************************************************************

::Copy()
::Delete(.f.)


return 0


***********************************************************************************************************************************
   METHOD Delete(lMsg) CLASS TC5Report
***********************************************************************************************************************************
local n       := 1
local nCount  := 0
local nDels   := 0
local nLen    := len(::aItems)
local cStr    := ""
local lDelete := .t.

if lMsg == nil; lMsg := .t.; endif

if ::oSelected != nil .or. ::lSelecteds

   if lMsg
      lDelete := MsgYesNo( "¿Estás seguro de borrarlo?" )
   endif

   if lDelete

      if ::lSelecteds
         do while nCount++ < nLen
            if ::aItems[n]:lSelected
               adel(::aItems, n )
               nDels++
            else
               n++
            endif
         enddo
         asize(::aItems, nLen-nDels)
         ::lSelecteds := .f.
      else
         for n := 1 to nLen
             if ::aItems[n]:nId == ::oSelected:nId
                 adel( ::aItems, n )
                 asize( ::aItems, nLen-1)
                 exit
             endif
         next
      endif
      ::Refresh(.t.)
   endif
endif

return 0

***********************************************************************************************************************************
      METHOD Align( nType ) CLASS TC5Report
***********************************************************************************************************************************
local nMinTop    := 3000
local nMinLeft   := 3000
local nMaxBottom := 0
local nMaxRight  := 0
local nLen := len(::aItems)
local oItem
local nAux
local n
local nMedW := ::nWidth/2
local nMedH := ::nHeight/2


if ::lSelecteds
   for n := 1 to nLen
       oItem := ::aItems[n]
       if oItem:lSelected
          nMinTop    := min( oItem:nTop, nMinTop )
          nMinLeft   := min( oItem:nLeft, nMinLeft )
          nMaxBottom := max( oItem:nBottom, nMaxBottom )
          nMaxRight  := max( oItem:nRight, nMaxRight )
       endif
   next
else
   ? "seleccione elementos"
   return 0
endif

do case
   case nType == 1 // alinear a arriba
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nTop
               oItem:nTop := nMinTop
               oItem:nBottom := oItem:nTop + oItem:nBottom - nAux
            endif
        next

   case nType == 2 // alinear a izda
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nLeft
               oItem:nLeft := nMinLeft
               oItem:nRight := oItem:nLeft + oItem:nRight - nAux
            endif
        next

   case nType == 3 // alinear abajo
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               oItem:nTop := nMaxBottom - (oItem:nBottom - oItem:nTop)
               oItem:nBottom := nMaxBottom
            endif
        next

   case nType == 4 // alinear a derecha
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nLeft
               oItem:nLeft := nMaxRight - (oItem:nRight-oItem:nLeft)
               oItem:nRight := nMaxRight
            endif
        next

   case nType == 5 // AlCenter horizontalmente

        nAux := (( nMinLeft + ::nWidth - nMaxRight ) / 2)-nMinLeft

        for n := 1 to nLen
            ::aItems[n]:MoveX( nAux )
        next

   case nType == 6 // AlCenter horizontalmente

        nAux := (( nMinTop + ::nHeight - nMaxBottom ) / 2)-nMinTop

        for n := 1 to nLen
            ::aItems[n]:MoveY( nAux )
        next


endcase

::Refresh()


return 0

***********************************************************************************************************************
    METHOD AlCenter() CLASS TC5Report
***********************************************************************************************************************

::SelectAll()
::Align(5)
::Align(6)
::SelectAll(.f.)


return 0


***********************************************************************************************************************
    METHOD SelectAll(lSelect) CLASS TC5Report
***********************************************************************************************************************

local n
local nLen := len( ::aItems )

if lSelect == nil; lSelect := .t.; endif

for n := 1 to nLen
    ::aItems[n]:lSelected := lSelect
next
::lSelecteds := .t.
::Refresh()

return 0


***********************************************************************************************************************
   METHOD MoveItem( cDir ) CLASS TC5Report
***********************************************************************************************************************
local n
local nLen := len( ::aItems )
local oItem
local nVInc := 1
local nHInc := 1
local lControl := GetKeyState( VK_CONTROL )
local lShift   := GetKeyState( VK_SHIFT )

do case
   case cDir == "up"
        nHInc := 0
        nVInc := -1
   case cDir == "down"
        nHInc := 0
   case cDir == "left"
        nHInc := -1
        nVInc := 0
   case cDir == "right"
        nVInc := 0
endcase

if lControl
   nVInc *= 5
   nHInc *= 5
endif

if lShift
   nVInc *= 5
   nHInc *= 5
endif


if ::lSelecteds
   for n := 1 to nLen
       oItem := ::aItems[n]
       if oItem:lSelected
          oItem:aOldPos := {oItem:nTop, oItem:nLeft, oItem:nWidth, oItem:nHeight}
          oItem:nTop     += nVInc
          oItem:nBottom  += nVInc
          oItem:nLeft    += nHInc
          oItem:nRight   += nHInc
       endif
   next
else
   if ::oSelected != nil
      ::oSelected:aOldPos   := {::oSelected:nTop, ::oSelected:nLeft, ::oSelected:nWidth, ::oSelected:nHeight}
      ::oSelected:nTop    += nVInc
      ::oSelected:nBottom += nVInc
      ::oSelected:nLeft   += nHInc
      ::oSelected:nRight  += nHInc
   endif
endif

::Refresh()

return 0


*******************************************************************************************************************************
      METHOD Zoom( nZoom ) CLASS TC5Report
*******************************************************************************************************************************
local n
local nLen := len( ::aItems )
local nInc := ::nFactorZoom(nZoom) - ::nFactorZoom(::nZoom)

::nZoom   := nZoom
::nWidth  := ::aOrgSize[1] * ::nFactorZoom()
::nHeight := ::aOrgSize[2] * ::nFactorZoom()

for n := 1 to nLen
    ::aItems[n]:aCoords[1]  := ::aItems[n]:aCoords[1]  + ( ::aItems[n]:aCoords[1] * nInc )
    ::aItems[n]:aCoords[2]  := ::aItems[n]:aCoords[2]  + ( ::aItems[n]:aCoords[2] * nInc )
    ::aItems[n]:aCoords[3]  := ::aItems[n]:aCoords[3]  + ( ::aItems[n]:aCoords[3] * nInc )
    ::aItems[n]:aCoords[4]  := ::aItems[n]:aCoords[4]  + ( ::aItems[n]:aCoords[4] * nInc )
next

if ::oVRule != nil; ::oVRule:Refresh(); endif
if ::oHRule != nil; ::oHRule:Refresh(); endif
SysRefresh()

::Refresh(.t.)

return 0

*******************************************************************************************************************************
      METHOD nFactorZoom( nZoom ) CLASS TC5Report
*******************************************************************************************************************************
local aZooms := {1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0}

DEFAULT nZoom := ::nZoom

return aZooms[nZoom]




CLASS TC5RptItem

      CLASSDATA nInitID INIT 100

      DATA lMain        AS LOGICAL INIT .F.
      DATA oWnd
      DATA aCoords      AS ARRAY INIT {0,0,0,0}
      DATA aText        AS ARRAY INIT {0,0,0,0}
      DATA nType
      DATA cPrompt
      DATA lEnable
      DATA cBmp
      DATA cBmpOver
      DATA bAction
      DATA cAction      AS CHARACTER INIT ""
      DATA nColor
      DATA nId
      DATA aBmp         AS ARRAY INIT {0,0,0,0}
      DATA aPoints      AS ARRAY INIT {}
      DATA nHText       AS NUMERIC INIT 0
      DATA lSelected    AS LOGICAL INIT .F.
      DATA aOldPos      AS ARRAY INIT {0,0,0,0}
      //DATA aLinks       AS ARRAY INIT {}
      //DATA nAngulo      AS NUMERIC INIT 0
      //DATA ptCentro
      //DATA ptGiro


      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cPrompt, cBmp, bAction, cBmpOver, lEnable, nColor, nType ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD GetNewId() INLINE If( ::nInitId == nil, ::nInitId := 100,),++::nInitId

      METHOD nTop    ( nNew )       SETGET
      METHOD nLeft   ( nNew )       SETGET
      METHOD nBottom ( nNew )       SETGET
      METHOD nRight  ( nNew )       SETGET
      METHOD nWidth  ( nNew )       INLINE (::nRight-::nLeft)
      METHOD nHeight ( nNew )       INLINE (::nBottom-::nTop)
      METHOD nMedW   ( )            INLINE ::nLeft + ::nWidth/2
      METHOD nMedH   ( )            INLINE ::nTop + ::nHeight/2
      METHOD MoveY   ( n )          INLINE ::nTop := ::nTop + n, ::nBottom := ::nBottom + n
      METHOD MoveX   ( n )          INLINE ::nLeft := ::nLeft + n, ::nRight := ::nRight + n
      METHOD IsOverPt( nRow, nCol )
      METHOD IsOver  ( nRow, nCol ) INLINE PtInRect( nRow, nCol, {::nTop+3,::nLeft+3,::nBottom-3,::nRight-3} )
      METHOD EditText( )
      METHOD EditBmp (lOverBmp)

ENDCLASS

******************************************************************************************************************************
      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cPrompt, cBmp, bAction, cBmpOver, lEnable, nColor, nType ) CLASS TC5RptItem
******************************************************************************************************************

   if cPrompt  == nil; cPrompt  := " "      ; endif
   if cBmp     == nil; cBmp     := " "      ; endif
   if cBmpOver == nil; cBmpOver := " "      ; endif
   if lEnable  == nil; lEnable  :=       .t.; endif
   if nColor   == nil; nColor   := CLR_BLACK; endif
   if nType    == nil; nType    :=         1; endif // bmp + texto

   ::oWnd     := oWnd
   ::nTop     := nTop
   ::nLeft    := nLeft
   ::nBottom  := nTop + nHeight
   ::nRight   := nLeft + nWidth
   ::cPrompt  := cPrompt
   ::cBmp     := cBmp
   ::bAction  := bAction
   ::cBmpOver := cBmpOver
   ::lEnable  := lEnable
   ::nID      := ::GetNewID()
   ::nColor   := nColor
   ::nType    := nType


return self

******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItem
******************************************************************************************************************

 local hBmp := 0
 local hFont
 local hOldFont
 local nMode
 local hBrush, hOldBrush
 local nT := ::nTop
 local nL := ::nLeft
 local nB := ::nBottom
 local nR := ::nRight
 local nMedH := ::nHeight/2
 local nMedW := ::nWidth/2
 local nHBmp, nWBmp
 local lOver := ::oWnd:oOver != nil .and. ::oWnd:oOver:nId == ::nID
 local n
 local hPen    := CreatePen( PS_SOLID, 1, rgb( 123,123,123 ) )
 local hOldPen := SelectObject( hDC, hPen)
 local hPenDot
 local nH := ::nHeight
 local nW := ::nWidth
 local nTrozo
 local nRet


 if ::nType > 1 .and. ::nType < 8
    hBrush := CreateSolidBrush( rgb( 123,123,123 ) )
    hOldBrush := SelectObject( hDC, hBrush )
 endif


 do case
    case ::nType == 1
         if lOver
            hBmp := LoadImageEx( ::cBmpOver )
         endif
         if hBmp == 0
            hBmp := LoadImageEx( ::cBmp )
         endif

         hFont    := GetStockObject( 17 )
         hOldFont := SelectObject( hDC, hFont )
         nMode    := SetBkMode( hDC, 1 )

         ::aText := {::nTop,::nLeft,::nBottom,::nRight}
         DrawText( hDC, ::cPrompt, ::aText, nOr( DT_SINGLELINE, DT_VCENTER, DT_LEFT) )

         SetBkMode( hDC, nMode )
         SelectObject( hDC, hOldFont  )

         if hBmp != 0
            nHBmp := BmpHeight( hBmp )
            nWBmp := BmpWidth ( hBmp )

            ::aBmp := {::nTop  + (::nHeight-::nHText)/2 - (nHBmp / 2),;
                       ::nLeft + (::nWidth    )/2 - nWBmp / 2      ,;
                       ::nTop  + (::nHeight-::nHText)/2 + nHBmp / 2,;
                       ::nLeft + (::nWidth    )/2 + nWBmp / 2}

            DrawMasked( hDC, hBmp, ::aBmp[1],::aBmp[2] )
            DeleteObject( hBmp )
         else
            ::aBmp := {0,0,0,0}
         endif


    case ::nType == 9 // rectangulo

         Moveto( hDC, nL, nT )
         Lineto( hDC, nR, nT )
         Lineto( hDC, nR, nB )
         Lineto( hDC, nL, nB )
         Lineto( hDC, nL, nT )

         //PolyPolygon( hDC, {{nL,nT  },;
         //                   {nR,nT  },;
         //                   {nR,nB  },;
         //                   {nL,nB  },;
         //                   {nL,nT  }} )

    case ::nType == 13

         Ellipse( hDC, nL,nT,nL+nH,nT+nH )

endcase

SelectObject( hDC, hOldPen )
DeleteObject( hPen )

if ::nType > 1 .and. ::nType < 8
   SelectObject( hDC, hOldBrush )
   DeleteObject( hBrush )
endif



if ( ::oWnd:oSelected != nil .and. ::oWnd:oSelected:nID == ::nID ) .or. ::lSelected

   nT := ::nTop
   nL := ::nLeft
   nB := ::nBottom
   nR := ::nRight

   //if empty(::aPoints)
      ::aPoints := {{nT      , nL},;
                    {nT      , nL+nMedW},;
                    {nT      , nR},;
                    {nT+nMedH, nR},;
                    {nB      , nR},;
                    {nB      , nL+nMedW},;
                    {nB      , nL },;
                    {nT+nMedH, nL }}
   //endif

   for n := 1 to len(::aPoints)
       if ::lMain
          FillSolidRect( hDC, {::aPoints[n,1]-3,::aPoints[n,2]-3,::aPoints[n,1]+3,::aPoints[n,2]+3}, CLR_BLACK, ::oWnd:nClrPane )
       else
          FillSolidRect( hDC, {::aPoints[n,1]-3,::aPoints[n,2]-3,::aPoints[n,1]+3,::aPoints[n,2]+3}, if(::lSelected,CLR_HGRAY,RGB(0,255,0)), if(::lSelected,::oWnd:nClrPane,CLR_HBLUE) )
       endif
   next

else
   ::aPoints := {}
endif


return nil



******************************************************************************************************************
      METHOD IsOverPt( nRow, nCol )  CLASS TC5RptItem
******************************************************************************************************************
local n
local nLen := len(::aPoints )

for n := 1 to nLen
    if PtInRect( nRow, nCol, {::aPoints[n,1]-3,::aPoints[n,2]-3,::aPoints[n,1]+3,::aPoints[n,2]+3} )
       return n
    endif
next

//if PtInRect( nRow, nCol, {::nTop+::ptGiro[1]-5,::nLeft+::ptGiro[2]-5,::nTop+::ptGiro[1]+5,::nLeft+::ptGiro[2]+5} )
//   return -1
//endif

return 0

******************************************************************************************************************
      METHOD nTop   ( nNew )  CLASS TC5RptItem
******************************************************************************************************************

   if nNew != nil
      ::aCoords[1] := nNew
   endif

return ::aCoords[1] * ::oWnd:nFactorZoom()


******************************************************************************************************************
      METHOD nLeft  ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[2] := nNew
   endif

return ::aCoords[2] * ::oWnd:nFactorZoom()

******************************************************************************************************************
      METHOD nBottom( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[3] := nNew
   endif

return ::aCoords[3] * ::oWnd:nFactorZoom()

******************************************************************************************************************
      METHOD nRight ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[4] := nNew
   endif

return ::aCoords[4] * ::oWnd:nFactorZoom()


******************************************************************************************************************
      METHOD EditText()   CLASS TC5RptItem
******************************************************************************************************************
local cOldVar
local rc
local cText := ::cPrompt
local oFont
local o := self

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -10

if ::oWnd:oGet != nil
   ::oWnd:oGet:End()
endif

  cOldVar := ::cPrompt
  cText := padr(::cPrompt,60)
  rc := { ::aText[1],::aText[2],::aText[3],::aText[4]}

  o:oWnd:oGet := TGetEx():New(rc[1],rc[2]+1 ,{ | u | If(PCount()==0,cText,cText:= u ) },::oWnd,rc[4]-rc[2],rc[3]-rc[1],,,,o:oWnd:nClrPane,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.f.,.f.,,.F.,,,,)
  o:oWnd:oGet:bLostFocus := {|| o:oWnd:oGet:Assign(),( o:cPrompt := alltrim(o:oWnd:oGet:oGet:VarGet()),o:oWnd:Refresh()),o:oWnd:oGet:End() }

return 0

******************************************************************************************************************
      METHOD EditBmp(lOverBmp)   CLASS TC5RptItem
******************************************************************************************************************
 local cPath := AllTrim( GetModuleFileName( GetInstance() ) )
 local cFile
 cPath := cFilePath( cPath )

 if Right( cPath, 1 ) == '\'
    cPath := Left( cPath, Len( cPath ) - 1 ) // Quitamos la barra
 endif

 cFile := upper(cGetFile( "*.bmp", "Seleccione imagen" ))

 if !empty( cFile )
    if lOverBmp
       ::cBmpOver := strtran( cFile,cPath,".")
    else
       ::cBmp := strtran( cFile,cPath,".")
    endif
    ::oWnd:Refresh()
 endif



 return 0








////////////////////////////////////////////////////////////////////
 static function LoadImageEx( cImage )
////////////////////////////////////////////////////////////////////

 local hBmp := 0

 hBmp := LoadBitmap( GetResources(), cImage )
 if hBmp == 0
    hBmp := ReadBitmap( 0, cImage )
 endif

return hBmp

///////////////////////////////////////////////////////////////////////////////////////////
  function aSplit( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

local nItems := strcount( cString, cChar )
local aItems := {}
local n
local uItem

if nItems == 0
   return  aItems
endif

for n := 1 to nItems + 1
    aadd( aItems, alltrim(strtoken( cString, n, cchar )) )
next

return aItems

///////////////////////////////////////////////////////////////////////////////////////////
  function strcount( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

return int(( len( cString ) - len( strtran( cString, cChar, "" ) ))/len(cChar))

function astr( n ); return alltrim(str(n))


///////////////////////////////////////////////////////////////////////////////////////////
function PtInRecta( y, x, aRecta )
///////////////////////////////////////////////////////////////////////////////////////////
local x0, y0, x1, y1

y0 := int(aRecta[1])
x0 := int(aRecta[2])
y1 := int(aRecta[3])
x1 := int(aRecta[4])

return (x-x0)/(x1-x0) == (y-y0)/(y1-y0)

*********************************************************************************************
  function NormalizeRect( rc )
*********************************************************************************************
local aRect := {rc[1],rc[2],rc[3],rc[4]}

if rc[3] < rc[1]
   aRect[1] := rc[3]
   aRect[3] := rc[1]
endif

if rc[4] < rc[2]
   aRect[2] := rc[4]
   aRect[4] := rc[2]
endif

return aRect





**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

#define ES_CENTER                   1
CLASS TGetEx FROM TGet

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel,;
               cMsg, lUpdate, bWhen, lCenter, lRight, bChanged,;
               lReadOnly, lPassword, lNoBorder, nHelpId,;
               lSpinner, bUp, bDown, bMin, bMax ) CONSTRUCTOR

ENDCLASS

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax ) CLASS TGetEx

#ifdef __XPP__
   #undef New
#endif

   local cText := Space( 50 )

   DEFAULT nClrFore  := 0,;
           nClrBack  := CLR_WHITE,;
           oWnd      := GetWndDefault(),;
           nHeight   := If( oFont != nil, oFont:nHeight, 12 ),;
           lDesign   := .f., lPixel := .f., lUpdate := .f.,;
           lCenter   := .f., lRight := .f.,;
           lReadOnly := .f., lPassword := .f.,;
           lSpinner  := .f.,;
           nRow      := 0, nCol := 0, lNoBorder := .f.,;
           bSetGet   := bSETGET( cText )

   ::cCaption = If( cPict == nil, cValToChar( Eval( bSetGet ) ), ;
                    Transform( Eval( bSetGet ), cPict ) )

   if lSpinner
     nHeight := Max( 15, nHeight )
   endif

   ::nTop     = nRow * If( lPixel, 1, 13 )       //13
   ::nLeft    = nCol * If( lPixel, 1, 8 )        // 8
   ::nBottom  = ::nTop + nHeight - 1
   ::nRight   = ::nLeft + If( nWidth == nil, ( 1 + Len( ::cCaption ) ) * 3.5, ;
                                               nWidth - 1 ) + ;
                If( lSpinner, 20, 0 )
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      ES_AUTOHSCROLL, ;
                      If( ! lReadOnly, WS_TABSTOP, 0 ),;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      If( lSpinner, WS_VSCROLL, 0 ),;
                      If( lReadOnly, ES_READONLY, 0 ),;
                      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
//                      If( lCenter .OR. lRight, ES_MULTILINE, 0 ),; Only needed for Win31

   ::nStyle    = If( lNoBorder, nAnd( ::nStyle, nNot( WS_BORDER ) ), ::nStyle )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lPassword = lPassword
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      = 1  // 0   14/Aug/98
   ::lReadOnly = lReadOnly
   ::lFocused  = .f.
   ::nHelpId   = nHelpId
   ::cPicture  = cPict

   ::SetColor( nClrFore, nClrBack )
   ::nClrDef := nClrBack

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer
   ::oGet:KillFocus()

   if ! Empty( oWnd:hWnd )
      ::Create( "EDIT" )
      if oFont != nil
         ::SetFont( oFont )
      endif
      ::GetFont()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

   if lSpinner
      ::Spinner( bUp, bDown, bMin, bMax )
   endif

return Self















#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "math.h"


HB_FUNC( PTINRECT )
{
   POINT pt;
   RECT  rct;

   pt.y = hb_parnl( 1 );
   pt.x = hb_parnl( 2 );

   rct.top    = hb_parni( 3, 1 );
   rct.left   = hb_parni( 3, 2 );
   rct.bottom = hb_parni( 3, 3 );
   rct.right  = hb_parni( 3, 4 );

   hb_retl( PtInRect( &rct, pt ) );
}

HB_FUNC( CREATECOMPATIBLEBITMAP )
{
         hb_retnl( (LONG) CreateCompatibleBitmap( ( HDC ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ));
}


HB_FUNC( CREATECOMPATIBLEDC )
{
         hb_retnl( (LONG) CreateCompatibleDC( ( HDC ) hb_parnl( 1 )));

}

void FillSolidRect(HDC hDC, LPCRECT lpRect, COLORREF clr)
{
   SetBkColor(hDC, clr);
   ExtTextOut(hDC, 0, 0, ETO_OPAQUE, lpRect, NULL, 0, NULL);
}

HB_FUNC( FILLSOLIDRECT )
{
    RECT rct;
    COLORREF nColor;
    HPEN hPen, hOldPen;
    HDC hDC = ( HDC ) hb_parnl( 1 );
    rct.top    = hb_parni( 2, 1 );
    rct.left   = hb_parni( 2, 2 );
    rct.bottom = hb_parni( 2, 3 );
    rct.right  = hb_parni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right, rct.top );
       LineTo( hDC, rct.right, rct.bottom );
       LineTo( hDC, rct.left, rct.bottom );
       LineTo( hDC, rct.left, rct.top );
       SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }
}

HB_FUNC( BMPWIDTH )
{
    BITMAP bm;

    if( hb_parnl( 1 ) )
    {
       GetObject( ( HGDIOBJ ) hb_parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );
       hb_retnl( bm.bmWidth );
    }
    else
    {
       hb_retnl(0);
    }
}
HB_FUNC(  BMPHEIGHT )
{
    BITMAP bm;
    if( hb_parnl( 1 ) )
    {
       GetObject( ( HGDIOBJ ) hb_parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );
       hb_retnl( bm.bmHeight );
    }
    else
    {
       hb_retnl(0);
    }
}

HB_FUNC( CURSORNW )
{
   hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZENWSE ) ) );
}

HB_FUNC( CURSORNE )
{
   hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZENESW ) ) );
}

HB_FUNC( INTRECT )
{

   RECT rc;
   RECT rc1;
   RECT rc2;

  rc.top    = 0;
  rc.left   = 0;
  rc.bottom = 0;
  rc.right  = 0;

  rc1.top    = hb_parni(1,1);
  rc1.left   = hb_parni(1,2);
  rc1.bottom = hb_parni(1,3);
  rc1.right  = hb_parni(1,4);

  rc2.top    = hb_parni(2,1);
  rc2.left   = hb_parni(2,2);
  rc2.bottom = hb_parni(2,3);
  rc2.right  = hb_parni(2,4);

  IntersectRect( &rc, &rc1, &rc2 );

  hb_reta(4);

  hb_storni(rc.top, -1, 1 );
  hb_storni(rc.left, -1, 2 );
  hb_storni(rc.bottom, -1, 3 );
  hb_storni(rc.right, -1, 4 );

}

HB_FUNC( INTERSECTRECT )
{

   RECT rc;
   RECT rc1;
   RECT rc2;

  rc.top    = 0;
  rc.left   = 0;
  rc.bottom = 0;
  rc.right  = 0;

  rc1.top    = hb_parni(1,1);
  rc1.left   = hb_parni(1,2);
  rc1.bottom = hb_parni(1,3);
  rc1.right  = hb_parni(1,4);

  rc2.top    = hb_parni(2,1);
  rc2.left   = hb_parni(2,2);
  rc2.bottom = hb_parni(2,3);
  rc2.right  = hb_parni(2,4);

  hb_retl( IntersectRect( &rc, &rc1, &rc2 ));
}

HB_FUNC( ROUNDRECT )
{
   hb_retl( RoundRect( ( HDC ) hb_parni( 1 ),            // HDC
                               hb_parni( 3 ),            // nLeft
                               hb_parni( 2 ),            // nTop
                               hb_parni( 5 ),            // nRight
                               hb_parni( 4 ),            // nBottom
                               hb_parni( 6 ),            // nWidthEllipse
                               hb_parni( 7 ) ) );        // nHeightEllipse
}




HB_FUNC( CURSORSIZE  )
{
      hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZEALL ) ) );

}

#pragma ENDDUMP



