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


static cFaceName
static nClrReturn

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

       @ 0,0 FOLDER oFld OF oDlg PROMPTS "Colores" PIXEL SIZE 150, 150

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

       //oLbx := TLbxSysColor():New( 0, 0, 75, 70, oFld:aDialogs[2] )

       //oLbx:bLDblClick := { || lPaleta := .f., SetColorReturn( GetSysColor( oLbx:aSysColors[ oLbx:GetPos() ] )), oDlg:End(), lCancel := .f.  }

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


ACTIVATE DIALOG oDlg ON INIT oLbx:Set( cFont )

return cFaceName

function SetFaceNameReturn( cFont )
cFaceName := cFont
return cFaceName



CLASS TLbxFont FROM TListBox

      DATA aSysColors

      METHOD New( nRow, nCol, nWidth, nHeight, oWnd, cFaceName )  CONSTRUCTOR
      METHOD Default()
      METHOD PaintItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap )
      METHOD DrawItem( nIdCtl, nPStruct ) INLINE LbxDrawItem( nPStruct, ::aBitmaps, ::aItems, ::nBmpWidth, ::bDrawItem )


ENDCLASS

*********************************************************************************************
  METHOD New( nRow, nCol, nWidth, nHeight, oWnd, cFaceName ) CLASS TLbxFont
*********************************************************************************************

   local oFont
   local o := self

   ::bSetGet  := bSETGET(cFaceName)
   ::cCaption   := ""
   ::nTop       := nRow
   ::nLeft      := nCol
   ::nBottom    := ::nTop  + nHeight - 1
   ::nRight     := ::nLeft + nWidth - 1
   ::aItems     := aGetFontNamesEx()
   aeval( ::aItems, {|x, nX| ::aItems[nx] := alltrim( x ) } )

   ::aBitmaps   := {}

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
  METHOD PaintItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap ) CLASS TLbxFont
*********************************************************************************************

  local hOldFont
  local iMode := SetBkMode( hDC, TRANSPARENT )
  local oFont

  if lSelected
     FillSolidRect( hDC, rc, GetSysColor( COLOR_HIGHLIGHT ) )
     SetTextColor( hDC, CLR_WHITE )
  else
     FillSolidRect( hDC, rc, CLR_WHITE )
     SetTextColor( hDC, 0 )
  endif

  DEFINE FONT oFont NAME ::aItems[nItem] SIZE 0, -16
  hOldFont := SelectObject( hDC, oFont:hFont )

  DrawText( hDC, ::aItems[nItem], rc, nOr( DT_VCENTER, DT_SINGLELINE ) )

  SelectObject( hDC, hOldFont )
  oFont:End()

  SetBkMode( hDC, iMode )

return 1

METHOD Default()  CLASS TLbxFont

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


function aGetFontNamesEx()

local hDC := GetDC( 0 )
local aFonts := GetFontNames(hDC)
aFonts := asort( aFonts )
ReleaseDC(0,hDC)

return  aFonts










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
