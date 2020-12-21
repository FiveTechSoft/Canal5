// Win32 TreeView support

#include "FiveWin.ch"
#include "Constant.ch"
#include "fileio.ch"

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_BTNSHADOW     16
#define COLOR_BTNHIGHLIGHT  20

#define FD_BORDER            8
#define FD_HEIGHT           22

#define DT_CENTER            1
#define DT_VCENTER           4

#define WINDING              2
#define SC_KEYMENU       61696   // 0xF100

#define TVS_HASBUTTONS       1
#define TVS_HASLINES         2
#define TVS_LINESATROOT      4
#define TVS_EDITLABELS       8
#define TVS_SHOWSELALWAYS   32 //   0x0020
#define TVS_DISABLEDRAGDROP 16 //   0x0010
#define TVS_CHECKBOXES     256

#define TV_FIRST                0x1100      // TreeView messages
#define TVM_EDITLABEL          4366
#define TVM_ENDEDITLABELNOW     (TV_FIRST + 22)

#define WM_ERASEBKGND 20 //0x0014


#ifdef __CLIPPER__
   #define CTRL_NAME "SysTreeView"
#else
   #define CTRL_NAME "SysTreeView32"
#endif

#define TVN_FIRST               -400       // treeview
#define TVN_ITEMEXPANDED       -406

#define NM_CUSTOMDRAW           -12



#define CDDS_ITEM               65536 //0x00010000

#define CDDS_PREPAINT           1    // 0x00000001
#define CDDS_POSTPAINT          2    // 0x00000002
#define CDDS_PREERASE           3    // 0x00000003
#define CDDS_POSTERASE          4    // 0x00000004
// the 0x000010000 bit means it's individual item specific

#define CDDS_ITEMPREPAINT       nOr(65536, 1)
#define CDDS_ITEMPOSTPAINT      nOr(65536, 2)
#define CDDS_ITEMPREERASE       nOr(65536, 3)
#define CDDS_ITEMPOSTERASE      nOr(65536, 4)

#define CDIS_SELECTED       1           // 0x0001
#define CDIS_GRAYED         2           // 0x0002
#define CDIS_DISABLED       4           // 0x0004
#define CDIS_CHECKED        8           // 0x0008
#define CDIS_FOCUS          16          // 0x0010
#define CDIS_DEFAULT        32          // 0x0020
#define CDIS_HOT            64          // 0x0040
#define CDIS_MARKED         128         // 0x0080
#define CDIS_INDETERMINATE  256         // 0x0100

#define CDRF_DODEFAULT          0
#define CDRF_NEWFONT            2       // 0x00000002
#define CDRF_NOTIFYPOSTPAINT   16       // 0x00000010
#define CDRF_NOTIFYITEMDRAW    32       // 0x00000020

//----------------------------------------------------------------------------//

CLASS TTreeView FROM TControl

   DATA   aItems
   DATA   oImageList
   DATA   bChanged
   DATA   oGet
   DATA   aRet
   DATA   hBold, hOldFont
   DATA   lMain
   DATA   lDobleBuffer AS LOGICAL INIT .T.

   DATA   oCutItem

   METHOD New( nTop, nLeft, oWnd, nClrFore,nClrBack, lPixel, lDesign, nWidth, nHeight,cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CONSTRUCTOR

   METHOD Add( cPrompt, nImage, lChecked )
   METHOD ColapseAll()                INLINE ScanItems( ::aItems, .f. )
   METHOD DeleteAll()                 INLINE ( TVDelAllItems( ::hWnd ), ::aItems := {} )
   METHOD Display()                   INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD Expand()                    INLINE AEval( ::aItems, { | oItem | oItem:Expand() } )
   METHOD ExpandAll()                 INLINE ScanItems( ::aItems, .t. )
   METHOD Find( bFind, aItems )
   METHOD GetItem( hItem )
   METHOD GetSelText()                INLINE TVGetSelText( ::hWnd )
   METHOD GetSelected()
   METHOD HScroll( nWParam, nLParam ) VIRTUAL
   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD HitTest(nRow, nCol)
   METHOD KeyDown( nKey, nFlags )
   METHOD LDblCLick( nRow, nCol )
   METHOD Load( cInfo, oParent, nFrom )
   METHOD LoadFile( cFileName )
   METHOD Notify( nIdCtrl, nPtrNMHDR )
   METHOD OnBeginDrag()               INLINE  MsgInfo(  "OnBeginDrag()     " )
   METHOD OnBeginLabelEdit()
   METHOD OnBeginRDrag()              INLINE  MsgInfo(  "OnBeginRDrag()    " )
   METHOD OnItemExpanded(hItem)
   METHOD Paint()
   METHOD Save()
   METHOD SaveFile( oItem, cFileName )
   METHOD SelChanged()                INLINE If( ::bChanged != nil, Eval( ::bChanged, Self ), nil )
   METHOD Select( oItem )             INLINE TVSelect( ::hWnd, oItem:hItem )
   METHOD SetImageList( oImageList )
   METHOD VScroll( nWParam, nLParam ) VIRTUAL   // standard behavior requested
   METHOD aGetItems( bEval, aItems )
   METHOD aGetItemsAux( bEval, aItems )
   METHOD DispBegin( lCreateDC )
   METHOD DispEnd( aRestore )
   METHOD aevalitems( aItems, bEval )

ENDCLASS



//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nClrFore, nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CLASS TTreeView

   DEFAULT nTop     := 0, nLeft := 0,;
           oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200, nHeight := 150

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP,;
                      TVS_HASBUTTONS, TVS_HASLINES, TVS_LINESATROOT, TVS_SHOWSELALWAYS, TVS_EDITLABELS ) // TVS_DISABLEDRAGDROP,

   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::oFont     = TFont():New( "Ms Sans Serif", 0, -9 )
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::aItems    = {}
   ::oGet      = nil
   ::aRet      = {}
   ::oCutItem  = nil
   ::lMain     = .f.

   if !Empty( oWnd:hWnd )
      ::Create( CTRL_NAME )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CLASS TTreeView

   DEFAULT oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lDesign  := .f.

   ::nId     = nId
   ::oWnd    = oWnd
   ::aItems  = {}

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW, TVS_HASBUTTONS, TVS_HASLINES, TVS_LINESATROOT, TVS_EDITLABELS  ) )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, cCargo, nImage2, lChecked ) CLASS TTreeView

   local oItem
   local hItem := TVInsertItem( ::hWnd, cPrompt,, nImage, nImage2 )
   DEFAULT nImage2 := nImage
   DEFAULT lChecked := .t.


   oItem := TTVItem():New( hItem, Self, cCargo, cPrompt, nImage, lChecked, self )
   AAdd( ::aItems, oItem )

return oItem

//----------------------------------------------------------------------------//

static function ScanItem( aItems, hItem )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := ScanItem( aItems[ n ]:aItems, hItem ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:hItem == hItem
         return aItems[ n ]
      endif
   next

return nil

//----------------------------------------------------------------------------//

static function ScanItems( aItems, lExpand )

   local oItem, i

   DEFAULT lExpand := .t.

   for i := 1 to Len( aItems )
       oItem = aItems[ i ]

       if lExpand
          oItem:Expand()
       else
          oItem:Colapse()
       endif

       if Len( oItem:aItems ) != 0
          ScanItems( oItem:aItems )
       endif
   next

return nil


METHOD AevalItems( aItems, bEval ) CLASS TTreeView

   local oItem, i

   for i := 1 to Len( aItems )
       oItem = aItems[ i ]
       eval( bEval, oItem )
       if Len( oItem:aItems ) != 0
          ::AevalItems( oItem:aItems, bEval )
       endif
   next

return nil



//----------------------------------------------------------------------------//

METHOD GetSelected() CLASS TTreeView

return ScanItem( ::aItems, TVGetSelected( ::hWnd ) )

//----------------------------------------------------------------------------//

METHOD GetItem( hItem ) CLASS TTreeView

return ScanItem( ::aItems, hItem )

//----------------------------------------------------------------------------//

METHOD HitTest(nRow, nCol) CLASS TTreeView

   local hItem

   hItem := TVHitTest( ::hWnd, nRow, nCol )

   If hItem > 0
      return ::GetItem( hItem )
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD SetImageList( oImageList ) CLASS TTreeView

   ::oImageList = oImageList

   TVSetImageList( ::hWnd, oImageList:hImageList, 0 )

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TTreeView

   local aInfo := ::DispBegin()
   local hBrush := CreateSolidBrush( CLR_WHITE )

   FillRect( ::hDC, GetClientRect( ::hWnd ), hBrush )
   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )
   DeleteObject( hBrush )
   ::DispEnd( aInfo )

return nil

METHOD OnItemExpanded( hItem ) CLASS TTreeview
local oItem


if hItem != nil
   oItem := ::GetItem( hItem )
   if oItem:lFolder .and. oItem:lChgImage
      if IsExpanded( ::hWnd, hItem )
         SetImage( ::hWnd, hItem, 7 )
      else
         SetImage( ::hWnd, hItem, 6 )
      endif
   endif
endif

return nil

METHOD OnBeginLabelEdit( hEdit ) CLASS TTreeview

  ShowWindow( hEdit, 0 )
  SetFocus( hEdit )

return nil


return nil

METHOD Find( bFind, aItems ) CLASS TTreeview

   LOCAL oItem, oReturn

   DEFAULT aItems := ::aItems

   FOR EACH oItem IN aItems

       if Len( oItem:aItems ) > 0
          if ( oReturn := ::Find( bFind, oItem:aItems ) ) != NIL
             return oReturn
          endif
       endif

       if eval( bFind, oItem )
          return oItem
       endif

   next

return nil

*********************************************************************************************************************************
   METHOD aGetItems( bEval, aItems ) CLASS TTreeview
*********************************************************************************************************************************

   DEFAULT aItems := ::aItems

   ::aRet := {}

return ::aGetItemsAux( bEval, aItems )




*********************************************************************************************************************************
   METHOD aGetItemsAux( bEval, aItems ) CLASS TTreeview
*********************************************************************************************************************************
   local oItem, i

   for i := 1 to Len( aItems )
       oItem = aItems[ i ]
       if Len( oItem:aItems ) != 0
          ::aGetItemsAux( bEval, oItem:aItems )
       endif
       if eval( bEval, oItem )
          aadd( ::aRet, oItem )
       endif
   next


return ::aRet

*********************************************************************************************************************************
   METHOD LDblCLick( nRow, nCol ) CLASS TTreeview
*********************************************************************************************************************************
local oItem := ::HitTest( nRow, nCol )

if oItem != nil
   if oItem:bAction != nil
      eval( oItem:bAction, oItem )
   else
      if Aplicacion():oProyecto != nil
         Aplicacion():oProyecto:ActionTree( oItem )
      endif
   endif
endif

return nil



*********************************************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TTreeview
*********************************************************************************************************************************


do case
   case nKey == VK_DELETE
        Aplicacion():oProyecto:Borrar( ::GetSelected() )
   case nKey == VK_ADD
        Aplicacion():oProyecto:AddExistFileToFolder( ::GetSelected() )
endcase

return super:KeyDown( nKey, nFlags )

*********************************************************************************************************************************
   METHOD SaveFile( oItem, cFileName ) CLASS TTreeview
*********************************************************************************************************************************
local h
local cStr := ""
local n, nLen

DEFAULT oItem := self

nLen := len( oItem:aItems )

if nLen == 0
   MsgStop( "No encuentro elementos en el arbol","Atención" )
   return nil
endif

h := fcreate( cFileName )

cStr += alltrim( str( len(oItem:aItems) ) ) + CRLF

for n := 1 to nLen
    cStr += oItem:aItems[n]:Save()
next

cStr := strtran( cStr, CRLF, chr(9) )

fwrite( h, cStr )
fclose( h )

return nil

*********************************************************************************************************************
   METHOD Save() CLASS TTreeView
*********************************************************************************************************************
local cStr := ""
local nLen := len( ::aItems )
local n


for n := 1 to nLen
    cStr += ::aItems[n]:Save()
next

return cStr



*********************************************************************************************************************************
   METHOD LoadFile( cFileName ) CLASS TTreeview
*********************************************************************************************************************************
local h
local nSize := fsize( cFileName )
local buffer
local nItems, n
local nFrom := 1

if nSize == 0
   MsgInfo( "No encuentro el fichero " + cFileName, "Atención" )
   return nil
endif
buffer := space( nSize )

h := fopen( cFileName, FO_READ )
fread( h, @buffer, nSize )
fclose( h )

buffer := strtran( buffer, chr(9), CRLF )


// leo los items de primer nivel
nItems  := val( alltrim( memoline( buffer,,nFrom)))

for n := 1 to nItems
    nFrom++
    ::Load( buffer, self, @nFrom )
next



return nil

*********************************************************************************************************************
   METHOD Load( cInfo, oParent, nFrom ) CLASS TTreeview
*********************************************************************************************************************
local cPrompt, nImage, nImage2, lCheck, cRuta, cTipo, lChgImage, lFolder, nItems, oItem, lIsExpand
local n

DEFAULT nFrom := 1

    cPrompt   :=      alltrim( memoline( cInfo,,  nFrom))                   //cStr += ::cPrompt                                             + CRLF
    nImage    := val( alltrim( memoline( cInfo,,++nFrom)))                  //cStr += str(::nImage)                                         + CRLF
    nImage2   := val( alltrim( memoline( cInfo,,++nFrom)))                  //cStr += str(::nImage2)                                        + CRLF
    lCheck    := if(  alltrim( memoline( cInfo,,++nFrom))==".t.",.t.,.f.)   //cStr += if(::GetCheckState(),".t.",".f." )                    + CRLF
    cRuta     :=      alltrim( memoline( cInfo,,++nFrom))                   //cStr += ::cRuta                                               + CRLF
    cTipo     :=      alltrim( memoline( cInfo,,++nFrom))                   //cStr += ::cTipo                                               + CRLF
    lChgImage := if(  alltrim( memoline( cInfo,,++nFrom))==".t.",.t.,.f.)   //cStr += if(::lChgImage,".t.",".f.")                           + CRLF
    lFolder   := if(  alltrim( memoline( cInfo,,++nFrom))==".t.",.t.,.f.)   //cStr += if(::lFolder,".t.",".f.")                             + CRLF
    lIsExpand := if(  alltrim( memoline( cInfo,,++nFrom))==".t.",.t.,.f.)   //cStr += if(IsExpanded( ::oTree:hWnd, ::hItem ),".t.",".f.")   + CRLF
    nItems    := val( alltrim( memoline( cInfo,,++nFrom)))


    oItem := TTVItem():New( self,, cPrompt, nImage, lCheck, oParent, nImage2,cTipo, lFolder, lChgImage, cRuta )
    for n := 1 to nItems
        nFrom++
        ::Load( cInfo, oItem, @nFrom )
    next
    if lIsExpand
       oItem:Expand()
    endif

return oItem

//***************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TTreeview
//***************************************************************************************************
Local hBrush

if nMsg == WM_ERASEBKGND
   return 1
endif


return super:HandleEvent( nMsg, nWParam, nLParam )



//***************************************************************************************************
   METHOD Notify( nIdCtrl, nPtrNMHDR )  CLASS TTreeview
//***************************************************************************************************

  local nCode := GetNMHDRCode( nPtrNMHDR )
  local nDrawStage
  local hItem
  local uItemState
  local hDC
  local aRect
  local oItem

  do case
     case nCode == TVN_ITEMEXPANDED

          return ::OnItemExpanded( GetItemExpanded( nPtrNMHDR ) )

     case nCode == NM_CUSTOMDRAW

          nDrawStage := DrawStage( nPtrNMHDR )

          do case
             case nDrawStage == CDDS_PREPAINT

                  return CDRF_NOTIFYITEMDRAW

             case nDrawStage == CDDS_ITEMPREPAINT

                  hItem      := GetItemPrePaint( nPtrNMHDR )
                  oItem      := ::GetItem( hItem )
                  uItemState := UItemState     ( nPtrNMHDR )
                  hDC        := Getnmcdhcd     ( nPtrNMHDR )

                  if oItem != nil .and. oItem:lMain
                     ::hBold    := CreateBold     ( ::oFont:hFont )
                     ::hOldFont := SelectObject( hDC, ::hBold )
                  endif
                  return 2

             case nDrawStage == CDDS_POSTPAINT
                  return CDRF_NOTIFYPOSTPAINT


             case nDrawStage == CDDS_ITEMPOSTPAINT

                  hDC := Getnmcdhcd( nPtrNMHDR )
                  aRect := GetItemRect( .t. )
                  hItem      := GetItemPrePaint( nPtrNMHDR )
                  oItem      := ::GetItem( hItem )

                  //DrawText( hDC, "sdfasdfasdfasdf", aRect, 4)

                  if oItem != nil .and. oItem:lMain
                     SelectObject( hDC, ::hOldFont )
                     DeleteObject( ::hFont )
                  endif

                  return 2


          endcase

  endcase

return nil

METHOD DispBegin() CLASS TTreeview

   local aInfo
   if ::lDobleBuffer
      aInfo = FWDispBegin( ::hWnd, ::hDC )
      ::hDC = aInfo[ 3 ]  // Memory hDC
   endif
return aInfo

//----------------------------------------------------------------------------//

METHOD DispEnd( aRestore ) CLASS TTreeview

   if ::lDobleBuffer
      FWDispEnd( aRestore )
      ::hDC = aRestore[ 2 ]
   endif

return nil



*********************************************************************************************************************************
*********************************************************************************************************************************
*********************************************************************************************************************************
*********************************************************************************************************************************



#pragma BEGINDUMP
#include <windows.h>
#include <hbapi.h>
#include <commctrl.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
//#include "hbfast.h"

UINT GetItemState(HWND hWnd, HTREEITEM hItem, UINT nStateMask )
{
#if (_WIN32_IE >= 0x0500) && !defined(_WIN32_WCE)
      return (UINT)::SendMessage(hWnd, TVM_GETITEMSTATE, (WPARAM)hItem, (LPARAM)nStateMask);
#else //!((_WIN32_IE >= 0x0500) && !defined(_WIN32_WCE))
      TVITEM item = { 0 };
      item.hItem = hItem;
      item.mask = TVIF_STATE;
      item.state = 0;
      item.stateMask = nStateMask;
      ::SendMessage(m_hWnd, TVM_GETITEM, 0, (LPARAM)&item);
      return item.state;
#endif //!((_WIN32_IE >= 0x0500) && !defined(_WIN32_WCE))
}

HB_FUNC( TVGETITEMSTATE )
{
   hb_retni( GetItemState( (HWND) hb_parnl( 1 ),(HTREEITEM) hb_parnl(2), hb_parni(3) ) );
}

HB_FUNC( ISEXPANDED )
{
      hb_retl( (GetItemState( (HWND) hb_parnl(1), (HTREEITEM) hb_parnl(2), TVIS_STATEIMAGEMASK  ) & TVIS_EXPANDED ) );
}


BOOL SetItem(HWND m_hWnd, HTREEITEM hItem, UINT nMask, LPCTSTR lpszItem, int nImage,
                int nSelectedImage, UINT nState, UINT nStateMask, LPARAM lParam)
{
   TVITEM item = { 0 };
   item.hItem = hItem;
   item.mask = nMask;
   item.pszText = (LPTSTR) lpszItem;
   item.iImage = nImage;
   item.iSelectedImage = nSelectedImage;
   item.state = nState;
   item.stateMask = nStateMask;
   item.lParam = lParam;
   return (BOOL)SendMessage(m_hWnd, TVM_SETITEM, 0, (LPARAM)&item);
}

HB_FUNC( GETITEMDATA )
{
   TVITEM item = { 0 };
   item.hItem = (HTREEITEM) hb_parnl( 2 );
   item.mask = TVIF_PARAM;
   SendMessage( (HWND) hb_parnl( 1 ), TVM_GETITEM, 0, (LPARAM)&item);
   hb_retni( item.lParam );
}

HB_FUNC( SETITEMDATA )
{
      SetItem( (HWND) hb_parnl( 1 ), (HTREEITEM) hb_parnl( 2 ), TVIF_PARAM, NULL, 0, 0, 0, 0, (LPARAM) hb_parni( 3 ) );
      hb_ret();
}

HB_FUNC( SETIMAGE )
{
   hb_retl(  SetItem((HWND)hb_parnl(1),(HTREEITEM)hb_parnl(2), TVIF_IMAGE|TVIF_SELECTEDIMAGE, NULL, hb_parni(3),hb_parni(3), 0, 0, NULL) );
}


HB_FUNC( TVINSERTITEM ) // ( hWnd, cItemText, hItem, nImage )
{
   TV_INSERTSTRUCT is;

   ZeroMemory( ( char * ) &is, sizeof( TV_INSERTSTRUCT ) );

   is.hParent      = ( HTREEITEM ) hb_parnl( 3 );
   is.hInsertAfter = TVI_LAST;

   #if (_WIN32_IE >= 0x0400)
      is.DUMMYUNIONNAME.item.pszText = hb_parc( 2 );
      is.DUMMYUNIONNAME.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.DUMMYUNIONNAME.item.iImage  = hb_parnl( 4 );
      is.DUMMYUNIONNAME.item.iSelectedImage = hb_parnl( 5 );
   #else
      is.item.pszText = hb_parc( 2 );
      is.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.item.iImage  = hb_parnl( 4 );
      is.item.iSelectedImage = hb_parnl( 5 );
   #endif

   hb_retnl( SendMessage( ( HWND ) hb_parnl( 1 ), TVM_INSERTITEM, 0,
           ( LPARAM )( LPTV_INSERTSTRUCT )( &is ) ) );
}


//BOOL TreeView_GetCheckState(HWND hwndTreeView, HTREEITEM hItem)
HB_FUNC( TVGETSTATE )
{
    TVITEM tvItem;
    HWND hwndTreeView = (HWND) hb_parnl( 1 );
    HTREEITEM hItem = (HTREEITEM) hb_parnl( 2 );

    // Prepare to receive the desired information.
    tvItem.mask = TVIF_HANDLE | TVIF_STATE;
    tvItem.hItem = hItem;
    tvItem.stateMask = TVIS_STATEIMAGEMASK;

    // Request the information.
    TreeView_GetItem(hwndTreeView, &tvItem);

    // Return zero if it's not checked, or nonzero otherwise.
    hb_retl( ((BOOL)(tvItem.state >> 12) -1));
}

HB_FUNC_STATIC( GETITEMRECT )
{
   BOOL fItemRect = hb_parl( 2 );
   RECT rc;
   SendMessage( (HWND) hb_parnl(1), TVM_GETITEMRECT,  fItemRect, (long)&rc );
   hb_reta(4);
   hb_storvni( rc.top    ,-1, 1 );
   hb_storvni( rc.left   ,-1, 2 );
   hb_storvni( rc.bottom ,-1, 3 );
   hb_storvni( rc.right  ,-1, 4 );
}

HB_FUNC_STATIC( GETITEMEXPANDED )
{
   LPNMTREEVIEW pnmtv = (LPNMTREEVIEW) hb_parnl( 1 );
   TVITEM vItem = pnmtv->itemNew;
   hb_retnl((long)vItem.hItem );
}

HB_FUNC_STATIC( DRAWSTAGE )
{
   LPNMTVCUSTOMDRAW pNMTVCD = (LPNMTVCUSTOMDRAW)hb_parnl( 1 );
   hb_retnl( pNMTVCD->nmcd.dwDrawStage );
}

HB_FUNC_STATIC( GETITEMPREPAINT )
{
   LPNMTVCUSTOMDRAW pNMTVCD = (LPNMTVCUSTOMDRAW)hb_parnl( 1 );

   hb_retnl( (long)((HTREEITEM) pNMTVCD->nmcd.dwItemSpec) );
}




HB_FUNC_STATIC( UITEMSTATE )
{
   LPNMTVCUSTOMDRAW pNMTVCD = (LPNMTVCUSTOMDRAW)hb_parnl( 1 );
   hb_retni( pNMTVCD->nmcd.uItemState );
}


HB_FUNC_STATIC( ISUITEMSTATE )
{
    UINT uItemState = (UINT) hb_parni( 1 );
    hb_retl( ( (int)uItemState & hb_parni(2) ) == hb_parni(2) );
}

HB_FUNC_STATIC( GETNMCDHCD )
{
   LPNMTVCUSTOMDRAW pNMTVCD = (LPNMTVCUSTOMDRAW)hb_parnl( 1 );

   hb_retnl( (long) pNMTVCD->nmcd.hdc );

}


#pragma ENDDUMP



