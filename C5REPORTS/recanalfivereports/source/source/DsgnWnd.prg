#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"
#include "uxtheme_tmt.ch"
#include "Constant.ch"

CLASS TWndDsgn FROM TShape

      DATA aProperties

      DATA nGrid

      DATA lxToolWindow
      DATA nHCaption
      DATA nBorder
      DATA nLastLeftBtn
      DATA nTypeWnd
      DATA aTypesWnd
      DATA nTypeBorder
      DATA aTypesBorder

      DATA lCaption
      DATA lxSysMenu
      DATA lCloseBtn, aBtnClose
      DATA lxMinBtn , aBtnMin
      DATA lxMaxBtn  , aBtnMax
      DATA lResBtn  , aBtnRes
      DATA lxHelpBtn , aBtnHelp
      DATA lVScroll
      DATA lHScroll
      DATA nxHeightFont

      DATA oBrush
      DATA lGrid
      DATA oBar, oMsgBar, oMenu
      DATA nExStyle
      DATA nStyle



      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD DrawNoClient( hDC ) VIRTUAL
      METHOD DrawCaption( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD SetGrid( nGrid )
      METHOD GetClientRect()
      METHOD Move( nTop, nLeft, nBottom, nRight )
      METHOD SetSize( nWidth, nHeight, lUndo )
      METHOD Edit()
      METHOD Inspect( cDataName, oInspector )
      METHOD cCaption     ( cNewVal )      SETGET

      METHOD cSetFocus( coCtrlName )
      METHOD Run()
      METHOD SetProps( oList )

      METHOD nTop   ( nNewValue ) SETGET
      METHOD nLeft  ( nNewValue ) SETGET
      METHOD nBottom( nNewValue ) SETGET
      METHOD nRight ( nNewValue ) SETGET
      METHOD nWidth ( nNewValue ) SETGET
      METHOD nHeight( nNewValue ) SETGET
      METHOD lToolWindow( lNewValue ) SETGET
      METHOD lMinBtn( lNewValue ) SETGET
      METHOD lMaxBtn( lNewVal ) SETGET
      METHOD lHelpBtn( lNewVal ) SETGET
      METHOD lSysMenu( lNewVal ) SETGET
      METHOD nHeightFont( nNewVal ) SETGET

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TWndDsgn
************************************************************************************************



   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::cFaceName    := if( GetDefaultFontName()== "MS Shell Dlg","MS Sans Serif",GetDefaultFontName())
   ::nWidthFont   := GetDefaultFontWidth()
   ::nxHeightFont := GetDefaultFontHeight()
   ::lBold        := GetDefaultFontBold()
   ::lItalic      := GetDefaultFontItalic()
   ::lUnderline   := GetDefaultFontUnderline()
   ::lStrikeOut   := GetDefaultFontStrikeOut()


   ::nGrid       := 10
   ::nGrid       := 10
   ::lxToolWindow  := .f.
   ::lBorder      := .f.
   ::lPaintBorderDsgn := .t.
   ::aDotsActives := {0,0,0,1,1,1,0,0}
   //::aDotsActives := {1,1,1,1,1,1,1,1}
   ::lCanMove      := .f.
   ::nClrBorder   := 0
   ::nClrPane     := GetSysColor(COLOR_BTNFACE)
   ::nHCaption    := 0
   ::nBorder      := 0
   ::lGrid        := .f.
   ::lVScroll     := .f.
   ::lHScroll     := .f.
   ::nLastLeftBtn := nRight
   ::nTypeWnd     := 3
   ::aTypesWnd    := {"Popup","Overlapped","Child"}
   ::nTypeBorder  := 3
   ::aTypesBorder := {"Dialog frame","Border","Caption","No border"}
   ::lCanMove     := .f.

   //::cTitle       := "CanalFive-[Bóton derecho caption]"
   ::cCaption       := alltrim(::oWnd:oWnd:GetText())
   ::lCaption     := .t.
   ::lCloseBtn    := .t.
   ::lxSysMenu    := .t.
   ::lxMinBtn     := .f.
   ::lxMaxBtn     := .f.
   ::lResBtn      := .f.
   ::lxHelpBtn    := .f.
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }
   ::nMinHeight   := 38
   ::nMinWidth    := 113
   ::aRect        := {0,0,0,0}
  ::cObjName         := ::GetObjName()


  ::aPropertiesPPC := { "cCaption"      ,;
                        "lBorder"       ,;
                        "nID"           ,;
                        "nWidth"        ,;
                        "nHeight"       ,;
                        "nClrPane"      ,;
                        "nClrText"      ,;
                        "lVScroll"      ,;
                        "lHScroll"      ,;
                        "cFaceName"     ,;
                        "nWidthFont"    ,;
                        "nHeightFont"   ,;
                        "lBold"         ,;
                        "lItalic"       ,;
                        "lUnderline"    ,;
                        "lStrikeOut"    }



   ::aProperties := { "cCaption",;
                      "lBorder"     ,;
                      "lCaption"    ,;
                      "lCloseBtn"   ,;
                      "lHelpBtn"    ,;
                      "lMaxBtn"     ,;
                      "lMinBtn"     ,;
                      "lResBtn"     ,;
                      "lToolWindow" ,;
                      "cFaceName"   ,;
                      "nHeightFont"      ,;
                      "nClrPane"    ,;
                      "nTypeWnd"    ,;
                      "nTypeBorder" ,;
                      "oBottom"     ,;
                      "oClient"     ,;
                      "oLeft"       ,;
                      "oRight"      ,;
                      "oTop"        ,;
                      "nGrid"       ,;
                      "nGrid"        }
    if ::lGrid
       ::SetGrid()
    endif

   if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif



return self


*************************************************************************************************
  METHOD Paint( hDC ) CLASS TWndDsgn
*************************************************************************************************
  local hOldBrush
  local nRow, nCol
  local rc :=  ::GetClientRect() //{::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
  local nClrPane := ::nClrPane

  ::SetSize(,,.t.,.f.)

  if nClrPane == nil
     if ::oWnd:lPocketPc()
        nClrPane := CLR_WHITE
     else
        nClrPane := GetSysColor(COLOR_BTNFACE)
     endif
  endif


  rc[3]--;  rc[4]--

  if ::lCaption
     rc[1]+= 4
  endif

  if ::lGrid
     SetBrushOrgEx( hDC, rc[2], rc[1] )
     FillRect( hDC, rc, ::oBrush:hBrush )
  else
     if ::lBorder
        FillSolidRect( hDC, rc, nClrPane )
     else
        FillSolidRect( hDC, rc, nClrPane )
     endif
  endif

  //if ::oWnd:lPocketPC
  //   Box(hDC,rc, ::nClrBorder )
  //endif

  //if ::oWnd:oSelected == self .or. ::lSelected
  //   ::DotsSelect( hDC )
  //endif


return nil





***************************************************************************************************
      METHOD DrawCaption( hDC ) CLASS TWndDsgn
***************************************************************************************************

local aRect2, rc
local aRcBtn
local nW, nH
local hFont := FontCaption( ::lToolWindow )
local hOldFont
local color, nClrText
local nRight
local hTheme := nil
local hBmp
local aInfo := MetricsCaption()
local oFontPPC := nil
local aRect := ::GetClientRect()

if !::lCaption
   ::nHCaption := 0
   ::nBorder   := 0
   nW := 0
   nH := 0
//else
//   if !::oWnd:lPocketPc()
//      ::nBorder := GetSysMetrics( 6 ) //aInfo[5]
//
//      ::nBorder := 7
//      nW        := if( ::lToolWindow, aInfo[3], aInfo[1]  )
//      nH        := 30 //if( ::lToolWindow, aInfo[4], aInfo[2]  )
//      ::nHCaption :=  27//GetSysMetrics(if( ::lToolWindow,SM_CYSMCAPTION,SM_CYCAPTION)) + ::nBorder
//      nH := ::nHCaption //- (::nBorder * 2)
//      nW := nH - 10
//      nH := 20
//
//   endif
endif


if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

   aRect2 :=  {::aRect[1],::aRect[2],::aRect[1]+::nHCaption,::aRect[4]}

   hTheme := C5_OpenThemeData(::oWnd:hWnd, "WINDOW")

   if hTheme != nil

      if ::lCaption

         aRect2 :=  {::aRect[1],::aRect[2],::aRect[1]+::nHCaption,::aRect[4]}

         C5_DrawThemeBackground( hTheme, hDC, if(::lToolWindow, WP_SMALLCAPTION,WP_CAPTION), CS_ACTIVE , aRect2 )

         aRcBtn := { aRect2[1] +5,;
                     aRect2[4]-::nHCaption+5 ,;
                     aRect2[3] -5,;
                     aRect2[4] -5 }

         if ::lCloseBtn
            C5_DrawThemeBackground( hTheme, hDC, WP_CLOSEBUTTON, CBS_NORMAL , aRcBtn )
            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lHelpBtn
            C5_DrawThemeBackground( hTheme, hDC, WP_HELPBUTTON, HBS_NORMAL , aRcBtn )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lMaxBtn
            C5_DrawThemeBackground( hTheme, hDC, WP_MAXBUTTON, MAXBS_NORMAL , aRcBtn )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lResBtn
            C5_DrawThemeBackground( hTheme, hDC, WP_RESTOREBUTTON, RBS_NORMAL , aRcBtn )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lMinBtn
            C5_DrawThemeBackground( hTheme, hDC, WP_MINBUTTON, MINBS_NORMAL , aRcBtn )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         DeleteObject( hFont )
         //hFont := GetThemeSysFont( hTheme, TMT_FONT )
         //hOldFont := SelectObject( hDC, hFont )

         // color := SetTextColor( hDC, CLR_WHITE )
         // color := SetTextColor( hDC, GetThemeColor( hTheme, if(::lToolWindow, WP_SMALLCAPTION,WP_CAPTION), CS_ACTIVE, TMT_COLOR ) )




         hBmp := LoadBitmap( GetResources(), "canalfive" )
         //DrawMasked( hDC, hBmp, ::nTop + if(::lToolWindow, 2, 7), ::nLeft+6 )
         //DrawBitmap( hDC, hBmp, ::nTop + if(::lToolWindow, 2, 7), ::nLeft+6 )
         DeleteObject( hBmp )
         aRect2[2] += 26
         aRect2[4] := aRcBtn[2]
         C5_DrawThemeText( hTheme,;
                           hDC,;
                           if(::lToolWindow, WP_SMALLCAPTION,WP_CAPTION),;
                           CS_ACTIVE,;
                           ::cCaption,;
                           nOr( DT_SINGLELINE , DT_VCENTER, DT_END_ELLIPSIS ),;
                           nil,;
                           aRect2 )

         // SetTextColor( hDC, color )

         //SelectObject( hDC, hOldFont )
         //DeleteObject( hFont )

         aRect2 :=  {::aRect[1]+::nHCaption,::aRect[2],::aRect[3],::aRect[2]+::nBorder}
         C5_DrawThemeBackground( hTheme, hDC, WP_FRAMELEFT,   FS_ACTIVE , aRect2 )

         aRect2 :=  {::aRect[1]+::nHCaption,::aRect[4]-::nBorder,::aRect[3],::aRect[4]}
         C5_DrawThemeBackground( hTheme, hDC, WP_FRAMERIGHT,  FS_ACTIVE , aRect2 )

         aRect2 :=  {::aRect[3]-::nBorder,::aRect[2],::aRect[3],::aRect[4]}
         C5_DrawThemeBackground( hTheme, hDC, WP_FRAMEBOTTOM, FS_ACTIVE , aRect2 )


      endif

      C5_CloseThemeData()

   endif

else

   aRect2 :=  {::aRect[1]+::nBorder,::aRect[2]+::nBorder,::aRect[1]+::nBorder+::nHCaption,::aRect[4]-::nBorder}

   if ::lCaption

      if ::oWnd:lPocketPc()

         aRect2 :=  {::aRect[1],::aRect[2],::aRect[1]+::nHCaption+1,::aRect[4]}

         if ::oWnd:nTypePPC == 2 .or. ::oWnd:nTypePPC == 3
            Degrada95( hDC, aRect2, RGB(49,154,239),RGB(0,65,158),.F. )
         else
            FillSolidRect( hDC, aRect2, RGB( 16, 85, 181 ) )
         endif

         DEFINE FONT oFontPPC NAME "Tahoma" SIZE 0,-12 BOLD

         hOldFont := SelectObject( hDC, oFontPPC:hFont )

         if ::oWnd:nTypePPC == 1 .or. ::oWnd:nTypePPC == 2
            hBmp     := LoadBitmap( GetResources(), "sysppc" )
            DrawBitmap( hDC, hBmp, aRect2[1], aRect2[2] )
            DeleteObject( hBmp )

            aRect2[2] += 28

         endif

         SetBkMode( hDC, TRANSPARENT )
         color := SetTextColor( hDC, CLR_WHITE )

         aRect2[4] -= 28
         DrawText( hDC, alltrim( ::cCaption ), aRect2, nOr( DT_SINGLELINE , DT_VCENTER, DT_END_ELLIPSIS ))
         aRect2[4] += 28

         SelectObject( hDC, hOldFont  )
         SetTextColor(hDC, color)

         ::nLastLeftBtn := aRect2[4] - 28

         if ::oWnd:nTypePPC == 1 .or. ::oWnd:nTypePPC == 2
            hBmp     := LoadBitmap( GetResources(), "xppc" )
            //hBmp     := LoadBitmap( GetResources(), "okext" )
            DrawMasked( hDC, hBmp, aRect2[1]+4-1, aRect2[4]-24-1 )
            DeleteObject( hBmp )
         else
            if ::oWnd:nTypePPC == 3
               hBmp     := LoadBitmap( GetResources(), "oksmph" )
               DrawMasked( hDC, hBmp, aRect2[1], aRect2[4]-40 )
               DeleteObject( hBmp )
               ::nLastLeftBtn := aRect2[4]-40
            endif
         endif

      else

         hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )

         //DrawCaption( ::oWnd:hWnd, hDC, aRect2, nOR( DC_TEXT, DC_GRADIENT, DC_ACTIVE ) )

         aRect2 := { ::aRect[1]+::nBorder,;
                     ::aRect[2]+::nBorder,;
                     ::aRect[1]+::nHCaption-::nBorder,;
                     ::aRect[4]-::nBorder}

         Degrada95( hDC, aRect2, RGB(0,65,158),RGB(49,154,239),.F. )

         aRcBtn := { aRect2[1] + int((aRect2[3]-aRect2[1])/2)- int(nH/2),;
                     aRect2[4]-nW-::nBorder ,;
                     aRect2[1] + int((aRect2[3]-aRect2[1])/2)+ int(nH/2),;
                     aRect2[4]-::nBorder}

         if ::lCloseBtn
            DrawFrameControl( hDC, aRcBtn, DFC_CAPTION, DFCS_CAPTIONCLOSE )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lHelpBtn
            DrawFrameControl( hDC, arcBtn, DFC_CAPTION, DFCS_CAPTIONHELP )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lMaxBtn
            DrawFrameControl( hDC, aRcBtn, DFC_CAPTION, DFCS_CAPTIONMAX )

            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lResBtn
            DrawFrameControl( hDC, aRcBtn, DFC_CAPTION, DFCS_CAPTIONRESTORE )
            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         if ::lMinBtn
            DrawFrameControl( hDC, aRcBtn, DFC_CAPTION, DFCS_CAPTIONMIN )
            aRcBtn[2] -= (nW +2)
            aRcBtn[4] -= (nW +2)
         endif

         nRight := aRcBtn[2]

         aRcBtn[2] := aRect2[2] + ::nBorder
         aRcBtn[4] := nRight


         SetBkMode( hDC, TRANSPARENT )
         color := SetTextColor(hDC, GetSysColor(COLOR_CAPTIONTEXT))
         hOldFont := SelectObject( hDC, hFont )
         DrawText( hDC, ::cCaption, aRcBtn, nOr( DT_SINGLELINE , DT_VCENTER, DT_END_ELLIPSIS ))
         SelectObject( hDC, hOldFont  )
         SetTextColor(hDC, color)

         ::nLastLeftBtn := aRcBtn[2]

         DrawEdge( hDC, ::aRect, BDR_RAISEDINNER, BF_RECT )

         rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

         DrawEdge( hDC, rc, BDR_RAISEDOUTER, BF_RECT )
         rc[1]++;rc[2]++;rc[3]--;rc[4]--
         DrawEdge( hDC, rc, BDR_RAISEDINNER, BF_RECT )
         rc[1]++;rc[2]++;rc[3]++;rc[4]++
      endif

   endif

   if oFontPPC != nil
      oFontPPC:End()
   endif

   DeleteObject( hFont )


  aRect2 := {::aRect[1]+::nBorder+ GetSysMetrics(if( ::lToolWindow,SM_CYSMCAPTION,SM_CYCAPTION)) + ::nBorder ,;
           ::aRect[2]+::nBorder,;
           ::aRect[3]-::nBorder,;
           ::aRect[4]-::nBorder}

      nH :=aRect2[3]-aRect2[1]
      nW := nH

    if ::lVScroll
       ::PaintVScroll( hDC, .t.,::lHScroll, ::lHScroll, .f., ::nHCaption  )
    endif

    if ::lHScroll
       ::PaintHScroll( hDC, .t. ,::lVScroll, ::lVScroll )
    endif

    if ::lBorder
       Box( hDC, {::aRect[1],::aRect[2],::aRect[3]-1,::aRect[4]-1}, ::nClrBorder )
    endif

endif

if !::oWnd:lPocketPc()
   if ::lCaption
      aRect2 :=  {::aRect[1]+::nBorder,::aRect[2]+::nBorder,::aRect[1]+::nBorder+::nHCaption,::aRect[4]-::nBorder}
      hBmp     := LoadBitmap( GetResources(), "iconwnd" )
      DrawMasked( hDC, hBmp, aRect2[1]+3, aRect2[2]+5 )
      DeleteObject( hBmp )
 endif
endif


return nil



***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TWndDsgn
***************************************************************************************************
local oMenu



if nRow <= ::nHCaption + 8 .and. !::oWnd:lPocketPc
   MENUITEM "Botón Minimizar"  ACTION ::lMinBtn   := !::lMinBtn  , ::Refresh()
   MENUITEM "Botón Restaurar"  ACTION ::lResBtn   := !::lResBtn  , ::Refresh()
   MENUITEM "Botón Maximizar"  ACTION ::lMaxBtn   := !::lMaxBtn  , ::Refresh()
   MENUITEM "Botón ?"          ACTION ::lHelpBtn  := !::lHelpBtn , ::Refresh()
   MENUITEM "Botón X"          ACTION ::lCloseBtn := !::lCloseBtn, ::Refresh()
   SEPARATOR
   MENUITEM "ToolWindow"       ACTION ::lToolWindow := !::lToolWindow, ::Refresh()

else
   MENUITEM "Paste"            ACTION ::Paste( nRow, nCol, ::oWnd )
   MENUITEM "Save"             ACTION ::Save2Prg()
   MENUITEM "Run"              ACTION ::Run()
   /*
   MENUITEM "Grid"
   MENU
        MENUITEM "1" ACTION (::nGrid :=   1)
        MENUITEM "2" ACTION (::nGrid :=   2)
        MENUITEM "3" ACTION (::nGrid :=   3)
        MENUITEM "4" ACTION (::nGrid :=   4)
        MENUITEM "5" ACTION (::nGrid :=   5)
        MENUITEM "6" ACTION (::nGrid :=   6)
        MENUITEM "7" ACTION (::nGrid :=   7)
        MENUITEM "8" ACTION (::nGrid :=   8)
        MENUITEM "9" ACTION (::nGrid :=   9)
        MENUITEM "10" ACTION (::nGrid := 10)
   ENDMENU
   */
endif

return nil




************************************************************************************************************************
   METHOD SetGrid( nGrid ) CLASS TWndDsgn
************************************************************************************************************************
local hDC, hDCMem, hOldBmp   //local n := max( nGrid, 2 )
local hBmpBrush
local nClrPane := ::nClrPane
local n := nGrid

DEFAULT nGrid := ::nGrid

if nGrid == 0
   ? "nGrid == 0"
   ::lGrid := .f.
   return nil
endif

if nClrPane == nil
   if ::oWnd:lPocketPc()
      nClrPane := CLR_WHITE
   else
      nClrPane := GetSysColor(COLOR_BTNFACE)
   endif
endif

hDC         := ::oWnd:GetDC()
hDCMem      := CreateCompatibleDC( hDC )
hBmpBrush   := CreateCompatibleBitmap( hDC, n, n )
hOldBmp     := SelectObject( hDCMem, hBmpBrush )

FillSolidRect( hDCMem, {0, 0, n, n }, nClrPane )

if nGrid != 0
   SetPixel( hDCMem, nGrid-1, nGrid-1, 0 )
endif

SelectObject( hDCMem, hOldBmp )

DeleteDC( hDCMem )
::oWnd:ReleaseDC()

if ::oBrush != nil
   ::oBrush:End()
endif

DEFINE BRUSH ::oBrush COLOR CLR_HRED
::oBrush:hBrush := CreatePatternBrush( hBmpBrush )




return nil

**************************************************************************
  METHOD GetClientRect() CLASS TWndDsgn
**************************************************************************
local aClient
local hTheme
local hDC
local nBorder

if ::oWnd:lPocketPc()
   nBorder := 0
else
   nBorder := ::nBorder
endif

if !::lCaption
   aClient := { ::aRect[1]+1, ::aRect[2]+1, ::aRect[3]-1, ::aRect[4]-1 }
else

   aClient := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }

   ::nHCaption := 0 //GetSysMetrics(if( ::lToolWindow,SM_CYSMCAPTION,SM_CYCAPTION))
   if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

      hTheme := hTheme := C5_OpenThemeData(::oWnd:hWnd, "WINDOW" )

      C5_CloseThemeData()

   else

      if ::oWnd:lPocketPc()
         do case
            case ::oWnd:nTypePPC == 1 .or. ::oWnd:nTypePPC == 2
                 ::nHCaption := 0 //25
            case ::oWnd:nTypePPC == 3
                 ::nHCaption := 0 //19
         endcase
      else
         ::nHCaption := 0 //GetSysMetrics(if( ::lToolWindow,SM_CYSMCAPTION,SM_CYCAPTION)) + nBorder //+ nBorder
         ::nHCaption := 0 //20
      endif

   endif

   aClient[1] += ::nHCaption

   if !::oWnd:lPocketPc()
      if ::oMenu != nil
         ::oMenu:aRect[1] := aClient[1]
         ::oMenu:aRect[2] := aClient[2]
         aClient[1] += ::oMenu:nHeight
         ::oMenu:aRect[3] := ::oMenu:aRect[1] + ::oMenu:nHeight
         ::oMenu:aRect[4] := aClient[4]
      endif
   endif

   if ::oBar != nil
      do case
         case ::oBar:nSide == TOPBAR
              aClient[1] += ::oBar:nHeight
         case ::oBar:nSide == LEFTBAR
              aClient[2] += ::oBar:nWidth
         case ::oBar:nSide == RIGHTBAR
              aClient[4] -= ::oBar:nWidth
         case ::oBar:nSide == DOWNBAR
              aClient[3] += ::oBar:nHeight
      endcase
   endif

   if ::oMsgBar != nil
      aClient[3] += ::oMsgBar:nHeight
   endif

   if ::lVScroll
      aClient[4] -= 16
   endif

   if ::lHScroll
      aClient[3] -= 16
   endif

   if ::oWnd:lPocketPc()
      if ::oMenu != nil
         ::oMenu:aRect[1] := ::aRect[3]- 26
         ::oMenu:aRect[2] := aClient[2]
         aClient[3] -= 26
         ::oMenu:aRect[3] := ::aRect[3]
         ::oMenu:aRect[4] := ::aRect[4]
      endif
   endif

endif

return aClient




**************************************************************************
  METHOD Move( nTop, nLeft, nBottom, nRight ) CLASS TWndDsgn
**************************************************************************

::aRect[1] := nTop
::aRect[2] := nLeft

::SetSize( nRight-nLeft, nBottom-nTop )


return nil


*************************************************************************************************
   METHOD SetSize( nWidth, nHeight, lUndo, lRefresh ) CLASS TWndDsgn
*************************************************************************************************
local lChange := .t.
local aClient
local nT, nL, nH, nW
local oTop, oLeft, oBottom, oRight, oClient

if nWidth   == nil; nWidth   := ::nWidth ; endif
if nHeight  == nil; nHeight  := ::nHeight; endif
if lUndo    == nil; lUndo    := .f.      ; endif
if lRefresh == nil; lRefresh := .t.      ; endif

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

aClient := ::GetClientRect()

if ::oBar != nil
   do case
      case ::oBar:nSide == TOPBAR
           ::oBar:nRight := aClient[4]
      case ::oBar:nSide == LEFTBAR
           ::oBar:nBottom := aClient[3]
      case ::oBar:nSide == RIGHTBAR
           ::oBar:nLeft := aClient[4]-::oBar:nWidth
           ::oBar:nBottom := aClient[3]
      case ::oBar:nSide == DOWNBAR
           ::oBar:nTop := aClient[3]-::oBar:nHeight
   endcase
endif



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



if lUndo .and. lRefresh
   ::oWnd:Refresh()
endif




return nil

***************************************************************************************************
   METHOD Edit( nKey ) CLASS TWndDsgn
***************************************************************************************************
local oFont
local bValid := {||.t.}
local oShape := self
local uVar
local nTop, nLeft, nWidth, nHeight
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

uVar := padr(::cCaption, 100)

nTop    := rc[1]+4
nLeft   := rc[2]+4
if ::oWnd:lPocketPc()
   if ::oWnd:nTypePPC == 1 .or. ::oWnd:nTypePPC == 2
      nLeft   := rc[2]+4+24
   endif
endif
nWidth  := ::nLastLeftBtn - nLeft - 4
nHeight := rc[1]+::nHCaption-8

if ::oWnd:lPocketPc()
   DEFINE FONT oFont NAME "Tahoma" SIZE 0,-12 BOLD
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10
endif

if oShape:lEditable

   if nKey != nil
      uVar := padr(chr( nKey ), 100)
   endif

   ::oWnd:oGet := TGet():New(nTop,nLeft,{ | u | If( PCount()==0, uVar, uVar:= u ) },oShape:oWnd,nWidth,nHeight,,,0,16777215,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

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
                                  oShape:oWnd:oGet:End(), DisableUndo(),::Refresh()) }

   ::oWnd:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( oShape:oWnd:nLastKey := nKey, oShape:oWnd:oGet:End()), ) }

endif

return nil

 #define LOGPIXELSY          90




**********************************************************************************
  METHOD Inspect( cDataName, oInspector ) CLASS TWndDsgn
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


      case cDataName == "cFaceName"

           if !empty( oInspector:aRectBtn )
              aPoint := {oInspector:aRectBtn[3],oInspector:aRectBtn[4]}
              aPoint := ClientToScreen( oInspector:hWnd, aPoint )
           endif
           return { | cDataName | oSend( self, "_" + cDataName,;
                                  xSelFont( aPoint[1], aPoint[2]-155, oSend( Self, cDataName ))),;
                                  o:Refresh(),;
                                  oInspector:Refresh() }


   endcase

return nil

**********************************************************************************
   METHOD cSetFocus( coCtrlName ) CLASS TWndDsgn
**********************************************************************************
local n

  for n := 1 to len( ::oWnd:aShapes ) -1
      if coCtrlName == ::oWnd:aShapes[n]:GetObjName()
         ::oWnd:aShapes[n]:SetFocus(.f.)
      endif
  next
  ::oWnd:Refresh()

return nil

***************************************************************************************************
  METHOD cCaption( cNewVal ) CLASS TWndDsgn
***************************************************************************************************

if cNewVal != nil

   if lMetoEnUndo()
      ::oWnd:AddUndo( self, "cCaption", ::cxCaption , .t. )
   endif

   ::cxCaption := alltrim(cNewVal)

   if lFromUndo()
      ::oWnd:Refresh()
   endif
   ::oWnd:oWnd:cTitle := ::cxCaption

endif

return ::cxCaption

***************************************************************************************************
  METHOD Run() CLASS TWndDsgn
***************************************************************************************************
local cCurPath  := cFilePath( GetModuleFileName( GetInstance() ) )

if right( cCurPath,1) != "\";     cCurPath += "\";   endif
DeleteFile( "comp.log" )

CursorWait()

WAITRUN( "buildh.bat " + cFileNoext( ::cFileName )  ,0 )

if File( "comp.log" )
   if At( upper(memoread("comp.log")),"ERROR" ) != 0
      ShellExecute( GetActiveWindow(),nil,"comp.log","","",8)
      CursorArrow()
      return 0
   endif
endif
CursorArrow()

 if file( cCurPath + cFileNoExt( ::cFileName ) + ".EXE" )
    ShellExecute( GetActiveWindow() ,nil, cCurPath + cFileNoExt( ::cFileName ) + ".EXE" ,'','',8)
 ENDIF

return 0

***************************************************************************************************
   METHOD SetProps( oList ) CLASS TWndDsgn
***************************************************************************************************
local nGroup
local o := self
//   ::aProperties := { "cCaption",;
//                      "lBorder"     ,;
//                      "lCaption"    ,;
//                      "lCloseBtn"   ,;
//                      "lHelpBtn"    ,;
//                      "lMaxBtn"     ,;
//                      "lMinBtn"     ,;
//                      "lResBtn"     ,;
//                      "lToolWindow" ,;
//                      "cFaceName"   ,;
//                      "nHeightFont" ,;
//                      "nClrPane"    ,;
//                      "nTypeWnd"    ,;
//                      "nTypeBorder" ,;
//                      "oBottom"     ,;
//                      "oClient"     ,;
//                      "oLeft"       ,;
//                      "oRight"      ,;
//                      "oTop"        ,;
//                      "nGrid"       ,;
//                      "nGrid"        }

nGroup := oList:AddGroup( "Appearence" )

oList:AddItem( "cObjName","Name", ,nGroup )
//oList:AddItem( "lActive","Active","L" ,nGroup )
oList:AddItem( "cCaption","Text",,nGroup )

oList:AddItem( "lCanMove","Can move?", "L",nGroup )
oList:AddItem( "lCanSize","Can size?", "L",nGroup )
oList:AddItem( "lGrid","Grid?", "L",nGroup )

oList:AddItem( "lSysMenu","System menu?", "L",nGroup )
oList:AddItem( "lHelpBtn","Help button?", "L",nGroup )
oList:AddItem( "lMaxBtn","Maximize button?", "L",nGroup )
oList:AddItem( "lMinBtn","Minimize button?", "L",nGroup )
oList:AddItem( "lResBtn","Restore button?", "L",nGroup )
oList:AddItem( "lCaption","Title bar?", "L",nGroup )
oList:AddItem( "lToolWindow","ToolbarWindow?", "L",nGroup )

oList:AddItem( "nClrText"    ,"Text color", "B",nGroup,,,{|| ChooseColor( o:nClrText )} )
oList:AddItem( "nClrPane"    ,"Back color", "B",nGroup,,,{|| ChooseColor( o:nClrPane )} )

nGroup := oList:AddGroup( "Font" )
oList:AddItem( "cFaceName",  "FaceName",    "A",nGroup,,,{|| aGetFontNamesEx() } )
oList:AddItem( "nHeightFont","nHeightFont",    ,nGroup )
oList:AddItem( "lBold",      "lBold      ", "L",nGroup )
oList:AddItem( "lItalic",    "lItalic    ", "L",nGroup )
oList:AddItem( "lUnderline", "lUnderline ", "L",nGroup )
oList:AddItem( "lStrikeOut", "lStrikeOut ", "L",nGroup )



nGroup := oList:AddGroup(  "Position" )
//oList:AddItem( ,"Center", .t.,,nGroup )
oList:AddItem( "nTop","Top", ,nGroup )
oList:AddItem( "nLeft","Left", ,nGroup )
oList:AddItem( "nWidth","Width", ,nGroup )
oList:AddItem( "nHeight","Height", ,nGroup )





return 0


*************************************************************************************************
      METHOD nTop( nNewVal ) CLASS TWndDsgn
*************************************************************************************************
local nHeight

if nNewVal != nil
   nHeight := ::aRect[3] - ::aRect[1]
   ::aRect[1] := nNewVal
   ::aRect[3] := ::aRect[1] + nHeight
   ::oWnd:oWnd:Move( nNewVal, ::oWnd:oWnd:nLeft )
endif

return ::oWnd:oWnd:nTop

*************************************************************************************************
      METHOD nLeft( nNewVal ) CLASS TWndDsgn
*************************************************************************************************
local nWidth

if nNewVal != nil
   nWidth := ::aRect[4] - ::aRect[2]
   ::aRect[2] := nNewVal
   ::aRect[4] := ::aRect[2] + nWidth
   ::oWnd:oWnd:Move( ::oWnd:oWnd:nTop, nNewVal )
endif

return ::oWnd:oWnd:nLeft

*************************************************************************************************
      METHOD nBottom( nNewVal ) CLASS TWndDsgn
*************************************************************************************************

if nNewVal != nil
   ::aRect[3] := nNewVal
   ::oWnd:oWnd:SetSize( ::oWnd:oWnd:nWidth, nNewVal-::oWnd:oWnd:nTop  )
endif

return ::oWnd:oWnd:nBottom

*************************************************************************************************
      METHOD nRight ( nNewVal ) CLASS TWndDsgn
*************************************************************************************************

if nNewVal != nil
   ::aRect[4] := nNewVal
   ::oWnd:oWnd:SetSize( ::oWnd:oWnd:nWidth, nNewVal-::oWnd:oWnd:nTop  )
endif

return ::oWnd:oWnd:nRight

*************************************************************************************************
      METHOD nWidth ( nNewVal ) CLASS TWndDsgn
*************************************************************************************************

if nNewVal != nil
   ::aRect[4] := ::aRect[2] + nNewVal
   ::oWnd:oWnd:SetSize(  nNewVal, ::oWnd:oWnd:nHeight )
endif

return ::oWnd:oWnd:nWidth


*************************************************************************************************
      METHOD nHeight( nNewVal ) CLASS TWndDsgn
*************************************************************************************************

if nNewVal != nil
   ::aRect[3] := ::aRect[1] + nNewVal
   ::oWnd:oWnd:SetSize(  ::oWnd:oWnd:nWidth, nNewVal )
endif

return ::oWnd:oWnd:nHeight


#define GWL_STYLE          -16
#define GWL_EXSTYLE          -20
#define WS_EX_TOOLWINDOW     128
#define WS_EX_CONTEXTHELP   1024

*************************************************************************************************
      METHOD lToolWindow( lNewVal ) CLASS TWndDsgn
*************************************************************************************************

if pcount() > 0

   if lNewVal
      ::nExStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE )
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE,nOr( ::nExStyle, WS_EX_TOOLWINDOW ) )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )

   else
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE,::nExStyle )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   endif

   ::lxToolWindow := lNewVal

endif

return ::lxToolWindow

*************************************************************************************************
      METHOD lMinBtn( lNewVal ) CLASS TWndDsgn
*************************************************************************************************

if pcount() > 0

   if !lNewVal
      //::nStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE )
      //nStyle = nXor( nStyle, SBS_HORZ )
      //nStyle = nOr( nStyle, SBS_VERT )
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE, nAnd( ::nStyle, nNot( WS_MINIMIZEBOX ) ))
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )

   else
      ::nStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE )
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE,nOr( ::nStyle, WS_MINIMIZEBOX ) )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   endif

   ::lxMinBtn := lNewVal

endif



return ::lxMinBtn

*************************************************************************************************
      METHOD lMaxBtn( lNewVal ) CLASS TWndDsgn
*************************************************************************************************

if pcount() > 0

   if !lNewVal

      //nStyle = nXor( nStyle, SBS_HORZ )
      //nStyle = nOr( nStyle, SBS_VERT )
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE, nAnd( ::nStyle, nNot( WS_MAXIMIZEBOX ) ))
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )

   else
      ::nStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE )
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE,nOr( ::nStyle, WS_MAXIMIZEBOX ) )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   endif

   ::lxMaxBtn := lNewVal

endif



return ::lxMaxBtn


*************************************************************************************************
      METHOD lHelpBtn( lNewVal ) CLASS TWndDsgn
*************************************************************************************************
local nStyle

if pcount() > 0

   nStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE )

   if !lNewVal
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE, nAnd( nStyle, nNot( WS_EX_CONTEXTHELP ) ))
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   else
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_EXSTYLE, nOr( nStyle, WS_EX_CONTEXTHELP ) )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   endif

   ::lxHelpBtn := lNewVal

endif



return ::lxHelpBtn


*************************************************************************************************
      METHOD lSysMenu( lNewVal ) CLASS TWndDsgn
*************************************************************************************************
local nStyle

if pcount() > 0

   nStyle := GetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE )

   if !lNewVal

      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE, nAnd( nStyle, nNot( WS_SYSMENU ) ))
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )

   else
      SetWindowLong( ::oWnd:oWnd:hWnd, GWL_STYLE,nOr(nStyle, WS_SYSMENU) )
      SetWindowPos( ::oWnd:oWnd:hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,::nBottom - ::nTop + 1, 55 )
   endif

   ::lxSysMenu := lNewVal

endif

return ::lxSysMenu

*************************************************************************************************
    METHOD nHeightFont( nNewVal )  CLASS TWndDsgn
*************************************************************************************************
local oFont
local nDH
local nDW
local nH, nW
local nH2, nW2
local n
local c := ""
local nLen

if pcount() > 0

   oFont := TFont():New( ::cFaceName, 0, ::nxHeightFont , .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
   nH := oFont:nHeight
   ::nxHeightFont := nNewVal
   oFont:End()

   oFont := TFont():New( ::cFaceName, 0, ::nxHeightFont , .f.,::lBold,,,,::lItalic,::lUnderline,::lStrikeOut )
   nH2 := oFont:nHeight

   oFont:End()
   nD := nH2/nH

   nLen := len( ::oWnd:ashapes ) -1
   for n := 1 to nLen
       ::oWnd:aShapes[n]:nLeft   := int( ::oWnd:aShapes[n]:nLeft   * nD )
       ::oWnd:aShapes[n]:nTop    := int( ::oWnd:aShapes[n]:nTop    * nD )
       ::oWnd:aShapes[n]:nWidth  := int( ::oWnd:aShapes[n]:nWidth  * nD )
       ::oWnd:aShapes[n]:nHeight := int( ::oWnd:aShapes[n]:nHeight * nD )
   next

endif

return ::nxHeightFont
