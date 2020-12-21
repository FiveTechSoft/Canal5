// Win95 Class TTreeView items support ( TTVItem --> TreeViewItem )

#include "FiveWin.ch"

#define TV_FIRST          4352   // 0x1100
#define TVM_EXPAND        TV_FIRST + 2

#define TVE_COLLAPSE      1
#define TVE_EXPAND        2

static nID

//----------------------------------------------------------------------------//

CLASS TTVItem

   DATA   hItem
   DATA   oTree
   DATA   aItems
   DATA   cPrompt
   DATA   nImage
   DATA   nImage2
   DATA   Cargo
   DATA   nID
   DATA   oParent
   DATA   oLastParent
   DATA   bAction
   DATA   Cargo2

   DATA cRuta        AS CHARACTER INIT ""
   DATA cTipo
   DATA lChgImage
   DATA lFolder
   DATA lMain

   CLASSDATA nInitID INIT 100

   METHOD New( oTree, Cargo, cPrompt, nImage, lChecked, oParent, nImage2, cTipo, lFolder, lChgImage, cRuta  ) CONSTRUCTOR

   METHOD GetNewID()

   METHOD Add( cPrompt, nImage, Cargo, nImage2, lChecked )

   METHOD SetText( cText )   INLINE TREEITEM_SetText( ::oTree:hWnd, ::hItem, cText ), ::cPrompt := cText

   METHOD DeleteBranches()

   METHOD Expand() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_EXPAND, ::hItem )

   METHOD Colapse() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_COLLAPSE, ::hItem )

   METHOD DeleteItem( oItem )

   METHOD GetCheckState()         INLINE GetCheckState( ::oTree:hWnd, ::hItem )
   METHOD SetCheckState( bCheck ) INLINE SetCheckState( ::oTree:hWnd, ::hItem, bCheck )
   METHOD SetImage( nImage )      INLINE SetImage( ::oTree:hWnd, ::hItem, nImage )
   METHOD Copy( lCut )
   METHOD Paste( cInfo, oItem )
   METHOD Save()
   METHOD cFileName()             INLINE  ::cRuta + if( left( ::cRuta, 1 ) == "\","","\" ) + ::cPrompt


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oTree, Cargo, cPrompt, nImage, lChecked, oParent, nImage2, cTipo, lFolder, lChgImage, cRuta ) CLASS TTVItem

   DEFAULT nImage2 := nImage
   DEFAULT lChecked := .t.
   DEFAULT cRuta := ""
   DEFAULT cTipo := ""
   DEFAULT lChgImage := .f.
   DEFAULT lFolder  := .f.

   ::aItems  = {}

   if oParent:ClassName() == "TTREEVIEW"
      ::hItem   = TVInsertItem( oTree:hWnd, cPrompt ,, nImage, nImage2 )
   else
      ::hItem   = TVInsertItem( oTree:hWnd, cPrompt , oParent:hItem, nImage, nImage2 )
   endif

   ::oTree     := oTree
   ::Cargo     := Cargo
   ::cPrompt   := cPrompt
   ::nImage    := nImage
   ::nImage2   := nImage2
   ::nID       := ::GetNewId()
   ::oParent   := oParent
   ::cRuta     := cRuta
   ::cTipo     := cTipo
   ::lChgImage := lChgImage
   ::lFolder   := lFolder
   ::lMain     := .f.

   ::SetCheckState( lChecked )

   aadd( oParent:aItems, self )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, Cargo, nImage2, lChecked ) CLASS TTVItem

   local oItem
   local hItem := TVInsertItem( ::oTree:hWnd, cPrompt,::hItem, nImage, nImage2 )
   DEFAULT nImage2 := nImage

   oItem := TTVItem():New( hItem, ::oTree, Cargo, cPrompt, nImage, lChecked, self )
   AAdd( ::aItems, oItem )

return oItem

//----------------------------------------------------------------------------//

METHOD DeleteBranches() CLASS TTVItem

   Aeval(::aItems, {|o| TVDeleteItem(::oTree:hWnd, o:hItem) } )

   ::aItems  = {}

return nil

METHOD GetNewId() CLASS TTVitem

   DEFAULT ::nInitId := 100

   ::nInitId++

return ::nInitId

*********************************************************************************************************************************
   METHOD DeleteItem() CLASS TTVItem
*********************************************************************************************************************************
local n, nLen
local nItem := 0

nLen := len( ::oParent:aItems )

for n := 1 to nLen
    if ::nID == ::oParent:aItems[n]:nId
       nItem := n
       exit
    endif
next

if nItem > 0
   DeleteTreeItem( ::oTree:hWnd, ::hItem )
   adel( ::oParent:aItems, nItem )
   asize( ::oParent:aItems, nLen-1)
endif

return nil


*********************************************************************************************************************
   METHOD Save() CLASS TTVItem
*********************************************************************************************************************
local cStr := ""
local nLen := len( ::aItems )
local n

cStr += ::cPrompt                                             + CRLF
cStr += str(::nImage)                                         + CRLF
cStr += str(::nImage2)                                        + CRLF
cStr += if(::GetCheckState(),".t.",".f." )                    + CRLF
cStr += ::cRuta                                               + CRLF
cStr += ::cTipo                                               + CRLF
cStr += if(::lChgImage,".t.",".f.")                           + CRLF
cStr += if(::lFolder,".t.",".f.")                             + CRLF
cStr += if(IsExpanded( ::oTree:hWnd, ::hItem ),".t.",".f.")   + CRLF
cStr += alltrim( str( nLen ) )                                + CRLF

for n := 1 to nLen
    cStr += ::aItems[n]:Save()
next

return cStr


*********************************************************************************************************************
   METHOD Copy( lCut ) CLASS TTVItem
*********************************************************************************************************************
local cStr := ""
local oClp

DEFAULT lCut := .f.

if lCut
   ::oTree:oCutItem := self
else
   ::oTree:oCutItem := nil
endif

DEFINE CLIPBOARD oClp FORMAT TEXT

cStr := ::Save(.t.)

if oClp:Open()
   oClp:Clear()
   oClp:SetText( cStr )
   oClp:End()
else
   MsgAlert( "El portapapeles no está disponible en este momento !" )
endif



return nil

*********************************************************************************************************************
   METHOD Paste( oParent ) CLASS TTVItem
*********************************************************************************************************************

  local nProps := 8
  local cPrompt, nImage, nImage2, lCheck, cRuta, cTipo, lChgImage, lFolder
  local oItem
  local oClp
  local cInfo

  DEFINE CLIPBOARD oClp

  cInfo := oClp:GetText()

  if empty( cInfo )
     MsgStop( "No se encuentra información en el portapapeles","Corrija")
     return nil
  endif

//  ::oTree:
  ::oTree:Load( cInfo, oParent )

  ::oTree:Refresh()

  if ::oTree:oCutItem != nil
     ::oTree:oCutItem:DeleteItem()
  endif

  ::oTree:oCutItem := nil

return oItem


#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"
#include <commctrl.h>



HB_FUNC_STATIC( TREEITEM_SETTEXT ) // (hWndTV, hItem, cText)
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   TVITEM pitem;

   pitem.hItem = ( HTREEITEM ) hb_parnl( 2 );
   pitem.mask = TVIF_TEXT;
   pitem.pszText = hb_parc( 3 );
   pitem.cchTextMax = hb_parclen( 3 );

   hb_retl( TreeView_SetItem( ( HWND ) hWnd, ( LPTVITEM )( &pitem ) ) );
}
HB_FUNC_STATIC( DELETETREEITEM )
{
   hb_retnl(TreeView_DeleteItem( ( HWND ) hb_parnl( 1 ), ( HTREEITEM ) hb_parnl( 2 )));
}
HB_FUNC_STATIC( GETCHECKSTATE )
{
   hb_retl( ( LONG ) TreeView_GetCheckState( ( HWND ) hb_parnl( 1 ), ( HTREEITEM ) hb_parnl( 2 ) ) );
}

HB_FUNC_STATIC( SETCHECKSTATE )
{
   TreeView_SetCheckState( ( HWND ) hb_parnl( 1 ), ( HTREEITEM ) hb_parnl( 2 ), hb_parl( 3 ) );
   hb_ret();
}

HB_FUNC_STATIC( SETITEMIMAGE )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   UINT iImage = hb_parni( 3 ) - 1;
   TVITEM pitem;

   pitem.hItem = ( HTREEITEM ) hb_parnl( 2 );
   pitem.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   pitem.iImage = iImage;
   pitem.iSelectedImage = iImage;

   hb_retl( TreeView_SetItem( ( HWND ) hWnd, ( LPTVITEM )( &pitem ) ) );
}



#pragma ENDDUMP

