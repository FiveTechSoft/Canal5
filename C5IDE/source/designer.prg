#include "fivewin.ch"
//#include "funcionc.h"
#include "wnddsgn.ch"
#include "Splitter.ch"

#define WM_ERASEBKGND 20 //0x0014
#define WM_SYSCHAR   262 //0x0106
#define SRCCOPY 13369376
#define IDC_SIZENWSE        32642
#define IDC_SIZENESW        32643
#define IDC_SIZEWE          32644
#define IDC_SIZENS          32645
#define GWL_STYLE         (-16)
#define DSGN_CLICKING  100


static nOldState
static oAux
static nVez := 0
static lNoClient := .f.
//static oWndActive := nil

static nClrReturn := nil
static cFaceName  := ""
static coControl  := ""

//function oWndActive( oWnd ); return oWndActive


function Designer( nType, cInfo, nWidth, nHeight )

local oWnd, oDsgn, oBar, oShape
local o0, o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19, o20, o21
local o22, o23, o24, o25, o26, o27, o28, o29, o30, o31, o32
local oPanel
local oBrush
local lVScroll := .t.
local lHScroll := .t.
local cTitle   := "Diseñador de formularios"
local oSplit
local oImageList
local oDirList
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )
local rc
nType := 0

if empty( nWidth ) .and. empty( nHeight )
   if nType == nil; nType := 0; endif
   do case
      case nType == 1
           cTitle  := "Pocket PC"
           nWidth  := 240
           nHeight := 320

      case nType == 2
           cTitle := "Pocket PC Square Screen"
           nWidth  := 240
           nHeight := 240

      case nType == 3
           cTitle := "SmartPhone"
           nWidth  := 176
           nHeight := 220
      otherwise

           cTitle := "Test"
           nWidth  := 321
           nHeight := 263
      endcase
endif

DEFINE BRUSH oBrush STYLE "NULL"

    WndFold()



//DEFINE WINDOW oWnd FROM Aplicacion():nTopForm, Aplicacion():nLeftForm TO Aplicacion():nTopForm+nHeight, Aplicacion():nLeftForm+nWidth PIXEL TITLE "Form" NOMAXIMIZE NOMINIMIZE
oWnd := TWindowExt():New( Aplicacion():nTopForm, Aplicacion():nLeftForm, Aplicacion():nTopForm+nHeight,Aplicacion():nLeftForm+nWidth, "Form",,,,,,,,,,,, !.F., !.F., !.F., !.F., .T. )
       rc := GetClientRect( oWnd:hWnd )

oWnd:Show()

    oDsgn := TDsgnEditor():New( 0, 0, rc[4], rc[3], oWnd )
    oDsgn:nType = nType

    oWnd:bCopy  := {|| if( oDsgn:oSelected != nil, oDsgn:oSelected:Copy(),) }
    oWnd:bPaste := {|| oDsgn:oForm:Paste( 40, 10, oDsgn ) }
    oWnd:bUndo  := {|| oDsgn:Undo() }
    oWnd:bSelectAll  := {|| oDsgn:SelectAll() }
    oWnd:bDelete  := {|| oDsgn:KeyDown( VK_DELETE ) }
    oWnd:bGotFocus := {|| UpAll() }

    oWnd:oClient := oDsgn

    oDsgn:lPocketPC( nType )



    oDsgn:oBtnBar := oBar

    oDsgn:oForm := TWndDsgn():New( 0, 0, nWidth, nHeight, oDsgn )

    oDsgn:oForm:SetFocus()

    oDsgn:oForm:SetGrid( 10 )


    oDsgn:bResized := {|| AdjustDsgn( oDsgn ) }
    AdjustDsgn( oDsgn )

       DEFINE SCROLLBAR oWnd:oHScroll HORIZONTAL   OF oWnd ;
          RANGE 12, 500 ;
          ON UP       oDsgn:GoLeft()   ;
          ON DOWN     oDsgn:GoRight()  ;
          ON PAGEUP   oDsgn:PageLeft()  ;
          ON PAGEDOWN oDsgn:PageRight() ;
          ON THUMBPOS oDsgn:HThumbPos( nPos )
          oWnd:oHScroll:SetPos( 6 )


       DEFINE SCROLLBAR oWnd:oVScroll VERTICAL OF oWnd ;
          RANGE 12, 500 ;
          ON UP       oDsgn:GoUp()    ;
          ON DOWN     oDsgn:GoDown()  ;
          ON PAGEUP   oDsgn:PageUp()   ;
          ON PAGEDOWN oDsgn:PageDown() ;
          ON THUMBPOS oDsgn:VThumbPos( nPos )
          oWnd:oVScroll:SetPos( 6 )


    oWnd:oHScroll:SetRange(0,0)
    oWnd:oVScroll:SetRange(0,0)


return oDsgn

function AddImages( aItems, oImgL, oDirList )
local images
local n, nLen

asize( oImgL:aItems, 0 )

nLen := len( aItems )

for n := 2 to nLen
    images := aItems[n]
    aadd( oImgL:aItems, oDirList:cPath + images[1] )
next

oImgL:Refresh()

return nil



FUNCTION AdjustDsgn( oWnd )
local aRect := GetClientRect( oWnd:hWnd )

oWnd:oForm:aRect := {0,0,aRect[3],aRect[4]}
oWnd:Refresh()

return nil


function Selection( o )
local oBtn

for each oBtn in o:oWnd:aControls

    oBtn:lPressed := (o:nId == oBtn:nId)

next

AEval( o:oWnd:aControls, { | oCtrl | oCtrl:Refresh() } )

return nil





CLASS TDsgnEditor FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aOldRect
      DATA aRectSel
      DATA aRedo
      DATA aSelecteds
      DATA aShapes
      DATA aTrash
      DATA aUndo
      DATA lBorder AS LOGICAL INIT .F.
      DATA lEditando
      DATA lKeyDown
      DATA lMoviendo
      DATA lRotatePPC
      DATA lSaved
      DATA lxPocketPC
      DATA lPaintGuideN AS LOGICAL INIT .F.
      DATA lPaintGuideW AS LOGICAL INIT .F.
      DATA lPaintGuideE AS LOGICAL INIT .F.
      DATA lPaintGuideS AS LOGICAL INIT .F.
      DATA nDeltaCol
      DATA nDeltaRow
      DATA nDotSelect
      DATA nHPPC
      DATA nLeftDbf
      DATA nOldCol
      DATA nOldRow
      DATA nOldCol2 AS NUMERIC INIT 0
      DATA nOldRow2 AS NUMERIC INIT 0
      DATA nTopDbf
      DATA nType
      DATA nTypePPC
      DATA nWPPC
      DATA oBtnBar
      DATA oFocused
      DATA oForm
      DATA oGet
      DATA oMsgItem
      DATA oSelected
      DATA nZoom   AS NUMERIC INIT 100

      METHOD New           ( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR
      METHOD AddShape      ( oShape )
      METHOD AddUndo       ( oShape, cAction, uVal1 )
      METHOD Align         ( oItem, nTo )
      METHOD CheckSelecteds( aRect )
      METHOD DbfToDialog   ( )
      METHOD Destroy       ( )
      METHOD Display       ( ) INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
      METHOD GetContainer  ( aRect )
      METHOD GoDown        ( )
      METHOD GoLeft        ( )
      METHOD GoNextCtrl    ( ) VIRTUAL
      METHOD GoRIght       ( )
      METHOD GoUp          ( )
      METHOD HThumbPos     ( nPos )
      METHOD HandleEvent   ( nMsg, nWParam, nLParam )
      METHOD Inspect       ( oShape )
      METHOD IsInSelecteds ( oShape )
      METHOD IsOverDot     ( nRow, nCol )
      METHOD KeyChar       ( nKey, nFlags )
      METHOD KeyDown       ( nKey, nKeyFlags )
      METHOD KeyUp         ( nKey, nKeyFlags )
      METHOD LButtonDown   ( nRow, nCol, nKeyFlags )
      METHOD LButtonUp     ( nRow, nCol, nKeyFlags )
      METHOD LDblCLick     ( nRow, nCol )
      METHOD MaxMin        ( )
      METHOD MouseMove     ( nRow, nCol, nKeyFlags )
      METHOD MouseWheel    ( nKeys, nDelta, nXPos, nYPos )
      METHOD NextShape     ( )
      METHOD OpenTrash     ( oBtn, lActivate )
      METHOD OpenFormat    () VIRTUAL
      METHOD PageDown()    INLINE ::GoDown( 30 )
      METHOD PageLeft()    INLINE ::GoLeft( 30 )
      METHOD PageRight()   INLINE ::GoRight( 30 )
      METHOD PageUp()      INLINE ::GoUp( 30 )
      METHOD Paint         ( )
      METHOD Paste         ( ) VIRTUAL
      METHOD PrevShape     ( )
      METHOD RButtonDown   ( nRow, nCol, nKeyFlags )
      METHOD ResetSelecteds( )
      METHOD RestoreTrash  ( o )
      METHOD Rotate        ( )
      METHOD SaveFile      ( )
      METHOD SaveFormat    ( )
      METHOD SelectAll     ( )
      METHOD Send2Trash    ( o, lTrash )
      METHOD ShapeOver     ( nRow, nCol )
      METHOD Size          ( nModo )
      METHOD SysKeyChar    ( nKey, nKeyFlags )
      METHOD TakeDrop      ( aFiles )
      METHOD Undo          ( )
      METHOD VThumbPos     ( nPos )
      METHOD Validate      ( )
      METHOD lPocketPC     ( lValue ) SETGET
      METHOD nState        ( ) INLINE Aplicacion():nState

ENDCLASS



**********************************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TDsgnEditor
**********************************************************************************************************************


   local o := self

   ::nTop         := nTop
   ::nLeft        := nLeft
   ::nBottom      := ::nTop + nHeight - 1
   ::nRight       := ::nLeft + nWidth - 1
   ::nStyle       := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP  )
   ::nId          := ::GetNewId()
   ::oWnd         := oWnd
   ::lCaptured    := .f.
   //::nState       := DSGN_SELECT
   ::aRectSel     := nil
   ::aShapes      := {}
   ::oFocused     := nil
   ::oSelected    := nil
   ::nDotSelect   := 0
   ::aOldRect     := array(4)
   ::aSelecteds   := {}
   ::lMoviendo    := .f.
   ::aUndo        := {}
   ::aRedo        := {}
   ::aTrash       := {}
   ::lSaved       := .f.
   ::lKeyDown     := .f.
   ::nTopDbf      := 30
   ::nLeftDbf     := 30

   ::lxPocketPC   := .f.
   ::nTypePPC     := 1
   ::nWPPC        := 240
   ::nHPPC        := 320
   ::lRotatePPC   := .f.
   ::bGotFocus    := {|| Aplicacion():oDFocus := self }

   DEFINE BRUSH ::oBrush STYLE "NULL"

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif
   /*::aMinMaxInfo = { 2000, 2030,;  // xMaxSize,      yMaxSize
                      6,      6,;  // xMaxPosition,  yMaxPosition
                    120,     54,;  // xMinTrackSize, yMinTrackSize
                   2150,    2150 }  // xMaxTrackSize, yMaxTrackSize
   */
   ::bDropFiles := {|nRow,nCol,aFiles| o:TakeDrop( aFiles ) }
   DragAcceptFiles( ::hWnd, .t. )

return Self



**********************************************************************************************************************
  METHOD Paint() CLASS TDsgnEditor
**********************************************************************************************************************
   local hDCMem
   local hBmpMem
   local aRect := GetClientRect(::hWnd)
   local hOldBmp
   local nLen
   local n
   local oFigura
   local hRegion, hRegion2
   local rc := {aRect[1],aRect[2],aRect[3],aRect[4]}
   local hOldFont, oFont


   if ::oForm != nil
      rc := ::oForm:GetClientRect()
   endif

   hDCMem  := CreateCompatibleDC( ::hDC )
   hBmpMem := CreateCompatibleBitmap( ::hDC, aRect[4], aRect[3] )
   hOldBmp := SelectObject( hDCMem, hBmpMem )

   if ::oForm != nil
      ::oForm:lCaption := .f.
      ::oForm:lBorder  := .f.

      if ::oForm:lCaption .and. lTemas() .and. C5_IsAppThemed() .and. C5_IsThemeActive()
         FillSolidRect( hDCMem, {0,0,4,aRect[4]}, CLR_WHITE )
         aRect[1]+=5
      endif
   endif

   FillSolidRect( hDCMem, {-1,-1,aRect[3]+2,aRect[4]+2}, if( ::oForm==nil,::nClrPane,::oForm:nClrPane), if(::lBorder,0,nil)  )//CLR_WHITE )

   nLen := len( ::aShapes )

   // Form
   if nLen > 0
      ::aShapes[nLen]:Paint( hDCMem )
   endif

   if ::oForm != nil
      //::oForm:DrawCaption( hDCMem )
      if ::oForm:oMenu != nil
         ::oForm:oMenu:Paint( hDCMem )
      endif
      if ::oForm:oBar != nil
         ::oForm:oBar:Paint( hDCMem )
      endif
   endif

   hRegion := CreateRectRgn( rc[2],  rc[1], rc[4], rc[3] )
   SelectClipRgn( hDCMem, hRegion )
   DeleteObject( hRegion )

   if ::oForm != nil
      oFont := ::oForm:GetFontEx()
      hOldFont := SelectObject( hDCMem, oFont:hFont )
   endif

   for n := nLen-1 to 1 step -1
       oFigura := ::aShapes[n]
       if oFigura:lVisibleInForm
          oFigura:Paint( hDCMem )
       endif
   next

   if ::oSelected != nil .and. ::lCaptured
      if ::lPaintGuideN
         Line( hDCMem, ::oForm:nHCaption, ::oSelected:aRect[2]+10, ::oSelected:aRect[1], ::oSelected:aRect[2]+10,rgb(150,169,221))
      endif
      if ::lPaintGuideW
         Line( hDCMem, ::oSelected:aRect[1]+10, 4,  ::oSelected:aRect[1]+10, ::oSelected:aRect[2],rgb(150,169,221))
      endif
      if ::lPaintGuideE
         Line( hDCMem, ::oSelected:aRect[1]+10, ::oSelected:aRect[4], ::oSelected:aRect[1]+10, ::nWidth,rgb(150,169,221))
      endif
      if ::lPaintGuideS
         Line( hDCMem, ::oSelected:aRect[3], ::oSelected:aRect[2]+10, ::nHeight, ::oSelected:aRect[2]+10,rgb(150,169,221))
      endif


   endif

   if ::oForm != nil
      SelectObject( hDCMem, hOldFont )
      oFont:End()
   endif

   if !empty( ::aRectSel )
      DrawFocusRect( hDCMem, ::aRectSel[1], ::aRectSel[2], ::aRectSel[3], ::aRectSel[4])
   endif

   SelectClipRgn( hDCMem, nil )

BitBlt( ::hDC, 0, 0, aRect[4], aRect[3], hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmpMem )
DeleteDC( hDCMem )


return 0


**********************************************************************************************************************
  METHOD AddShape( oShape ) CLASS TDsgnEditor
**********************************************************************************************************************

if len( ::aShapes ) == 0
   aadd( ::aShapes, oShape )
else
   aadd( ::aShapes, nil )
   ains( ::aShapes, 1   )
   ::aShapes[1] := oShape
endif

return nil


**********************************************************************************************************************
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnEditor
**********************************************************************************************************************
local oShape
local n, nLen
local oOver


::nDotSelect := ::IsOverDot( nRow, nCol )

if ::nDotSelect == 0
   nLen := len( ::aShapes )
   for n := 1 to nLen
       oShape := ::aShapes[n]
       oOver := oShape:ShapeOver( nRow, nCol )
       if oOver != nil
          return oOver
       endif
   next
else
   return ::oSelected
endif

return nil

**********************************************************************************************************************
      METHOD IsOverDot( nRow, nCol ) CLASS TDsgnEditor
**********************************************************************************************************************
local n

if ::oSelected != nil

   for n := 1 to 8
       if ::oSelected:aDotsActives[n] == 1 .and. PtInRect( nRow, nCol, ::oSelected:aDots[n] )
          return n
       endif
   next

endif

return 0

**********************************************************************************************************************
   METHOD LDblCLick( nRow, nCol ) CLASS TDsgnEditor
**********************************************************************************************************************

if ::oSelected != nil
   ::oSelected:EditDlg()
endif

return 0

**********************************************************************************************************************
      METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TDsgnEditor
**********************************************************************************************************************
local oOldSelected := ::oSelected
local oSel
local lClone := GetKeyState( VK_CONTROL )

if lAnd( nRow , 0x8000);   nRow := nOr(nRow,0xFFFF0000); end
if lAnd( nCol , 0x8000);   nCol := nOr(nCol,0xFFFF0000); end

::SetFocus()

if !::lCaptured

   if ::oForm != nil .and. nRow < ::oForm:nHCaption //+ 10
      return nil
   endif

   ::Capture()
   ::lCaptured := .t.

   ::nOldRow := nRow
   ::nOldCol := nCol


   oSel  := ::ShapeOver( nRow, nCol )

   if oOldSelected != nil .and. oOldSelected != oSel
      if oOldSelected:bLostFocus != nil
         eval( oOldSelected:bLostFocus )
      endif
   endif

   if oSel != nil

      oSel:SetFocus()

      if lClone




      else


         //if oOldSelected != nil .and. oOldSelected == ::oSelected
            if ::oSelected:bLClicked != nil
               if eval(::oSelected:bLClicked, nRow, nCol )
                  nOldState := ::nState
                  Aplicacion():nState := DSGN_CLICKING
                  return 0
               endif
            endif

         //endif

         ::oSelected:LButtonDown( nRow, nCol )

         ::oSelected:StorePos()

         if ::oSelected == atail(::aShapes ) .or. !::IsInSelecteds( ::oSelected )
            ::ResetSelecteds()
         endif

         if ::nDotSelect != 0
            Aplicacion():nState     := DSGN_SELECT
         endif

         ::nDeltaRow := nRow - ::oSelected:nTop
         ::nDeltaCol := nCol - ::oSelected:nLeft
         ::aOldRect  := {::oSelected:aRect[1],;
                         ::oSelected:aRect[2],;
                         ::oSelected:aRect[3],;
                         ::oSelected:aRect[4]}

      endif

   else

      if len(::aSelecteds) > 0
         ::ResetSelecteds()
      endif

   endif
endif

return 0



**********************************************************************************************************************
      METHOD MouseMove  ( nRow, nCol, nKeyFlags ) CLASS TDsgnEditor
**********************************************************************************************************************
local aRect, nWidth, nHeight, nEn, oShape, aPage, n, nLen, oPage
local nOldLeft, nOldTop
local nTop, nLeft, nBottom, nRight


if lAnd( nRow , 0x8000) ; nRow := nOr(nRow,0xFFFF0000); end
if lAnd( nCol , 0x8000) ; nCol := nOr(nCol,0xFFFF0000); end

::lMoviendo := .f.

if ::lCaptured

   if ::nState == DSGN_CLICKING
      return 0
   endif

   if ::oSelected == nil .or. (::oSelected != nil .and. !::oSelected:lCanMove .and. ::nDotSelect == 0)
      // seleccionando
      ::aRectSel := NormalizeRect( {::nOldRow, ::nOldCol, nRow, nCol } )

   else
      // Moviendo

      if ::oForm != nil
         if ::oForm:lGrid
         endif
      endif

      do case
         case ::nDotSelect == 0  .and. ::oSelected:lCanMove // CENTRO

              ::lMoviendo := .t.
//            OutPutDebugString( str(len(::aSelecteds))+ CRLF )
              if len( ::aSelecteds ) > 0

                 for each oShape in ::aSelecteds
                     oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                 next

              else


                   nTop  := nRow - ::nOldRow
                   nLeft := nCol - ::nOldCol



                   aRect := { ::oSelected:aOldPos[1]+nTop, ;
                              ::oSelected:aOldPos[2]+nLeft, ;
                              ::oSelected:aOldPos[3]+nTop, ;
                              ::oSelected:aOldPos[4]+nLeft  }


                   ::oSelected:Offset( nTop, nLeft )

                   ::nOldRow2 := nTop
                   ::nOldCol2 := nLeft


              endif

              CursorSize()

         case ::nDotSelect == 1  .and. ::oSelected:lCanSize // IZDA-UP

              aRect := NormalizeRect( { nRow, nCol, ::aOldRect[3], ::aOldRect[4]} )

              if nRow > ::aOldRect[3] - ::oSelected:nMinHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMinHeight
              endif

              if  nCol > ::aOldRect[4] - ::oSelected:nMinWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMinWidth
              endif

              if ::aOldRect[3] - nRow > ::oSelected:nMaxHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMaxHeight
              endif

              if  ::aOldRect[4] - nCol > ::oSelected:nMaxWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { nRow , nCol , ::aOldRect[3], ::aOldRect[4]    }

              if len( ::oSelected:aPages ) > 0
                 for each oPage in ::oSelected:aPages
                     for each oShape in oPage:aShapes
                         oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                     next
                 next
              endif

         case ::nDotSelect == 2  .and. ::oSelected:lCanSize // UP

              aRect := NormalizeRect( { nRow , ::aOldRect[2], ::aOldRect[3], ::aOldRect[4]} )

              if nRow > ::aOldRect[3] - ::oSelected:nMinHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMinHeight
              endif

              if ::aOldRect[3] - nRow > ::oSelected:nMaxHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMaxHeight
              endif


              ::oSelected:aRect := { nRow , ;
                                   ::aOldRect[2], ;
                                   ::aOldRect[3], ;
                                   ::aOldRect[4]    }

              if len( ::oSelected:aPages ) > 0
                 for each oPage in ::oSelected:aPages
                     for each oShape in oPage:aShapes
                         oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                     next
                 next
              endif

         case ::nDotSelect == 3  .and. ::oSelected:lCanSize // DCHA-UP

              aRect := NormalizeRect( { nRow , ::aOldRect[2], ::aOldRect[3], nCol } )

              if nRow > ::aOldRect[3] - ::oSelected:nMinHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMinHeight
              endif

              if  nCol < ::aOldRect[2] + ::oSelected:nMinWidth
                  nCol := ::aOldRect[2] + ::oSelected:nMinWidth
              endif

              if ::aOldRect[3] - nRow > ::oSelected:nMaxHeight
                 nRow := ::aOldRect[3] - ::oSelected:nMaxHeight
              endif

              if nCol > ::aOldRect[2] + ::oSelected:nMaxWidth
                 nCol := ::aOldRect[2] + ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { nRow , ;
                                   ::aOldRect[2], ;
                                   ::aOldRect[3], ;
                                   nCol    }

              if len( ::oSelected:aPages ) > 0
                 for each oPage in ::oSelected:aPages
                     for each oShape in oPage:aShapes
                         oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                     next
                 next
              endif

         case ::nDotSelect == 4 .and. ::oSelected:lCanSize  // DCHA


              aRect := NormalizeRect( { ::aOldRect[1], ::aOldRect[2], ::aOldRect[3], nCol } )

              if  nCol < ::aOldRect[2] + ::oSelected:nMinWidth
                  nCol := ::aOldRect[2] + ::oSelected:nMinWidth
              endif

              if nCol > ::aOldRect[2] + ::oSelected:nMaxWidth
                 nCol := ::aOldRect[2] + ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { ::aOldRect[1], ;
                                   ::aOldRect[2], ;
                                   ::aOldRect[3], ;
                                   nCol    }

         case ::nDotSelect == 5 .and. ::oSelected:lCanSize  // DCHA-DOWN

              aRect := NormalizeRect( { ::aOldRect[1], ::aOldRect[2], nRow, nCol    } )

              if nRow < ::aOldRect[1] + ::oSelected:nMinHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMinHeight
              endif

              if  nCol < ::aOldRect[2] + ::oSelected:nMinWidth
                  nCol := ::aOldRect[2] + ::oSelected:nMinWidth
              endif

              if nRow > ::aOldRect[1] + ::oSelected:nMaxHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMaxHeight
              endif

              if nCol > ::aOldRect[2] + ::oSelected:nMaxWidth
                 nCol := ::aOldRect[2] + ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { ::aOldRect[1], ;
                                   ::aOldRect[2], ;
                                   nRow, ;
                                   nCol    }

         case ::nDotSelect == 6 .and. ::oSelected:lCanSize  // DOWN

              aRect := NormalizeRect( { ::aOldRect[1],  ::aOldRect[2], nRow, ::aOldRect[4]  } )

              if nRow < ::aOldRect[1] + ::oSelected:nMinHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMinHeight
              endif

              //LogFile( "log.txt", { str(nRow), str( ::aOldRect[1]), str(::aOldRect[1] + ::oSelected:nMaxHeight) } )
              if nRow > ::aOldRect[1] + ::oSelected:nMaxHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMaxHeight
              endif



              ::oSelected:aRect := { ::aOldRect[1], ;
                                   ::aOldRect[2], ;
                                   nRow, ;
                                   ::aOldRect[4]  }

         case ::nDotSelect == 7 .and. ::oSelected:lCanSize  // DOWN-LEFT

              aRect := NormalizeRect( { ::aOldRect[1], nCol, nRow, ::aOldRect[4] } )

              if nRow < ::aOldRect[1] + ::oSelected:nMinHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMinHeight
              endif

              if  nCol > ::aOldRect[4] - ::oSelected:nMinWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMinWidth
              endif

              if nRow > ::aOldRect[1] + ::oSelected:nMaxHeight
                 nRow := ::aOldRect[1] + ::oSelected:nMaxHeight
              endif

              if  ::aOldRect[4] - nCol > ::oSelected:nMaxWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { ::aOldRect[1], ;
                                   nCol, ;
                                   nRow, ;
                                   ::aOldRect[4]  }

              if len( ::oSelected:aPages ) > 0
                 for each oPage in ::oSelected:aPages
                     for each oShape in oPage:aShapes
                         oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                     next
                 next
              endif

         case ::nDotSelect == 8 .and. ::oSelected:lCanSize  // LEFT

              aRect := NormalizeRect( { ::aOldRect[1], nCol, ::aOldRect[3], ::aOldRect[4]  }  )

              if  nCol > ::aOldRect[4] - ::oSelected:nMinWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMinWidth
              endif

              if  ::aOldRect[4] - nCol > ::oSelected:nMaxWidth
                  nCol := ::aOldRect[4] - ::oSelected:nMaxWidth
              endif

              ::oSelected:aRect := { ::aOldRect[1], ;
                                   nCol, ;
                                   ::aOldRect[3], ;
                                   ::aOldRect[4]  }

              if len( ::oSelected:aPages ) > 0
                 for each oPage in ::oSelected:aPages
                     for each oShape in oPage:aShapes
                         oShape:Offset( nRow - ::nOldRow, nCol - ::nOldCol )
                     next
                 next
              endif


      endcase


      if ::lMoviendo
         if ::oSelected != nil
            //Aplicacion():oWnd:SetMsg( str(::oSelected:nAbsTop)+str(::oSelected:nAbsLeft)+str(::oSelected:nWidth)+str(::oSelected:nHeight))
         endif
      endif

      if ::nDotSelect > 0 .and. ::oSelected:aDotsActives[::nDotSelect] == 1
         SetCursor( LoadCursor(0,{ IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE,IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE}[::nDotSelect]))
      endif

      if ::oSelected == ::oForm .and. ::nDotSelect > 0
         //::SetSize( ::oForm:nWidth+20, ::oForm:nHeight + 20, .t. )
         ::SetSize( ::oForm:nWidth, ::oForm:nHeight, .t. )
      endif

   endif
   ::oSelected:Resize()

   ::Refresh()


else
   if ::oSelected != nil
      if ( ::nDotSelect := ::IsOverDot( nRow, nCol )) != 0
         SetCursor( LoadCursor(0,{ IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE,IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE}[::nDotSelect]))
      else
         CursorArrow()
         ::oSelected:MouseMove( nRow, nCol )
      endif
   else
      CursorArrow()
   endif
endif

return 0


**********************************************************************************************************************
  METHOD LButtonUp  ( nRow, nCol, nKeyFlags ) CLASS TDsgnEditor
**********************************************************************************************************************
local oShape
local oBtn
local rc := GetClientRect(::hwnd)

if lAnd( nRow , 0x8000)  ;   nRow := nOr(nRow,0xFFFF0000); end
if lAnd( nCol , 0x8000)  ;   nCol := nOr(nCol,0xFFFF0000); end

::lPaintGuideN := .f.
::lPaintGuideS := .f.
::lPaintGuideE := .f.
::lPaintGuideW := .f.


if ::lCaptured

   ReleaseCapture()
   ::lCaptured := .f.

   if ::nState == DSGN_CLICKING
      Aplicacion():nState := nOldState
      return 0
   endif

   if ::oForm != nil
      //if ::oForm:lGrid
      //   nRow -= ( nRow % ::oForm:nGrid )
      //   nCol -= ( nCol % ::oForm:nGrid )
      //   ::nOldRow -= ( ::nOldRow % ::oForm:nGrid )
      //   ::nOldCol -= ( ::nOldCol % ::oForm:nGrid )
      //endif
   endif

   ::aRectSel := NormalizeRect( {::nOldRow, ::nOldCol, nRow, nCol } )

   if ::lMoviendo


      if len( ::aSelecteds ) > 0

         for each oShape in ::aSelecteds
             ::AddUndo( oShape, "MoveTo", {oShape:aOldPos[1],oShape:aOldPos[2],oShape:aOldPos[3],oShape:aOldPos[4]}, .t. )
             oShape:StorePos()
         next

      else

          ::AddUndo( ::oSelected, "MoveTo", {::oSelected:aOldPos[1],::oSelected:aOldPos[2],::oSelected:aOldPos[3],::oSelected:aOldPos[4]}, .t. )

      endif
      ::nOldRow := 0
      ::nOldCol := 0

   else


      if ( ::oSelected == nil .or. (::oSelected != nil .and. !::oSelected:lCanMove ) )

         if ::nState == DSGN_SELECT            // Compruebo si he seleccionado figuras

            ::CheckSelecteds( ::aRectSel )

         else

            if ::oForm != nil

               do case
                  case ::nState ==  DSGN_BTN
                       oShape := TDsgnBtn():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, BOTON )

                  case ::nState ==  DSGN_CHEK
                       oShape := TDsgnBtn():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, CHECK )

                  case ::nState ==  DSGN_RADIO
                       oShape := TDsgnBtn():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, RADIODSGN )

                  case ::nState ==  DSGN_GET
                       oShape := TDsgnEdit():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_GROUPBOX
                       oShape := TDsgnGrp():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_SAY
                       oShape := TDsgnSay():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_LISTBOX
                       oShape := TDsgnLbx():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_HSCROLL
                       oShape := TDsgnScroll():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, .f. )

                  case ::nState ==  DSGN_VSCROLL
                       oShape := TDsgnScroll():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, .t. )

                  case ::nState ==  DSGN_COMBO
                       oShape := TDsgnCbx():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_PICTURE
                       oShape := TDsgnImg():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_ICON
                       oShape := TDsgnImg():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self, .T. )

                  case ::nState ==  DSGN_PROGRESS
                       oShape := TDsgnPrgBar():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_SLIDER
                       oShape := TDsgnSlider():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_VLINE
                       oShape := TDsgnSay():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                       oShape:cCaption := ""
                       oShape:lSunken := .t.
                       oShape:aRect[4] := oShape:aRect[2]+2
                       oShape:nMaxWidth  := 3
                       oShape:nMinWidth  := 3

                  case ::nState ==  DSGN_HLINE
                       oShape := TDsgnSay():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                       oShape:cCaption := ""
                       oShape:lSunken := .t.
                       oShape:aRect[3] := oShape:aRect[1]+2
                       oShape:nMaxHeight := 3
                       oShape:nMinHeight := 3

                  case ::nState ==  DSGN_STFRAME

                       oShape := TDsgnSay():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                       oShape:cCaption := ""
                       oShape:lStaticFrame := .t.

                  case ::nState ==  DSGN_TABCTRL

                       oShape := TDsgnFolder():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                       oShape:AddPage()

                  case ::nState ==  DSGN_LISTVIEW

                       oShape := TDsgnListView():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )


                  case ::nState ==  DSGN_BROWSE

                       oShape := TDsgnBrowse():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_TREE

                       oShape := TDsgnTreeView():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_BAR

                       oShape := TDsgnBar():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_MENU

                       if ::oForm:oMenu == nil
                          ::oForm:oMenu := TDsgnMenuBar():New( 0,0,20,rc[4], self )
                          ::oForm:oMenu:AddItem( "&File" )
                          ::oForm:oMenu:AddItem( "&Edit" )
                          ::oForm:oMenu:AddItem( "&View" )
                          ::oForm:oMenu:AddItem( "&Project" )
                          ::oForm:oMenu:AddItem( "&Tools" )
                          ::oForm:oMenu:AddItem( "&Help" )
                       endif

                  case ::nState ==  DSGN_BTNBMP
                       oShape := TDsgnBtnBmp():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_USER
                       oShape := TDsgnUser():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_PANEL
                       oShape := TDsgnPanel():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

                  case ::nState ==  DSGN_VISTAMENU
                       oShape := TVistaMenu():NewShape( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                       oShape:nMaxHeight := GetSysMetrics(1)
                       oShape:nMinHeight := 3
                  otherwise

                       oShape := TShape():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )

               endcase

               //Aplicacion():oToolBox:cargo:SetOption( 1 ) // Herramientas
               //Aplicacion():oToolBox:cargo:cargo[1]:aFolders[1]:nOption := 1
               //Aplicacion():oToolBox:cargo:cargo[1]:aFolders[1]:Refresh()

            else

                oShape := TShape():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
                oShape:nClrpane := CLR_GRAY

            endif

            Aplicacion():nState := DSGN_SELECT

            if oShape != nil
               oShape:oWnd := self
               oShape:SetFocus()
               ::oSelected:StorePos()
            endif

         endif

      else

         if ::nDotSelect != 0
            ::AddUndo( ::oSelected, "MoveTo", {::oSelected:aOldPos[1],::oSelected:aOldPos[2],::oSelected:aOldPos[3],::oSelected:aOldPos[4]}, .t. )
            ::oSelected:StorePos()
         endif

         ::aOldRect  := {}
         ::nDeltaRow := 0
         ::nDeltaCol := 0

      endif

   endif

   ::aRectSel := {}
   ::Refresh()
   ::nOldRow2 := 0
   ::nOldCol2 := 0

endif


return 0

//***************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDsgnEditor
//***************************************************************************************************
local nRow, nCol, aPoint, nWidth, nHeight, nMedW, nMedH
local nRow0, nCol0

//LogFile( "MisMsg.txt",{WG_DECODEMESSAGENAME(nMsg),nWParam,nLParam} )

if nMsg == WM_ERASEBKGND
   return 1
endif

if nMsg == WM_KEYUP
   return ::KeyUp( nMsg, nWParam, nLParam )
endif

if nMsg == WM_NCHITTEST

   nWidth  := ::nWidth
   nHeight := ::nHeight
   nMedW   := nWidth / 2
   nMedH   := nHeight/ 2
   nRow0   := nHiWord( nLParam )
   nCol0   := nLoWord( nLParam )
   aPoint  := { nRow0, nCol0 }
   aPoint  := ScreenToClient( ::hWnd, aPoint )

   nRow    := aPoint[ 1 ]
   nCol    := aPoint[ 2 ]

   do case
      //case nRow > 8 .and. nRow < ::oForm:nHCaption + 10
      //     return HTCAPTION
      //case nRow <= 8 .and. nCol <= 8
      //
      //     return HTTOPLEFT
      //case nRow <= 8 .and. nCol >= nWidth - 8
      //
      //     return HTTOPRIGHT
      //case nRow <= 8

      //     return HTTOP
      //case nRow >= nHeight - 8 .and. nCol <= 8
      //
      //     return HTBOTTOMLEFT
      //case nRow >= nHeight - 12 .and. nRow <= nHeight - 8 .and. nCol >= nWidth-12 .and. nCol <= nWidth - 8
      case nRow >= nHeight - 4 .and. nCol >= nWidth-4
           return HTBOTTOMRIGHT

      //case nRow >= nHeight - 12 .and. nRow <= nHeight - 8
      case nRow >= nHeight - 4

           return HTBOTTOM
      //case nCol <= 8
      //
      //     return HTLEFT
      //case nCol >= nWidth - 12 .and. nCol <= nWidth - 8
      case nCol >= nWidth - 4

           return HTRIGHT
   endcase

endif



if nMsg == WM_SYSCHAR
   return ::SysKeyChar( nWParam, nLParam )
endif



return super:HandleEvent( nMsg, nWParam, nLParam )

//***************************************************************************************************
  METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TDsgnEditor
//***************************************************************************************************
local oMenu
local oSelectedAnt := ::oSelected
local oItem
local o := self

 ::oSelected  := ::ShapeOver( nRow, nCol )
 oItem := ::oSelected
 ::Refresh()

 if !empty( ::aSelecteds ) .and. oItem != nil
    MENU oMenu POPUP
       MENUITEM "Bloquear" ACTION ( aeval( ::aSelecteds, {|x| x:lCanMove := !x:lCanMove} ),o:Refresh())
       MENUITEM "Copiar" ACTION ::oSelected:Copy( nRow, nCol )
       MENUITEM "Pegar"  ACTION if( o:oForm != nil, o:oForm:Paste( nRow, nCol, self ), o:Paste( nRow, nCol, self ) )
       MENUITEM "Alinear a"
       MENU
           MENUITEM "Arriba"    ACTION ::Align( oItem, 2 )                NAME "al_top"
           MENUITEM "Abajo"     ACTION ::Align( oItem, 6 )                NAME "al_down"
           MENUITEM "Izquierda" ACTION ::Align( oItem, 8 )                NAME "al_left"
           MENUITEM "Derecha"   ACTION ::Align( oItem, 4 )                NAME "al_right"
           SEPARATOR
           MENUITEM "Arriba del principal"    ACTION ::Align( oItem, 12 ) NAME "al_top"
           MENUITEM "Abajo del principal"     ACTION ::Align( oItem, 16 ) NAME "al_down"
           MENUITEM "Izquierda del principal" ACTION ::Align( oItem, 18 ) NAME "al_left"
           MENUITEM "Derecha del principal"   ACTION ::Align( oItem, 14 ) NAME "al_right"
       ENDMENU
       MENUITEM "Tamaño"
       MENU
           MENUITEM "Mismo alto"             ACTION ::Size( 1 ) NAME "samehe"
           MENUITEM "Mismo ancho"            ACTION ::Size( 2 ) NAME "samewi"
           MENUITEM "Igual que el principal" ACTION ::Size( 7 ) NAME "samebo"
           SEPARATOR
           MENUITEM "Máximo alto"            ACTION ::Size( 3 )
           MENUITEM "Máximo ancho"           ACTION ::Size( 4 )
           MENUITEM "Mínimo alto"            ACTION ::Size( 5 )
           MENUITEM "Mínimo ancho"           ACTION ::Size( 6 )

       ENDMENU
    ENDMENU
    ACTIVATE MENU oMenu AT nRow, nCol OF Self
 else
    if ::oSelected != nil
       MENU oMenu POPUP
          if ::oSelected:bContextMenu != nil
             eval(::oSelected:bContextMenu, nRow, nCol )
             if ::oSelected != ::oForm
                MENUITEM "Copiar" ACTION ::oSelected:Copy( nRow, nCol )
             endif
          endif
          if ::oSelected != ::oForm
             //MENUITEM "No redimensionar" ACTION (::oSelected:lCanSize := .f.,::Refresh())
             //MENUITEM "Si redimensionar" ACTION (::oSelected:lCanSize := .t.,::Refresh())
             //MENUITEM "No Mover"         ACTION (::oSelected:lCanMove       := .f.,::Refresh())
             //MENUITEM "Si Mover"         ACTION (::oSelected:lCanMove       := .t.,::Refresh())
          endif
       ENDMENU
       ACTIVATE MENU oMenu AT nRow, nCol OF Self
    endif
 endif

return 0

*****************************************************************************************************
  METHOD SelectAll() CLASS TDsgnEditor
*****************************************************************************************************
local oShape
local lHay := .f.
local n, nLen

nLen := len( ::aShapes ) - if(::oForm==nil,0,1) // el formulario

for n := 1 to nLen

    oShape := ::aShapes[n]

    aadd( ::aSelecteds, oShape )
    oShape:StorePos()
    oShape:lSelected := .t.

next

::Refresh()

return nil



*****************************************************************************************************
  METHOD CheckSelecteds( aRect ) CLASS TDsgnEditor
*****************************************************************************************************
local oShape
local lHay := .f.
local n, nLen

nLen := len( ::aShapes ) - if( ::oForm == nil, 0, 1 ) // el formulario

for n := 1 to nLen

    oShape := ::aShapes[n]

    if oShape:IntersectRect( aRect )
       if !oShape:lCanMove
          loop
       endif
       lHay := .t.
       aadd( ::aSelecteds, oShape )
       oShape:StorePos()
       oShape:lSelected := .t.
    else
       if oShape:lContainer
          if oShape:CheckSelecteds( aRect )
             lHay := .t.
          endif
       else
          oShape:lSelected := .f.
       endif
    endif

next

if !lHay
   ::aSelecteds := {}
endif

return lHay

function EsMayor( a, queb )

if a[1] < queb[1] .and. a[2]< queb[2] .and. a[3] > queb[3] .and. a[4] > queb[4]
   return .t.
endif
return .f.

*****************************************************************************************************
  METHOD ResetSelecteds() CLASS TDsgnEditor
*****************************************************************************************************
local oShape
local n, nLen

nLen := len( ::aShapes ) - if(::oForm==nil,0,1) // el formulario

for n := 1 to nLen

    oShape := ::aShapes[n]

    if ::oSelected != nil .and. ::oSelected == oShape
    else
       oShape:lSelected := .f.
    endif

next

::aSelecteds := {}
::Refresh()

return nil


*****************************************************************************************************
      METHOD Align( oItem, nTo ) CLASS TDsgnEditor
*****************************************************************************************************
local nTop
local nLeft
local nBottom
local nRight
local n, nLen, n2
local oShape
local nMedTop, nMedLeft
local nMX, nMY
local nTramo

DEFAULT oItem := ::oSelected

nMedTop  := oItem:nTop  + ((oItem:nBottom-oItem:nTop ) / 2 )
nMedLeft := oItem:nLeft + ((oItem:nRight-oItem:nLeft ) / 2 )

nLen := len( ::aSelecteds )

for n := 1 to nLen

    oShape := ::aSelecteds[n]

    if n == 1
       nTop    := oShape:nTop
       nLeft   := oShape:nLeft
       nBottom := oShape:nBottom
       nRight  := oShape:nRight
    else
       nTop    := min(oShape:nTop, nTop    )
       nLeft   := min(oShape:nLeft   , nLeft   )
       nBottom := max(oShape:nBottom , nBottom )
       nRight  := max(oShape:nRight  , nRight  )
    endif

next

for n := 1 to nLen

    oShape := ::aSelecteds[n]

    do case
       case nTo == 2  // alinear todos al que esté mas arriba
            oShape:GotoY( nTop )

       case nTo == 4
            oShape:GotoX( nRight - oShape:nWidth )

       case nTo == 6
            oShape:GotoY( nBottom - oShape:nHeight )

       case nTo == 8
            oShape:GotoX( nLeft )

       case nTo == 9  // al Left centro del principal

            if oShape == oItem
               loop
            endif

            nMX := ((oShape:nRight-oShape:nLeft)/2)
            oShape:GotoX( nMedLeft-nMX )

       case nTo == 10 // al top centro del principal

            if oShape == oItem
               loop
            endif

            nMY := ((oShape:nBottom-oShape:nTop)/2)
            oShape:GotoY( nMedTop-nMY )

       case nTo == 12  // alinear todos al que esté mas arriba
            oShape:GotoY( oItem:nTop )

       case nTo == 14
            oShape:GotoX( oItem:nRight - oShape:nWidth )

       case nTo == 16
            oShape:GotoY( oItem:nBottom - oShape:nHeight )

       case nTo == 18
            oShape:GotoX( oItem:nLeft )

       case nTo == 20  // repartir horizontal

            ::aSelecteds := asort( ::aSelecteds,,,{|x,y| x:nLeft < y:nLeft } )
            nTramo := ( ::aSelecteds[nLen]:nLeft - ::aSelecteds[1]:nLeft ) / (nLen-1)
            for n2 := 2 to nLen - 1
                ::aSelecteds[n2]:GotoX( ::aSelecteds[1]:nLeft +  ( nTramo * (n2 - 1) ) )
            next

       case nTo == 21  // repartir vertical

            ::aSelecteds := asort( ::aSelecteds,,,{|x,y| x:nTop < y:nTop } )
            nTramo := ( ::aSelecteds[nLen]:nTop - ::aSelecteds[1]:nTop ) / (nLen-1)
            for n2 := 2 to nLen - 1
                ::aSelecteds[n2]:GotoY( ::aSelecteds[1]:nTop +  ( nTramo * (n2 - 1) ) )
            next

    endcase
    oShape:StorePos()

next
::Refresh()


return nil

*****************************************************************************************************
      METHOD Size( nModo ) CLASS TDsgnEditor
*****************************************************************************************************

local oShape
local n, nLen
local nMaxWidth  := 0
local nMaxHeight := 0
local nMinWidth
local nMinHeight
local nWidth  := ::oSelected:nWidth
local nHeight := ::oSelected:nHeight

nLen := len( ::aSelecteds )

nMaxWidth  := ::aSelecteds[1]:nWidth
nMaxHeight := ::aSelecteds[1]:nHeight
nMinWidth  := ::aSelecteds[1]:nWidth
nMinHeight := ::aSelecteds[1]:nHeight

for n := 2 to nLen

    nMaxWidth  := Max(::aSelecteds[n]:nWidth , nMaxWidth )
    nMaxHeight := Max(::aSelecteds[n]:nHeight, nMaxHeight)
    nMinWidth  := Min(::aSelecteds[n]:nWidth , nMinWidth )
    nMinHeight := Min(::aSelecteds[n]:nHeight, nMinHeight)

next


for n := 1 to nLen

    oShape := ::aSelecteds[n]

    do case
       case nModo == 1                                                 //  1 "Mismo alto"
            oShape:SetSize(                 , nHeight            )
       case nModo == 2                                                 //  2 "Mismo ancho"
            oShape:SetSize(           nWidth,                    )
       case nModo == 3                                                 //  3 "Máximo alto"
            oShape:SetSize(                 , nMaxHeight         )
       case nModo == 4                                                 //  4 "Máximo ancho"
            oShape:SetSize( nMaxWidth,                           )
       case nModo == 5                                                 //  5 "Mínimo alto"
            oShape:SetSize(                 , nMinHeight         )
       case nModo == 6                                                 //  6 "Mínimo ancho"
            oShape:SetSize( nMinWidth,                           )
       case nModo == 7                                                 //  7 "Igual tamaño"
            oShape:SetSize(          nWidth,             nHeight)
    endcase

next

::Refresh()

return nil


*****************************************************************************************************
      METHOD AddUndo( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 ) CLASS TDsgnEditor
*****************************************************************************************************

aadd( ::aUndo, { oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 } )

return nil


*****************************************************************************************************
      METHOD Undo() CLASS TDsgnEditor
*****************************************************************************************************

local aUndo := atail( ::aUndo )
local oShape
local cAction
local uVal1
local uVal2
local uVal3
local uVal4
local uVal5

if empty( aUndo )
   MsgAlert( "No hay acciones para deshacer" )
   return nil
endif

oShape  := aUndo[1]
cAction := aUndo[2]
uVal1   := aUndo[3]
uVal2   := aUndo[4]
uVal3   := aUndo[5]
uVal4   := aUndo[6]
uVal5   := aUndo[7]

BeginFromUndo()

OSend( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 )

EndFromUndo()

adel( ::aUndo, len( ::aUndo ) )
asize( ::aUndo, len( ::aUndo )-1 )

return nil

*****************************************************************************************************
   METHOD SysKeyChar( nKey, nKeyFlags ) CLASS TDsgnEditor
*****************************************************************************************************

return 0

*****************************************************************************************************
   METHOD KeyUp( nKey, nKeyFlags ) CLASS TDsgnEditor
*****************************************************************************************************

::lKeyDown := .f.
::Refresh()


return 0

*****************************************************************************************************
   METHOD KeyChar( nKey, nFlags ) CLASS TDsgnEditor
*****************************************************************************************************

if ::oSelected != nil
   if ::oSelected:bKeyChar != nil
      if eval( ::oSelected:bKeyChar, nKey, nFlags )
         return 0
      endif
   endif
   if nKey >= 32 .and. nKey <= asc( "z" )
      ::oSelected:Edit( nKey )
   endif

endif

return super:KeyChar( nKey, nFlags )

*****************************************************************************************************
   METHOD KeyDown( nKey, nKeyFlags ) CLASS TDsgnEditor
*****************************************************************************************************
local lControl := GetKeyState( VK_CONTROL )
local lShift   := GetKeyState( VK_SHIFT   )
local n
local nLenSel  := len( ::aSelecteds )
local cMsg
local nGrid := if( !lControl, 1, if(::oForm==nil,1,::oForm:nGrid) )
local oOldSelected := ::oSelected
local nLen
local nDelta

if ::oSelected != nil
   if ::oSelected:bKeyDown != nil
      if eval( ::oSelected:bKeyDown, nKey, nKeyFlags )
         return 0
      endif
   endif
endif

::lKeyDown := .t.

do case

   case (lShift .or. lControl) .and. nKey == VK_TAB
        ::lKeyDown := .f.
        ::PrevShape()

        if oOldSelected != nil .and. oOldSelected != ::oSelected
           if oOldSelected:bLostFocus != nil
              eval( oOldSelected:bLostFocus )
           endif
        endif

   case nKey == VK_TAB
        ::lKeyDown := .f.
        ::NextShape()

        if oOldSelected != nil .and. oOldSelected != ::oSelected
           if oOldSelected:bLostFocus != nil
              eval( oOldSelected:bLostFocus )
           endif
        endif


   case nKey == VK_UP

        if nLenSel == 0
           if ::oSelected == nil .or. ::oSelected:nItemId == ::oForm:nItemId
              return nil
           endif
           if ::oSelected != nil .and. !::oSelected:lCanSize ; return 0 ; endif
           if ::oSelected != nil .and. !::oSelected:lCanMove              ; return 0 ; endif
        endif


        do case
           case lShift
                if nLenSel == 0
                   ::oSelected:SetSize( , ::oSelected:nHeight-nGrid,.f. )
                else
                   for n := 1 to nLenSel
                       ::aSelecteds[n]:SetSize( , ::aSelecteds[n]:nHeight-nGrid,.f. )
                   next
                endif
                ::Refresh()
           otherwise
              if nLenSel == 0
                 ::oSelected:ToTop( nGrid )
              else
                 for n := 1 to nLenSel
                     ::aSelecteds[n]:ToTop( nGrid )
                 next
              endif
        endcase


   case nKey == VK_DOWN

        if nLenSel == 0
           if ::oSelected == nil .or. ::oSelected:nItemId == ::oForm:nItemId
              return nil
           endif
           if ::oSelected != nil .and. !::oSelected:lCanSize ; return 0 ; endif
           if ::oSelected != nil .and. !::oSelected:lCanMove              ; return 0 ; endif
        endif
        do case
           case lShift
                if nLenSel == 0
                   ::oSelected:SetSize( , ::oSelected:nHeight+nGrid,.f. )
                else
                   for n := 1 to nLenSel
                       ::aSelecteds[n]:SetSize( , ::aSelecteds[n]:nHeight+nGrid,.f. )
                   next
                endif
                ::Refresh()
           otherwise
              if nLenSel == 0
                 ::oSelected:ToBottom( nGrid )
              else
                 for n := 1 to nLenSel
                     ::aSelecteds[n]:ToBottom( nGrid )
                 next
              endif
        endcase


   case nKey == VK_LEFT

        if nLenSel == 0
           if ::oSelected == nil .or. ::oSelected:nItemId == ::oForm:nItemId
              return nil
           endif
           if ::oSelected != nil .and. !::oSelected:lCanSize ; return 0 ; endif
           if ::oSelected != nil .and. !::oSelected:lCanMove              ; return 0 ; endif
        endif
        do case
           case lShift
                if nLenSel == 0
                   ::oSelected:SetSize(::oSelected:nWidth-nGrid,,.f. )
                else
                   for n := 1 to nLenSel
                       ::aSelecteds[n]:SetSize(::aSelecteds[n]:nWidth-nGrid,,.f. )
                   next
                endif
                ::Refresh()
           otherwise
              if nLenSel == 0
                 ::oSelected:ToLeft( nGrid )
              else
                 for n := 1 to nLenSel
                     ::aSelecteds[n]:ToLeft( nGrid )
                 next
              endif
        endcase


   case nKey == VK_RIGHT

        if nLenSel == 0
           if ::oSelected == nil .or. ::oSelected:nItemId == ::oForm:nItemId
              return nil
           endif
           if ::oSelected != nil .and. !::oSelected:lCanSize ; return 0 ; endif
           if ::oSelected != nil .and. !::oSelected:lCanMove              ; return 0 ; endif
        endif
        do case
           case lShift
                if nLenSel == 0
                   ::oSelected:SetSize(::oSelected:nWidth+nGrid,,.f. )
                else
                   for n := 1 to nLenSel
                       ::aSelecteds[n]:SetSize(::aSelecteds[n]:nWidth+nGrid,,.f. )
                   next
                endif
                ::Refresh()
           otherwise
              if nLenSel == 0
                 ::oSelected:ToRight( nGrid )
              else
                 for n := 1 to nLenSel
                     ::aSelecteds[n]:ToRight( nGrid )
                 next
              endif
        endcase

   case nKey == 93 //tecla menu windows

        if ::oSelected != nil
           return ::RButtonDown( ::oSelected:nBottom, ::oSelected:nLeft )
        endif

   case lControl .and. (nKey == asc( "C" ) .or. nKey == asc( "c" ))

        if  ::oSelected != nil .and. ::oSelected:nItemId != ::oForm:nItemId
            ::oSelected:Copy( ::oSelected:nTop, ::oSelected:nLeft )
        else
            if nLenSel > 0
               ::aSelecteds[1]:Copy( ::aSelecteds[1]:nTop, ::aSelecteds[1]:nLeft )
            endif
        endif

   case lControl .and. (nKey == asc( "V" ) .or. nKey == asc( "v" ))

        ::oForm:Paste( 40, 10, self )

   case lControl .and. (nKey == asc( "Z" ) .or. nKey == asc( "z" ))

        ::Undo()

   case nKey == VK_DELETE

        if ( ::oSelected:nItemId == ::oForm:nItemId ) .and. nLenSel == 0
           return nil
        endif

        if lShift // Borrado definitivo
           cMsg := "¿Esta seguro de borrar definitivamente el control?"
        else
           cMsg := "¿Desea enviar el control a la papelera?"
        endif

        if MsgYesNo( cMsg )

           if ::oForm:oMenu != nil .and. ::oForm:oMenu = ::oSelected
              ::oForm:oMenu := nil
           endif

           if nLenSel == 0

              ::NextShape()
              ::Send2Trash( oOldSelected, !lShift )

           else
              for n := 1 to nLenSel
                  ::Send2Trash( ::aSelecteds[n], !lShift )
              next
           endif

           ::lKeyDown := .f.

           ::Refresh()

        endif

   case nKey == VK_RETURN

        if ::oSelected != nil
            ::oSelected:Edit()
        endif

   case nKey == VK_ESCAPE
        ::ResetSelecteds()
        ::oForm:SetFocus()

   case nKey == VK_ADD

        ::nZoom += 1

        nDelta := ::nZoom/100

        ::oWnd:nWidth *= nDelta
        ::oWnd:nHeight *= nDelta

        nLen := len(::aShapes)

        for n := 1 to nLen-1
            ::aShapes[n]:aRect := {::aShapes[n]:aRect[1]*nDelta,::aShapes[n]:aRect[2]*nDelta,::aShapes[n]:aRect[3]*nDelta,::aShapes[n]:aRect[4]*nDelta}
        next

        ::Refresh()


   case nKey == VK_SUBTRACT

        ::nZoom -= 1

        nDelta := ::nZoom/100

        ::oWnd:nWidth /= nDelta
        ::oWnd:nHeight /= nDelta

        nLen := len(::aShapes)
        for n := 1 to nLen-1
            ::aShapes[n]:aRect := {::aShapes[n]:aRect[1]/nDelta,::aShapes[n]:aRect[2]/nDelta,::aShapes[n]:aRect[3]/nDelta,::aShapes[n]:aRect[4]/nDelta}
        next
        ::Refresh()



endcase


return 0

*****************************************************************************************************
  METHOD NextShape() CLASS TDsgnEditor
*****************************************************************************************************
local nLen := len( ::aShapes )
local n, nFocus

if len( ::aSelecteds ) > if(::oForm==nil,0,1)
   ::ResetSelecteds()
endif

if ::oSelected == nil .and. ::oForm != nil
   ::oForm:SetFocus()
endif

for n := 1 to nLen

    if ::aShapes[n]:nItemId == ::oSelected:nItemId
       if n == 1 .and. ::oForm != nil
          ::oForm:SetFocus()
       else
          ::aShapes[n-1]:SetFocus()
       endif
       exit
    endif

next

::Refresh()


return nil


*****************************************************************************************************
  METHOD PrevShape() CLASS TDsgnEditor
*****************************************************************************************************
local nLen := len( ::aShapes )
local n



if len( ::aSelecteds ) > if(::oForm==nil,0,1)
   ::ResetSelecteds()
endif

if ::oSelected == nil .and. ::oForm != nil
   ::oForm:SetFocus()
endif

for n := 1 to nLen

    if ::aShapes[n]:nItemId == ::oSelected:nItemId
       if n == nLen
          ::aShapes[1]:SetFocus()
       else
          ::aShapes[n+1]:SetFocus()
       endif
       exit
    endif
next

::Refresh()

return nil

*****************************************************************************************************
      METHOD Send2Trash    ( o, lTrash ) CLASS TDsgnEditor
*****************************************************************************************************
local n, nLen, n2
local nEn := 0
local nUndos := 0

DEFAULT lTrash := .t.

if lTrash
   aadd( ::aTrash, o )
endif

if o:oParent != nil
   o:StoreRelPos()
   o:oParent:DeleteChild(o)
   for n := 1 to len( o:aPages )
       for n2 := 1 to len( o:aPages[n] )
           ::Send2Trash( o:aPages[n,n2], lTrash )
       next
   next
endif

n := 1
do while n <= len( ::aUndo )
   if ::aUndo[n,1]:nItemId == o:nItemId
      adel ( ::aUndo, n )
      asize( ::aUndo, len( ::aUndo )-1)
   else
      n++
   endif
enddo

nLen := len( ::aShapes )
for n := 1 to nLen
    if ::aShapes[n]:nItemId == o:nItemId
       nEn := n
       exit
    endif
next

if nEn != 0
   adel( ::aShapes, n )
   asize( ::aShapes, nLen - 1 )
   ::Refresh()
endif

return nil


*****************************************************************************************************
      METHOD OpenTrash( oBtn, lActivate ) CLASS TDsgnEditor
*****************************************************************************************************
local oMenu
local n, nLen
local cAux := ""
DEFAULT lActivate := .f.


oAux := self

nLen := len( ::aTrash )

if nLen == 0
   MsgInfo( "Papelera vacía" )
   return nil
endif


MENU oMenu POPUP

for n := 1 to nLen
    cAux := "{||GetSelf():RestoreTrash("+ALLTRIM(STR(n))+")}"

    MenuAddItem (alltrim(str(n)) + ". " + ::aTrash[n]:ClassName(),, .f.,, & (cAux) ,,,,,,, .F. )
next
ENDMENU
if lActivate
   oMenu:Activate( oBtn:nTop + oBtn:nHeight(), oBtn:nLeft, oBtn:oWnd, .f. )
endif

return oMenu

function GetSelf()
return oAux



*****************************************************************************************************
      METHOD RestoreTrash  ( N ) CLASS TDsgnEditor
*****************************************************************************************************
local o := ::aTrash[n]
local nLen

aadd( ::aShapes, nil )
ains( ::aShapes, 1 )
::aShapes[1] := o
if o:oParent != nil
   o:oParent:AddShape( o, o:nEnPage )
   o:aRect := { o:oParent:aRect[1] + o:aRelPos[1],;
                o:oParent:aRect[2] + o:aRelPos[2],;
                o:oParent:aRect[3] + o:aRelPos[3],;
                o:oParent:aRect[4] + o:aRelPos[4] }
endif

nLen := len( ::aTrash )
adel( ::aTrash, n )
asize( ::aTrash, nLen-1)

::Refresh()

return nil

*****************************************************************************************************
  METHOD IsInSelecteds ( oShape ) CLASS TDsgnEditor
*****************************************************************************************************
local lIs := .f.
local n, nLen

nLen := len( ::aSelecteds )
//Outp( "IsInSelecteds" )
//Outp( len(::aSelecteds ) )
for n := 1 to nLen
    if ::aSelecteds[n]:nItemId == oShape:nItemId
       lIs := .t.
       exit
    endif
next

return lIs


*****************************************************************************************************
  METHOD GetContainer( aRect ) CLASS TDsgnEditor
*****************************************************************************************************
local oShape
local n
local nLen := len( ::aShapes )
local oContainer

if empty( aRect ) .or. aRect[1] == nil
   return oContainer
endif

for n := 1 to nLen - 1

    oShape := ::aShapes[n]
    oContainer := oShape:GetContainer( aRect )
    if oContainer != nil
       return oContainer
    endif
next

return oContainer


***************************************************************************************************
      METHOD Validate() CLASS TDsgnEditor
***************************************************************************************************

if !::lSaved
   if MsgYesNo( "¿Desea salvar?","Atención")
      //::Save()
      ::lSaved := .t.
   endif
endif

return ::lSaved


************************************************************************************************
  METHOD GoDown( nInc ) CLASS TDsgnEditor
************************************************************************************************

  local nRow := ::nTop
  if nInc == nil; nInc := 10; endif

  nRow -= nInc

  SetWindowPos( ::hWnd, 0, nRow, ::nLeft, 0, 0, SWP_NOSIZE )

return nil

************************************************************************************************
  METHOD GoUp( nInc ) CLASS TDsgnEditor
************************************************************************************************

  local nRow := ::nTop
  if nInc == nil; nInc := 10; endif

  nRow += nInc

  if nRow > 6
     nRow := 6
  endif

  SetWindowPos( ::hWnd, 0, nRow, ::nLeft, 0, 0, SWP_NOSIZE )

return nil

************************************************************************************************
  METHOD GoRight( nInc ) CLASS TDsgnEditor
************************************************************************************************

  local nCol := ::nLeft
  if nInc == nil; nInc := 10; endif

  nCol -= nInc


  SetWindowPos( ::hWnd, 0, ::nTop, nCol, 0, 0, SWP_NOSIZE )

return nil

************************************************************************************************
  METHOD GoLeft( nInc ) CLASS TDsgnEditor
************************************************************************************************

  local nCol := ::nLeft
  if nInc == nil; nInc := 10; endif

  nCol += nInc

  if nCol > 6
     nCol := 6
  endif
  SetWindowPos( ::hWnd, 0, ::nTop, nCol, 0, 0, SWP_NOSIZE )

return nil

************************************************************************************************
  METHOD HThumbPos( nPos ) CLASS TDsgnEditor
************************************************************************************************
  local nCol := nPos

  if nCol > 12
     nCol := 12
  endif

  SetWindowPos( ::hWnd, 0, ::nTop, nCol, 0, 0, SWP_NOSIZE )

return nil

************************************************************************************************
  METHOD VThumbPos( nPos ) CLASS TDsgnEditor
************************************************************************************************

  local nRow := nPos

  if nRow > 12
     nRow := 12
  endif
  SetWindowPos( ::hWnd, 0, nRow, ::nLeft, 0, 0, SWP_NOSIZE )

return nil


************************************************************************************************
  METHOD TakeDrop( aFiles ) CLASS TDsgnEditor
************************************************************************************************

   local n, lBrowsed := .F.

   if ::oForm != nil

      for n = 1 to Len( aFiles )

         if upper(Right( aFiles[ 1 ], 3 )) != "DBF"
            MsgAlert( "Solo ficheros dbf!!!" )
         else
            cursorwait()
            ::DbfToDialog(aFiles[ n ], 1 )
            cursorarrow()
         endif

      next

   endif

return nil


*********************************************************************************************************
  METHOD DbfToDialog( cDbfName ) CLASS TDsgnEditor
*********************************************************************************************************

   local n
   local oShape
   local aFields
   local nTop, nLeft
   local cCaption
   local nCount, cAlias
   local aRect := ::oForm:GetClientRect()
   local nWidth, nHeight
   nHeight := aRect[3]-aRect[1]
   nWidth := aRect[4]-aRect[2]

   nTop  := nHeight - 40
   nLeft := nWidth - (85*5)


   if Empty( cDbfName ) .or. ! File( cDbfName )
           MsgAlert( "Please select a DBF file first!" )
           return nil
   endif

   cursorwait()

   USE ( cDbfName ) NEW ALIAS ( cAlias := GetNewAlias( "CUST" ) ) SHARED
   aFields := DbStruct()


   for n := len( aFields ) to 1 step -1

       ::nTopDbf  += 30

       cCaption := Upper(left(aFields[ n ][ 1 ],1)) + lower( substr(aFields[ n ][ 1 ],2 ) )

       do case
          case aFields[ n ][ 2 ] == "C" .or. aFields[ n ][ 2 ] == "M"
               oShape := TDsgnEdit():New( ::nTopDbf, ::nLeftDbf+60,::nTopDbf+23,::nLeftDbf+60+ (aFields[ n ][ 3 ] * 8), self )
               oShape:cCaption := replicate("X",aFields[ n ][ 3 ] )
               oShape := TDsgnSay():New( ::nTopDbf+8, ::nLeftDbf,::nTopDbf+15+8,::nLeftDbf+ (len( aFields[ n ][ 1 ]) * 8), self )
               oShape:cCaption := cCaption


          case aFields[ n ][ 2 ] == "D"
               oShape := TDsgnEdit():New( ::nTopDbf, ::nLeftDbf+60,::nTopDbf+23,::nLeftDbf+60+ (aFields[ n ][ 3 ] * 8), self )
               oShape:cCaption := "DD-MM-AAAA"
               oShape := TDsgnSay():New( ::nTopDbf+8, ::nLeftDbf,::nTopDbf+15+8,::nLeftDbf+ (len( aFields[ n ][ 1 ]) * 8), self )
               oShape:cCaption := cCaption


          case aFields[ n ][ 2 ] == "N"

               oShape := TDsgnEdit():New( ::nTopDbf, ::nLeftDbf+60,::nTopDbf+23,::nLeftDbf+60+ (aFields[ n ][ 3 ] * 8), self )
               oShape:cCaption := replicate("9",aFields[ n ][ 3 ] )
               oShape := TDsgnSay():New( ::nTopDbf+8, ::nLeftDbf,::nTopDbf+15+8,::nLeftDbf+ (len( aFields[ n ][ 1 ]) * 8), self )
               oShape:cCaption := cCaption



          case aFields[ n ][ 2 ] == "L"
               oShape := TDsgnBtn():New( ::nTopDbf+8, ::nLeftDbf+60,::nTopDbf+15+8,::nLeftDbf+ (len( aFields[ n ][ 1 ]) * 8), self, CHECK )
               oShape:cCaption := cCaption


       endcase

       if ::nTopDbf > nHeight - 100
          ::nTopDbf := 30
          ::nLeftDbf += 300
       endif


   next


   oShape := TDsgnBtn():New( nTop , nLeft, nTop+23,nLeft+ 75, self, BOTON )
   oShape:cCaption := "Inicio"
   nLeft += 85

   oShape := TDsgnBtn():New( nTop , nLeft, nTop+23,nLeft+ 75, self, BOTON )
   oShape:cCaption := "Previo"
   nLeft += 85

   oShape := TDsgnBtn():New( nTop , nLeft, nTop+23,nLeft+ 75, self, BOTON )
   oShape:cCaption := "Próximo"
   nLeft += 85
   oShape := TDsgnBtn():New( nTop , nLeft, nTop+23,nLeft+ 75, self, BOTON )
   oShape:cCaption := "Fin"
   nLeft += 85
   oShape := TDsgnBtn():New( nTop , nLeft, nTop+23,nLeft+ 75, self, BOTON )
   oShape:cCaption := "Aceptar"


   ::Refresh()

   DBCloseArea( cALias )

return nil


*********************************************************************************************************
   METHOD Destroy() CLASS TDsgnEditor
*********************************************************************************************************
local oShape, oItem

for each oShape in ::aShapes
    oShape:Destroy()
next

Aplicacion():oDFocus := nil

return super:Destroy()

*********************************************************************************************************
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TDsgnEditor
*********************************************************************************************************

if ::oSelected != nil
   ::oSelected:MouseWheel( nKeys, nDelta, nXPos, nYPos )
endif

return super:MouseWheel( nKeys, nDelta, nXPos, nYPos )


*********************************************************************************************************
  METHOD lPocketPC   ( nValue ) CLASS TDsgnEditor
*********************************************************************************************************

if nValue != nil
   ::nType := nValue
   ::nTypePPC := nValue
   ::MaxMin()

   if ::nType != 0
      ::SetSize( ::nWPPC, ::nHPPC, .t. )
   endif

endif

return ::nType != 0

*********************************************************************************************************
  METHOD Rotate() CLASS TDsgnEditor
*********************************************************************************************************

if !::lPocketPC()
   return nil
endif

::lRotatePPC := !::lRotatePPC

::MaxMin()

::SetSize( ::nHeight, ::nWidth, .t. )

return nil


*********************************************************************************************************
  METHOD MaxMin() CLASS TDsgnEditor
*********************************************************************************************************
local nWPPC
local nHPPC


if !::lPocketPC()
   ::aMinMaxInfo = { 2000, 2030,;  // xMaxSize,      yMaxSize
                      6,      6,;  // xMaxPosition,  yMaxPosition
                    120,     54,;  // xMinTrackSize, yMinTrackSize
                   2150,    2150 }  // xMaxTrackSize, yMaxTrackSize
else

    if ::lRotatePPC

       do case
          case ::nTypePPC == 1

               nHPPC        := 240
               nWPPC        := 320

          case ::nTypePPC == 2

               nHPPC        := 240
               nWPPC        := 240

          case ::nTypePPC == 3

               nHPPC        := 176
               nWPPC        := 220

       endcase

    else

       do case
          case ::nTypePPC == 1

               nWPPC        := 240
               nHPPC        := 320

          case ::nTypePPC == 2

               nWPPC        := 240
               nHPPC        := 240

          case ::nTypePPC == 3

               nWPPC        := 176
               nHPPC        := 220

       endcase
    endif

    ::aMinMaxInfo  := { nWPPC,   nHPPC,;  // xMaxSize,      yMaxSize
                            6,       6,;  // xMaxPosition,  yMaxPosition
                           54,      54,;  // xMinTrackSize, yMinTrackSize
                        nWPPC,   nHPPC }  // xMaxTrackSize, yMaxTrackSize
endif

return nil

*********************************************************************************************************
      METHOD Inspect( oShape ) CLASS TDsgnEditor
*********************************************************************************************************

  if Aplicacion():oInspector == nil
     WndFold()
     //Aplicacion():oToolBox:cargo:SetOption( 2 )
  endif
  Aplicacion():oInspector:SetInspect( oShape )

return nil


*********************************************************************************************************
   METHOD SaveFile() CLASS TDsgnEditor
*********************************************************************************************************

::oForm:Save2PRG()

return nil

*********************************************************************************************************
   METHOD SaveFormat() CLASS TDsgnEditor
*********************************************************************************************************
 local cFileName := cNewFileName( "Test", "ffm" )
::oForm:SaveFile( )

return nil





*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************


CLASS TBtnBmpEx FROM TBtnBmp

      CLASSDATA lRegistered AS LOGICAL

      METHOD LButtonUp( nRow, nCol )
      METHOD Destroy()

ENDCLASS

METHOD Destroy() CLASS TBtnBmpEx

   ::FreeBitmaps()
   if ::oPopup != nil .and. Valtype( ::oPopup ) != "B"
      ::oPopup:End()
   endif
   TControl():Destroy()

return 0

METHOD LButtonUp( nRow, nCol )  CLASS TBtnBmpEx

   local oWnd
   local oPopup
   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return Super:LButtonUp( nRow, nCol )
   endif

   if ::bLButtonUp != nil
      Eval( ::bLButtonUp, nRow, nCol)
   endif

   ::lBtnUp  = .t.

   if ! ::lWorking
      if ::lCaptured
         ::lCaptured = .f.
         ReleaseCapture()
         if ! ::lPressed
            if ::lBtnDown
               ::lPressed = .t.
               ::Refresh()
            endif
         else
            if ! ::lBtnDown
               ::lPressed = .f.
               ::Refresh()
            endif
         endif
         if lClick
            if ::oPopup != nil
               if nCol >= ::nWidth() - 13
                  if ::oWnd:oWnd != nil .and. Upper( ::oWnd:oWnd:Classname() ) == "TBAR"
                     oWnd := ::oWnd:oWnd
                  else
                     oWnd := ::oWnd
                  endif
                  if GetClassName( GetParent( Self:hWnd ) ) != "TBAR"
                     oWnd = oWndFromhWnd( GetParent( Self:hWnd ) )
                  endif
                  oWnd:NcMouseMove() // close the tooltip
                  oPopup := ::oPopup
                  if valtype( ::oPopup ) == "B"
                     oPopup :=  eval( ::oPopup )
                  endif
                  oWnd:oPopup = oPopup
                  if oPopup != nil
                     oPopup:Activate( ::nTop + ::nHeight(), ::nLeft, oWnd, .f. )
                  endif
                  oWnd:oPopup = nil
                  ::Refresh()
               else
                  ::Click()
               endif
            else
               ::Click()
            endif
         endif
      endif
   endif

return 0

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

CLASS TMDiChild2 FROM TMdiChild

      METHOD KeyChar( nKey, nFlags )
      METHOD SaveFile()
      METHOD SaveFormat()
      METHOD OpenFormat()

ENDCLASS

METHOD KeyChar( nKey, nFlags ) CLASS TMdiChild2

   if nKey == VK_ESCAPE
      return 0
   endif

return Super:KeyChar( nKey, nFlags )


METHOD SaveFile() CLASS TMDiChild2
local n, nLen

nLen := len(::aControls )

for n := 1 to nLen
    if ::aControls[n]:ClassName() == "TDSGNEDITOR"
       ::aControls[n]:oForm:Save2prg()
    endif
next

return 0


METHOD SaveFormat() CLASS TMDiChild2
local n, nLen

nLen := len(::aControls )

for n := 1 to nLen
    if ::aControls[n]:ClassName() == "TDSGNEDITOR"
       ::aControls[n]:oForm:SaveFile()
    endif
next

return 0

*********************************************************************************************************
   METHOD OpenFormat() CLASS TMDiChild2
*********************************************************************************************************
 local cFileName := cGetFile( "*.ffm", "Seleccione fichero" )
 if file( cFileName )

 endif

return nil

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************












function NormalizeRect( aRect )
local n

if aRect[1] > aRect[3]
   n := aRect[3]
   aRect[3] := aRect[1]
   aRect[1] := n
endif

if aRect[2] > aRect[4]
   n := aRect[4]
   aRect[4] := aRect[2]
   aRect[2] := n
endif

return aRect

function OffsetRect( rc, x, y )

rc[1] := rc[1] + y
rc[2] := rc[2] + x
rc[3] := rc[3] + y
rc[4] := rc[4] + x

return rc




********************************************
   function xSelColor( nRow, nCol, nColor )
********************************************
local oDlg, oBmp

local nFila, nColumna, nOption
local nHFila, nWCol
local oBtn, oFont
local lCancel := .t.
local oFld
local oLbx
local lPaleta := .f.
local aColors := { rgb( 255, 127, 127), rgb( 255, 255, 127), rgb( 127, 255, 127),;
                   rgb(   0, 255, 127), rgb( 127, 255, 255), rgb(   0, 127, 255),;
                   rgb( 255, 127, 191), rgb( 255, 127, 255), rgb( 255,   0,   0),;
                   rgb( 255, 255,   0), rgb( 127, 255,   0), rgb(   0, 255,  63),;
                   rgb(   0, 255, 255), rgb(   0, 127, 191), rgb( 127, 127, 191),;
                   rgb( 255,   0, 255), rgb( 127,  63,  63), rgb( 255, 127,  63),;
                   rgb(   0, 255,   0), rgb(   0, 127, 127), rgb(   0,  63, 127),;
                   rgb( 127, 127, 255), rgb( 127,   0,  63), rgb( 255,   0, 127),;
                   rgb( 127,   0,   0), rgb( 255, 127,   0), rgb(   0, 127,   0),;
                   rgb(   0, 127,  63), rgb(   0,   0, 255), rgb(   0,   0, 159),;
                   rgb( 127,   0, 127), rgb( 127,   0, 255), rgb(  63,   0,   0),;
                   rgb( 127,  63,   0), rgb(   0,  63,   0), rgb(   0,  63,  63),;
                   rgb(   0,   0, 127), rgb(   0,   0,  63), rgb(  63,   0,  63),;
                   rgb(  63,   0, 127), rgb(   0,   0,   0), rgb( 127, 127,   0),;
                   rgb( 127, 127,  63), rgb( 127, 127, 127), rgb(  63, 127, 127),;
                   rgb( 191, 191, 191), rgb(  63,   0,  63), rgb( 255, 255, 255) }

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 5, 13

nClrReturn := nil

DEFINE DIALOG oDlg STYLE nOr( WS_POPUP, DS_MODALFRAME ) ;
       FROM nRow, nCol TO nRow + 152, nCol + 148 PIXEL

       @ 0,0 FOLDER oFld OF oDlg PROMPTS "Custom","System" PIXEL SIZE 150, 150

       oDlg:oClient := oFld

       @ 0, 0 BITMAP oBmp OF oFld:aDialogs[1] ;
              NAME "paleta"   ;
              SIZE 73, 54 NOBORDER ;
              PIXEL

       @ 54, 0  BUTTON oBtn      ;
              PROMPT "&Mas..."   ;
              OF oFld:aDialogs[1]      ;
              FONT oFont         ;
              SIZE 72, 12  PIXEL ;
              ACTION ( nClrReturn := ChooseColor( nColor ),;
                       lCancel := .f. ,;
                       oDlg:End() )

       oBmp:bLClicked := {| nRow, nCol | nFila := nRow, nColumna := nCol ,;
                                       lCancel := .f.,;
                                       lPaleta := .t.,;
                                       oDlg:End() }

       oLbx := TLbxSysColor():New( 0, 0, 75, 70, oFld:aDialogs[2] )

       oLbx:bLDblClick := { || lPaleta := .f., SetColorReturn( GetSysColor( oLbx:aSysColors[ oLbx:GetPos() ] )), oDlg:End(), lCancel := .f.  }

       //oFld:aDialogs[2]:oClient := oLbx


ACTIVATE DIALOG oDlg

if lCancel
   return nColor
endif

if lPaleta

   nHFila := int( 108 / 6 )
   nWCol  := int( 145 / 8 )

   nOption := ( int( nFila / nHFila ) * 8 ) + int( nColumna / nWCol ) + 1

   nClrReturn := aColors[ nOption ]

endif

return nClrReturn


function SetColorReturn( n )
nClrReturn := n
return nClrReturn

********************************************
   function xSelFont( nRow, nCol, cFont )
********************************************
local oDlg
local oLbx
local lCancel := .t.

cFaceName := cFont

DEFINE DIALOG oDlg STYLE nOr( WS_POPUP, DS_MODALFRAME ) ;
       FROM nRow, nCol-20 TO nRow + 132, nCol + 148 PIXEL

       oLbx := TLbxFont():New( 0, 0, 85, 70, oDlg, bSETGET( cFont ) )

       oLbx:bLDblClick := { || SetFaceNameReturn( oLbx:aItems[ oLbx:GetPos() ] ), oDlg:End()  }

       oDlg:oClient := oLbx


ACTIVATE DIALOG oDlg

return cFaceName

function SetFaceNameReturn( cFont )
cFaceName := cFont
return cFaceName


function xSelImage()
local oDirL1, oImagelist, oDlg


DEFINE DIALOG oDlg FROM 10, 10 TO 400, 700 PIXEL

       oDirL1 := TDirList():New( 10, 10, 90, 120, oDlg )
       oImageList := TImageBrw():New( 10, 110, 185, 155, oDlg )
       oDirL1:bChange := {|aItems| oImageList:nFirst := 1, AddImages( aItems, oImageList, oDirL1 ) }

       @ 170, 270 BUTTON "Aceptar" SIZE 28, 12 PIXEL ACTION oDlg:End()

ACTIVATE DIALOG oDlg CENTERED


return nil

****************************************************************************
   function xSelControl( nRow, nCol, coControl2, acoControls, oForm )
****************************************************************************
local oDlg
local oLbx
local lCancel := .t.

//cFaceName := cFont

DEFINE DIALOG oDlg STYLE nOr( WS_POPUP, DS_MODALFRAME ) ;
       FROM nRow, nCol-20 TO nRow + 147, nCol + 148 PIXEL

       @ 0,0 LISTBOX oLbx VAR coControl2 ITEMS acoControls SIZE 85, 80 PIXEL OF oDlg ;
             ON CHANGE oForm:cSetFocus( coControl2 )

       oLbx:bLDblClick := { || SetcoCOntrolReturn( oLbx:aItems[ oLbx:GetPos() ] ), lCancel := .f., oDlg:End()  }

       oDlg:oClient := oLbx


ACTIVATE DIALOG oDlg

return coControl

function SetcoControlReturn( c )
coControl := c
return coControl


CLASS TWindowExt FROM TWindow

      CLASSDATA lRegistered AS Logical

      METHOD HandleEvent( nMsg, nWParam, nLParam )

ENDCLASS

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWindowExt

if nMsg == 6 //.or. nMsg == WM_SETFOCUS
   //
   if nWParam == 0

   else

   endif
   //oWndActive( ::aControls[1] )
endif

return super:HandleEvent( nMsg, nWParam, nLParam )


****************************************************************************************
  function UpAll()
****************************************************************************************

//BringWindowToTop(oProperties():hWnd)
//BringWindowToTop(Aplicacion():oToolBox:hWnd)




return 1
