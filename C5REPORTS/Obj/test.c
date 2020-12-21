/*
 * Harbour 3.2.0dev (r1712141320)
 * Borland/Embarcadero C++ 7.3 (32-bit)
 * Generated C source from "Source\test.prg"
 */

#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"


HB_FUNC( INFORMES );
HB_FUNC_EXTERN( MENUBEGIN );
HB_FUNC_EXTERN( MENUADDITEM );
HB_FUNC_EXTERN( MENUEND );
HB_FUNC_EXTERN( TFONT );
HB_FUNC_EXTERN( TWINDOW );
HB_FUNC_EXTERN( TPANEL );
HB_FUNC_EXTERN( TBAR );
HB_FUNC_EXTERN( TBTNBMP );
HB_FUNC( RESETBAR );
HB_FUNC_EXTERN( TLISTPROP );
HB_FUNC_EXTERN( TSOPORTE );
HB_FUNC_EXTERN( TBANDA );
HB_FUNC_EXTERN( TSCROLLBAR );
HB_FUNC( INSPECTOR );
HB_FUNC_EXTERN( LEN );
HB_FUNC( AGETFONTNAMES );
HB_FUNC_EXTERN( GETDC );
HB_FUNC_EXTERN( GETFONTNAMES );
HB_FUNC_EXTERN( ASORT );
HB_FUNC_EXTERN( RELEASEDC );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TEST )
{ "INFORMES", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( INFORMES )}, NULL },
{ "MENUBEGIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUBEGIN )}, NULL },
{ "MENUADDITEM", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUADDITEM )}, NULL },
{ "MENUEND", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUEND )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFONT )}, NULL },
{ "TWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( TWINDOW )}, NULL },
{ "TPANEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TPANEL )}, NULL },
{ "_OLEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBAR )}, NULL },
{ "_BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEWBAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBTNBMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBTNBMP )}, NULL },
{ "_LPRESSED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPRESSED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESETBAR", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( RESETBAR )}, NULL },
{ "SETGRID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LGRID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TLISTPROP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TLISTPROP )}, NULL },
{ "_OCLIENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NLINESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSOPORTE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSOPORTE )}, NULL },
{ "NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OINSPECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBANDA", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBANDA )}, NULL },
{ "_OHSCROLL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WINNEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSCROLLBAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSCROLLBAR )}, NULL },
{ "MOVELEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OVSCROLL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOVEUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOVEDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETPROPERTIES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRESIZED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BKEYDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BINIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLBUTTONUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INSPECTOR", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( INSPECTOR )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ACONTROLS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AGETFONTNAMES", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( AGETFONTNAMES )}, NULL },
{ "GETDC", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETDC )}, NULL },
{ "HWND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFONTNAMES", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETFONTNAMES )}, NULL },
{ "ASORT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASORT )}, NULL },
{ "RELEASEDC", {HB_FS_PUBLIC}, {HB_FUNCNAME( RELEASEDC )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00006)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TEST, "Source\\test.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TEST
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TEST )
   #include "hbiniseg.h"
#endif

HB_FUNC( INFORMES )
{
   static const HB_BYTE pcode[] =
   {
	HB_P_FRAME, 15, 0,
	HB_P_SFRAME, 54, 0,
	HB_P_LINE, 14, 0,
	HB_P_PUSHBYTE, 20,
	HB_P_POPLOCALNEAR, 7,
	HB_P_LINE, 17, 0,
	HB_P_PUSHFUNCSYM, 1, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FUNCTIONSHORT, 48,
	HB_P_POPLOCALNEAR, 6,
	HB_P_LINE, 18, 0,
	HB_P_PUSHFUNCSYM, 2, 0,
	HB_P_PUSHSTRSHORT, 8,
	'A', 'r', 'c', 'h', 'i', 'v', 'o', 0, 
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_DOSHORT, 47,
	HB_P_LINE, 19, 0,
	HB_P_PUSHFUNCSYM, 2, 0,
	HB_P_PUSHSTRSHORT, 8,
	'E', 'd', 'i', 'c', 'i', 243, 'n', 0, 
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_DOSHORT, 47,
	HB_P_LINE, 20, 0,
	HB_P_PUSHFUNCSYM, 2, 0,
	HB_P_PUSHSTRSHORT, 8,
	'F', 'o', 'r', 'm', 'a', 't', 'o', 0, 
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_DOSHORT, 47,
	HB_P_LINE, 21, 0,
	HB_P_PUSHFUNCSYM, 2, 0,
	HB_P_PUSHSTRSHORT, 6,
	'V', 'i', 's', 't', 'a', 0, 
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_DOSHORT, 47,
	HB_P_LINE, 22, 0,
	HB_P_PUSHFUNCSYM, 3, 0,
	HB_P_DOSHORT, 0,
	HB_P_LINE, 23, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 5, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 8,
	'V', 'e', 'r', 'd', 'a', 'n', 'a', 0, 
	HB_P_ZERO,
	HB_P_PUSHBYTE, 245,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 18,
	HB_P_POPLOCALNEAR, 5,
	HB_P_LINE, 25, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 6, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHLOCALNEAR, 6,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_TRUE,
	HB_P_TRUE,
	HB_P_ZERO,
	HB_P_PUSHLONG, 128, 128, 128, 0,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_TRUE,
	HB_P_TRUE,
	HB_P_TRUE,
	HB_P_TRUE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 5,
	'o', 'W', 'n', 'd', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 25,
	HB_P_POPLOCALNEAR, 1,
	HB_P_LINE, 28, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 7, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_ZERO,
	HB_P_ZERO,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHINT, 44, 1,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 5,
	HB_P_POPLOCALNEAR, 4,
	HB_P_LINE, 29, 0,
	HB_P_MESSAGE, 8, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_PUSHLOCALNEAR, 4,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 31, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 9, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHLOCALNEAR, 4,
	HB_P_PUSHBYTE, 32,
	HB_P_PUSHBYTE, 32,
	HB_P_TRUE,
	HB_P_PUSHSTRSHORT, 6,
	'R', 'I', 'G', 'H', 'T', 0, 
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_FALSE,
	HB_P_SENDSHORT, 18,
	HB_P_POPSTATIC, 6, 0,
	HB_P_LINE, 32, 0,
	HB_P_MESSAGE, 10, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_PUSHBLOCKSHORT, 4,
	HB_P_TRUE,
	HB_P_ENDBLOCK,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 34, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 9,
	'c', 'u', 'r', 'a', 'r', 'r', 'o', 'w', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 37, 0,
	1, 0,
	1, 0,
	8, 0,
	HB_P_ZERO,
	HB_P_POPSTATIC, 3, 0,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_MESSAGE, 14, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_NOT,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_MESSAGE, 15, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_TRUE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 59,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '0', ',', ' ', ' ', 'o', '1', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '!', 'o', '1', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ',', ' ', 'o', '1', ':', 'R', 'e', 'f', 'r', 'e', 's', 'h', '(', ')', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 8,
	HB_P_LINE, 35, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 5,
	't', 'e', 'x', 't', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 28, 0,
	1, 0,
	1, 0,
	9, 0,
	HB_P_ONE,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 59,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '1', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '2', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 9,
	HB_P_LINE, 36, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 6,
	'f', 'i', 'e', 'l', 'd', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 29, 0,
	1, 0,
	1, 0,
	10, 0,
	HB_P_PUSHBYTE, 2,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 59,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '2', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '3', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 10,
	HB_P_LINE, 37, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 6,
	'i', 'm', 'a', 'g', 'e', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 29, 0,
	1, 0,
	1, 0,
	11, 0,
	HB_P_PUSHBYTE, 5,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 59,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '5', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '4', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 11,
	HB_P_LINE, 38, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 5,
	'l', 'i', 'n', 'e', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 29, 0,
	1, 0,
	1, 0,
	12, 0,
	HB_P_PUSHBYTE, 3,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 60,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '3', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '5', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 12,
	HB_P_LINE, 39, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 4,
	'b', 'o', 'x', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 29, 0,
	1, 0,
	1, 0,
	13, 0,
	HB_P_PUSHBYTE, 4,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 61,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '4', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '6', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 13,
	HB_P_LINE, 40, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 5,
	'b', 'a', 's', 'e', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 29, 0,
	1, 0,
	1, 0,
	14, 0,
	HB_P_PUSHBYTE, 6,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHFUNCSYM, 16, 0,
	HB_P_FALSE,
	HB_P_DOSHORT, 1,
	HB_P_MESSAGE, 13, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_TRUE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 60,
	'(', 'n', 'A', 'c', 't', 'i', 'v', 'o', ' ', ':', '=', ' ', '6', ',', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'R', 'e', 's', 'e', 't', 'B', 'a', 'r', '(', '.', 'F', '.', ')', ',', ' ', 'o', '7', ':', 'l', 'P', 'r', 'e', 's', 's', 'e', 'd', ' ', ':', '=', ' ', '.', 'T', '.', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 14,
	HB_P_LINE, 41, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHSTRSHORT, 5,
	'g', 'r', 'i', 'd', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHBLOCK, 25, 0,
	1, 0,
	1, 0,
	3, 0,
	HB_P_MESSAGE, 17, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_MESSAGE, 18, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_NOT,
	HB_P_SENDSHORT, 1,
	HB_P_ENDBLOCK,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 26,
	'o', 'S', 'p', ':', 'S', 'e', 't', 'G', 'r', 'i', 'd', '(', ' ', '!', 'o', 'S', 'p', ':', 'l', 'G', 'r', 'i', 'd', ' ', ')', 0, 
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POPLOCALNEAR, 15,
	HB_P_LINE, 42, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POP,
	HB_P_LINE, 43, 0,
	HB_P_MESSAGE, 11, 0,
	HB_P_PUSHFUNCSYM, 12, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 29,
	HB_P_POP,
	HB_P_LINE, 49, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 19, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHBYTE, 2,
	HB_P_PUSHBYTE, 2,
	HB_P_PUSHINT, 200, 0,
	HB_P_PUSHINT, 244, 1,
	HB_P_PUSHNIL,
	HB_P_PUSHSTRSHORT, 1,
	0, 
	HB_P_PUSHSTRSHORT, 1,
	0, 
	HB_P_PUSHSTRSHORT, 1,
	0, 
	HB_P_ARRAYGEN, 3, 0,
	HB_P_PUSHBYTE, 20,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHBYTE, 100,
	HB_P_ARRAYGEN, 3, 0,
	HB_P_PUSHLOCALNEAR, 4,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHLOCALNEAR, 5,
	HB_P_SENDSHORT, 15,
	HB_P_POPSTATIC, 5, 0,
	HB_P_LINE, 51, 0,
	HB_P_MESSAGE, 20, 0,
	HB_P_PUSHLOCALNEAR, 4,
	HB_P_PUSHSTATIC, 5, 0,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 52, 0,
	HB_P_MESSAGE, 21, 0,
	HB_P_PUSHSTATIC, 5, 0,
	HB_P_PUSHBYTE, 2,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 54, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 22, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_ZERO,
	HB_P_MESSAGE, 23, 0,
	HB_P_PUSHLOCALNEAR, 4,
	HB_P_SENDSHORT, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 3,
	HB_P_POPLOCALNEAR, 3,
	HB_P_LINE, 56, 0,
	HB_P_MESSAGE, 24, 0,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_PUSHSTATIC, 5, 0,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 58, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 25, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHLOCALNEAR, 7,
	HB_P_ZERO,
	HB_P_PUSHINT, 188, 2,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_PUSHSTRSHORT, 11,
	'P', 'a', 'g', 'e', 'H', 'e', 'a', 'd', 'e', 'r', 0, 
	HB_P_SENDSHORT, 6,
	HB_P_POPLOCALNEAR, 2,
	HB_P_LINE, 59, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 25, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHLOCALNEAR, 7,
	HB_P_PUSHBYTE, 100,
	HB_P_PLUS,
	HB_P_PUSHBYTE, 20,
	HB_P_PLUS,
	HB_P_ZERO,
	HB_P_PUSHINT, 188, 2,
	HB_P_PUSHINT, 144, 1,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_PUSHSTRSHORT, 7,
	'D', 'e', 't', 'a', 'i', 'l', 0, 
	HB_P_SENDSHORT, 6,
	HB_P_POPLOCALNEAR, 2,
	HB_P_LINE, 60, 0,
	HB_P_MESSAGE, 4, 0,
	HB_P_PUSHFUNCSYM, 25, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_PUSHLOCALNEAR, 7,
	HB_P_PUSHBYTE, 100,
	HB_P_PLUS,
	HB_P_PUSHBYTE, 20,
	HB_P_PLUS,
	HB_P_PUSHINT, 144, 1,
	HB_P_PLUS,
	HB_P_PUSHBYTE, 20,
	HB_P_PLUS,
	HB_P_ZERO,
	HB_P_PUSHINT, 188, 2,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_PUSHSTRSHORT, 11,
	'P', 'a', 'g', 'e', 'F', 'o', 'o', 't', 'e', 'r', 0, 
	HB_P_SENDSHORT, 6,
	HB_P_POPLOCALNEAR, 2,
	HB_P_LINE, 65, 0,
	HB_P_MESSAGE, 26, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_MESSAGE, 27, 0,
	HB_P_PUSHFUNCSYM, 28, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_ONE,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_PUSHBLOCK, 17, 0,
	0, 0,
	1, 0,
	3, 0,
	HB_P_MESSAGE, 29, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_ENDBLOCK,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 16,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 73, 0,
	HB_P_MESSAGE, 30, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_MESSAGE, 27, 0,
	HB_P_PUSHFUNCSYM, 28, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_ONE,
	HB_P_PUSHBYTE, 100,
	HB_P_PUSHNIL,
	HB_P_TRUE,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_PUSHBLOCK, 17, 0,
	0, 0,
	1, 0,
	3, 0,
	HB_P_MESSAGE, 31, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_ENDBLOCK,
	HB_P_PUSHBLOCK, 17, 0,
	0, 0,
	1, 0,
	3, 0,
	HB_P_MESSAGE, 32, 0,
	HB_P_PUSHLOCALNEAR, 255,
	HB_P_SENDSHORT, 0,
	HB_P_ENDBLOCK,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_FALSE,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_SENDSHORT, 16,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 75, 0,
	HB_P_MESSAGE, 33, 0,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_SENDSHORT, 0,
	HB_P_POP,
	HB_P_LINE, 88, 0,
	HB_P_MESSAGE, 34, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_PUSHSTRSHORT, 10,
	'M', 'A', 'X', 'I', 'M', 'I', 'Z', 'E', 'D', 0, 
	HB_P_MESSAGE, 35, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 36, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 37, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 38, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 39, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 40, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_MESSAGE, 41, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_PUSHNIL,
	HB_P_MESSAGE, 42, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_FALSE,
	HB_P_SENDSHORT, 20,
	HB_P_POP,
	HB_P_LINE, 90, 0,
	HB_P_PUSHNIL,
	HB_P_RETVALUE,
	HB_P_ENDPROC
   };

   hb_vmExecute( pcode, symbols );
}

HB_FUNC( INSPECTOR )
{
   static const HB_BYTE pcode[] =
   {
	HB_P_SFRAME, 54, 0,
	HB_P_LINE, 94, 0,
	HB_P_PUSHSTATIC, 5, 0,
	HB_P_RETVALUE,
	HB_P_ENDPROC
   };

   hb_vmExecute( pcode, symbols );
}

HB_FUNC( RESETBAR )
{
   static const HB_BYTE pcode[] =
   {
	HB_P_FRAME, 2, 1,
	HB_P_SFRAME, 54, 0,
	HB_P_LINE, 99, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_PUSHNIL,
	HB_P_EXACTLYEQUAL,
	HB_P_JUMPFALSENEAR, 5,
	HB_P_TRUE,
	HB_P_POPLOCALNEAR, 1,
	HB_P_LINE, 101, 0,
	HB_P_PUSHFUNCSYM, 44, 0,
	HB_P_MESSAGE, 45, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_SENDSHORT, 0,
	HB_P_FUNCTIONSHORT, 1,
	HB_P_POPLOCALNEAR, 3,
	HB_P_LINE, 102, 0,
	HB_P_ONE,
	HB_P_PUSHUNREF,
	HB_P_POPLOCALNEAR, 2,
	HB_P_JUMPNEAR, 49,
	HB_P_LINE, 103, 0,
	HB_P_MESSAGE, 13, 0,
	HB_P_MESSAGE, 45, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_SENDSHORT, 0,
	HB_P_PUSHLOCALNEAR, 2,
	HB_P_ARRAYPUSH,
	HB_P_FALSE,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 104, 0,
	HB_P_MESSAGE, 15, 0,
	HB_P_MESSAGE, 45, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_SENDSHORT, 0,
	HB_P_PUSHLOCALNEAR, 2,
	HB_P_ARRAYPUSH,
	HB_P_SENDSHORT, 0,
	HB_P_POP,
	HB_P_LINE, 102, 0,
	HB_P_LOCALINCPUSH, 2, 0,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_GREATER,
	HB_P_JUMPFALSENEAR, 206,
	HB_P_LINE, 106, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_JUMPFALSENEAR, 48,
	HB_P_LINE, 107, 0,
	HB_P_MESSAGE, 13, 0,
	HB_P_MESSAGE, 45, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_SENDSHORT, 0,
	HB_P_ONE,
	HB_P_ARRAYPUSH,
	HB_P_TRUE,
	HB_P_SENDSHORT, 1,
	HB_P_POP,
	HB_P_LINE, 108, 0,
	HB_P_MESSAGE, 15, 0,
	HB_P_MESSAGE, 45, 0,
	HB_P_PUSHSTATIC, 6, 0,
	HB_P_SENDSHORT, 0,
	HB_P_ONE,
	HB_P_ARRAYPUSH,
	HB_P_SENDSHORT, 0,
	HB_P_POP,
	HB_P_LINE, 109, 0,
	HB_P_ZERO,
	HB_P_POPSTATIC, 3, 0,
	HB_P_LINE, 112, 0,
	HB_P_PUSHNIL,
	HB_P_RETVALUE,
	HB_P_ENDPROC
   };

   hb_vmExecute( pcode, symbols );
}

HB_FUNC( AGETFONTNAMES )
{
   static const HB_BYTE pcode[] =
   {
	HB_P_FRAME, 3, 0,
	HB_P_LINE, 116, 0,
	HB_P_PUSHFUNCSYM, 43, 0,
	HB_P_FUNCTIONSHORT, 0,
	HB_P_POPLOCALNEAR, 1,
	HB_P_LINE, 117, 0,
	HB_P_PUSHFUNCSYM, 47, 0,
	HB_P_MESSAGE, 48, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_FUNCTIONSHORT, 1,
	HB_P_POPLOCALNEAR, 2,
	HB_P_LINE, 118, 0,
	HB_P_PUSHFUNCSYM, 49, 0,
	HB_P_PUSHLOCALNEAR, 2,
	HB_P_FUNCTIONSHORT, 1,
	HB_P_POPLOCALNEAR, 3,
	HB_P_LINE, 119, 0,
	HB_P_PUSHFUNCSYM, 50, 0,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_FUNCTIONSHORT, 1,
	HB_P_POPLOCALNEAR, 3,
	HB_P_LINE, 120, 0,
	HB_P_PUSHFUNCSYM, 51, 0,
	HB_P_MESSAGE, 48, 0,
	HB_P_PUSHLOCALNEAR, 1,
	HB_P_SENDSHORT, 0,
	HB_P_PUSHLOCALNEAR, 2,
	HB_P_DOSHORT, 2,
	HB_P_LINE, 122, 0,
	HB_P_PUSHLOCALNEAR, 3,
	HB_P_RETVALUE,
	HB_P_ENDPROC
   };

   hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
   static const HB_BYTE pcode[] =
   {
	HB_P_STATICS, 54, 0, 6, 0,
	HB_P_SFRAME, 54, 0,
	HB_P_ARRAYGEN, 0, 0,
	HB_P_POPSTATIC, 1, 0,
	HB_P_PUSHNIL,
	HB_P_POPSTATIC, 2, 0,
	HB_P_ZERO,
	HB_P_POPSTATIC, 3, 0,
	HB_P_PUSHBYTE, 100,
	HB_P_POPSTATIC, 4, 0,
	HB_P_ENDPROC
   };

   hb_vmExecute( pcode, symbols );
}

#line 129 "Source\\test.prg"

#include <windows.h>
#include <hbapi.h>
#include <hbapierr.h>
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbapirdd.h"
#include "hbxvm.h"

    HB_FUNC( UNIONRECT )
   {

      RECT rc, rc0, rc1;


      rc0.top    = hb_parvni( 1, 1 );
      rc0.left   = hb_parvni( 1, 2 );
      rc0.bottom = hb_parvni( 1, 3 );
      rc0.right  = hb_parvni( 1, 4 );

      rc1.top    = hb_parvni( 2, 1 );
      rc1.left   = hb_parvni( 2, 2 );
      rc1.bottom = hb_parvni( 2, 3 );
      rc1.right  = hb_parvni( 2, 4 );

      UnionRect( &rc, &rc0, &rc1 );
      hb_reta(4);

      hb_storvni( rc.top    , -1, 1 );
      hb_storvni( rc.left   , -1, 2 );
      hb_storvni( rc.bottom , -1, 3 );
      hb_storvni( rc.right  , -1, 4 );

   }
