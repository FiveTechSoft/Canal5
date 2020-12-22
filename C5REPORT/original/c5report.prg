#include "fivewin.ch"
#include "c5report.ch"
#include "fileio.ch"
#include "hbxml.ch"
//SETMULTIPROPERTIES no funciona bien, revisarlo
static cVersion := ""

static lCmdLine := .t.

#define VERSION "C5R01.01"

#define WM_MOUSEWHEEL                   0x020A

CLASS TC5Report FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aConectings       AS ARRAY     INIT {}
      DATA aCoords           AS ARRAY     INIT {0,0,0,0}
      DATA aFocusRect        AS ARRAY     INIT {}
      DATA aItems            AS ARRAY     INIT {}
      DATA aOldPoints
      DATA aOldPos           AS ARRAY     INIT {0,0,0,0}
      DATA aOldSize          AS ARRAY     INIT {0,0}
      DATA aProperties       AS ARRAY     INIT {}
      DATA aSize             AS ARRAY     INIT {0,0}
      DATA aUndo             AS ARRAY     INIT {}
      DATA bStart

      DATA lStart            AS LOGICAL   INIT .T.
      DATA hBmpMem
      DATA lConecting        AS LOGICAL   INIT .F.
      DATA lDisenio          AS LOGICAL   INIT .F.
      //DATA lSelecteds        AS LOGICAL   INIT .F.
      DATA lInsertionPoint   AS LOGICAL   INIT .F.
      DATA lShowInfo         AS LOGICAL   INIT .F.
      DATA nIniPtOver        AS NUMERIC   INIT 0
      DATA nOldAngulo
      DATA nOldCol
      DATA nOldRow
      DATA nPtOver           AS NUMERIC   INIT 0
      DATA nRadio
      DATA nZoom             AS NUMERIC   INIT 100
      DATA nZoom2            AS NUMERIC   INIT 1
      DATA oGet
      DATA oOver
      DATA oSelected
      DATA oHRule
      DATA oVRule
      DATA cxOrientation     AS CHARACTER INIT "Vertical"
      DATA aUndo             AS ARRAY     INIT {}
      DATA aRedo             AS ARRAY     INIT {}
      DATA rcLastUnknow      AS ARRAY     INIT {}
      CLASSDATA lDoUndo      AS LOGICAL   INIT .F.
      DATA aSetPoint         AS ARRAY     INIT {100,100}
      DATA cTipoPapel        AS CHARACTER INIT "A4 210 x 297 mm"
      DATA nFactor           AS NUMERIC   INIT 4
      DATA lSeeToMove        AS LOGICAL   INIT .t.

      DATA cFaceName         AS CHARACTER INIT "Verdana"
      DATA nHFont            AS NUMERIC   INIT 9
      DATA lBold             AS LOGICAL   INIT .F.
      DATA lUnder            AS LOGICAL   INIT .F.
      DATA lItalic           AS LOGICAL   INIT .F.
      DATA lStrike           AS LOGICAL   INIT .F.

      DATA nxClrText         AS NUMERIC  INIT CLR_BLACK
      DATA nxClrPane         AS NUMERIC  INIT CLR_WHITE
      //DATA lCmdLine          AS LOGICAL   INIT .T.
      DATA aActions          AS ARRAY    INIT {}
      DATA nAction           AS NUMERIC  INIT 0
      DATA lxAutoSave        AS LOGICAL  INIT .F.
      DATA nMinutesAutoSave  AS NUMERIC  INIT 5
      DATA cPathAutoSave     INIT ".\c5back"
      DATA oTimer
      DATA cLastAutoSave     INIT ""
      DATA lAutoLoad         AS LOGICAL INIT .t.

      DATA hBmp
      DATA aMedida          AS ARRAY INIT {}

      METHOD Abrir       ()
      METHOD Add         ( cItem, nTop, nLeft, nWidth, nHeight ) INLINE ::Crea( cItem, nTop, nLeft, nWidth, nHeight )
      METHOD AddItem     ( oItem )
      METHOD AddUndo     ( oShape, cAction, uVal1 )
      METHOD AlCenter    ()
      METHOD Align       ( nType )
      METHOD AutoSave    ()
      METHOD ClearSel    ()        INLINE ::SelectAll( .f. ), ::oSelected := nil, ::Refresh()
      METHOD Color       ()
      METHOD Copy        (lClipBoard)
      METHOD Crea        ( cITem, nTop, nLeft, nWidth, nHeight )
      METHOD Cut         ()
      METHOD Delete      ()
      METHOD Destroy     ()        INLINE DeleteObject( ::hBmpMem ), if(::oTimer != nil, ::oTimer:End(),),super:Destroy()
      METHOD Display     ()        INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Font        ()
      METHOD GetItem     ( uID )
      METHOD GetOver     ( nRow, nCol )
      METHOD GetPtOver   ( nRow, nCol )
      METHOD GoNextItem  ()
      METHOD GoPrevItem  ()
      METHOD HandleEvent ( nMsg, nWParam, nLParam )
      METHOD HidePanel()          INLINE oVSplit():SetPosition( 5 )
      METHOD HideInsertionPoint() INLINE ::lInsertionPoint := .f., ::Refresh()
      METHOD KeyChar     ( nKey, nFlags )
      METHOD KeyDown     ( nKey, nFlags )
      METHOD LButtonDown ( nRow, nCol )
      METHOD LButtonUp   ( nRow, nCol )
      METHOD LDblClick   ( nRow, nCol, nKeyFlags )
      METHOD Landscape   ()        INLINE ::cOrientation("Horizontal")
      METHOD Load        ( cFileName, lPaste )
      METHOD LoadForm    ( cForm ) VIRTUAL
      METHOD LoadIni     ( cFileName, lPaste )
      METHOD LoadScript  ( cFileName )
      METHOD LoadXML     ( cFileName, lPaste )
      METHOD MouseMove   ( nRow, nCol )
      METHOD MouseWheel  ( nKey, nDelta, nXPos, nYPos )
      METHOD MoveItem    ( cDir )
      METHOD MoveTo      ( nTop, nLeft )
      METHOD New         ( nTop, nLeft, nWidth, nHeight, oWnd, nClrText, nClrPane, rc ) CONSTRUCTOR
      METHOD Nuevo       ()
      METHOD OffSetItems ( nRow, nCol )
      METHOD OffsetX     ( nVal )
      METHOD OffsetY     ( nVal )
      METHOD Open        ()        INLINE ::LoadIni()
      METHOD Paint       ()
      METHOD Paste       ()
      METHOD Portrait    ()        INLINE ::cOrientation("Vertical")
      METHOD Preview     ()
      METHOD RButtonDown ( nRow, nCol, nFlags )
      METHOD ReSize      ( nType, nWidth, nHeight )
      METHOD Redefine    ( nId, oWnd, nClrText, nClrPane, rc ) CONSTRUCTOR
      METHOD Redo        () 	  VIRTUAL
      METHOD ReportToTree( oItem )
      METHOD Reset       ()        INLINE asize(::aItems,0), ::Refresh(.t.)
      METHOD SameHeight  ()
      METHOD SameSize    ()
      METHOD SameWidth   ()
      METHOD Save        ( )
      METHOD SaveToBin   ( cFileName, lGraba )
      METHOD SaveToIni   ( cFileName, lGraba )
      METHOD SaveToXml   ( cFileName, lGraba )
      METHOD Scroll      ( cType, nUnits )
      METHOD Select      ( oItem, lPartial )
      METHOD SelectAll   ( lSelect )
      METHOD SetProperties()
      METHOD ShowPanel()            INLINE oVSplit():SetPosition( 255 )
      METHOD ShowInsertionPoint()   INLINE ::lInsertionPoint := .t., ::Refresh()
      METHOD SizeItems   ( nWidth, nHeight )
      METHOD ToBack      ()
      METHOD ToFront     ()
      METHOD TreeToReport()
      METHOD Undo        ()
      METHOD Zoom        ( nZoom )
      METHOD nInvRatio   ()          INLINE 100/::nZoom
      METHOD nRatio      ()          INLINE ::nZoom/100
      METHOD cItemName   ()          INLINE "Informe"
      METHOD cOrientation( cValue )  SETGET
      METHOD lAutoSave   ( lVal )    SETGET
      METHOD lDoingUndo  ()          INLINE ::lDoUndo
      METHOD nMMHeight   ()          INLINE vPix2MM( ::aCoords[3]-::aCoords[1])
      METHOD nMMWidth    ()          INLINE hPix2MM( ::aCoords[4]-::aCoords[2])
      METHOD nRBottom    ( nNew )    SETGET
      METHOD nRHeight    ( nNew )    SETGET
      METHOD nRLeft      ( nNew )    SETGET
      METHOD nRRight     ( nNew )    SETGET
      METHOD nRTop       ( nNew )    SETGET
      METHOD nRWidth     ( nNew )    SETGET
      METHOD nRealHeight ( nNew )    SETGET
      METHOD nRealLeft   ( nNew )    SETGET
      METHOD nRealTop    ( nNew )    SETGET
      METHOD nRealWidth  ( nNew )    SETGET
      METHOD nWidthItems ( nValue )

      METHOD C5CommandLine   ()
      METHOD KeyDownCmd      ( nKey, oGet )
      METHOD ErrorSintaxisCmd()     INLINE MsgAlert( "Error de sintaxis" ),.f.
      METHOD CmdNotSupported ()     INLINE MsgWait( "Comando no soportado","Atención",1 ),.f.
      METHOD ShowHelpCMD     ()

      METHOD GetBoxes()
      METHOD lSelecteds( lValue ) SETGET

ENDCLASS

***********************************************************************************************************
      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrText, nClrPane, rc ) CLASS TC5Report
***********************************************************************************************************

  local cFile

  if nClrText  == nil ; nClrText     := CLR_BLACK ; endif
  if nClrPane  == nil ; nClrpane     := CLR_WHITE ; endif

  ::oWnd       := oWnd
  ::nTop       := nTop
  ::nLeft      := nLeft
  ::nBottom    := ::nTop + nHeight
  ::nRight     := ::nLeft + nWidth
  ::aCoords    := {vMM2Pix(rc[1]),hMM2Pix(rc[2]),vMM2Pix(rc[3]),hMM2Pix(rc[4])}
  ::aOldSize   := {nWidth,nHeight}
  ::aItems     := {}
  ::nClrText   := nClrText
  ::nClrPane   := nClrPane

  ::nStyle  := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_VSCROLL, WS_HSCROLL  ) //, WS_BORDER

  ::nId     := ::GetNewId()
  ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )

  if file( "lastsave.txt" )
     cFile := memoread("lastsave.txt")
     cFile := memoline( cFile,,1)
     if file( cFile )
        ::LoadIni( cFile )
     endif
  endif


  ::lAutoSave := .t.

  if ! Empty( oWnd:hWnd )
     ::Create()
     ::lVisible = .t.
     oWnd:AddControl( Self )
  else
     oWnd:DefControl( Self )
     ::lVisible  = .f.
  endif

  ::bStart := {|| ::Zoom(100) }

  DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self ;
     RANGE       1, 1000;
     ON UP       (::OffsetY(  10),::Refresh()) ;
     ON DOWN     (::OffsetY( -10),::Refresh()) ;
     ON PAGEUP   (::OffsetY( 100),::Refresh())  ;
     ON PAGEDOWN (::OffsetY(-100),::Refresh()) //;
     //ON THUMBPOS ::GoLine( nPos )



  DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
     RANGE       1, 1000;
     ON UP       (::OffsetX(10),::Refresh()) ;
     ON DOWN     (::OffsetX(-10),::Refresh()) ;
     ON PAGEUP   (::OffsetX(100),::Refresh())  ;
     ON PAGEDOWN (::OffsetX(-100),::Refresh()) //;
     //ON THUMBPOS ::GoLine( nPos )



return self



***********************************************************************************************************************************
      METHOD Abrir() CLASS TC5Report
***********************************************************************************************************************************

return ::Load()

***********************************************************************************************************
      METHOD AddItem( oItem ) CLASS TC5Report
***********************************************************************************************************
local oTreeItem

   oItem:oWnd := self
   aadd(::aItems, oItem )
   ::Refresh()
   oTreeItem := oRoot():Add( oItem:cItemName )
   oTreeItem:cargo := oItem
   oRoot():Expand()

return 0

*****************************************************************************************************
      METHOD AddUndo( nVeces, oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 ) CLASS TC5Report
*****************************************************************************************************

aadd( ::aUndo, { nVeces, oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 } )
oUndo():Enable()
oUndo():Refresh()

return nil

***********************************************************************************************************************
    METHOD AlCenter() CLASS TC5Report
***********************************************************************************************************************

::SelectAll()
::Align(5)
::Align(6)
::SelectAll(.f.)


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
local nMedW := ::nRealWidth/2
local nMedH := ::nRealHeight/2
local nCount := 0

if empty( nType )
   return 0
endif

if valtype( nType ) == "C"
   nType := ascan( {"top","left","bottom","right"}, nType )
endif

if nType == 0
   return 0
endif


if ::lSelecteds
   if ::oSelected != nil
      nMinTop    := ::oSelected:nRealTop
      nMinLeft   := ::oSelected:nRealLeft
      nMaxBottom := ::oSelected:nRealBottom
      nMaxRight  := ::oSelected:nRealRight
   else
      for n := 1 to nLen
          oItem := ::aItems[n]
          if oItem:lSelected
             nMinTop    := min( oItem:nRealTop, nMinTop )
             nMinLeft   := min( oItem:nRealLeft, nMinLeft )
             nMaxBottom := max( oItem:nRealBottom, nMaxBottom )
             nMaxRight  := max( oItem:nRealRight, nMaxRight )
          endif
      next
   endif
else
   ? "seleccione elementos"
   return 0
endif

do case
   case nType == 1 // alinear a arriba
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nRealTop
               oItem:nRealTop := nMinTop
               //oItem:nRealBottom := oItem:nRealTop + oItem:nRealBottom - nAux
            endif
        next

   case nType == 2 // alinear a izda
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nRealLeft
               oItem:nRealLeft := nMinLeft
               //oItem:nRealRight := oItem:nRealLeft + oItem:nRealRight - nAux
            endif
        next

   case nType == 3 // alinear abajo
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               oItem:nRealTop := nMaxBottom - (oItem:nRealBottom - oItem:nRealTop)
               //oItem:nRealBottom := nMaxBottom
            endif
        next

   case nType == 4 // alinear a derecha
        for n := 1 to nLen
            oItem := ::aItems[n]
            if oItem:lSelected
               nAux := oItem:nLeft
               oItem:nRealLeft := nMaxRight - (oItem:nRealRight-oItem:nRealLeft)
               //oItem:nRealRight := nMaxRight
            endif
        next

   case nType == 5 // AlCenter horizontalmente

        nAux := (( nMinLeft + ::nRealWidth - nMaxRight ) / 2)-nMinLeft

        for n := 1 to nLen
            ::aItems[n]:MoveX( nAux )
        next

   case nType == 6 // AlCenter horizontalmente

        nAux := (( nMinTop + ::nRealHeight - nMaxBottom ) / 2)-nMinTop

        for n := 1 to nLen
            ::aItems[n]:MoveY( nAux )
        next


endcase

::Refresh()

return 0

***********************************************************************************************************
   METHOD AutoSave() CLASS TC5Report
***********************************************************************************************************
local cFileName
local cStr0
local cStr
local lGraba := .t.

if ::oTimer == nil
   DEFINE TIMER ::oTimer INTERVAL ::nMinutesAutoSave * 60000 OF ::oWnd ACTION ::AutoSave()
   ::oTimer:Activate()
endif

if !lIsDir( ::cPathAutoSave )
   lMKDir( ::cPathAutoSave )
endif

cFileName := cNewFileName( ::cPathAutoSave +"\~back", "ini" )

cStr := ::Save( cFileName,.f. )

if empty( ::cLastAutoSave )
   MemoWritEx( cFileName, cStr )
   ::cLastAutoSave := cFileName
else
   if file( ::cLastAutoSave )
      cStr0 := MemoRead( ::cLastAutoSave )
      if( cStr0 != cStr )
          MemoWritEx( cFileName, cStr )
          ::cLastAutoSave := cFileName
      endif
   endif
endif
MemoWritEx("lastsave.txt",::cLastAutoSave)

return 0

*******************************************************************************************************************************
      METHOD Color() CLASS TC5Report
*******************************************************************************************************************************
ChooseColor()

return 0

***********************************************************************************************************************************
   METHOD Copy(lClipBoard) CLASS TC5Report
***********************************************************************************************************************************
local cStr := ""
local oClp
local n
local nCount := 0
local nLen := len(::aItems)
local oItem

if lClipBoard == nil; lClipBoard := .t.; endif

if ::oSelected == nil .and. !::lSelecteds
   ? "Seleccione un elemento"
   return 0
endif

if ::oSelected != nil
   ::oSelected:lSelected := .t.
endif

for n := 1 to nLen
    oItem := ::aItems[n]
    if oItem:lSelected
       nCount++
       cStr += oItem:Save()
    endif
next

cStr := VERSION +str( nCount,10)+ cStr


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

***********************************************************************************************************
      METHOD Crea( cITem, nTop, nLeft, nWidth, nHeight ) CLASS TC5Report
***********************************************************************************************************
local oItem
local nVeces := 1
local n

DEFAULT nTop  := 300
DEFAULT nLeft := 300

if valtype( nTop    ) == "C" ; nTop    := val( nTop );    endif
if valtype( nLeft   ) == "C" ; nLeft   := val( nLeft );   endif
if valtype( nWidth  ) == "C" ; nWidth  := val( nWidth );  endif
if valtype( nHeight ) == "C" ; nHeight := val( nHeight ); endif


   do case
      case left( cItem, 4 ) == "text"
           oItem := TC5RptItemText():New( self, nTop, nLeft, nWidth, nHeight, "Texto")

      case left( cItem, 4 ) == "imag"
           oItem := TC5RptItemImg():New( self, nTop, nLeft, nWidth, nHeight )

      case left( cItem,4 ) == "vlin" .or. left( cItem, 4 ) == "hlin" .or. left( cItem, 4 ) == "line"
           oItem := TC5RptItemLine():New( self, nTop, nLeft, nWidth, nHeight, cItem == "vline", cItem == "line", .t.)

      case left( cItem, 4 ) == "rect"
           oItem := TC5RptItemRect():New( self, nTop, nLeft, nWidth, nHeight)

      case left( cItem, 4 ) == "elli" .or. left( cItem, 4 ) == "circ"
           oItem := TC5RptItemEllipse():New( self, nTop, nLeft, nWidth, nHeight)
      //case nActivo == C5DETAIL
      //     DEFAULT nWidth := 350
      //     DEFAULT nHeight := 224
      //     oItem := TC5RptItemDetail():New(  self, nTop, nLeft, nWidth, nHeight )

      case left( cItem, 4 ) == "fiel"
           oItem := TC5RptItemField():New(  self, nTop, nLeft, nWidth, nHeight)

      otherwise
           ::ErrorSintaxisCmd()
   endcase

   if oItem != nil
      oReport():AddItem( oItem )
      ::Select( oItem, .f. )
   endif


return oItem

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
local oTreeItem

if lMsg == nil; lMsg := .t.; endif

if ::oSelected != nil .or. ::lSelecteds

   if lMsg
      lDelete := MsgYesNo( "¿Estás seguro de borrarlo?" )
   endif

   if lDelete

      if ::lSelecteds
         do while nCount++ < nLen
            if ::aItems[n]:lSelected
               oTreeItem := cSearchItem( oTree():aItems, ::aItems[n]:cItemName() )
               if oTreeItem != nil
                  oTree():DelITem( oTreeItem )
               endif
               adel(::aItems, n )
               nDels++
            else
               n++
            endif
         enddo
         asize(::aItems, nLen-nDels)
         //::lSelecteds := .f.
      else
         for n := 1 to nLen
             if ::aItems[n]:nId == ::oSelected:nId
                 oTreeItem := cSearchItem( oTree():aItems, ::aItems[n]:cItemName() )
                 if oTreeItem != nil
                    oTree():DelITem( oTreeItem )
                 endif
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

*******************************************************************************************************************************
      METHOD Font() CLASS TC5Report
*******************************************************************************************************************************

ChooseFont()

return 0

***********************************************************************************************************
      METHOD GetItem( uID )  CLASS TC5Report
***********************************************************************************************************
local oItem := nil
local n
if valtype( uID ) == "C"
   uID := val( uID )
endif

for n := 1 to len( ::aItems )
    if ::aItems[n]:nID == uID
       return ::aItems[n]
    endif
next

return oItem

***********************************************************************************************************
      METHOD GetOver( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
 local n
 local nLen := len( ::aItems )


 if ::oSelected != nil
    if ::oSelected:IsOver( nRow, nCol )
       return ::oSelected
    endif
 endif

 for n := nLen to 1 step -1
     if ::aItems[n]:IsOver( nRow, nCol )
        return ::aItems[n]
     endif
 next

 return nil

***********************************************************************************************************
      METHOD GetPtOver( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
 local n
 local nLen := len( ::aItems )

 if ::oSelected == nil
    return 0
 endif

 return ::oSelected:IsOverPt( nRow, nCol )

*******************************************************************************************************************************
      METHOD GoNextItem() CLASS TC5Report
*******************************************************************************************************************************
local oItem
local n, nLen
local nItem := 0
nLen := len(::aItems)

if ::oSelected == nil

   if nLen > 0
      ::Select( ::aItems[1] )
   endif

else

   for n := 1 to nLen
       if ::aItems[n]:nId == ::oSelected:nId
          if n == nLen
             ::Select(::aItems[1])
          else
             ::Select(::aItems[n+1])
          endif
          exit
       endif
   next

endif

::Refresh()

return 0

*******************************************************************************************************************************
      METHOD GoPrevItem() CLASS TC5Report
*******************************************************************************************************************************
local oItem
local n, nLen
local nItem := 0
nLen := len(::aItems)

if ::oSelected == nil

   if nLen > 0
      ::Select(::aItems[1])
   endif

else

   for n := 1 to nLen
       if ::aItems[n]:nId == ::oSelected:nId
          if n == 1
             ::Select(::aItems[nLen])
          else
             ::Select(::aItems[n-1])
          endif
          exit
       endif
   next

endif

::Refresh()

return 0

***********************************************************************************************************************************
      METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TC5Report
***********************************************************************************************************************************

do case
   case nMsg == 20
        return 1
   //case nMsg == WM_MOUSEWHEEL
   //     return ::MouseWheel( nMsg, nWParam, nLParam )
endcase

return super:HandleEvent( nMsg, nWParam, nLParam )

***********************************************************************************************************
      METHOD KeyChar( nKey, nFlags )  CLASS TC5Report
***********************************************************************************************************
do case

   case nKey == VK_TAB
        if GetKeyState( VK_SHIFT )
           ::GoPrevItem()
        else
           ::GoNextItem()
        endif
        return 0

endcase

return super:KeyChar( nKey, nFlags )

***********************************************************************************************************
      METHOD KeyDown( nKey, nFlags )  CLASS TC5Report
***********************************************************************************************************
local lControl := GetKeyState( VK_CONTROL )
local lShift   := GetKeyState( VK_SHIFT )


 do case
    case lControl .and. ( nKey == asc( "z" ) .or. nKey == asc( "Z" ))
           ::Undo()
    case nKey == VK_ADD
         return ::Zoom( ::Zoom()+10 )
    case nKey == VK_SUBTRACT
         return ::Zoom( max(10,::Zoom()-10 ))
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
    case lControl .and. (nKey == asc("C").or. nKey ==asc("c"))
         ::Copy()
    case lControl .and. (nKey == asc("V").or. nKey ==asc("v"))
         ::Paste()
    case lControl .and. (nKey == asc("X").or. nKey ==asc("x"))
         ::Cut()
    case lControl .and. ::oSelected != nil

         IF  ::oSelected:ClassName() == "TC5RPTITEMTEXT" .OR. ::oSelected:ClassName() == "TC5RPTITEMFIELD"

            do case
               case (nKey == asc("F").or. nKey ==asc("f"))

                    if lShift
                       ::oSelected:DecFont()

                    else
                       ::oSelected:IncFont()
                    endif
                    ::oSelected:SetProperties()

               case (nKey == asc("N").or. nKey ==asc("n"))

                       ::oSelected:lBold := !::oSelected:lBold
                       ::oSelected:Refresh()
                       ::oSelected:SetProperties()

               case (nKey == asc("S").or. nKey ==asc("s"))

                       ::oSelected:lStrike := !::oSelected:lStrike
                       ::oSelected:Refresh()
                       ::oSelected:SetProperties()

               case (nKey == asc("K").or. nKey ==asc("k"))

                       ::oSelected:lItalic := !::oSelected:lItalic
                       ::oSelected:Refresh()
                       ::oSelected:SetProperties()


               case (nKey == asc("U").or. nKey ==asc("u"))

                       ::oSelected:lUnder := !::oSelected:lUnder
                       ::oSelected:Refresh()
                       ::oSelected:SetProperties()

            endcase
         endif

    case nKey == VK_ESCAPE

         if lCmdLine
            ::C5CommandLine()
         endif

    case nKey == VK_F8 .and. GetKeyState( VK_CONTROL )
         HidePanelLeft()

 endcase

return 0

***********************************************************************************************************
      METHOD LButtonDown( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local lControl := GetKeyState( VK_CONTROL )
local n, nLen
local nCount := 0
local nT, nL, nB, nR
local oItem
local oOldSel := ::oSelected
local oOver   := ::GetOver( nRow, nCol )

nLen := len(::aItems)

nRow := nRow * 100 / ::nZoom
nCol := nCol * 100 / ::nZoom

//::aSetPoint := {nRow-::aCoords[1], nCol-::aCoords[2]}

::SetFocus()

::nOldRow   := nRow
::nOldCol   := nCol

if !::lCaptured

   ::lCaptured := .t.
   ::Capture()
   ::aOldPos   := {::aCoords[1],::aCoords[2],::aCoords[4]-::aCoords[2],::aCoords[3]-::aCoords[1]}

   if !lControl .and. (::nPtOver := ::GetPtOver( nRow, nCol )) != 0
   // redimensionamiento de ::oSelected

      nT := ::oSelected:aCoords[1]
      nL := ::oSelected:aCoords[2]
      nB := ::oSelected:aCoords[3]
      nR := ::oSelected:aCoords[4]

      ::AddUndo( 1, ::oSelected, "Moveto", {nT, nL, nB, nR}, .t. )

   else

      if !lControl .and. oOver != nil         //inicio mover figura

         ::Select( oOver )

         if ::lSelecteds
            // inicio mover grupo
            for n := 1 to nLen
                if ::aItems[n]:lSelected
                   nT := ::aItems[n]:aCoords[1]
                   nL := ::aItems[n]:aCoords[2]
                   nB := ::aItems[n]:aCoords[3]
                   nR := ::aItems[n]:aCoords[4]
                   ::aItems[n]:aOldPos   := {nT,nL,nB,nR}
                   ::AddUndo( ,::aItems[n], "Moveto", {nT, nL, nB, nR}, .t. )
                   nCount++
                   ::aUndo[ len( ::aUndo ),1] := nCount
                endif

            next
         else
            nT := ::oSelected:aCoords[1]
            nL := ::oSelected:aCoords[2]
            nB := ::oSelected:aCoords[3]
            nR := ::oSelected:aCoords[4]
            ::oSelected:aOldPos   := {nT,nL,nB,nR}
            ::AddUndo( 1, ::oSelected, "Moveto", {nT, nL, nB, nR}, .t. )
         endif
         SetCursor(LoadCursor(GetResources(),"catch2"))

      else

         ::SetProperties(.t.)

         if lControl
            if oOver != nil
               oOver:lSelected := !oOver:lSelected
            else
               //mover formulario
               SetCursor(LoadCursor(GetResources(),"catch2"))
               ::aOldPos   := {::aCoords[1],::aCoords[2],::aCoords[4]-::aCoords[2],::aCoords[3]-::aCoords[1]}
            endif
         else
            ::aSetPoint := {nRow, nCol}
            //inicio selección
            for n := 1 to nLen
                ::aItems[n]:lSelected := .f.
            next
            //::lSelecteds := .f.
            ::oSelected  := nil
            ::aFocusRect := { 0,0,0,0 }
         endif
      endif

   endif
endif

::Refresh()

return 0

***********************************************************************************************************
      METHOD LButtonUp( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local oOver := ::GetOver( nRow, nCol )
local n
local nLen
local nCount := 0
local nActivo := 0
local oItem := nil
local nWidth
local nHeight
local oTreeItem
local nAux
local nSelect := 0

::lShowInfo := .f.

nLen := len(::aItems)


nRow := nRow * 100 / ::nZoom
nCol := nCol * 100 / ::nZoom

for n := 1 to nLen
    ::aItems[n]:lMoviendo := .f.
next

ReleaseCapture()

if ::lCaptured

   if !empty( ::aFocusRect )
      // si estoy seleccionando
      // comprobamos si hemos seleccionado objetos
      for n := 1 to nLen
          if !::aItems[n]:lEnable

          else
             if lIntersectRect( {::aFocusRect[1]-::aCoords[1],::aFocusRect[2]-::aCoords[2],::aFocusRect[3]-::aCoords[1],::aFocusRect[4]-::aCoords[2]},::aItems[n]:GetCoords() )
                ::aItems[n]:lSelected := .t.
                nSelect := n
                nCount++
             endif
          endif
      next

      if !empty( nSelect )
         ::aItems[nSelect]:SetProperties()
      endif

   else

      if ::oSelected != nil
         if ::oSelected:aCoords[1] > ::oSelected:aCoords[3]
            nAux := ::oSelected:aCoords[3]
            ::oSelected:aCoords[3] := ::oSelected:aCoords[1]
            ::oSelected:aCoords[1] := nAux
         endif
         if ::oSelected:aCoords[2] > ::oSelected:aCoords[4]
            nAux := ::oSelected:aCoords[4]
            ::oSelected:aCoords[4] := ::oSelected:aCoords[2]
            ::oSelected:aCoords[2] := nAux
         endif
      endif

   endif

   nActivo := nGetActivo()

   if nActivo != 0

      if !empty(::aFocusRect)

         if ::aFocusRect[4]-::aFocusRect[2] > 3 .and. ::aFocusRect[3]-::aFocusRect[1] > 3
            nWidth  := ::aFocusRect[4]-::aFocusRect[2]
            nHeight := ::aFocusRect[3]-::aFocusRect[1]
         else
            ::aFocusRect := {nRow,nCol,nRow,nCol}
         endif

      else

         ::aFocusRect := {nRow,nCol,nRow,nCol}

      endif

      do case
         case nActivo == C5TEXTO

              oItem := TC5RptItemText():New( self, ::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth, nHeight, "Texto")

         case nActivo == C5BITMAP
              oItem := TC5RptItemImg():New( self, ::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight)

         case nActivo == C5LINE
              oItem := TC5RptItemLine():New( self, ::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight ) //, .t.,.f., .t.)

         case nActivo == C5RECT
              oItem := TC5RptItemRect():New( self, ::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight)

         case nActivo == C5ELIPSE
              oItem := TC5RptItemEllipse():New( self,::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight)

         case nActivo == C5DETAIL
              DEFAULT nWidth := 350
              DEFAULT nHeight := 224
              oItem := TC5RptItemDetail():New(  self,::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight)

         case nActivo == C5FIELD
              oItem := TC5RptItemField():New(  self,::aFocusRect[1]-::aCoords[1], ::aFocusRect[2]-::aCoords[2], nWidth,nHeight)

      endcase

      if oItem != nil
         oReport():AddItem( oItem )
         ::Select( oItem )
      endif

       SelArrow()
   endif

   ::lCaptured  := .f.
   ::aFocusRect := {}
   ::nPtOver    := 0

endif

::Refresh()

if ::oSelected != nil
   //::oSelected:SetProperties()
endif

if ::oSelected == nil .and. oItem == nil
   ::ReportToTree( self )
endif


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




***********************************************************************************************************************************
  METHOD Redefine( nId, oWnd, nClrText, nClrPane, rc ) CLASS TC5Report
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
   METHOD lAutoSave( lValue ) CLASS TC5Report
***********************************************************************************************************

if lValue != nil
   ::lxAutoSave := lValue
   if lValue
      ::AutoSave()
   else
      if ::oTimer != nil
         ::oTimer:End()
         ::oTimer := nil
      endif
   endif
endif
return ::lxAutoSave








***********************************************************************************************************
      METHOD MouseMove( nRow, nCol ) CLASS TC5Report
***********************************************************************************************************
local oOver    := ::GetOver( nRow, nCol )
local oOldOver := ::oOver
local n
local nLen := len(::aItems )
local nPtOver

if nRow > 32768 ;   nRow -= 65535; endif
if nCol > 32768 ;   nCol -= 65535; endif

if ::oHRule != nil
   ::oHRule:nGuia := nCol
   ::oHRule:Refresh()
endif

if ::oVRule != nil
   ::oVRule:nGuia := nRow
   ::oVRule:Refresh()
endif

nRow := nRow * 100 / ::nZoom
nCol := nCol * 100 / ::nZoom

if ::lCaptured
   if ::oSelected != nil .and. !GetKeyState( VK_CONTROL )
      if ::nPtOver == 0
         // moviendo figura o grupo
         SetCursor(LoadCursor(GetResources(),"catch2"))
         if ::lSelecteds
            // mover grupo
            for n := 1 to nLen
                if ::aItems[n]:lSelected
                   ::aItems[n]:aCoords[1] := ::aItems[n]:aOldPos[1]+ nRow - ::nOldRow
                   ::aItems[n]:aCoords[2] := ::aItems[n]:aOldPos[2]+ nCol - ::nOldCol
                   ::aItems[n]:aCoords[3] := ::aItems[n]:aOldPos[3]+ nRow - ::nOldRow
                   ::aItems[n]:aCoords[4] := ::aItems[n]:aOldPos[4]+ nCol - ::nOldCol
                   ::aItems[n]:lMoviendo := !::lSeeToMove
                endif
            next
         else
            // mover figura
            ::oSelected:aCoords[1] := ::oSelected:aOldPos[1]+ nRow - ::nOldRow
            ::oSelected:aCoords[2] := ::oSelected:aOldPos[2]+ nCol - ::nOldCol
            ::oSelected:aCoords[3] := ::oSelected:aOldPos[3]+ nRow - ::nOldRow
            ::oSelected:aCoords[4] := ::oSelected:aOldPos[4]+ nCol - ::nOldCol
            ::oSelected:lMoviendo  := !::lSeeToMove
         endif

      else
         if oOver != nil .and. ::nPtOver == 0
            // Estamos cogiendo una figura
            SetCursor(LoadCursor(GetResources(),"catch2"))
         else
            // redimensionamiento de las figuras
            do case
               case ::nPtOver == 1
                    ::oSelected:aCoords[1] := nRow - ::aCoords[1]
                    ::oSelected:aCoords[2] := nCol - ::aCoords[2]
               case ::nPtOver == 2
                    ::oSelected:aCoords[1] := nRow - ::aCoords[1]
               case ::nPtOver == 3
                    ::oSelected:aCoords[1] := nRow - ::aCoords[1]
                    ::oSelected:aCoords[4] := nCol - ::aCoords[2]
               case ::nPtOver == 4
                    ::oSelected:aCoords[4] := nCol - ::aCoords[2]
               case ::nPtOver == 5
                    ::oSelected:aCoords[3] := nRow - ::aCoords[1]
                    ::oSelected:aCoords[4] := nCol - ::aCoords[2]
               case ::nPtOver == 6
                    ::oSelected:aCoords[3] := nRow - ::aCoords[1]
               case ::nPtOver == 7
                    ::oSelected:aCoords[3] := nRow - ::aCoords[1]
                    ::oSelected:aCoords[2] := nCol - ::aCoords[2]
               case ::nPtOver == 8
                    ::oSelected:aCoords[2] := nCol - ::aCoords[2]
            endcase
         endif
      endif
      ::Refresh()
   else
      if GetKeyState( VK_CONTROL )
         // movimiento del formulario
         ::aCoords[1] := ::aOldPos[1] - (::nOldRow - nRow)
         ::aCoords[2] := ::aOldPos[2] - (::nOldCol - nCol)
         ::aCoords[3] := ::aCoords[1] + ::aOldPos[4]
         ::aCoords[4] := ::aCoords[2] + ::aOldPos[3]
         if ::oHRule != nil
            ::oHRule:MakeRule()
            ::oHRule:Refresh()
         endif
         if ::oVRule != nil
            ::oVRule:MakeRule()
            ::oVRule:Refresh()
         endif

         ::Refresh()
      else
         // pintado de las selección
         ::aFocusRect := {min(::nOldRow,nRow), min(::nOldCol,nCol), max(::nOldRow,nRow), max(::nOldCol,nCol)}
         ::Refresh()
         CursorArrow()
         ::lShowInfo := .t.
      endif
   endif
else

//   if oOver != nil
//      // indica que una figura se puede coger
//      SetCursor(LoadCursor(GetResources(),"hand2"))
//   else

      // si pasamos por un punto de control ponemos el cursor determinado
      nPtOver := ::GetPtOver( nRow, nCol )
      do case
         case nPtOver == 0   // client
              if oOver != nil
                 SetCursor(LoadCursor(GetResources(),"hand2"))
              else
                 CursorArrow()
              endif
         case nPtOver == 1   // NW
              CursorNW()
         case nPtOver == 2   // N
              CursorNS()
         case nPtOver == 3   // NE
              CursorNE()
         case nPtOver == 4   // E
              CursorWE()
         case nPtOver == 5   // SE
              CursorNW()
         case nPtOver == 6   // S
              CursorNS()
         case nPtOver == 7   // SW
              CursorNE()
         case nPtOver == 8   // W
              CursorWE()
      endcase
//   endif
endif

return 0


*************************************************************************************
  METHOD MouseWheel( nKey, nDelta, nXPos, nYPos ) CLASS TC5Report
*************************************************************************************

   if nDelta > 0
      if GetKeyState( VK_CONTROL )
         ::Zoom( ::Zoom() + 10 )
      else
      if nYPos > ::nHeight-::nHeight/6
         ::OffsetX( 10 )
      else
         ::OffsetY( 10 )
      endif
         ::Refresh()
      endif
   else

      if GetKeyState( VK_CONTROL )
         ::Zoom( max( ::Zoom() - 10,10) )
      else
      if nYPos > ::nHeight-::nHeight/6
         ::OffsetX( -10 )
      else
         ::OffsetY( -10 )
      endif
         ::Refresh()
      endif
   endif



return nil


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

if oOver != nil
   return oOver:RButtonDown( nRow, nCol, nFlags )
endif

MENU oMenu POPUP
   if oOver != nil
      MENUITEM "Cortar" ACTION ::Cut()
      MENUITEM "Copiar" ACTION ::Copy()
   endif
   MENUITEM "Pegar" ACTION ::Paste()

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF Self



return 0


***********************************************************************************************************
      METHOD ReSize( nType, nWidth, nHeight )  CLASS TC5Report
***********************************************************************************************************

   Super:ReSize( nType, nWidth, nHeight )

   ::Zoom( ::nZoom )

return 0







#define MM_ISOTROPIC      7

***********************************************************************************************************
      METHOD Paint() CLASS TC5Report
***********************************************************************************************************
//local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( ::hDC )
local rc      := GetClientRect( ::hWnd )
local hBmpMem
local hOldBmp
local n, a
local aPos
local nLen    := len( ::aItems )
local oFont, hOldFont
local nMode, color
local c := chr(67)  +;
           chr(97)  +;
           chr(110) +;
           chr(97)  +;
           chr(108) +;
           chr(70)  +;
           chr(105) +;
           chr(118) +;
           chr(101) +;
           chr(82)  +;
           chr(101) +;
           chr(112) +;
           chr(111) +;
           chr(114) +;
           chr(116) +chr(32)+ chr(68)+chr(101)+chr(109)+chr(111)

if ::lStart
   if ::bStart != nil
      eval( ::bStart )
   endif
   ::lStart := .f.
endif


if ::aSize[1] != rc[4]-rc[2] .or. ::aSize[2] != rc[3]-rc[1]
   if ::hBmpMem != nil
      DeleteObject( ::hBmpMem )
   endif
   ::aSize := {rc[4]-rc[2], rc[3]-rc[1] }
   ::hBmpMem := CreateCompatibleBitmap( ::hDC, ::aSize[1], ::aSize[2] )
endif

hOldBmp := SelectObject( hDCMem, ::hBmpMem )


FillSolidRect( hDCMem, rc, ::nClrPane )
FillSolidRect( hDCMem, {::nRTop,::nRLeft,::nRBottom,::nRRight}, RGB(250,250,250), 0 )//::nClrPane )
//Line( hDCMem, ::nRTop+1, ::nRLeft+1, ::nRBottom-1, ::nRLeft+1, rgb(223,223,223))


FillRectBmp( hDCMem, {::nRTop-1,   ::nRRight+1,::nRTop+8,    ::nRRight+9}, "topright"  )
FillRectBmp( hDCMem, {::nRTop-3,   ::nRLeft,   ::nRTop  ,    ::nRRight+5}, "top"       )
FillRectBmp( hDCMem, {::nRTop+8,   ::nRRight+1,::nRBottom+1, ::nRRight+9}, "right"     )
FillRectBmp( hDCMem, {::nRBottom+1,::nRRight+1,::nRBottom+9, ::nRRight+9}, "downright" )
FillRectBmp( hDCMem, {::nRBottom+1,::nRLeft+9, ::nRBottom+9, ::nRRight+1}, "down"      )
FillRectBmp( hDCMem, {::nRBottom+1,::nRLeft,   ::nRBottom+9, ::nRLeft+9 }, "downleft"  )
FillRectBmp( hDCMem, {::nRTop,     ::nRLeft-4, ::nRBottom+5, ::nRLeft   }, "left"      )


DEFINE FONT oFont NAME "Verdana" SIZE 0, -40 BOLD //NESCAPEMENT 3150
hOldFont := SelectObject( hDCMem, oFont:hFont )
nMode := SetBkMode( hDCMem, 1 )
color := SetTextColor( hDCMem, RGB( 210,210,210))
TextOut( hDCMem, 150, 150, C )
TextOut( hDCMem, 350, 350, C )
SelectObject( hDCMem, hOldFont )
SetBkMode( hDCMem, nMode  )
SetTextColor( hDCMem, color )
oFont:End()



for n := 1 to nLen
    //if ::oSelected != nil .and. ::oSelected:nId == ::aItems[n]:nID
    //else
       ::aItems[n]:Paint( hDCMem )
    //endif
next

if !empty(::aFocusRect)
   DrawFocusRect(hDCMem, (::aFocusRect[1]*::nZoom/100),;
                         (::aFocusRect[2]*::nZoom/100),;
                         (::aFocusRect[3]*::nZoom/100),;
                         (::aFocusRect[4]*::nZoom/100) )

endif


nMode := SetBkMode( hDCMem, 1 )
if !empty( ::oHRule:aGuias )
   nLen := len(::oHRule:aGuias)
   for n := 1 to nLen
       a := ::oHRule:GetCoords(n)
       LineEx(hDCMem,0,a[2],rc[3],a[2],CLR_HBLUE,PS_DOT )
   next
endif

if !empty( ::oVRule:aGuias )
   nLen := len(::oVRule:aGuias)
   for n := 1 to nLen
       a := ::oVRule:GetCoords(n)
       LineEx(hDCMem,a[1],0,a[1],rc[4],CLR_HBLUE,PS_DOT )
   next
endif
SetBkMode( hDCMem, nMode )

if ::lInsertionPoint
   Moveto( hDCMem, ::aSetPoint[2]     *::nRatio, ::aSetPoint[1]     *::nRatio)
   Lineto( hDCMem, (::aSetPoint[2]-10)*::nRatio, ::aSetPoint[1]     *::nRatio)
   Moveto( hDCMem, ::aSetPoint[2]     *::nRatio, ::aSetPoint[1]     *::nRatio)
   Lineto( hDCMem, (::aSetPoint[2]+10)*::nRatio, ::aSetPoint[1]     *::nRatio)
   Moveto( hDCMem, ::aSetPoint[2]     *::nRatio, ::aSetPoint[1]     *::nRatio)
   Lineto( hDCMem, ::aSetPoint[2]     *::nRatio, (::aSetPoint[1]-10)*::nRatio)
   Moveto( hDCMem, ::aSetPoint[2]     *::nRatio, ::aSetPoint[1]     *::nRatio)
   Lineto( hDCMem, ::aSetPoint[2]     *::nRatio, (::aSetPoint[1]+10)*::nRatio)
endif

//if ::lShowInfo
//   aPos    := GetCursorPos()
//   aPos := ScreenToClient(::hWnd, aPos )
//   aPos[1] += 20
//   aPos[2] += 20
//   aadd( aPos, aPos[1]+ 50 )
//   aadd( aPos, aPos[2]+ 130 )
//   FillSolidRect( hDCMem, aPos, RGB(255,255,192 ))
//   Box( hDCMem, aPos, CLR_GRAY)
//endif

BitBlt( ::hDC, 0, 0, ::aSize[1], ::aSize[2], hDCMem, 0, 0, 13369376 )
SelectObject( hDCMem, hOldBmp )
//DeleteDC( hDC )
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
      METHOD Save( cFileName, lGraba ) CLASS TC5Report
***********************************************************************************************************************************
local cStr := ""
local n
local cExt := ""
local nType := 1


if cFileName == nil       //"Binario (*.c5r)| *.c5r|"+;
   cFileName := cGetFile( "Ini (*.ini)| *.ini|"+;
                          "XML (*.xml)| *.xml|",;
                          "Elija el formato", 1 )
endif

cExt := lower(right(cFileName,4 ) )

do case
   case cExt == ".c5r"
        nType := 0
   case cExt == ".ini"
        nType := 1
   case cExt == ".xml"
        nType := 2
   otherwise
     if empty( cExt ) .or. at(".",cFileName) == 0
        cFileName += ".ini"
     endif
endcase

if file( cFileName )
   if !MsgYesNo( "El fichero" + CRLF + cFileName + CRLF + "Ya existe" + CRLF + CRLF + "¿Desea sobreescribirlo?")
      MsgInfo("Proceso cancelado")
      return 0
   endif
   DeleteFile( cFileName )
endif

do case
   case nType == 0
        cStr := ::SaveToBin( cFileName )
   case nType == 1
        cStr := ::SaveToIni( cFileName, lGraba )
   case nType == 2
        cStr := ::SaveToXML( cFileName, lGraba )
endcase






return cStr

***********************************************************************************************************************************
      METHOD Load( cFileName, lPaste ) CLASS TC5Report
***********************************************************************************************************************************
local cStr := ""
local n
local nItems
local nPuntero := 1
local a
local nLen
local oItem
local oClp
local nMax := 0
local hBmp := 0
local hDib
local cBmpFile
local bError
local nLenHDr
local cExt

DEFAULT lPaste := .f.

if !lPaste

   if cFileName == nil .or. lIsDir( cFileName ) //"Binario (*.c5r)| *.c5r|"+;
      cFileName := cGetFile( "Ini (*.ini)| *.ini|"+;
                             "XML (*.xml)| *.xml|",;
                             "Elija el archivo", 1, if( lIsDir( cFileName ), cFileName,) )

      //cFileName := cGetFile( "Informe (*.c5r) | *.c5r",;
      //                            "Seleccione un fichero a editar", 1, if( lIsDir( cFileName ), cFileName,)  )
   endif

   if empty( cFileName )
      MsgInfo("Proceso cancelado")
      return 0
   endif

   cExt := lower(right(cFileName,4 ) )

   do case
      case cExt == ".c5r"
           //Carga en binario
      case cExt == ".ini"
           return ::LoadIni( cFileName )
      case cExt == ".xml"
           return ::LoadXML( cFileName )
      otherwise
           MsgStop( "Formato no soportado","Atención")
           return 0
   endcase

   asize( ::aItems, 0 )

   ::oSelected := nil
   ::Refresh()

   cStr := memoread( cFileName )
   oTree():DeleteAll()
   oRoot( oTree():Add( "Informe" ) )
   oRoot():cargo := self

    cVersion      :=      substr( cStr, nPuntero, len(VERSION) )        ; nPuntero += len(VERSION)
    nLenHdr       :=      substr( cStr, nPuntero, 6 )                   ; nPuntero += 6
    ::aCoords[ 1] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nTop
    ::aCoords[ 2] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nLeft
    ::aCoords[ 3] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nRight
    ::aCoords[ 4] := val( substr( cStr, nPuntero, 4 ))                  ; nPuntero += 4   // nBottom
    nLen          := val( substr( cStr, nPuntero, 3 ))                  ; nPuntero += 3   // len tipo papel
    ::cTipoPapel  :=      substr( cStr, nPuntero, nLen )                ; nPuntero += nLen
    ::nZoom       := val( substr( cStr, nPuntero, 3 ))                  ; nPuntero += 3   // Zoom

else

   aeval( ::aItems, {|x| x:lSelected := .f. } )

   DEFINE CLIPBOARD oClp OF Self

   cStr := oClp:GetText()

   IF !empty( cStr ) .and. left( cStr, len( VERSION )) != VERSION

      oItem := TC5RptItemText():New( self, ::aSetPoint[1], ::aSetPoint[2], 200, 30, cStr)
      oReport():AddItem( oItem )
      ::Select( oItem )
      return 0

   else

      hBmp := oClp:GetBitmap()

      if hBmp != 0

         cBmpFile := cGetFile( "*.bmp","Guardar...", 1, , .t. )
         if empty( cBmpFile )
            MsgStop( "Operación cancelada" )
            DeleteObject( hBmp )
            return 0
         endif
         if lower(right( cBmpFile,4 )) != ".bmp"
            cBmpFile += ".bmp"
         endif

         BEGIN SEQUENCE

            hDib := DibFromBitmap( hBmp )
            DibWrite( cBmpFile, hDib )
            GloBalFree( hDib )
            DeleteObject( hBmp )
            oItem := TC5RptItemImg():New( self, ::aSetPoint[1], ::aSetPoint[2], 200, 30, cStr)
            oItem:cBmp := cBmpFile
            oReport():AddItem( oItem )
            ::Select( oItem )

         RECOVER
            MsgAlert( "Error al almacenar la imagen" )
         END SEQUENCE

         return 0
      endif
   endif

   cStr := substr( cStr, len(VERSION)+1 )

endif

nItems := val( substr( cStr, nPuntero, 10 ))  ; nPuntero += 10


for n := 1 to nItems

    a := afill( array( 30 ), 0 )

    a[ 1] := val( substr( cStr, nPuntero, 3 )) ; nPuntero += 3   // nType

    do case
       case a[ 1 ] == C5TEXTO

            oItem := TC5RptItemText():Load( cStr, lPaste, @nPuntero )

       case a[ 1 ] == C5BITMAP

            oItem := TC5RptItemImg():Load( cStr, lPaste, @nPuntero )

       case a[ 1 ] == C5LINE

            oItem := TC5RptItemLine():Load( cStr, lPaste, @nPuntero )

       case a[ 1 ]== C5RECT

            oItem := TC5RptItemRect():Load( cStr, lPaste, @nPuntero )

      case a[ 1 ] == C5ELIPSE

            oItem := TC5RptItemEllipse():Load( cStr, lPaste, @nPuntero )

      case a[ 1 ] == C5FIELD

            oItem := TC5RptItemField():Load( cStr, lPaste, @nPuntero )

    endcase

    ::AddItem( oItem )

    if lPaste
       oItem:lSelected := .t.
    endif

next


if !lPaste .and. nItems > 0
   for n := 1 to nItems
       nMax := max( nMax, ::aItems[n]:nId )
   next
   ::aItems[1]:nInitId := nMax+1
endif

if nItems == 1
   ::Select( oItem )
endif


::Refresh()

return 0

***********************************************************************************************************************************
      METHOD LoadScript( cFileName ) CLASS TC5Report
***********************************************************************************************************************************
local cStr := ""
local n, nLines

   if cFileName == nil .or. lIsDir( cFileName )
      cFileName := cGetFile( "Informe (*.c5s) | *.c5s",;
                                  "Seleccione un fichero a editar", 1, if( lIsDir( cFileName ), cFileName,)  )
   endif

   if empty( cFileName )
      MsgInfo("Proceso cancelado")
      return 0
   endif

   cStr := memoread( cFileName ) + CRLF
   nLines := strcount( cStr, CRLF )

   for n := 1 to nLines
       ::KeyDownCmd( ,,, .t., rtrim(memoline(cStr,400,n )) )
   next



return 0




***********************************************************************************************************************************
      METHOD LoadIni( cFileName ) CLASS TC5Report
***********************************************************************************************************************************
local cStr
local n
local nItems
local nPuntero := 1
local a
local nLen
local oItem
local oClp
local nMax := 0
local oIni
local nTop, nLeft, nWidth, nHeight
local cItem
local cType

   if cFileName == nil
      cFileName := cGetFile( "Informe (*.c5r) | *.c5r", "Seleccione un fichero a editar", 1,  )
   endif

   if empty( cFileName )
      MsgInfo("Proceso cancelado")
      return 0
   endif

   asize( ::aItems, 0 )

   ::oSelected := nil
   ::Refresh()

   cStr := memoread( cFileName )
   oTree():DeleteAll()
   oRoot( oTree():Add( "Informe" ) )
   oRoot():cargo := self


INI oIni FILENAME cFileName

    GET nTop          SECTION "Report" ENTRY "nTop"        OF oIni  DEFAULT 0
    GET nLeft         SECTION "Report" ENTRY "nLeft"       OF oIni  DEFAULT 0
    GET nWidth        SECTION "Report" ENTRY "nWidth"      OF oIni  DEFAULT 0
    GET nHeight       SECTION "Report" ENTRY "nHeight"     OF oIni  DEFAULT 0
    GET ::nZoom       SECTION "Report" ENTRY "nZoom"       OF oIni  DEFAULT 100

    ::aCoords[1] := nTop
    ::aCoords[2] := nLeft
    ::aCoords[3] := nTop + nHeight
    ::aCoords[4] := nLeft + nWidth

    GET ::cTipoPapel  SECTION "Report" ENTRY "cTipoPapel"  OF oIni  DEFAULT ""
    GET nItems        SECTION "Report" ENTRY "nItems"      OF oIni  DEFAULT 0

    for n := 1 to nItems
        cItem := "Item" + alltrim(str(n))

        GET cType SECTION cItem ENTRY "Type" OF oIni DEFAULT ""

        do case
           case cType == "Text"

                oItem := TC5RptItemText():LoadIni( oIni, cItem )

           case cType == "Image"

                oItem := TC5RptItemImg():LoadIni( oIni, cItem )

           case cType == "Line"

                oItem := TC5RptItemLine():LoadIni( oIni, cItem )

           case cType == "Rectangle"

                oItem := TC5RptItemRect():LoadIni( oIni, cItem )

           case cType == "Ellipse"

                oItem := TC5RptItemEllipse():LoadIni( oIni, cItem )

           case cType == "Field"

                oItem := TC5RptItemField():LoadIni( oIni, cItem )

        endcase

        ::AddItem( oItem )

    next

if nItems > 0
   for n := 1 to nItems
       nMax := max( nMax, ::aItems[n]:nId )
   next
   ::aItems[1]:nInitId := nMax
endif

::Refresh()

return 0

***********************************************************************************************************************************
      METHOD LoadXML( cFileName ) CLASS TC5Report
***********************************************************************************************************************************

   local txt := ""
   local doc
   local hFile
   local oXmlDoc
   local oNodo
   local cError

   if cFileName == nil
      cFileName := cGetFile( "Informe (*.xml) | *.xml", "Seleccione un fichero a editar", 1,  )
   endif

   if empty( cFileName )
      MsgInfo("Proceso cancelado")
      return 0
   endif

    hFile := FOpen( cFileName )

    If hFile = -1
       MsgStop( cFileName, "No se pudo abrir el fichero" + cFileName )
       return 0
    endif

    oXmlDoc := TXmlDocument():New( hFile )

    if oXmlDoc:nStatus != HBXML_STATUS_OK
       cError := "Error While Processing File: " + AllTrim( Str( oxmlDoc:nLine ) ) + " # "+;
                 "Error: " + HB_XmlErrorDesc( oxmlDoc:nError ) + " # " +;
                 "Tag Error on tag: " + oxmlDoc:oErrorNode:cName + " # " +;
                 "Tag Begin on line: " + AllTrim( Str( oxmlDoc:oErrorNode:nBeginLine ) )
       MsgStop( cFileName, cError )
       return 0
    endif

     if( oNodo := oXmlDoc:FindFirst( "PETICION", "id",  "CONSULTA_EMPRESA" ) ) != NIL

     endif

   fClose( hFile )





return 0








***********************************************************************************************************************************
   METHOD Paste( nRow, nCol) CLASS TC5Report
***********************************************************************************************************************************

::Load( ,.t., nRow, nCol )

return 0




***********************************************************************************************************************************
      METHOD SameHeight() CLASS TC5Report
***********************************************************************************************************************************
local nLen := len(::aItems)
local oItem
local n

if ::lSelecteds .and. ::oSelected <> nil
   for n := 1 to nLen
       oItem := ::aItems[n]
       oItem:nRealHeight := ::oSelected:nRealHeight
   next
else
   if .not. ::lSelecteds
      ? "Seleccione elementos"
   else
      ? "Debe seleccionar el elemento de referencia"
   endif
   return 0
endif

::Refresh()

return 0

***********************************************************************************************************************************
      METHOD SameWidth() CLASS TC5Report
***********************************************************************************************************************************
local nLen := len(::aItems)
local oItem
local n

if ::lSelecteds .and. ::oSelected <> nil
   for n := 1 to nLen
       oItem := ::aItems[n]
       oItem:nRealWidth := ::oSelected:nRealWidth
   next
else
   if .not. ::lSelecteds
      ? "Seleccione elementos"
   else
      ? "Debe seleccionar el elemento de referencia"
   endif
   return 0
endif

::Refresh()

return 0

***********************************************************************************************************************************
      METHOD SameSize() CLASS TC5Report
***********************************************************************************************************************************
local nLen := len(::aItems)
local oItem
local n

if ::lSelecteds .and. ::oSelected <> nil
   for n := 1 to nLen
       oItem := ::aItems[n]
       oItem:nRealHeight := ::oSelected:nRealHeight
       oItem:nRealWidth := ::oSelected:nRealWidth
   next
else
   if .not. ::lSelecteds
      ? "Seleccione elementos"
   else
      ? "Debe seleccionar el elemento de referencia"
   endif
   return 0
endif

::Refresh()

return 0



***********************************************************************************************************************
    METHOD Scroll( cType, nUnits ) CLASS TC5Report
***********************************************************************************************************************

DEFAULT nUnits := 10
DEFAULT cType  := "down"

if valtype( nUnits ) == "C"; nUnits := val( nUnits ); endif

do case
   case cType == "up"
        ::OffsetY( -nUnits )
   case cType == "down"
        ::OffsetY( nUnits )
   case cType == "left"
        ::OffsetX( -nUnits )
   case cType == "right"
        ::OffsetX( nUnits )
endcase
::Refresh()

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
//::lSelecteds := .t.
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

//if lShift
//   nVInc *= 5
//   nHInc *= 5
//endif


if ::lSelecteds
   for n := 1 to nLen
       oItem := ::aItems[n]
       if oItem:lSelected
          oItem:aOldPos := {oItem:aCoords[1], oItem:aCoords[2], oItem:aCoords[4]-oItem:aCoords[2], oItem:aCoords[3]-oItem:aCoords[1]}
          if lShift
             do case
                case cDir == "up"
                     oItem:aCoords[3] := max( oItem:aCoords[1]+1, oItem:aCoords[3]+nVInc )
                case cDir == "down"
                     oItem:aCoords[3] := oItem:aCoords[3]+nVInc
                case cDir == "left"
                     oItem:aCoords[4] := max( oItem:aCoords[2]+1, oItem:aCoords[4]+nHInc )
                case cDir == "right"
                     oItem:aCoords[4] := oItem:aCoords[4]+nHInc
             endcase
          else
             oItem:aCoords[1] += nVInc
             oItem:aCoords[3] += nVInc
             oItem:aCoords[2] += nHInc
             oItem:aCoords[4] += nHInc
          endif
       endif
   next
else
   if ::oSelected != nil
      oItem := ::oSelected
      oItem:aOldPos := {oItem:aCoords[1], oItem:aCoords[2], oItem:aCoords[4]-oItem:aCoords[2], oItem:aCoords[3]-oItem:aCoords[1]}
      if lShift
         do case
            case cDir == "up"
                 oItem:aCoords[3] := max( oItem:aCoords[1]+1, oItem:aCoords[3]+nVInc )
            case cDir == "down"
                 oItem:aCoords[3] := oItem:aCoords[3]+nVInc
            case cDir == "left"
                 oItem:aCoords[4] := max( oItem:aCoords[2]+1, oItem:aCoords[4]+nHInc )
            case cDir == "right"
                 oItem:aCoords[4] := oItem:aCoords[4]+nHInc
         endcase
      else
         oItem:aCoords[1] += nVInc
         oItem:aCoords[3] += nVInc
         oItem:aCoords[2] += nHInc
         oItem:aCoords[4] += nHInc
      endif
   endif
endif

::Refresh()

return 0

*******************************************************************************************************************************
      METHOD SizeItems( nWidth, nHeight ) CLASS TC5Report
*******************************************************************************************************************************

local n
if valtype( nWidth ) == "C"; nWidth := val( nWidth ); endif
if valtype( nHeight ) == "C"; nHeight := val( nHeight ); endif

      for n := 1 to len( ::aItems )
          if ::aItems[n]:lSelected .or. ( ::oSelected != nil .and. ::oSelected:nID == ::aItems[n]:nId )
             if !empty( nWidth );  ::aItems[n]:nWidth  := nWidth ; endif
             if !empty( nHeight ); ::aItems[n]:nHeight := nHeight; endif
          endif
      next
      ::Refresh()

retur 0

*******************************************************************************************************************************
      METHOD MoveTo( nTop, nLeft ) CLASS TC5Report
*******************************************************************************************************************************
local nT,nL
local nWidth, nHeight

if valtype( nTop )  == "C"; nTop  := val( nTop  ); endif
if valtype( nLeft ) == "C"; nLeft := val( nLeft ); endif

  // movemos ::oSelected
  if ::oSelected != nil

    //T      := ::oSelected:aCoords[1]
    //L      := ::oSelected:aCoords[2]
     nWidth  := ::oSelected:aCoords[4]-::oSelected:aCoords[2]
     nHeight := ::oSelected:aCoords[3]-::oSelected:aCoords[1]

     if !empty( nTop )
        ::oSelected:aCoords[1] := nTop
        ::oSelected:aCoords[3] := nTop + nHeight
     endif
     if !empty( nLeft )
        ::oSelected:aCoords[2] := nLeft
        ::oSelected:aCoords[4] := nLeft + nWidth
     endif

     ::Refresh()

  endif

return 0

*******************************************************************************************************************************
      METHOD nWidthItems( nValue ) CLASS TC5Report
*******************************************************************************************************************************

local n
if valtype( nValue ) == "C"; nValue := val( nValue ); endif

  for n := 1 to len( ::aItems )
      if ::aItems[n]:lSelected .or. ( ::oSelected != nil .and. ::oSelected:nID == ::aItems[n]:nId )
         if !empty( nValue )
            ::aItems[n]:nWidth := nValue
         endif
      endif
  next
  ::Refresh()

return 0




*******************************************************************************************************************************
      METHOD Zoom( nValue ) CLASS TC5Report
*******************************************************************************************************************************

local rc     := GetClientRect(::hWnd)
local nMed   := (rc[4]-rc[2])/2
local nWidth := ::aCoords[4]-::aCoords[2]
local nLeft

if valtype( nValue ) == "C"; nValue := val( nValue ); endif

if nValue != nil
   ::nZoom      := min(max(nValue, 10),500)
   ::Refresh(.t.)
endif

if ::oHRule != nil
   ::oHRule:MakeRule()
   ::oHRule:Refresh()
endif

if ::oVRule != nil
   ::oVRule:MakeRule()
   ::oVRule:Refresh()
endif

//oWnd():cTitle := "Reports " + alltrim(str(::nZoom)) + " %"


return ::nZoom

*******************************************************************************************************************************
      METHOD nRTop   ( nNew ) CLASS TC5Report
*******************************************************************************************************************************

if nNew != nil
   ::aCoords[1] := nNew
endif

return ::aCoords[1] * ::nZoom / 100

*******************************************************************************************************************************
      METHOD nRLeft  ( nNew ) CLASS TC5Report
*******************************************************************************************************************************
if nNew != nil
   ::aCoords[2] := nNew
endif

return ::aCoords[2] * ::nZoom / 100


*******************************************************************************************************************************
      METHOD nRBottom( nNew ) CLASS TC5Report
*******************************************************************************************************************************
if nNew != nil
   ::aCoords[3] := nNew
endif

return ::aCoords[3] * ::nZoom / 100

*******************************************************************************************************************************
      METHOD nRRight ( nNew ) CLASS TC5Report
*******************************************************************************************************************************
if nNew != nil
   ::aCoords[4] := nNew
endif

return ::aCoords[4] * ::nZoom / 100

*******************************************************************************************************************************
      METHOD nRWidth ( nNew ) CLASS TC5Report
*******************************************************************************************************************************

if nNew != nil
   ::aCoords[4] := ::aCoords[2] + nNew
endif

return (::aCoords[4]-::aCoords[2]) * ::nZoom / 100


*******************************************************************************************************************************
      METHOD nRHeight( nNew ) CLASS TC5Report
*******************************************************************************************************************************

if nNew != nil
   ::aCoords[3] := ::aCoords[1] + nNew
endif

return (::aCoords[3]-::aCoords[1]) * ::nZoom / 100

*******************************************************************************************************************************
      METHOD OffsetItems( nRow, nCol ) CLASS TC5Report
*******************************************************************************************************************************
local n

if valtype( nRow ) == "C"; nRow := val( nRow ); endif
if valtype( nCol ) == "C"; nCol := val( nCol ); endif


   for n := 1 to len( ::aItems )
       if ::aItems[n]:lSelected .or. ( ::oSelected != nil .and. ::oSelected:nID == ::aItems[n]:nId )
          if !Empty( nCol ); ::aItems[n]:OffsetX( nCol ) ; endif
          if !Empty( nRow ); ::aItems[n]:OffsetY( nRow ) ; endif
       endif
   next
   ::Refresh()

return 0

*******************************************************************************************************************************
      METHOD OffsetX( nVal ) CLASS TC5Report
*******************************************************************************************************************************

::aCoords[2] += nVal
::aCoords[4] += nVal

return nVal


*******************************************************************************************************************************
      METHOD OffsetY( nVal ) CLASS TC5Report
*******************************************************************************************************************************

::aCoords[1] += nVal
::aCoords[3] += nVal

return 0



*******************************************************************************************************************************
      METHOD ToBack() CLASS TC5Report
*******************************************************************************************************************************
local oItem
local nItem := 0
local n
local nLen := len( ::aItems )

if ::oSelected == nil
   return 0
endif

for n := 1 to nLen
    if ::oSelected:nID == ::aItems[n]:nId
       nItem := n
       exit
    endif
next

if nItem <= 1
   return 0
endif

oItem         := ::aItems[n-1]
::aItems[n-1] := ::oSelected
::aItems[n]   := oItem
::Refresh()

return 0

*******************************************************************************************************************************
      METHOD ToFront() CLASS TC5Report
*******************************************************************************************************************************
local oItem
local nItem := 0
local n
local nLen := len( ::aItems )

if ::oSelected == nil
   return 0
endif

for n := 1 to nLen
    if ::oSelected:nID == ::aItems[n]:nId
       nItem := n
       exit
    endif
next

if nItem >= nLen
   return 0
endif

oItem         := ::aItems[nItem+1]
::aItems[n+1] := ::oSelected
::aItems[n]   := oItem
::Refresh()

return 0







******************************************************************************************************************
      METHOD nRealTop ( nNew )   CLASS TC5Report
******************************************************************************************************************
local nH := ::aCoords[3]-::aCoords[1]

   if nNew != nil
      ::aCoords[1] := nNew
      ::aCoords[3] := nNew + nH
   endif

return ::aCoords[1]

******************************************************************************************************************
      METHOD nRealLeft ( nNew )   CLASS TC5Report
******************************************************************************************************************
local nW := ::aCoords[4]-::aCoords[2]

   if nNew != nil
      ::aCoords[2] := nNew
      ::aCoords[4] := nNew + nW
   endif

return ::aCoords[2]

******************************************************************************************************************
      METHOD nRealWidth ( nNew )   CLASS TC5Report
******************************************************************************************************************
   if nNew != nil
      ::aCoords[4] := ::aCoords[2] + nNew
   endif

return ::aCoords[4] - ::aCoords[2]

******************************************************************************************************************
      METHOD nRealHeight ( nNew )   CLASS TC5Report
******************************************************************************************************************
   if nNew != nil
      ::aCoords[3] := ::aCoords[1] + nNew
   endif

return ::aCoords[3]-::aCoords[1]


******************************************************************************************************************
   METHOD cOrientation( cValue ) CLASS TC5Report
******************************************************************************************************************
local nW := ::nRealWidth()
local nH := ::nRealHeight()
local nAux

if cValue != nil
   if cValue == "Vertical"
      if nW > nH
         ::nRealWidth := nH
         ::nRealHeight := nW
      endif
   else
      if nW < nH
         ::nRealWidth := nH
         ::nRealHeight := nW
      endif
   endif
   ::cxOrientation := cValue
endif
return ::cxOrientation


******************************************************************************************************************
   METHOD SetProperties( lReset ) CLASS TC5Report
******************************************************************************************************************
Local nGroup, oInsp := Inspector()
local hDC, aFonts
local nColor

     DEFAULT lReset := .t.

     oInsp:Reset()
     oInsp:oObject := self

     nGroup := oInsp:AddGroup( "Información" )

     oInsp:AddItem( "", "Tipo", "Diseñador",,nGroup,,.F. )

     nGroup := oInsp:AddGroup( "Posición" )

     oInsp:AddItem( "nRealTop",    "Arriba",    int(::nRealTop)   ,,nGroup )
     oInsp:AddItem( "nRealLeft",   "Izquierda", int(::nRealLeft)  ,,nGroup )
     oInsp:AddItem( "nRealWidth",  "Ancho",     int(::nRealWidth) ,,nGroup )
     oInsp:AddItem( "nRealHeight", "Alto",      int(::nRealHeight),,nGroup )

     nGroup := oInsp:AddGroup( "Apariencia" )

     oInsp:AddItem( "cTipoPapel",   "Tipo papel" , ::cTipoPapel  ,LISTA,nGroup,,,{|| aPapers() } )
     oInsp:AddItem( "cOrientation", "Orientación", ::cOrientation,LISTA,nGroup,,,{||{"Vertical","Horizontal"}} )
     oInsp:AddItem( "nZoom", "Zoom", ::nZoom,SPINNER,nGroup,,,,{||::Zoom() } )
     oInsp:AddItem( "lSeeToMove", "Ver al arrastrar", ::lSeeToMove,,nGroup,,,, )




     oInsp:GoTop()
     oInsp:Refresh()

return nil





*****************************************************************************************************
      METHOD Undo() CLASS TC5Report
*****************************************************************************************************

local aUndo
local oShape
local cAction
local uVal1
local uVal2
local uVal3
local uVal4
local uVal5
local nVeces
local n

if empty( ::aUndo )
   MsgAlert( "No hay acciones para deshacer" )
   return nil
endif
::lDoUndo := .t.
aUndo := atail( ::aUndo )
nVeces  := aUndo[1]

DEFAULT nVeces := 1

for n := 1 to nVeces

   aUndo := atail( ::aUndo )

   oShape  := aUndo[2]
   cAction := aUndo[3]
   uVal1   := aUndo[4]
   uVal2   := aUndo[5]
   uVal3   := aUndo[6]
   uVal4   := aUndo[7]
   uVal5   := aUndo[8]

   OSend( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 )

   adel( ::aUndo, len( ::aUndo ) )
   asize( ::aUndo, len( ::aUndo )-1 )

   if empty( ::aUndo )
      oUndo():Disable()
      oUndo():Refresh()
   endif

next

::lDoUndo := .f.

::Refresh()
if ::oSelected != nil
   ::oSelected:SetProperties()
endif


return nil

*****************************************************************************************************
  METHOD TreeToReport() CLASS TC5Report
*****************************************************************************************************
local oTItem := oTree():GetSelected()
local oItem

if oTItem != nil
   oItem := oTItem:cargo
   if oItem != nil
      if oItem:ClassName() == ::ClassName()
         ::oSelected := nil
         ::SetProperties()
      else
         ::Select(oItem)
      endif
      //SysRefresh()
      ::Refresh()
   endif
endif

return 0

*****************************************************************************************************
      METHOD ReportToTree( oItem ) CLASS TC5Report
*****************************************************************************************************
local oTreeItem := cSearchItem( oTree():aItems, oItem:cItemName() )

if oTreeItem != nil
   oTree():Select( oTreeItem )
endif

return 0

*****************************************************************************************************
      METHOD Select( oItem, lPartial ) CLASS TC5Report
*****************************************************************************************************
local cClassName := oItem:ClassName()
local n
local nCount := 0

DEFAULT lPartial := .f.

if valtype( oItem ) == "C"
   oItem := val( oItem )
endif

if valtype( oItem ) == "N"
   for n := 1 to len( ::aItems )
       if ::aItems[n]:nID == oItem
          oItem := ::aItems[n]
          exit
       endif
   next
   if valtype( oItem ) == "N"
      MsgStop( "Item " + str( oItem ) + " no encontrado" )
      return 0
   endif
else
   if valtype( oItem ) == "A"
      for n := 1 to len( oItem )
          if oItem[n] != nil
             nCount++
          endif
      next
      for n := 1 to len( oItem )
          if oItem[n] != nil
             ::Select( oItem[n], nCount > 1 )
          endif
      next
      return 0
   endif
endif

if lPartial
   oItem:lSelected := .t.
else
   ::oSelected := oItem
   ::ReportToTree( oItem )
   oItem:SetProperties()
   ::ReportToTree( oItem )

   if cClassName == "TC5RPTITEMTEXT" .or. cClassName == "TC5RPTITEMFIELD"
      oFaceName( ::oSelected:cFaceName )
          oBold( ::oSelected:    lBold )
        oItalic( ::oSelected:  lItalic )
         oUnder( ::oSelected:   lUnder )
        oStrike( ::oSelected:  lStrike )
   endif
endif

return nil





static function cSearchItem( aItems, cItem )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := cSearchItem( aItems[ n ]:aItems, cItem ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:cPrompt == cItem
         return aItems[ n ]
      endif
   next

return nil




return 0



*****************************************************************************************
   METHOD SaveToBin() CLASS TC5Report
*****************************************************************************************
local n, nLen
local oIni
local cStr := ""
local cVersion := VERSION

//if cFileName == nil
//   cFileName := cGetFile( "*.c5r","Guardar...", 1, , .t. )
//endif
//
//if lower(right(cFileName,4 ) ) != ".c5r"
//   if at(".",cFileName) == 0
//      cFileName += ".c5r"
//   endif
//endif
//
//if file( cFileName )
//   if !MsgYesNo( "El fichero" + CRLF + cFileName + CRLF + "Ya existe" + CRLF + CRLF + "¿Desea sobreescribirlo?")
//      MsgInfo("Proceso cancelado")
//      return 0
//   endif
//   DeleteFile( cFileName )
//endif





 cStr += str(::aCoords[1],4)
 cStr += str(::aCoords[2],4)
 cStr += str(::aCoords[3],4)
 cStr += str(::aCoords[4],4)
 cStr += str(len(::cTipoPapel),3)
 cStr += ::cTipoPapel
 cStr += str(::nZoom,3)
 cStr += str(len(::aItems),10)

 cStr := VERSION + str(len(cStr),6) + cStr

 for n := 1 to len( ::aItems )
     cStr += ::aItems[n]:Save()
 next n

// MemoWritEx( cFileName, cStr )

return 0



*****************************************************************************************
   METHOD SaveToIni( cFileName, lGrabar ) CLASS TC5Report
*****************************************************************************************
local n, nLen
local oIni
local cStr := ""

DEFAULT lGrabar := .t.

if lGrabar
   if cFileName == nil
      cFileName := cGetFile( "*.ini","Guardar...", 1, , .t. )
   endif

   if lower(right(cFileName,4 ) ) != ".ini"
      if at(".",cFileName) == 0
         cFileName += ".ini"
      endif
   endif

   if file( cFileName )
      if !MsgYesNo( "El fichero" + CRLF + cFileName + CRLF + "Ya existe" + CRLF + CRLF + "¿Desea sobreescribirlo?")
         MsgInfo("Proceso cancelado")
         return 0
      endif
      DeleteFile( cFileName )
   endif
endif

 cStr += "[Report]" + CRLF
 cStr += "nTop="    + alltrim(str( ::aCoords[1]              ))+CRLF
 cStr += "nLeft="   + alltrim(str( ::aCoords[2]              ))+CRLF
 cStr += "nWidth="  + alltrim(str( ::aCoords[4]-::aCoords[2] ))+CRLF
 cStr += "nHeight=" + alltrim(str( ::aCoords[3]-::aCoords[1] ))+CRLF
 cStr += "cType="   + ::cTipoPapel                             +CRLF
 cStr += "nItems="  + alltrim(str( len( ::aItems ) ))          +CRLF
 cStr += "nZoom="   + alltrim(str( ::nZoom ))                  +CRLF+CRLF

    for n := 1 to len( ::aItems )
        cStr += ::aItems[n]:SaveToIni( oIni, n )
    next n

 if lGrabar
    memowritEx( cFileName, cStr )
 endif

return cStr


*****************************************************************************************
   METHOD SaveToXML( cFileName, lGraba ) CLASS TC5Report
*****************************************************************************************
local n, nLen
local oIni
local buffer
local nmanejador

DEFAULT lGraba := .t.

if lGraba
   if cFileName == nil
      cFileName := cGetFile( "*.xml","Guardar...", 1, , .t. )
   endif

   if lower(right(cFileName,4 ) ) != ".xml"
      if at(".",cFileName) == 0
         cFileName += ".xml"
      endif
   endif

   if file( cFileName )
      if !MsgYesNo( "El fichero" + CRLF + cFileName + CRLF + "Ya existe" + CRLF + CRLF + "¿Desea sobreescribirlo?")
         MsgInfo("Proceso cancelado")
         return 0
      endif
      DeleteFile( cFileName )
   endif
endif


  buffer := '<?xml version="1.0" encoding="ISO-8859-1"?>' + CRLF

  buffer+='<Report xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../xsd/1002.xsd">'+CRLF
//  buffer+='<nTop>'    + alltrim(str(::aCoords[1]))             + '</nTop>'    + CRLF
//  buffer+='<nLeft>'   + alltrim(str(::aCoords[2]))             + '</nLeft>'   + CRLF
  buffer+='<nWidth>'  + alltrim(str(hPix2MM(::aCoords[4]-::aCoords[2])))+ '</nWidth>'  + CRLF
  buffer+='<nHeight>' + alltrim(str(vPix2MM(::aCoords[3]-::aCoords[1])))+ '</nHeight>' + CRLF
  buffer+='<cType>'   + ::cTipoPapel                           + '</cType>'   + CRLF
  buffer+='<nItems>'  + alltrim(str(len(::aItems)))            + '</nItems>'  + CRLF
  buffer+='<nZoom>'   + alltrim(str(::nZoom))                  + '</nZoom>'   + CRLF

  for n := 1 to len( ::aItems )
      buffer += ::aItems[n]:SaveToXML( oIni, n )
  next n

  buffer+='</Report>'

  if lGraba
     nmanejador:=FCREATE(cFileName, 0)
     FWRITE(nManejador, alltrim(buffer))
     FCLOSE(nManejador)
  endif

return buffer

*****************************************************************************************
   METHOD Preview() CLASS TC5Report
*****************************************************************************************
local n
local nLen     := len( ::aItems )
local oItem
local nType
local oPrint   := TPrinter():New( "C5Report",.t.,.t.,,,,{0,0,29700,21000} )
local nWidth   := oPrint:nHorzRes()
local nHeight  := oPrint:nVertRes()
//local nLogPixX := Round( nWidth / (oPrint:nHorzSize()/25.4), 0 )
//local nLogPixY := Round( nHeight/ (oPrint:nVertSize()/25.4), 0 )
local nLogPixX := oPrint:nLogPixelX()
local nLogPixY := oPrint:nLogPixelY()


local oPen
local nTop
local nLeft
local nBottom
local nRight
local oFont

local nEscapement   := 0
local nOrientation  := 0
local nWeight       := 0
local lItalic       := 0
local lUnderline    := 0
local lStrikeOut    := 0
local nCharSet      := 0
local nOutPrecision := 0
local nClipPrecision := 0
local nQuality      := 0
local nPitchFamily  := 0
local hBmp


oPrint:StartPage()

for n := 1 to nLen

    oItem := ::aItems[n]
    nType := oItem:nType
    do case
       case nType == C5TEXTO

           // oFont := TFont():New( oItem:cFaceName, 0, -oItem:nHFont, .f.,;
           //    oItem:lBold, oItem:nGiro*10, nOrientation, nWeight, oItem:lItalic,;
           //    oItem:lUnder, oItem:lStrike, nCharSet, nOutPrecision,;
           //    nClipPrecision, nQuality, oPrint, nPitchFamily )

oFont := TFont():New( oItem:cFaceName,;
          0,;
          -oItem:nHFont* nLogPixY /72,;
          .f.,;
          oItem:lBold,;
          oItem:nGiro*10,;
          0,;
          0,;
          oItem:lItalic,;
          oItem:lUnder,;
          oItem:lStrike,;
          0,;
          0,;
          0,;
          0 )

            nTop    := oItem:nMMTop   /10
            nLeft   := oItem:nMMLeft  /10
            oPrint:Cmtr2Pix( @nTop, @nLeft )

            nBottom := oItem:nMMBottom/10
            nRight  := oItem:nMMRight /10
            oPrint:Cmtr2Pix( @nBottom, @nRight )

            oPrint:C5Say( nTop, nLeft, oItem:cCaption, oFont, nRight-nLeft, nBottom-nTop,oItem:nClrText, oItem:lTransparent,;
                        oItem:nAlign, 0, oItem:nClrPane ) //oItem:nGiro

            oFont:End()


       case nType == C5RECT

            if oItem:lMidRound
               oPen := TPenExt():New( oItem:nPen, oItem:nClrPen, oPrint )
            else
               DEFINE PEN oPen ;
                      STYLE 0 ;
                      WIDTH Int(oItem:nPen * nLogPixX/72) ;
                      COLOR oItem:nClrPen
            endif

            nTop    := oItem:nMMTop   /10
            nLeft   := oItem:nMMLeft  /10
            nBottom := oItem:nMMBottom/10
            nRight  := oItem:nMMRight /10


            oPrint:Cmtr2Pix( @nTop, @nLeft )
            oPrint:Cmtr2Pix( @nBottom, @nRight )

            oPrint:C5Box( nTop, nLeft, nBottom, nRight, oPen, oItem:lTransparent, oItem:nClrPane,;
             oItem:lGrad, oItem:nClrPane2, oItem:cTypeGrad, oItem:lRoundRect, oItem:lMidRound, oItem:lOnlyCorners,;
             oItem:nRW, oItem:nRH )

            oPen:End()

       case nType == C5LINE

            DEFINE PEN oPen ;
                   STYLE 0 ;
                   WIDTH Int(oItem:nPen * nLogPixX/72) ;
                   COLOR oItem:nClrPen

            nTop    := oItem:nMMTop   / 10
            nLeft   := oItem:nMMLeft  / 10
            nBottom := oItem:nMMBottom/ 10
            nRight  := oItem:nMMRight / 10

            oPrint:Cmtr2Pix( @nTop, @nLeft )
            oPrint:Cmtr2Pix( @nBottom, @nRight )


            oPrint:Line( nTop, nLeft, nBottom, nRight, oPen )

            oPen:End()

       case nType == C5BITMAP

            nTop    := oItem:nMMTop   /10
            nLeft   := oItem:nMMLeft  /10
            nBottom := oItem:nMMBottom/10
            nRight  := oItem:nMMRight /10
            oPrint:Cmtr2Pix( @nTop, @nLeft )
            oPrint:Cmtr2Pix( @nBottom, @nRight )

            hBmp := C5FILoadImg( AllTrim( oItem:cBmp ) )
            oPrint:SayImage( nTop, nLeft, hBmp, nRight-nLeft, nBottom-nTop, ,oItem:lTransparent )
            DeleteObject( hBmp )

    endcase

next

oPrint:EndPage()
rpreview( oPrint )





oPrint:End()

return 0

*****************************************************************************************
   METHOD C5CommandLine( nRow, nCol ) CLASS TC5Report
*****************************************************************************************
local oDlg
local oFont
local oCmd
local cCmd := space( 500 )
local lCancel := .t.
local rc := GetClientRect(GetDesktopWindow())
local nH := 20
local nW := 400

DEFAULT nRow := rc[3]- 140
DEFAULT nCol := rc[4]/2 - nW/2


DEFINE FONT oFont NAME "Verdana" SIZE 0, -11 BOLD


DEFINE DIALOG oDlg STYLE nOr( WS_POPUP ) ;        //, DS_MODALFRAME
       FROM nRow, nCol TO nRow + nH, nCol + nW PIXEL

       oCmd := TC5Get():New( 0, 0, { | u | If( PCount()==0, cCmd, cCmd:= u ) },, 24, 300,,,,, oFont, .F.,, .T.,, .F.,, .F., .F.,, .F., .F., .F.,, .F.,,,, )
       //@ 0,0 GET oCmd VAR cCmd SIZE 24, 300 PIXEL FONT oFont
       oCmd:bGotFocus := {|| oCmd:SetSel( 0, len( rtrim( oCmd:GetText())))}

       oCmd:bKeyChar := {|nKey| ::KeyDownCmd( nKey, oDlg, oCmd )}
       oCmd:bKeyAction := {|nKey| ::KeyDownCmd( nKey, oDlg, oCmd ) }

       oDlg:oClient := oCmd

ACTIVATE DIALOG oDlg ON INIT oCmd:Move( 0, 0, oDlg:nWidth-1, oDlg:nHeight-1,.t.)

if lCancel
   return 0
endif

return 0

*****************************************************************************************
   METHOD KeyDownCmd( nKey, oDlg, oGet, lScript, cCmd ) CLASS TC5Report
*****************************************************************************************

local aTokens
local cAction
local cObject
local nParams
local nTop
local nLeft
local nWidth, nHeight
local oItem
local nAux1
local nAux2
local nAux3
local nAux4
local cAux1
local cClassName
local nVeces := 1
local n

DEFAULT lScript := .f.


if !lScript

   if nKey == VK_ESCAPE
      return oDlg:End()
   endif

   if GetKeyState( VK_CONTROL ) .and.;
      ( nKey == VK_UP   .or. nKey == VK_DOWN .or. nKey == VK_LEFT .or. nKey == VK_RIGHT )

        do case
           case nKey == VK_UP
                oGet:cText( padr( "up",500) )
           case nKey == VK_DOWN
                oGet:cText( padr( "down",500) )
           case nKey == VK_LEFT
                oGet:cText( padr( "left",500) )
           case nKey == VK_RIGHT
                oGet:cText( padr( "right",500) )
        endcase
        nKey := 13
   else
      if !empty( ::aActions ) .and. ( nKey == VK_UP .or. nKey == VK_DOWN )

         if nKey == VK_UP
            ::nAction --
            if ::nAction < 1
               ::nAction := len( ::aActions )
            endif
         else
            ::nAction ++
            if ::nAction > len( ::aActions )
               ::nAction := 1
            endif
         endif
         oGet:cText( padr( ::aActions[::nAction],500) )
      endif
   endif

   if nKey != 13
      return 1
   endif

   cCmd    := alltrim(oGet:GetText())

endif

if empty( cCmd )
   return .f.
endif

aTokens := aTokens( cCmd )
asize( aTokens, 10 )
nParams := len( aTokens )

if !lScript
   oGet:SetSel( 0, len( rtrim(cCmd) ))
   if empty( aTokens[1] )
      return ::ErrorSintaxisCmd()
   endif
endif

cAction := lower( aTokens[1] )
if ascan( ::aActions, cCmd ) == 0
   aadd( ::aActions, cCmd )
endif
::nAction := len( ::aActions )

do case
   case left( cAction, 4 ) == "exit"
        if oDlg != nil
           oDlg:End()
        endif

   case left( cAction, 4 ) == "alig"

        if empty( aTokens[2] )
           return ::ErrorSintaxisCmd()
        endif

        ::Align( aTokens[2] )

   case cAction == "add" .or. left(cAction,4) == "crea"

        if empty( aTokens[2] )
           return ::ErrorSintaxisCmd()
        endif

        nTop := ::aSetPoint[1]-::aCoords[1]
        nLeft := ::aSetPoint[2]-::aCoords[2]

        if aTokens[3] == nil ; aTokens[3] := nTop  ; endif
        if aTokens[4] == nil ; aTokens[4] := nLeft ; endif

        ::Crea( aTokens[2], aTokens[3], aTokens[4], aTokens[5], aTokens[6] )

   case cAction == "copy"

        ::Copy()


   case left(cAction,4) == "clea"

        ::ClearSel()

   case cAction == "height"

        ::SizeItems( , val(aTokens[2]) )

   case cAction == "help" .or. cAction == "?"

        ::ShowHelpCmd()

   case cAction == "load" .or. cAction == "open"

        if aTokens[2] == "script"
           ::LoadScript( aTokens[3] )
        else
           ::Load( aTokens[2] )
        endif

    case cAction == "paste"

        ::Paste()

   case cAction == "quit"

        if oDlg != nil
           oDlg:End()
        endif

        oWnd():End()

   case left( cAction, 4 ) == "sele" .and. aTokens[2] == "all"

        ::SelectAll()

   case left( cAction, 4 ) == "sele"

        adel( aTokens, 1 )
        ::Select( aTokens )

   case left( cAction,4 ) == "move"

        DEFAULT nTop  := aTokens[2]
        DEFAULT nLeft := aTokens[3]

        if aTokens[2] == nil
           nTop := ::aSetPoint[1]-::aCoords[1]; nLeft := ::aSetPoint[2]-::aCoords[2]
        endif

        ::MoveTo( nTop, nLeft )

   case cAction == "next"

        ::GoNextItem()

   case left( cAction,4 ) == "offs"  //et

        ::OffSetItems( aTokens[2], aTokens[3] )

   case left( cAction, 4 ) == "prev"

        ::GoPrevItem()

   case left( cAction,4 ) == "port"
        ::Portrait()

   case left( cAction,4 ) == "land"
        ::LandScape()

   case left( cAction,4 ) == "prop"

        oDlg:End()
        SetFocus(Inspector():hWnd)
        Inspector():Refresh()

   case cAction == "save"

        ::Save()

   case cAction == "scroll"


        ::Scroll( aTokens[2], aTokens[3] )


   case cAction == "size"

        ::SizeItems( aTokens[2], aTokens[3] )

   case left( cAction,4 ) == "tree"

        oDlg:End()
        SetFocus(oTree():hWnd)
        oTree():Refresh()

   case cAction == "undo"

        ::Undo()

   case cAction == "width"

        ::nWidthItems( aTokens[2] )

   case cAction == "zoom"

        ::Zoom( aTokens[2] )

   case cAction == "show" .and. aTokens[2] != nil .and. aTokens[2] == "panel"
        ::ShowPanel()

   case cAction == "hide" .and. aTokens[2] != nil .and. aTokens[2] == "panel"
        ::HidePanel()

   case cAction == "sip"

        ::ShowInsertionPoint()

   case cAction == "hip"

        ::HideInsertionPoint()


   case cAction == "up"

        nAux1 := 1
        if aTokens[2] != nil
           nAux1 := val( aTokens[2] )
        endif
        ::aSetPoint[1] -= nAux1
        ::Refresh()

   case cAction == "down"

        nAux1 := 1
        if aTokens[2] != nil
           nAux1 := val( aTokens[2] )
        endif
        ::aSetPoint[1] += nAux1
        ::Refresh()

   case cAction == "right"

        nAux1 := 1
        if aTokens[2] != nil
           nAux1 := val( aTokens[2] )
        endif
        ::aSetPoint[2] += nAux1
        ::Refresh()

   case cAction == "left"

        nAux1 := 1
        if aTokens[2] != nil
           nAux1 := val( aTokens[2] )
        endif
        ::aSetPoint[2] -= nAux1
        ::Refresh()

   otherwise

        //if ::oSelected != nil
        //   if aTokens[3] != nil
        //     ::oSelected:SetProperty( aTokens[2], aTokens[3] )
        //     ::oSelected:Refresh()
        //     return 0
        //  endif
        //endif

        //::CmdNotSupported()
        if MsgYesNo( "¿Desea añadirlo como texto?","Comando desconocido")
           nTop := ::aSetPoint[1]-::aCoords[1]; nLeft := ::aSetPoint[2]-::aCoords[2]
           oItem := TC5RptItemText():New( self, nTop, nLeft, 100, 24, cCmd )
           oItem:aCoords[3] := oItem:aCoords[1]+18
           oItem:aCoords[4] := oItem:aCoords[2]+oItem:GetTextLenght()+2
           oItem:Refresh()
           if oItem != nil
              oReport():AddItem( oItem )
              ::Select( oItem, .f. )
           endif
        endif


endcase



return 0

*****************************************************************************************
    METHOD ShowHelpCMD() CLASS TC5Report
*****************************************************************************************
//   case cAction == "exit"
//
//   case cAction == "align"
//           case cAux1 == "top"
//           case cAux1 == "left"
//           case cAux1 == "bottom"
//           case cAux1 == "right"
//
//   case cAction == "add" .OR. cAction == "aadd"
//               case cObject == "text"
//               case cObject == "image"
//               case cObject == "vline" .or. cObject == "hline" .or. cObject == "line"
//               case cObject == "rectangle"
//               case cObject == "ellipse"
//               case cObject == "field"
//   case left(cAction,5) == "clear"
//   case cAction == "help" .or. cAction == "?"
//   case cAction == "select" .or. cAction == "go" .or. cAction == "goto"
//   case cAction == "selectall"
//   case left( cAction,4 ) == "move"
//   case left( cAction,4 ) == "prop"
//   case cAction == "undo"
//   case cAction == "zoom"
//



return 0

*****************************************************************************************
      METHOD GetBoxes() CLASS TC5Report
*****************************************************************************************
local oDeskTop
local hDib
local oBar
local oCursor := TCursor():New( ,"CROSS" )

oWnd():Hide()
syswait(1)

   ::hBmp := WndBitmap( GetDesktopWindow() )


DEFINE WINDOW oDeskTop TITLE "Boxes" FROM 0, 0 TO GetSysMetrics(1), GetSysMetrics(0) PIXEL BORDER NONE ;
       CURSOR oCursor

DEFINE BUTTONBAR oBar OF oDeskTop

       DEFINE BUTTON OF oBar ACTION if( !empty(::aMedida),;
                                   ( oReport():Crea( "rect", ::aMedida[1],::aMedida[2],;
                                                             ::aMedida[4]-::aMedida[2],;
                                                             ::aMedida[3]-::aMedida[1]),;
                                     ::aMedida := {}, oDesktop:Refresh() ),)
       DEFINE BUTTON OF oBar



oDeskTop:bPainted  := {|hDC| DrawBitmap( hDC, ::hBmp, 0, 0 ),if( !empty(::aMedida),Box(hDC, ::aMedida, CLR_HRED),) }
oDeskTop:bLClicked := {|nRow,nCol| if(empty(::aMedida),::aMedida := {nRow,nCol,nRow,nCol},;
                                   (::aMedida[3] := nRow, ::aMedida[4] := nCol, oDesktop:Refresh())) }


oDeskTop:Show()
oDeskTop:GoTop()
oDeskTop:bValid := {|| DeleteObject( ::hBmp ),oWnd():Show(),oWnd():GoTop(),.t.}


return 0

*****************************************************************************************
  METHOD lSelecteds() CLASS TC5Report
*****************************************************************************************
local lSelecteds := .f.
local n
local nLen := len(::aItems)
local nCount := 0

for n := 1 to nLen
    if ::aItems[n]:lSelected
       nCount++
    endif
    if nCount > 1
       lSelecteds := .t.
       exit
    endif
next

return lSelecteds




CLASS TC5Get FROM TGet

      CLASSDATA lRegistered AS LOGICAL
      DATA bKeyAction

      METHOD KeyDown( nKey, nFlags )

ENDCLASS

METHOD KeyDown( nKey, nFlags ) CLASS TC5Get

   do case

      case GetKeyState( VK_CONTROL ) .and. (nKey == VK_LEFT .or. nKey == VK_RIGHT)

         if ::bKeyAction != nil
            return eval( ::bKeyAction, nKey )
         endif

      case nKey == VK_UP .or. nKey == VK_DOWN

         if ::bKeyAction != nil
            return eval( ::bKeyAction, nKey )
         endif



   endcase

return super:KeyDown( nKey, nFlags )


function ReportVersion( cVal )

if cVal != nil
   cVersion := cVal
endif

return cVal
