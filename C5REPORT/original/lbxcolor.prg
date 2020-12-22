#include "fivewin.ch"
#include "c5report.ch"

#define ODT_MENU        1
#define ODT_LISTBOX     2
#define ODT_COMBOBOX    3
#define ODT_BUTTON      4
#define ODA_DRAWENTIRE  0x0001
#define ODA_SELECT      0x0002
#define ODA_FOCUS       0x0004
#define ODS_SELECTED    0x0001
#define ODS_GRAYED      0x0002
#define ODS_DISABLED    0x0004
#define ODS_CHECKED     0x0008
#define ODS_FOCUS       0x0010
#define ODS_DEFAULT         0x0020
#define ODS_COMBOBOXEDIT    0x1000

#define LISTBOX_BASE    383
#define LB_ADDSTRING         ( LISTBOX_BASE +  1 )
#define LB_INSERTSTRING      ( LISTBOX_BASE +  2 )
#define LB_DELETESTRING      ( LISTBOX_BASE +  3 )
#define LB_RESETCONTENT      ( LISTBOX_BASE +  5 )
#define LB_SETSEL            ( LISTBOX_BASE +  6 )
#define LB_SETCURSEL         ( LISTBOX_BASE +  7 )
#define LB_GETSEL            ( LISTBOX_BASE +  8 )
#define LB_GETCURSEL         ( LISTBOX_BASE +  9 )
#define LB_GETCOUNT          ( LISTBOX_BASE + 12 )
#define LB_DIR               ( LISTBOX_BASE + 14 )
#define LB_GETSELCOUNT       ( LISTBOX_BASE + 17 )
#define LB_GETSELITEMS       ( LISTBOX_BASE + 18 )
#define LB_ERR                           -1
#define GWL_STYLE           (-16)

#define COLOR_3DDKSHADOW              21
#define COLOR_3DLIGHT                 22
#define COLOR_ACTIVEBORDER            10
#define COLOR_ACTIVECAPTION            2
#define COLOR_APPWORKSPACE            12
#define COLOR_BACKGROUND               1
#define COLOR_BTNFACE                 15
#define COLOR_BTNHIGHLIGHT            20
#define COLOR_BTNSHADOW               16
#define COLOR_BTNTEXT                 18
#define COLOR_CAPTIONTEXT              9
#define COLOR_GRADIENTACTIVECAPTION   27
#define COLOR_GRADIENTINACTIVECAPTION 28
#define COLOR_GRAYTEXT                17
#define COLOR_HIGHLIGHT               13
#define COLOR_HIGHLIGHTTEXT           14
#define COLOR_HOTLIGHT                26
#define COLOR_INACTIVEBORDER          11
#define COLOR_INACTIVECAPTION          3
#define COLOR_INACTIVECAPTIONTEXT     19
#define COLOR_INFOBK                  24
#define COLOR_INFOTEXT                23
#define COLOR_MENU                     4
#define COLOR_MENUTEXT                 7
#define COLOR_SCROLLBAR                0
#define COLOR_WINDOW                   5
#define COLOR_WINDOWFRAME              6
#define COLOR_WINDOWTEXT               8


CLASS TLbxSysColor FROM TListBox

      DATA aSysColors

      METHOD New( nRow, nCol, nWidth, nHeight, oWnd )  CONSTRUCTOR
      METHOD Default()
      METHOD PaintItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap )

ENDCLASS

*********************************************************************************************
  METHOD New( nRow, nCol, nWidth, nHeight, oWnd ) CLASS TLbxSysColor
*********************************************************************************************

   local oFont
   local o := self

   ::bSetGet  := { || nil }
   ::cCaption   := ""
   ::nTop       := nRow
   ::nLeft      := nCol
   ::nBottom    := ::nTop  + nHeight - 1
   ::nRight     := ::nLeft + nWidth - 1
   ::aItems     := {"3ddkshadow",;
                    "3dlight",;
                    "activeborder",;
                    "activecaption",;
                    "appworkspace",;
                    "background",;
                    "btnface",;
                    "btnhighlight",;
                    "btnshadow",;
                    "btntext",;
                    "captiontext",;
                    "gradientactivecaption",;
                    "gradientinactivecaption",;
                    "graytext",;
                    "highlight",;
                    "highlighttext",;
                    "hotlight",;
                    "inactiveborder",;
                    "inactivecaption",;
                    "inactivecaptiontext",;
                    "infobk",;
                    "infotext",;
                    "menu",;
                    "menutext",;
                    "scrollbar",;
                    "window",;
                    "windowframe",;
                    "windowtext" }

   ::aSysColors := { COLOR_3DDKSHADOW,;
                     COLOR_3DLIGHT,;
                     COLOR_ACTIVEBORDER,;
                     COLOR_ACTIVECAPTION,;
                     COLOR_APPWORKSPACE,;
                     COLOR_BACKGROUND,;
                     COLOR_BTNFACE,;
                     COLOR_BTNHIGHLIGHT,;
                     COLOR_BTNSHADOW,;
                     COLOR_BTNTEXT,;
                     COLOR_CAPTIONTEXT,;
                     COLOR_GRADIENTACTIVECAPTION,;
                     COLOR_GRADIENTINACTIVECAPTION,;
                     COLOR_GRAYTEXT,;
                     COLOR_HIGHLIGHT,;
                     COLOR_HIGHLIGHTTEXT,;
                     COLOR_HOTLIGHT,;
                     COLOR_INACTIVEBORDER,;
                     COLOR_INACTIVECAPTION,;
                     COLOR_INACTIVECAPTIONTEXT,;
                     COLOR_INFOBK,;
                     COLOR_INFOTEXT,;
                     COLOR_MENU,;
                     COLOR_MENUTEXT,;
                     COLOR_SCROLLBAR,;
                     COLOR_WINDOW,;
                     COLOR_WINDOWFRAME,;
                     COLOR_WINDOWTEXT }

   ::oWnd       = oWnd
   ::oFont      = oFont

   ::lOwnerDraw = .T.

   ::bDrawItem := {| hDC, nItem, cText, rc, lFocus, lSelected, hBitmap | o:PaintItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap ) }

   ::nStyle     = nOR( LBS_NOTIFY , LBS_OWNERDRAWFIXED , LBS_DISABLENOSCROLL , WS_CHILD , WS_VISIBLE , WS_BORDER , WS_VSCROLL )

   ::nId        = ::GetNewId()
   ::lCaptured  = .f.

   ::SetColor( 0, CLR_WHITE )

   if ! Empty( oWnd:hWnd )
      ::Create( "LISTBOX" )
      ::Default()
      if oFont != nil
         ::SetFont( oFont )
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return Self

*********************************************************************************************
  METHOD PaintItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap ) CLASS TLbxSysColor
*********************************************************************************************

  local rc0 := {rc[1]+3,rc[2]+3,rc[3]-3,rc[2]+25}
  local hOldFont := SelectObject( hDC, GetStockObject( DEFAULT_GUI_FONT ) )
  local iMode := SetBkMode( hDC, TRANSPARENT )

  if lSelected
     FillSolidRect( hDC, rc, GetSysColor( COLOR_HIGHLIGHT ) )
     SetTextColor( hDC, CLR_WHITE )
  else
     FillSolidRect( hDC, rc, CLR_WHITE )
     SetTextColor( hDC, 0 )
  endif


  FillSolidRect( hDC, rc0, GetSysColor( ::aSysColors[ nItem ] ), 0 )

  rc0 := {rc[1]  ,rc[2]+30,rc[3]  ,rc[4]}

  DrawText( hDC, ::aItems[nItem], rc0, nOr( DT_VCENTER, DT_SINGLELINE ) )

  SelectObject( hDC, hOldFont )
  SetBkMode( hDC, iMode )

return 1

METHOD Default()  CLASS TLbxSysColor

   local nAt
   local cStart := ::aItems[1]
   local aFiles

   DEFAULT cStart := ""


   AEval( ::aItems,;
           { | cItem, nAt | If( cItem == nil, ::aItems[ nAt ] := "",),;
                           ::SendMsg( LB_ADDSTRING, 0, If( cItem == nil, "", cItem ) ) } )

   if ValType( cStart ) != "N"
      nAt = AScan( ::aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
                                         Upper( AllTrim( cStart ) ) } )
   else
      nAt = cStart
   endif

   if nAt != 0
      ::SendMsg( LB_SETCURSEL, nAt - 1 )
   else
      ::SendMsg( LB_SETCURSEL, 0 )
   endif

return nil



function LbxDrawItem( nPStruct, aBitmaps, aItems, nBmpWidth, bDrawItem )

local aInfo := GetDrawItemStruct( nPStruct )
local CtlType    := aInfo[1]
local CtlID      := aInfo[2]
local itemID     := aInfo[3]
local itemAction := aInfo[4]
local itemState  := aInfo[5]
local hWndItem   := aInfo[6]
local hDC        := aInfo[7]
local nTop       := aInfo[8]
local nLeft      := aInfo[9]
local nBottom    := aInfo[10]
local nRight     := aInfo[11]
local rgbFore, rgbBack

do case
   case itemAction == ODA_DRAWENTIRE .or. itemAction == ODA_SELECT

        if lAnd( itemState, ODS_FOCUS )
           DrawFocusRect( hDC, nTop,nLeft,nBottom,nRight )
        endif

        if lAnd( itemState, ODS_SELECTED )
           rgbFore := SetTextColor( hDC, GetSysColor( COLOR_HIGHLIGHTTEXT ) )
           rgbBack := SetBkColor( hDC, GetSysColor( COLOR_HIGHLIGHT ) )
           FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, GetSysColor( COLOR_HIGHLIGHT ) )
        else
           FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, CLR_WHITE	 )
        endif

        //if bDrawItem == nil
           DrawText( hDC, aItems[itemID + 1], {nTop, nLeft + 2, nBottom, nRight}, nOr( DT_VCENTER, DT_SINGLELINE ) )
        //endif

        if lAnd( itemState, ODS_SELECTED )
           SetTextColor( hDC, rgbFore )
           SetBkColor( hDC, rgbBack )
        endif

        if lAnd( itemState, ODS_FOCUS )
           DrawFocusRect( hDC, nTop, nLeft, nBottom, nRight )
        endif

        if bDrawItem != nil
           return eval( bDrawItem, hDC, itemID+1, aItems[itemID+1], {nTop, nLeft, nBottom, nRight}, lAnd( itemState, ODS_FOCUS ),lAnd( itemState, ODS_SELECTED ), if( len( abitmaps ) > 0, aBitmaps[itemID+1],0) )
        endif

endcase

return nil












#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

HB_FUNC( GETDRAWITEMSTRUCT )
{
   LPDRAWITEMSTRUCT lp = ( LPDRAWITEMSTRUCT ) hb_parnl( 1 );

   hb_reta( 12 );

   hb_storni( lp->CtlType      ,    -1, 1  );
   hb_storni( lp->CtlID        ,    -1, 2  );
   hb_storni( lp->itemID       ,    -1, 3  );
   hb_storni( lp->itemAction   ,    -1, 4  );
   hb_storni( lp->itemState    ,    -1, 5  );
   hb_storni( ( LONG ) lp->hwndItem     ,    -1, 6  );
   hb_storni( ( LONG ) lp->hDC          ,    -1, 7  );
   hb_storni( lp->rcItem.top   ,    -1, 8  );
   hb_storni( lp->rcItem.left  ,    -1, 9  );
   hb_storni( lp->rcItem.bottom,    -1, 10 );
   hb_storni( lp->rcItem.right ,    -1, 11 );
   hb_stornd( lp->itemData     ,    -1, 12 );

}




#pragma ENDDUMP
