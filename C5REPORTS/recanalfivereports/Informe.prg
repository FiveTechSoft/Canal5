
#include "fivewin.ch"
#include "Informe.ch"




Function test()

    local oWnd
    local oPaper
   local nTop := 20
    DEFINE WINDOW oWnd COLOR 0, CLR_GRAY VSCROLL HSCROLL

              oPanel := TPanel():New( 0, 0, 100, 300, oWnd )
              oWnd:oLeft := oPanel

               oSp := TSoporte():New( 0, oPanel:nWidth, oWnd )

  *  oSp:oInspect := oList

    o := TBanda():New(                       nTop,  0, 700, 100, oSp, "PageHeader" )
    o := TBanda():New(            nTop + 100 + 20,  0, 700, 400, oSp, "Detail" )
    o := TBanda():New( nTop + 100 + 20 + 400 + 20,  0, 700, 100, oSp, "PageFooter" )

    DEFINE SCROLLBAR oWnd:oHScroll HORIZONTAL   OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveLeft() ;
      // ON DOWN     oSp:MoveRight() ;
     //  ON PAGEUP   oSp:PanLeft() ;
     //  ON PAGEDOWN oSp:PanRight() ;
     //  ON THUMBPOS oSp:ThumbPos( ,nPos )

    DEFINE SCROLLBAR oWnd:oVScroll VERTICAL OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveUp() ;
       ON DOWN     oSp:MoveDown()

  *  oSp:SetProperties()

          ACTIVATE WINDOW oWnd MAXIMIZED

    return nil









   /*





function Informes()

local oWnd, o, oSp,  oPanel, oFont, nGroup, oMenu
local hDC, aFonts
local nTop := 20
local o1, o2, o3, o4, o5, o6, o7, o8

DEFINE FONT oFont NAME "Verdana" SIZE 0,-11
/*
MENU oMenu
     MENUITEM "Archivo"
     MENUITEM "Edición"
     MENUITEM "Formato"
     MENUITEM "Vista"
ENDMENU





DEFINE WINDOW oWnd COLOR 0, CLR_GRAY VSCROLL HSCROLL


    oPanel := TPanel():New( 0, 0, 100, 300, oWnd )
    oWnd:oLeft := oPanel

    DEFINE BUTTONBAR oBar OF oPanel 3D SIZE 32, 32 RIGHT
    oBar:bLClicked := {||.t.}
   /*
      DEFINE BUTTON o1 OF oBar NAME "curarrow"              FLAT PRESSED ACTION (nActivo := ARROW,  o1:lPressed := !o1:lPressed,             , o1:Refresh())
       DEFINE BUTTON o2 OF oBar NAME "text"                  FLAT         ACTION (nActivo := TEXTO,          ResetBar(.f.), o2:lPressed := .t.)
       DEFINE BUTTON o3 OF oBar NAME "field"                 FLAT         ACTION (nActivo := FIELD,          ResetBar(.f.), o3:lPressed := .t.)
       DEFINE BUTTON o4 OF oBar NAME "image"                 FLAT         ACTION (nActivo := IMAGE,          ResetBar(.f.), o4:lPressed := .t.)
       DEFINE BUTTON o5 OF oBar NAME "line"                  FLAT         ACTION (nActivo := LINE,           ResetBar(.f.), o5:lPressed := .t.)
       DEFINE BUTTON o6 OF oBar NAME "box"                   FLAT         ACTION (nActivo := BOX,            ResetBar(.f.), o6:lPressed := .t.)
       DEFINE BUTTON o7 OF oBar NAME "base"                  FLAT GROUP   ACTION (nActivo := BASE,           ResetBar(.f.), o7:lPressed := .t.)
       DEFINE BUTTON o8 OF oBar NAME "grid"  ACTION oSp:SetGrid( !oSp:lGrid ) FLAT
       DEFINE BUTTON OF oBar                                  FLAT
       DEFINE BUTTON OF oBar                                  FLAT


   // oList := TListProp():New( 2, 2, 200, 500, , {"","",""},{20, 100, 100}, oPanel, , , ,,,, oFont )
        oList := TInspector():New( 2, 2, 200, 500, , {"","",""},{20, 100, 100}, oPanel, , , ,,,, oFont )
    oPanel:oClient := oList
    oList:nLineStyle := 2

    oSp := TSoporte():New( 0, oPanel:nWidth, oWnd )

    oSp:oInspect := oList

  *  o := TBanda():New(                       nTop,  0, 700, 100, oSp, "PageHeader" )
  *  o := TBanda():New(            nTop + 100 + 20,  0, 700, 400, oSp, "Detail" )
   * o := TBanda():New( nTop + 100 + 20 + 400 + 20,  0, 700, 100, oSp, "PageFooter" )

    DEFINE SCROLLBAR oWnd:oHScroll HORIZONTAL   OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveLeft() ;
      // ON DOWN     oSp:MoveRight() ;
     //  ON PAGEUP   oSp:PanLeft() ;
     //  ON PAGEDOWN oSp:PanRight() ;
     //  ON THUMBPOS oSp:ThumbPos( ,nPos )

    DEFINE SCROLLBAR oWnd:oVScroll VERTICAL OF oWnd ;
       RANGE 1, 100 ;
       ON UP       oSp:MoveUp() ;
       ON DOWN     oSp:MoveDown()

    oSp:SetProperties()
*/

*ACTIVATE WINDOW oWnd MAXIMIZED

*return nil



**********************************
 function ResetBar( lBar )
**********************************
 local n, nLen
 DEFAULT lBar := .t.

 nLen := len( oBar:aControls )
 for n := 1 to nLen
     oBar:aControls[n]:lPressed := .f.
     oBar:aControls[n]:Refresh()
 next
 if lBar
    oBar:aControls[1]:lPressed := .t.
    oBar:aControls[1]:Refresh()
    nActivo := ARROW
 endif

return nil

function Inspector()
return oList


function aGetFontNames()

local oInsp := Inspector()
local hDC := GetDC( oInsp:hWnd )
local aFonts := GetFontNames(hDC)
aFonts := asort( aFonts )
ReleaseDC(oInsp:hWnd,hDC)

return  aFonts














#pragma BEGINDUMP


#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
#include "hbset.h"
#include "hbapiitm.h"
#include "..\include\uxtheme.h"

HINSTANCE GetInstance( void );

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

HB_FUNC( SETACTIVEWINDOW )
{
         hb_retnl( (LONG) SetActiveWindow( ( HWND ) hb_parnl( 1 )));
}

HB_FUNC( SETFOREGROUNDWINDOW )
{
         hb_retnl( (LONG) SetForegroundWindow( ( HWND ) hb_parnl( 1 )));
}

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

HB_FUNC( SELECTCLIPRGN )
{
    hb_retni( SelectClipRgn( ( HDC ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ) ) );
}

HB_FUNC( EXCLUDECLIPRECT )
{
  hb_retni( ExcludeClipRect( ( HDC ) hb_parnl( 1 ),         // handle to DC
                                     hb_parni( 2 ),
                                     hb_parni( 3 ),
                                     hb_parni( 4 ),
                                     hb_parni( 5 )));
}

HB_FUNC( CREATERECTRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parvni( 1, 1 );
    rc.left = hb_parvni( 1, 2 );
    rc.bottom = hb_parvni( 1, 3 );
    rc.right = hb_parvni( 1, 4 );

    hb_retnl( (LONG) CreateRectRgnIndirect( &rc ) );
}


HB_FUNC( CREATEELLIPTICRGN )
{
    hb_retnl( (LONG) CreateEllipticRgn( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}


HB_FUNC( CREATEELLIPTICRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parvni( 1, 1 );
    rc.left = hb_parvni( 1, 2 );
    rc.bottom = hb_parvni( 1, 3 );
    rc.right = hb_parvni( 1, 4 );

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

   if (HB_ISARRAY( 1 ) )
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

   if (HB_ISARRAY( 1 ) && HB_ISARRAY( 2 ) )
   {
       iPolyCount = hb_parinfa(2,0) ;
       PolyPoints = ( INT *) hb_xgrab( iPolyCount * sizeof( INT ) ) ;

       for ( i=0 ; i < iPolyCount ; i++ )
       {
          *(PolyPoints+i) = hb_parvni( 2,i+1) ;
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
   HRGN hrgnDest;
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
   hb_storvnl( rc.left  , 2 ,2 );
   hb_storvnl( rc.top   , 2, 1 );
   hb_storvnl( rc.right , 2 ,4 );
   hb_storvnl( rc.bottom, 2, 3 );
}


HB_FUNC( PTINREGION )
{
   hb_retl( PtInRegion( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) ;
}

HB_FUNC( RECTINREGION )
{
    RECT rc;

   if (HB_ISARRAY( 2 ) && Array2Rect( hb_param( 2, HB_IT_ARRAY ), &rc ) )
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
    rct.top    = hb_parvni( 2, 1 );
    rct.left   = hb_parvni( 2, 2 );
    rct.bottom = hb_parvni( 2, 3 );
    rct.right  = hb_parvni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parvnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right-1, rct.top );
       LineTo( hDC, rct.right-1, rct.bottom-1 );
       LineTo( hDC, rct.left, rct.bottom-1 );
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

      rct.top    = hb_parvni( 3, 1 );
      rct.left   = hb_parvni( 3, 2 );
      rct.bottom = hb_parvni( 3, 3 );
      rct.right  = hb_parvni( 3, 4 );

      hb_retl( PtInRect( &rct, pt ) );
   }

   HB_FUNC( INTERSECTRECT )
   {

      RECT rc, rc01, rc02;
      RECT rc0, rc1;

      rc01.top = hb_parvni( 1, 1 );
      rc01.left = hb_parvni( 1, 2 );
      rc01.bottom = hb_parvni( 1, 3 );
      rc01.right = hb_parvni( 1, 4 );

      rc02.top = hb_parvni( 2, 1 );
      rc02.left = hb_parvni( 2, 2 );
      rc02.bottom = hb_parvni( 2, 3 );
      rc02.right = hb_parvni( 2, 4 );

      rc0 = rc01;
      rc1 = rc02;

      hb_retl( IntersectRect( &rc, &rc0, &rc1 ) );

   }

   HB_FUNC( SETROP2 )  // (hdc, fnDrawMode)
   {
      hb_retni( ( LONG ) SetROP2( ( HDC ) hb_parni( 1 ), hb_parnl( 2 ) ));
   }

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

   HB_FUNC( DRAWEDGE )
   {
      HDC hDC     = (HDC) hb_parnl( 1 );
      RECT rc;
      HBRUSH hOldBrush;
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);

      hb_retl( DrawEdge( hDC, &rc, hb_parnl( 3 ), hb_parnl( 4 ) ) );
   }

   HB_FUNC( FONTCAPTION )
   {
        BOOL bTool = hb_parl(1);
        HFONT hFont;
        NONCLIENTMETRICS info;
        //BOOL bRet;
        info.cbSize = sizeof(info);
        SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof(info), &info, 0 );
        if( bTool )
        {
            hFont = CreateFontIndirect( &info.lfSmCaptionFont );
        }
        else
        {
            hFont = CreateFontIndirect( &info.lfCaptionFont );
        }
        hb_retnl( (LONG) hFont );
   }
/*
typedef struct tagNONCLIENTMETRICS {  UINT cbSize;
  int iBorderWidth;
  int iScrollWidth;
  int iScrollHeight;
  int iCaptionWidth;
  int iCaptionHeight;
  LOGFONT lfCaptionFont;
  int iSmCaptionWidth;
  int iSmCaptionHeight;
  LOGFONT lfSmCaptionFont;
  int iMenuWidth ;
  int iMenuHeight;
  LOGFONT lfMenuFont;
  LOGFONT lfStatusFont;
  LOGFONT lfMessageFont;
}
*/
   HB_FUNC( METRICSCAPTION )
   {
      HFONT hFont;
        NONCLIENTMETRICS info;
        //BOOL bRet;
        info.cbSize = sizeof(info);
        SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof(info), &info, 0 );
        hb_reta( 7 );
        hb_storvni( info.iCaptionWidth,    -1, 1 );
        hb_storvni( info.iCaptionHeight,   -1, 2 );
        hb_storvni( info.iSmCaptionWidth,  -1, 3 );
        hb_storvni( info.iSmCaptionHeight, -1, 4 );
        hb_storvni( info.iBorderWidth,     -1, 5 );
        hb_storvni( info.iMenuWidth ,      -1, 6 );
        hb_storvni( info.iMenuHeight,      -1, 7 );
   }

   HB_FUNC( DRAWCAPTION )
   {
      RECT rc;
      rc.top    = hb_parvni( 3, 1);
      rc.left   = hb_parvni( 3, 2);
      rc.bottom = hb_parvni( 3, 3);
      rc.right  = hb_parvni( 3, 4);

       hb_retl( DrawCaption( ( HWND )hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ), &rc, hb_parni(4)));
   }

   HB_FUNC( BOX )
   {
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen;
      HPEN hOldPen;
      RECT rc;

      if( hb_pcount() > 3 )
      {
         hPen = CreatePen( hb_parni(4),1, (COLORREF)hb_parnl( 3 ));
      }
      else
      {
         hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 3 ));
      }
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, rc.left, rc.top, NULL );
      LineTo( hDC, rc.right, rc.top );
      LineTo( hDC, rc.right, rc.bottom );
      LineTo( hDC, rc.left, rc.bottom );
      LineTo( hDC, rc.left, rc.top );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
   }

   HB_FUNC( LINE )
   {
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 6 ));
      HPEN hOldPen;
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, hb_parni( 3 ), hb_parni( 2 ), NULL );
      LineTo( hDC, hb_parni( 5 ), hb_parni( 4 ) );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
   }


   HB_FUNC( ISWINDOWVISIBLE )
   {
      hb_retl( IsWindowVisible( (HWND) hb_parnl(1) ) );
   }

   //////////////////////////////////////////////////////////////////////////   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////

   LPWSTR AnsiToWide( LPSTR cAnsi )
   {
      WORD wLen;
      LPWSTR cString;

      wLen  = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, 0, 0 );

      cString = (LPWSTR) hb_xgrab( wLen * 2 );
      MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, cString, wLen );

      return ( cString );
   }

   //--------------------------------------------------------------------------

   LPSTR WideToAnsi( LPWSTR cWide )
   {
      WORD wLen;
      LPSTR cString;

      wLen = WideCharToMultiByte( CP_ACP, 0, cWide, -1, cString, 0, NULL, NULL );

      cString = (LPSTR) hb_xgrab( wLen );
      WideCharToMultiByte( CP_ACP, 0, cWide, -1, cString, wLen, NULL, NULL );

      return ( cString );
   }


   HB_FUNC ( ANSITOWIDE )  // ( cAnsiStr ) -> cWideStr
   {
      WORD wLen;
      LPSTR cOut;

      wLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, hb_parc( 1 ), -1, 0, 0 );
      cOut = ( char * ) hb_xgrab( wLen * 2 );
      MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, hb_parc( 1 ), -1, ( LPWSTR ) cOut, wLen );

      hb_retclen( cOut, wLen * 2 - 1 );
      hb_xfree( cOut );
   }

   //--------------------------------------------------------------------------

   HB_FUNC ( WIDETOANSI )  // ( cWideStr, nLen ) -> cAnsiStr
   {
      WORD wLen;
      LPWSTR cWideStr;
      LPSTR cOut;

      cWideStr = ( LPWSTR ) hb_parc( 1 );
      wLen = WideCharToMultiByte( CP_ACP, WC_COMPOSITECHECK, cWideStr, -1, cOut, 0, NULL, NULL );
      cOut = ( char * ) hb_xgrab( wLen );
      WideCharToMultiByte( CP_ACP, WC_COMPOSITECHECK, cWideStr, -1, cOut, wLen, NULL, NULL );

      hb_retc( cOut );
      hb_xfree( cOut );
   }

   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   // ~~~~~~~ MANEJO DE TEMAS ~~~~~~
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
   // C5_ISTHEMEACTIVE
   // C5_OPENTHEMEDATA
   // C5_CLOSETHEMEDATA
   // C5_GETCURRENTTHEMENAME
   // C5_DRAWTHEMEBACKGROUND

   HB_FUNC( C5_ISAPPTHEMED )
   {
      typedef BOOL (CALLBACK* LPFNDLLFUNC2)();
      HINSTANCE hLib;
      LPFNDLLFUNC2 IsAppThemed;
      BOOL bIsAppThemed = FALSE;

      hLib = LoadLibrary( "uxtheme.dll" );
      if( hLib )
      {
          (LPFNDLLFUNC2)IsAppThemed = ((LPFNDLLFUNC2) GetProcAddress( hLib, "IsAppThemed" ));
          bIsAppThemed = (BOOL) IsAppThemed();
          FreeLibrary( hLib );
      }
      hb_retl(bIsAppThemed);
   }


   HB_FUNC( C5_ISTHEMEACTIVE ) // --> BOOL
   {
      typedef BOOL (CALLBACK* LPFNDLLFUNC2)();
      HINSTANCE hLib;
      LPFNDLLFUNC2 IsThemeActive;
      BOOL bIsActive = FALSE;

      hLib = LoadLibrary( "uxtheme.dll" );
      if( hLib )
      {
          IsThemeActive = ((LPFNDLLFUNC2) GetProcAddress( hLib, "IsThemeActive" ));
          bIsActive = (BOOL) IsThemeActive();
          FreeLibrary( hLib );
      }
      hb_retl(bIsActive);
   }

   HB_FUNC( C5_OPENTHEMEDATA ) //( ::hWnd, cTheme )
   {
     typedef HTHEME   ( FAR PASCAL  *LPOPENTHEMEDATA )( HWND hwnd, LPCSTR pszClassList );
     LPWSTR cTheme = AnsiToWide( hb_parc( 2 ) );
     HINSTANCE hLib;
     LPOPENTHEMEDATA OpenThemeData;

     hLib = LoadLibrary( "uxtheme.dll" );

     if ( hLib )
     {
         OpenThemeData = (LPOPENTHEMEDATA) GetProcAddress( hLib, "OpenThemeData" );
         hb_retnl( ( LONG ) OpenThemeData( ( HWND ) hb_parnl( 1 ) , ( LPCSTR ) cTheme ) ); //
         FreeLibrary( hLib );
     }
     hb_xfree( cTheme );
   }

   HB_FUNC( C5_CLOSETHEMEDATA )
   {
      typedef HRESULT  ( FAR PASCAL  *LPCLOSETHEMEDATA )     ( HTHEME hTheme );
      HINSTANCE hLib ;
      LPCLOSETHEMEDATA CloseThemeData;
      hLib = LoadLibrary( "uxtheme.dll" );
      if ( hLib )
      {
          CloseThemeData = (LPCLOSETHEMEDATA) GetProcAddress( hLib, "CloseThemeData" );
          hb_retni( CloseThemeData( (HTHEME) hb_parnl( 1 ) ) );
          FreeLibrary( hLib );
      }
   }


   HB_FUNC( C5_GETCURRENTTHEMENAME )
   {
     typedef HRESULT  ( FAR PASCAL  *LPGETCURRENTTHEMENAME) ( LPWSTR pszThemeFileName, int cchMaxNameChars, LPWSTR pszColorBuff, int cchMaxColorChars, LPWSTR pszSizeBuff, int cchMaxSizeChars);
     WCHAR pszThemeFileName[MAX_PATH];
     HINSTANCE hLib;
     LPGETCURRENTTHEMENAME GetCurrentThemeName;
     LPSTR cOut;

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         GetCurrentThemeName = (LPGETCURRENTTHEMENAME) GetProcAddress( hLib, "GetCurrentThemeName" );
         GetCurrentThemeName( (LPWSTR) pszThemeFileName, MAX_PATH, NULL, 0, NULL, 0 );
         cOut = WideToAnsi( pszThemeFileName );
         hb_retc( cOut );
         hb_xfree( cOut );
         FreeLibrary( hLib );
     }
   }

   HB_FUNC( C5_DRAWTHEMEBACKGROUND ) //( ::hTheme, hDC, nPartID, nStateID, pRect, pClipRect )
   {
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEBACKGROUND )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, const RECT *pRect, const RECT *pClipRect );
     HINSTANCE hLib;
     LPDRAWTHEMEBACKGROUND DrawThemeBackground;
     int iRet;
     RECT pRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeBackground = (LPDRAWTHEMEBACKGROUND) GetProcAddress( hLib, "DrawThemeBackground" );
         iRet = DrawThemeBackground( ( HTHEME ) hb_parnl( 1 ),
                                          (HDC) hb_parnl( 2 ),
                                                hb_parni( 3 ),
                                                hb_parni( 4 ),
                                                &pRect,
                                                NULL );
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
   }

/*HRESULT DrawThemeIcon(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pRect,
    HIMAGELIST himl,
    int iImageIndex
);*/

   HB_FUNC( C5_DRAWTHEMEICON ) //( ::hTheme, hDC, nPartID, nStateID, pRect, himl, index )
   {
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEICON )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, const RECT *pRect, HIMAGELIST il, int index );
     HINSTANCE hLib;
     LPDRAWTHEMEICON DrawThemeIcon;
     int iRet;
     RECT pRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeIcon = (LPDRAWTHEMEICON) GetProcAddress( hLib, "DrawThemeIcon" );
         iRet = DrawThemeIcon( ( HTHEME )     hb_parnl( 1 ),
                               ( HDC )        hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &pRect,
                               ( HIMAGELIST ) hb_parnl( 6 ),
                                              hb_parni( 7 ));
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
   }

/*HRESULT DrawThemeEdge(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pDestRect,
    UINT uEdge,
    UINT uFlags,
    RECT *pContentRect
);*/
HB_FUNC( C5_DRAWTHEMEEDGE )
{
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEEDGE )( HTHEME hTheme,
                                                        HDC hdc,
                                                        int iPartId,
                                                        int iStateId,
                                                        const RECT *pDestRect,
                                                        UINT uEdge,
                                                        UINT uFlags,
                                                        RECT *pContentRect );
     HINSTANCE hLib;
     LPDRAWTHEMEEDGE DrawThemeEdge;
     int iRet;
     RECT pRect;
     RECT pContentRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     pContentRect.top    = hb_parvnl( 5, 1 );
     pContentRect.left   = hb_parvnl( 5, 2 );
     pContentRect.bottom = hb_parvnl( 5, 3 );
     pContentRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeEdge = (LPDRAWTHEMEEDGE) GetProcAddress( hLib, "DrawThemeEdge" );
         iRet = DrawThemeEdge( ( HTHEME )     hb_parnl( 1 ),
                               ( HDC )        hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &pRect,
                                              hb_parni( 6 ),
                                              hb_parni( 7 ),
                                              &pContentRect );
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
}


/*HRESULT DrawThemeText(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    LPCWSTR pszText,
    int iCharCount,
    DWORD dwTextFlags,
    DWORD dwTextFlags2,
    const RECT *pRect
);*/

   HB_FUNC( C5_DRAWTHEMETEXT ) //( ::hWnd, cTheme )
   {
     typedef HRESULT ( FAR PASCAL  *LPDRAWTHEMETEXT )( HTHEME hTheme,
                                                       HDC hdc,
                                                       int iPartId,
                                                       int iStateId,
                                                       LPCWSTR pszText,
                                                       int iCharCount,
                                                       DWORD dwTextFlags,
                                                       DWORD dwTextFlags2,
                                                       RECT *rc );

     LPCWSTR pszText = AnsiToWide( hb_parc( 5 ) );
     HINSTANCE hLib;
     LPDRAWTHEMETEXT DrawThemeText;
     RECT rc;

     rc.top     = hb_parvnl( 8, 1 );
     rc.left    = hb_parvnl( 8, 2 );
     rc.bottom  = hb_parvnl( 8, 3 );
     rc.right   = hb_parvnl( 8, 4 );


     hLib = LoadLibrary( "uxtheme.dll" );

     if ( hLib )
     {
         DrawThemeText = (LPDRAWTHEMETEXT) GetProcAddress( hLib, "DrawThemeText" );
         hb_retnl( ( LONG ) DrawThemeText( ( HTHEME ) hb_parnl( 1 ),
                            ( HDC )    hb_parnl( 2 ),
                            hb_parni( 3 ),
                            hb_parni( 4 ),
                 (LPCWSTR)  pszText,
                            -1,
                            hb_parnl( 6 ),
                            hb_parnl( 7 ),
                            &rc ) );          //
         FreeLibrary( hLib );
     }
     hb_xfree( pszText );
   }

/*HRESULT GetThemeBackgroundContentRect(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pBoundingRect,
    RECT *pContentRect
);
*/


HB_FUNC( GETTHEMEFONT )   //(::hTheme, hDC, nPartID, nStateID, nPropID, pFont)
{

  LOGFONT plf;
  HFONT hFont;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEFONT )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, int iPropId, LOGFONT *pFont);
  HINSTANCE hLib;
  LPGETTHEMEFONT GetThemeFont;

  ZeroMemory( &plf, sizeof(plf) );

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeFont = (LPGETTHEMEFONT) GetProcAddress( hLib, "GetThemeFont" );
      hb_retnl( ( LONG ) GetThemeFont((HTHEME) hb_parnl( 1 ),
                       ( HDC ) hb_parnl( 2 ),
                       hb_parni( 3 ),
                       hb_parni( 4 ),
                       hb_parni( 5 ),
                       &plf ) );          //
      hFont = CreateFontIndirect( &plf );
      hb_retnl( (long) hFont );
      FreeLibrary( hLib );
      return;
  }
  hb_ret();
}


/*HRESULT GetThemeSysFont(          HTHEME hTheme,
    int iFontID,
    LOGFONT *plf
);*/

HB_FUNC( GETTHEMESYSFONT )   //(::hTheme, hDC, nPartID, nStateID, nPropID, pFont)
{
  LOGFONT plf;
  HFONT hFont;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMESYSFONT )( HTHEME hTheme, int iFontID,LOGFONT *pFont);
  HINSTANCE hLib;
  LPGETTHEMESYSFONT GetThemeSysFont;

  ZeroMemory( &plf, sizeof(plf) );

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeSysFont = (LPGETTHEMESYSFONT) GetProcAddress( hLib, "GetThemeSysFont" );
      GetThemeSysFont((HTHEME) hb_parnl( 1 ),
                               hb_parni( 2 ),
                               &plf );          //
      hFont = CreateFontIndirect( &plf );
      hb_retnl( (long) hFont );
      FreeLibrary( hLib );
      return;
  }
  hb_ret();

}

HB_FUNC(GETTHEMECOLOR)   //(::hTheme, nPartID, nStateID, nPropID, pColor)
{
  COLORREF color;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMECOLOR )( HTHEME hTheme, int iPartId, int iStateId, int nPropID, COLORREF *color);
  HINSTANCE hLib;
  LPGETTHEMECOLOR GetThemeColor;
  int iPropId = 204;
  if( hb_pcount() > 3 )
  {
     iPropId = hb_parni( 4 );
  }

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeColor = (LPGETTHEMECOLOR) GetProcAddress( hLib, "GetThemeColor" );
      hb_retnl( ( LONG ) GetThemeColor((HTHEME) hb_parnl( 1 ),
                                               hb_parni( 2 ),
                                               hb_parni( 3 ),
                                               iPropId,
                                               &color ) );          //
      FreeLibrary( hLib );
      hb_retnl( (long) color );
      return;
  }
  hb_ret();
}

/*HRESULT GetThemeMetric(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    int iPropId,
    int *piVal
);
*/
HB_FUNC( GETTHEMEMETRIC )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEMETRIC )( HTHEME hTheme, HDC hDC, int iPartId, int iStateId, int iPropId, int *piVal );
  HINSTANCE hLib;
  LPGETTHEMEMETRIC GetThemeMetric;
  int iVal = 0;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeMetric = (LPGETTHEMEMETRIC) GetProcAddress( hLib, "GetThemeMetric" );
      GetThemeMetric((HTHEME) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                                                     hb_parni( 3 ),
                                                     hb_parni( 4 ),
                                                     hb_parni( 5 ),
                                                     &iVal ) ;
      FreeLibrary( hLib );
      hb_retni( iVal );
      return;
  }
  hb_retni( iVal );
}
/*
HRESULT GetThemePartSize(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    RECT *prc,
    THEMESIZE eSize,
    SIZE *psz
);*/

HB_FUNC( GETTHEMEPARTSIZE )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEPARTSIZE )(HTHEME hTheme, HDC hdc, int iPartId,
                                                         int iStateId, RECT * pRect, enum THEMESIZE eSize, SIZE *psz);
  HINSTANCE hLib;
  LPGETTHEMEPARTSIZE GetThemePartSize;
  SIZE sz;
  sz.cx = 0;
  sz.cy = 0;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemePartSize = (LPGETTHEMEPARTSIZE) GetProcAddress( hLib, "GetThemePartSize" );
      GetThemePartSize((HTHEME) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                                                       hb_parni( 3 ),
                                                       hb_parni( 4 ),
                                                (RECT*) NULL,
                                                       TS_TRUE,
                                                       &sz ) ;
        FreeLibrary( hLib );
      hb_retni( sz.cy );
      return;
  }
  hb_retni( sz.cy );
}

HB_FUNC( GETTHEMESYSCOLOR )
{

  COLORREF color;
  typedef COLORREF ( FAR PASCAL  *LPGETTHEMESYSCOLOR )( HTHEME hTheme, int iColorID );
  HINSTANCE hLib;
  LPGETTHEMESYSCOLOR GetThemeSysColor;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeSysColor = (LPGETTHEMESYSCOLOR) GetProcAddress( hLib, "GetThemeSysColor" );
      GetThemeSysColor((HTHEME) hb_parnl( 1 ), hb_parni( 2 )) ;          //
      FreeLibrary( hLib );
      hb_retnl( (long) color );
      return;
  }
  hb_ret();

}

/*HRESULT GetThemeBackgroundContentRect( HTHEME hTheme,
                                         HDC hdc,
                                         int iPartId,
                                         int iStateId,
                                         const RECT *pBoundingRect,
                                         RECT *pContentRect
);
*/
HB_FUNC( GETTHEMEBACKGROUNDCONTENTRECT )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEBACKGROUNDCONTENTRECT )(HTHEME hTheme,
                                         HDC hdc,
                                         int iPartId,
                                         int iStateId,
                                         const RECT *pBoundingRect,
                                         RECT *pContentRect );
  HINSTANCE hLib;
  LPGETTHEMEBACKGROUNDCONTENTRECT GetThemeBackgroundContentRect;
  RECT rcout;
  RECT rc;

  rc.top     = hb_parvnl( 5, 1 );
  rc.left    = hb_parvnl( 5, 2 );
  rc.bottom  = hb_parvnl( 5, 3 );
  rc.right   = hb_parvnl( 5, 4 );

  rcout.top     = hb_parvnl( 5, 1 );
  rcout.left    = hb_parvnl( 5, 2 );
  rcout.bottom  = hb_parvnl( 5, 3 );
  rcout.right   = hb_parvnl( 5, 4 );



  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeBackgroundContentRect = (LPGETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hLib, "GetThemeBackgroundContentRect" );
      GetThemeBackgroundContentRect( (HTHEME) hb_parnl( 1 ),
                                     (HDC)    hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &rc          ,
                                              &rcout );          //
      FreeLibrary( hLib );

  }
  hb_reta(4);

  hb_storvni( rcout.top    , -1, 1 );
  hb_storvni( rcout.left   , -1, 2 );
  hb_storvni( rcout.bottom , -1, 3 );
  hb_storvni( rcout.right  , -1, 4 );
}

HB_FUNC( STRETCHBLT )
{
   hb_retl( StretchBlt( (HDC) hb_parnl( 1 )   ,
                        hb_parni( 2 )         ,
                        hb_parni( 3 )         ,
                        hb_parni( 4 )         ,
                        hb_parni( 5 )         ,
                        (HDC) hb_parnl( 6 )   ,
                        hb_parni( 7 )         ,
                        hb_parni( 8 )         ,
                        hb_parni( 9 )         ,
                        hb_parni( 10 )        ,
                        (DWORD) hb_parnl( 11 )
                        ) ) ;
}


HB_FUNC( REGISTERWINDOWMESSAGE )
{
     hb_retni( RegisterWindowMessage( ( LPCTSTR ) hb_parc(1)));
}

HB_FUNC( SETBRUSHORGEX )
{
   SetBrushOrgEx( (HDC) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), NULL );
   hb_ret();
}

/*BOOL SetWindowOrgEx(
  HDC hdc,        // handle to device context
  int X,          // new x-coordinate of window origin
  int Y,          // new y-coordinate of window origin
  LPPOINT lpPoint // original window origin
);*/
HB_FUNC( SETWINDOWORGEX )
{
   POINT pt;
   pt.x = 0;
   pt.y = 0;
   SetWindowOrgEx( (HDC) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), &pt );
   hb_reta( 2 );
   hb_storvni( pt.y, -1, 1 );
   hb_storvni( pt.x, -1, 2 );

}

HB_FUNC( DSGNBORDE )
{

   HDC dc = (HDC) hb_parnl( 1 );
   HBITMAP bmp  = LoadBitmap( GetInstance(), "brush" );
   HBITMAP bmp2 = LoadBitmap( GetInstance(), "brush" );
   int nXMiddle;
        int nYMiddle;
   COLORREF color;
   HBRUSH br, br2, hOldBrush;
   POINT pt;
   RECT rc, rcPaint;

   rc.top    = hb_parvni( 2, 1 );
   rc.left   = hb_parvni( 2, 2 );
   rc.bottom = hb_parvni( 2, 3 );
   rc.right  = hb_parvni( 2, 4 );

        br2 = CreatePatternBrush( bmp2 );
        br = CreatePatternBrush( bmp );

        nXMiddle = (rc.right-rc.left) / 2;
        nYMiddle = (rc.bottom-rc.top) / 2;

   hOldBrush = (HBRUSH) SelectObject( dc, br );
   color = SetBkColor( dc, RGB( 255,0,0) );

   SetBrushOrgEx( dc, rc.left, rc.top, NULL );
        SetRect( &rcPaint, rc.left, rc.top, rc.right, rc.top + 7 );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );


   SetBrushOrgEx( dc, rc.left, rc.top, NULL );
        SetRect( &rcPaint, rc.left, rc.top, rc.left + 7, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );

   SetBrushOrgEx( dc, rc.left, rc.bottom - 7, NULL );
        SetRect( &rcPaint, rc.left, rc.bottom - 7, rc.right, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );

   SetBrushOrgEx( dc, rc.right - 7, rc.top, NULL );
        SetRect( &rcPaint, rc.right - 7, rc.top, rc.right, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br2 );

   SelectObject( dc, hOldBrush );
   SetBkColor( dc, color );

        DeleteObject( bmp );
        DeleteObject( bmp2 );
        DeleteObject( br );
        DeleteObject( br2 );

}

HB_FUNC( EXTCREATEPEN )
{
   int numValues = 0;
   HPEN pen;
   LOGBRUSH lb;
   lb.lbStyle = BS_SOLID;
   lb.lbColor = (COLORREF)hb_parnl( 2 );
   lb.lbHatch = 0;

   pen = ExtCreatePen(PS_GEOMETRIC | PS_SOLID | PS_ENDCAP_SQUARE | PS_JOIN_BEVEL, hb_parni( 1 ), &lb, numValues, NULL);

   hb_retnl( (long) pen );
}


    void GradientFill95( HDC hDC, RECT rct, COLORREF crStart, COLORREF crEnd, int bVertical )
    {
       // Get the starting RGB values and calculate the incremental
       // changes to be applied.

            int nSegments = 100;
       COLORREF cr;
       int nR = GetRValue(crStart);
       int nG = GetGValue(crStart);
       int nB = GetBValue(crStart);

       int neB = GetBValue(crEnd);
       int neG = GetGValue(crEnd);
       int neR = GetRValue(crEnd);


       int nDiffR = (neR - nR);
       int nDiffG = (neG - nG);
       int nDiffB = (neB - nB);

       int ndR = 256 * (nDiffR) / (max(nSegments,1));
       int ndG = 256 * (nDiffG) / (max(nSegments,1));
       int ndB = 256 * (nDiffB) / (max(nSegments,1));

       int nCX = (rct.right-rct.left) / max(nSegments,1);
       int nCY = (rct.bottom-rct.top) / max(nSegments,1);
       int nTop = rct.top;
       int nBottom = rct.bottom;
       int nLeft = rct.left;
       int nRight = rct.right;

            HPEN hPen;
            HPEN hOldPen;
            HBRUSH hBrush;
            HBRUSH pbrOld;

            int i;

       if(nSegments > ( rct.right - rct.left ) )
          nSegments = ( rct.right - rct.left );


       nR *= 256;
       nG *= 256;
       nB *= 256;

       hPen    = CreatePen( PS_NULL, 1, 0 );
       hOldPen = (HPEN) SelectObject( hDC, hPen );

       for (i = 0; i < nSegments; i++, nR += ndR, nG += ndG, nB += ndB)
       {
          // Use special code for the last segment to avoid any problems
          // with integer division.

          if (i == (nSegments - 1))
          {
             nRight  = rct.right;
             nBottom = rct.bottom;
          }
          else
          {
             nBottom = nTop + nCY;
             nRight = nLeft + nCX;
          }

          cr = RGB(nR / 256, nG / 256, nB / 256);

          {

             hBrush = CreateSolidBrush( cr );
             pbrOld = (HBRUSH) SelectObject( hDC, hBrush );

             if( bVertical )
                Rectangle(hDC, rct.left, nTop, rct.right, nBottom + 1 );
             else
                Rectangle(hDC, nLeft, rct.top, nRight + 1, rct.bottom);

             (HBRUSH) SelectObject( hDC, pbrOld );
             DeleteObject( hBrush );
          }

          // Reset the left side of the drawing rectangle.

          nLeft = nRight;
          nTop = nBottom;
       }

       (HPEN) SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }

// hDC, aRect, nClr1, nClr2
// Utilizar mejor C5Degrada
    HB_FUNC( DEGRADA95 )
    {
            RECT rct;

            rct.top    = hb_parvni( 2, 1 );
            rct.left   = hb_parvni( 2, 2 );
            rct.bottom = hb_parvni( 2, 3 );
            rct.right  = hb_parvni( 2, 4 );

            GradientFill95( ( HDC ) hb_parnl( 1 ) , rct, hb_parnl( 3 ), hb_parnl( 4 ), hb_parl(5) );

    }


HB_FUNC( CREATEBOLD )
{
        LOGFONT lf;
      GetObject( ( HFONT ) hb_parnl( 1 ) , sizeof( LOGFONT ), &lf );
      lf.lfWeight = FW_BOLD;
                  hb_retnl( (LONG) CreateFontIndirect( &lf ));
}


HB_FUNC( WBRWSCROLL ) // ( hWnd, nRows, hFont ) --> nil
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int wRows  = hb_parni( 2 );
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   int nHLine = hb_parni( 4 );
   RECT rct;
   TEXTMETRIC tm;



   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );
   GetTextMetrics( hDC, &tm );
   if( hb_pcount() == 4 )
   {
      tm.tmHeight = nHLine;
   }
   else
   {
     tm.tmHeight += 1;
   }

   rct.top += tm.tmHeight;
   //rct.bottom -= ( ( rct.bottom - rct.top ) % tm.tmHeight );

   ScrollWindowEx( hWnd, 0, -( tm.tmHeight * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

HB_FUNC( DRAWFRAMECONTROL )
{
      RECT rc;
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);

       hb_retl( DrawFrameControl( (HDC) hb_parnl( 1 ), &rc, hb_parni( 3 ), hb_parni( 4 ) ) );
}




HB_FUNC( HWNDCOMBO )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndCombo ) ;
}

HB_FUNC( HWNDCOMBOEDIT )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndItem ) ;
   //hb_retnl( (LONG)cbi.hwndList ) ;
}

HB_FUNC( HWNDCOMBOLIST )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndList ) ;
}
// no funciona en w95 revisar GetComboBoxInfo


HB_FUNC( GETDEFAULTFONTNAME )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retc( lf.lfFaceName );

}

HB_FUNC( GETDEFAULTFONTHEIGHT )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retni( lf.lfHeight );
}

HB_FUNC( GETDEFAULTFONTWIDTH )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retni( lf.lfWidth );
}

HB_FUNC( GETDEFAULTFONTITALIC )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfItalic );
}

HB_FUNC( GETDEFAULTFONTUNDERLINE )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfUnderline );
}

HB_FUNC( GETDEFAULTFONTBOLD )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) ( lf.lfWeight == 700 ) );
}

HB_FUNC( GETDEFAULTFONTSTRIKEOUT )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfStrikeOut );
}

HB_FUNC( XDLGUNITS )
{
   HDC dc = GetDC(NULL);
   HFONT hFont = (HFONT) hb_parnl( 1 );
   LOGFONT lf, lf2;
   HFONT hSysFont;
   TEXTMETRIC tm;
   int cx, cxSys;
   int avgWidth, avgWidthSys;
   int basex;

   HFONT hOldFont = (HFONT)SelectObject(dc, hFont);
   GetObject( ( HFONT ) hFont  , sizeof( LOGFONT ), &lf );
   GetTextMetrics(dc, &tm);
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&cx);
   SelectObject(dc, hOldFont);

   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf2 );
   //GetObject( ( HFONT ) GetStockObject( SYSTEM_FONT )  , sizeof( LOGFONT ), &lf );
   lf2.lfWidth = lf.lfWidth;
   lf2.lfHeight = lf.lfHeight;
   hSysFont = CreateFontIndirect( &lf2 );
   hOldFont = (HFONT) SelectObject( dc, hSysFont );
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&cxSys);
   SelectObject(dc, hOldFont);
   DeleteObject( hSysFont );
   ReleaseDC(NULL, dc);

   avgWidth = (cx/(26+1))/2;
   avgWidthSys = (cxSys/(26+1))/2;

   basex = ( 2*avgWidth/avgWidthSys );
   hb_retni(basex);
}

HB_FUNC( YDLGUNITS )
{
   HDC dc = GetDC(NULL);
   HFONT hFont = (HFONT) hb_parnl( 1 );
   HFONT hSysFont;
   LOGFONT lf, lf2;
   TEXTMETRIC tm, tm2;
   int basey;

   HFONT hOldFont = (HFONT)SelectObject(dc, hFont);
   GetTextMetrics(dc, &tm);
   SelectObject(dc, hOldFont);

   GetObject( ( HFONT ) hFont  , sizeof( LOGFONT ), &lf );
   GetObject( ( HFONT ) GetStockObject( SYSTEM_FONT )  , sizeof( LOGFONT ), &lf2 );
   lf2.lfWidth = lf.lfWidth;
   lf2.lfHeight = lf.lfHeight;
   hSysFont = CreateFontIndirect( &lf2 );
   hOldFont = (HFONT)SelectObject(dc, hSysFont);
   GetTextMetrics(dc, &tm2);
   SelectObject(dc, hOldFont);
   DeleteObject( hSysFont );

   ReleaseDC(NULL, dc);
   basey = (2*tm.tmHeight/tm2.tmHeight);
   hb_retni( basey );
}

HB_FUNC( XYDLGUNITS )
{
   int avgWidth, avgHeight;
   HDC dc = GetDC(NULL);
   HFONT hFontOld = (HFONT)SelectObject(dc,(HFONT)hb_parnl( 1 ));
   SIZE size;
   TEXTMETRIC tm;

   GetTextMetrics(dc,&tm);
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&size);
   avgWidth = (size.cx/26+1)/2;
   avgHeight = (WORD)tm.tmHeight;
   SelectObject(dc,hFontOld);
   ReleaseDC(NULL, dc);
   hb_reta(2);
   hb_storvni( avgWidth, -1, 1 );
   hb_storvni( avgHeight, -1, 2 );
}

 /*
HB_FUNC(  GETPTSIZE ) //( HDC &dc, HFONT &font, SIZE *pSize )
{
    HFONT oldfont = 0;
    HDC dc = GetDC(NULL);
    static char *sym = "abcdefghijklmnopqrstuvwxyz"
                       "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    SIZE sz;
    sz.cx = hb_parni( 2 );
    sz.cy = hb_parni( 3 );
    TEXTMETRICA t;
    oldfont = (HFONT)SelectObject(dc,hb_parnl(1));
    GetTextMetricsA(dc,&t);
    GetTextExtentPointA(dc,sym, 52, &sz);
    pSize->cy = t.tmHeight;
    pSize->cx = (sz.cx / 26 + 1) / 2;
    SelectObject(dc,oldfont);
}
*/

HB_FUNC ( DRIVETYPE )
{
   #if defined(HB_OS_WIN_32)
      unsigned int uiType;
      char * pDrive = (char *) hb_xgrab( hb_parclen( 1 )+3 ); // allow space for '\0' & ":\"
      strcpy( pDrive, (char *) hb_parcx(1) );

      if ( strstr( pDrive, ":" ) == NULL )
      {
         strcat( pDrive, ":" ) ;
      }

      if ( strstr( pDrive, "\\" ) == NULL )
      {
         strcat( pDrive, "\\" ) ;
      }

      uiType = GetDriveType( pDrive );

      if ( uiType  == DRIVE_RAMDISK )
      {
         hb_retni( 0 );  // RAM Drive - Clipper compatible
      }
      else if (uiType == DRIVE_REMOVABLE )
      {
         hb_retni( 2 );  // Floppy Drive - Clipper compatible
      }
      else if (uiType == DRIVE_FIXED )
      {
         hb_retni( 3 );  // Hard Drive  - Clipper compatible
      }
      else if (uiType == DRIVE_CDROM )
      {
         hb_retni( 4 );  // CD-Rom Drive - xHarbour extension
      }
      else if (uiType == DRIVE_REMOTE )
      {
         hb_retni( 5 );  // Network Drive - xHarbour extension
      }
      else
      {
         hb_retni( 9 );  // Unknow Drive - xHarbour extension
      }
      hb_xfree( pDrive );
   #else
      hb_retni(9);
   #endif

}

HB_FUNC( GETBMPICONEXT )
{

   SHFILEINFO    sfi;
   HDC dcMem;
   HDC hDC;
   HBITMAP bmpMem, hOldBmp;
   RECT rct;
   COLORREF nColor;

   SHGetFileInfo(
         hb_parc( 1 ),
         FILE_ATTRIBUTE_NORMAL,
         &sfi,
         sizeof(SHFILEINFO),
         SHGFI_ICON | SHGFI_SMALLICON | SHGFI_USEFILEATTRIBUTES);


   hDC = CreateDC( "DISPLAY","","",NULL);

   dcMem = CreateCompatibleDC( hDC );
   bmpMem = CreateCompatibleBitmap( hDC, 16, 16 );
   hOldBmp = (HBITMAP) SelectObject( dcMem, bmpMem );
   rct.top    = 0;
   rct.left   = 0;
   rct.bottom = 16;
   rct.right  = 16;

   nColor = SetBkColor( dcMem, RGB(255,255,255) );
   ExtTextOut( dcMem, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
   SetBkColor( dcMem, nColor );

   DrawIconEx( dcMem, 0, 0, sfi.hIcon, 16, 16, NULL, NULL, DI_NORMAL );
   DestroyIcon( sfi.hIcon );
   SelectObject( dcMem, hOldBmp );
   DeleteDC( dcMem );
   DeleteDC( hDC );
   hb_retnl( (LONG) bmpMem );
}

HB_FUNC( SETSTRETCHBLTMODE )
{
   hb_retni( SetStretchBltMode( (HDC) hb_parnl( 1 ), hb_parni( 2 ) ) ) ;
}

void DrawBitmapEx( HDC hdc, HBITMAP hbm, WORD wCol, WORD wRow, WORD wWidth,
                 WORD wHeight, DWORD dwRaster )
{
    HDC       hDcMem, hDcMemX;
    BITMAP    bm, bmx;
    HBITMAP   hBmpOld, hbmx, hBmpOldX;

    if( !hdc || !hbm )
       return;

    hDcMem  = CreateCompatibleDC( hdc );
    hBmpOld = ( HBITMAP ) SelectObject( hDcMem, hbm );

    if( ! dwRaster )
       dwRaster = SRCCOPY;

    GetObject( hbm, sizeof( BITMAP ), ( LPSTR ) &bm );

    if( ! wWidth || ! wHeight )
       BitBlt( hdc, wRow, wCol, bm.bmWidth, bm.bmHeight, hDcMem, 0, 0, dwRaster );
    else
    {
       hDcMemX          = CreateCompatibleDC( hdc );
       bmx              = bm;
       bmx.bmWidth      = wWidth;
       bmx.bmHeight     = wHeight;

       bmx.bmWidthBytes = ( bmx.bmWidth * bmx.bmBitsPixel + 15 ) / 16 * 2;

       hbmx = CreateBitmapIndirect( &bmx );

       SetStretchBltMode (hDcMemX, COLORONCOLOR);
       hBmpOldX = ( HBITMAP ) SelectObject( hDcMemX, hbmx );
       StretchBlt( hDcMemX, 0, 0, wWidth, wHeight, hDcMem, 0, 0,
                   bm.bmWidth, bm.bmHeight, dwRaster );
       BitBlt( hdc, wRow, wCol, wWidth, wHeight, hDcMemX, 0, 0, dwRaster );
       SelectObject( hDcMemX, hBmpOldX );
       DeleteDC( hDcMemX );
       DeleteObject( hbmx );
    }

    SelectObject( hDcMem, hBmpOld );
    DeleteDC( hDcMem );
}
HB_FUNC( DRAWBITMAPEX ) //  hDC, hBitmap, nRow, nCol, nWidth, nHeight, nRaster
{
   DrawBitmapEx( ( HDC ) hb_parnl( 1 ), ( HBITMAP ) hb_parnl( 2 ),
               hb_parni( 3 ), hb_parni( 4 ),
               hb_parni( 5 ), hb_parni( 6 ), hb_parnl( 7 ) );
}


   HB_FUNC( MULDIV )
   {
      hb_retni( MulDiv( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
   }


HB_FUNC( SETSCROLLRANGE )
{
   hb_retl( SetScrollRange( (HWND) hb_parnl( 1 ),
                            hb_parni( 2 )       ,
                            hb_parni( 3 )       ,
                            hb_parni( 4 )       ,
                            hb_parl( 5 )
                          ) ) ;
}

HB_FUNC( GETSCROLLINFOPOS )
{
   SCROLLINFO si ;
   si.cbSize = sizeof(SCROLLINFO) ;
   si.fMask  = SIF_TRACKPOS ;

   if ( GetScrollInfo( (HWND) hb_parnl( 1 ), hb_parni( 2 ), &si ) )
      hb_retni( si.nTrackPos );
   else
      hb_retni( 0 );

}


HB_FUNC( SUMAESTILO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style | hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_STYLE, style );
}

//--------------------------------------------------------------------------

HB_FUNC( RESTAESTILO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style & ~hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_STYLE, style );
}

HB_FUNC( SUMAESTILOEXTENDIDO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style | hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_EXSTYLE, style );

}

//--------------------------------------------------------------------------

HB_FUNC( RESTAESTILOEXTENDIDO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style & ~hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_EXSTYLE, style );
}


//HB_FUNC( LINE )
//{
//   HDC hDC = (HDC) hb_parnl( 1 );
//   int nTop = hb_parni( 2 );
//   int nLeft = hb_parni( 3 );
//   int nBottom = hb_parni( 4 );
//   int nRight = hb_parni( 5 );
//   COLORREF color = (COLORREF) hb_parnl(6);
//   HPEN hPen, hOldPen;
//   hPen = CreatePen( PS_SOLID, 1, color );
//   hOldPen = (HPEN) SelectObject( hDC, hPen );
//   MoveToEx( hDC, nLeft, nTop, NULL );
//   LineTo( hDC, nRight, nBottom );
//   SelectObject( hDC, hOldPen );
//   DeleteObject( hPen );
//}
//
//

HB_FUNC( ALPHABLEND )
{

}


HB_FUNC( FREELIBRARY ) // ( hDll ) --> nil
{
   hb_retnl( FreeLibrary( ( HINSTANCE ) hb_parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( LOADLIBRARY ) // ( cDllName ) --> hDll
{
   hb_retnl( ( LONG ) LoadLibrary( hb_parc( 1 ) ) );
}

#pragma ENDDUMP