#include "fivewin.ch"
/*
 * $Id: C5stBar.prg,v 1.00 2007/05/12 20:37:00 canalfive Exp $
 * Paco García Fernández
 * File   : c5stbar.prg
 * Project: C5STBAR,
 * Created: 05/12/2007, 20:37 by Administrador
 * Copyright CanalFive 2007
 * Francisco García Fernández y Oskar Lira Lira
 * See adjunt licence. Ver licencia adjunta
 */

/*** version 1.01 21-06-07 */

/** - Se añade oFont a los items. oFont is added to c5stbaritem.
      Se puede especificar un font individual a los items. It is possible to specify a individual font to the items
    - Nueva variable "lBreak" para los items . Si un item tiene esta variable a .T., los items siguientes se alinearán
      al otro extremo de la barra.
      New variable "lBreak" for the items. If a item have the variable to .t., the next items will be aligned to the other
      side of the bar.
    - Arreglado error en menucontextual. Solved error in menucontextual. DEFAULT cPrompt := ""
      Ahora muestra separadores en el menucontextual. Now show separators in menucontextual
    - Posibilidad de definir una brocha en base a un bitmap y rellenar con ella el fondo
      Posibility of define a brush from a bitmap and fill the background with she.
      See prueba18
*/
/*** versión 1.02 23-06-2007 */
/**  - corregido bug al mostrar los menús popups que hacia colgar la aplicación
       corrected bug to show the popup menu that hang the aplication
     - se añade la data lFillStyle para que los items se repartan horizontalmente por toda la superficie
       del control ( ver prueba19 y prueba20 )

*/
/*** versión 1.03 24-06-2007 */
/**    error al mover el ratón el ::Capture de mousemove hacia qe se ejecutase una accion de un boton
       Error to move the mouse. The ::Capture of MouseMove make that on execute an action of a button */


CLASS TC5StBar FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aItems  AS ARRAY INIT {}
      DATA aGroups AS ARRAY INIT {}
      DATA nAlign  AS NUMERIC INIT 36
      DATA cPrompt
      DATA nAlign
      DATA cBigImg
      DATA nClrBorder       AS NUMERIC INIT RGB(124,124,148)
      DATA nClrOver         AS NUMERIC INIT RGB(255,255,220)
      DATA nClrOver2        AS NUMERIC INIT RGB(238,152, 21)
      DATA nClrSel          AS NUMERIC INIT RGB(238,152, 21)
      DATA nClrSel2         AS NUMERIC INIT RGB(250,227,144)
      DATA nClrPane         AS NUMERIC INIT RGB(255,255,255)
      DATA nClrPane2        AS NUMERIC INIT RGB(143,172,230)
      DATA nClrTSel         AS NUMERIC INIT RGB( 49,106,197)
      DATA nClrSeparator
      DATA nOver            AS NUMERIC INIT  0
      DATA nxOption
      DATA rcArrow          AS ARRAY INIT {0,0,0,0}
      DATA nBtnStyle        AS NUMERIC INIT 1

                            // nBtnStyle 1 -> image - text
                            // nBtnStyle 2 -> text  - image
                            // nBtnStyle 3 ->     I m a g e
                            //                     t e x t
                            // nBtnStyle 4 ->      t e x t
                            //                    I m a g e

      DATA lUnderLine       AS LOGICAL INIT .F.
      DATA lPressed         AS LOGICAL INIT .f.
      DATA nLevel
      DATA lRightToLeft     AS LOGICAL INIT .f.
      DATA lHGrad           AS LOGICAL INIT .F.
      DATA lBorder          AS LOGICAL INIT .F.
      DATA nMargenVSep      AS NUMERIC INIT 5
      DATA nMargenHSep      AS NUMERIC INIT 5

      DATA nMargenUp         AS NUMERIC INIT 3
      DATA nMargenDown       AS NUMERIC INIT 3
      DATA nMargenLeft       AS NUMERIC INIT 3
      DATA nMargenRight      AS NUMERIC INIT 3

      DATA cBackImage

      // compatibilidad con oBar
      DATA   nGroups     AS NUMERIC   INIT 0
      DATA   nMode       AS CHARACTER INIT 1
      DATA   nBtnWidth   AS NUMERIC   INIT 0
      DATA   nBtnHeight  AS NUMERIC   INIT 0
      DATA   l3D         AS LOGICAL   INIT .F.

      // version 1.01 21-06-07 *******************************************
      DATA lBreaks          AS LOGICAL INIT .F. // version 1.01 21-06-07
      DATA nTopPrompt       AS NUMERIC INIT 5   // version 1.01 21-06-07
      DATA nLeftPrompt      AS NUMERIC INIT 5   // version 1.01 21-06-07
      DATA nTopImg          AS NUMERIC INIT 0   // version 1.01 21-06-07
      DATA nLeftImg         AS NUMERIC INIT 0   // version 1.01 21-06-07
      DATA oImgBrush

      DATA lFillStyle       AS LOGICAL INIT .F.


      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrPane1, nClrPane2, lHGrad, oFont, nClrText ) CONSTRUCTOR
      METHOD Redefine( nId, oWnd, nClrPane1, nClrPane2, lHGrad, oFont, nClrText ) CONSTRUCTOR

      METHOD AddItem( cText, cBmp, bAction, bWhen, cToolTip, lEnable, cSmallBmp, lOnOff, bChange )
      METHOD Default       ()
      METHOD Display       ()  INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Destroy       ()  INLINE if(::oImgBrush != nil, ::oImgBrush:End(),), super:Destroy()
      METHOD GetClientRect ()
      METHOD HandleEvent   ( nMsg, nWParam, nLParam )
      METHOD Initiate      ( hDlg) INLINE super:Initiate(hDlg), ::Default()
      METHOD LButtonDown   ( nRow, nCol, nKeyFlags )
      METHOD LButtonUp     ( nRow, nCol, nKeyFlags )
      METHOD MenuContextual( nRow, nCol )
      METHOD MouseMove     ( nRow, nCol, nKeyFlags )
      METHOD Paint         ()
      METHOD PintaLast     ( hDC )
      METHOD Resize        () INLINE super:Resize(), ::ResizeItems()
      METHOD ResizeItems   ()
      METHOD Separator()
      METHOD SetGroup      ( aItems ) INLINE aadd( ::aGroups, aItems ), aeval( aItems, {|x| x:lOnOff := .t., x:lChecked := .f. } )
      METHOD ShowToolTip   ()
      METHOD aEvalWhen()
      METHOD aInGroup      ( oItem )
      METHOD lHorizontal   () INLINE ::nWidth > ::nHeight
      METHOD nOption       ( nNewVal ) SETGET
      METHOD nOverItem     ( nRow, nCol )
      METHOD nTotalVisibles()
      METHOD nVisibles     ()
      METHOD Del           ( nPos )
      METHOD Insert        ( nPos, oItem )
      METHOD SetOption     ( nOption )



      // compatibilidad con oBar
      METHOD NewAt()                             VIRTUAL
      METHOD Add()                               VIRTUAL
      METHOD AddGroup( nPos )                    VIRTUAL
      METHOD Adjust()
      METHOD BtnAdjust()                         VIRTUAL
      METHOD DelGroup( nPos )                    VIRTUAL
      METHOD Float()                             VIRTUAL
      METHOD GoDown()                            VIRTUAL
      METHOD GoLeft()                            VIRTUAL
      METHOD GoRight()                           VIRTUAL
      METHOD GoTop()                             VIRTUAL
      METHOD cGenPRG()                           VIRTUAL
      METHOD GetBtnTop( lNewGroup, nPos )        INLINE 0
      METHOD GetBtnLeft( lNewGroup, nPos )       INLINE 0
      METHOD RButtonDown( nRow, nCol, nFlags )   VIRTUAL
      METHOD SaveIni( cBarName, cFile )          VIRTUAL
      METHOD FloatClick( nRow, nCol, oWnd )      VIRTUAL

ENDCLASS


***********************************************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrPane1, nClrPane2, lHGrad, oFont, nClrText ) CLASS TC5StBar
***********************************************************************************************************************************

  if nClrText  == nil ; nClrText     := CLR_BLACK ; endif
  if lHGrad    == nil ; lHGrad       := .f.       ; endif


  ::oWnd       := oWnd
  ::nTop       := nTop
  ::nLeft      := nLeft
  ::nBottom    := ::nTop + nHeight
  ::nRight     := ::nLeft + nWidth

  ::aItems     := {}
  ::nxOption   := 0
  ::nClrText   := nClrText

  ::nClrPane  := nClrPane1
  ::nClrPane2 := if( nClrPane2 == nil, nClrPane1, nClrPane2)

  ::lHGrad     := lHGrad

  ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN )

  ::nId     := ::GetNewId()
  ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )

  if oFont == nil
    DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -12 BOLD
  endif

  ::oFont := oFont

  if ! Empty( oWnd:hWnd )
     ::Create()
     ::Default()
     ::lVisible = .t.
     oWnd:AddControl( Self )
  else
     oWnd:DefControl( Self )
     ::lVisible  = .f.
  endif
  ::cTooltip := ::ClassName()
  ::CheckToolTip()

return self

***********************************************************************************************************************************
  METHOD Redefine( nId, oWnd, nClrPane1, nClrPane2, lHGrad, oFont, nClrText ) CLASS TC5StBar
***********************************************************************************************************************************

  if nClrText  == nil ; nClrText     := CLR_BLACK ; endif
  if lHGrad    == nil ; lHGrad       := .f.       ; endif

  ::oWnd       := oWnd
  ::nId        := nId

  ::aItems     := {}
  ::nxOption   := 0
  ::nClrText   := nClrText

  if nClrPane1 != nil; ::nClrPane  := nClrPane1  ; endif
  if nClrPane2 != nil; ::nClrPane2 := nClrPane2  ; endif
  ::lHGrad     := lHGrad

  ::nId     := nId
  ::Register()

  if oFont == nil
    DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -12 BOLD
  endif

  ::oFont := oFont

  ::oWnd:DefControl( Self )
  ::lVisible  = .f.
  ::cTooltip := " "
  ::CheckToolTip()

return self

******************************************************************************************************************************
METHOD aEvalWhen() CLASS TC5StBar
******************************************************************************************************************************

   local nFor, oItem
   for nFor := 1 to len( ::aItems )
      oItem := ::aItems[ nFor ]
      if valtype( oItem:bWhen ) == "B"
         if Eval( oItem:bWhen )
            oItem:Enable()
         else
            oItem:Disable()
         endif
      endif
   next

return 0


******************************************************************************************************************************
  METHOD Default() CLASS TC5StBar
******************************************************************************************************************************

 ::ResizeItems()

return 0

******************************************************************************************************************************
  METHOD AddItem( cText, cBmp, bAction, bWhen, lSeparator, cToolTip, lEnable, cSmallBmp, lOnOff, bChange ) CLASS TC5StBar
******************************************************************************************************************************
local rc := {}
local oItem
if lEnable == nil; lEnable := .t.; endif

   oItem := TC5StBarItem():New( self, cText, cBmp, bAction, bWhen, lSeparator, cToolTip, lEnable, cSmallBmp, lOnOff, bChange )

   aadd( ::aItems, oItem )

   if !empty( ::hWnd )
      ::ResizeItems()
   endif

return oItem

******************************************************************************************************************************
  METHOD Separator() CLASS TC5StBar
******************************************************************************************************************************

   local oItem := TC5StBarItem():New( self, ,,,,.t.,,.f.,,,)
   aadd( ::aItems, oItem )

   if !empty( ::hWnd )
      ::ResizeItems()
   endif

return oItem

******************************************************************************************************************************
  METHOD GetClientRect() CLASS TC5StBar
******************************************************************************************************************************
local rc := GetClientRect(::hWnd)

rc[1] += ::nMargenUp
rc[2] += ::nMargenLeft
rc[3] -= ::nMargenDown
rc[4] -= ::nMargenRight


return rc

******************************************************************************************************************************
  METHOD ResizeItems() CLASS TC5StBar
******************************************************************************************************************************
local n
local nLen := len( ::aItems )
local oItem, oLast
local rc, aSize
local nTop, nLeft, nBottom, nRight, nWidth, nHeight

local nBreak := 0            // version 1.01 21-06-07
local nFin   := nLen
local nTotal := 0
local aLevels := {{}}
local aMaxHs  := {}
local nLevel := 1
local nMaxH  := 0
local  n2
local nCount := 0


if empty(::aItems)
   return 0
endif

rc := ::GetClientRect()

nWidth  := rc[4]-rc[2]
nHeight := rc[3]-rc[1]

::lBreaks := .f.

if ::lFillStyle

   nTop    := rc[1]
   nLeft   := rc[2]
   nRight  := nLeft
   nBottom := 0

   for n := 1 to nLen

       aSize   := ::aItems[n]:aGetSize()

       if nRight + aSize[1] >= rc[2]+nWidth
          nLeft := rc[2]
          aadd( aLevels, {} )
          nLevel++
       else
          nLeft   := if( n == 1, rc[2],nRight)
       endif
       aadd( aLevels[nLevel], ::aItems[n] )
       nRight  := nLeft + aSize[1]

   next

   nTop  := rc[1]

   for n := 1 to len( aLevels )
       nMaxH := 0
       for n2 := 1 to len( aLevels[n] )
           if !aLevels[n,n2]:lSeparator
              nMaxH := max(nMaxH,aLevels[n,n2]:aGetSize[2] )
           endif
       next
       for n2 := 1 to len( aLevels[n] )
           if n2 == 1
              nLeft := rc[2]
           else
              nLeft := nRight
           endif
           nRight := nLeft + aLevels[n,n2]:aGetSize[1]
           nBottom := nTop + nMaxH
           aLevels[n,n2]:aCoors := {nTop,nLeft,nBottom,nRight}
       next
       nTop += nMaxH
   next



   //if empty(::aItems[nLen]:nBottom)
   //   ::aItems[nLen]:nBottom := nMaxH
   //endif
   //nMaxH := 0
   //for n := nLen to 1 step -1
   //    if ::aItems[n]:nBottom != 0
   //       nMaxH := ::aItems[n]:nBottom
   //    endif
   //    ::aItems[n]:nBottom := ::aItems[n]:nTop + nMaxH
   //next
   return 0
endif

// version 1.01 21-06-07
for n := 1 to nLen
    nTotal += ::aItems[n]:aGetSize()[if(::lHorizontal,1,2)]
next

if (if(::lHorizontal,nWidth,nHeight) - 20) > nTotal
   for n := 1 to nLen
       if ::aItems[n]:lBreak
          nBreak := n
          ::lBreaks := .t.
          exit
       endif
   next
   nFin := if( nBreak != 0, nBreak, nLen )
endif

if !::lRightToLeft

   for n := 1 to nFin

       oItem := ::aItems[n]
       aSize := oItem:aGetSize()

       if ::lHorizontal
          nTop    := rc[1]
          nLeft   := if( n == 1, rc[2],oLast:nRight)
          nBottom := nTop + aSize[2]
          nRight  := nLeft + aSize[1]

       else

          nTop    := if (n == 1, rc[1], oLast:nBottom )
          nLeft   := rc[2]
          nBottom := nTop + aSize[2]
          nRight  := nLeft + aSize[1]

       endif

       oItem:aCoors := {nTop,nLeft,nBottom,nRight}
       oLast := ::aItems[n]
   next

   if nBreak != 0

      for n := nLen to nBreak+1 step - 1

          oItem := ::aItems[n]
          aSize   := oItem:aGetSize()

          if ::lHorizontal

             nTop    := rc[1]
             nRight  := if( n == nLen, rc[2]+nWidth,oLast:nLeft)
             nLeft   := nRight - aSize[1]
             nBottom := nTop + aSize[2]

          else

             nLeft   := rc[2]
             nBottom := if( n == nLen, rc[1]+nHeight, oLast:nTop )
             nTop    := nBottom - aSize[2]
             nRight  := nLeft + aSize[1]

          endif

          oItem:aCoors := {nTop,nLeft,nBottom,nRight}
          oLast := ::aItems[n]
      next

   endif

else

   for n := nFin to 1 step -1

       oItem := ::aItems[n]
       aSize   := oItem:aGetSize()

       if ::lHorizontal

          nTop    := rc[1]
          nRight  := if( n == nLen, rc[2]+nWidth,oLast:nLeft)
          nLeft   := nRight - aSize[1]
          nBottom := nTop + aSize[2]

       else

          nLeft   := rc[2]
          nBottom := if( n == nLen, rc[1]+nHeight, oLast:nTop )
          nTop    := nBottom - aSize[2]
          nRight  := nLeft + aSize[1]

       endif

       oItem:aCoors := {nTop,nLeft,nBottom,nRight}
       oLast := ::aItems[n]

   next

   if nBreak != 0

      for n := 1 to nBreak+1

          oItem := ::aItems[n]
          aSize := oItem:aGetSize()

          if ::lHorizontal

             nTop    := rc[1]
             nLeft   := if( n == 1, rc[2],oLast:nRight)
             nBottom := nTop + aSize[2]
             nRight  := nLeft + aSize[1]

          else

             nTop    := if (n == 1, rc[1], oLast:nBottom )
             nLeft   := rc[2]
             nBottom := nTop + aSize[2]
             nRight  := nLeft + aSize[1]

          endif

          oItem:aCoors := {nTop,nLeft,nBottom,nRight}
          oLast := ::aItems[n]

      next

   endif

endif

return 0

******************************************************************************************************************************
  METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TC5StBar
******************************************************************************************************************************
local nOver := ::nOverItem( nRow, nCol )
local hWnd  := ChildWindowFromPoint(::hWnd,{nRow,nCol})
local aPoint

if hWnd != ::hWnd
   aPoint := ClientToScreen( ::hWnd, aPoint )
   aPoint := ScreenToClient( hWnd, aPoint )
   nRow := aPoint[ 1 ]
   nCol := aPoint[ 2 ]
   ::LButtonUp( nRow, nCol, nKeyFlags )
   PostMessage( hWnd, WM_LBUTTONDOWN, nMakeLong( nCol, nRow ), 0 )
   return 1
endif


if ::nOver > 0 .and. ::nOver < 1000 .and. ::aItems[::nOver]:lEnable

   ::lPressed := .t.
   ::Capture()
   ::lCaptured := .t.
   if nOver > 0 .and. !::aItems[nOver]:lEmpty()
      CursorHand()
   else
      CursorArrow()
   endif
   ::Refresh(.f.)
else
   CursorArrow()
endif

return 0

******************************************************************************************************************************
  METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TC5StBar
******************************************************************************************************************************
local nOver     := ::nOverItem( nRow, nCol )
local nHeight   := ::nHeight
local lShow     := .t.
local nLastOver := ::nOver
local aPoint
local rc
local nLeft
local nLevel
local hWnd      := ChildWindowFromPoint(::hWnd,{nRow,nCol})

if nRow > 32768
   nRow -= 65535
endif
if nCol > 32768
   nCol -= 65535
endif

if hWnd != ::hWnd
   aPoint := ClientToScreen( ::hWnd, aPoint )
   aPoint := ScreenToClient( hWnd, aPoint )
   nRow   := aPoint[ 1 ]
   nCol   := aPoint[ 2 ]
   ::LButtonUp( nRow, nCol, nKeyFlags )
   PostMessage( hWnd, WM_MOUSEMOVE, nMakeLong( nCol, nRow ), 0 )
   return 1
endif

// version 1.07
//::Capture()

if nOver > 0
   if nOver != ::nOver
      ::nOver := nOver
      if lShow
         ::DestroyToolTip()
      endif
      if (( nOver < 1000 .and.  !::aItems[nOver]:lEmpty() .and. ::aItems[nOver]:lEnable ) .or. nOver == 1000)

         CursorHand()
      else
         CursorArrow()
      endif
      ::CheckToolTip()
      ::Refresh(.t.)
   endif
   starttrackmouseleave(::hWnd)
else
   if ::nOver != 0
      ::nOver := 0
      ::Refresh(.f.)
   endif
   CursorArrow()
endif

if !IsOverWnd( ::hWnd, nRow, nCol ) .and. !::lCaptured
   ReleaseCapture()
   ::Refresh(.f.)
   ::nOver := 0
endif

return 0


******************************************************************************************************************************
  METHOD nTotalVisibles() CLASS TC5StBar
******************************************************************************************************************************
local nTotal := 0
local n
local nLen := len( ::aItems )

for n := 1 to nLen
    if ::aItems[n]:lVisible
       nTotal++
    endif
next
return nTotal

******************************************************************************************************************************
  METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TC5StBar
******************************************************************************************************************************
local nOver := ::nOverItem( nRow, nCol )
local rc := ::GetClientRect()
local nOption
local aPoint

::lPressed := .f.

ReleaseCapture()
::lCaptured := .f.

if PtInRect( nRow, nCol, rc )

   if nOver == 1000
      ::MenuContextual()
   else
      if nOver != ::nOption .and. ::aItems[nOver]:lEnable
         if nOver > 0
            CursorHand()
            ::SetOption( nOver )
            nOption := ::nOption
            ::nOver := 0
            ::Refresh(.f.)
            if nOver <= len( ::aItems )
               if ::aItems[nOver]:lOnOff
                  ::aItems[nOver]:Toogle()
               else
                  if ::aItems[nOver]:bPopup != nil
                     nRow := ::aItems[nOver]:nBottom
                     nCol := ::aItems[nOver]:nLeft
                     aPoint := {nRow+3,nCol+18}
                     aPoint := ClientToScreen( ::hWnd, aPoint )
                     //aPoint := ScreenToClient( hWnd, aPoint )
                     nRow   := aPoint[ 1 ]
                     nCol   := aPoint[ 2 ]
                     eval( ::aItems[nOver]:bPopup, nRow, nCol  )
                  else
                     if ::aItems[nOver]:oPopup != nil .and. nCol > ::aItems[nOver]:nRight-::aItems[nOver]:nWPopup
                        ::NcMouseMove() // close the tooltip
                        ::oWnd:oPopup = ::aItems[nOver]:oPopup
                        if ::lFillStyle
                           nRow := ::aItems[nOver]:nBottom
                           nCol := ::aItems[nOver]:nLeft
                        else
                           if ::lHorizontal
                              nRow := ::nHeight
                              nCol := ::aItems[nOver]:nLeft
                           else
                              nRow := ::aItems[nOver]:nTop
                              nCol := ::nWidth
                           endif
                        endif
                        ::aItems[nOver]:lChecked := .t.
                        ::Refresh()
                        ::aItems[nOver]:oPopup:Activate( nRow, nCol, self, .f. )
                        ::aItems[nOver]:lChecked := .f.
                        // version 1.02 23-06-2007
                        ::oWnd:oPopup := nil
                     else
                        if ::aItems[nOver]:bAction != nil
                           ::aItems[nOver]:Click( nOption )
                        endif
                     endif
                  endif
               endif
            endif
            ::nOption := 0
         else
            CursorArrow()
         endif
        ::Refresh(.f.)
      endif
   endif
endif

return 0




******************************************************************************************************************************
  METHOD nOverItem( nRow, nCol ) CLASS TC5StBar
******************************************************************************************************************************
local n
local nVisibles := ::nVisibles
local nOver := 0
local nLen := len( ::aItems )


if  PtInRect( nRow, nCol, ::rcArrow )
    nOver := 1000
else
   for n := 1 to nLen
       //visible
       if ::aItems[n]:lVisible .and. !::aItems[n]:lHide .and. !empty(::aItems[n]:aCoors) .and. PtInRect( nRow, nCol, ::aItems[n]:aCoors )
          nOver := n
          exit
       endif
   next
endif

return nOver

******************************************************************************************************************************
  METHOD Paint() CLASS TC5StBar
******************************************************************************************************************************
local nLast
local rc
local hDCMem
local hBmpMem
local hOldBmp
local n
local nLen := len( ::aItems )
local lOcultos := .f.
local hFont, hOldFont
local nColor
local nMode
local hBmp

hDCMem  := ::hDC

rc      := GetClientRect(::hWnd)
hDCMem  := CompatDC( ::hDC )
hBmpMem := CompatBmp( ::hDC, rc[4]-rc[2], rc[3]-rc[1] )
hOldBmp := SelectObject( hDCMem, hBmpMem )

rc[1]--

if ::oImgBrush != nil
   SetBrushOrg (hDCMem,0, 0)
   FillRect(hDCMem,rc,::oImgBrush:hBrush )
else
   if ::lHGrad
      rc[3]++
      HorizontalGradient( hDCMem, rc, ::nClrPane, ::nClrPane2 )
      rc[3]--
   else
      VerticalGradient( hDCMem, rc, ::nClrPane, ::nClrPane2 )
   endif
endif

hBmp := LoadImageEx( ::cBackImage )
if hBmp != 0
   DrawMasked( hDCMem, hBmp, ::nTopImg, ::nLeftImg )
   DeleteObject( hBmp )
endif

for n := 1 to nLen
    if ::aItems[n]:lVisible
       ::aItems[n]:Paint( hDCMem )
    else
       lOcultos := .t.
    endif
next

if lOcultos
   ::PintaLast( hDCMem )
endif

if !Empty( ::cPrompt )
   if ::oFont == nil
      hOldFont := SelectObject( hDCMem, GetDefFont() )
   else
      hOldFont := SelectObject( hDCMem, ::oFont:hFont )
   endif
   nMode := SetBkMode( hDCMem, 1 )
   nColor := SetTextColor( hDCMem, ::nClrText )

   DrawText( hDCMem, ::cPrompt, {rc[1]+::nTopPrompt,rc[2]+::nLeftPrompt,rc[3]-5,rc[4]-5}, ::nAlign )

   SetTextColor( hDCMem, nColor )
   SetBkMode( hDCMem, nMode )
   SelectObject( hDCMem, hOldFont )

endif

if ::lBorder
   Box( hDCMem, {rc[1]+1,rc[2],rc[3]-1,rc[4]-1}, ::nClrBorder )
endif

BitBlt( ::hDC, 0, 0,rc[4]-rc[2], rc[3]-rc[1], hDCMem, 0, 0, 13369376 )
hOldBmp := SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmpMem )
DeleteDC( hDCMem )

return 0

******************************************************************************************************************************
      METHOD PintaLast( hDC ) CLASS TC5StBar
******************************************************************************************************************************

local oFont, hOldFont
local nMode := SetBkMode( hDC, 1 )
local rc
local cChar


if ::lHorizontal
   if ::lRightToLeft
      cChar := chr( 171 )
      rc := {2,2,::nHeight-3,13}
   else
      cChar := chr( 187 )
      rc := {2,::nWidth-16,::nHeight-3,::nWidth-2}
   endif
else
   cChar := chr( 187 )
   if ::lRightToLeft
      rc := {2,2,21 ,::nWidth-3}
   else
      rc := {::nHeight-22,2,::nHeight-3 ,::nWidth-3}
   endif
endif

if ::nOver == 1000
   if ::lCaptured
      VerticalGradient( hDC,{rc[1],rc[2],rc[3],rc[4]} , ::nClrSel, ::nClrSel2 )
   else
      VerticalGradient( hDC,{rc[1],rc[2],rc[3],rc[4]} , ::nClrOver, ::nClrOver2 )
   endif
   Box(hDC, rc, ::nClrBorder )
endif


TextOut( hDC, rc[1]+1, if(::lHorizontal,rc[2]+2,::nWidth-10), cChar )

::rcArrow := { rc[1],rc[2],rc[3],rc[4] }

SetBkMode( hDC, nMode )

return 0



******************************************************************************************************************************
  METHOD nOption( nNewVal ) CLASS TC5StBar
******************************************************************************************************************************

if pcount() > 0
   ::nxOption := nNewVal
endif

return ::nxOption

******************************************************************************************************************************
  METHOD nVisibles() CLASS TC5StBar
******************************************************************************************************************************

return ::nTotalVisibles()

******************************************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TC5StBar
******************************************************************************************************************************
Local rc

if nMsg == 20 //WM_ERASEBKGND
   return 1
else
   if nMsg == 0x02A3 //WM_MOUSELEAVE
      ::nOver := -1
      ::Refresh(.f.)
      ReleaseCapture()
      return 0
   endif
endif

return super:HandleEvent( nMsg, nWParam, nLParam )


******************************************************************************************************************************
  METHOD ShowToolTip( nTip ) CLASS TC5StBar
******************************************************************************************************************************

   local cItem, nTop, nLeft

   if ::nOver > 0 .and. ::nOver <= len(::aItems )

      cItem = ::aItems[ ::nOver ]:cTooltip

      if ! Empty( cItem )
         ::cToolTip = cItem
         nLeft = ::aItems[::nOver]:aCoors[ 2 ] + 5
         nTop  = ::aItems[::nOver]:aCoors[ 3 ] + 5
         Super:ShowToolTip( nTop, nLeft )
      endif
   endif

return nil


***************************************************************************************************************
   METHOD MenuContextual( nRow, nCol ) CLASS TC5StBar
***************************************************************************************************************
local oMenu  //local aAux := aGetMenuAccesos()
local cPrompt
local lVisible
local bAction
local cAction
local cResName
local n
local oItem
local hBmp
local o := self
local nVisibles := ::nVisibles()
local item

nRow := ::nHeight
if ::lHorizontal
   if ::lRightToLeft
      nCol := 3
   else
      nCol := ::nWidth - 1
   endif
else
   if ::lRightToLeft
      nRow := 1
      nCol := ::nWidth -1
   else
      nRow := ::nHeight-14
      nCol := ::nWidth-1
   endif
endif

MENU oMenu POPUP
     for n := nVisibles+1 to len(::aItems) //aAux)

         cPrompt  := allTrim(::aItems[n]:cPrompt ) //(aAux[n,1])

         if empty( cPrompt )
            cPrompt := space(30)
         endif

         lVisible := ::aItems[n]:lVisible
         item := ::aItems[n]
         if item:lEnable
            bAction  :=  item:bAction
         else
            bAction  :=  nil
         endif

         // version 1.01 26-01-07
         if ::aItems[n]:lSeparator
             MenuAddItem()
         else

            if !empty(::aItems[n]:cSmallBmp )
               cResName := ::aItems[n]:cSmallBmp
            else
               cResName := allTrim(::aItems[n]:cBmp)
            endif

            if !empty( cResName )
               if "." $ cResname
                  oItem := MenuAddItem(cPrompt, ,lVisible,item:lEnable ,bAction, cResName,         ,,,,,.F.,,,.F. )
               else
                  oItem := MenuAddItem(cPrompt, ,lVisible,item:lEnable ,bAction,         , cResName,,,,,.F.,,,.F. )
               endif
               hBmp := GetBitmap16( oItem:hBitmap,,,.t.)
               oItem:hBitmap := hBmp
            endif

         endif
     next
ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF Self
::oPopup := nil

return nil


***************************************************************************************************************
   METHOD aInGroup( oItem ) CLASS TC5StBar
***************************************************************************************************************
local aInfo := {}
local n,n2

for n := 1 to len( ::aGroups )
    for n2 := 1 to len( ::aGroups[n] )
        if ::aGroups[n,n2]:nID == oItem:nId
           return ::aGroups[n]
        endif
    next
next

return aInfo

*********************************************************************************************************************
  METHOD Adjust() CLASS TC5StBar
*********************************************************************************************************************

   local oMsgBar := ::oWnd:oMsgBar

   BarAdjust2( ::hWnd, ::nMode, oMsgBar != nil,If( oMsgBar != nil, oMsgBar:Height(),) )

return nil

*********************************************************************************************************************
  METHOD Del( nPos ) CLASS TC5StBar
*********************************************************************************************************************
local nLen := len(::aItems )

if nPos > 0 .and. nPos <= nLen
   adel( ::aItems, nPos )
   asize(::aItems, nLen-1)
   ::ResizeItems()
endif

return 0

*********************************************************************************************************************
  METHOD Insert( nPos, oItem ) CLASS TC5StBar
*********************************************************************************************************************
local nLen := len(::aItems )

if nPos > 0 .and. nPos <= nLen
   aadd( ::aItems, nil )
   ains( ::aItems, nPos )
   ::aItems[nPos] := oItem
   ::ResizeItems()
endif

return 0

*********************************************************************************************************************
   METHOD SetOption( nOption ) CLASS TC5StBar
*********************************************************************************************************************
local nOldOption := ::nOption

  if nOption > 0 .and. nOption <= Len( ::aItems ) .and. ::aItems[ nOption ] != nil
     ::nOption := nOption
     if ::bChange != nil
        Eval( ::bChange, nOption, nOldOption )
     endif
     ::Refresh()
  endif

return 0


*********************************************************************************************************************
*********************************************************************************************************************
*********************************************************************************************************************
*********************************************************************************************************************
*********************************************************************************************************************

CLASS TC5StBarItem

      DATA aCoors
      DATA bAction
      DATA bChange
      DATA bWhen
      DATA cBmp
      DATA cPrompt
      DATA cSmallBmp
      DATA cToolTip
      DATA lBreak       AS LOGICAL INIT .F. // version 1.01 21-06-07
      DATA lChecked     AS LOGICAL INIT .F.
      DATA lEnable
      DATA lHide        AS LOGICAL INIT .F. // Do not paint because is out of his client area
      DATA lOnOff
      DATA lSeparator   AS LOGICAL INIT .F.
      DATA nFixHeight
      DATA nFixWidth
      DATA nId
      DATA nWPopup      AS NUMERIC INIT 13
      DATA oFont             // version 1.01 21-06-07
      DATA oPopup
      DATA oWnd
      DATA bPopup           // you can show a dialog


      CLASS VAR nInitId     AS NUMERIC INIT 100 SHARED

      DATA nClrBorder

      METHOD New( oWnd, cText, cBmp, bAction, bWhen, lSeparator, cToolTip, lEnable, cSmallBmp, lOnOff, bChange ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD PaintSeparator( hDC )
      METHOD GetNewId()        INLINE If( ::nInitId == nil, ::nInitId := 100,), ++::nInitId

      METHOD nTop   ( nNewVal ) SETGET
      METHOD nLeft  ( nNewVal ) SETGET
      METHOD nBottom( nNewVal ) SETGET
      METHOD nRight ( nNewVal ) SETGET

      METHOD nWidth()          INLINE ::aCoors[4]-::aCoors[2]
      METHOD nHeight()         INLINE ::aCoors[3]-::aCoors[1]
      METHOD Disable()         INLINE ::lEnable := .f.
      METHOD Enable()          INLINE ::lEnable := .t.
      METHOD lVisible()
      METHOD nGetWidth()       INLINE ::aGetSize()[1]
      METHOD nGetHeight()      INLINE ::aGetSize()[2]
      METHOD aGetSize()

      METHOD Toogle()          INLINE ::SetChecked( !::lChecked )
      METHOD SetChecked( lChecked )
      METHOD lEmpty   ()       INLINE empty(::cPrompt) .and. empty(::cBmp)
      METHOD Refresh()         INLINE ::oWnd:Refresh()
      METHOD Click( nOption )  INLINE if( ::bAction != nil, eval( ::bAction, nOption ),)

ENDCLASS

****************************************************************************************************************************************
 METHOD New( oWnd, cPrompt, cBmp, bAction, bWhen, lSeparator, cTooltip, lEnable, cSmallBmp, lOnOff, bChange, nClrBorder ) CLASS TC5StBarItem
****************************************************************************************************************************************

 DEFAULT lSeparator := .f.
 DEFAULT cToolTip   := ""
 DEFAULT cPrompt    := ""   // version 1.01 21-06-07

 if lOnOff == nil; lOnOff   := .f.; endif
 if lEnable == nil; lEnable := .t.; endif
 if nClrBorder == nil; nClrBorder := oWnd:nClrBorder; endif

   ::oWnd       := oWnd
   ::cPrompt    := cPrompt
   ::cBmp       := cBmp
   ::bAction    := bAction
   ::aCoors     := {}
   ::bWhen      := bWhen
   ::lSeparator := lSeparator
   ::cToolTip   := cToolTip
   ::lEnable    := lEnable
   ::nId        := ::GetNewId()
   ::cSmallBmp  := cSmallBmp
   ::lOnOff     := lOnOff
   ::bChange    := bChange
   ::nClrBorder := nClrBorder

return self

******************************************************************************************************
      METHOD SetChecked( lChecked )CLASS TC5StBarItem
******************************************************************************************************

      local aGroup := ::oWnd:aInGroup( self )
      local lOldCheck := ::lChecked
      local lEval := .t.
      local n

      if lChecked == nil; lChecked := .t.; endif

      if !empty(aGroup) .and. !lOldCheck
         for n := 1 to len( aGroup )
             aGroup[n]:lChecked := .f.
         next
         ::lChecked := .t.
      else
         ::lChecked := lChecked
      endif

      ::oWnd:Refresh()

      if ::bChange != nil
         eval( ::bChange, ::lChecked )
      endif



return ::lChecked


******************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5StBarItem
******************************************************************************************************
local hBmp := 0
local hFont := GetDefFont()  // version 1.01 21-06-07
local hGray
local hOldFont
local hUnder
local lOver
local lPressed
local lText
local nAlign
local nBottom
local nColor
local nHBmp
local nLeft
local nMedH
local nMedHBmp
local nMedW
local nMedWBmp
local nMode
local nRight
local nTop
local nWBmp
local nWText
local oldrc
local rc
local rcTxt
local lIcon

if ::lSeparator
   return ::PaintSeparator( hDC )
endif


lIcon    := LoadImageEx2( ::cBmp, @hBmp )

nWBmp    := if( lIcon, 32, BmpWidth   ( hBmp ))
nHBmp    := if( lIcon, 32, BmpHeight  ( hBmp ))
hFont    := GetDefFont ()
lOver    := ::oWnd:nOver > 0 .and. ::oWnd:nOver <= len(::oWnd:aItems ) .and. ::oWnd:aItems[::oWnd:nOver]:nID == ::nID
lPressed := ::oWnd:lPressed .and. lOver
rc       := {::aCoors[1],::aCoors[2],::aCoors[3],::aCoors[4]}
rcTxt    := {rc[1],rc[2],rc[3],rc[4]}
nMedH    := (rc[3]-rc[1])/2
nMedW    := (rc[4]-rc[2]-if(::oPopup#nil .or. ::bPopup#nil ,::nWPopup,0))/2
nMedHBmp := nHBmp/2
nMedWBmp := nWBmp/2
nBottom  := rc[3]
nRight   := rc[4] - if( ::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0 )
nAlign   := 1 + 4 + 32  // DT_CENTER, DT_VCENTER, DT_SINGLELINE
lText    := !empty( ::cPrompt )

nMode := SetBkMode( hDC, 1 )

if ::oFont != nil            // version 1.01 21-06-07
   hFont := ::oFont:hFont
else
   if ::oWnd:oFont != nil
      hFont := ::oWnd:oFont:hFont
   endif
endif

if ::lEnable

      if ( lPressed .and. !::oWnd:lUnderLine ).or. ::lChecked
         VerticalGradient( hDC,{rc[1],rc[2],rc[3],rc[4]} , ::oWnd:nClrSel, ::oWnd:nClrSel2 )
      else
         if lOver .and. !::oWnd:lUnderLine//.or. (::lOnOff .and. !::lChecked )
            VerticalGradient( hDC,{rc[1],rc[2],rc[3],rc[4]} , ::oWnd:nClrOver, ::oWnd:nClrOver2 )
         endif
      endif

      if (lPressed .or. lOver .or. ::lOnOff) .and. !::oWnd:lUnderLine
         Box(hDC, rc, ::nClrBorder )
      endif

endif

// pintar la imagen
if !lText // si no hay texto
   nTop  := rc[1] + nMedH - nMedHBmp
   nLeft := rc[2] + nMedW - nMedWBmp
else

   do case
      case ::oWnd:nBtnStyle == 1   // image - text

           nTop  := rc[1] + nMedH - nMedHBmp
           nLeft := rc[2] + 4

      case ::oWnd:nBtnStyle == 2   // text - image

           nTop  := rc[1] + nMedH - nMedHBmp
           nLeft := rc[4] - if(::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0 ) - 4 - nWBmp

      case ::oWnd:nBtnStyle == 3   // up image down text

           nTop  := max( 4, rc[1] + ( nMedH / 2 ) - nMedHBmp )
           nLeft := rc[2] + nMedW - nMedWBMp

      case ::oWnd:nBtnStyle == 4   // up text down image

           nTop  := max( 4, rc[1] + nMedH + ( nMedH / 2 ) - nMedHBmp )
           nLeft := rc[2] + nMedW - nMedWBMp
   endcase

endif

if hBmp != 0
   if !::lEnable
      if lIcon
         hGray := IconToGray( hBmp )
      else
         hGray := BmpToGray( hBmp )
      endif
      DrawMasked( hDC, hGray, nTop, nLeft )
      DeleteObject( hGray )
   else
      if lIcon
         DrawIcon( hDC, nTop, nLeft, hBmp )
         DestroyIcon( hBmp )
      else
         DrawMasked( hDC, hBmp, nTop, nLeft )
         DeleteObject( hBmp )
      endif
   endif

endif


if lText
   hUnder   := CreateFontUnderline( hFont )
   if ::lEnable .and. ::oWnd:lUnderLine .and. lOver
      hOldFont := SelectObject( hDC, hUnder )
   else
      hOldFont := SelectObject( hDC, hFont )
   endif
   nWText   := GetTextWidth( hDC, ::cPrompt, hFont )
   do case
      case ::oWnd:nBtnStyle == 1 // image - text

           rc[2] += ( 4 + nWBmp + 4 )
           nAlign  := 4 + 32 + 32768           // DT_VCENTER, DT_SINGLELINE, DT_END_ELLIPSIS

      case ::oWnd:nBtnStyle == 2 // text - image

           rc[4] -= if(::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0 )
           nAlign  := 4 + 32 + 32768          // DT_VCENTER, DT_SINGLELINE, DT_END_ELLIPSIS

      case ::oWnd:nBtnStyle == 3 // image up text down

           rc[1] += nMedH + 8
           rc[4] -= if(::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0 )

           if nWText < ::nWidth
              nAlign := 1 + 4 + 32
           else
              nAlign := 1 + 16
           endif

      case ::oWnd:nBtnStyle == 4 // image down text up

           rc[3] -= nMedH - 4

           if nWText < ::nWidth
              nAlign := 1 + 4 + 32
           else
              nAlign := 1 + 16
           endif

   endcase
   rc[4] -= if(::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0 )

   nColor := SetTextColor( hDC, if(!::lEnable, CLR_GRAY,if(::lChecked,::oWnd:nClrTSel,::oWnd:nClrText)) )

   DrawText(hDC, ::cPrompt, {rc[1],rc[2],rc[3],rc[4]}, nAlign  )

   SetTextColor( hDC, nColor )
   SelectObject( hDC, hOldFont )
   DeleteObject( hUnder )

endif

if ::oPopup != nil .or. ::bPopup != nil
   rc       := {::aCoors[1],::aCoors[2],::aCoors[3],::aCoors[4]}
   if lOver
      Box(hDC, { rc[1]+2,rc[4]-::nWPopup, rc[3]-2,rc[4]-::nWPopup}, ::nClrBorder )
   endif
   C5Simbol( hDC, rc[1]+((rc[3]-rc[1])/2)-6,rc[4]-::nWPopup +2, .f., "u", ::lEnable )
endif

SetBkMode( hDC, nMode )

return 0

******************************************************************************************************
      METHOD PaintSeparator( hDC ) CLASS TC5StBarItem
******************************************************************************************************
local rc       := {::aCoors[1],::aCoors[2],::aCoors[3],::aCoors[4]}

Box(hDC, { rc[1]+::oWnd:nMargenVSep,rc[2]+::oWnd:nMargenHSep, rc[3]-::oWnd:nMargenVSep,rc[2]+::oWnd:nMargenHSep}, if(::oWnd:nClrSeparator != nil, ::oWnd:nClrSeparator,::nClrBorder ))

return 0

******************************************************************************************************
  METHOD aGetSize() CLASS TC5StBarItem
******************************************************************************************************
local hBmp
local nWBmp
local nHBmp
local hDC
local hFont
local hOldFont
local nHeight
local nWidth
local nHText, nWText
local rc
rc := ::oWnd:GetClientRect()

nHeight  := rc[3]-rc[1]
nWidth   := rc[4]-rc[2]

if ::lSeparator
   if ::oWnd:lFillStyle
      return { ::oWnd:nMargenHSep*2, 15 }
   else
      if ::oWnd:lHorizontal
         return { ::oWnd:nMargenHSep*2, nHeight }
      else
         return { nWidth, ::oWnd:nMargenVSep*2 }
      endif
   endif
endif


hBmp     := LoadImageEx( ::cBmp )
nWBmp    := BmpWidth   ( hBmp )
nHBmp    := BmpHeight  ( hBmp )
hDC      := CreateDC( "DISPLAY",0,0,0)
hFont    := GetDefFont()

DeleteObject(hBmp)

if ::oFont != nil          // version 1.01 21-06-07
   hFont := ::oFont:hFont
else
   if ::oWnd:oFont != nil
      hFont := ::oWnd:oFont:hFont
   endif
endif

hOldFont := SelectObject( hDC, hFont )
nHText   := GetTextHeight( ::oWnd:hWnd, hDC ) + 3
nWText   := GetTextWidth( hDC, ::cPrompt, hFont )

if ::oWnd:lFillStyle

   do case
      case ::oWnd:nBtnStyle == 1 .or. ::oWnd:nBtnStyle == 2

           nWidth  := 4 + nWBmp + 4 + nWText + 4 + if( ::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0)
           nHeight := max( nHBmp, nHText )+8

      case ::oWnd:nBtnStyle == 3 .or. ::oWnd:nBtnStyle == 4

           nHeight := 4 + nHBmp + 4 + nHText + 4
           nWidth  := max( nWBmp, nWText)+8

   endcase

   if ::nFixWidth != nil
      nWidth := ::nFixWidth
   endif

   if ::nFixHeight != nil
      nHeight := ::nFixHeight
   endif

   return {nWidth,nHeight}

endif


if ::oWnd:lHorizontal
   do case
      case ::oWnd:nBtnStyle == 1   //imagen-texto

           nWidth  := 4 + nWBmp + 4 + nWText + 4 + if( ::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0)
           nHeight := nHeight             //4 + nHBmp + 4 + nHText + 4

      case ::oWnd:nBtnStyle == 2  // texto-imagen

           nWidth := 4 + nWBmp + 4 + nWText + 4 + if( ::oPopup != nil .or. ::bPopup#nil, ::nWPopup, 0)
           nHeight := nHeight             //4 + nHBmp + 4 + nHText + 4

      case ::oWnd:nBtnStyle == 3  // up image down texto

           nHeight := nHeight             //4 + nHBmp + 4 + nHText + 4
           nWidth  := nHeight //4 + nWText + 4


      case ::oWnd:nBtnStyle == 4  // up texto down image

           nHeight := nHeight             //4 + nHBmp + 4 + nHText + 4
           nWidth  := nHeight //4 + nWText + 4

   endcase
else
   // Vertical
   do case
      case ::oWnd:nBtnStyle == 1   //imagen-texto

           nWidth  := nWidth
           nHeight := max( 4 + nHText + 4, 4 + nHbmp + 4 )

      case ::oWnd:nBtnStyle == 2  // texto-imagen

           nWidth := nWidth
           nHeight := max( 4 + nHText + 4, 4 + nHbmp + 4 )

      case ::oWnd:nBtnStyle == 3  // up image down texto

           nWidth  := nWidth
           nHeight := 4 + nHBmp + 4 + nHText + 4

      case ::oWnd:nBtnStyle == 4  // up texto down image

           nWidth  := nWidth
           nHeight := 4 + nHBmp + 4 + nHText + 4

   endcase
endif
SelectObject( hDC, hOldFont )
DeleteDC( hDC )

if ::nFixWidth != nil
   nWidth := ::nFixWidth
endif

if ::nFixHeight != nil
   nHeight := ::nFixHeight
endif

return {nWidth,nHeight}


******************************************************************************************************
  METHOD nTop  ( nNewVal ) CLASS TC5StBarItem
******************************************************************************************************

if nNewVal != nil
   ::aCoors[1] := nNewVal
endif

return ::aCoors[1]


******************************************************************************************************
  METHOD nLeft( nNewVal ) CLASS TC5StBarItem
******************************************************************************************************
if nNewVal != nil
   ::aCoors[2] := nNewVal
endif

return ::aCoors[2]

******************************************************************************************************
  METHOD nBottom( nNewVal ) CLASS TC5StBarItem
******************************************************************************************************
if nNewVal != nil
   ::aCoors[3] := nNewVal
endif

return ::aCoors[3]

******************************************************************************************************
  METHOD nRight( nNewVal ) CLASS TC5StBarItem
******************************************************************************************************
if nNewVal != nil
   ::aCoors[4] := nNewVal
endif

return ::aCoors[4]



******************************************************************************************************
  METHOD lVisible() CLASS TC5StBarItem
******************************************************************************************************
local rc := ::oWnd:GetClientRect()

if ::oWnd:lBreaks
   return .t.
endif
if ::oWnd:lRightToLeft
   if ::oWnd:lHorizontal
      return ::nLeft > 10
   else
      return ::nTop > 10
   endif
else
   if ::oWnd:lHorizontal
      return ::nRight < rc[4] - 10
   else
      return ::nBottom < rc[3] - 10
   endif
endif


return .t.









#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

HB_FUNC( C5CURSORSIZE  )
{
      hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZEALL ) ) );

}
#define IF(x,y,z) ((x)?(y):(z))

HB_FUNC( BARADJUST2 )
{
   HWND hWnd    = ( HWND ) hb_parnl( 1 );
   BYTE bMode   = hb_parni( 2 );
   BOOL bMsgBar = hb_parl( 3 );
   WORD wHeight = hb_parni( 4 );
   HWND hParent = GetParent( hWnd );
   RECT rcWnd, rcParent;

   GetClientRect( hWnd, &rcWnd );
   GetClientRect( hParent, &rcParent );

   switch( bMode )
   {
      case 1:
           SetWindowPos( hWnd, 0, -1, -1,
                         rcParent.right - rcParent.left ,
                         rcWnd.bottom - rcWnd.top, SWP_NOZORDER );
           break;

      case 2:
           SetWindowPos( hWnd, 0, -1, -1, rcWnd.right - rcWnd.left + 2,
                         rcParent.bottom + 1 - IF( bMsgBar, wHeight - 1, 0 ),
                         SWP_NOZORDER );
           break;

      case 3:
           SetWindowPos( hWnd, 0, rcParent.right - ( rcWnd.right - rcWnd.left ) - 1,
                         -1, rcWnd.right - rcWnd.left + 2,
                         rcParent.bottom + 1 - IF( bMsgBar, wHeight - 1, 0 ),
                         SWP_NOZORDER );
           break;

      case 4:
           SetWindowPos( hWnd, 0, -1, rcParent.bottom -
                         IF( bMsgBar, wHeight - 1, 0 ) -
                         ( rcWnd.bottom - rcWnd.top ) - 2,
                         rcParent.right - rcParent.left + 2,
                         rcWnd.bottom - rcWnd.top + 2,
                         SWP_NOZORDER );
           break;

      case 5:
           break;
   }
}

#pragma ENDDUMP









