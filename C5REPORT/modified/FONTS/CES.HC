#include "windows.h"
#include "hbapi.h"
#include "math.h"

HB_FUNC( BEGIN_ROTATE )
{
   HDC hDc = (HDC) hb_parnl( 1 );
   int nGraphicsMode = SetGraphicsMode(hDc, GM_ADVANCED);
   XFORM xform;
   double fangle;
   int m_iAngle = hb_parni( 2 );

   POINT centerPt;
   centerPt.y = hb_parni( 3 );
   centerPt.x = hb_parni( 4 );


   if ( m_iAngle != 0 )
   {
       fangle = (double)m_iAngle / 180 * 3.1415926;
       xform.eM11 = (float)cos(fangle);
       xform.eM12 = (float)sin(fangle);
       xform.eM21 = (float)-sin(fangle);
       xform.eM22 = (float)cos(fangle);
       xform.eDx = (float)(centerPt.x - cos(fangle)*centerPt.x + sin(fangle)*centerPt.y);
       xform.eDy = (float)(centerPt.y - cos(fangle)*centerPt.y - sin(fangle)*centerPt.x);

       SetWorldTransform(hDc, &xform);
   }
   hb_retni( nGraphicsMode );

}



HB_FUNC( END_ROTATE )
{
    HDC hDc = (HDC) hb_parnl( 1 );
    XFORM xform;
    int nGraphicsMode = hb_parni( 2 );

    xform.eM11 = (float)1.0;
    xform.eM12 = (float)0;
    xform.eM21 = (float)0;
    xform.eM22 = (float)1.0;
    xform.eDx = (float)0;
    xform.eDy = (float)0;

    SetWorldTransform(hDc, &xform);
    SetGraphicsMode(hDc, nGraphicsMode);
    hb_ret();
}

HB_FUNC( PTINREGION )
{
   hb_retl( PtInRegion( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
}

HB_FUNC( BEGINPATH )
{
   hb_retl( BeginPath( ( HDC ) hb_parnl( 1 ) ));
}

HB_FUNC( ENDPATH )
{
   hb_retl( EndPath( ( HDC ) hb_parnl( 1 ) ));
}

HB_FUNC( PATHTOREGION )
{
   hb_retnl( (long) PathToRegion( ( HDC ) hb_parnl( 1 ) ));
}

HB_FUNC( STROKEPATH )
{
   hb_retl( StrokePath( ( HDC ) hb_parnl( 1 )));
}

HB_FUNC( PAINTRGN )
{
   hb_retl( PaintRgn( ( HDC ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 )));
}

HB_FUNC( WIDENPATH )
{
   hb_retl( WidenPath( ( HDC ) hb_parnl( 1 )));
}
HB_FUNC( FILLRGN )
{
   hb_retl( FillRgn( ( HDC ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), ( HBRUSH ) hb_parnl( 3 )));
}
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

HB_FUNC( SETMENUDEFAULTITEM )
{
    hb_retl( SetMenuDefaultItem( (HMENU) hb_parnl( 1 ), hb_parni( 2 ), 1));
}

HB_FUNC( C5CREATEENHMETAFILE ) // ()   cFileName --> hDC

{
   RECT rect ;
   LONG iWidthMM, iHeightMM ;
   HDC  hdcRet;


   rect.left   = hb_parni( 4, 2 );
   rect.top    = hb_parni( 4, 1 ) ;
   rect.right  = hb_parni( 4, 4 ) ;
   rect.bottom = hb_parni( 4, 3 ) ;

   hdcRet = ( HDC ) CreateEnhMetaFile( (HDC)hb_parnl(1), (LPSTR)hb_parc( 2 ), &rect, (LPSTR)hb_parc(3) );

   if( !hdcRet )
   {
      char sBuffer[ 200 ];

   	  wsprintf( sBuffer, "Error (%d) creating enhanced metafile", GetLastError() );
      MessageBox( NULL, sBuffer, ( LPSTR ) hb_parc( 2 ), MB_OK && MB_ICONEXCLAMATION );

   }
   else
      hb_retnl( ( LONG ) hdcRet );
}


HB_FUNC( DRAWRULE )
{

   HWND hWnd = (HWND) hb_parnl( 1 );
   int iZoom = hb_parni( 2 );
   HDC hDC = CreateDC("DISPLAY",NULL,NULL,NULL);
   HDC hDC2 = GetDC( hWnd );
   HDC hDCMem;
   HFONT hFont = GetStockObject( DEFAULT_GUI_FONT );
   HFONT hSmallFont;
   HFONT hOldFont;
   RECT rc;
   HBITMAP hBmpMem, hOldBmp;
   int n;
   int hres     = GetDeviceCaps(hDC,HORZRES);                  // {display width in pixels}
   int vres     = GetDeviceCaps(hDC,VERTRES);                  // {display height in pixels}
   int hsiz     = GetDeviceCaps(hDC,HORZSIZE);                 // {display width in mm}
   int vsiz     = GetDeviceCaps(hDC,VERTSIZE);                 // {display height in mm}
   float HPixByMM = (hres/hsiz )*(iZoom / 100 ); // pixels hay en un mm horizontal
   float VPixByMM = (vres/vsiz )*(iZoom / 100 ); // pixels hay en un mm vertical
   int nMMs;
   int nPos = 0;
   int nInc = 1;
   char buffer[ 5 ];
   LOGFONT lf = { 0 };

   BOOL lVertical;

   GetObject(hFont, sizeof(LOGFONT), &lf);
   {
      lf.lfHeight = 10;
      hSmallFont =  CreateFontIndirect(&lf);
   }

   GetClientRect( hWnd, &rc );
   lVertical = (rc.bottom-rc.top > rc.right-rc.left);

   hDCMem = CreateCompatibleDC( hDC );
   hBmpMem = CreateCompatibleBitmap( hDC, rc.right-rc.left, rc.bottom-rc.top );
   hOldBmp = (HBITMAP) SelectObject( hDCMem, hBmpMem );

   FillSolidRect( hDCMem, &rc, hb_parni( 3 ));

   SetBkMode( hDCMem, 1 );

   if( iZoom < 70 )
     nInc = 2;

   if( iZoom <= 30 )
     nInc = 10;


   if( lVertical )
   {
      //nMMs = (float)(( rc.bottom-rc.top ) / VPixByMM ) *  (float)(iZoom / 100);
      nMMs = (float)(( rc.bottom-rc.top ) / VPixByMM );

      for( n = 1; n <= nMMs; n += nInc )
      {
          nPos = (float)(n * VPixByMM);
          MoveToEx( hDCMem,                      0, nPos, NULL);
          LineTo  ( hDCMem, 10 + (n %5 == 0 ? 5:0), nPos );

          if( n%10 == 0 )
          {
             wsprintf( buffer, "%3i", n/10 );
             hOldFont = (HFONT)SelectObject( hDCMem, hSmallFont );
             TextOut( hDCMem, 15, nPos-5, buffer, 3);
             SelectObject( hDCMem, hOldFont );
          }
      }
      //MoveToEx( hDCMem,                 0,               0, NULL );
      //LineTo  ( hDCMem,                 0,rc.bottom-rc.top );
      //MoveToEx( hDCMem,rc.right-rc.left-1,               0, NULL );
      //LineTo  ( hDCMem,rc.right-rc.left-1,rc.bottom-rc.top );
   }
   else
   {
      nMMs = (float)(( rc.right-rc.left ) / HPixByMM );

      for( n = 1; n <= nMMs; n+= nInc )
      {
          nPos = n * HPixByMM;
          MoveToEx( hDCMem, nPos,                  0, NULL );
          LineTo  ( hDCMem, nPos, 10+( n%5 == 0? 5:0) );

          if( n%10 == 0 )
          {
             wsprintf( buffer, "%3i", n/10 );
             hOldFont = (HFONT)SelectObject( hDCMem, hSmallFont );
             TextOut( hDCMem, nPos-5, 17, buffer, 3);
             SelectObject( hDCMem, hOldFont );
          }

      }
      //MoveToEx( hDCMem,               0,                 0, NULL );
      //LineTo  ( hDCMem,rc.right-rc.left,                 0 );
      //MoveToEx( hDCMem,               0,rc.bottom-rc.top-1, NULL );
      //LineTo  ( hDCMem,rc.right-rc.left,rc.bottom-rc.top-1 );
   }
   //SelectObject( hDCMem, hOldBmp )
   BitBlt( hDC2, 0, 0, rc.right-rc.left, rc.bottom-rc.top, hDCMem, 0, 0, SRCCOPY );
   SelectObject( hDCMem, hOldBmp );
   DeleteDC( hDC );
   ReleaseDC( hWnd, hDC2 );
   DeleteDC( hDCMem );
   DeleteObject( hSmallFont );

   hb_retnl( (long) hBmpMem );
}

HB_FUNC( ARCTO )
{
   hb_retl( ArcTo( (HDC) hb_parnl( 1 ), hb_parni( 3 ),hb_parni( 2 ),hb_parni( 4 ),hb_parni( 3 ),
                          hb_parni( 6 ),hb_parni( 5 ),hb_parni( 8 ),hb_parni( 7 )));
}


HB_FUNC( CLOSEFIGURE )
{
   hb_retl( CloseFigure( (HDC) hb_parnl( 1 )));
}




HB_FUNC( MIDROUNDRECT )
{
   HDC hDC = (HDC) hb_parnl( 1 );
   int X = hb_parni( 2, 2 );
   int Y = hb_parni( 2, 1 );
   int width = hb_parni( 2, 4 ) - X;
   int height = hb_parni( 2, 3 ) - Y;
   int radius = hb_parni( 3 );

   BeginPath( hDC );
//   SetArcDirection( hDC, AD_CLOCKWISE );
   MoveToEx( hDC, X + radius, Y, NULL);
   ArcTo     (hDC, X, Y, X + radius*2, Y + radius*2,
              X + radius, Y,
              X, Y + radius);
   LineTo(hDC, X , Y + height );
   LineTo  (hDC, X + width, Y + height);
   LineTo  (hDC, X + width, Y + radius);
   ArcTo     (hDC, X + width - radius*2, Y, X + width, Y + radius*2,
                 X + width , Y + radius,
                 X + width-radius, Y );
   LineTo  (hDC, X + radius, Y);
   //CloseFigure( hDC );

   EndPath( hDC );
   StrokeAndFillPath( hDC );
}


//GraphicsPath gp=new GraphicsPath();
//
//    gp.AddLine(X + radius, Y, X + width - (radius*2), Y);
//
//    gp.AddArc(X + width - (radius*2), Y, radius*2, radius*2, 270, 90);
//
//    gp.AddLine(X + width, Y + radius, X + width, Y + height - (radius*2));
//
//    gp.AddArc(X + width - (radius*2), Y + height - (radius*2), radius*2, radius*2,0,90);
//
//    gp.AddLine(X + width - (radius*2), Y + height, X + radius, Y + height);
//
//    gp.AddArc(X, Y + height - (radius*2), radius*2, radius*2, 90, 90);
//
//    gp.AddLine(X, Y + height - (radius*2), X, Y + radius);
//
//    gp.AddArc(X, Y, radius*2, radius*2, 180, 90);
//
//    gp.CloseFigure();
//
//    g.DrawPath(p, gp);
//

HB_FUNC( EXTCREATEPEN )
{
   LOGBRUSH logbrush;
   HPEN hpen;
   logbrush.lbStyle = BS_SOLID;
   logbrush.lbColor = (COLORREF) hb_parni( 2 );
   logbrush.lbHatch = 0;
   hpen = ExtCreatePen(PS_GEOMETRIC|PS_ENDCAP_FLAT|PS_JOIN_MITER|PS_SOLID,hb_parni( 1 ),&logbrush,0,NULL);
   hb_retnl( (long) hpen );
}
