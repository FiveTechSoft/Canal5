#pragma BEGINDUMP

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
/*
HB_FUNC( EXTCREATEPEN )
{
   LOGBRUSH lb;
   lb.lbStyle = hb_parnl( 1 );
   lb.lbColor = (COLORREF) hb_parnl( 3 );
   lb.lbHatch = hb_parnl( 5 );

   hb_retnl( (LONG) ExtCreatePen( (DWORD) hb_parnl( 1 ),
                                  (DWORD) hb_parnl( 2 ),
                                  &lb                  ,
                                  (DWORD) hb_parnl( 4 ),
                                  NULL ) ) ;
}
*/

HB_FUNC( CREATECOMPATIBLEDC )
{
	 hb_retnl( (LONG) CreateCompatibleDC( ( HDC ) hb_parnl( 1 )));

}

HB_FUNC( CREATECOMPATIBLEBITMAP )
{
     hb_retnl( (LONG) CreateCompatibleBitmap( (HDC) hb_parnl(1), hb_parni(2), hb_parni(3)));
}


HB_FUNC( CREATEHATCHBRUSH )
{
   hb_retnl( (LONG) CreateHatchBrush( hb_parni( 1 ), hb_parnl( 2 ) ) );
}

HB_FUNC( CREATERECTRGN )
{
    hb_retnl( (LONG) CreateRectRgn( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

HB_FUNC( CREATERECTRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parni( 1, 1 );
    rc.left = hb_parni( 1, 2 );
    rc.bottom = hb_parni( 1, 3 );
    rc.right = hb_parni( 1, 4 );

    hb_retnl( (LONG) CreateRectRgnIndirect( &rc ) );
}


HB_FUNC( CREATEELLIPTICRGN )
{
    hb_retnl( (LONG) CreateEllipticRgn( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}


HB_FUNC( CREATEELLIPTICRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parni( 1, 1 );
    rc.left = hb_parni( 1, 2 );
    rc.bottom = hb_parni( 1, 3 );
    rc.right = hb_parni( 1, 4 );

    hb_retnl( (LONG) CreateEllipticRgnIndirect( &rc ) );
}

BOOL Array2Point(PHB_ITEM aPoint, POINT *pt )
{
   if (HB_IS_ARRAY(aPoint) && hb_arrayLen(aPoint) == 2) {
      pt->x = hb_arrayGetNL(aPoint,1);
      pt->y = hb_arrayGetNL(aPoint,2);
      return TRUE ;
   }
   return FALSE;
}

BOOL Array2Rect(PHB_ITEM aRect, RECT *rc )
{
   if (HB_IS_ARRAY(aRect) && hb_arrayLen(aRect) == 4) {
      rc->left   = hb_arrayGetNL(aRect,1);
      rc->top    = hb_arrayGetNL(aRect,2);
      rc->right  = hb_arrayGetNL(aRect,3);
      rc->bottom = hb_arrayGetNL(aRect,4);
      return TRUE ;
   }
   return FALSE;
}


HB_FUNC( CREATEPOLYGONRGN )
{
   POINT * Point ;
   POINT pt ;
   int iCount ;
   int i ;
   PHB_ITEM aParam ;
   PHB_ITEM aSub ;

   if (ISARRAY( 1 ) )
   {
       iCount = (int) hb_parinfa( 1, 0 ) ;
       Point = (POINT *) hb_xgrab( iCount * sizeof (POINT) ) ;
       aParam = hb_param(1,HB_IT_ARRAY);

       for ( i = 0 ; i<iCount ; i++ )
       {
          aSub = hb_itemArrayGet( aParam, i+1 );

          if ( Array2Point(aSub, &pt ))
               *(Point+i) = pt ;
          else {
            hb_retnl(0);
            hb_xfree(Point);
            return ;
          }
       }

       hb_retnl( (LONG) CreatePolygonRgn( Point, iCount, hb_parni( 2 ) ) ) ;
       hb_xfree(Point);

   }
   else
    hb_retnl( 0 );

}


HB_FUNC( CREATEPOLYPOLYGONRGN )
{
   POINT * Point ;
   INT * PolyPoints ;
   int iPolyCount ;
   int iCount ;
   POINT pt ;
   int i ;
   PHB_ITEM aParam ;
   PHB_ITEM aSub ;

   if (ISARRAY( 1 ) && ISARRAY( 2 ) )
   {
       iPolyCount = hb_parinfa(2,0) ;
       PolyPoints = ( INT *) hb_xgrab( iPolyCount * sizeof( INT ) ) ;

       for ( i=0 ; i < iPolyCount ; i++ )
       {
          *(PolyPoints+i) = hb_parni( 2,i+1) ;
       }

       iCount = hb_parinfa( 1, 0 ) ;
       Point = (POINT *) hb_xgrab( iCount * sizeof (POINT) ) ;
       aParam = hb_param(1,HB_IT_ARRAY);

       for ( i = 0 ; i<iCount ; i++ )
       {
          aSub = hb_itemArrayGet( aParam, i+1 );

          if ( Array2Point(aSub, &pt ))
               *(Point+i) = pt ;
          else {
            hb_retnl(0);
            hb_xfree(PolyPoints);
            hb_xfree(Point);
            return ;
          }
       }

       hb_retnl( (LONG) CreatePolyPolygonRgn( Point, PolyPoints, iPolyCount, hb_parni( 3 ) ) ) ;
       hb_xfree(PolyPoints);
       hb_xfree(Point);

   }
   else
    hb_retnl( 0 );

}

HB_FUNC( CREATEROUNDRECTRGN )
{
   hb_retnl( (LONG) CreateRoundRectRgn( hb_parni( 1 ),
                                        hb_parni( 2 ),
                                        hb_parni( 3 ),
                                        hb_parni( 4 ),
                                        hb_parni( 5 ),
                                        hb_parni( 6 ) ) ) ;
}

HB_FUNC( SETRECTRGN )
{
   hb_retl( SetRectRgn( (HRGN) hb_parnl( 1 ),
                        hb_parni( 2 )       ,
                        hb_parni( 3 )       ,
                        hb_parni( 4 )       ,
                        hb_parni( 5 )      ) ) ;
}

HB_FUNC( EQUALRGN )
{
   hb_retl( EqualRgn( (HRGN) hb_parnl( 1 ), (HRGN) hb_parnl( 2 ) ) ) ;
}


HB_FUNC( COMBINERGN )
{
   HRGN hrgnDest = 0;
   HRGN hrgnSrc1 = ( HRGN ) hb_parnl( 1 );
   HRGN hrgnSrc2 = ( HRGN ) hb_parnl( 2 );
   int fnCombineMode = hb_parni( 3 );
   hb_retni( CombineRgn( hrgnDest, hrgnSrc1, hrgnSrc2, fnCombineMode ));

}

HB_FUNC( PATHTOREGION )
{
   hb_retnl( (LONG) PathToRegion( (HDC) hb_parnl( 1 ) ) ) ;
}

HB_FUNC( OFFSETRGN )
{
   hb_retni( OffsetRgn( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) ;
}


HB_FUNC( GETRGNBOX )
{
   RECT rc;
   hb_retni( GetRgnBox( (HRGN) hb_parnl( 1 ), &rc ) ) ;
   hb_stornl( rc.left  , 2 ,2 );
   hb_stornl( rc.top   , 2, 1 );
   hb_stornl( rc.right , 2 ,4 );
   hb_stornl( rc.bottom, 2, 3 );
}


HB_FUNC( PTINREGION )
{
   hb_retl( PtInRegion( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) ;
}

HB_FUNC( RECTINREGION )
{
    RECT rc;

   if (ISARRAY( 2 ) && Array2Rect( hb_param( 2, HB_IT_ARRAY ), &rc ) )
      hb_retl( RectInRegion( (HRGN) hb_parnl( 1 ), &rc ) ) ;
}

HB_FUNC( DRAWFOCUSRECT )  //RECT

{
   RECT rct ;
   HDC  hDC = ( HDC ) hb_parni( 1 );

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   DrawFocusRect( hDC, &rct );

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

#pragma ENDDUMP
