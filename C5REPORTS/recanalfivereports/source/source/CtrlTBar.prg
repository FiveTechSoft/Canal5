#include "fivewin.ch"
#include "wnddsgn.ch"
#include "Constant.ch"
#include "Slider.ch"
#include "SPlitter.ch"
#include "xBrowse.ch"


#define SRCCOPY 13369376
#define COLOR_HIGHLIGHT      13
#define COLOR_HIGHLIGHTTEXT  14
#define SB_THUMBTRACK                      5


function ToolBar( nTop, nLeft, nWidth, nHeight, oPage )
local oWnd, oDlg
local oToolBar
local oBtnFld
local oSlide1
local nVar1 := 10


        oBtnFld  := TBtnFolder():New( nTop, nLeft, nTop+nHeight, nLeft+nWidth, oPage )

        //oPage:oClient := oBtnFld

        oToolBar := TCtrlToolBar():New( 0, 0, 1, 1, oBtnFld, "Controles", "toolbar\image3.bmp" )
        aadd( oBtnFld:aFolders, oToolBar )

        oToolBar:AddItem( "Seleccionar"  ,   0, {||Aplicacion():nState := DSGN_SELECT   } )    //oToolBar:AddItem( "Dialogo"      ,  42 )
        oToolBar:AddItem( "Boton"        ,   2, {||Aplicacion():nState := DSGN_BTN      } )
        oToolBar:AddItem( "Get"          ,   5, {||Aplicacion():nState := DSGN_GET      } )
        oToolBar:AddItem( "Say"          ,   1, {||Aplicacion():nState := DSGN_SAY      } )
        oToolBar:AddItem( "ListBox"      ,   4, {||Aplicacion():nState := DSGN_LISTBOX  } )
        oToolBar:AddItem( "ComboBox"     ,  12, {||Aplicacion():nState := DSGN_COMBO    } )
        oToolBar:AddItem( "GroupBox"     ,   8, {||Aplicacion():nState := DSGN_GROUPBOX } )
        oToolBar:AddItem( "RadioBox"     ,   6, {||Aplicacion():nState := DSGN_RADIO    } )
        oToolBar:AddItem( "CheckBox"     ,   7, {||Aplicacion():nState := DSGN_CHEK     } )
        oToolBar:AddItem( "Imagen"       ,   9, {||Aplicacion():nState := DSGN_PICTURE  } )
        oToolBar:AddItem( "Menu"         ,   3, {||Aplicacion():nState := DSGN_MENU     } )
        oToolBar:AddItem( "ListView"     ,  13, {||Aplicacion():nState := DSGN_LISTVIEW } )
        oToolBar:AddItem( "TreeView"     ,  14, {||Aplicacion():nState := DSGN_TREE     } )
        oToolBar:AddItem( "TrackControl" ,  25, {||Aplicacion():nState := DSGN_SLIDER } )
        oToolBar:AddItem( "Meter"        ,  26, {||Aplicacion():nState := DSGN_PROGRESS } )
      //oToolBar:AddItem( "Folder"       ,  15, {||Aplicacion():nState := DSGN_FOLDER   } )
        oToolBar:AddItem( "User Control" ,  43, {||Aplicacion():nState := DSGN_USER     } )
        oToolBar:AddItem( "Icon"         ,  44, {||Aplicacion():nState := DSGN_ICON     } )
        oToolBar:AddItem( "ButtonBar"    ,  30, {||Aplicacion():nState := DSGN_BAR      } )
        oToolBar:AddItem( "BtnBmp"       ,  45, {||Aplicacion():nState := DSGN_BTNBMP   } )
        oToolBar:AddItem( "Browse"       ,  46, {||Aplicacion():nState := DSGN_BROWSE   } )
        oToolBar:AddItem( "Folder"       ,  15, {||Aplicacion():nState := DSGN_TABCTRL  } )
        oToolBar:AddItem( "Panel"        ,  10, {||Aplicacion():nState := DSGN_PANEL    } )
        oToolBar:AddItem( "VistaMenu"    ,  10, {||Aplicacion():nState := DSGN_VISTAMENU } )

        SetScrollRange( oToolBar:hWnd, 1, 1, len(oToolBar:aItems ), .t. )

        //oToolBar := TCtrlToolBar():New( 0, 0, 100, 100, oBtnFld, "FiveWin", "toolbar\image3.bmp" )
        //aadd( oBtnFld:aFolders, oToolBar )


        SetScrollRange( oToolBar:hWnd, 1, 1, len(oToolBar:aItems ), .t. )

        oToolBar := TCtrlToolBar():New( 0, 0, 1, 1, oBtnFld, "Alinear", "toolbar\image4.bmp" )
        aadd( oBtnFld:aFolders, oToolBar )
        oToolBar:AddItem( "Selección"                , 0 )
        oToolBar:AddItem( "Izquierda"                , 1, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( , 8),)} )
        oToolBar:AddItem( "Derecha"                  , 2, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( , 4),)} )
        oToolBar:AddItem( "Arriba"                   , 3, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( , 2),)} )
        oToolBar:AddItem( "Abajo"                    , 4, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( , 6),)} )
        oToolBar:AddItem( "Centrar Horizontal"       , 5, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( , 9),)} )
        oToolBar:AddItem( "Centrar Vertical"         , 6, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( ,10),)} )
        oToolBar:AddItem( "Repartir horizontal"      , 7, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( ,20),)} )
        oToolBar:AddItem( "Repartir vertical"        , 8, {|| if( Aplicacion():oDFocus != nil, Aplicacion():oDFocus:Align( ,21),)} )
        oToolBar:AddItem( "Mismo ancho"              , 9 )
        oToolBar:AddItem( "Mismo alto"               ,10 )
        oToolBar:AddItem( "Mismo tamaño"             ,11 )
        oToolBar:AddItem( "Centrado horizontal"      ,12 )
        oToolBar:AddItem( "Centrado vertical"        ,13 )

        oToolBar := TCtrlToolBar():New( 0, 0, 1, 1, oBtnFld, "Imágenes", "toolbar\image4.bmp" )
        aadd( oBtnFld:aFolders, oToolBar )

        oToolBar:AddItem( "Abrir"                   , 20, {|| Aplicacion():Abrir(.f.,.f.,.t.)} )
        oToolBar:AddItem( "Aumentar"                , 14, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:Zoom(),)} )
        oToolBar:AddItem( "Disminuir"               , 15, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:UnZoom(),)} )
        oToolBar:AddItem( "Rotar 90º"               , 16, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:Rotar(90),)} )
        //oToolBar:AddItem( "Rotar 180º"              , 16, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:Rotar(180),)} )
        //oToolBar:AddItem( "Rotar 270º"              , 16, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:Rotar(270),)} )
        oToolBar:AddItem( "Flip Horizontal"         , 17, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:FlipH(),)} )
        oToolBar:AddItem( "Flip Vertical"           , 18, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:FlipV(),)} )
        oToolBar:AddItem( "Salvar"                  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:Save(),)} )
        oToolBar:AddItem( "Salvar como JPG"         , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsJPG(),)} )
        oToolBar:AddItem( space(16)+"...  BMP"  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsBMP(),)} )
        oToolBar:AddItem( space(16)+"...  TIF"  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsTIF(),)} )
        oToolBar:AddItem( space(16)+"...  PNG"  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsPng(),)} )
        oToolBar:AddItem( space(16)+"...  GIF"  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsGif(),)} )
        oToolBar:AddItem( space(16)+"...  ICO"  , 19, {|| if( Aplicacion():oImgFocus != nil, Aplicacion():oImgFocus:SaveAsICO(),)} )


        oToolBar := TCtrlToolBar():New( 0, 0, 1, 1, oBtnFld, "Buscar", "toolbar\image4.bmp", {||ShowWndFind()}, {|self| FindInFiles( self )} )
        aadd( oBtnFld:aFolders, oToolBar )


        oBtnFld:SetOption( 1 )


return oBtnFld


CLASS TBtnFolder FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aFolders
      DATA nOption
      DATA nFirst
      DATA aClient
      DATA nHItem

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR

      METHOD LButtonDown( nRow, nCol, nFlags )
     // METHOD MouseMove( nRow, nCol, nFlags )
     // METHOD LButtonUp( nRow, nCol, nFlags )

      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(),0
      METHOD Paint()
      METHOD GetClientRect()
      METHOD SetOption( nOption )
      METHOD ReSize( nSizeType, nWidth, nHeight )

      //METHOD VScroll( nWParam, nLParam )
      //METHOD MouseWheel( nKey, nDelta, nXPos, nYPos )
      //METHOD KeyDown( nKey, nKeyFlags )

ENDCLASS

*******************************************************************************************
   METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TBtnFolder
*******************************************************************************************

   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nBottom
   ::nRight    := nRight
   ::oWnd      := oWnd
   ::aFolders  := {}
   ::aClient   := {0,0,0,0}
   ::nOption   := 1
   ::nHItem    := 22

   ::nStyle    := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP ) //WS_HSCROLL
   ::nId       := ::GetNewId()

   ::lCaptured := .f.

   ::nClrText := 0
   ::nClrPane := CLR_WHITE //GetSysColor( COLOR_BTNFACE )

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

return Self

****************************************************************************************************
  METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TBtnFolder
****************************************************************************************************
local n
local nLen := len( ::aFolders )

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aFolders[n]:aRect )
       ::SetOption( n )
       ::Refresh()
       exit
    endif
next

return 0


*******************************************************************************************
  METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TBtnFolder
*******************************************************************************************
local aC := GetClientRect( ::hWnd )

::SetOption( ::nOption )

return Super:ReSize( nSizeType, nWidth, nHeight )


*******************************************************************************************
  METHOD Paint() CLASS TBtnFolder
*******************************************************************************************
local n, nLen
local nCount  := 0
local nTop    := 0
local nBottom := 0
local nLeft   := 5
local nHeight := 0
local hDCMem, hBmp, hOldBmp
local aRect := GetClientRect(::hWnd)
local rc
local nMode
local hOldFont


ExcludeClipRect( ::hDC, ::aClient[2], ::aClient[1], ::aClient[4], ::aClient[3] )

hBmp   := CreateCompatibleBitmap( ::hDC, aRect[4], aRect[3] )
hDCMem := CreateCompatibleDC( ::hDC )

hOldBmp := SelectObject( hDCMem, hBmp )

FillSolidRect( hDCMem, aRect, ::nClrPane )
nMode := SetBkMode( hDCMem, 1 )

nLen := len( ::aFolders )

hOldFont := SelectObject( hDCMem, GetStockObject( DEFAULT_GUI_FONT ) )

for n := 1 to ::nOption
    nTop := (::nHItem * (n-1) ) + nHeight
    rc := { nTop+1, 1, nTop + ::nHItem-1, ::aClient[4]-1}
    DrawFrameControl( hDCMem, rc, DFC_BUTTON, nOr(DFCS_BUTTONPUSH, DFCS_FLAT )) //
    rc[2] += 15
    DrawText( hDCMem, ::aFolders[n]:cCaption, rc, nOr( DT_SINGLELINE,  DT_VCENTER ) ) //DT_CENTER,
next

nBottom := nTop + ::nHItem + (::aClient[3]-::aClient[1])

if ::nOption < nLen
   nCount := 0
   for n := ::nOption + 1 to nLen
       nTop := nBottom  + (::nHItem * nCount)
       rc := { nTop+1, 1, nTop + ::nHItem-1, ::aClient[4]-1}
       DrawFrameControl( hDCMem, rc, DFC_BUTTON, nOr(DFCS_BUTTONPUSH, DFCS_FLAT )) //
    rc[2] += 15
       DrawText( hDCMem, ::aFolders[n]:cCaption, rc, nOr( DT_SINGLELINE, DT_VCENTER ) ) //DT_CENTER,
       nCount ++
   next
endif

SetBkMode( hDCMem, nMode )
SelectObject( hDCMem, hOldFont )

BitBlt( ::hDC, 0, 0, aRect[4], aRect[3], hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmp )
DeleteDC( hDCMem )

return 0


*********************************************************************************************************
  METHOD GetClientRect() CLASS TBtnFolder
*********************************************************************************************************
local nLen := len( ::aFolders )
local n
local nTop, nBottom
local nCount := 0

for n := 1 to ::nOption
    nTop := (::nHItem * (n-1) )
    ::aFolders[n]:aRect := { nTop, 0, nTop + ::nHItem, ::nWidth }
next

::aClient[1] := nTop + ::nHItem
::aClient[2] := 0
::aClient[3] := ::nHeight - (::nHItem * (nLen - ::nOption) )
::aClient[4] := ::nWidth

if ::nOption < nLen
   nCount := 0
   for n := ::nOption+1 to nLen
       nTop := ::aClient[3] + (::nHItem * nCount)
       ::aFolders[n]:aRect := { nTop, 0, nTop + ::nHItem, ::nWidth }
       nCount ++
   next
endif



return ::aClient

*********************************************************************************************************
  METHOD SetOption( nOption ) CLASS TBtnFolder
*********************************************************************************************************
local n
local nOld := ::nOption
local hWnd

for n := 1 to len( ::aFolders )
    if n != nOption
       ::aFolders[n]:Hide()
       hWnd := GetWindow( ::aFolders[n]:hWnd, 5 )
       if hWnd != 0
          ShowWindow( hWnd, 0 )
       endif
    endif
next

::nOption := nOption
hWnd := GetWindow( ::aFolders[::nOption]:hWnd, 5 )
if hWnd != 0
   ShowWindow( hWnd, 8 )
endif

if ::aFolders[::nOption]:bAction != nil
   eval( ::aFolders[::nOption]:bAction )
endif

::GetClientRect()

::aFolders[::nOption]:Move( ::aClient[1],::aClient[2],::aClient[4]-::aClient[2],::aClient[3]-::aClient[1],.t.)
::aFolders[::nOption]:Show()

return nil

**************************************************************************************************************


CLASS TCtrlToolBar FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA cCaption
      DATA oImageList
      DATA aItems
      DATA aRect
      DATA bAction
      DATA nOption
      DATA nFirst
      DATA nHItem
      DATA lDown
      DATA nOver


      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, cCaption, cBmpFile, bAction, bPage ) CONSTRUCTOR
      METHOD AddItem( cCaption, nImage, bAction )

      METHOD Destroy() INLINE  ::oImageList:End(), super:Destroy()

      METHOD LButtonDown( nRow, nCol, nFlags )
      METHOD MouseMove( nRow, nCol, nFlags )
      METHOD LButtonUp( nRow, nCol, nFlags )

      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(),0
      METHOD Paint()

      METHOD VScroll( nWParam, nLParam )
      METHOD MouseWheel( nKey, nDelta, nXPos, nYPos )
      METHOD KeyDown( nKey, nKeyFlags )

ENDCLASS

*******************************************************************************************
   METHOD New( nTop, nLeft, nBottom, nRight, oWnd, cCaption, cBmpFile, bAction, bPage ) CLASS TCtrlToolBar
*******************************************************************************************

   DEFAULT cCaption := ""

   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nBottom
   ::nRight    := nRight
   ::oWnd      := oWnd
   ::aItems    := {}
   ::cCaption  := cCaption
   ::oImageList  := TImageList():New(16,16,cBmpFile)
   ::aRect       := {0,0,0,0}
   ::lDown := .f.
   ::nOver     := 0
   ::nOption   := 1
   ::nFirst    := 1
   ::nHItem    := 22
   ::bAction   := bAction

   ::nStyle    := nOR(   WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_VSCROLL ) //WS_HSCROLL,
   ::nId       := ::GetNewId()

   ::lCaptured := .f.

   ::nClrText := 0
   ::nClrPane := CLR_WHITE //GetSysColor( COLOR_BTNFACE )

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

   DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self

   ::oVScroll:SetRange( 0, 0 )

   if bPage != nil
      eval( bPage, self )
   endif


return Self


*******************************************************************************************
   METHOD AddItem( cCaption, nImage, bAction ) CLASS TCtrlToolBar
*******************************************************************************************
local oItem

oItem := TItemToolBar():New( cCaption, nImage, bAction, self )

aadd( ::aItems, oItem )

::oVScroll:SetRange( 1, len( ::aItems ) )

return oItem



*******************************************************************************************
  METHOD Paint() CLASS TCtrlToolBar
*******************************************************************************************
local n, nLen
local nCount := 0
local nTop   := 0
local nLeft  := 5
local hDCMem, hBmp, hOldBmp
local aRect := GetClientRect(::hWnd)

nLen := len( ::aItems )

if nLen == 0
   return 0
endif

if ::nHItem * nLen < aRect[3]
   ::oVScroll:SetRange( 0, 0 )
else
   ::oVScroll:SetRange( 1, nLen )
endif

hBmp    := CreateCompatibleBitmap( ::hDC, aRect[4], aRect[3] )
hDCMem  := CreateCompatibleDC( ::hDC )
hOldBmp := SelectObject( hDCMem, hBmp )

FillSolidRect( hDCMem, aRect, ::nClrPane )

for n := ::nFirst to nLen
    nTop := ::nHItem * nCount
    ::aItems[n]:Paint( hDCMem, nTop, nLeft,, n == ::nOption, ::nOver != 0 .and. !::lDown .and. ::nOver == n)
    nCount++
next

//  ScrollWindow( ::hWnd, 0, nPos - nOldPos, ::aRectBtn, GetClientRect( ::hWnd ) )
BitBlt( ::hDC, 0, 0, aRect[4], aRect[3], hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmp )
DeleteDC( hDCMem )

return 0

****************************************************************************************************
  METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TCtrlToolBar
****************************************************************************************************
local nItem := int( nRow / ::nHItem )
local nLen := len( ::aItems )

if nLen == 0
   return 0
endif

nItem := ::nFirst + nItem

SetFocus(::hWnd)

::lDown := .t.

if nItem <= nLen
   ::nOption := nItem
   if ::aItems[::nOption]:bAction != nil
      eval( ::aItems[::nOption]:bAction )
   endif
   ::Refresh()
//   ::oVScroll:SetPos( ::nOption )
endif

return 0

****************************************************************************************************
  METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TCtrlToolBar
****************************************************************************************************
::lDown := .f.

return 0



****************************************************************************************************
   METHOD MouseMove( nRow, nCol, nFlags ) CLASS TCtrlToolBar
****************************************************************************************************
local nItem := int( nRow / ::nHItem )
local nLen := len( ::aItems )
nItem := ::nFirst + nItem

if nLen == 0
   return 0
endif

CursorHand()

if nItem <= len( ::aItems )
   ::nOver := nItem
   ::Refresh()
endif

return 0


****************************************************************************************************
  METHOD MouseWheel( nKey, nDelta, nXPos, nYPos ) CLASS TCtrlToolBar
****************************************************************************************************
local nLen := len( ::aItems )
if nLen == 0
   return 0
endif


  if nDelta > 0
     ::KeyDown( VK_UP )
  else
     ::KeyDown( VK_DOWN )
  endif

return nil

return 0

*****************************************************************************************************
   METHOD KeyDown( nKey, nKeyFlags ) CLASS TCtrlToolBar
*****************************************************************************************************
local aRect := GetClientRect(::hWnd)
local nLines := int( aRect[3]/::nHItem)
local nLen := len( ::aItems )
if nLen == 0
   return 0
endif


do case
   case nKey == VK_UP
       ::nOption := max( 1, ::nOption-1)
       if ::nOption < ::nFirst
          ::nFirst--
       endif
       ::Refresh()
       ::oVScroll:SetPos( ::nOption )

   case nKey == VK_DOWN
       ::nOption := min( len(::aItems), ::nOption+1)
       if ::nOption >= ::nFirst + nLines
          ::nFirst++
       endif
       ::Refresh()
       ::oVScroll:SetPos( ::nOption )

   case nKey == VK_HOME
       ::nOption := 1
       ::nFirst := 1
       ::Refresh()
       ::oVScroll:SetPos( 1 )

   case nKey == VK_END
       ::nFirst := len(::aItems)-nLines+1
       ::nOption := len(::aItems)
       ::oVScroll:GoBottom()
       ::Refresh()


endcase


return 0

****************************************************************************************************
  METHOD VScroll( nWParam, nLParam ) CLASS TCtrlToolBar
****************************************************************************************************
local aRect := GetClientRect(::hWnd)
local nLines := int( aRect[3]/::nHItem)

   #ifdef __CLIPPER__
      local nScrollCode := nWParam
   #else
      local nScrollCode := nLoWord( nWParam )
   #endif

   local nPos := nHiWord( nWParam )

   local nLen := len( ::aItems )
   if nLen == 0
      return 0
   endif

   SetFocus(::hWnd)

   do case
      case nScrollCode == SB_LINEUP
           ::nFirst := max( 1, ::nFirst-1)
           ::oVScroll:PageUp()
           ::Refresh()
           return 0

      case nScrollCode == SB_LINEDOWN
           ::nFirst := min( len(::aItems), ::nFirst+1)
           ::oVScroll:PageDown()
           ::Refresh()
           return 0

      case nScrollCode == SB_PAGEUP
           ::nFirst := max( 1, ::nFirst- int( aRect[3]/::nHItem) )
           ::oVScroll:PageUp()
           ::Refresh()
           return 0

      case nScrollCode == SB_PAGEDOWN
           ::oVScroll:PageDown()
           ::nFirst := min( len(::aItems), ::nFirst+ int( aRect[3]/::nHItem) )
           ::Refresh()
           return 0


      case nScrollCode == SB_TOP
           ::nFirst := 1
           ::oVScroll:GoTop()
           ::Refresh()

      case nScrollCode == SB_BOTTOM
           ::nFirst := len(::aItems)-nLines
           ::nOption := len(::aItems)
           ::oVScroll:GoBottom()
           ::Refresh()

       case nScrollCode == SB_THUMBPOSITION

           ::nFirst := nPos
           ::oVScroll:SetPos( nPos )
           ::Refresh( .f. )
           ::oVScroll:ThumbPos( nPos )
           return 0

       case nScrollCode == SB_THUMBTRACK

           nPos := GetScrollInfoPos( ::hWnd, 1 )
           ::nFirst := nPos
           ::Refresh( .f. )
           return 0

      otherwise
           return nil
   endcase

   ::oVScroll:SetPos( ::nOption )

return 0




CLASS TItemToolBar

      DATA cCaption
      DATA nImage
      DATA bAction
      DATA oWnd
      DATA oPage

      METHOD New( cCaption, nImage, bAction, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC, nTop, nLeft, lDisable, lSelected, lOver )
      METHOD PaintContour( hDC, nTop, nLeft, nBottom, nRight, nColor )

ENDCLASS

*****************************************************************************************************
  METHOD New( cCaption, nImage, bAction, oWnd ) CLASS TItemToolBar
*****************************************************************************************************

  ::cCaption := cCaption
  ::nImage   := nImage
  ::bAction  := bAction
  ::oWnd     := oWnd

return self



*****************************************************************************************************
  METHOD Paint( hDC, nTop, nLeft, lDisable, lSelected, lOver ) CLASS TItemToolBar
*****************************************************************************************************

local hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
local nColor
local aRect := GetClientRect(::oWnd:hWnd)

if lDisable  == nil; lDisable  := .f.; endif
if lSelected == nil; lSelected := .f.; endif
if lOver     == nil; lOver     := .f.; endif

if lSelected
   FillSolidRect( hDC, {nTop, 0, nTop + ::oWnd:nHItem, aRect[4] }, RGB( 255,239,187 ) )
   ::PaintContour( hDC, nTop, 0, nTop + ::oWnd:nHItem, aRect[4], rgb(229, 195, 101 ) )
   //DrawEdge( hDC, {nTop, 0, nTop + ::oWnd:nHItem, aRect[4]  }, EDGE_ETCHED, BF_RECT )
else
   if lOver
      ::PaintContour( hDC, nTop, 0, nTop + ::oWnd:nHItem, aRect[4], rgb(229, 195, 101 ) )
      //DrawEdge( hDC, {nTop, 0, nTop + ::oWnd:nHItem, aRect[4] }, BDR_RAISEDINNER, BF_RECT )
   endif
endif

::oWnd:oImageList:Draw( hDC, ::nImage, nTop + ::oWnd:nHItem / 2 - ::oWnd:oImageList:nHeight/2   , nLeft )

nLeft += ::oWnd:oImageList:nWidth + 10

SetBkMode( hDC, 1 )

DrawText( hDC, ::cCaption, {nTop, nLeft, nTop + ::oWnd:nHItem, aRect[4] }, nOR( DT_SINGLELINE, DT_VCENTER ) )

SetBkMode( hDC, 0 )

SelectObject( hDC, hOldFont )

if nColor != nil
   SetTextColor( hDC, nColor )
endif

return 0


*************************************************************************************************
  METHOD PaintContour( hDC, nTop, nLeft, nBottom, nRight, nColor ) CLASS TItemToolBar
*************************************************************************************************
local hPen := ExtCreatePen( 1, nColor )
local hOldPen := SelectObject( hDC, hPen )


Moveto( hDC, nLeft, nTop )
Lineto( hDC, nRight, nTop )
Lineto( hDC, nRight, nBottom )
Lineto( hDC, nLeft, nBottom )
Lineto( hDC, nLeft, nTop )

SelectObject( hDC, hOldPen )
DeleteObject( hPen )


return nil


