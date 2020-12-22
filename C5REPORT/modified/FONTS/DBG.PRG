#include 'fivewin.ch'


FUNCTION Main()

   Dbg( Time() )

   MsgInfo( 'Output to DBWin32.exe' )

RETU nil

FUNCTION Dbg( xVal, cTitle )

   DEFAULT cTitle := Procname(1) + ': (' + ltrim(str(Procline(1))) + ') '

   OutputDebugString( cTitle + ' => ' + cValToChar( xVal ) + CRLF )

RETURN NIL


DLL32 FUNCTION OutputDebugString( cOutStr AS LPSTR ) As VOID PASCAL ;
  FROM "OutputDebugStringA" lib "kernel32.dll"

*#pragma BEGINDUMP
*
*#include <windows.h>
*#include "hbapi.h"
*
*HB_FUNC( OUTPUTDEBUGSTRINGC )
*{
* OutPutDebugStringA( hb_parc( 1 ) );
*}
*
*#pragma ENDDUMP
*
*FUNCTION OutPutDebugString( xVal )
*
*    OutPutDebugStringC( cValToChar( xVal ))
*
*RETURN NIL

