/*
 * Harbour 1.0.1dev Intl. (Rev. 9361)
 * Borland C++ 5.5.1 (32 bit)
 * Generated C source from ".\FONTS\RULE.PRG"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TC5RULE );
HB_FUNC_STATIC( TC5RULE_NEW );
HB_FUNC_STATIC( TC5RULE_PAINT );
HB_FUNC_STATIC( TC5RULE_HANDLEEVENT );
HB_FUNC_STATIC( TC5RULE_MAKERULE );
HB_FUNC_STATIC( TC5RULE_LBUTTONDOWN );
HB_FUNC_STATIC( TC5RULE_MOUSEMOVE );
HB_FUNC_STATIC( TC5RULE_GETCOORDS );
HB_FUNC_INITSTATICS();
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TCONTROL );
HB_FUNC_EXTERN( DELETEOBJECT );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( NOR );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( GETCLIENTRECT );
HB_FUNC_EXTERN( DRAWBITMAP );
HB_FUNC_EXTERN( MOVETO );
HB_FUNC_EXTERN( LINETO );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( TFONT );
HB_FUNC_EXTERN( SELECTOBJECT );
HB_FUNC_EXTERN( SETBKMODE );
HB_FUNC_EXTERN( SETTEXTCOLOR );
HB_FUNC_EXTERN( VMM2PIX );
HB_FUNC_EXTERN( TEXTOUT );
HB_FUNC_EXTERN( HMM2PIX );
HB_FUNC_EXTERN( CREATEDC );
HB_FUNC_EXTERN( GETDEVICECAPS );
HB_FUNC_EXTERN( CREATECOMPATIBLEDC );
HB_FUNC_EXTERN( CREATECOMPATIBLEBITMAP );
HB_FUNC_EXTERN( HORIZONTALGRADIENT );
HB_FUNC_EXTERN( VERTICALGRADIENT );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( DELETEDC );
HB_FUNC_EXTERN( PTINRECT );
HB_FUNC_EXTERN( ADEL );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( VPIX2MM );
HB_FUNC_EXTERN( HPIX2MM );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( CURSORARROW );
HB_FUNC_EXTERN( CURSORHAND );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_RULE )
{ "TC5RULE", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TCONTROL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCONTROL )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMULTICLSDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TC5RULE_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_NEW )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELETEOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( DELETEOBJECT )}, NULL },
{ "HBMPMEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DESTROY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCONTROL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BEGINPAINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PAINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ENDPAINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TC5RULE_PAINT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_PAINT )}, NULL },
{ "TC5RULE_HANDLEEVENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_HANDLEEVENT )}, NULL },
{ "TC5RULE_MAKERULE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_MAKERULE )}, NULL },
{ "TC5RULE_LBUTTONDOWN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_LBUTTONDOWN )}, NULL },
{ "TC5RULE_MOUSEMOVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_MOUSEMOVE )}, NULL },
{ "TC5RULE_GETCOORDS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TC5RULE_GETCOORDS )}, NULL },
{ "MAKERULE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OWND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NLEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NRIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NLEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCLRTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCLRPANE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OLINKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LVERTICAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LVERTICAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NINIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACOORDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OLINKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NSTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NOR )}, NULL },
{ "_NID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETNEWID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REGISTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "HWND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LVISIBLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCONTROL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFCONTROL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCLIENTRECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETCLIENTRECT )}, NULL },
{ "DRAWBITMAP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DRAWBITMAP )}, NULL },
{ "HDC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOVETO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MOVETO )}, NULL },
{ "NGUIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOFFSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LINETO", {HB_FS_PUBLIC}, {HB_FUNCNAME( LINETO )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "AGUIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFONT )}, NULL },
{ "SELECTOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( SELECTOBJECT )}, NULL },
{ "HFONT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETBKMODE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETBKMODE )}, NULL },
{ "SETTEXTCOLOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETTEXTCOLOR )}, NULL },
{ "VMM2PIX", {HB_FS_PUBLIC}, {HB_FUNCNAME( VMM2PIX )}, NULL },
{ "NZOOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TEXTOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TEXTOUT )}, NULL },
{ "HMM2PIX", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMM2PIX )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HANDLEEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEDC", {HB_FS_PUBLIC}, {HB_FUNCNAME( CREATEDC )}, NULL },
{ "GETDEVICECAPS", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETDEVICECAPS )}, NULL },
{ "CREATECOMPATIBLEDC", {HB_FS_PUBLIC}, {HB_FUNCNAME( CREATECOMPATIBLEDC )}, NULL },
{ "_HBMPMEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATECOMPATIBLEBITMAP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CREATECOMPATIBLEBITMAP )}, NULL },
{ "HORIZONTALGRADIENT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HORIZONTALGRADIENT )}, NULL },
{ "NCLRPANE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VERTICALGRADIENT", {HB_FS_PUBLIC}, {HB_FUNCNAME( VERTICALGRADIENT )}, NULL },
{ "_NGUIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NINIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "DELETEDC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DELETEDC )}, NULL },
{ "PTINRECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PTINRECT )}, NULL },
{ "GETCOORDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADEL )}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VPIX2MM", {HB_FS_PUBLIC}, {HB_FUNCNAME( VPIX2MM )}, NULL },
{ "NINVRATIO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HPIX2MM", {HB_FS_PUBLIC}, {HB_FUNCNAME( HPIX2MM )}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "CURSORARROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORARROW )}, NULL },
{ "CURSORHAND", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORHAND )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_RULE, ".\\FONTS\\RULE.PRG", 0x0, 0x0002 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_RULE
#elif defined( HB_MSC_STARTUP )
   #if defined( HB_OS_WIN_64 )
      #pragma section( HB_MSC_START_SEGMENT, long, read )
   #endif
   #pragma data_seg( HB_MSC_START_SEGMENT )
   static HB_$INITSYM hb_vm_auto_SymbolInit_RULE = hb_vm_SymbolInit_RULE;
   #pragma data_seg()
#endif

HB_FUNC( TC5RULE )
{
	static const BYTE pcode[] =
	{
		149,2,0,116,98,0,36,13,0,103,2,0,100,8,
		29,222,2,122,80,1,48,1,0,176,2,0,12,0,
		106,8,84,67,53,82,117,108,101,0,108,3,4,1,
		0,108,0,112,3,82,2,0,36,15,0,48,4,0,
		103,2,0,100,100,95,1,106,8,111,76,105,110,107,
		101,100,0,4,1,0,9,112,5,73,36,16,0,48,
		4,0,103,2,0,106,8,78,85,77,69,82,73,67,
		0,121,95,1,106,8,110,79,102,102,115,101,116,0,
		4,1,0,9,112,5,73,36,17,0,48,4,0,103,
		2,0,106,8,76,79,71,73,67,65,76,0,9,95,
		1,106,10,108,86,101,114,116,105,99,97,108,0,4,
		1,0,9,112,5,73,36,18,0,48,4,0,103,2,
		0,106,8,78,85,77,69,82,73,67,0,121,95,1,
		106,6,110,71,117,105,97,0,4,1,0,9,112,5,
		73,36,19,0,48,4,0,103,2,0,100,100,95,1,
		106,8,104,66,109,112,77,101,109,0,4,1,0,9,
		112,5,73,36,20,0,48,4,0,103,2,0,106,8,
		78,85,77,69,82,73,67,0,121,95,1,106,6,110,
		73,110,105,116,0,4,1,0,9,112,5,73,36,21,
		0,48,4,0,103,2,0,106,6,65,82,82,65,89,
		0,4,0,0,95,1,106,7,97,71,117,105,97,115,
		0,4,1,0,9,112,5,73,36,23,0,48,5,0,
		103,2,0,106,8,76,79,71,73,67,65,76,0,100,
		95,1,92,32,72,106,12,108,82,101,103,105,115,116,
		101,114,101,100,0,4,1,0,9,112,5,73,36,25,
		0,48,6,0,103,2,0,106,4,78,101,119,0,108,
		7,95,1,92,8,72,112,3,73,36,26,0,48,8,
		0,103,2,0,106,8,68,101,115,116,114,111,121,0,
		89,32,0,1,0,0,0,176,9,0,48,10,0,95,
		1,112,0,20,1,48,11,0,48,12,0,95,1,112,
		0,112,0,6,95,1,112,3,73,36,27,0,48,8,
		0,103,2,0,106,8,68,105,115,112,108,97,121,0,
		89,33,0,1,0,0,0,48,13,0,95,1,112,0,
		73,48,14,0,95,1,112,0,73,48,15,0,95,1,
		112,0,73,121,6,95,1,112,3,73,36,28,0,48,
		6,0,103,2,0,106,6,80,97,105,110,116,0,108,
		16,95,1,112,3,73,36,29,0,48,6,0,103,2,
		0,106,12,72,97,110,100,108,101,69,118,101,110,116,
		0,108,17,95,1,112,3,73,36,30,0,48,6,0,
		103,2,0,106,9,77,97,107,101,82,117,108,101,0,
		108,18,95,1,112,3,73,36,31,0,48,6,0,103,
		2,0,106,12,76,66,117,116,116,111,110,68,111,119,
		110,0,108,19,95,1,112,3,73,36,32,0,48,6,
		0,103,2,0,106,10,77,111,117,115,101,77,111,118,
		101,0,108,20,95,1,112,3,73,36,33,0,48,6,
		0,103,2,0,106,10,71,101,116,67,111,111,114,100,
		115,0,108,21,95,1,112,3,73,36,34,0,48,8,
		0,103,2,0,106,7,82,101,115,105,122,101,0,89,
		15,0,1,0,0,0,48,22,0,95,1,112,0,6,
		95,1,112,3,73,36,36,0,48,23,0,103,2,0,
		112,0,73,48,24,0,103,2,0,112,0,80,2,176,
		25,0,95,2,106,10,73,110,105,116,67,108,97,115,
		115,0,12,2,28,12,48,26,0,95,2,164,146,1,
		0,73,95,2,110,7,48,24,0,103,2,0,112,0,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_NEW )
{
	static const BYTE pcode[] =
	{
		13,1,9,36,39,0,102,80,10,36,42,0,95,6,
		100,8,28,5,121,80,6,36,43,0,95,7,100,8,
		28,9,97,255,255,255,0,80,7,36,44,0,95,8,
		100,8,28,5,120,80,8,36,46,0,48,27,0,95,
		10,95,5,112,1,73,36,47,0,48,28,0,95,10,
		95,1,112,1,73,36,48,0,48,29,0,95,10,95,
		2,112,1,73,36,49,0,48,30,0,95,10,48,31,
		0,95,10,112,0,95,4,72,112,1,73,36,50,0,
		48,32,0,95,10,48,33,0,95,10,112,0,95,3,
		72,112,1,73,36,51,0,48,34,0,95,10,95,6,
		112,1,73,36,52,0,48,35,0,95,10,95,7,112,
		1,73,36,53,0,48,36,0,95,10,95,9,112,1,
		73,36,54,0,48,37,0,95,10,95,8,112,1,73,
		36,56,0,48,38,0,95,10,112,0,28,29,36,57,
		0,48,39,0,95,10,48,40,0,48,41,0,95,10,
		112,0,112,0,122,1,112,1,73,25,28,36,59,0,
		48,39,0,95,10,48,40,0,48,41,0,95,10,112,
		0,112,0,92,2,1,112,1,73,36,62,0,48,42,
		0,95,10,176,43,0,97,0,0,0,64,97,0,0,
		0,16,97,0,0,1,0,12,3,112,1,73,36,64,
		0,48,44,0,95,10,48,45,0,95,10,112,0,112,
		1,73,36,65,0,48,46,0,95,10,176,43,0,122,
		92,2,12,2,112,1,73,36,67,0,176,47,0,48,
		48,0,95,5,112,0,12,1,31,40,36,68,0,48,
		23,0,95,10,112,0,73,36,69,0,48,49,0,95,
		10,120,112,1,73,36,70,0,48,50,0,95,5,95,
		10,112,1,73,25,27,36,72,0,48,51,0,95,5,
		95,10,112,1,73,36,73,0,48,49,0,95,10,9,
		112,1,73,36,76,0,95,10,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_PAINT )
{
	static const BYTE pcode[] =
	{
		13,8,0,36,80,0,102,80,1,36,82,0,176,52,
		0,48,48,0,95,1,112,0,12,1,80,2,36,88,
		0,48,10,0,95,1,112,0,100,8,28,13,36,89,
		0,48,22,0,95,1,112,0,73,36,92,0,176,53,
		0,48,54,0,95,1,112,0,48,10,0,95,1,112,
		0,121,121,20,4,36,94,0,48,38,0,95,1,112,
		0,28,74,36,96,0,176,55,0,48,54,0,95,1,
		112,0,95,2,92,2,1,48,56,0,95,1,112,0,
		48,57,0,95,1,112,0,72,20,3,36,97,0,176,
		58,0,48,54,0,95,1,112,0,95,2,92,4,1,
		48,56,0,95,1,112,0,48,57,0,95,1,112,0,
		72,20,3,25,71,36,101,0,176,55,0,48,54,0,
		95,1,112,0,48,56,0,95,1,112,0,48,57,0,
		95,1,112,0,72,95,2,122,1,20,3,36,102,0,
		176,58,0,48,54,0,95,1,112,0,48,56,0,95,
		1,112,0,48,57,0,95,1,112,0,72,95,2,92,
		3,1,20,3,36,106,0,176,59,0,48,60,0,95,
		1,112,0,12,1,80,4,36,107,0,95,4,121,15,
		29,103,1,36,108,0,48,1,0,176,61,0,12,0,
		106,8,77,97,114,108,101,116,116,0,121,92,238,9,
		9,121,121,121,9,9,9,122,121,121,121,100,121,112,
		17,80,5,36,109,0,176,62,0,48,54,0,95,1,
		112,0,48,63,0,95,5,112,0,12,2,80,6,36,
		110,0,176,64,0,48,54,0,95,1,112,0,122,20,
		2,36,111,0,176,65,0,48,54,0,95,1,112,0,
		97,0,0,255,0,20,2,36,112,0,48,38,0,95,
		1,112,0,28,111,36,113,0,122,165,80,3,25,92,
		36,114,0,48,40,0,48,41,0,95,1,112,0,112,
		0,122,1,176,66,0,48,60,0,95,1,112,0,95,
		3,1,12,1,72,48,67,0,48,41,0,95,1,112,
		0,112,0,65,92,100,18,80,7,36,115,0,92,18,
		80,8,36,116,0,176,68,0,48,54,0,95,1,112,
		0,95,7,92,8,49,95,8,106,2,52,0,20,4,
		36,113,0,175,3,0,95,4,15,28,163,36,117,0,
		25,110,36,119,0,122,165,80,3,25,93,36,120,0,
		92,18,80,7,36,121,0,48,40,0,48,41,0,95,
		1,112,0,112,0,92,2,1,176,69,0,48,60,0,
		95,1,112,0,95,3,1,12,1,72,48,67,0,48,
		41,0,95,1,112,0,112,0,65,92,100,18,80,8,
		36,122,0,176,68,0,48,54,0,95,1,112,0,95,
		7,95,8,92,8,49,106,2,54,0,20,4,36,119,
		0,175,3,0,95,4,15,28,162,36,125,0,176,62,
		0,48,54,0,95,1,112,0,95,6,20,2,36,126,
		0,48,70,0,95,5,112,0,73,36,131,0,121,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_HANDLEEVENT )
{
	static const BYTE pcode[] =
	{
		13,1,3,36,134,0,102,80,4,36,138,0,95,1,
		92,20,8,28,8,36,139,0,122,110,7,36,142,0,
		48,71,0,48,12,0,95,4,112,0,95,1,95,2,
		95,3,112,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_MAKERULE )
{
	static const BYTE pcode[] =
	{
		13,24,0,36,147,0,102,80,1,36,149,0,176,72,
		0,106,8,68,73,83,80,76,65,89,0,121,121,121,
		12,4,80,2,36,152,0,176,52,0,48,48,0,95,
		1,112,0,12,1,80,5,36,154,0,92,255,80,7,
		36,155,0,121,80,8,36,156,0,121,80,9,36,157,
		0,176,73,0,95,2,92,8,12,2,80,10,36,158,
		0,176,73,0,95,2,92,10,12,2,80,11,36,159,
		0,176,73,0,95,2,92,4,12,2,80,12,36,160,
		0,176,73,0,95,2,92,6,12,2,80,13,36,161,
		0,95,10,95,12,18,48,67,0,48,41,0,95,1,
		112,0,112,0,65,92,100,18,80,14,36,162,0,95,
		11,95,13,18,48,67,0,48,41,0,95,1,112,0,
		112,0,65,92,100,18,80,15,36,164,0,95,5,92,
		4,1,95,5,92,2,1,49,80,18,36,165,0,95,
		5,92,3,1,95,5,122,1,49,80,19,36,166,0,
		48,40,0,48,41,0,95,1,112,0,112,0,122,1,
		66,48,67,0,48,41,0,95,1,112,0,112,0,65,
		92,100,18,80,20,36,167,0,48,40,0,48,41,0,
		95,1,112,0,112,0,92,2,1,66,48,67,0,48,
		41,0,95,1,112,0,112,0,65,92,100,18,80,21,
		36,171,0,48,10,0,95,1,112,0,100,69,28,17,
		36,172,0,176,9,0,48,10,0,95,1,112,0,20,
		1,36,175,0,176,74,0,95,2,12,1,80,3,36,
		176,0,48,75,0,95,1,176,76,0,95,2,95,18,
		95,19,12,3,112,1,73,36,177,0,176,62,0,95,
		3,48,10,0,95,1,112,0,12,2,80,4,36,179,
		0,48,38,0,95,1,112,0,28,28,36,180,0,176,
		77,0,95,3,95,5,48,78,0,95,1,112,0,97,
		255,255,255,0,20,4,25,26,36,182,0,176,79,0,
		95,3,95,5,97,255,255,255,0,48,78,0,95,1,
		112,0,20,4,36,184,0,48,56,0,95,1,112,0,
		121,35,28,15,36,185,0,48,80,0,95,1,92,3,
		112,1,73,36,188,0,176,64,0,95,3,122,20,2,
		36,190,0,48,1,0,176,61,0,12,0,106,7,84,
		97,104,111,109,97,0,121,92,246,100,100,100,100,100,
		100,100,100,100,100,100,100,100,100,112,17,80,16,36,
		192,0,48,38,0,95,1,112,0,29,158,1,36,194,
		0,95,20,95,15,18,80,24,36,195,0,92,255,80,
		7,36,196,0,48,81,0,95,1,112,0,48,40,0,
		48,41,0,95,1,112,0,112,0,122,1,49,48,67,
		0,48,41,0,95,1,112,0,112,0,65,92,100,18,
		95,15,18,92,10,50,122,49,80,8,36,197,0,48,
		81,0,95,1,112,0,48,40,0,48,41,0,95,1,
		112,0,112,0,122,1,49,48,67,0,48,41,0,95,
		1,112,0,112,0,65,92,100,18,95,15,18,92,5,
		50,122,49,80,9,36,199,0,95,20,165,80,6,26,
		202,0,36,201,0,174,7,0,36,202,0,174,8,0,
		36,203,0,174,9,0,36,204,0,174,24,0,36,206,
		0,48,67,0,48,41,0,95,1,112,0,112,0,92,
		60,16,31,9,95,8,92,10,16,28,48,36,207,0,
		176,55,0,95,3,121,95,7,95,15,65,20,3,36,
		208,0,176,58,0,95,3,92,10,95,9,92,5,16,
		28,6,92,5,25,3,121,72,95,7,95,15,65,20,
		3,36,211,0,95,9,92,5,16,28,5,121,80,9,
		36,213,0,95,8,92,10,16,28,72,36,214,0,121,
		80,8,36,215,0,176,62,0,95,3,48,63,0,95,
		16,112,0,12,2,80,17,36,216,0,176,68,0,95,
		3,95,7,95,15,65,92,15,176,82,0,176,83,0,
		95,24,92,10,18,121,12,2,12,1,20,4,36,217,
		0,176,62,0,95,3,95,17,20,2,36,199,0,96,
		6,0,95,15,139,95,19,95,20,72,95,15,10,29,
		49,255,36,221,0,176,55,0,95,3,121,121,20,3,
		36,222,0,176,58,0,95,3,121,95,5,92,3,1,
		20,3,36,223,0,176,55,0,95,3,95,5,92,4,
		1,122,49,121,20,3,36,224,0,176,58,0,95,3,
		95,5,92,4,1,122,49,95,5,92,3,1,20,3,
		26,153,1,36,228,0,95,21,95,14,18,80,24,36,
		229,0,92,255,80,7,36,230,0,48,81,0,95,1,
		112,0,48,40,0,48,41,0,95,1,112,0,112,0,
		92,2,1,49,48,67,0,48,41,0,95,1,112,0,
		112,0,65,92,100,18,95,14,18,92,10,50,80,8,
		36,231,0,48,81,0,95,1,112,0,48,40,0,48,
		41,0,95,1,112,0,112,0,92,2,1,49,48,67,
		0,48,41,0,95,1,112,0,112,0,65,92,100,18,
		95,14,18,92,5,50,80,9,36,233,0,95,21,165,
		80,6,26,202,0,36,235,0,174,7,0,36,236,0,
		174,8,0,36,237,0,174,9,0,36,238,0,174,24,
		0,36,240,0,48,67,0,48,41,0,95,1,112,0,
		112,0,92,60,16,31,9,95,8,92,10,16,28,48,
		36,241,0,176,55,0,95,3,95,7,95,14,65,121,
		20,3,36,242,0,176,58,0,95,3,95,7,95,14,
		65,92,10,95,9,92,5,16,28,6,92,5,25,3,
		121,72,20,3,36,245,0,95,9,92,5,16,28,5,
		121,80,9,36,247,0,95,8,92,10,16,28,72,36,
		248,0,121,80,8,36,249,0,176,62,0,95,3,48,
		63,0,95,16,112,0,12,2,80,17,36,250,0,176,
		68,0,95,3,92,15,95,7,95,14,65,176,82,0,
		176,83,0,95,24,92,10,18,121,12,2,12,1,20,
		4,36,251,0,176,62,0,95,3,95,17,20,2,36,
		233,0,96,6,0,95,14,139,95,18,95,21,72,95,
		14,10,29,49,255,36,255,0,176,55,0,95,3,121,
		121,20,3,36,0,1,176,58,0,95,3,95,5,92,
		4,1,121,20,3,36,1,1,176,55,0,95,3,121,
		95,5,92,3,1,122,49,20,3,36,2,1,176,58,
		0,95,3,95,5,92,4,1,95,5,92,3,1,122,
		49,20,3,36,5,1,176,62,0,95,3,95,4,20,
		2,36,6,1,176,84,0,95,2,20,1,36,7,1,
		176,84,0,95,3,20,1,36,10,1,48,70,0,95,
		16,112,0,73,36,12,1,121,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_LBUTTONDOWN )
{
	static const BYTE pcode[] =
	{
		13,4,2,36,15,1,102,80,3,36,19,1,176,59,
		0,48,60,0,95,3,112,0,12,1,80,6,36,24,
		1,122,165,80,5,25,100,36,25,1,176,85,0,95,
		1,95,2,48,86,0,95,3,95,5,112,1,12,3,
		28,71,36,26,1,176,87,0,48,60,0,95,3,112,
		0,95,5,20,2,36,27,1,176,88,0,48,60,0,
		95,3,112,0,95,6,122,49,20,2,36,28,1,48,
		89,0,95,3,112,0,73,36,29,1,48,89,0,48,
		41,0,95,3,112,0,112,0,73,36,30,1,121,110,
		7,36,24,1,175,5,0,95,6,15,28,155,36,35,
		1,48,38,0,95,3,112,0,28,49,36,36,1,176,
		90,0,95,1,48,91,0,48,41,0,95,3,112,0,
		112,0,65,12,1,176,90,0,48,40,0,48,41,0,
		95,3,112,0,112,0,122,1,12,1,49,80,4,25,
		48,36,38,1,176,92,0,95,2,48,91,0,48,41,
		0,95,3,112,0,112,0,65,12,1,176,92,0,48,
		40,0,48,41,0,95,3,112,0,112,0,92,2,1,
		12,1,49,80,4,36,42,1,176,93,0,48,60,0,
		95,3,112,0,95,4,20,2,36,44,1,48,89,0,
		95,3,112,0,73,36,45,1,48,89,0,48,41,0,
		95,3,112,0,112,0,73,36,47,1,121,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_MOUSEMOVE )
{
	static const BYTE pcode[] =
	{
		13,4,2,36,50,1,102,80,3,36,53,1,176,59,
		0,48,60,0,95,3,112,0,12,1,80,5,36,54,
		1,121,80,6,36,56,1,122,165,80,4,25,43,36,
		57,1,176,85,0,95,1,95,2,48,86,0,95,3,
		95,4,112,1,12,3,28,14,36,58,1,95,4,80,
		6,36,59,1,25,13,36,56,1,175,4,0,95,5,
		15,28,212,36,63,1,95,6,121,8,28,12,36,64,
		1,176,94,0,20,0,25,10,36,66,1,176,95,0,
		20,0,36,69,1,121,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TC5RULE_GETCOORDS )
{
	static const BYTE pcode[] =
	{
		13,4,1,36,72,1,102,80,2,36,77,1,95,1,
		176,59,0,48,60,0,95,2,112,0,12,1,15,28,
		14,36,78,1,121,121,121,121,4,4,0,110,7,36,
		81,1,48,38,0,95,2,112,0,28,62,36,82,1,
		48,40,0,48,41,0,95,2,112,0,112,0,122,1,
		176,66,0,48,60,0,95,2,112,0,95,1,1,12,
		1,72,48,67,0,48,41,0,95,2,112,0,112,0,
		65,92,100,18,80,4,36,83,1,92,18,80,5,25,
		61,36,85,1,92,18,80,4,36,86,1,48,40,0,
		48,41,0,95,2,112,0,112,0,92,2,1,176,69,
		0,48,60,0,95,2,112,0,95,1,1,12,1,72,
		48,67,0,48,41,0,95,2,112,0,112,0,65,92,
		100,18,80,5,36,89,1,95,4,95,5,95,4,92,
		10,72,95,5,92,10,72,4,4,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const BYTE pcode[] =
	{
		117,98,0,2,0,7
	};

	hb_vmExecute( pcode, symbols );
}

