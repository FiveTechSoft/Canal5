#include "fivewin.ch"

static nError
static oCode
static aCopys := {}

static WM_GOPREVDOC
static WM_GONEXTDOC
#define WM_SYSKEYDOWN                                                        260


#define CW_USEDEFAULT      32768

CLASS TCodeMax FROM TControl

      DATA cFileName
      DATA nMaxLenAcopys

      CLASSDATA lRegisterd AS LOGICAL
      CLASSDATA hLib

      CLASSDATA nInst AS NUMERIC INIT 0


      METHOD New( nRow, nCol, oWnd, nWidth, nHeight ) CONSTRUCTOR
      METHOD End()


      METHOD lCanCopy()                    INLINE CM_CanCopy()
      METHOD lCanPaste()                   INLINE CM_CanPaste()

      METHOD Open( cFileName )

      METHOD Save()
      METHOD SaveAs( cFileName )
      METHOD SaveToFile( cFileName )

      METHOD Copy()
      METHOD Paste( cText )
      METHOD GetSel()                      INLINE CM_GetSel( ::hWnd )
      METHOD SetSel( nLine1, nCol1, nLine2, nCol2 ) INLINE CM_SetSel( ::hWnd, nLine1, nCol1, nLine2, nCol2 )

      METHOD GetLine( nLine )              INLINE CM_GetLine  ( ::hWnd, nLine )
      METHOD GetLineLen( nLine )           INLINE CM_GetLineLength  ( ::hWnd, nLine, .t. )
      METHOD GetLineCount()                INLINE CM_GetLineCount  ( ::hWnd )
      METHOD GetText()                     INLINE CM_GetText       ( ::hWnd )
      METHOD GetLenght()                   INLINE CM_GetTextLength ( ::hWnd )

      METHOD Msg( nError )                 INLINE if( nError != 1, MsgAlert( {"Mal argumento","Falló"}[nError+2] ),)

  //    METHOD LButtonDown( nRow, nCol, nKeyFlags )
      METHOD MouseMove( nRow, nCol, nKeyFlags )
      METHOD KeyDown( nKey, nFlags )
      METHOD SetVSplitter()                INLINE CM_EnableSplitter(::hWnd, .f., .t. )
      METHOD SetHSplitter()                INLINE CM_EnableSplitter(::hWnd, .t., .t. )
      METHOD SetVScrollBar()               INLINE CM_ShowScrollBar(::hWnd,.f.,.t.)
      METHOD SetHScrollBar()               INLINE CM_ShowScrollBar(::hWnd,.t.,.t.)
      METHOD SetLineNumber( lOn, nStart, nStyle ) INLINE CM_SetLineNumbering(::hWnd, lOn, nStart, nStyle )
      METHOD GetColors()                   INLINE CM_GetColors( ::hWnd )
      METHOD SetColors( aColors )          INLINE MsgInfo( CM_SetColors( ::hWnd, aColors ) )
      METHOD SetLineNumberColor( nClrText, nClrPane )

      METHOD InsertLine( nLine, cText )    INLINE CM_InsertLine( ::hWnd, nLine, cText )
      METHOD InsertText( nLine, nCol, cText )    INLINE CM_InsertText( ::hWnd, cText, nLine, nCol )

      METHOD SetPos( nLine, nCol )         INLINE CM_SetCaretPos( ::hWnd, nLine, nCol )
      METHOD Indent( nSpaces, lRight )
      METHOD SetAutoIndentMode( nMode )    INLINE CM_SetAutoIndentMode( ::hWnd, nMode )
      METHOD HandleEvent( nMsg, nWParam, nLParam )


ENDCLASS


/*********************************************************************/
      METHOD End() CLASS TCodeMax
/*********************************************************************/

::nInst --

CMUnregisterControl()
if ::nInst == 0
   FreeLibrary( ::hLib )
endif

return Super:End()



/*********************************************************************/
  METHOD New( nRow, nCol, nWidth, nHeight, oWnd ) CLASS TCodeMax
/*********************************************************************/

DEFAULT nRow := 0, nCol := 0, nWidth := 100, nHeight := 100

   ::nTop     = nRow
   ::nLeft    = nCol
   ::nBottom  = nRow + nHeight
   ::nRight   = nCol + nWidth
   ::oWnd     = oWnd
   ::nStyle   = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP  )
   ::nId       = ::GetNewId()
   ::nMaxLenAcopys = 20

   //::SetColor( 0, CLR_WHITE )
   DEFINE BRUSH ::oBrush STYLE "NULL"

   if ::nInst == 0
      ::hLib := LoadLibrary( "cmax20.dll" )
      ::nInst ++
   endif
   CMRegisterControl()

   //::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create("CODEMAX")
      //::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::bGotFocus := {|| SetCodeMax( self ) }

   WM_GOPREVDOC := RegisterWindowMessage( "WM_GOPREVDOC" )
   WM_GONEXTDOC := RegisterWindowMessage( "WM_GONEXTDOC" )

   ::SetVScrollBar()
   ::SetHScrollBar()
   ::SetVSplitter()
   ::SetHSplitter()


return Self




/*********************************************************************/
//  METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TCodeMax
/*********************************************************************/


//return 0

/*********************************************************************/
  METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TCodeMax
/*********************************************************************/


return CallWindowProc( ::nOldProc, ::hWnd, WM_MOUSEMOVE, nKeyFlags, nMakeLong( nCol, nRow ) )


function SetCodeMax( oCodemax )
oCode := oCodeMax
return nil

function GetCurrentCode()
return oCode


/*********************************************************************/
  METHOD KeyDown( nKey, nFlags ) CLASS TCodeMax
/*********************************************************************/
local lCtrl   := GetKeyState( VK_CONTROL )
local lShift  := GetKeyState( VK_SHIFT )
local oMenu
local n, cAction, bAction, cText
local oThis := self


do case
   case ( nKey == 	asc( "V" ) .or. nKey == asc( "v" )) .and. lCtrl .and. lShift

       if len( aCopys ) > 0
          MENU oMenu POPUP
               for n := 1 to len( aCopys )
                  cText := aCopys[n]
                  cAction := "{|oMenuItem| GetCurrentCode():Paste(" +  '"' + cText +'"'+ ")}"
                  bAction := &(cAction)
                  cText := aCopys[n]
                  if at( CRLF, cText ) != 0
                     cText := alltrim(memoline(aCopys[n],,1)) + "..."
                  endif
                  MenuAddItem( cText,,.F.,,bAction ,,,,,,,.F.,,,.F. )

               next
          ENDMENU
          ACTIVATE POPUP oMenu AT GetCaretPos()[2], GetCaretPos()[1] OF self
          return 0
        endif
   case nKey == asc( "C" ) .or. nKey == asc( "c" ) .and. lCtrl
        ::Copy()
        return 0

   case nKey == VK_TAB

        if lCtrl
           if lShift
              SendMessage( ::oWnd:hWnd, WM_GOPREVDOC, 0, 0 )
           else
              SendMessage( ::oWnd:hWnd, WM_GONEXTDOC, 0, 0 )
           endif
        endif


endcase




return CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )




/*********************************************************************/
  METHOD Open( cFileName ) CLASS TCodeMax
/*********************************************************************/
local nError

if empty( cFileName )
   cFileName := cGetFile("*.prg", "Seleccione fichero prg")
   if !file( cFileName )
      return .f.
   endif
endif

::cFileName := cFileName

nError :=  CM_OpenFile( ::hWnd, cFileName )

if nError != 1
   if nError == 0
      MsgAlert( "Error al abrir fichero " + cFileName, "Corrija" )
   elseif nError == -1
      MsgAlert( "Error en argumento " + cFileName, "Corrija" )
   endif
endif

return .t.

/*********************************************************************/
      METHOD Save() CLASS TCodeMax
/*********************************************************************/
local nError := CM_SaveFile( ::hWnd, ::cFileName, .f. )

if nError != 1
   if nError == 0
      MsgAlert( "Error al salvar fichero " + ::cFileName, "Corrija" )
   elseif nError == -1
      MsgAlert( "Error en argumento " + ::cFileName, "Corrija" )
   endif
endif

return nil


/*********************************************************************/
  METHOD SaveAs( cFileName ) CLASS TCodeMax
/*********************************************************************/

local nError := CM_SaveFile( ::hWnd, cFileName, .f. )

if nError != 1
   if nError == 0
      MsgAlert( "Error al salvar fichero " + cFileName, "Corrija" )
   elseif nError == -1
      MsgAlert( "Error en argumento " + cFileName, "Corrija" )
   endif
   return nil
endif

if ::cFileName != cFileName
   if MsgYesNo( "Usar el nuevo nombre", "Save As" )
      ::cFileName := cFileName
   endif
endif

return nil

/*********************************************************************/
      METHOD SaveToFile( cFileName ) CLASS TCodeMax
/*********************************************************************/

if empty( cFileName )
    cFileName := cGetFile( "*.prg","Salvar fichero" )
    if file( cFileNAme )
       ::SaveAs( cFileName )
    else
       MsgInfo( "Operación cancelada","Atención" )
    endif
else
   ::SaveAs( cFileName )
endif

return nil



/**********************************************************************/
  METHOD Paste( cText ) CLASS TCodeMax
/**********************************************************************/

local oClp, nError

if !empty( cText )
   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT
   oClp:SetText( cText )
   oClp:Close()
endif


nError := CM_Paste(::hWnd)

::Msg( nError )

return nil

/**********************************************************************/
  METHOD Copy( cText ) CLASS TCodeMax
/**********************************************************************/

local oClp, nError
local aSel

if CM_CanCopy( ::hWnd )
   nError := CM_Copy( ::hWnd )
   ::Msg( nError )
   DEFINE CLIPBOARD oClp OF self FORMAT TEXT
   cText := oClp:GetText()
   if ascan( aCopys, cText ) == 0
      aadd( aCopys, oClp:GetText() )
   endif
   oClp:Close()
   if len( aCopys ) > ::nMaxLenAcopys
      adel( aCopys, 1 )
      asize( aCopys, ::nMaxLenAcopys )
   endif
endif

return nil

/**********************************************************************/
   METHOD SetLineNumberColor( nClrText, nClrPane ) CLASS TCodeMax
/**********************************************************************/
local aColors

aColors := ::GetColors()
aColors[27] := nClrText
aColors[28] := nClrPane

::SetColor( aColors )

return nil

/**********************************************************************/
  METHOD Indent( nSpaces, lRight ) CLASS TCodeMax
/**********************************************************************/
local aSel := ::GetSel()
local n
DEFAULT lRight := .t.
DEFAULT nSpaces := 1

for n := aSel[1] to aSel[3]
    if lRight
       ::InsertText( n, aSel[2], space( nSpaces ) )
    else
       ::SetSel(aSel[n],aSel[2],aSel[n],aSel[2]+1 )
       ::DeleteSel()
    endif
next

return nil


/**********************************************************************/
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TCodeMax
/**********************************************************************/

do case
   case nMsg == WM_SYSKEYDOWN
        if nWParam == VK_RIGHT
           ::Indent(1,.T.)
        elseif nWParam == VK_LEFT
           ::Indent(1,.F.)
        endif

endcase


return super:HandleEvent( nMsg, nWParam, nLParam )










#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "commctrl.h"

#include "codemax.h"


HB_FUNC( CMUNREGISTERCONTROL )
{
   CMUnregisterControl();
}

HB_FUNC( CMREGISTERCONTROL )
{
    CMRegisterControl(CM_VERSION);
}


HB_FUNC( CM_ABOUTBOX )
{
    CM_AboutBox( (HWND) hb_parnl( 1 ) );
}

//#define CM_AddText( hWnd, pszText )
HB_FUNC( CM_ADDTEXT )
{
   hb_retni( CM_AddText( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ));
}

HB_FUNC( CM_BUFFERCOLTOVIEWCOL  )
{
   hb_retni( CM_BufferColToViewCol( (HWND) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 )));
}

HB_FUNC( CM_CANCOPY )
{
   hb_retl( CM_CanCopy( (HWND) hb_parnl( 1 ) ) );
}


HB_FUNC( CM_CANCUT )
{
   hb_retl( CM_CanCut( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_CANPASTE )
{
   hb_retl( CM_CanCut( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_CANREDO )
{
   hb_retl( CM_CanRedo( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_CANUNDO )
{
   hb_retl( CM_CanUndo( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_CLEARUNDOBUFFER )
{
   hb_retni( CM_ClearUndoBuffer( (HWND) hb_parnl( 1 ) ));
}

HB_FUNC( CM_COPY )
{
   hb_retni( CM_Copy( (HWND) hb_parnl( 1 )));
}

HB_FUNC( CM_CUT )
{
   hb_retni( CM_Cut( (HWND) hb_parnl( 1 )));
}

HB_FUNC( CM_DELETELINE )
{
   hb_retni( CM_DeleteLine( (HWND) hb_parnl( 1 ), hb_parni(2) ));
}

HB_FUNC( CM_DELETESEL )
{
   hb_retni( CM_DeleteSel( (HWND) hb_parnl( 1 ) ));
}

HB_FUNC( CM_ENABLECRLF )
{
   hb_retni( CM_EnableCRLF( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_EnableCaseSensitive )
{
    hb_retni( CM_EnableCaseSensitive( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLECOLORSYNTAX )
{
   hb_retni( CM_EnableColorSyntax( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLECOLUMNSEL )
{
   hb_retni( CM_EnableColumnSel( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEDRAGDROP )
{
   hb_retni( CM_EnableDragDrop( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEGLOBALPROPS )
{
   hb_retni( CM_EnableGlobalProps( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ) );
}

HB_FUNC( CM_ENABLEHIDESEL )
{
   hb_retni( CM_EnableHideSel((HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLELEFTMARGIN )
{
   hb_retni( CM_EnableLeftMargin( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLELINETOOLTIPS )
{
   hb_retni( CM_EnableLineToolTips( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLENORMALIZECASE )
{
   hb_retni( CM_EnableNormalizeCase( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEOVERTYPE )
{
   hb_retni( CM_EnableOvertype( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}


HB_FUNC( CM_ENABLEOVERTYPECARET )
{
   hb_retni( CM_EnableOvertypeCaret( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEPRESERVECASE )
{
   hb_retni( CM_EnablePreserveCase( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEREGEXP )
{
   hb_retni( CM_EnableRegExp( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLESELBOUNDS )
{
   hb_retni( CM_EnableSelBounds( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLESMOOTHSCROLLING )
{
   hb_retni( CM_EnableSmoothScrolling( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLESPLITTER )
{
   hb_retni( CM_EnableSplitter( (HWND) hb_parnl( 1 ), hb_parl( 2 ), hb_parl( 3 ) ));
}

HB_FUNC( CM_ENABLETABEXPAND )
{
   hb_retni( CM_EnableTabExpand( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}


HB_FUNC( CM_ENABLEWHITESPACEDISPLAY )
{
   hb_retni( CM_EnableWhitespaceDisplay( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

HB_FUNC( CM_ENABLEWHOLEWORD )
{
   hb_retni( CM_EnableWholeWord( (HWND) hb_parnl( 1 ), hb_parl( 2 ) ));
}

//#define CM_ExecuteCmd( hWnd, wCmd, dwCmdData )
HB_FUNC( CM_EXECUTECMD )
{
   hb_retni( CM_ExecuteCmd( (HWND) hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ) ));
}

HB_FUNC( CM_GETAUTOINDENTMODE )
{
   hb_retnl( CM_GetAutoIndentMode( (HWND) hb_parnl( 1 ) ));
}

HB_FUNC( CM_GETBOOKMARK )
{
   hb_retl( CM_GetBookmark( ( HWND ) hb_parnl( 1 ), hb_parni( 2 )));
}

HB_FUNC( CM_GETBORDERSTYLE )
{
   hb_retnl( CM_GetBorderStyle( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETCURRENTTOKEN )
{
   hb_retnl( CM_GetCurrentToken( ( HWND ) hb_parnl( 1 ) ) );
}


HB_FUNC( CM_GETCURRENTVIEW )
{
   hb_retni( CM_GetCurrentView( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETDIVIDER )
{
   hb_retl( CM_GetDivider( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( CM_GETFINDTEXT )
{
   hb_retni( CM_GetFindText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

HB_FUNC( CM_GETFONTOWNERSHIP )
{
   hb_retl( CM_GetFontOwnership( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETHIGHLIGHTEDLINE )
{
   hb_retni( CM_GetHighlightedLine( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETIMAGELIST )
{
   hb_retnl( (LONG)  CM_GetImageList( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETITEMDATA )
{
   hb_retnl( CM_GetItemData( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( CM_GETLANGUAGE )
{
    hb_retni( CM_GetLanguage( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

HB_FUNC( CM_GETLINE )
{
   char cLine[300];
   cLine[300] = '\0';

   CM_GetLine( (HWND) hb_parnl( 1 ), hb_parni( 2 ), cLine );
   hb_retc( cLine );

}

HB_FUNC( CM_GETLINECOUNT )
{
   hb_retni( CM_GetLineCount( (HWND) hb_parnl( 1 ) ) );
}


HB_FUNC( CM_GETLINELENGTH )
{
   hb_retni( CM_GetLineLength( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}


//#define CM_GetLineNumbering( hWnd, pNumbering )
HB_FUNC( CM_GETLINENUMBERING )
{
   CM_LINENUMBERING ln;
   ZeroMemory( &ln, sizeof( CM_LINENUMBERING ) );
   CM_GetLineNumbering( ( HWND ) hb_parnl( 1 ), &ln );
   hb_retni( ln.dwStyle );
}

HB_FUNC( CM_GETLINESTYLE )
{
   hb_retnl( CM_GetLineStyle( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( CM_GETMARGINIMAGES )
{
    hb_retni( CM_GetMarginImages( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( CM_GETREPLACETEXT )
{
   hb_retni( CM_GetReplaceText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_GetSel( hWnd, pRange, bNormalized )
HB_FUNC( CM_GETSEL )
{
    CM_RANGE rg;
    ZeroMemory( &rg, sizeof( CM_RANGE ) );
    CM_GetSel( ( HWND ) hb_parnl( 1 ), &rg, TRUE );
    hb_reta(4);
    hb_storvni( rg.posStart.nLine, -1, 1 );
    hb_storvni( rg.posStart.nCol, -1, 2 );
    hb_storvni( rg.posEnd.nLine, -1, 3 );
    hb_storvni( rg.posEnd.nCol, -1, 4 );
}

//#define CM_GetSelFromPoint( hWnd, xClient, yClient, pPos )
HB_FUNC( CM_GETSELFROMPOINT )
{
    CM_POSITION pos;
    ZeroMemory( &pos, sizeof( CM_POSITION ) );
    hb_reta(2);
    if( CM_GetSelFromPoint( (HWND) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), &pos ) == CME_SUCCESS )
    {
       hb_storvni( pos.nLine, -1, 1 );
       hb_storvni( pos.nCol, -1, 2 );
    }
    else
    {
       hb_storvni( 0, -1, 1 );
       hb_storvni( 0, -1, 2 );
    }
}

HB_FUNC( CM_GETSPLITTERPOS )
{
    hb_retni( CM_GetSplitterPos( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}

HB_FUNC( CM_GETTABSIZE )
{
	hb_retni( CM_GetTabSize( ( HWND ) hb_parnl( 1 ) ) );
}

//#define CM_GetText( hWnd, pszBuff, pRange )

HB_FUNC( CM_GETTEXT )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   int wLen;
   BYTE * pbyBuffer;
   wLen = CM_GetTextLength( hWnd, NULL, TRUE );
   pbyBuffer = ( char * ) hb_xgrab( wLen );

   CM_GetText( hWnd, pbyBuffer, NULL );

   hb_retclen( ( char * ) pbyBuffer, wLen );
   hb_xfree( pbyBuffer );
}

//#define CM_GetTextLength( hWnd, pRange, bLogical )
HB_FUNC( CM_GETTEXTLENGTH )
{
   hb_retni( CM_GetTextLength( ( HWND ) hb_parnl( 1 ), NULL, TRUE ) );
}

HB_FUNC( CM_GETTOPINDEX )
{
   hb_retni( CM_GetTopIndex( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( CM_GETUNDOLIMIT )
{
   hb_retni( CM_GetUndoLimit( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_GETVIEWCOUNT )
{
   hb_retni( CM_GetViewCount( ( HWND ) hb_parnl( 1 ) ) );
}

//#define CM_GetVisibleLineCount( hWnd, nView, bFullyVisible )
HB_FUNC( CM_GETVISIBLELINECOUNT )
{
    hb_retni( CM_GetVisibleLineCount( (HWND) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}

//#define CM_GetWord( hWnd, pszBuff, pPos )
HB_FUNC( CM_GETWORD )
{
    int nLen;
    HWND hWnd = ( HWND ) hb_parnl( 1 );
    CM_POSITION pos;
    char* pszBuff;

    pos.nLine = hb_parni( 2 );
    pos.nCol = hb_parni( 3 );

    nLen = CM_GetWordLength( hWnd, &pos, TRUE );

    pszBuff = ( char * ) hb_xalloc( nLen+1 );

    CM_GetWord( hWnd, pszBuff, &pos );
    pszBuff[nLen] = '\0';
    hb_retc( pszBuff );
    hb_xfree( pszBuff );
}


//#define CM_GetWordLength( hWnd, pPos, bLogical )
HB_FUNC( CM_GETWORDLENGTH )
{
   CM_POSITION pPos;
   pPos.nLine = hb_parni( 2 );
   pPos.nCol = hb_parni( 3 );

   hb_retni( CM_GetWordLength( ( HWND ) hb_parnl( 1 ), &pPos, TRUE ) );
}



HB_FUNC( CM_HASSCROLLBAR )
{
   hb_retl( CM_HasScrollBar( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}


HB_FUNC( CM_HITTEST )
{
   hb_retnl( CM_HitTest( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 2 ) ) );
}


//#define CM_InsertFile( hWnd, pszFileName, pPos )

HB_FUNC( CM_INSERTFILE )
{
   hb_retni( CM_InsertFile( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ), hb_parl( 3 ) ) );
}


HB_FUNC( CM_INSERTLINE )
{
    hb_retni( CM_InsertLine( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parc( 3 ) ) );
}

//#define CM_InsertText( hWnd, pszText, pPos )
HB_FUNC( CM_INSERTTEXT )
{
   CM_POSITION pPos;
   pPos.nLine = hb_parni( 3 );
   pPos.nCol = hb_parni( 4 );

   hb_retni( CM_InsertText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ), &pPos ) );
}


HB_FUNC( CM_ISCRLFENABLED )
{
   hb_retl( CM_IsCRLFEnabled( ( HWND ) hb_parnl( 1 ) ) );
}


HB_FUNC( CM_ISCASESENSITIVEENABLED )
{
   hb_parl( CM_IsCaseSensitiveEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISCOLORSYNTAXENABLED )
{
	hb_parl( CM_IsColorSyntaxEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISCOLUMNSELENABLED )
{
	hb_parl( CM_IsColumnSelEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISDRAGDROPENABLED )
{
	hb_parl( CM_IsDragDropEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISGLOBALPROPSENABLED )
{
	hb_parl( CM_IsGlobalPropsEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISHIDESELENABLED )
{
	hb_parl( CM_IsHideSelEnabled( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISLEFTMARGINENABLED )
{
	hb_retl( CM_IsLeftMarginEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISLINETOOLTIPSENABLED )
{
	hb_retl( CM_IsLineToolTipsEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISMODIFIED )
{
	hb_retl( CM_IsModified( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISNORMALIZECASEENABLED )
{
	hb_retl( CM_IsNormalizeCaseEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISOVERTYPECARETENABLED )
{
	hb_retl( CM_IsOvertypeCaretEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISOVERTYPEENABLED )
{
	hb_retl( CM_IsOvertypeEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISPLAYINGMACRO )
{
	hb_retl( CM_IsPlayingMacro( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISPRESERVECASEENABLED )
{
	hb_retl( CM_IsPreserveCaseEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISREADONLY )
{
	hb_retl( CM_IsReadOnly( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISRECORDINGMACRO )
{
	hb_retl( CM_IsRecordingMacro( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISREGEXPENABLED )
{
	hb_retl( CM_IsRegExpEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISSELBOUNDSENABLED )
{
	hb_retl( CM_IsSelBoundsEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISSMOOTHSCROLLINGENABLED )
{
	hb_retl( CM_IsSmoothScrollingEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISSPLITTERENABLED )
{
	hb_retl( CM_IsSplitterEnabled( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}

HB_FUNC( CM_ISTABEXPANDENABLED )
{
	hb_retl( CM_IsTabExpandEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISWHITESPACEDISPLAYENABLED )
{
	hb_retl( CM_IsWhitespaceDisplayEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_ISWHOLEWORDENABLED )
{
	hb_retl( CM_IsWholeWordEnabled( ( HWND ) hb_parnl( 1 ) ) );
}

//#define CM_OpenFile( hWnd, pszFileName )
HB_FUNC( CM_OPENFILE )
{
   hb_retni( CM_OpenFile( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) ) ;
}

HB_FUNC( CM_PASTE )
{
   hb_retni( CM_Paste( (HWND) hb_parnl( 1 )));
}

//#define CM_PosFromChar( hWnd, pPos, pRect )
HB_FUNC( CM_POSFROMCHAR )
{
   RECT pRect;
   CM_POSITION pPos;

   pPos.nLine = hb_parni( 2 );
   pPos.nCol = hb_parni( 3 );

   ZeroMemory( &pRect, sizeof( CM_POSITION ) );

   CM_PosFromChar( ( HWND ) hb_parnl( 1 ), &pPos, &pRect );

   hb_reta(4);

   hb_storvni( pRect.top, -1, 1 );
   hb_storvni( pRect.left, -1, 2 );
   hb_storvni( pRect.bottom, -1, 3 );
   hb_storvni( pRect.right, -1, 4 );
}


//#define CM_Print( hWnd, hDC, dwFlags )
HB_FUNC( CM_PRINT )
{
    hb_retni( CM_Print( (HWND) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ), hb_parnl( 3 ) ) );
}

HB_FUNC( CM_REDO )
{
   hb_retni( CM_Redo( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( CM_REPLACESEL )
{
   hb_retni( CM_ReplaceSel( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}


//#define CM_ReplaceText( hWnd, pszText, pRange )
HB_FUNC( CM_REPLACETEXT )
{
   hb_retni( CM_ReplaceText( (HWND) hb_parnl( 1 ), hb_parc( 2 ), NULL ) );
}

HB_FUNC( CM_SAVEFILE )
{
   hb_retni( CM_SaveFile( (HWND) hb_parnl( 1 ), hb_parc( 2 ), hb_parl( 3 )));
}


HB_FUNC( CM_SELECTLINE )
{
   hb_retni( CM_SelectLine( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}


//#define CM_SetAllBookmarks( hWnd, nCount, pdwLines )
HB_FUNC( CM_SETALLBOOKMARKS )
{
   DWORD* pdwLines;
   WORD wLines = hb_parni( 2 );
   WORD i;
   pdwLines = ( DWORD * ) hb_xalloc( wLines );

   for( i=0;i<wLines;i++)
   {
       pdwLines[i] = hb_parni( 3, i+1 );
   }
   hb_retni( CM_SetAllBookmarks( ( HWND ) hb_parnl( 1 ), wLines, pdwLines ));
   hb_xfree( pdwLines );
}


HB_FUNC( CM_SETAUTOINDENTMODE )
{
   hb_retni( CM_SetAutoIndentMode( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}


HB_FUNC( CM_SETBOOKMARK )
{
	hb_retni( CM_SetBookmark( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}

HB_FUNC( CM_SETBORDERSTYLE )
{
	hb_retni( CM_SetBorderStyle( ( HWND ) hb_parnl( 1 ), hb_parnl( 2 ) ) );
}


HB_FUNC( CM_SETCARETPOS )
{
	hb_retni( CM_SetCaretPos( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
}

//#define CM_SetColors( hWnd, pColors )

HB_FUNC( CM_SETCOLORS )
{
   CM_COLORS pColors;

    pColors.crWindow =             hb_parvnl( 2,  1 );
    pColors.crLeftMargin =         hb_parvnl( 2,  2 );
    pColors.crBookmark =           hb_parvnl( 2,  3 );
    pColors.crBookmarkBk =         hb_parvnl( 2,  4 );
    pColors.crText =               hb_parvnl( 2,  5 );
    pColors.crTextBk =             hb_parvnl( 2,  6 );
    pColors.crNumber =             hb_parvnl( 2,  7 );
    pColors.crNumberBk =           hb_parvnl( 2,  8 );
    pColors.crKeyword =            hb_parvnl( 2,  9 );
    pColors.crKeywordBk =          hb_parvnl( 2, 10 );
    pColors.crOperator =           hb_parvnl( 2, 11 );
    pColors.crOperatorBk =         hb_parvnl( 2, 12 );
    pColors.crScopeKeyword =       hb_parvnl( 2, 13 );
    pColors.crScopeKeywordBk =     hb_parvnl( 2, 14 );
    pColors.crComment =            hb_parvnl( 2, 15 );
    pColors.crCommentBk =          hb_parvnl( 2, 16 );
    pColors.crString =             hb_parvnl( 2, 17 );
    pColors.crStringBk =           hb_parvnl( 2, 18 );
    pColors.crTagText =            hb_parvnl( 2, 19 );
    pColors.crTagTextBk =          hb_parvnl( 2, 20 );
    pColors.crTagEntity =          hb_parvnl( 2, 21 );
    pColors.crTagEntityBk =        hb_parvnl( 2, 22 );
    pColors.crTagElementName =     hb_parvnl( 2, 23 );
    pColors.crTagElementNameBk =   hb_parvnl( 2, 24 );
    pColors.crTagAttributeName =   hb_parvnl( 2, 25 );
    pColors.crTagAttributeNameBk = hb_parvnl( 2, 26 );
    pColors.crLineNumber =         hb_parvnl( 2, 27 );
    pColors.crLineNumberBk =       hb_parvnl( 2, 28 );
    pColors.crHDividerLines =      hb_parvnl( 2, 29 );
    pColors.crVDividerLines =      hb_parvnl( 2, 30 );
    pColors.crHighlightedLine =    hb_parvnl( 2, 31 );

    hb_retni( CM_SetColors( (HWND) hb_parnl( 1 ), &pColors ) );
}


HB_FUNC( CM_SETDIVIDER )
{
    hb_retni( CM_SetDivider( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}


HB_FUNC( CM_SETDLGPARENT )
{
    hb_retni( CM_SetDlgParent( ( HWND ) hb_parnl( 1 ), ( HWND ) hb_parnl( 2 ) ) );
}


HB_FUNC( CM_SETFINDTEXT )
{
   hb_retni( CM_SetFindText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}


HB_FUNC( CM_SETFONTOWNERSHIP )
{
   hb_retni( CM_SetFontOwnership( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}

//#define CM_SetFontStyles( hWnd, pFontStyles )
HB_FUNC( CM_SETFONTSTYLES )
{
    CM_FONTSTYLES pFontStyles;
    pFontStyles.byText =             hb_parvni( 2,  1 );
    pFontStyles.byNumber =           hb_parvni( 2,  2 );
    pFontStyles.byKeyword =          hb_parvni( 2,  3 );
    pFontStyles.byOperator =         hb_parvni( 2,  4 );
    pFontStyles.byScopeKeyword =     hb_parvni( 2,  5 );
    pFontStyles.byComment =          hb_parvni( 2,  6 );
    pFontStyles.byString =           hb_parvni( 2,  7 );
    pFontStyles.byTagText =          hb_parvni( 2,  8 );
    pFontStyles.byTagEntity =        hb_parvni( 2,  9 );
    pFontStyles.byTagElementName =   hb_parvni( 2, 10 );
    pFontStyles.byTagAttributeName = hb_parvni( 2, 11 );
    pFontStyles.byLineNumber =       hb_parvni( 2, 12 );

    hb_retni( CM_SetFontStyles( (HWND) hb_parnl( 1 ), &pFontStyles ) );

}


//#define CM_SetHighlightedLine( hWnd, nLine )
HB_FUNC( CM_SETHIGHLIGHTEDLINE )
{
   hb_retni( CM_SetHighlightedLine( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

//#define CM_SetImageList( hWnd, hImageList )
HB_FUNC( CM_SETIMAGELIST )
{
   hb_retni( CM_SetImageList( (HWND) hb_parnl( 1 ), ( HIMAGELIST ) hb_parnl( 2 ) ) );
}

//#define CM_SetItemData( hWnd, nLine, lParam )
HB_FUNC( CM_SETITEMDATA )
{
   hb_retni( CM_SetItemData( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), (LPARAM) hb_parnl( 3 ) ) );
}


//#define CM_SetLanguage( hWnd, pszName )
HB_FUNC( CM_SETLANGUAGE )
{
	hb_retni( CM_SetLanguage( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageComments( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGECOMMENTS )
{
	hb_retni( CM_SetLanguageComments( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageKeywords( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGEKEYWORDS )
{
	hb_retni( CM_SetLanguageKeywords( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageLiteralChar( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGELITERALCHAR )
{
   hb_retni( CM_SetLanguageLiteralChar( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageMultiComments1( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGEMULTICOMMENTS1 )
{
   hb_retni( CM_SetLanguageMultiComments1( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageMultiComments2( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGEMULTICOMMENTS2 )
{
   hb_retni( CM_SetLanguageMultiComments2( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageOperators( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGEOPERATORS )
{
   hb_retni( CM_SetLanguageOperators( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageScapeChar( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGESCAPECHAR )
{
   hb_retni( CM_SetLanguageScapeChar( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageScope1( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGESCOPE1 )
{
   hb_retni( CM_SetLanguageScope1( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageScope2( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGESCOPE2 )
{
   hb_retni( CM_SetLanguageScope2( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageSensitive( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGESENSITIVE )
{
   hb_retni( CM_SetLanguageSensitive( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageStyle( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGESTYLE )
{
   hb_retni( CM_SetLanguageStyle( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageTagAttributes( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGETAGATTRIBUTES )
{
   hb_retni( CM_SetLanguageTagAttributes( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageTagEntities( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGETAGENTITIES )
{
   hb_retni( CM_SetLanguageTagEntities( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageTagNames( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGETAGNAMES )
{
   hb_retni( CM_SetLanguageTagNames( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLanguageTerminatorChar( hWnd, lpszParams )
HB_FUNC( CM_SETLANGUAGETERMINATORCHAR )
{
   hb_retni( CM_SetLanguageTerminatorChar( (HWND) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetLineNumbering( hWnd, pNumbering )
HB_FUNC( CM_SETLINENUMBERING )
{

        //#define CM_BINARY            2
        //#define CM_OCTAL             8
        //#define CM_DECIMAL           10
        //#define CM_HEXADECIMAL       16

 	CM_LINENUMBERING ln;
 	ln.bEnabled = hb_parl( 2 );
 	ln.nStartAt = hb_parni( 3 );
 	ln.dwStyle = hb_parni( 4 );

 	hb_retni(CM_SetLineNumbering( ( HWND ) hb_parnl( 1 ), &ln ) );
}

//#define CM_SetLineStyle( hWnd, nLine, dwStyle )
HB_FUNC( CM_SETLINESTYLE )
{
   hb_retni( CM_SetLineStyle( (HWND) hb_parnl( 1 ), hb_parni( 2 ), hb_parnl( 3 ) ) );
}


//#define CM_SetMarginImages( hWnd, nLine, byImages )
HB_FUNC( CM_SETMARGINIMAGES )
{
   hb_retni( CM_SetMarginImages( (HWND) hb_parnl( 1 ), hb_parni( 2 ), (BYTE) hb_parc( 3 ) ) );
}

HB_FUNC( CM_SETMODIFIED )
{
	hb_retni( CM_SetModified( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}


HB_FUNC( CM_SETREADONLY )
{
	hb_retni( CM_SetReadOnly( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ) ) );
}


HB_FUNC( CM_SETREPLACETEXT )
{
	hb_retni( CM_SetReplaceText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetSel( hWnd, pRange, bMakeVisible )
HB_FUNC( CM_SETSEL )
{
	CM_RANGE mr;
	mr.posStart.nLine = hb_parni( 2 );
	mr.posStart.nCol = hb_parni( 3 );
	mr.posEnd.nLine = hb_parni( 4 );
	mr.posEnd.nCol = hb_parni( 5 );
	mr.bColumnSel = hb_parl( 6 );
	hb_retni( CM_SetSel( ( HWND ) hb_parnl( 1 ), &mr, hb_parl( 7 ) ) );
}

//#define CM_SetSplitterPos( hWnd, bHorz, nPos )
HB_FUNC( CM_SETSPLITTERPOS )
{
	hb_retni( CM_SetSplitterPos( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ), hb_parni( 3 ) ) );
}

//#define CM_SetTabSize( hWnd, nTabSize )
HB_FUNC( CM_SETTABSIZE )
{
	hb_retni( CM_SetTabSize( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}


//#define CM_SetText( hWnd, pszText )
HB_FUNC( CM_SETTEXT )
{
	hb_retni( CM_SetText( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//#define CM_SetTopIndex( hWnd, nView, nLine )
HB_FUNC( CM_SETTOPINDEX )
{
	hb_retni( CM_SetTopIndex( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
}

//#define CM_SetUndoLimit( hWnd, nLimit )
HB_FUNC( CM_SETUNDOLIMIT )
{
	hb_retni( CM_SetUndoLimit( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

//#define CM_ShowScrollBar( hWnd, bHorz, bShow )
HB_FUNC( CM_SHOWSCROLLBAR )
{
	hb_retni( CM_ShowScrollBar( ( HWND ) hb_parnl( 1 ), hb_parl( 2 ), hb_parl( 3 ) ) );
}

HB_FUNC( CM_UNDO )
{
	hb_retni( CM_Undo( ( HWND ) hb_parnl( 1 ) ) );
}

//#define CM_ViewColToBufferCol( hWnd, nLine, nViewCol )
HB_FUNC( CM_VIEWCOLTOBUFFERCOL )
{
	hb_retni( CM_ViewColToBufferCol( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 )  ) );
}

//#define CM_GetAllBookmarks( hWnd, pdwLines )
HB_FUNC( CM_GETALLBOOKMARKS )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   WORD wLines = CM_GetAllBookmarks( hWnd, NULL );
   DWORD* pdwLines = ( DWORD * ) hb_xalloc( wLines );
   int i;
   CM_GetAllBookmarks( hWnd, pdwLines );

   hb_reta( wLines );
   for( i=0; i<wLines; i++)
   {
       hb_storvni( pdwLines[i], -1, i+1 );
   }
   hb_xfree( pdwLines );
}

//#define CM_GetColors( hWnd, pColors )
HB_FUNC( CM_GETCOLORS )
{
   CM_COLORS pColors;
   ZeroMemory( &pColors, sizeof( CMM_GETCOLORS ) );

   CM_GetColors( ( HWND ) hb_parnl( 1 ), &pColors );
   hb_reta( 31 );
   hb_storvnl( pColors.crWindow             , -1,  1 );
   hb_storvnl( pColors.crLeftMargin         , -1,  2 );
   hb_storvnl( pColors.crBookmark           , -1,  3 );
   hb_storvnl( pColors.crBookmarkBk         , -1,  4 );
   hb_storvnl( pColors.crText               , -1,  5 );
   hb_storvnl( pColors.crTextBk             , -1,  6 );
   hb_storvnl( pColors.crNumber             , -1,  7 );
   hb_storvnl( pColors.crNumberBk           , -1,  8 );
   hb_storvnl( pColors.crKeyword            , -1,  9 );
   hb_storvnl( pColors.crKeywordBk          , -1, 10 );
   hb_storvnl( pColors.crOperator           , -1, 11 );
   hb_storvnl( pColors.crOperatorBk         , -1, 12 );
   hb_storvnl( pColors.crScopeKeyword       , -1, 13 );
   hb_storvnl( pColors.crScopeKeywordBk     , -1, 14 );
   hb_storvnl( pColors.crComment            , -1, 15 );
   hb_storvnl( pColors.crCommentBk          , -1, 16 );
   hb_storvnl( pColors.crString             , -1, 17 );
   hb_storvnl( pColors.crStringBk           , -1, 18 );
   hb_storvnl( pColors.crTagText            , -1, 19 );
   hb_storvnl( pColors.crTagTextBk          , -1, 20 );
   hb_storvnl( pColors.crTagEntity          , -1, 21 );
   hb_storvnl( pColors.crTagEntityBk        , -1, 22 );
   hb_storvnl( pColors.crTagElementName     , -1, 23 );
   hb_storvnl( pColors.crTagElementNameBk   , -1, 24 );
   hb_storvnl( pColors.crTagAttributeName   , -1, 25 );
   hb_storvnl( pColors.crTagAttributeNameBk , -1, 26 );
   hb_storvnl( pColors.crLineNumber         , -1, 27 );
   hb_storvnl( pColors.crLineNumberBk       , -1, 28 );
   hb_storvnl( pColors.crHDividerLines      , -1, 29 );
   hb_storvnl( pColors.crVDividerLines      , -1, 30 );
   hb_storvnl( pColors.crHighlightedLine    , -1, 31 );
}

//#define CM_GetFontStyles( hWnd, pFontStyles )
HB_FUNC( CM_GETFONTSTYLES )
{
  CM_FONTSTYLES pFontStyles;
  ZeroMemory( &pFontStyles, sizeof( CM_FONTSTYLES ) );
  CM_GetFontStyles( ( HWND ) hb_parnl( 1 ), &pFontStyles );
  hb_reta( 12 );
  hb_storvni( pFontStyles.byText            , -1,  1 );
  hb_storvni( pFontStyles.byNumber          , -1,  2 );
  hb_storvni( pFontStyles.byKeyword         , -1,  3 );
  hb_storvni( pFontStyles.byOperator        , -1,  4 );
  hb_storvni( pFontStyles.byScopeKeyword    , -1,  5 );
  hb_storvni( pFontStyles.byComment         , -1,  6 );
  hb_storvni( pFontStyles.byString          , -1,  7 );
  hb_storvni( pFontStyles.byTagText         , -1,  8 );
  hb_storvni( pFontStyles.byTagEntity       , -1,  9 );
  hb_storvni( pFontStyles.byTagElementName  , -1, 10 );
  hb_storvni( pFontStyles.byTagAttributeName, -1, 11 );
  hb_storvni( pFontStyles.byLineNumber      , -1, 12 );
}

HB_FUNC( REGISTERWINDOWMESSAGE )
{
     hb_retni( RegisterWindowMessage( ( LPCTSTR ) hb_parc(1)));
}



#pragma ENDDUMP



