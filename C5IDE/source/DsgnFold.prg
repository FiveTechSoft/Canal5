#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#define SRCCOPY  13369376

//No se copia bien no copia los controles de las paginas
//No anida bien los folders, el tercer nivel no anida



CLASS TDsgnFolder FROM TShape

      DATA aProperties

      DATA lActive
      DATA aPrompts
      DATA aSizes
      DATA nHTab

      METHOD New          ( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint        ( hDC )
      METHOD ContextMenu  ( nRow, nCol )
      METHOD ShapeOver    ( nRow, nCol )
      METHOD IntersectRect( aRect )
      METHOD nMinWidth    ( nVal ) SETGET
      METHOD nAllSizes    ( )
      METHOD AddPage      ( )
      METHOD AddShape     ( oShape, nPage )
      METHOD SetOption    ( n )
      METHOD GetOption    ( nRow, nCol )
      METHOD KeyDown( nKey, nFlags )
      METHOD LButtonDown  ( nRow, nCol )
      METHOD GetClientRect( )    INLINE {::aRect[1]+::nHTab,::aRect[2],::aRect[3],::aRect[4]}
      METHOD StorePos     ( )
      METHOD DeleteChild  ( o )
      METHOD Edit     ( )
      METHOD GetContainer( aRect )
      METHOD oMainPage     ()     INLINE ::aPages[::nOption]
      METHOD CheckSelecteds( aRect )
      METHOD GenPrg()

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnFolder
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
   ::nHTab         := 20
   ::lActive       := .t.
   ::bContextMenu  := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
   ::bLClicked     := {|nRow,nCol| ::LButtonDown( nRow, nCol ) }
   ::lContainer    := .t.
   ::bKeyDown      := {|nKey,nFlags| o:KeyDown( nKey, nFlags ) }
  ::cObjName         := ::GetObjName()


  ::aProperties :=  { "nHTab"          ,;
                      "lActive"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lEditable"      ,;
                      "lVisible"       ,;
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
  METHOD nAllSizes() CLASS TDsgnFolder
************************************************************************************************
local oPage
local nTotal := 0

for each oPage in ::aPages
    nTotal += oPage:nSize
next

return nTotal


************************************************************************************************
  METHOD AddPage() CLASS TDsgnFolder
************************************************************************************************
local cItem := "Item " + alltrim( str( len( ::aPages )+1))
local oPage

oPage := TDsgnPage():New()
oPage:oWnd := ::oWnd

aadd( ::aPages, oPage )

::aRect[4] := max( ::aRect[4], ::aRect[2]+::nAllSizes+10)

::SetOption( len( ::aPages ) )

::oWnd:Refresh()

return nil

************************************************************************************************
  METHOD AddShape( oShape, nPage ) CLASS TDsgnFolder
************************************************************************************************

if nPage == nil; nPage := ::nOption; endif

::aPages[nPage]:AddShape( oShape )



return nil





*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnFolder
*************************************************************************************************
   local rc := {::aRect[1]+::nHTab,::aRect[2],::aRect[3],::aRect[4]}
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
   local lThemes := lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
   local aOptions
   local hDCMem, hOldBmp, hBmpMem
   local aRect := ::GetClientRect()
   local oPage

   ::nMinWidth     := ::aPages[1]:nSize + 20
   ::nMinHeight    := ::nHTab + 10

   hWhitePen   := GetStockObject( WHITE_PEN )
   hGrisClaro  := CreatePen( PS_SOLID, 1, grisclaro  )
   hGrisOscuro := CreatePen( PS_SOLID, 1, grisoscuro )
   hGris       := CreatePen( PS_SOLID, 1, gris       )

   hDCMem      := CreateCompatibleDC( ::oWnd:hDC )
   hBmpMem     := CreateCompatibleBitmap( ::oWnd:hDC, aRect[4], aRect[3] )
   hOldBmp     := SelectObject( hDCMem, hBmpMem )

   rc := {::aRect[1]+::nHTab,::aRect[2],::aRect[3],::aRect[4]}

   if lThemes

      hTheme := C5_OpenThemeData(::oWnd:hWnd, "TAB")
      C5_DrawThemeBackground( hTheme, hDCMem, TABP_PANE,, rc )

   else

      FillSolidRect( hDCMem, rc, ::oWnd:oForm:nClrPane )

   endif

   for each oPage in ::aPages
       oPage:aRect := rc
       oPage:oWnd := ::oWnd
       oPage:Paint( hDCMem )
   next

   StretchBlt( hDC,    aRect[2], aRect[1], aRect[4]-aRect[2], aRect[3]-aRect[1],;
               hDCMem, aRect[2], aRect[1], aRect[4]-aRect[2], aRect[3]-aRect[1], SRCCOPY )

   SelectObject( hDCMem, hOldBmp )
   DeleteObject( hBmpMem )
   DeleteDC( hDCMem )

   if !lThemes

      Box( hDC, rc, grisoscuro )
      rc[1]+=1; rc[2]+=1;rc[3]-=1; rc[4]-=1

      Box( hDC, rc, gris )
      rc := {::aRect[1]+::nHTab,::aRect[2],::aRect[3],::aRect[4]}

      hOldPen := SelectObject( hDC, hWhitePen )

      Moveto( hDC, nLeft, nBottom-1 )
      LineTo( hDC, nLeft, nTop      )
      LineTo( hDC, nRight-1, nTop   )

      SelectObject( hDC, hOldPen )
      hOldPen := SelectObject( hDC, hGrisClaro )

      Moveto( hDC, nLeft+1, nBottom-2 )
      Lineto( hDC, nLeft+1,  nTop +1 )
      Lineto( hDC, nRight-1, nTop +1 )

      SelectObject( hDC, hOldPen )

   endif

//   hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
   nLen := len( ::aPages )

   nLeft := ::aRect[2]
   for n := 1 to nLen

       nTop    := ::aRect[1]
       nLeft   += nSizeItem
       nBottom := nTop + ::nHTab

       if n != ::nOption
          nTop += 2
       endif

       nSizeItem := ::aPages[n]:nSize
       nRight  := nLeft + nSizeItem

       ::aPages[n]:aCoords := {nTop, nLeft, nBottom, nRight}

       if lThemes

          rc := { nTop, nLeft, nBottom, nRight }

          if n == ::nOption
             rc[3] += 1
             aOptions := { nTop, nLeft-if( n > 1,3,0), nBottom+1, nRight+if( n < nLen,3,0) }
             loop
          endif
          C5_DrawThemeBackground( hTheme, hDC, TABP_TABITEM,TIS_NORMAL, rc )

       else

          FillSolidRect( hDC, {nTop, nLeft, nBottom+if( n == ::nOption,3,0), nRight}, ::oWnd:oForm:nClrPane )

          hOldPen := SelectObject( hDC, hWhitePen )
          MoveTo( hDC, nLeft, nBottom + if( n == 1 .and. n == ::nOption, 2, 0)  )
          LineTo( hDC, nLeft, nTop+2  )
          Lineto( hDC, nLeft+2, nTop  )
          Lineto( hDC, nLeft+nSizeItem-2, nTop )
          SelectObject( hDC, hOldPen )

          hOldPen := SelectObject( hDC, hGrisClaro )
          MoveTo( hDC, nLeft+1, nBottom + if( n == 1 .and. n == ::nOption, 2, 0) )
          LineTo( hDC, nLeft+1, nTop+1   )
          Moveto( hDC, nLeft+2, nTop+1   )
          Lineto( hDC, nLeft+nSizeItem-3, nTop+1 )
          SelectObject( hDC, hOldPen )

          hOldPen := SelectObject( hDC, hGris )
          Moveto( hDC, nRight-2, nTop + 2     )
          Lineto( hDC, nRight-2, nBottom      )
          SelectObject( hDC, hOldPen )

          hOldPen := SelectObject( hDC, hGrisOscuro )
          Moveto( hDC, nRight-2, nTop + 1     )
          Lineto( hDC, nRight-1, nTop + 2     )
          Lineto( hDC, nRight-1, nBottom      )
          SelectObject( hDC, hOldPen )

       endif

       if lThemes
          C5_DrawThemeText( hTheme, hDC, TABP_TABITEM,TIS_NORMAL, ::aPages[n]:cCaption, nOr( DT_VCENTER, DT_CENTER, DT_SINGLELINE ),nil,{nTop, nLeft, nBottom, nRight} )
       else
          nMode := SetBkMode( hDC, TRANSPARENT )
          DrawText( hDC, ::aPages[n]:cCaption, {nTop, nLeft, nBottom, nRight}, nOr( DT_VCENTER, DT_CENTER, DT_SINGLELINE ) )
          SetBkMode( hDC, nMode )
       endif
   next

   if lThemes
      C5_DrawThemeBackground( hTheme, hDC, TABP_TABITEM,TIS_SELECTED, aOptions )
      C5_DrawThemeText( hTheme, hDC, TABP_TABITEM,TIS_SELECTED, ::oMainPage:cCaption, nOr( DT_VCENTER, DT_CENTER, DT_SINGLELINE ),nil, aOptions )
   endif

//   SelectObject( hDC, hOldFont )

   DeleteObject( hGris )
   DeleteObject( hGrisClaro )
   DeleteObject( hGrisOscuro )

   if hTheme != nil
      C5_CloseThemeData()
   endif

   if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
      ::DotsSelect( hDC )
   endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnFolder
***************************************************************************************************
local oMenu
local o := self

  MENUITEM "Añadir solapa" ACTION o:AddPage()
  SEPARATOR


return nil

***************************************************************************************************
  METHOD IntersectRect( aRect ) CLASS TDsgnFolder
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
      METHOD ShapeOver( nRow, nCol ) CLASS TDsgnFolder
*************************************************************************************************
 local oShape
 local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

 if PtInRect( nRow, nCol, {rc[1]-5,rc[2]-5,rc[3]+5,rc[4]+5} )
    rc := {::aRect[1]+::nHTab,::aRect[2]+5,::aRect[3]-5,::aRect[4]-5}
    if !PtInRect( nRow, nCol, rc )
       return self
    else
       return ::oMainPage:ShapeOver( nRow, nCol )
    endif
 endif

 return nil

***************************************************************************************************
  METHOD nMinWidth( nVal ) CLASS TDsgnFolder
***************************************************************************************************

if pcount() > 0
   ::xMinWidth := nVal
endif

return max( ::xMinWidth, ::nAllSizes()+10 )


***************************************************************************************************
   METHOD SetOption( nOption ) CLASS TDsgnFolder
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
  METHOD GetOption( nRow, nCol ) CLASS TDsgnFolder
***************************************************************************************************
local n, nLen
local nSizes := ::nLeft
local nOption := 0

nLen := len( ::aPages )

for n := 1 to nLen
    nSizes += ::aPages[n]:nSize
    if nCol < nSizes .and. nRow < ::nTop + ::nHTab
       nOption := n
       exit
    endif
next

return nOption


***************************************************************************************************
  METHOD LButtonDown( nRow, nCol ) CLASS TDsgnFolder
***************************************************************************************************
local nOption := ::GetOption( nRow, nCol )

if nOption != 0 .and. nOption != ::nOption
   ::SetOption( nOption )
   ::oWnd:Refresh()
   return .t.
endif

return .f.


***************************************************************************************************
      METHOD StorePos()  CLASS TDsgnFolder
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
  METHOD DeleteChild( o ) CLASS TDsgnFolder
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

***************************************************************************************************
   METHOD Edit() CLASS TDsgnFolder
***************************************************************************************************
local oFont
local bValid := {||.t.}
local oShape := self
local uVar
local nTop, nLeft, nWidth, nHeight

uVar := padr(::oMainPage:cCaption, 100)

nTop    := ::oMainPage:aCoords[1]+4
nLeft   := ::oMainPage:aCoords[2]+6
nWidth  := ::oMainPage:aCoords[4]-::oMainPage:aCoords[2]-8
nHeight := ::oMainPage:aCoords[3]-::oMainPage:aCoords[1]-1

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

if oShape:lEditable

   ::oWnd:oGet := TGet():New(nTop,nLeft,{ | u | If( PCount()==0, uVar, uVar:= u ) },oShape:oWnd,nWidth,nHeight,,,0,16777215,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   //::oGet:oGet:Picture = cPicture

   ::oWnd:nLastKey := 0
   ::oWnd:oGet:SetFocus()

   if Upper( ::oWnd:oGet:ClassName() ) != "TGET"
      ::oWnd:oGet:Refresh()
   endif


   ::oWnd:oGet:bValid := {|| .t. }

   ::oWnd:oGet:bLostFocus := {|| (oShape:oWnd:oGet:Assign(),;
                            oShape:oWnd:oGet:VarPut( oShape:oWnd:oGet:oGet:VarGet()),;
                            oShape:aPages[::nOption]:cCaption := if( oShape:oWnd:nLastKey != VK_ESCAPE,;
                            (EnableUndo(),alltrim(oShape:oWnd:oGet:oGet:VarGet())),;
                            oShape:aPages[::nOption]:cCaption) ,;
                            If( oShape:oWnd:nLastKey != VK_ESCAPE,;
                                Eval( bValid, uVar, oShape:oWnd:nLastKey, Self ),;
                                Eval( bValid, nil, oShape:oWnd:nLastKey, Self ) ),;
                            oShape:oWnd:oGet:End(), DisableUndo(),::Refresh()) }

   ::oWnd:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( oShape:oWnd:nLastKey := nKey, oShape:oWnd:oGet:End()), ) }

endif

return nil

***************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TDsgnFolder
***************************************************************************************************

do case
   case nKey == VK_ADD
        ::AddPage()
        ::oWnd:Refresh()
        return .t.
endcase

return .f.

**********************************************************************************
  METHOD GetContainer( aRect ) CLASS TDsgnFolder
**********************************************************************************

return ::oMainPage:GetContainer( aRect )


*****************************************************************************************************
  METHOD CheckSelecteds( aRect ) CLASS TDsgnFolder
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

*****************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnFolder
*****************************************************************************************************
local cRet := ""
local n, n2
local cObject

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

        cObject := ::cObjName
        cHeader += "local " + cObject + CRLF

        cRet += "         @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " FOLDER " + cObject +  " ; " + CRLF
        cRet += "         PROMPTS "
        for n := 1 to len( ::aPages )
            cRet += '"' + alltrim( ::aPages[n]:cCaption ) + '"'
            if n < len( ::aPages )
               cRet += ", "
            endif
        next
        cRet += " ;" + CRLF
        cRet += "         OPTION " + alltrim(str(::nOption)) + " ;" + CRLF
        cRet += "         SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF
        cRet += "         OF " + cFrom  + CRLF  + CRLF

        for n := 1 to len( ::aPages )
            for n2 := 1 to len( ::aPages[n]:aShapes )
                cRet += ::aPages[n]:aShapes[n2]:GenPrg( .t., cObject + ":aDialogs[" + alltrim(str(n)) + "]", @cHeader, @cFunciones ) + CRLF
            next
        next


return cRet


****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************


CLASS TDsgnPage FROM TShape

      DATA cxCaption
      DATA nSize
      DATA aCoords
      DATA lVisible

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD cCaption( cNew ) SETGET
      METHOD GetContainer( aRect )
      METHOD ShapeOver( nRow, nCol )
      METHOD AddShape( oShape )        INLINE aadd( ::aShapes, oShape )

ENDCLASS

************************************************************************************************
  METHOD New() CLASS TDsgnPage
************************************************************************************************

   super:New()
   ::cCaption := "Item 1"
   ::aCoords := {0,0,0,0}
   ::lCanSize := .f.
   ::lCanMove       := .f.
   ::lContainer     := .t.

   ::aProperties := { "cCaption"       ,;
                      "aShapes"        ,;
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
   METHOD Paint( hDC ) CLASS TDsgnPage
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
   METHOD cCaption( cNew ) CLASS TDsgnPage
************************************************************************************************
   local hDC
   local hFont

   if cNew != nil
      ::cxCaption := cNew
      hDC   := GetDC( 0 )
      hFont := GetStockObject( DEFAULT_GUI_FONT )
      ::nSize := 7 + GetTextWidth( hDC, ::cxCaption, hFont ) + 7
      ReleaseDC( 0, hDC )
   endif

return ::cxCaption


************************************************************************************************
  METHOD GetContainer( aRect ) CLASS TDsgnPage
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
  METHOD ShapeOver( nRow, nCol ) CLASS TDsgnPage
************************************************************************************************
local oShape, oOver

for each oShape in ::aShapes
    oOver := oShape:ShapeOver( nRow, nCol )
    if oOver != nil
       return oOver
    endif
next

return nil


