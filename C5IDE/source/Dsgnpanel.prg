#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#define SRCCOPY  13369376


CLASS TDsgnPanel FROM TShape

      DATA aProperties

      DATA lActive
      DATA aPrompts
      DATA aSizes
      DATA nHTab

      METHOD New          ( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint        ( hDC )
      METHOD ShapeOver    ( nRow, nCol )
      METHOD IntersectRect( aRect )
      METHOD AddPage      ( )
      METHOD AddShape     ( oShape, nPage )
      METHOD StorePos     ( )
      METHOD DeleteChild  ( o )
      METHOD GetContainer( aRect )
      METHOD oMainPage     ()     INLINE ::aPages[::nOption]
      METHOD SetOption( nOption )
      METHOD CheckSelecteds( aRect )
      METHOD SetSize( nWidth, nHeight, lUndo )
      METHOD Inspect( cDataName, oInspector )
      METHOD GetObjNames()
      METHOD GetObjFromName( cName )
      METHOD cSetFocus( coCtrlName )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnPanel
************************************************************************************************
   local o := self

   if nTop != nil .and. ( nBottom-nTop < 10 .or. nRight-nLeft < 10 )
      nBottom := nTop + 100
      nRight  := nLeft + 160
   endif

   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::aDotsActives     := {1,1,1,1,1,1,1,1}
   ::aPages        := {}
   ::nOption       := 1
   ::lActive       := .t.
   ::lContainer    := .t.
   ::nClrPane      := nil
   ::oTop          := nil
   ::oLeft         := nil
   ::oBottom       := nil
   ::oRight        := nil
   ::oClient       := nil
  ::cObjName         := ::GetObjName()

  ::aProperties :=  { "aDotsActives"   ,;
                      "aRect"          ,;
                      "aPages"         ,;
                      "lActive"        ,;
                      "lCanSize"       ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lVisible"       ,;
                      "nClrPane"       ,;
                      "oBottom"        ,;
                      "oClient"        ,;
                      "oLeft"          ,;
                      "oRight"         ,;
                      "oTop"           ,;
                      "nOption"        ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }
   ::AddPage()

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self



************************************************************************************************
  METHOD AddPage() CLASS TDsgnPanel
************************************************************************************************
local oPage

oPage := TDsgnPage():New()
oPage:oWnd := ::oWnd

aadd( ::aPages, oPage )

::oWnd:Refresh()

return nil

************************************************************************************************
  METHOD AddShape( oShape, nPage ) CLASS TDsgnPanel
************************************************************************************************

if nPage == nil; nPage := ::nOption; endif

::aPages[nPage]:AddShape( oShape )

return nil





*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnPanel
*************************************************************************************************
   local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
   local color, iMode
   local grisoscuro := RGB( 113,111,100)
   local gris       := RGB( 157,157,161)
   local grisclaro  := RGB( 241,239,226)
   local nTop    := rc[1]
   local nLeft   := rc[2]
   local nBottom := rc[3]
   local nRight  := rc[4]
   local hWhitePen, hGrisOscuro, hGris, hGrisClaro
   local hOldPen, hOldFont
   local n, n2, nLen, nLen2
   local nSizeItem := 0
   local nMode
   local hTheme
   local lThemes := lTemas() .and. !::oWnd:lPocketPc  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
   local aOptions
   local hDCMem, hOldBmp, hBmpMem
   local aRect := ::GetClientRect()
   local oPage
   local nClrPane := ::nClrPane
   local nColor

   ::SetSize( rc[4]-rc[2],rc[3]-rc[1],.f.)

   if nClrPane == nil
     if ::oWnd:lPocketPc()
        nClrPane := CLR_WHITE
     else
        nClrPane := GetSysColor(COLOR_BTNFACE)
     endif
   endif

   hDCMem      := CreateCompatibleDC( ::oWnd:hDC )
   hBmpMem     := CreateCompatibleBitmap( ::oWnd:hDC, aRect[4], aRect[3] )
   hOldBmp     := SelectObject( hDCMem, hBmpMem )

   rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

   FillSolidRect( hDCMem, rc, nClrPane )

   for each oPage in ::aPages
       oPage:aRect := rc
       oPage:oWnd := ::oWnd
       oPage:Paint( hDCMem )
   next

   rc[3]--;rc[4]--

   nColor := SetBkColor( hDCMem, RGB( 224, 223, 227 ) )
   Box( hDCMem, rc, RGB( 205, 203, 211 ), 2 )
   SetBkColor( hDCMem, nColor )

   StretchBlt( hDC,    aRect[2], aRect[1], aRect[4]-aRect[2], aRect[3]-aRect[1],;
               hDCMem, aRect[2], aRect[1], aRect[4]-aRect[2], aRect[3]-aRect[1], SRCCOPY )

   SelectObject( hDCMem, hOldBmp )
   DeleteObject( hBmpMem )
   DeleteDC( hDCMem )

   DeleteObject( hGris )
   DeleteObject( hGrisClaro )
   DeleteObject( hGrisOscuro )


   if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
      ::DotsSelect( hDC )
   endif

return nil


***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TDsgnPanel
***************************************************************************************************
local lIntersect := .f.
local aClientRect := ::GetClientRect()

if EsMayor( aClientRect, aRect )
   return .f.
endif

if IntersectRect( aRect, ::aRect )
   lIntersect := .t.
endif

return lInterSect

*************************************************************************************************
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnPanel
*************************************************************************************************
 local oShape
 local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

 if PtInRect( nRow, nCol, {rc[1]-5,rc[2]-5,rc[3]+5,rc[4]+5} )
    rc := {::aRect[1]+5,::aRect[2]+5,::aRect[3]-5,::aRect[4]-5}
    if !PtInRect( nRow, nCol, rc )
       return self
    else
       return ::oMainPage:ShapeOver( nRow, nCol )
    endif
 endif

 return nil


***************************************************************************************************
   METHOD SetOption( nOption ) CLASS TDsgnPanel
***************************************************************************************************
local nOldOption := ::nOption
local oShape

if nOption <= 0 .or. nOption > len( ::aPages )
   return nil
endif

::nOption := nOption
::oMainPage:lVisible := .t.
if ::nOption != nOldOption
   ::aPages[nOldOption]:lVisible := .f.
endif

/*
for each oShape in ::aPages[nOption]
    oShape:Show()
next


for each oShape in ::aPages[nOldOption]
    oShape:Hide()
next
*/

return nil


***************************************************************************************************
      METHOD StorePos()  CLASS TDsgnPanel
***************************************************************************************************
local oShape, oPage

super:StorePos()

for each oPage in ::aPages
    for each oShape in oPage:aShapes
        oShape:StorePos()
    next
next

return nil


***************************************************************************************************
  METHOD DeleteChild( o ) CLASS TDsgnPanel
***************************************************************************************************
local nPages, nShapes, n, n2
local oPage
//nPages := len( ::aPages )
for each oPage in ::aPages
    nShapes := len( oPage:aShapes )
    for n := 1 to nShapes
        if oPage:aShapes[n] == o
           adel( oPage:aShapes, n )
           asize( oPage:aShapes, len( oPage:aShapes )-1 )
           return 0
        endif
    next
next


return nil

**********************************************************************************
  METHOD GetContainer( aRect ) CLASS TDsgnPanel
**********************************************************************************

return ::oMainPage:GetContainer( aRect )


*****************************************************************************************************
  METHOD CheckSelecteds( aRect ) CLASS TDsgnPanel
*****************************************************************************************************
local oShape
local lHay := .f.
local n, nLen

nLen := len( ::oMainPage:aShapes )  // el formulario

for n := 1 to nLen

    oShape := ::oMainPage:aShapes[n]

    if oShape:IntersectRect( aRect )
       if !oShape:lCanMove
          loop
       endif
       lHay := .t.
       aadd( ::oWnd:aSelecteds, oShape )
       oShape:StorePos()
       oShape:lSelected := .t.
       //OutPutDebugString( "intersect" )
    else
       oShape:lSelected := .f.
    endif

next

if !lHay
   ::oWnd:aSelecteds := {}
else
   ::oWnd:Refresh()
endif

return lHay


*************************************************************************************************
   METHOD SetSize( nWidth, nHeight, lUndo ) CLASS TDsgnPanel
*************************************************************************************************
local lChange := .t.
local aClient
local nT, nL, nH, nW
local oTop, oLeft, oBottom, oRight, oClient

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

//::StorePos()

aClient := ::GetClientRect()


if ::oTop != nil
   oTop := ::GetObjFromName(::oTop)
   if oTop != nil
      nT := aClient[1]
      nL := aClient[2]
      nW := aClient[4]-aClient[2]
      nH := oTop:nHeight
      oTop:aRect := {nT, nL, nT+nH, nL+nW}
      aClient[1] += nH
   endif
endif

if ::oBottom != nil
   oBottom := ::GetObjFromName(::oBottom)
   if oBottom != nil
      nT := aClient[3]-oBottom:nHeight
      nL := aClient[2]
      nW := aClient[4]
      nH := oBottom:nHeight
      aClient[3] -= nH
      oBottom:aRect := {nT, nL, nT+nH, nL+nW}
   endif
endif

if ::oLeft  != nil
   oLeft := ::GetObjFromName(::oLeft)
   if oLeft != nil
      nT := aClient[1]
      nL := aClient[2]
      nW := oLeft:nWidth
      nH := aClient[3]-aClient[1]
      aClient[2] += nW
      oLeft:aRect := {nT, nL, nT+nH, nL+nW}
   endif
endif

if ::oRight  != nil
   oRight := ::GetObjFromName(::oRight)
   if oRight != nil
      nT := aClient[1]
      nL := aClient[4]- oRight:nWidth
      nW := oRight:nWidth
      nH := aClient[3]-aClient[1]
      aClient[4] -= nW
      oRight:aRect := {nT, nL, nT+nH, nL+nW}
   endif
endif

if ::oClient != nil
   oClient := ::GetObjFromName(::oClient)
   if oClient != nil
      nT := aClient[1]
      nL := aClient[2]
      nW := aClient[4]-aClient[2]
      nH := aClient[3]-aClient[1]
      oClient:aRect := {nT, nL, nT+nH, nL+nW}
   endif
endif

if lUndo
   ::oWnd:Refresh()
endif


**********************************************************************************
  METHOD Inspect( cDataName, oInspector ) CLASS TDsgnPanel
**********************************************************************************

local o := self
local n
local uVal
local hDC, aFonts
local aPoint := {0,0}
local aCtrls := {}

   do case
      case cDataName == "oTop" .or. cDataName == "oLeft" .or. cDataName == "oBottom" .or. cDataName == "oRight" .or. cDataName == "oClient"
           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif
           return {|cDataName| oSend( self, ;
                               "_" + cDataName, ;
                               xSelControl( aPoint[1], aPoint[2]-155, "", o:GetObjNames(), o ) ),;
                               o:SetSize(),;
                               o:Refresh(),oInspector:Refresh() }

   endcase

return super:Inspect( cDataName, oInspector )


**********************************************************************************
  METHOD GetObjNames() CLASS TDsgnPanel
**********************************************************************************
local n
local aCtrls := {""}

  for n := 1 to len( ::oMainPage:aShapes )
      aadd( aCtrls, ::oMainPage:aShapes[n]:GetObjName() )
  next

return  aCtrls


**********************************************************************************
  METHOD GetObjFromName( cName ) CLASS TDsgnPanel
**********************************************************************************
local n, c

for n := 1 to len( ::oMainPage:aShapes )
    c := ::oMainPage:aShapes[n]:GetObjName()
    if c == cName
       return ::oMainPage:aShapes[n]
    endif
next

return nil


**********************************************************************************
   METHOD cSetFocus( coCtrlName ) CLASS TDsgnPanel
**********************************************************************************
local n

  for n := 1 to len( ::oMainPage:aShapes ) -1
      if coCtrlName == ::oMainPage:aShapes[n]:GetObjName()
         ::oMainPage:aShapes[n]:SetFocus(.f.)
      endif
  next
  ::oWnd:Refresh()

return nil




****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************


CLASS TDsgnPagePanel FROM TShape

      DATA nSize
      DATA aCoords
      DATA lVisible

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD GetContainer( aRect )
      METHOD ShapeOver( nRow, nCol )
      METHOD AddShape( oShape )        INLINE aadd( ::aShapes, oShape )

ENDCLASS

************************************************************************************************
  METHOD New() CLASS TDsgnPagePanel
************************************************************************************************

   super:New()

   ::aCoords := {0,0,0,0}
   ::lCanSize := .f.
   ::lCanMove       := .f.
   ::lContainer     := .t.

   ::aProperties := { "aShapes"        ,;
                      "nSize"          ,;
                      "aCoords"        ,;
                      "lVisible"       ,;
                      "lCanMove"       ,;
                      "lCanSize" ,;
                      "aDotsActives"   ,;
                      "aRect"          ,;
                      "lEditable"      }

return self


************************************************************************************************
   METHOD Paint( hDC ) CLASS TDsgnPagePanel
************************************************************************************************
local oShape

if !::lVisible
   return 0
endif

for each oShape in ::aShapes
    oShape:oWnd := ::oWnd
    oShape:Paint( hDC )
next

return nil


************************************************************************************************
  METHOD GetContainer( aRect ) CLASS TDsgnPagePanel
************************************************************************************************

local oShape, oContainer

for each oShape in ::aShapes
    oContainer := oShape:GetContainer( aRect )
    if oContainer != nil
       return oContainer
    endif
next

if EsMayor( ::aRect, aRect )
   oContainer := self
endif


return oContainer

************************************************************************************************
  METHOD ShapeOver( nRow, nCol ) CLASS TDsgnPagePanel
************************************************************************************************
local oShape, oOver

for each oShape in ::aShapes
    oOver := oShape:ShapeOver( nRow, nCol )
    if oOver != nil
       return oOver
    endif
next

return nil



function outp( c )
return OutPutDebugString( cValToChar(c) )





return nil




