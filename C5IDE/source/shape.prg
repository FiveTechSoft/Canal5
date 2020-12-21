#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#define LOGPIXELSY          90

static nIdItem := 1
static cWindow := ""
static cHeader := ""
static aVarNames := {}

CLASS TShape

      DATA hWnd
      DATA hDC

      CLASSDATA cInfo
      CLASSDATA acInfos        AS ARRAY INIT {}

      DATA nID
      DATA nItemID

      DATA aDots
      DATA aDotsActives
      DATA aOldPos
      DATA aPages
      DATA aPropBase
      DATA aProperties
      DATA aPropertiesPPC
      DATA aRect
      DATA aRelPos
      DATA aShapes
      DATA bContextMenu
      DATA bKeyChar
      DATA bKeyDown
      DATA bLClicked
      DATA bLostFocus
      DATA cxCaption
      DATA cFileName
      DATA cObjName
      DATA cVarName

      DATA oFont     AS CHARACTER INIT ""
      DATA cFaceName
      DATA nWidthFont
      DATA nHeightFont
      DATA lBold
      DATA lItalic
      DATA lUnderline
      DATA lStrikeOut

      DATA lBorder
      DATA lCanMove
      DATA lCanSize
      DATA lCaption
      DATA lContainer
      DATA lEditable
      DATA lFilled
      DATA lForm               // provisional
      DATA lLocked
      DATA lModalFrame
      DATA lMultiline
      DATA lPaintBorderDsgn
      DATA lSelected
      DATA lVisible
      DATA lVisibleInForm
      DATA nClrBorder
      DATA nClrDot               AS NUMERIC INIT CLR_BLUE
      DATA nClrPane
      DATA nClrText
      DATA nEnPage
      DATA nIdentifier
      DATA nOption
      DATA oParent
      DATA oWnd
      DATA xMaxHeight
      DATA xMaxWidth
      DATA xMinHeight
      DATA xMinWidth

      DATA nTabIndex
      DATA cFileName
      DATA lGroup // cabecera de radiomenu
      DATA lCaptured AS LOGICAL INIT .F.

      CLASSDATA aVarNames

      DATA oTop, oLeft, oBottom, oRight, oClient

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR

      METHOD AddShape     ( oShape )      VIRTUAL
      METHOD Copy         ( nRow, nCol )
      METHOD CheckSelecteds( aRect )      INLINE .f.
      METHOD ChooseFont   ()
      METHOD ResetSelecteds()
      METHOD DeleteChild  ( o )           VIRTUAL
      METHOD Destroy      ( )             VIRTUAL
      METHOD Distintos    ( oShape )      OPERATOR "!="
      METHOD DotsSelect   ( hDC )
      METHOD Edit         ( nKey )
      METHOD EditDlg      ()
      METHOD cGenVar      ( )             VIRTUAL
      METHOD GetClientRect( )             INLINE {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      METHOD GetContainer ( aRect )
      METHOD GetFontEx()
      METHOD GetNewId     ( )             INLINE ++nIdItem
      METHOD GetRect      ( )             INLINE {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      METHOD GotoX        ( nRow )
      METHOD GotoY        ( nCol )
      METHOD Hide         ( )
      METHOD Iguales      ( oShape )       OPERATOR "=="
      METHOD IntersectRect( aRect )
      METHOD Load         ( cInfo )
      METHOD LoadFile     ( cFileName )
      METHOD MenuContex   ( nRow, nCol )   VIRTUAL
      METHOD MouseWheel   ( nKeys, nDelta, nXPos, nYPos ) VIRTUAL
      METHOD MoveTo       ( aPos, lRefresh )
      METHOD OffSet       ( nRows, nCols )
      METHOD Paint        ( hDC )
      METHOD Paint        ( )              VIRTUAL
      METHOD PaintContour ( hDC )
      METHOD PaintHScroll ( hDC, lRight, lVScroll, lRight, lFull )
      METHOD PaintVScroll ( hDC, lRight, lHScroll, lDown,  lFull )
      METHOD Paste        ( nTop, nLeft, oWnd )
      METHOD Refresh      ( )              INLINE  if( ::oWnd != nil,::oWnd:Refresh(),nil)
      METHOD Resize       ( ) VIRTUAL
      METHOD Save         ( )
      METHOD SaveFile     ( cFileName )
      METHOD Save2RC      ( cFileName )
      METHOD Save2PRG     ( cFileName )
      METHOD Save2Ini     ( cFileName ) VIRTUAL
      METHOD SetFocus     ( lUpdate )
      METHOD SetSize      ( nWidth, nHeight )
      METHOD ShapeOver    ( nRow, nCol )
      METHOD Show         ( )
      METHOD StorePos     ( )              INLINE ::aOldPos := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
      METHOD StoreRelPos  ( )
      METHOD ToBottom     ( nInc )
      METHOD ToLeft       ( nInc )
      METHOD ToRight      ( nInc )
      METHOD ToTop        ( nInc )
      METHOD cCaption     ( cNewVal )      SETGET
      METHOD lIsMovingSel ( )
      METHOD nAbsBottom   ( ) INLINE ::nBottom - ::oWnd:oForm:nHCaption
      METHOD nAbsLeft     ( ) INLINE ::nLeft   - ::oWnd:oForm:nBorder
      METHOD nAbsRight    ( ) INLINE ::nRight  - ::oWnd:oForm:nBorder
      METHOD nAbsTop      ( ) INLINE ::nTop    - ::oWnd:oForm:nHCaption
      METHOD nBottom      ( nNewVal )       SETGET
      METHOD nHeight      ( nNewVal )       SETGET
      METHOD nLeft        ( nNewVal )       SETGET
      METHOD nMaxHeight   ( nVal )          SETGET
      METHOD nMaxWidth    ( nVal )          SETGET
      METHOD nMinHeight   ( nVal )          SETGET
      METHOD nMinWidth    ( nVal )          SETGET
      METHOD nRight       ( nNewVal )       SETGET
      METHOD nTop         ( nNewVal )       SETGET
      METHOD nWidth       ( nNewVal )       SETGET
      METHOD xPaste       ( oWnd, cInfo )

      METHOD PropCount    ()                INLINE Len( if( ::oWnd:lPocketPC(),::aPropertiesPPC,::aProperties ) )
      METHOD Property     ( n )             INLINE if( ::oWnd:lPocketPC(),::aPropertiesPPC,::aProperties )[n]
      METHOD Inspect      ( cDataName )
      METHOD GetColor     ( nDataName, uVal )
      METHOD SetProp      ( nDataName, uVal )
      METHOD cGetFileName()

      METHOD GenRc        ( )
      METHOD GenRcManifest( )
      METHOD GenPrg       ( )
      METHOD cStrID()
      METHOD cStrLeft()
      METHOD cStrTop()
      METHOD cStrRight()
      METHOD cStrBottom()
      METHOD cStrWidth()
      METHOD cStrHeight()
      METHOD YPix2Dlg( nPix )
      METHOD XPix2Dlg( nPix )

      METHOD cGetVarName()
      METHOD GetObjName()
      METHOD GetObjNames()
      METHOD GetObjFromName( cName )
      METHOD SetProps( oObject ) VIRTUAL

      METHOD DestroyTooltip()           VIRTUAL
      METHOD CheckToolTip()             VIRTUAL
      METHOD KeyDown( nKey, nFlags )    VIRTUAL
      METHOD LButtonDown( nRow, nCol )  VIRTUAL
      METHOD MouseMove( nRow, nCol )    VIRTUAL
      METHOD LButtonUp( nRow, nCol )    VIRTUAL
      METHOD Capture()       INLINE SetCapture( ::oWnd:hWnd ), ::lCaptured := .t.
      METHOD ShowToolTip2()             VIRTUAL

ENDCLASS

METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TShape

local oContainer := nil
local lIs

DEFAULT nTop := 0, nLeft := 0, nBottom := 0, nRight := 0

  ::aDots            := array(8)
  ::aDotsActives     := {1,1,1,1,1,1,1,1}
  ::aPages           := {}
  ::aShapes          := {}
  ::aRect            := {nTop, nLeft, nBottom, nRight}
  ::bContextMenu     := nil
  ::bLClicked        := nil
  ::lBorder          := .t.
  ::lCaption         := .t.
  ::lCanSize         := .t.
  ::lCanMove         := .t.
  ::lContainer       := .f.
  ::lEditable        := .t.
  ::lForm            := .f.
  ::lLocked          := .f.
  ::lModalFrame      := .f.
  ::lMultiline       := .f.
  ::lPaintBorderDsgn := .t.
  ::lSelected        := .f.
  ::lVisible         := .t.
  ::lVisibleInForm   := .t.
  ::nClrBorder       := CLR_BLACK
  ::nClrPane         := CLR_HGRAY
  ::nClrText         := CLR_BLACK
  ::nItemId          := ::GetNewId()
  ::nOption          := 1
  ::oWnd             := oWnd
  ::xMaxHeight       := 3000
  ::xMaxWidth        := 3000
  ::xMinHeight       := 1
  ::xMinWidth        := 1

  ::cFaceName        := "" //GetDefaultFontName() //"" // buscar el nombre de la del sistema
  ::nWidthFont       := 0
  //::nHeightFont      := "" //GetDefaultFontHeight()
  ::lBold            := nil
  ::lItalic          := nil
  ::lUnderline       := nil
  ::lStrikeOut       := nil
  ::aVarNames        := {}
  ::nTabIndex        := 0


  if ::oWnd != nil
     oContainer := ::oWnd:GetContainer( ::aRect )
     if oContainer != nil
        oContainer:AddShape( self )
        ::oParent := oContainer
     else
        ::oWnd:AddShape( self )
     endif
  endif

  ::aPropertiesPPC := { "cCaption"      ,;
                        "lBorder"       ,;
                        "nID"           ,;
                        "nTop"          ,;
                        "nLeft"         ,;
                        "nWidth"        ,;
                        "nHeight"       ,;
                        "nClrPane"      ,;
                        "nClrText"      ,;
                        "cFaceName"     ,;//   "nWidthFont"    ,;
                        "nHeightFont"   ,;
                        "lBold"         ,;
                        "lItalic"       ,;
                        "lUnderline"    ,;
                        "lStrikeOut"    }


  ::aPropBase := {"aDots"            ,;
                  "aDotsActives"     ,;
                  "aPages"           ,;
                  "aShapes"          ,;
                  "cCaption"         ,;
                  "cFaceName"        ,;
                  "nHeightFont"      ,;
                  "cObjName"         ,;
                  "lActive"          ,;
                  "lBold"            ,;
                  "lBorder"          ,;
                  "lCanMove"         ,;
                  "lCanSize"         ,;
                  "lEditable"        ,;
                  "lFilled"          ,;
                  "lItalic"          ,;
                  "lModalFrame"      ,;
                  "lMultiline"       ,;
                  "lPaintBorderDsgn" ,;
                  "lStrikeOut"       ,;
                  "lUnderline"       ,;
                  "lVisible"         ,;
                  "lVisible"         ,;
                  "lVisibleInForm"   ,;
                  "nClrBorder"       ,;
                  "nClrPane"         ,;
                  "nClrText"         ,;
                  "nHeight"          ,;
                  "nHeightFont"      ,;
                  "nLeft"            ,;
                  "nOption"          ,;
                  "nTop"             ,;
                  "nWidth"           ,;
                  "nWidthFont"       ,;
                  "xMaxHeight"       ,;
                  "xMaxWidth"        ,;
                  "xMinHeight"       ,;
                  "xMinWidth"        }

return self


*************************************************************************************************
      METHOD nTop( nNewVal ) CLASS TShape
*************************************************************************************************
local nHeight

if nNewVal != nil
   nHeight := ::aRect[3] - ::aRect[1]
   ::aRect[1] := nNewVal
   ::aRect[3] := ::aRect[1] + nHeight
endif

return ::aRect[1]

*************************************************************************************************
      METHOD nLeft( nNewVal ) CLASS TShape
*************************************************************************************************
local nWidth

if nNewVal != nil
   nWidth := ::aRect[4] - ::aRect[2]
   ::aRect[2] := nNewVal
   ::aRect[4] := ::aRect[2] + nWidth
endif

return ::aRect[2]

*************************************************************************************************
      METHOD nBottom( nNewVal ) CLASS TShape
*************************************************************************************************

if nNewVal != nil
   ::aRect[3] := nNewVal
endif

return ::aRect[3]

*************************************************************************************************
      METHOD nRight ( nNewVal ) CLASS TShape
*************************************************************************************************

if nNewVal != nil
   ::aRect[4] := nNewVal
endif

return ::aRect[4]

*************************************************************************************************
      METHOD nWidth ( nNewVal ) CLASS TShape
*************************************************************************************************

if nNewVal != nil
   ::aRect[4] := ::aRect[2] + nNewVal
endif

return ::aRect[4] - ::aRect[2]


*************************************************************************************************
      METHOD nHeight( nNewVal ) CLASS TShape
*************************************************************************************************

if nNewVal != nil
   ::aRect[3] := ::aRect[1] + nNewVal
endif

return ::aRect[3] - ::aRect[1]

*************************************************************************************************
  METHOD Paint( hDC ) CLASS TShape
*************************************************************************************************

local nHCaption
local aRect2
local aRcBtn
local nW

  if ::lIsMovingSel()
     return ::PaintContour( hDC )
  endif

  if ::lBorder
     FillSolidRect( hDC, ::aRect, ::nClrPane, ::nClrBorder )
  else
     FillSolidRect( hDC, ::aRect, ::nClrPane )
  endif

  if ::oWnd:oSelected != nil .and. ::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected
     ::DotsSelect( hDC )
  endif


return nil

*************************************************************************************************
  METHOD PaintContour( hDC ) CLASS TShape
*************************************************************************************************
local hPen := ExtCreatePen( 2, 0 )
local hOldPen := SelectObject( hDC, hPen )


Moveto( hDC, ::nLeft, ::nTop )
Lineto( hDC, ::nRight, ::nTop )
Lineto( hDC, ::nRight, ::nBottom )
Lineto( hDC, ::nLeft, ::nBottom )
Lineto( hDC, ::nLeft, ::nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )


return nil


*************************************************************************************************
  METHOD DotsSelect( hDC ) CLASS TShape
*************************************************************************************************
local aRect := {0,0,6,6}
local nClrBorder
local nClrPane
local lFocused := .f.

  if ( ::oWnd:lMoviendo .or. ::oWnd:lKeyDown ) .and. ::oWnd:oForm:nItemId != ::nItemId
     return nil
  endif


  nClrBorder := 0 //::nClrDot
  nClrPane   := CLR_WHITE //::nClrDot

  do case
     case ::lSelected

          if ::oWnd:oSelected == self
             nClrBorder := CLR_WHITE //0 //RGB( 178,180,191 )
             nClrPane   := 0         //CLR_WHITE //RGB( 178,180,191 )
          else
             nClrBorder := 0 //RGB( 178,180,191 )
             nClrPane   := CLR_WHITE
          endif
          if ::oWnd:oFocused != nil .and. ::oWnd:oFocused:nID == ::nID
             lFocused := .t.
             nClrBorder := 0 //RGB( 178,180,191 )
             nClrPane := CLR_WHITE //RGB( 178,180,191 )

             //nClrPane   := RGB( 178,180,191 )
          endif

     case !::lCanSize

          nClrBorder := 0 //::nClrDot
          nClrPane   := CLR_WHITE

  endcase

  if ::lPaintBorderDsgn                //DsgnBorde( hDC, {::aRect[1]-7, ::aRect[2]-7, ::aRect[3]+8, ::aRect[4]+8} )
     DrawFocusRect( hDC,::aRect[1]-4, ::aRect[2]-4, ::aRect[3]+4, ::aRect[4]+4 )
  endif

  ::aDots := array( 8 )

  aRect := OffsetRect( aRect, ::nLeft-7, ::nTop-7 )
  ::aDots[1] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nLeft + int((::nRight - ::nLeft)/2)-3, ::nTop-7 )
  ::aDots[2] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nRight+1, ::nTop-7 )
  ::aDots[3] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nRight+1 , ::nTop + int((::nBottom - ::nTop)/2)-3)
  ::aDots[4] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nRight+1, ::nBottom+1 )
  ::aDots[5] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nLeft + int((::nRight - ::nLeft)/2)-3, ::nBottom+1 )
  ::aDots[6] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nLeft-7, ::nBottom+1 )
  ::aDots[7] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

  aRect := {0,0,6,6}
  aRect := OffsetRect( aRect, ::nLeft-7, ::nTop + int((::nBottom - ::nTop)/2)-3 )
  ::aDots[8] := {aRect[1],aRect[2],aRect[3],aRect[4]}
  //if ::lSelected
  //   FillSolidRect( hDC, aRect, nClrPane, nClrBorder )
  //else
     Ellipse( hDC, aRect[2], aRect[1],aRect[4], aRect[3])
  //endif

return nil



*************************************************************************************************
  METHOD GotoX( nCol, lUndo ) CLASS TShape
*************************************************************************************************
local nWidth := ::nWidth

DEFAULT lUndo := .f.

if !lUndo
   ::oWnd:AddUndo( self, "MoveTo", { ::aRect[1],::aRect[2],::aRect[3],::aRect[4]}, .t. )
endif

::aRect[2] := nCol
::aRect[4] := ::aRect[2] + nWidth

::StorePos()

if lUndo
   ::oWnd:Refresh()
endif


return nil

*************************************************************************************************
  METHOD GotoY( nRow, lUndo) CLASS TShape
*************************************************************************************************
local nHeight := ::nHeight

DEFAULT lUndo := .f.

if !lUndo
   ::oWnd:AddUndo( self, "MoveTo", { ::aRect[1],::aRect[2],::aRect[3],::aRect[4]}, .t. )
endif

::aRect[1] := nRow
::aRect[3] := ::aRect[1] + nHeight

::StorePos()

if lUndo
   ::oWnd:Refresh()
endif

return nil



*************************************************************************************************
  METHOD OffSet( nRows, nCols ) CLASS TShape
*************************************************************************************************

local oShape, oPage

   ::aRect := { ::aOldPos[1]+nRows, ;
                ::aOldPos[2]+nCols, ;
                ::aOldPos[3]+nRows, ;
                ::aOldPos[4]+nCols  }

   if !empty(::aPages)
      for each oPage in ::aPages
          for each oShape in oPage:aShapes
              oShape:OffSet( nRows, nCols )
          next
      next
   endif



return nil

*************************************************************************************************
      METHOD MoveTo( aPos, lRefresh ) CLASS TShape
*************************************************************************************************
DEFAULT lRefresh := .f.

::aRect := { aPos[1],aPos[2],aPos[3],aPos[4] }

::StorePos()

if lRefresh
   ::oWnd:Refresh()
endif

return nil

*************************************************************************************************
   METHOD SetFocus( lUpdate ) CLASS TShape
*************************************************************************************************

DEFAULT lUpdate := .t.

::oWnd:oSelected := self

if lUpdate
   ::oWnd:Inspect( self )
endif

//if oWndCode() != nil
//   oWndCode():oClient:ClearAll()
//   oWndCode():oClient:AddText( ::GenPrg() )
//endif


return self


*************************************************************************************************
   METHOD SetSize( nWidth, nHeight, lUndo ) CLASS TShape
*************************************************************************************************
local lChange := .t.


if nWidth  == nil; nWidth  := ::nWidth ; endif
if nHeight == nil; nHeight := ::nHeight; endif
if lUndo   == nil; lUndo   := .f.      ; endif

if nWidth < ::nMinWidth
   nWidth := ::nMinWidth
   lChange := .f.
endif

if nHeight < ::nMinHeight
   nHeight := ::nMinHeight
   lChange := .f.
endif

if !lUndo .and. lChange
   ::oWnd:AddUndo( self, "SetSize", ::nWidth, ::nHeight, .t. )
endif

::aRect[4] := ::aRect[2] + nWidth
::aRect[3] := ::aRect[1] + nHeight

::StorePos()

if lUndo
   ::oWnd:Refresh()
endif

return nil


*************************************************************************************************
  METHOD ToLeft( nInc ) CLASS TShape
*************************************************************************************************

 ::GotoX( ::nLeft - nInc )

 ::StorePos()

 ::oWnd:Refresh()

return nil


*************************************************************************************************
  METHOD ToRight( nInc ) CLASS TShape
*************************************************************************************************

 ::GotoX( ::nLeft + nInc )

 ::StorePos()

 ::oWnd:Refresh()

return nil

*************************************************************************************************
  METHOD ToTop( nInc ) CLASS TShape
*************************************************************************************************

 ::GotoY( ::nTop - nInc )

 ::StorePos()

 ::oWnd:Refresh()

return nil


*************************************************************************************************
  METHOD ToBottom( nInc ) CLASS TShape
*************************************************************************************************

 ::GotoY( ::nTop + nInc )

 ::StorePos()

 ::oWnd:Refresh()

return nil

***************************************************************************************************
  METHOD PaintVScroll( hDC, lRight, lHasHScroll, lDown, lFull, nCaption  ) CLASS TShape
***************************************************************************************************
local nH, rc
local nLeft, nTop, nRight, nBottom
local aRect  := ::aRect
local nBorde := if(::lModalFrame,2,0)
local hTheme
local nClrPane := rgb(222,207,198)
local hBmp
local nW
local n

DEFAULT lDown       := .f.
DEFAULT lRight      := .t.
DEFAULT lHasHScroll := .f.
DEFAULT lFull       := .f.
DEFAULT nCaption    := 0

if ::oWnd:lPocketPc()
   nW := 14
else
   nW := 20
endif

if lFull
   nTop    := ::aRect[1]
   nLeft   := ::aRect[2]
   nBottom := ::aRect[3]
   nRight  := ::aRect[4]
else
   if lRight
      nTop    := ::aRect[1] + if( lHasHScroll, if( lDown, nBorde, nW-1 ), nBorde ) + nCaption+1
      nLeft   := ::aRect[4] - nW+1
      nBottom := ::aRect[3] - if( lHasHScroll, if( lDown, nW-1, nBorde ), nBorde ) -1
      nRight  := ::aRect[4] - nBorde-1
   else
      nTop    := ::aRect[1] + if( lHasHScroll, if( lDown, nBorde, nW-1 ), nBorde )
      nLeft   := ::aRect[2] + nBorde
      nBottom := ::aRect[3] - if( lHasHScroll, if( lDown, nW-1, nBorde ), nBorde )
      nRight  := nLeft      + nW-1
   endif
endif

nH := nBottom - nTop

if ::oWnd:lPocketPc()

   FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, CLR_WHITE, 0 )

   FillSolidRect( hDC, {nTop,       nLeft, nTop+min(19, nH/2),   nRight}, nClrPane, 0 )

   hBmp := LoadBitmap( GetResources(), "arrowup" )
   DrawMasked( hDC, hBmp, nTop + min(6, nH/2), nLeft+1  )
   DeleteObject( hBmp )

   if nH > 19*3
      FillSolidRect( hDC, {nTop+19,    nLeft, nTop+19*2, nRight}, nClrPane, 0 )
      hBmp := LoadBitmap( GetResources(), "gripver" )
      DrawMasked( hDC, hBmp, nTop + 19 +6, nLeft + 2+1 )
      DeleteObject( hBmp )
   endif

   FillSolidRect( hDC, {nBottom-min(19, nH/2), nLeft, nBottom,   nRight}, nClrPane, 0 )
   hBmp := LoadBitmap( GetResources(), "arrow" )
   DrawMasked( hDC, hBmp, nBottom - min(13, nH/2), nLeft+1  )
   DeleteObject( hBmp )

else

   if lTemas() .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "SCROLLBAR")

      if hTheme != nil
         rc := { nTop, nLeft, nBottom, nRight }
         C5_DrawThemeBackground( hTheme, hDC, SBP_LOWERTRACKVERT,SCRBS_NORMAL , rc )


         n := min(19, nH/2)
         rc := { nTop+1, nLeft+1, nTop + n , nRight }
         C5_DrawThemeBackground( hTheme, hDC, SBP_ARROWBTN,ABS_UPNORMAL , rc )

         if nH > 57
            rc := { nTop+20,nLeft+1,nTop+37,nRight}
            C5_DrawThemeBackground( hTheme, hDC, SBP_THUMBBTNVERT,SCRBS_NORMAL , rc )
            C5_DrawThemeBackground( hTheme, hDC, SBP_GRIPPERVERT,SCRBS_NORMAL , rc )
         endif

         rc := { nBottom - min(19, nH/2),nLeft+1,nBottom,nRight}
         C5_DrawThemeBackground( hTheme, hDC, SBP_ARROWBTN,ABS_DOWNNORMAL , rc )

         C5_CloseThemeData()

      endif

   else


      DrawFrameControl(hDC, { nTop        ,;
                              nLeft       ,;
                              nBottom     ,;
                              nRight        }, DFC_BUTTON, nOr( DFCS_BUTTONPUSH, DFCS_FLAT ))


      DrawFrameControl(hDC, { nTop    +  1  ,;
                              nLeft   +  1,;
                              nTop    + min(19, nH/2) ,;
                              nRight        }, DFC_SCROLL, DFCS_SCROLLUP )

      if nH > 57
         DrawFrameControl(hDC, { nTop    + 20,;
                                 nLeft   +  1,;
                                 nTop    + 37,;
                                 nRight        }, DFC_BUTTON, DFCS_BUTTONPUSH)
      endif

      DrawFrameControl(hDC, { nBottom - min(19, nH/2) ,;
                              nLeft   +  1,;
                              nBottom     ,;
                              nRight        }, DFC_SCROLL, DFCS_SCROLLDOWN)

   endif

endif

return nil

***************************************************************************************************
  METHOD PaintHScroll( hDC, lDown, lHasVScroll, lRight, lFull ) CLASS TShape
***************************************************************************************************
local nW, nH, rc
local nLeft, nTop, nRight, nBottom
local aRect  := ::aRect
local nBorde := if(::lModalFrame,2,0)
local hTheme
local nClrPane := rgb(222,207,198)
local hBmp
DEFAULT lDown  := .t.
DEFAULT lRight := .t.
DEFAULT lHasVScroll := .f.
DEFAULT lFull := .f.

if ::oWnd:lPocketPc()
   nH := 14
else
   nH := 20
endif

if lFull
   nTop    := ::aRect[1]
   nLeft   := ::aRect[2]
   nBottom := ::aRect[3]
   nRight  := ::aRect[4]
else

   aRect := ::aRect

   if lDown
      nTop    := aRect[3] - nH -1
      nLeft   := aRect[2] + if( lHasVScroll, if( lRight, nBorde, nH ), nBorde )-1
      nBottom := aRect[3] -  nBorde -1
      nRight  := aRect[4] - if( lHasVScroll, if( lRight, nH, nBorde ), nBorde )-1
   else
      nTop    := aRect[1] +  nBorde
      nLeft   := aRect[2] + if( lHasVScroll, if( lRight, nBorde, nH ), nBorde )
      nBottom := aRect[1] + nH
      nRight  := aRect[4] - if( lHasVScroll, if( lRight, nH, nBorde ), nBorde )
   endif
endif

nW := nRight - nLeft

if ::oWnd:lPocketPc()

   FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, CLR_WHITE, 0 )

   FillSolidRect( hDC, {nTop,       nLeft, nBottom, nLeft+ min(19, nW/2)  }, nClrPane, 0 )

   hBmp := LoadBitmap( GetResources(), "arrowle" )
   DrawMasked( hDC, hBmp, nTop+2, nLeft + min(6, nW/2)+1 )
   DeleteObject( hBmp )

   if nW > 19*3
      FillSolidRect( hDC, {nTop, nLeft+19, nBottom, nLeft+19*2}, nClrPane, 0 )
      hBmp := LoadBitmap( GetResources(), "griphor" )
      DrawMasked( hDC, hBmp, nTop + 2, nLeft + 19 +6+1 )
      DeleteObject( hBmp )
   endif

   FillSolidRect( hDC, {nTop, nRight-min(19, nW/2), nBottom,   nRight}, nClrPane, 0 )
   hBmp := LoadBitmap( GetResources(), "arrowri" )
   DrawMasked( hDC, hBmp, nTop+2, nRight- min(13, nW/2+1)  )
   DeleteObject( hBmp )

else


   if lTemas() .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "SCROLLBAR")

      if hTheme != nil
         rc := { nTop, nLeft, nBottom, nRight }
         C5_DrawThemeBackground( hTheme, hDC, SBP_LOWERTRACKHORZ,SCRBS_NORMAL , rc )


         rc := { nTop + 1, nLeft + 1, nBottom, nLeft   + min(19, nW/2) }
         C5_DrawThemeBackground( hTheme, hDC, SBP_ARROWBTN,ABS_LEFTNORMAL , rc )

         if nW > 57
            rc := { nTop + 1, nLeft + 21, nBottom, nLeft + 37  }
            C5_DrawThemeBackground( hTheme, hDC, SBP_THUMBBTNHORZ,SCRBS_NORMAL , rc )
            C5_DrawThemeBackground( hTheme, hDC, SBP_GRIPPERHORZ,SCRBS_NORMAL , rc )
         endif

         rc := { nTop + 1, nRight  - min(19, nW/2), nBottom, nRight }
         C5_DrawThemeBackground( hTheme, hDC, SBP_ARROWBTN,ABS_RIGHTNORMAL , rc )

         C5_CloseThemeData()

      endif

   else

      DrawFrameControl(hDC, { nTop         ,;
                              nLeft        ,;
                              nBottom      ,;
                              nRight        }, DFC_BUTTON, nOr( DFCS_BUTTONPUSH, DFCS_FLAT ))


      DrawFrameControl(hDC, { nTop + 1    ,;
                              nLeft + 1   ,;
                              nBottom     ,;
                              nLeft   + min(19, nW/2) }, DFC_SCROLL, DFCS_SCROLLLEFT )

      if nW > 57
         DrawFrameControl(hDC, { nTop + 1    ,;
                                 nLeft   + 21,;
                                 nBottom     ,;
                                 nLeft   + 37  }, DFC_BUTTON, DFCS_BUTTONPUSH)
      endif

      DrawFrameControl(hDC, { nTop + 1                  ,;
                              nRight  - min(19, nW/2),;
                              nBottom     ,;
                              nRight        }, DFC_SCROLL, DFCS_SCROLLRIGHT)
   endif

endif

return nil


***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TShape
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return ::xMinWidth

***************************************************************************************************
  METHOD nMinHeight( nVal ) CLASS TShape
***************************************************************************************************

if pcount() > 0
   ::xMinHeight := nVal
endif

return ::xMinHeight


***************************************************************************************************
  METHOD nMaxWidth( nVal ) CLASS TShape
***************************************************************************************************

if pcount() > 0
   ::xMaxWidth := nVal
endif

return ::xMaxWidth

***************************************************************************************************
  METHOD nMaxHeight( nVal ) CLASS TShape
***************************************************************************************************

if pcount() > 0
   ::xMaxHeight := nVal
endif

return ::xMaxHeight


***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TShape
***************************************************************************************************
local lIntersect := .f.

if IntersectRect( aRect, ::aRect )
   lIntersect := .t.
endif

return lInterSect


***************************************************************************************************
  METHOD lIsMovingSel() CLASS TShape
***************************************************************************************************
local lIs := .f.

if ::oWnd:lMoviendo
   if ::oWnd:IsInSelecteds( self ) .or.( ::oWnd:oSelected != nil .and. ::oWnd:oSelected:nItemId == ::nItemId )
      return .t.
   endif
endif

return lIs


***************************************************************************************************
METHOD StoreRelPos() CLASS TShape
***************************************************************************************************

::aRelPos := ::GetRect()

if ::oParent != nil
   ::aRelPos[1] -= ::oParent:nTop
   ::aRelPos[2] -= ::oParent:nLeft
   ::aRelPos[3] -= ::oParent:nBottom
   ::aRelPos[4] -= ::oParent:nRight
endif

return nil

//HB_ENUMINDEX()]
***************************************************************************************************
      METHOD Hide() CLASS TShape
***************************************************************************************************
local o

::lVisibleInform := .f.

if len( ::aPages ) > 0
   if len( ::aPages[::nOption] ) > 0
      for each o in ::aPages[::nOption]
          o:Hide()
      next
   endif
endif

return 0


***************************************************************************************************
      METHOD Show() CLASS TShape
***************************************************************************************************
local o

::lVisibleInform := .t.

if len( ::aPages ) > 0
   if len( ::aPages[::nOption] ) > 0
      for each o in ::aPages[::nOption]
          o:Show()
      next
   endif
endif

return 0



***************************************************************************************************
  METHOD cCaption( cNewVal ) CLASS TShape
***************************************************************************************************

if cNewVal != nil

   if lMetoEnUndo()
      ::oWnd:AddUndo( self, "cCaption", ::cxCaption , .t. )
   endif

   ::cxCaption := cNewVal

   if lFromUndo()
      ::oWnd:Refresh()
   endif

endif

return ::cxCaption


***************************************************************************************************
   METHOD Iguales( oShape ) CLASS TShape
***************************************************************************************************

return oShape:nItemId == ::nItemID


***************************************************************************************************
   METHOD Distintos( oShape ) CLASS TShape
***************************************************************************************************

return oShape:nItemId != ::nItemID


***************************************************************************************************
   METHOD Edit( nKey ) CLASS TShape
***************************************************************************************************
local oFont
local bValid := {||.t.}
local oShape := self
local uVar := padr(oShape:cCaption, 100)

/*
if ::oWnd:lPocketPc()
   DEFINE FONT oFont NAME ::cFaceName SIZE ::nWidthFont, ::nHeightFont
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10
endif
*/
oFont := ::oWnd:oForm:GetFontEx()

if oShape:lEditable

   if nKey != nil
      uVar := padr(chr( nKey ), 100)
   endif

   ::oWnd:oGet := TGet():New(oShape:nTop+1,oShape:nLeft+1,{ | u | If( PCount()==0, uVar, uVar:= u ) },oShape:oWnd,oShape:nWidth-2,oShape:nHeight-1,,,0,16777215,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   if nKey != nil
      ::oWnd:oGet:SetPos(2,2)
   endif

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
                                  oShape:oWnd:oGet:End(), DisableUndo()) }

   ::oWnd:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE,;
    ( oShape:oWnd:nLastKey := nKey, SetFocus(oShape:oWnd:hWnd)), ) }
                                    //oShape:oWnd:oGet:End(),
endif

return nil

**************************************************************************************************
  METHOD EditDlg () CLASS TShape
**************************************************************************************************
local oWnd
local oIcon1


 DEFINE DIALOG oWnd FROM 0, 0 TO 0,0  SIZE 118, 79 ;
        TITLE "Form"


        @ 10.00, 20.50 IMAGE oIcon1 FILENAME "" ;
                 SIZE 16.00, 16.00 PIXEL ;
                 OF oWnd NOBORDER


oWnd:lHelpIcon := .f.

ACTIVATE DIALOG oWnd CENTERED

return nil


return nil

**************************************************************************************************
  METHOD Save() CLASS TShape
**************************************************************************************************

   local n
   local cType, cInfo := "", cMethod
   local oWnd  := &( ::ClassName() + "()" )
   local uData, nProps := 0

   oWnd = oWnd:New()

   for n = 1 to Len( ::aProperties )
       uData := OSend( Self, ::aProperties[ n ] )
       cInfo += ( I2Bin( Len( ::aProperties[ n ] ) ) + ;
                     ::aProperties[ n ] )
       nProps++
       cType = ValType( uData )
       do case
          case cType == "A"
               cInfo += ASave( uData )

          case cType == "O"
               cInfo += uData:Save()

          otherwise
               cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                          uData )
       endcase
   next

   oWnd := nil

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo



****************************************************************************************************
  METHOD Load( cInfo ) CLASS TShape
****************************************************************************************************


   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer
   local obj
   local aArray

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              OSend( Self, "_" + cData, ORead( cBuffer ) )

         case cType == "C"
              OSend( Self, "_" + cData, cBuffer )

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == ".T." )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return nil

function ARead( cInfo )

   local nPos := 1, nLen, n
   local aArray, cType, cBuffer

   nLen   = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos  += 2
   aArray = Array( nLen )

   for n = 1 to Len( aArray )
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen

      do case
         case cType == "A"
              aArray[ n ] = ARead( "A" + I2Bin( nLen ) + cBuffer )

         case cType == "O"
              aArray[ n ] = ORead( cBuffer )

         case cType == "C"
              aArray[ n ] = cBuffer

         case cType == "D"
              aArray[ n ] = CToD( cBuffer )

         case cType == "L"
              aArray[ n ] = ( cBuffer == ".T." )

         case cType == "N"
              aArray[ n ] = Val( cBuffer )
      endcase
   next

return aArray

function ASave( aArray )

   local n, cType, uData
   local cInfo := ""

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
         case cType == "A"
              cInfo += ASave( aArray[ n ] )

         case cType == "O"
              cInfo += aArray[ n ]:Save()

         otherwise
              cInfo += ( cType + I2Bin( Len( uData := cValToChar( aArray[ n ] ) ) ) +  uData )
      endcase
   next

return "A" + I2Bin( 2 + Len( cInfo ) ) + I2Bin( Len( aArray ) ) + cInfo

****************************************************************************************************
   METHOD SaveFile( cFileName ) CLASS TShape
****************************************************************************************************

 DEFAULT cFileName := cNewFileName( "Test", "ffm" )

return MemoWrit( cFileName, ::Save() )

****************************************************************************************************
   METHOD Save2RC( cFileName ) CLASS TShape
****************************************************************************************************
local h

   DEFAULT cFileName := cNewFileName( "Test", "rc" )

 h := fcreate( cFileName )
 fwrite( h, ::GenRC() )
 fclose( h )

return 0

****************************************************************************************************
   METHOD Save2PRG( cFileName ) CLASS TShape
****************************************************************************************************
local h
local a :={}
local n
local cCurPath  := cFilePath( GetModuleFileName( GetInstance() ) )
local cPrg

if right( cCurPath,1) != "\";     cCurPath += "\";   endif


   DEFAULT cFileName := cNewFileName( "Test", "prg" )

::cFileName := cFileName

 h := fcreate( cFileName )

 for n := 1 to len( ::oWnd:aShapes )-1
     aadd( a, ::oWnd:aShapes[n] )
 next

 a := asort( a,,,{|x,y| x:nTop < y:nTop .and. if( x:nTop == y:nTop, x:nLeft < y:nLeft, .t. ) } ) //.and. x:nLeft < y:nLeft

 for n := 1 to len( a )
     ::oWnd:aShapes[n] := a [n]
 next

 cPrg := ::GenPRG(.F.)

 fwrite( h, cPrg )
 fclose( h )

 //ShellExecute( GetActiveWindow() ,nil, cFileName ,'','',5)

 if !file( "WindowsXP.Manifest" )
    h := fcreate( "WindowsXP.Manifest" )
    fwrite( h, ::GenRcManifest() )
    fclose( h )
 endif

 if !file( cFileNoExt( cFileName ) + ".rc" )
    h := fcreate( cFileNoExt( cFileName ) + ".rc" )
    fwrite( h,   '1 24 "WinXP/WindowsXP.Manifest"' )
    fclose( h )
 endif


return 0


****************************************************************************************************
  METHOD LoadFile( cFileName, oWnd ) CLASS TShape
****************************************************************************************************

   local cInfo, nPos := 4
   local nLenName
   local cClassName
   local oObj

   DEFAULT cFileName := ""

   if ! File( cFileName )
      MsgStop( "File not found: " + cFileName )
      return nil
   endif

   cInfo  = MemoRead( cFileName )
   nLenName := bin2I( substr( cInfo, nPos, 2 ) )
   cClassName := substr( cInfo, 6, nLenName )
   oObj       := &( cClassName + "()" )
   oObj:New()
   oObj:oWnd := oWnd
   oWnd:AddShape( oObj )
   //nPos  += ( 2 + Bin2I( SubStr( cInfo, nPos, 2 ) ) )
   nPos := 1
   cInfo := substr( cInfo, 6 + nLenName )
   oObj:Load( SubStr( cInfo, nPos ) )
   oWnd:Refresh()

return nil



*********************************************************************************
  METHOD Copy( nRow, nCol ) CLASS TShape
*********************************************************************************
local oShape
::cInfo := ""
asize( ::acInfos, 0 )
if len(::oWnd:aSelecteds) > 1

   for each oShape in ::oWnd:aSelecteds
       aadd( ::acInfos, oShape:Save() )
   next

else

   ::cInfo := ::Save()

endif

return ::cInfo

*********************************************************************************
  METHOD Paste( nTop, nLeft, oWnd ) CLASS TShape
*********************************************************************************
local cStr
local oObj
local nWidth, nHeight

if !empty( ::cInfo )
   oObj := ::xPaste( oWnd )
   nWidth  := oObj:nWidth
   nHeight := oObj:nHeight

   oObj:aRect[1] := nTop
   oObj:aRect[2] := nLeft
   oObj:aRect[3] := nTop + nHeight
   oObj:aRect[4] := nLeft + nWidth
else
   ::oWnd:ResetSelecteds()
   if len( ::acInfos ) > 0
      for each cStr in ::acInfos
          oObj := ::xPaste( oWnd, cStr )
          oObj:aRect[1] += 10
          oObj:aRect[2] += 10
          oObj:aRect[3] += 10
          oObj:aRect[4] += 10
          aadd( ::oWnd:aSelecteds, oObj )
          oObj:StorePos()
          oObj:lSelected := .t.
      next
      ::oWnd:oSelected := ::oWnd:aSelecteds[1]
   endif
endif

oWnd:Refresh()

return 0




*********************************************************************************
  METHOD xPaste( oWnd, cInfo ) CLASS TShape
*********************************************************************************
local nPos := 4
local nLenName
local cClassName
local oObj

DEFAULT cInfo := ::cInfo


   if empty( ::cInfo ) .and. len( ::acInfos ) == 0
      MsgInfo( "No hay datos" )
      return nil
   endif

   nLenName := bin2I( substr( cInfo, nPos, 2 ) )
   cClassName := substr( cInfo, 6, nLenName )
   oObj       := &( cClassName + "()" )
   oObj:New()

   oObj:oWnd := oWnd
   oWnd:AddShape( oObj )

   if lower(cClassName) == "tdsgnmenubar"
      oWnd:oForm:oMenu := oObj
   endif

   if lower(cClassName) == "tdsgnbar"
      oWnd:oForm:oBar := oObj
   endif

   nPos := 1
   cInfo := substr( cInfo, 6 + nLenName )
   oObj:Load( SubStr( cInfo, nPos ) )


return oObj


**********************************************************************************
  METHOD ShapeOver( nRow, nCol ) CLASS TShape
**********************************************************************************
local oShape

if ::lContainer
   for each oShape in ::aShapes
       if oShape:ShapeOver( nRow, nCol ) != nil
          return oShape
       endif
   next
else
   if PtInRect( nRow, nCol, {::aRect[1]-5,::aRect[2]-5,::aRect[3]+5,::aRect[4]+5} )
      return self
   endif
endif

return nil

**********************************************************************************
  METHOD GetContainer( aRect ) CLASS TShape
**********************************************************************************
local oContainer

   if ::lContainer
      if EsMayor( ::aRect, aRect )
         return self
      endif
   endif

return oContainer

**********************************************************************************
  METHOD Inspect( cDataName, oInspector ) CLASS TShape
**********************************************************************************

local o := self
local uVal
local hDC, aFonts
local aPoint := {0,0}

   do case
      case left( cDataName, 4 ) == "nClr"

           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif
           //return { | cDataName | oSend( self, "_" + cDataName, xSelColor( aPoint[1], aPoint[2]-155, OSend( Self, cDataName )))} //,o:Refresh(),oInspector:Refresh() }
           return { | cDataName | o:GetColor( cDataName ) }

      case cDataName == "cFaceName"

           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif
           return { | cDataName | oSend( self, "_" + cDataName, xSelFont( aPoint[1], aPoint[2]-155, OSend( Self, cDataName ))),o:Refresh(),oInspector:Refresh() }

      case cDataName == "oFont"

           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif
           return { | cDataName | ::ChooseFont( ) }




   endcase

return nil

**********************************************************************************
  METHOD SetProp( cDataName, uVal ) CLASS TShape
**********************************************************************************

     OSend( Self, "_" + cDataName, uVal )
     ::Refresh()

return nil

**********************************************************************************
  METHOD GetColor( cDataName ) CLASS TShape
**********************************************************************************

local nColor := oSend( self, cDataName )

   nColor := ChooseColor( nColor )

   oSend( self, "_" + cDataName, nColor )

   ::Refresh()

return nil

***************************************************************************************************
      METHOD cGetFileName() CLASS TShape
***************************************************************************************************
local cFiltro := "Imágenes (*.bmp *.gif *.jpg *.ico *.cur ) | *.bmp;*.gif;*.jpg;*.ico;*.cur; |"
local cFiles := cGetFile( cFiltro, "Selecciona imagen" )

::cFileName := cFiles

::oWnd:Refresh()

return ::cFileName


***************************************************************************************************
   METHOD GenRc( ) CLASS TShape
***************************************************************************************************
local cClass := ::ClassName()
local cRet := ""
local oControl
local n, nLen


do case
   case cClass == "TWNDDSGN"
        cRet += '#include <windows.h>' + CRLF + CRLF
        cRet += ::cStrID() + " DIALOG " +;
                ::cStrLeft() + ", "    +;
                ::cStrTop() + ", "     +;
                ::cStrWidth() + ", "   +;
                ::cStrHeight() + CRLF


        if ::lCaption
           cRet += "CAPTION " + '"' + alltrim( ::cCaption )  + '"' + CRLF
           cRet += "STYLE DS_MODALFRAME | WS_POPUP | WS_VISIBLE | WS_CAPTION | WS_SYSMENU"  + CRLF
        endif

        cRet += "FONT 8"  +", " + ;
             '"' + alltrim(::cFaceName) + '"' + CRLF
        if ::oMenu != nil
           cRet += "MENU " + ::oMenu:cStrId() + CRLF
        endif
        /*
        if ::lBold
           cRet += ", 700"
        else
           cRet += ", 0"
        endif
        if ::lItalic
           cRet += ", 1"
        else
           cRet += ", 0"
        endif
        cRet += ", 1" + CRLF
        */
        cRet += "BEGIN" + CRLF
        nLen := len( ::oWnd:aShapes )
        for n := 1 to nLen - 1
            oControl := ::oWnd:aShapes[n]
            if oControl:ClassName() != "TDSGNMENUBAR"
               cRet += oControl:GenRc()
            endif
        next
        cRet += "END" + CRLF + CRLF

        if ::oMenu != nil
           cRet += ::oMenu:cStrID() + " MENU" + CRLF
           cRet += "{" + CRLF
                for n := 1 to len( ::oMenu:aShapes )
                    cRet += ::oMenu:aShapes[n]:GenRc( 1 )
                next
           cRet += "}" + CRLF
        endif

   case cClass == "TDSGNBTN"

        do case
           case ::nTipo == BOTON

                cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                        ::cStrID() + ", " + '"Button", ' +;
                        "WS_TABSTOP , "                  +;
                        ::cStrLeft() + ", "              +;
                        ::cStrTop() + ", "               +;
                        ::cStrWidth() + ", "             +;
                        ::cStrHeight() + CRLF

           case ::nTipo == CHECK

                cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                        ::cStrID() + ", " + '"Button", ' +;
                        "BS_CHECKBOX | WS_TABSTOP , " +;
                        ::cStrLeft() + ", "           +;
                        ::cStrTop() + ", "            +;
                        ::cStrWidth() + ", "          +;
                        ::cStrHeight() + CRLF

           case ::nTipo == RADIODSGN

                cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                        ::cStrID() + ", " + '"Button", ' +;
                        "BS_RADIOBUTTON , " +;
                        ::cStrLeft() + ", "  +;
                        ::cStrTop() + ", "   +;
                        ::cStrWidth() + ", " +;
                        ::cStrHeight() + CRLF
        endcase

   case cClass == "TDSGNSAY"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", " + ;
                '"Static", ' + "WS_GROUP , " +;
                ::cStrLeft() + ", "          +;
                ::cStrTop() + ", "           +;
                ::cStrWidth() + ", "         +;
                ::cStrHeight() + CRLF

   case cClass == "TDSGNEDIT"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", " + ;
                '"Edit", ES_AUTOHSCROLL|WS_BORDER|WS_TABSTOP , ' +;
                ::cStrLeft() + ", "    +;
                ::cStrTop() + ", "     +;
                ::cStrWidth() + ", "   +;
                ::cStrHeight() + CRLF

   case cClass == "TDSGNGRP"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", " + ;
                '"Button", BS_GROUPBOX , ' +;
                ::cStrLeft() + ", "        +;
                ::cStrTop() + ", "         +;
                ::cStrWidth() + ", "       +;
                ::cStrHeight() + CRLF

   case cClass == "TDSGNCBX"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", "
                do case
                   case ::nTipo == "DropDownList"
                        cRet += '"ComboBox", WS_BORDER|CBS_DROPDOWNLIST|WS_VSCROLL|WS_TABSTOP , '
                   case ::nTipo == "Simple"
                        cRet += '"ComboBox", WS_BORDER|CBS_SIMPLE|WS_VSCROLL|WS_TABSTOP , '
                   otherwise
                        cRet += '"ComboBox", WS_BORDER|CBS_DROPDOWN|WS_VSCROLL|WS_TABSTOP , '
                endcase

                cRet += ::cStrLeft()  + ", "  +;
                        ::cStrTop()   + ", "  +;
                        ::cStrWidth() + ", "  +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNLBX"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", "

                cRet += '"ListBox", LBS_NOTIFY|WS_VSCROLL|WS_BORDER|WS_TABSTOP , '

                cRet += ::cStrLeft() + ", "   +;
                        ::cStrTop() + ", "    +;
                        ::cStrWidth() + ", "  +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNSCROLL"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", "

                cRet += '"ScrollBar", ' + if( ::lVertical,"0x00000001","0x00000000") + ", "

                cRet += ::cStrLeft() + ", "    +;
                        ::cStrTop() + ", "     +;
                        ::cStrWidth() + ", "   +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNBTNBMP"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", "

                cRet += '"TBTNBMP", ' + "0 | WS_CHILD | WS_VISIBLE | WS_TABSTOP, "

                cRet += ::cStrLeft() + ", "    +;
                        ::cStrTop() + ", "     +;
                        ::cStrWidth() + ", "   +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNBROWSE"

        cRet += "  CONTROL " + '"' + alltrim( ::cCaption ) + '", ' +;
                ::cStrID() + ", "

                cRet += '"TWBROWSE", ' + "0 | WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL | WS_VSCROLL, "

                cRet += ::cStrLeft() + ", "    +;
                        ::cStrTop() + ", "     +;
                        ::cStrWidth() + ", "   +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNIMG"

        cRet += "  CONTROL " + '"", ' +;
                ::cStrID() + ", "

                cRet += '"TBITMAP", ' + "0 | WS_CHILD | WS_VISIBLE, "

                cRet += ::cStrLeft() + ", "    +;
                        ::cStrTop() + ", "     +;
                        ::cStrWidth() + ", "   +;
                        ::cStrHeight() + CRLF

   case cClass == "TDSGNUSER"

        cRet += "  CONTROL " + '"' + alltrim(::cCaption) + '", ' +;
                ::cStrID() + ", "

                cRet += '"' + alltrim( ::cClassName )+ '", ' +  alltrim( ::cStyle )+  ", "

                cRet += ::cStrLeft() + ", "    +;
                        ::cStrTop() + ", "     +;
                        ::cStrWidth() + ", "   +;
                        ::cStrHeight() + CRLF


endcase

return cRet

***************************************************************************************************
   METHOD GenRCManifest( ) CLASS TShape
***************************************************************************************************
local c := ""

c += '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
c += '<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">'
c += '<assemblyIdentity'
c += '    version="1.0.0.0"'
c += '    processorArchitecture="X86"'
c += '    name="FiveTech Software.FiveWin.32bits"'
c += '    type="win32"'
c += '/>'
c += '<description>Your application description here.</description>'
c += '<dependency>'
c += '    <dependentAssembly>'
c += '         <assemblyIdentity'
c += '          type="win32"'
c += '          name="Microsoft.Windows.Common-Controls"'
c += '          version="6.0.0.0"'
c += '          processorArchitecture="X86"'
c += '          publicKeyToken="6595b64144ccf1df"'
c += '          language="*"'
c += '         />'
c += '        </dependentAssembly>'
c += '</dependency>'
c += '</assembly>'

return c

***************************************************************************************************
   METHOD GenPrg( lDialog ) CLASS TShape
***************************************************************************************************
local cClass := ::ClassName()
local cRet := ""
local oControl
local n, nLen
local cObject
local cVar
local caItems
local o := self
local cFunciones := ""
// ordenamos los controles de izda a derecha y de arriba a abajo


DEFAULT lDialog := .t.


do case
   case cClass == "TWNDDSGN"

        aVarNames := {}

        cHeader := '#include "fivewin.ch"' + CRLF + CRLF + CRLF + CRLF

        cHeader += 'static oWnd' + CRLF
        cHeader += 'function main()' + CRLF


        cWindow := " DEFINE DIALOG oWnd FROM " + ::cStrTop(.f.) + ", " + ::cStrLeft(.f.) + " TO 0,0  SIZE " + ::cStrWidth(.f.) + ", " + ::cStrHeight(.f.) + " ;" + CRLF
        cWindow += "        TITLE " + '"' + alltrim( ::cCaption )  + '"' + CRLF + CRLF

        nLen := len( ::oWnd:aShapes )
        for n := 1 to nLen - 1

            oControl := ::oWnd:aShapes[n]

            cRet += oControl:GenPRG( lDialog, "oWnd", @cHeader, @cFunciones ) + CRLF

        next

        cRet += CRLF

        cRet += "oWnd:lHelpIcon := .f." + CRLF + CRLF
        cRet += "ACTIVATE DIALOG oWnd CENTERED" + CRLF + CRLF
        cRet += "return nil" + CRLF + CRLF

        cRet := cHeader + CRLF + CRLF + cWindow + CRLF + cRet

        if ::oMenu != nil
           cWindow += " ;" + CRLF
           cWindow += "        MENU BuildMenu() "

           cRet += "function BuildMenu()" + CRLF
           cRet += "local oMenu" + CRLF + CRLF
                for n := 1 to len( ::oMenu:aShapes )
                    cRet += ::oMenu:aShapes[n]:GenPrg( 1 )
                next
           cRet += "return oMenu" + CRLF
        endif

        if !empty( cFunciones )
           cRet += CRLF
           cRet += cFunciones
        endif


/*
   case cClass == "TDSGNBTN"

        do case
           case ::nTipo == BOTON
                cObject := ::GetObjName()
                cHeader += "local " + cObject + CRLF

                cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " BUTTON " + cObject + ' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                        "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                        '                 ACTION MsgInfo( "action") ;' + CRLF +;
                        "                 OF oWnd " + CRLF

           case ::nTipo == CHECK

                cObject := ::GetObjName()
                cVar    := ::cGetVarName( "lCheck" )
                cHeader += "local " + cObject + CRLF
                cHeader += "local " + cVar + " := .f." + CRLF
                cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " CHECKBOX " + cObject + " VAR " + cVar +' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                        "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                        "         OF oWnd " + CRLF

           case ::nTipo == RADIODSGN

                cObject := ::GetObjName()
                cVar    := ::cGetVarName( "nRadio" )
                cHeader += "local " + cObject + CRLF
                cHeader += "local " + cVar + " := 1" + CRLF

                cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " RADIOITEM " + cObject + ' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                        "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                        "         OF oWnd " + CRLF


        endcase

   case cClass == "TDSGNSAY"

        cObject := ::GetObjName()
        cHeader += "local " + cObject + CRLF

        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " SAY " + cObject + ' PROMPT "' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                "         OF oWnd " + CRLF

   case cClass == "TDSGNEDIT"

        cObject := ::GetObjName()
        cVar    := ::cGetVarName( "cGet" )
        cHeader += "local " + cObject + CRLF
        cHeader += "local " + cVar + ' := "' + alltrim( ::cCaption ) + '"' + CRLF

        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " GET "  + cObject +  ' VAR ' + cVar + " ;" + CRLF +;
             "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
             "         OF oWnd " + CRLF

   case cClass == "TDSGNGRP"

        cObject := ::GetObjName()
        cVar    := ::cGetVarName( "cGet" )
        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " GROUPBOX " + cObject + " TO " + ::cStrBottom(lDialog) + ", " + ::cStrRight(lDialog) + " ;" + CRLF +;
                '         PROMPT"' + alltrim( ::cCaption ) + '" ;' + CRLF +;
                "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                "         OF oWnd " + CRLF


   case cClass == "TDSGNCBX"

        cObject := ::GetObjName()
        cVar    := ::cGetVarName( "cCombo" )
        caItems := ::cGetVarName( "aCbxItems" )
        cHeader += "local " + cObject + CRLF
        cHeader += "local " + cVar + ' := "' + alltrim( ::cCaption ) + '"' + CRLF
        cHeader += "local " + caItems + ' := {"' + alltrim( ::cCaption )  + '"}' + CRLF


        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " COMBOBOX " + cObject + ' VAR ' + cVar + " ITEMS " + caItems + " ;" + CRLF +;
             "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
             "         OF oWnd " + CRLF

   case cClass == "TDSGNLBX"

        cObject := ::GetObjName()
        cVar    := ::cGetVarName( "cLbx" )
        caItems := ::cGetVarName( "aLbxItems" )
        cHeader += "local " + cObject + CRLF
        cHeader += "local " + cVar + ' := "' + alltrim( ::cCaption ) + '"' + CRLF
        cHeader += "local " + caItems + ' := {"' + alltrim( ::cCaption )  + '"}' + CRLF


        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " LISTBOX " + cObject + ' VAR ' + cVar + " ITEMS " + caItems + " ;" + CRLF +;
             "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
             "         OF oWnd " + CRLF


   case cClass == "TDSGNSCROLL"




   case cClass == "TDSGNBTNBMP"

        cObject := ::GetObjName()
        cHeader += "local " + cObject + CRLF

        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " BUTTONBMP " + cObject + ' ;' + CRLF +;
                "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                '         ACTION MsgInfo( "action") ;' + CRLF +;
                "         BITMAP " + alltrim( ::cFileName) + " ; " +;
                if( !empty(::cCaption), CRLF + "         PROMPT " + '"' + alltrim( ::cCaption ) + '" ;' + CRLF,CRLF) + ;
                "         OF oWnd " + CRLF


   case cClass == "TDSGNBROWSE"


   case cClass == "TDSGNIMG"

        cObject := ::GetObjName()
        cHeader += "local " + cObject + CRLF

        cRet += "@ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " IMAGE " + cObject + ' FILENAME "' + alltrim( ::cFileName ) + '" ;' + CRLF +;
                "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
                "         OF oWnd NOBORDER" + CRLF



   case cClass == "TDSGNUSER"


   case cClass == "TDSGNFOLDER"

  */



endcase

return cRet


***************************************************************************************************
  METHOD cStrID() CLASS TShape
***************************************************************************************************
local cRet := allstr( ::nItemID )


return cRet

***************************************************************************************************
  METHOD cStrLeft( lRc ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nLeft := ::nLeft

DEFAULT lRc := .t.

if ::oParent != nil
   nLeft := nLeft - ::oParent:nLeft
endif


cRet := allstr( if(lRC,::XPix2Dlg(nLeft),nLeft) )

return cRet

***************************************************************************************************
  METHOD cStrTop( lRc ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nTop := ::nTop
DEFAULT lRc := .t.

if ::ClassName() != "TWNDDSGN"
   nTop -= ::oWnd:oForm:nHCaption
endif

if ::oParent != nil
   nTop := nTop - ::oParent:nTop
endif


cRet := allstr( if(lRC,::YPix2Dlg(nTop),nTop) )

return cRet

***************************************************************************************************
  METHOD cStrRight( lRc ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nRight := ::nRight
DEFAULT lRc := .t.

cRet := allstr( if(lRC,::YPix2Dlg(nRight),nRight) )

return cRet

***************************************************************************************************
  METHOD cStrBottom( lRc ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nBottom := ::nBottom
DEFAULT lRc := .t.


cRet := allstr( if(lRC,::YPix2Dlg(nBottom),nBottom) )

return cRet



***************************************************************************************************
  METHOD cStrWidth( lRc ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nWidth := ::nWidth()
DEFAULT lRc := .t.

if ::ClassName() == "TWNDDSGN"
   nWidth := ::oWnd:nWidth()
endif

cRet := allstr( if( lRC, ::XPix2Dlg(nWidth),nWidth) )

return cRet

***************************************************************************************************
  METHOD cStrHeight( lRC ) CLASS TShape
***************************************************************************************************
local cRet := ""
local nHeight := ::nHeight()

DEFAULT lRC := .t.

if ::ClassName() == "TWNDDSGN"
   nHeight := ::oWnd:nHeight()-::oWnd:oForm:nHCaption
endif

cRet := allstr( if( lRC, ::YPix2Dlg(nHeight),nHeight) )

return cRet


***************************************************************************************************
      METHOD YPix2Dlg( nPix ) CLASS TShape
***************************************************************************************************
//local oFont := ::oWnd:oForm:GetFontEx()
//local nUnits := XYDlgUnits(oFont:hFont)[1]
//nUnits := abs( ::oWnd:oForm:nHeightFont )
//oFont:End()
//nPix := MulDiv( nPix, 8, nUnits )
//local nUnits := GetDlgBaseUnits()
//nPix    = MulDiv(nPix, 8, nUnits)
//nPix    = nPix/nUnits



return (4 / nLoWord( GetDlgBaseUnits() )) * nPix

***************************************************************************************************
      METHOD XPix2Dlg( nPix ) CLASS TShape
***************************************************************************************************
//local oFont := ::oWnd:oForm:GetFontEx()
//local nUnits := XYDlgUnits(oFont:hFont)[2]
//nUnits := abs( oFont:nInpWidth )
//oFont:End()
//nPix := MulDiv( nPix, 4, nUnits )
//local nUnits := GetDlgBaseUnits()
//nPix   = MulDiv(nPix, 4, nUnits)
//nPix   = nPix / nUnits

return (8 / nHiWord( GetDlgBaseUnits() )) * nPix


function allstr( n ) ; return alltrim( str( n ) )


*****************************************************************************************************
  METHOD ResetSelecteds() CLASS TShape
*****************************************************************************************************
local oShape
local n, nLen

nLen := len( ::aShapes ) - 1 // el formulario

for n := 1 to nLen

    oShape := ::aShapes[n]

    if ::oWnd:oSelected != nil .and. ::oWnd:oSelected == oShape
    else
       oShape:lSelected := .f.
    endif

next

::oWnd:aSelecteds := {}
::oWnd:Refresh()

return nil



*****************************************************************************************************
   METHOD GetObjName() CLASS TShape
*****************************************************************************************************
local cName := "oUsr"
local nAt

do case
   case ::ClassName() == "TDSGNBAR"
        cName := "oBar"

   case ::ClassName() == "TDSGNBROWSE"
        cName := "oBrw"

   case ::ClassName() == "TDSGNBTN"

        do case
           case ::nTipo == BOTON
                cName := "oBtn"

           case ::nTipo == CHECK
                cName := "oChk"

           case ::nTipo == RADIODSGN
                if ::lGroup
                   cName := "oRadMenu"
                else
                   cName := "oRadio"
                endif
        endcase

   case ::ClassName() == "TDSGNBTNBMP"
        cName := "oBtnBmp"

   case ::ClassName() == "TDSGNCBX"
        cName := "oCbx"

   case ::ClassName() == "TDSGNEDIT"
        cName := "oGet"

   case ::ClassName() == "TDSGNFOLDER"
        cName := "oFolder"

   case ::ClassName() == "TDSGNGRP"
        cName := "oGroup"

   case ::ClassName() == "TDSGNIMG"
        if ::lIcon
           cName := "oIcon"
        else
           cName := "oImg"
        endif

   case ::ClassName() == "TDSGNLBX"
        cName := "oLbx"

   case ::ClassName() == "TDSGNLISTVIEW"
        cName := "oLview"

   case ::ClassName() == "TDSGNMENUBAR"
        cName := "oMenu"

   case ::ClassName() == "TDSGNPANEL"
        cName := "oPanel"

   case ::ClassName() == "TDSGNPRGBAR"
        cName := "oMtr"

   case ::ClassName() == "TDSGNSAY"
        cName := "oSay"

   case ::ClassName() == "TDSGNSCROLL"
        if ::lVertical
           cName := "oVScroll"
        else
           cName := "oHScroll"
        endif

   case ::ClassName() == "TDSGNSLIDER"
        cName := "oSlider"

   case ::ClassName() == "TDSGNTREEVIEW"
        cName := "oTree"

   case ::ClassName() == "TDSGNUSER"
        cName := "oUser"

endcase

if empty( ::cObjName )

   if !empty( aVarNames ) .and. ( nAt := AScan( aVarNames, { | a | Upper( cName ) == Upper( a[1] ) } ) ) != 0
      aVarNames[nAt,2] := aVarNames[nAt,2] + 1
   else
      aadd( aVarNames, {cName, 1} )
      nAt := len( aVarNames )
   endif

   ::cObjName := cName + alltrim(str(aVarNames[nAt,2] ))

endif

::cObjName := strtran( ::cObjName, " ", "")


return ::cObjName


**********************************************************************************
  METHOD GetObjNames() CLASS TShape
**********************************************************************************
local n
local aCtrls := {""}

  for n := 1 to len( ::oWnd:aShapes ) -1
      aadd( aCtrls, ::oWnd:aShapes[n]:GetObjName() )
  next

return  aCtrls

**********************************************************************************
  METHOD cGetVarName( cFrom ) CLASS TShape
**********************************************************************************
local n
local nLen := len( ::aVarNames )
local nCount := 0
local cName

  for n := 1 to nLen
      if substr(::aVarNames[n],1,len(cFrom)) == cFrom
         nCount ++
      endif
  next
  nCount++

  cName := cFrom+alltrim(str(nCount))
  aadd( ::aVarNames, cName )

return cName




**********************************************************************************
  METHOD GetObjFromName( cName ) CLASS TShape
**********************************************************************************
local n, c


for n := 1 to len( ::oWnd:aShapes )
    c := ::oWnd:aShapes[n]:GetObjName()
    if c == cName
       return ::oWnd:aShapes[n]
    endif
next

return nil



**********************************************************************************
  METHOD ChooseFont() CLASS TShape
**********************************************************************************

local oFont
/*
cFaceName
nWidthFont
nHeightFont
lBold
lItalic
lUnderline
lStrikeOut
*/

oFont := TFont():New( ::cFaceName,;
                      ::nWidthFont,;
                      ::nHeightFont,;
                      .f.,;
                      ::lBold,;
                      0, 0, 0,;
                      ::lItalic,;
                      ::lUnderline,;
                      ::lStrikeOut )

oFont := oFont:Choose( @::nClrPane )

::cFaceName   := oFont:cFaceName
::nWidthFont  := oFont:nWidth
::nHeightFont := oFont:nHeight
::lBold       := oFont:lBold
::lItalic     := oFont:lItalic
::lUnderline  := oFont:lUnderline
::lStrikeOut  := oFont:lStrikeOut

::oWnd:Refresh()

return nil


//**************************************************************************************************
//  METHOD GetFontEx() CLASS TShape
//**************************************************************************************************
//
//local cFaceName
//local oFontPPC
//local nHeight
//local lBold
//local lItalic
//local lUnderline
//local lStrikeOut
//
//
//if ::oWnd:oForm != nil
//
//   if empty( ::cFaceName )
//      cFaceName := ::oWnd:oForm:cFaceName
//   else
//      cFaceName := ::cFaceName
//   endif
//
//   if ::nHeightFont == 0
//      nHeight := ::oWnd:oForm:nHeightFont
//   else
//      nHeight := ::nHeightFont
//   endif
//
//   if ::lBold == nil
//      lBold := ::oWnd:oForm:lBold
//   else
//      lBold := ::lBold
//   endif
//
//endif
//
////DEFAULT cFaceName  := "Segoe UI"
////DEFAULT nHeight    := -12
//DEFAULT lBold      := .f.
//DEFAULT lItalic    := .f.
//DEFAULT lUnderline := .f.
//DEFAULT lStrikeOut := .f.
//
//if cFaceName == "Ms Shell Dlg"
//   cFaceName := "Ms Sans Serif"
//endif
//
//cFaceName := alltrim( cFaceName )
//
//
//nHeight := -1 * abs(::nHeightFont)
//
//oFontPPC := TFont():New( cFaceName, 0, nHeight , .f.,lBold,,,,lItalic,lUnderline,lStrikeOut )
//
//
//
//return oFontPPC

**************************************************************************************************
  METHOD GetFontEx() CLASS TShape
**************************************************************************************************

local cFaceName := ::cFaceName
local oFontPPC
//local hDC := ::oWnd:GetDC()
local nHeight := ::nHeightFont

DEFAULT nHeight := GetDefaultFontHeight()

//if cFaceName == "Ms Shell Dlg"
//   cFaceName := "Ms Sans Serif"
//endif

cFaceName := ::cFaceName //GetDefaultFontName() //alltrim( cFaceName )

//nHeight := -MulDiv(abs(::nHeightFont), GetDeviceCaps(hDC, LOGPIXELSY), 72)

nHeight := -1 * abs(nHeight)

oFontPPC := TFont():New( cFaceName, 0, nHeight , .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )

//::oWnd:ReleaseDC()

return oFontPPC


#pragma BEGINDUMP

#include "windows.h"
#include <stdio.h>
#include <hbapi.h>

HB_FUNC( FREOPEN_STDERR )
{
   hb_retnl( ( HB_LONG ) freopen( hb_parc( 1 ), hb_parc( 2 ), stderr ) );
}

HB_FUNC( GETDEFAULTFONTNAME )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT ) , sizeof( LOGFONT ), &lf );
   hb_retc( lf.lfFaceName );
}


#pragma ENDDUMP
