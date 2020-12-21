#include "fivewin.ch"
#include "splitter.ch"
#include "scintilla.ch"


static aFiles := {}
static oWnd


*******************************************************************************************************
function AddFile( cFile )
*******************************************************************************************************

if ascan( aFiles, alltrim(cFile) ) == 0
   aadd( aFiles, alltrim(cFile) )
endif

return len( aFiles )


*******************************************************************************************************
  function NuevoCode()
*******************************************************************************************************
   local oWndChild, oCode, oBar

   DEFINE WINDOW oWndCHild  TITLE "Noname" MDICHILD OF Aplicacion():oWnd

          DEFINE BUTTONBAR oBar SIZE 23, 27 OF oWndCHild _3D

          DEFINE BUTTON OF oBar NOBORDER

          DEFINE BUTTON OF oBar NOBORDER  NAME "new"      GROUP
          DEFINE BUTTON OF oBar NOBORDER  NAME "open"            ACTION OpenCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "saveed"          ACTION SaveCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "printer"         ACTION PrintCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "cut"       GROUP
          DEFINE BUTTON OF oBar NOBORDER  NAME "copy"
          DEFINE BUTTON OF oBar NOBORDER  NAME "paste"
          DEFINE BUTTON OF oBar NOBORDER  NAME "undoed"    GROUP ACTION UndoCode()   WHEN CanUndoCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "redoed"          ACTION RedoCode()   WHEN CanRedoCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "finded"    GROUP ACTION DlgFindText()

          DEFINE BUTTON OF oBar                                  ACTION FindTip() //InsertX()
          DEFINE BUTTON OF oBar                                  ACTION FindMark()
          DEFINE BUTTON OF oBar                                  ACTION FindLine()
          //DEFINE BUTTON OF oBar NOBORDER  NAME "bmps\fonts.bmp"       ACTION OptionSetFont()


      //oCode := TCodeMax():New(0, 0, 1, 1, oWndChild )
      oCode := TScintilla():New(0, 0, 1, 1, oWndChild )
      oCode:SetFocus()

      oWndChild:SetControl( oCode )

   ACTIVATE WINDOW oWndChild MAXIMIZED


return oCode

*******************************************************************************************************
  function OpenCode( cFileName )
*******************************************************************************************************
local oCode, o, n, nLen
local lGetFile := empty( cFileName )

if lGetFile
   cFileName := cGetFile("*.prg", "Seleccione fichero prg")
   if !file( cFileName )
      return .f.
   endif
endif


o := Aplicacion():oWnd:oWndActive

if o != nil .and. upper(o:ClassName()) == "SCINTILLA" .or. upper(o:ClassName()) == "CODEMAX"
   nLen := len(o:oWndClient:aWnd)
   for n := 1 to nLen
       if o:oWndClient:aWnd[n]:cTitle == "Noname"
          o:oWndClient:aWnd[n]:oControl:OpenFile( cFileName )
          SetWindowText( o:oWndClient:aWnd[n]:hWnd, cFileName )
          return nil
       endif
       if o:oWndClient:aWnd[n]:cTitle == cFileName
          o:oWndClient:aWnd[n]:SetFocus()
          return nil
       endif
   next
endif
oCode := NuevoCode()
if !empty( cFileName )
   oCode:OpenFile( cFileName )
   SetWindowText( oCode:oWnd:hWnd, cFileName )
endif

return oCode

*******************************************************************************************************
  function SaveCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   return o:oControl:Save()
endif

return nil


*******************************************************************************************************
  function SendAsEmail( lAttach )
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

DEFAULT lAttach := .f.

if o != nil
   return o:oControl:SendAsEmail( lAttach )
endif

return nil


*******************************************************************************************************
  function UndoCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   if CanUndoCode()
      o:Undo()
   endif
endif

return nil

*******************************************************************************************************
  function CanUndoCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil .and. o:oControl != nil
   if o:oControl:CanUndo()
      return .t.
   endif
endif

return .f.


*******************************************************************************************************
  function RedoCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   if CanRedoCode()
      o:oControl:Redo()
   endif
endif

return nil

*******************************************************************************************************
  function CanRedoCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil .and. o:oControl != nil
   if o:oControl:CanRedo()
      return .t.
   endif
endif

return .f.

*******************************************************************************************************
  function CutCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   o:oControl:Cut()
endif

return nil

*******************************************************************************************************
  function CopyCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   o:oControl:Copy()
endif

return nil

*******************************************************************************************************
  function PasteCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   o:oControl:Paste()
endif

return nil

*******************************************************************************************************
  function PrintCode()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   o:oControl:Print()
endif

return nil

*******************************************************************************************************
  function DlgFindText()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive

if o != nil
   o:oControl:DlgFindText()
endif

return nil



//----------------------------------------------------------------------------//

*******************************************************************************************************
  function InsertX()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive
local oEditor

if o == nil
   return nil
endif

oEditor := o:oControl


oEditor:AddTextCRLF( 'DEFINE WINDOW <oWnd> FROM <nTop>, <nLeft> TO <nBottom>, <nRight> [<pixel: PIXEL>]  ;')
oEditor:AddTextCRLF( '    TITLE <cTitle> ;')
oEditor:AddTextCRLF( '    COLOR <nClrFore> ,<nClrBack> ;')
oEditor:AddTextCRLF( '    OF <oParent> ;')
oEditor:AddTextCRLF( '    BRUSH <oBrush> ;')
oEditor:AddTextCRLF( '    CURSOR <oCursor> ;')
oEditor:AddTextCRLF( '    ICON  <oIcon> ;')
oEditor:AddTextCRLF( '    MENU <oMenu> ;')
oEditor:AddTextCRLF( '    STYLE <nStyle> ;')
oEditor:AddTextCRLF( '    BORDER <border: NONE, SINGLE> ;')
oEditor:AddTextCRLF( '    NOSYSMENU ;')
oEditor:AddTextCRLF( '    NOCAPTION ;')
oEditor:AddTextCRLF( '    NOICONIZE ;')
oEditor:AddTextCRLF( '    NOMAXIMIZE ;')
oEditor:AddTextCRLF( '    VSCROLL ;')
oEditor:AddTextCRLF( '    HSCROLL')



return nil

*******************************************************************************************************
  function FindMark() // busca la siguiete "<loquesea>"
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive
local oEditor
local nIni, nEnd

if o == nil
   return nil
endif

oEditor := o:oControl
oEditor:GotoPos( oEditor:GetCurrentPos()+1 )
oEditor:SendEditor(2366)
nIni := oEditor:SearchNext(,"<" )
if nIni > 0
   nEnd := oEditor:SearchNext(,">")
   if nEnd > 0
      oEditor:SetSel(nIni, nEnd+1)
   endif
endif
oEditor:SetFocus()

return nil

*******************************************************************************************************
  function FindLine()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive
local oEditor
local nIni, nEnd

if o == nil
   return nil
endif

oEditor := o:oControl

oEditor:GoHome()
oEditor:LineDown()
nIni := oEditor:nPos
oEditor:GoEol()
nEnd := oEditor:nPos
oEditor:SetSel( nIni, nEnd )
oEditor:SetFocus()

return nil

*******************************************************************************************************
  function FindTip()
*******************************************************************************************************
local o := Aplicacion():oWnd:oWndActive
local oEditor, cText
local nIni, nEnd

if o == nil
   return nil
endif

oEditor := o:oControl

USE codetips

cText := Browse()

USE

if !empty( cText )
   oEditor:AddTextCRLF( cText )
endif


return nil



/*
function NuevoCode()
local oBar, oMenu
local oIni, n, nLen, cVal
local oPopup1, cItem
local oBrush


INI oIni FILE ".\c5.ini"
    GET nLen SECTION "FICHEROS"   ENTRY "LENGTH"  OF oIni           DEFAULT 0
    for n=1 to nLen
      GET cVal SECTION "FICHEROS" ENTRY "FICHERO" + alltrim( str( n ) ) OF oIni DEFAULT ""
      aadd( aFiles, cVal )
    next n
ENDINI


MENU oPopup1 POPUP
    for n := 1 to len( aFiles )
       cItem := aFiles[n]
       MenuAddItem(cItem,,.F.,,{|oMenuItem|MsgInfo("hola")},,,,,,,.F.,,,.F. )
    next
ENDMENU



MENU oMenu
     MENUITEM "&Fichero"
     MENU
        MENUITEM "&Nuevo" FILE "bmps\new.bmp" ACTION Nuevo()
        MENUITEM "&Abrir" FILE "bmps\open.bmp" ACTION Open()
        MENUITEM "Recargar"
        SEPARATOR
        MENUITEM "Save"         FILE "bmps\save.bmp" ACTION Save()
        MENUITEM "Save As..."
        SEPARATOR
        MENUITEM "Print"        FILE "bmps\printer.bmp" ACTION Print()
        MENUITEM "Print Preview"
        MENUITEM "Page Setup..." ACTION PrinterSetup()
        SEPARATOR
        MENUITEM "Send as email"
        MENU
          MENUITEM "Send as text..."       FILE "bmps\mail.bmp" ACTION SendAsEmail()
          MENUITEM "Send as attachment..." FILE "bmps\mailat.bmp" ACTION SendAsEmail(.t.)
        ENDMENU
        SEPARATOR
        MENUITEM "Exit"   ACTION oWnd:End()
     ENDMENU
     MENUITEM "Edit"
     MENU
        MENUITEM "Undo"   ACTION Undo()
        MENUITEM "Redo"   ACTION Redo()
        SEPARATOR
        MENUITEM "Cortar" ACTION Cut()
        MENUITEM "Copiar" ACTION Copy()
        MENUITEM "Pegar"  ACTION Paste()
     ENDMENU
     MENUITEM "&Windows"
     MENU
        MENUITEM "Maximize"         ACTION oWnd:Maximize()
        MENUITEM "Cascada"          ACTION oWnd:Cascade()
        MENUITEM "Tile Horizontal"  ACTION oWnd:Tile(.t.)
        MENUITEM "Tile Vertical"    ACTION oWnd:Tile()
     ENDMENU
     MENUITEM "Ayuda" HELP
ENDMENU


DEFINE BRUSH oBrush STYLE "NULL"

DEFINE WINDOW oWnd TITLE "Scintilla" MENU oMenu MDI

   SetKey( VK_F3, {|| FindMark()} )
   SetKey( VK_F4, {|| FindLine()} )

   DEFINE BUTTONBAR oBar SIZE 23, 27 OF oWnd _3D

   DEFINE BUTTON OF oBar NOBORDER MENU oPopup1

   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\new.bmp" GROUP
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\open.bmp"        ACTION Open()
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\save.bmp"        ACTION Save()
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\printer.bmp"     ACTION Print()

   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\cut.bmp"   GROUP
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\copy.bmp"
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\paste.bmp"

   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\undo.bmp"  GROUP ACTION Undo()  WHEN CanUndo()
   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\redo.bmp"   ACTION Redo()       WHEN CanRedo()
   //DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\fonts.bmp"       ACTION OptionSetFont()

   DEFINE BUTTON OF oBar NOBORDER  FILE "bmps\find.bmp" GROUP  ACTION DlgFindText()

   DEFINE BUTTON OF oBar                                       ACTION FindTip() //InsertX()
   DEFINE BUTTON OF oBar                                       ACTION FindMark()
   DEFINE BUTTON OF oBar                                       ACTION FindLine()



ACTIVATE WINDOW oWnd MAXIMIZED ;//VALID (if( oCode():GetModify(), MsgYesNo( "Ha sido modificado" + CRLF + "¿Desea salvarlo?" ),),.t.)
         ON INIT Nuevo()

INI oIni FILE ".\c5.ini"
    SET SECTION "FICHEROS"   ENTRY "LENGTH"  OF oIni TO len( aFiles )
    for n=1 to Len(aFiles)
      SET SECTION "FICHEROS" ENTRY "FICHERO" + alltrim( str( n ) ) OF oIni TO aFiles[n]
    next n
ENDINI

return nil
*/

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include <shlobj.h>

static far char IniDir[] = ".\\";
static char szDirName[ MAX_PATH ];
void cdecl _bcopy( void *, void *, unsigned int );
static far char Title[] = "Select the file";

HB_FUNC ( CGETFILEEX )   // de minigui
{
	OPENFILENAME ofn;
	char buffer[65536];
	char cFullName[64][1024];
	char cCurDir[512];
	char cFileName[512];
	int iPosition = 0;
	int iNumSelected = 0;
	int n;
   LPSTR  pFile,pFilter,pTitle,pDir;
   WORD w = 0, wLen;
	int flags =  OFN_ALLOWMULTISELECT | OFN_EXPLORER ; //OFN_FILEMUSTEXIST  |

	buffer[0] = 0 ;

   // alloc for title

   pTitle = ( LPSTR ) hb_xgrab( 128 );

   if ( hb_pcount() > 1 && ISCHAR( 2 ) )
   {
      wLen   = min( ( unsigned long ) 127, hb_parclen( 2 ) );
      memcpy( pTitle, hb_parc( 2 ), wLen );
      * ( pTitle + wLen ) = 0;

   }
   else
   {
      pTitle  = Title;
   }

   // alloc for initial dir

   pDir = ( LPSTR ) hb_xgrab( 128 );

   if ( hb_pcount() > 3 && ISCHAR( 4 ) )
   {
      wLen  = min( ( unsigned long ) 127, hb_parclen( 4 ) );
      memcpy( pDir, hb_parc( 4 ), wLen );
      * ( pDir + wLen ) = 0;
   }
   else
   {
      * ( pDir ) = 0;
   }

   // alloc for file

   pFile = ( LPSTR ) hb_xgrab( 255 );

   if ( hb_pcount() > 7 && ISCHAR( 8 ) )
   {
      wLen = min( ( unsigned long ) 254, hb_parclen( 8 ) );
      memcpy( pFile, hb_parc( 8 ), wLen );
   }
   else
   {
      wLen = min( ( unsigned long ) 254, hb_parclen( 1 ) );
      memcpy( pFile, hb_parc( 1 ), wLen );
   }
   * ( pFile + wLen ) = 0;

   // alloc for mask

   pFilter = ( LPSTR ) hb_xgrab( 400 );
   wLen    = min( ( unsigned long ) 398, hb_parclen( 1 ) );
   memcpy( pFilter, hb_parc( 1 ), wLen );
   * ( pFilter + wLen ) = 0;

   #ifndef __FLAT__
   //   _xunlock();
   #endif

   while( * ( pFilter + w ) )
   {
      if( * ( pFilter + w ) == '|' )
      {
         * ( pFilter + w ) = 0;
         if ( hb_pcount() < 8 )
            * (pFile) = 0;
      }
      w++;
   }

   * ( pFilter + wLen  ) = 0;
   * ( pFilter + wLen + 1 ) = 0;


	memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
	ofn.lStructSize = sizeof(ofn);
	ofn.hwndOwner = GetActiveWindow();
	ofn.lpstrFilter = pFilter;
	ofn.nFilterIndex = 1;
	ofn.lpstrFile = buffer;
	ofn.nMaxFile = sizeof(buffer);
	ofn.lpstrInitialDir = hb_parc(3);
	ofn.lpstrTitle = pTitle;
	ofn.nMaxFileTitle = 512;
	ofn.Flags = flags;

	if( GetOpenFileName( &ofn ) )
	{
		if(ofn.nFileExtension!=0)
		{
			hb_retc( ofn.lpstrFile );
		}
		else
		{
			wsprintf(cCurDir,"%s",&buffer[iPosition]);
			iPosition=iPosition+strlen(cCurDir)+1;

			do
			{
				iNumSelected++;
				wsprintf(cFileName,"%s",&buffer[iPosition]);
				iPosition=iPosition+strlen(cFileName)+1;
				wsprintf(cFullName[iNumSelected],"%s\\%s",cCurDir,cFileName);
			}
			while(  (strlen(cFileName)!=0) && ( iNumSelected <= 63 ) );

			if(iNumSelected > 1)
			{
				hb_reta( iNumSelected - 1 );

				for (n = 1; n < iNumSelected; n++)
				{
					hb_storvc( cFullName[n], -1, n );
				}
			}
			else
			{
				hb_retc( &buffer[0] );
			}
		}
	}
	else
	{
		hb_retc( "" );
	}
}

// del msdn
INT CALLBACK BrowseCallbackProc(HWND hwnd,
                                UINT uMsg,
                                LPARAM lp,
                                LPARAM pData)
{
   switch(uMsg)
   {
   case BFFM_INITIALIZED:
      if (szDirName)
      {
         // WParam is TRUE since you are passing a path.
         // It would be FALSE if you were passing a pidl.
         SendMessage(hwnd, BFFM_SETSELECTION, TRUE, (LPARAM)szDirName);
      }
      break;
   }
   return 0;
}


// minigui tambien
HB_FUNC( CGETFOLDER ) // Based Upon Code Contributed By Ryszard Ryüko
{
   HWND hwnd = GetActiveWindow();
   BROWSEINFO bi;
   char *lpBuffer = (char*) hb_xgrab( MAX_PATH+1);
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user

    bi.hwndOwner = hwnd;
    bi.pidlRoot = NULL;
    bi.pszDisplayName = lpBuffer;
    bi.lpszTitle = hb_parc(1);
    bi.ulFlags = BIF_RETURNONLYFSDIRS + BIF_DONTGOBELOWDOMAIN + BIF_USENEWUI;
    bi.lpfn = BrowseCallbackProc;
    bi.lParam = 0;

   strcpy( szDirName, (hb_parc( 2 )? hb_parc( 2 ): IniDir) );

    // Browse for a folder and return its PIDL.
    pidlBrowse = SHBrowseForFolder(&bi);
    SHGetPathFromIDList(pidlBrowse,lpBuffer);
    hb_retc(lpBuffer);
    hb_xfree( lpBuffer);
}


#pragma ENDDUMP

