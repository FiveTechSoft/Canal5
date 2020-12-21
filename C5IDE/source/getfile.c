#define _WIN32_WINNT 0x0400         // Borland 5.5 special requirement !!!

#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>
#include <CommDlg.h>

#define OFN_LONGNAMES   0x00200000L
#define WF_WINNT        0x4000

BOOL IsWin95( void );

static far WORD wIndex;
static far HFONT hFont  = 0;
static far char Font[]  = "MS Sans Serif";
static far char Title[] = "Select the file";

//----------------------------------------------------------------------------//

BOOL CALLBACK ComDlgHkFile(HWND hDlg,
                         UINT uMsg,
                         WPARAM wParam,
                         LPARAM lPar)
{
   HANDLE hCtrl;
   BOOL   lEnd  = FALSE;

   switch (uMsg)
   {
      case WM_INITDIALOG:

        hFont = CreateFont(14,5, 0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0, 0, Font);

        if ( hFont && (( hCtrl = GetWindow( hDlg, GW_CHILD ) ) != 0))
        {
         while(!lEnd)
         {
          SendMessage( ( HWND ) hCtrl, WM_SETFONT, ( WPARAM ) hFont, 1 );
          hCtrl = ( HANDLE ) GetWindow( ( HWND) hCtrl, GW_HWNDNEXT );
          lEnd = !( (hCtrl != 0) && (GetParent( ( HWND ) hCtrl) == hDlg) );
         }
        }
        break;

      case WM_DESTROY:

        if (hFont != NULL)
        {
          DeleteObject(hFont);
        }

        break;
    }

    return FALSE;
}

//----------------------------------------------------------------------------//

CLIPPER CGETFILE( PARAMS )   // ( cFileMask, cTitle, nDefaultMask, ;
                             // cInitDir, lSave, lLongNames, nFlags, ;
                             // cIniFile )  --> cFileName
{
   OPENFILENAME ofn;
   LPSTR pFile, pFilter, pDir, pTitle;
   WORD w = 0, wLen;
   BYTE bIndex = _parni( 3 );
   BOOL bSave = IF( PCOUNT() > 4 && ISLOGICAL( 5 ), _parl( 5 ), FALSE );
   BOOL bLongNames = _parl( 6 );
   DWORD dwFlags = _parnl( 7 );

   if( PCOUNT() < 1 )
   {
      _retc( "" );
       return;
   }

   // alloc for title

   pTitle = ( LPSTR ) _xgrab( 128 );

   if ( PCOUNT() > 1 && ISCHAR( 2 ) )
   {
      wLen   = min( ( unsigned long ) 127, _parclen( 2 ) );
      _bcopy( pTitle, _parc( 2 ), wLen );
      * ( pTitle + wLen ) = 0;

   }
   else
   {
      pTitle  = Title;
   }

   // alloc for initial dir

   pDir = ( LPSTR ) _xgrab( 128 );

   if ( PCOUNT() > 3 && ISCHAR( 4 ) )
   {
      wLen  = min( ( unsigned long ) 127, _parclen( 4 ) );
      _bcopy( pDir, _parc( 4 ), wLen );
      * ( pDir + wLen ) = 0;
   }
   else
   {
      * ( pDir ) = 0;
   }

   // alloc for file

   pFile = ( LPSTR ) _xgrab( 128 );

   if ( PCOUNT() > 7 && ISCHAR( 8 ) )
   {
      wLen = min( ( unsigned long ) 127, _parclen( 8 ) );
      _bcopy( pFile, _parc( 8 ), wLen );
   }
   else
   {
      wLen = min( ( unsigned long ) 127, _parclen( 1 ) );
      _bcopy( pFile, _parc( 1 ), wLen );
   }
   * ( pFile + wLen ) = 0;

   // alloc for mask

   pFilter = ( LPSTR ) _xgrab( 400 );
   wLen    = min( ( unsigned long ) 398, _parclen( 1 ) );
   _bcopy( pFilter, _parc( 1 ), wLen );
   * ( pFilter + wLen ) = 0;

   #ifndef __FLAT__
   //   _xunlock();
   #endif

   while( * ( pFilter + w ) )
   {
      if( * ( pFilter + w ) == '|' )
      {
         * ( pFilter + w ) = 0;
         if ( PCOUNT() < 8 )
            * (pFile) = 0;
      }
      w++;
   }

   * ( pFilter + wLen  ) = 0;
   * ( pFilter + wLen + 1 ) = 0;

   _bset( ( char * ) &ofn, 0, sizeof( OPENFILENAME ) );

   ofn.lStructSize     = sizeof( OPENFILENAME );
   ofn.hwndOwner       = GetActiveWindow();
   ofn.lpstrFilter     = pFilter;
   ofn.lpstrCustomFilter = 0; // NIL;
   ofn.nFilterIndex    = bIndex ? bIndex: 1;
   ofn.lpstrFile       = pFile;
   ofn.nMaxFile        = 128;
   ofn.lpstrFileTitle  = 0; // NIL;
   ofn.lpstrInitialDir = pDir;
   ofn.lpstrTitle      = pTitle;
   ofn.Flags           = OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR |
                        IF( bSave, OFN_HIDEREADONLY, 0 ) |
                        IF( bLongNames, OFN_LONGNAMES, 0 );

   #ifndef __FLAT__
   if( IsWin95() || GetWinFlags() & WF_WINNT )
     {
      ofn.Flags    |= OFN_ENABLEHOOK;
      ofn.lpfnHook  = ComDlgHkFile;
     }
   #endif

   if( dwFlags )
      ofn.Flags = dwFlags;

   wIndex = 0;

   if( bSave )
   {
      if( GetSaveFileName( &ofn ) )
         _retc( pFile );
      else
         _retc( "" );
   }
   else
   {
      if( GetOpenFileName( &ofn ) )
         _retc( pFile );
      else
         _retc( "" );
   }

   wIndex = ofn.nFilterIndex;

   _xfree( pFilter );
   _xfree( pFile );
   _xfree( pDir );
   _xfree( pTitle );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER NGETFILEFILTER( PARAMS )   // ()    Returns the index of the filter selection
#else
   CLIPPER NGETFILEFI( PARAMS )   //  LTER()    Returns the index of the filter selection
#endif
{
   _retni( wIndex );
}

//----------------------------------------------------------------------------//
