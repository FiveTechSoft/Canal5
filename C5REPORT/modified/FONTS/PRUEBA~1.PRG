#include "fivewin.ch"
#include "c5report.ch"



static oWnd
static aReports    := {}
static nLastActive := 1

function main( nTop, nLeft, nWidth, nHeight, lDisenio )

local oBar
local oItem
local oPanel
local oBrush
DEFINE BRUSH oBrush STYLE "NULL"

if lDisenio == nil; lDisenio := .t.; endif
if nTop     == nil; nTop     := 40; endif
if nLeft    == nil; nLeft    := 40; endif
if nWidth   == nil; nWidth   := 400; endif
if nHeight  == nil; nHeight  := 400; endif


    if lDisenio

       DEFINE WINDOW oWnd TITLE "Reports" COLOR 0, GetSysColor(15) VSCROLL HSCROLL


       oBar := TC5StBar():New( 0,0, 35, 35, oWnd, rgb(227,239,255), RGB(171,207,255), .f. )

        oBar:lRightToLeft := .f.
        oWnd:oTop := oBar
        oBar:lBorder := .f.


        oBar:AddItem(          "", "smallbmp\nuevo.bmp",   {||oReport():Nuevo()                            }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\abrir.bmp",    {||oReport():Abrir()                            }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\save.bmp",     {||oReport():Save()                             }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\saveas.bmp",   {||oReport():Save(,.t.)                         }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\cut.bmp" ,     {||oReport():Cut()                              }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\copy.bmp",     {||oReport():Copy()                             }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\paste.bmp",    {||oReport():Paste()                            }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\colors.bmp" ,      {||oReport():Color()                            }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\font.bmp"   ,      {||oReport():Font()                             }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\toback.bmp" ,      {||oReport():toback()                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\tofront.bmp",      {||oReport():tofront()                          }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\text.bmp"  ,       {||AddItem(  1, oReport() )                     }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\bitmap.bmp",       {||AddItem(  2, oReport() )                     }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\vline.bmp" ,       {||AddItem(  3, oReport() )                     }, {||.t.}, .f., )
        //oBar:AddItem(          "", "btns\hline.bmp" ,       {||AddItem(  4, oReport() )                     }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\rect.bmp"  ,       {||AddItem(  9, oReport() ):lTransparent := .t. }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\rorect.bmp"  ,     {||AddItem( 10, oReport() ):lTransparent := .t. }, {||.t.}, .f., )
        oBar:AddItem(          "", "btns\ellipse.bmp"  ,    {||AddItem( 13, oReport() )                     }, {||.t.}, .f., )

        oBar:AddItem(          "", "btns\database.bmp"  ,   {||AddItem( 20, oReport() )                     }, {||.t.}, .f., )

        //oBar:AddItem(          "", "btns\browse.bmp"  ,   {||AddItem( 21, oReport() )                     }, {||.t.}, .f., )


        oBar:AddItem(          "", "smallbmp\top.bmp"  ,    {||oReport():Align(1)                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\left.bmp" ,    {||oReport():Align(2)                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\down.bmp" ,    {||oReport():Align(3)                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\right.bmp",    {||oReport():Align(4)                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\alcenter.bmp", {||oReport():Align(5)                           }, {||.t.}, .f., )
        oBar:AddItem(          "", "smallbmp\almides.bmp",  {||oReport():Align(6)                           }, {||.t.}, .f., )



//              DEFINE BUTTON OF oBar ACTION oReport():Nuevo()                              FILE "smallbmp\Nuevo.bmp"         NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Abrir()                              FILE "smallbmp\abrir.bmp"         NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Save()                               FILE "smallbmp\save.bmp"          NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Cut()                                FILE "smallbmp\cut.bmp"           NOBORDER  GROUP
//              DEFINE BUTTON OF oBar ACTION oReport():Copy()                               FILE "smallbmp\copy.bmp"          NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Paste()                              FILE "smallbmp\paste.bmp"         NOBORDER  GROUP
//              DEFINE BUTTON OF oBar ACTION oReport():Color()                              FILE "btns\colors.bmp"         NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Font()                               FILE "btns\font.bmp"          NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():toback()                             FILE "btns\toback.bmp"        NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():tofront()                            FILE "btns\tofront.bmp"       NOBORDER
//              DEFINE BUTTON OF oBar ACTION AddItem(  1, oReport() )                       FILE "btns\text.bmp"   GROUP
//              DEFINE BUTTON OF oBar ACTION AddItem(  1, oReport() ):lVertical  := .t.     FILE "btns\vtext.bmp"
//              DEFINE BUTTON OF oBar ACTION AddItem(  2, oReport() ):lInvertido := .t.     FILE "btns\itext.bmp"
//              DEFINE BUTTON OF oBar ACTION AddItem(  2, oReport() )                       FILE "btns\bitmap.bmp"
//              DEFINE BUTTON OF oBar ACTION AddItem(  3, oReport() )                       FILE "btns\vline.bmp"
//              DEFINE BUTTON OF oBar ACTION AddItem(  4, oReport() )                       FILE "btns\hline.bmp"
//              DEFINE BUTTON OF oBar ACTION AddItem(  9, oReport() ):lTransparent := .t.   FILE "btns\rect.bmp"
//              DEFINE BUTTON OF oBar ACTION oReport():Align(1)                             FILE "smallbmp\top.bmp"          NOBORDER  GROUP
//              DEFINE BUTTON OF oBar ACTION oReport():Align(2)                             FILE "smallbmp\left.bmp"         NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Align(3)                             FILE "smallbmp\down.bmp"         NOBORDER
//              DEFINE BUTTON OF oBar ACTION oReport():Align(4)                             FILE "smallbmp\right.bmp"        NOBORDER
//
//              DEFINE BUTTON OF oBar ACTION (oReport():lDisenio := !oReport():lDisenio,oReport():Refresh())   GROUP

              DEFINE SCROLLBAR oWnd:oVScroll OF oWnd PAGESTEP 10 RANGE 0, 0 VERTICAL    ;
                     ON UP    OnUp() ;
                     ON DOWN  OnDown()

              DEFINE SCROLLBAR oWnd:oHScroll OF oWnd PAGESTEP 10 RANGE 0, 0 HORIZONTAL ;
                     ON UP    OnLeft() ;
                     ON DOWN  OnRight()


    endif
    oPanel  := TPanel():New( 0, 0, 100, 100, oWnd )
    oPanel:SetBrush( oBrush )
    oWnd:oClient := oPanel


    aadd( aReports,  TC5Report():New( 0,  0, 555, 784, oPanel,0,rgb(173,197,229), { 20, 0, 804, 555 } ) )
    //aadd( aReports,  TC5Report():New( 40, 660, 600, 600, oWnd,0,GetSysColor(15), { 40, 40, 910, 610 } ) )

    aReports[1]:bLostFocus := {|| nLastActive := 1 }
    //aReports[2]:bLostFocus := {|| nLastActive := 2 }

    aReports[1]:oHRule := TC5Rule():New(  0,  0, 1600,  25, oPanel,,, .f., aReports[1] )
    aReports[1]:oHRule:nOffset := 26
    aReports[1]:oVRule := TC5Rule():New( 26,  0,  25, 1600, oPanel,,, .t., aReports[1] )

    oPanel:bResized := {|| aReports[1]:oHRule:nWidth := oPanel:nWidth,;
                           aReports[1]:oVRule:nHeight := oPanel:nHeight,;
                           aReports[1]:Move( 26,26, oPanel:nWidth-26, oPanel:nHeight-26,.t.) }

    //oPanel:bResized := {|| aReports[1]:Move( 26,26, oPanel:nWidth-26, oPanel:nHeight-26,.t.) }


    if lDisenio
       ACTIVATE WINDOW oWnd MAXIMIZED
    endif

return 0

function oWnd() ; return oWnd


function AddItem( nType, oReport )
                                                                                                           //"bmps\image11_2.bmp"
local oItem
local nTop    := 10
local nLeft   := 10
local nWidth  := 69
local nHeight := 35

do case
   case nType == C5TEXTO

        nWidth = 100
        nHeight = 15
        oItem := TC5RptItemText():New( oReport, nTop, nLeft, nWidth, nHeight, "Text")

   case nType == C5BITMAP

        oItem := TC5RptItemImg():New( oReport, nTop, nLeft, nWidth, nHeight)

   case nType == C5LINE

        oItem := TC5RptItemLine():New( oReport, nTop, nLeft, nWidth, nHeight, .t.,.f., .t.)

//   case nType == C5GRID
//
//        nWidth = 400
//        nHeight = 200
endcase

if oItem == nil
   oItem := TC5RptItem():New( oReport, 10,    -100, nWidth, nHeight, "Texto", "bmps\image11.bmp" ,  ,,        ,       , nType )
endif

oReport():AddItem( oItem )
oReport():Refresh()

return oItem

function OnUp()
local nInc    := 10 * oReport():nZoom / 100
local nRow    := oReport():nTop
nRow += nInc
SetWindowPos( oReport():hWnd, 0, nRow, oReport():nLeft, 0, 0, 1 )

return 0

function OnDown()

local nInc    := 10 * oReport():nZoom / 100
local nRow    := oReport():nTop
nRow -= nInc
SetWindowPos( oReport():hWnd, 0, nRow, oReport():nLeft, 0, 0, 1 )

return 0

function OnLeft()
local nInc := 10 * oReport():nZoom / 100
local nCol    := oReport():nLeft
nCol += nInc
SetWindowPos( oReport():hWnd, 0, oReport():nTop, nCol, 0, 0, 1 )

return 0

function OnRight()
local nInc := 10 * oReport():nZoom / 100
local nCol    := oReport():nLeft
nCol -= nInc
SetWindowPos( oReport():hWnd, 0, oReport():nTop, nCol, 0, 0, 1 )

return 0

function oReport()


return aReports[nLastActive]









////////////////////////////////////////////////////////////////////
 static function LoadImageEx( cImage )
////////////////////////////////////////////////////////////////////

 local hBmp := 0

 hBmp := LoadBitmap( GetResources(), cImage )
 if hBmp == 0
    hBmp := ReadBitmap( 0, cImage )
 endif

return hBmp

///////////////////////////////////////////////////////////////////////////////////////////
  function aSplit( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

local nItems := strcount( cString, cChar )
local aItems := {}
local n
local uItem

if nItems == 0
   return  aItems
endif

for n := 1 to nItems + 1
    aadd( aItems, alltrim(strtoken( cString, n, cchar )) )
next

return aItems

///////////////////////////////////////////////////////////////////////////////////////////
  function strcount( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

return int(( len( cString ) - len( strtran( cString, cChar, "" ) ))/len(cChar))

function astr( n ); return alltrim(str(n))


///////////////////////////////////////////////////////////////////////////////////////////
function PtInRecta( y, x, aRecta )
///////////////////////////////////////////////////////////////////////////////////////////
local x0, y0, x1, y1

y0 := int(aRecta[1])
x0 := int(aRecta[2])
y1 := int(aRecta[3])
x1 := int(aRecta[4])

return (x-x0)/(x1-x0) == (y-y0)/(y1-y0)

*********************************************************************************************
  function NormalizeRect( rc )
*********************************************************************************************
local aRect := {rc[1],rc[2],rc[3],rc[4]}

if rc[3] < rc[1]
   aRect[1] := rc[3]
   aRect[3] := rc[1]
endif

if rc[4] < rc[2]
   aRect[2] := rc[4]
   aRect[4] := rc[2]
endif

return aRect





**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

#define ES_CENTER                   1
CLASS TGetEx FROM TGet

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel,;
               cMsg, lUpdate, bWhen, lCenter, lRight, bChanged,;
               lReadOnly, lPassword, lNoBorder, nHelpId,;
               lSpinner, bUp, bDown, bMin, bMax ) CONSTRUCTOR

ENDCLASS

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax ) CLASS TGetEx

#ifdef __XPP__
   #undef New
#endif

   local cText := Space( 50 )

   DEFAULT nClrFore  := 0,;
           nClrBack  := CLR_WHITE,;
           oWnd      := GetWndDefault(),;
           nHeight   := If( oFont != nil, oFont:nHeight, 12 ),;
           lDesign   := .f., lPixel := .f., lUpdate := .f.,;
           lCenter   := .f., lRight := .f.,;
           lReadOnly := .f., lPassword := .f.,;
           lSpinner  := .f.,;
           nRow      := 0, nCol := 0, lNoBorder := .f.,;
           bSetGet   := bSETGET( cText )

   ::cCaption = If( cPict == nil, cValToChar( Eval( bSetGet ) ), ;
                    Transform( Eval( bSetGet ), cPict ) )

   if lSpinner
     nHeight := Max( 15, nHeight )
   endif

   ::nTop     = nRow * If( lPixel, 1, 13 )       //13
   ::nLeft    = nCol * If( lPixel, 1, 8 )        // 8
   ::nBottom  = ::nTop + nHeight - 1
   ::nRight   = ::nLeft + If( nWidth == nil, ( 1 + Len( ::cCaption ) ) * 3.5, ;
                                               nWidth - 1 ) + ;
                If( lSpinner, 20, 0 )
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      ES_AUTOHSCROLL, ;
                      If( ! lReadOnly, WS_TABSTOP, 0 ),;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      If( lSpinner, WS_VSCROLL, 0 ),;
                      If( lReadOnly, ES_READONLY, 0 ),;
                      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
//                      If( lCenter .OR. lRight, ES_MULTILINE, 0 ),; Only needed for Win31

   ::nStyle    = If( lNoBorder, nAnd( ::nStyle, nNot( WS_BORDER ) ), ::nStyle )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lPassword = lPassword
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      = 1  // 0   14/Aug/98
   ::lReadOnly = lReadOnly
   ::lFocused  = .f.
   ::nHelpId   = nHelpId
   ::cPicture  = cPict

   ::SetColor( nClrFore, nClrBack )
   ::nClrDef := nClrBack

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer
   ::oGet:KillFocus()

   if ! Empty( oWnd:hWnd )
      ::Create( "EDIT" )
      if oFont != nil
         ::SetFont( oFont )
      endif
      ::GetFont()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

   if lSpinner
      ::Spinner( bUp, bDown, bMin, bMax )
   endif

return Self


function MiIntersectRect( o1, oRep )
local rc  := GetClientRect( o1:hWnd )
local rcRep := {oRep:nTop, oRep:nLeft, oRep:nTop + oRep:nHeight, oRep:nLeft+oRep:nWidth}
local rc0 := {0, 0, oRep:nHeight, oRep:nWidth}

if rcRep[1] < 0
   rc0[1] := abs(rcRep[1])
endif

if rcRep[2] < 0
   rc0[2] := abs(rcRep[2])
endif

if rcRep[3] > rc[3]
   rc0[3] := abs(rcRep[1])+rc[3]
endif

if rcRep[4] > rc[4]
   rc0[4] := abs(rcRep[2])+rc[4]
endif

return rc0





















#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "math.h"


HB_FUNC( PTINRECT )
{
   POINT pt;
   RECT  rct;

   pt.y = hb_parnl( 1 );
   pt.x = hb_parnl( 2 );

   rct.top    = hb_parni( 3, 1 );
   rct.left   = hb_parni( 3, 2 );
   rct.bottom = hb_parni( 3, 3 );
   rct.right  = hb_parni( 3, 4 );

   hb_retl( PtInRect( &rct, pt ) );
}

HB_FUNC( CREATECOMPATIBLEBITMAP )
{
         hb_retnl( (LONG) CreateCompatibleBitmap( ( HDC ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ));
}


HB_FUNC( CREATECOMPATIBLEDC )
{
         hb_retnl( (LONG) CreateCompatibleDC( ( HDC ) hb_parnl( 1 )));

}

void FillSolidRect(HDC hDC, LPCRECT lpRect, COLORREF clr)
{
   SetBkColor(hDC, clr);
   ExtTextOut(hDC, 0, 0, ETO_OPAQUE, lpRect, NULL, 0, NULL);
}

HB_FUNC( FILLSOLIDRECT )
{
    RECT rct;
    COLORREF nColor;
    HPEN hPen, hOldPen;
    HDC hDC = ( HDC ) hb_parnl( 1 );
    rct.top    = hb_parni( 2, 1 );
    rct.left   = hb_parni( 2, 2 );
    rct.bottom = hb_parni( 2, 3 );
    rct.right  = hb_parni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right, rct.top );
       LineTo( hDC, rct.right, rct.bottom );
       LineTo( hDC, rct.left, rct.bottom );
       LineTo( hDC, rct.left, rct.top );
       SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }
}

HB_FUNC( BMPWIDTH )
{
    BITMAP bm;

    if( hb_parnl( 1 ) )
    {
       GetObject( ( HGDIOBJ ) hb_parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );
       hb_retnl( bm.bmWidth );
    }
    else
    {
       hb_retnl(0);
    }
}
HB_FUNC(  BMPHEIGHT )
{
    BITMAP bm;
    if( hb_parnl( 1 ) )
    {
       GetObject( ( HGDIOBJ ) hb_parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );
       hb_retnl( bm.bmHeight );
    }
    else
    {
       hb_retnl(0);
    }
}

HB_FUNC( CURSORNW )
{
   hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZENWSE ) ) );
}

HB_FUNC( CURSORNE )
{
   hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZENESW ) ) );
}

HB_FUNC( INTERSECTRECT )
{

   RECT rc;
   RECT rc1;
   RECT rc2;

  rc.top    = 0;
  rc.left   = 0;
  rc.bottom = 0;
  rc.right  = 0;

  rc1.top    = hb_parni(1,1);
  rc1.left   = hb_parni(1,2);
  rc1.bottom = hb_parni(1,3);
  rc1.right  = hb_parni(1,4);

  rc2.top    = hb_parni(2,1);
  rc2.left   = hb_parni(2,2);
  rc2.bottom = hb_parni(2,3);
  rc2.right  = hb_parni(2,4);

  IntersectRect( &rc, &rc1, &rc2 );

  hb_reta(4);

  hb_storni(rc.top, -1, 1 );
  hb_storni(rc.left, -1, 2 );
  hb_storni(rc.bottom, -1, 3 );
  hb_storni(rc.right, -1, 4 );

}

HB_FUNC( LINTERSECTRECT )
{

   RECT rc;
   RECT rc1;
   RECT rc2;

  rc.top    = 0;
  rc.left   = 0;
  rc.bottom = 0;
  rc.right  = 0;

  rc1.top    = hb_parni(1,1);
  rc1.left   = hb_parni(1,2);
  rc1.bottom = hb_parni(1,3);
  rc1.right  = hb_parni(1,4);

  rc2.top    = hb_parni(2,1);
  rc2.left   = hb_parni(2,2);
  rc2.bottom = hb_parni(2,3);
  rc2.right  = hb_parni(2,4);

  hb_retl( IntersectRect( &rc, &rc1, &rc2 ));
}

HB_FUNC( ROUNDRECT )
{
   hb_retl( RoundRect( ( HDC ) hb_parni( 1 ),            // HDC
                               hb_parni( 3 ),            // nLeft
                               hb_parni( 2 ),            // nTop
                               hb_parni( 5 ),            // nRight
                               hb_parni( 4 ),            // nBottom
                               hb_parni( 6 ),            // nWidthEllipse
                               hb_parni( 7 ) ) );        // nHeightEllipse
}




HB_FUNC( CURSORSIZE  )
{
      hb_retnl( ( LONG ) SetCursor( LoadCursor( 0, IDC_SIZEALL ) ) );

}

HB_FUNC( SETSCROLLBARINFO )
{
  SCROLLINFO ScrollInfo;
  ScrollInfo.cbSize = sizeof(ScrollInfo);     // size of this structure
  ScrollInfo.fMask = SIF_ALL;                 // parameters to set
  ScrollInfo.nMin = 0;                        // minimum scrolling position
  ScrollInfo.nMax = 100;                      // maximum scrolling position
  ScrollInfo.nPage = 40;                      // the page size of the scroll box
  ScrollInfo.nPos = 50;                       // initial position of the scroll box
  ScrollInfo.nTrackPos = 0;                   // immediate position of a scroll box that the user is dragging
  hb_retni( SetScrollInfo(( HWND ) hb_parnl( 1 ),
                          hb_parni( 2   ),
                          &ScrollInfo,
                          TRUE ));
}

HB_FUNC( GETRGNBOX )
{
   RECT rc;
   rc.top = 0;
   rc.left = 0;
   rc.bottom = 0;
   rc.right = 0;
   GetRgnBox( ( HRGN ) hb_parnl( 1 ), &rc );
   hb_reta( 4 );
   hb_storni( rc.top,    -1, 1 );
   hb_storni( rc.left,   -1, 2 );
   hb_storni( rc.bottom, -1, 3 );
   hb_storni( rc.right,  -1, 4 );
}

HB_FUNC( COMBINERGN )
{
    hb_retni( CombineRgn( (HRGN) hb_parnl(1), (HRGN) hb_parnl(2), (HRGN) hb_parnl(3), hb_parni(4) ) ) ;

}

HB_FUNC( CREATERECTRGN )
{
   hb_retnl( (LONG) CreateRectRgn( hb_parni( 1 ),
                                   hb_parni( 2 ),
                                   hb_parni( 3 ),
                                   hb_parni( 4 )
                                   ) ) ;
}

#pragma ENDDUMP



