#include "fivewin.ch"
#include "common.ch"
#include "hboo.ch"
#include "hbclass.ch"
#include "hbgwst.ch"
//-------------------------------------------------------------------------------------------------------------------------
REQUEST GWST
//-------------------------------------------------------------------------------------------------------------------------
#include "funcionc.h"
#define REPOSO 0
#define WM_ERASEBKGND 20 //0x0014
#define SRCCOPY 13369376
#define IDC_SIZENWSE        32642
#define IDC_SIZENESW        32643
#define IDC_SIZEWE          32644
#define IDC_SIZENS          32645
#define COLOR_BTNFACE             15
//-------------------------------------------------------------------------------------------------------------------------
REQUEST TDSGNEDITOR_CPPLINK
REQUEST TDSGNEDITOR_CPPUNLINK
//-------------------------------------------------------------------------------------------------------------------------
function main22()
 local oWnd, oDsgn

 DEFINE WINDOW oWnd
     oDsgn := TDsgnEditorPablo():New( 0, 0, 100, 100, oWnd )
     oWnd:oClient := oDsgn
 ACTIVATE WINDOW oWnd ON INIT WndCenter( oWnd:hWnd )
return NIL
//-------------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE RECT
   MEMBER mLONG left
   MEMBER mLONG top
   MEMBER mLONG right
   MEMBER mLONG bottom
END STRUCTURE
//-------------------------------------------------------------------------------------------------------------------------

BEGIN STRUCTURE TDsgnEditorPablo FROM TControl
      GWST_SKIP_BYTES(4) // VTBL
      GWST_SKIP_BYTES(4) // Self
      MEMBER mLONG hWnd
      MEMBER mLONG hDC
      CLASSDATA lRegistered AS LOGICAL
      DATA aShapes
      MEMBER mLONG nState
      MEMBER mLONG nOldRow
      MEMBER mLONG nOldCol
      DATA aRectSel
      DATA oFocused
      DATA oSelect, nDotSelect, aOldRect
      MEMBER mLONG nDeltaRow
      MEMBER mLONG nDeltaCol

      METHOD CppLink() EXTERN TDsgnEditorPablo_CPPLINK
      METHOD CppUnlink() EXTERN TDsgnEditorPablo_CPPUNLINK
      METHOD Destroy() INLINE ::CppUnlink() , ::TControl:Destroy()
      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR
      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
      METHOD Paint() EXTERN TDsgnEditorPablo_PAINT
      METHOD AddShape( oShape ) INLINE aadd( ::aShapes, oShape )
      METHOD LButtonDown( nRow, nCol, nKeyFlags )
      METHOD MouseMove  ( nRow, nCol, nKeyFlags )
      METHOD LButtonUp  ( nRow, nCol, nKeyFlags )
      METHOD HandleEvent ( nMsg, nWParam, nLParam )
      METHOD IsOverShape( nRow, nCol )
      METHOD IsOverDot( nRow, nCol )

END STRUCTURE
//-------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------
**********************************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
   ::_gwst_()
   ::CppLink()

   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := ::nTop + nHeight - 1
   ::nRight    := ::nLeft + nWidth - 1
   ::nStyle    := nOR( WS_CHILD, WS_VISIBLE ) // , WS_TABSTOP )
   ::nId       := ::GetNewId()
   ::oWnd      := oWnd
   ::lCaptured := .f.
   ::nState    := REPOSO
   ::aRectSel  := nil
   ::aShapes   := {}
   ::oFocused  := nil
   ::oSelect := nil
   ::nDotSelect := 0
   ::aOldRect  := array(4)

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif

return Self

**********************************************************************************************************************
//  METHOD Paint() CLASS TDsgnEditorPablo
**********************************************************************************************************************
////   local aRect   := GetClientRect(::hWnd)
////   local hDCMem  := CreateCompatibleDC( ::hDC )
////   local hBmpMem := CreateCompatibleBitmap( ::hDC, aRect[4], aRect[3] )
////   local hOldBmp := SelectObject( hDCMem, hBmpMem )
////   local oFigura, n, nLen
////   local nCol, nRow
////
////   nLen := len( ::aShapes )
////
////   FillSolidRect( hDCMem, aRect, GetSysColor( COLOR_BTNFACE )  )
////
////   /*
////   for nCol := 1 to aRect[4] step 10
////       for nRow := 1 to aRect[3] step 10
////           SetPixel( hDCMem, nCol, nRow, 0 )
////       next
////   next
////   */
////
////   for n := 1 to nLen
////       oFigura := ::aShapes[n]
////       oFigura:Paint( hDCMem )
////   next
////
////   if !empty( ::aRectSel )
////      DrawFocusRect( hDCMem, ::aRectSel[1], ::aRectSel[2], ::aRectSel[3], ::aRectSel[4])
////   endif
////
////
////
////   BitBlt( ::hDC, 0, 0, aRect[4], aRect[3], hDCMem, 0, 0, SRCCOPY )
////   SelectObject( hDCMem, hOldBmp )
////   DeleteObject( hBmpMem )
////   DeleteDC( hDCMem )
////
////   return 0
////
**********************************************************************************************************************
      METHOD IsOverShape( nRow, nCol ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
local oShape

for each oShape in ::aShapes
    if PtInRect( nRow, nCol, oShape:aRect )
       return oShape
    endif
next

::nDotSelect := ::IsOverDot( nRow, nCol )
if ::nDotSelect != 0
   return ::oSelect
endif

return nil

**********************************************************************************************************************
      METHOD IsOverDot( nRow, nCol ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
local n

if ::oSelect != nil

   for n := 1 to 8
       if PtInRect( nRow, nCol, ::oSelect:aDots[n] )
          return n
       endif
   next

endif

return 0


**********************************************************************************************************************
      METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
if lAnd( nRow , 0x8000) ; nRow := nOr(nRow,0xFFFF0000) ; end
if lAnd( nCol , 0x8000) ; nCol := nOr(nCol,0xFFFF0000) ; end

if !::lCaptured

   ::Capture()
   ::lCaptured := .t.
   ::nOldRow := nRow
   ::nOldCol := nCol
   ::oSelect  := ::IsOverShape( nRow, nCol )
   if ::oSelect != nil
      ::nDeltaRow := nRow - ::oSelect:nTop
      ::nDeltaCol := nCol - ::oSelect:nLeft
      ::aOldRect  := ::oSelect:aRect
   endif

endif

return 0



**********************************************************************************************************************
      METHOD MouseMove  ( nRow, nCol, nKeyFlags ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
local aRect, nWidth, nHeight, nEn
if lAnd( nRow , 0x8000) ; nRow := nOr(nRow,0xFFFF0000) ; end
if lAnd( nCol , 0x8000) ; nCol := nOr(nCol,0xFFFF0000) ; end

if ::lCaptured

   if ::oSelect == nil
      // seleccionando
      ::aRectSel := NormalizeRect( {::nOldRow, ::nOldCol, nRow, nCol } )
   else
      // Moviendo
      if !::oSelect:lCanChangeSize .and. ::nDotSelect > 0

      else
         do case
            case ::nDotSelect == 0  // CENTRO

                 ::oSelect:aRect := { nRow - ::nDeltaRow, ;
                                      nCol - ::nDeltaCol, ;
                                      nRow - ::nDeltaRow + ::oSelect:nHeight, ;
                                      nCol - ::nDeltaCol + ::oSelect:nWidth    }
                  CursorSize()

            case ::nDotSelect == 1 // IZDA-UP

                 ::oSelect:aRect := { nRow , ;
                                      nCol , ;
                                      ::aOldRect[3], ;
                                      ::aOldRect[4]    }

            case ::nDotSelect == 2  // UP

                 ::oSelect:aRect := { nRow , ;
                                      ::aOldRect[2], ;
                                      ::aOldRect[3], ;
                                      ::aOldRect[4]    }

            case ::nDotSelect == 3  // DCHA-UP

                 ::oSelect:aRect := { nRow , ;
                                      ::aOldRect[2], ;
                                      ::aOldRect[3], ;
                                      nCol    }

            case ::nDotSelect == 4  // DCHA

                 ::oSelect:aRect := { ::aOldRect[1], ;
                                      ::aOldRect[2], ;
                                      ::aOldRect[3], ;
                                      nCol    }

            case ::nDotSelect == 5  // DCHA-DOWN

                 ::oSelect:aRect := { ::aOldRect[1], ;
                                      ::aOldRect[2], ;
                                      nRow, ;
                                      nCol    }

            case ::nDotSelect == 6  // DOWN

                 ::oSelect:aRect := { ::aOldRect[1], ;
                                      ::aOldRect[2], ;
                                      nRow, ;
                                      ::aOldRect[4]  }

            case ::nDotSelect == 7  // DOWN-LEFT

                 ::oSelect:aRect := { ::aOldRect[1], ;
                                      nCol, ;
                                      nRow, ;
                                      ::aOldRect[4]  }

            case ::nDotSelect == 8  // LEFT

                 ::oSelect:aRect := { ::aOldRect[1], ;
                                      nCol, ;
                                      ::aOldRect[3], ;
                                      ::aOldRect[4]  }
         endcase
      endif
      if ::nDotSelect > 0
         SetCursor( LoadCursor(0,{ IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE,IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE}[::nDotSelect]))
      endif

   endif

   ::Refresh()

else
   if ::oSelect != nil
      if ( ::nDotSelect := ::IsOverDot( nRow, nCol )) != 0
         SetCursor( LoadCursor(0,{ IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE,IDC_SIZENWSE,IDC_SIZENS,IDC_SIZENESW,IDC_SIZEWE}[::nDotSelect]))
      else
         CursorArrow()
      endif
   else
      CursorArrow()
   endif
endif


return 0




**********************************************************************************************************************
      METHOD LButtonUp  ( nRow, nCol, nKeyFlags ) CLASS TDsgnEditorPablo
**********************************************************************************************************************
local oShape
if lAnd( nRow , 0x8000) ; nRow := nOr(nRow,0xFFFF0000) ; end
if lAnd( nCol , 0x8000) ; nCol := nOr(nCol,0xFFFF0000) ; end

if ::lCaptured
   ReleaseCapture()
   ::lCaptured := .f.
   ::aRectSel := NormalizeRect( {::nOldRow, ::nOldCol, nRow, nCol } )
   if ::oSelect == nil .and. ::aRectSel[3] - ::aRectSel[1] > 3 .and. ::aRectSel[4] - ::aRectSel[2] > 3
      oShape := TShape():New( ::aRectSel[1],::aRectSel[2],::aRectSel[3],::aRectSel[4], self )
      oShape:nClrBorder := CLR_WHITE
      oShape:lCanSize := .T.
   else
      ::nDeltaRow := 0
      ::nDeltaCol := 0
   endif
   ::aRectSel := {}
   ::Refresh()
endif

return 0

//***************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDsgnEditorPablo
//***************************************************************************************************

if nMsg == WM_ERASEBKGND
   return 1
endif


return ::TControl:HandleEvent( nMsg, nWParam, nLParam )


#pragma BEGINDUMP


#include <windows.h>
#include "hbapi.h"
#define HB_OS_WIN_32_USED
#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
//-------------------------------------------------------------------------------------------------------------------------
#include "hbapi.h"
#include "hbvm.h"
//-------------------------------------------------------------------------------------------------------------------------
#define __GWST_MEMBER_BOOL__         1
#define __GWST_MEMBER_BYTE__         2
#define __GWST_MEMBER_WORD__         3
#define __GWST_MEMBER_DWORD__        4
#define __GWST_MEMBER_DWORD64__      5
#define __GWST_MEMBER_PCLIPVAR__     6
#define __GWST_MEMBER_FLOAT__        7
#define __GWST_MEMBER_DOUBLE__       8
#define __GWST_MEMBER_LPSTR__        9
#define __GWST_MEMBER_BINSTR__      10
#define __GWST_MEMBER_SZSTR__       11
#define __GWST_MEMBER_DYNSZ__       12
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__MALLOC__      );
HB_FUNC( __GWST__MFREE__       );
HB_FUNC( __GWST__ZEROMEMORY__  );
HB_FUNC( __GWST__C2MEM__       );
HB_FUNC( __GWST__MEM2C__       );
HB_FUNC( __GWST__GET__         );
HB_FUNC( __GWST__SET__         );
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__MALLOC__ ) // METHOD GWST():_malloc_( n )   -> pMem
{
   UINT    nSize = (UINT) hb_parnl(1);
   if( nSize != 0)
   {
      LPSTR p = (LPSTR) malloc( nSize );
      UINT  n;
      for( n = 0; n < nSize ; n++) p[n] = 0;
      hb_retnl( (LONG) p);
   }
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__MFREE__ ) // METHOD GWST():_mfree_( pMem )  -> NIL
{
   void * p = (void *) hb_parnl(1);
   if( p != NULL ) free(p);
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__C2MEM__ )
{
   LPSTR pSrc  = hb_parc(1);
   ULONG n     = (ULONG) hb_parclen(1);
   LPSTR pDst  = (LPSTR) hb_parnl(2);
   ULONG nSize = (ULONG) hb_parnl(3);
   if( n < nSize) nSize = n;
   for( n = 0 ; n < nSize ; n++ ) pDst[n] = pSrc[n];
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__MEM2C__ )  //(::_m__pt_ , ::_mc__size_ )
{
   LPSTR pSrc  = (LPSTR) hb_parnl(1);
   ULONG nSize = (ULONG) hb_parnl(2);
   hb_retclen(pSrc,nSize);
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__GET__ )// (1pMem,2nOffset,3nSize,4nPtType) -> val
{
   void * pMem    = (void *) ( hb_parnl(1) + hb_parnl(2) );
   ULONG  nSize   = (ULONG)  hb_parnl(3);
   ULONG  nPtType = (ULONG)  hb_parnl(4);

   switch(nPtType)
   {
      case __GWST_MEMBER_BOOL__    :
      {
         BOOL  * p = (BOOL *) pMem;
         hb_retl( p[0] );
         return;
      }
      case __GWST_MEMBER_BYTE__    :
      {
         BYTE  * p = (BYTE*) pMem ;
         BYTE  ch  = p[0];
         hb_retnl( (LONG) ch );
         return;
      }
      case __GWST_MEMBER_WORD__    :
      {
         WORD  * p = (WORD*) pMem;
         WORD  w   = p[0];
         hb_retnl( (LONG) w );
         return;
      }
      case __GWST_MEMBER_LPSTR__   : // Pointer AS LONG
      case __GWST_MEMBER_DWORD__   : // LONG
      {
         LONG * p = (LONG *) pMem;
         hb_retnl( p[0] );
         return;
      }
      case __GWST_MEMBER_DWORD64__ : // AS CHARACTER
      {
         hb_retclen((LPSTR)pMem,8);
         return;
      }
      case __GWST_MEMBER_PCLIPVAR__ :
      {
         PHB_ITEM * p = (PHB_ITEM *) pMem;
         hb_itemReturn( p[0] );
         return;
      }
      case __GWST_MEMBER_FLOAT__   :
      {
        FLOAT * p  = (FLOAT *) pMem;
        FLOAT fl   = p[0];
        hb_retnd((double) fl);
        return;
      }
      case __GWST_MEMBER_DOUBLE__  :
      {
        double * p  = (double *) pMem;
        hb_retnd(p[0]);
        return;
      }
      case __GWST_MEMBER_BINSTR__  :
      {
         hb_retclen((LPSTR) pMem , nSize );
         return;
      }
      case __GWST_MEMBER_SZSTR__ :
      {
         LPSTR p = (LPSTR) pMem;
         ULONG n;
         for( n=0; n < nSize; n++){ if( p[n] == 0 )  hb_retc(p); }
         hb_retclen((LPSTR) pMem , nSize-1 );
         return;
      }
      case __GWST_MEMBER_DYNSZ__ :
      {
         LPSTR * p = (LPSTR *) pMem;
         if( p[0] != NULL ) hb_retc(p[0]);
         return;
      }
    }
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__SET__ )// (1val, 2pMem,3nOffset,4nSize,5nPtType)
{
   LPBYTE pMem    = (LPBYTE) ( hb_parnl(2) + hb_parnl(3) );
   ULONG  nSize   = (ULONG)  hb_parnl(4);
   ULONG  nPtType = (ULONG)  hb_parnl(5);

   if( pMem == NULL ) return;
   switch(nPtType)
   {
      case __GWST_MEMBER_BOOL__    :
      {
         BOOL  * p = (BOOL *) pMem;
         p[0] = hb_parl(1);
         return;
      }
      case __GWST_MEMBER_BYTE__    :
      {
         BYTE  * p = (BYTE*) pMem ;
         p[0] = (BYTE) hb_parnl(1);
         return;
      }
      case __GWST_MEMBER_WORD__    :
      {
         WORD  * p = (WORD*) pMem;
         p[0] = (WORD) hb_parnl(1);
         return;
      }
      case __GWST_MEMBER_LPSTR__   : // Pointer AS LONG
      case __GWST_MEMBER_DWORD__   : // LONG
      {
         LONG * p = (LONG *) pMem;
         p[0] = hb_parnl(1);
         return;
      }
      case __GWST_MEMBER_DWORD64__ : // AS CHARACTER
      {
         if( hb_parclen(1) > 7 )
         {
            LPSTR pDst = (LPSTR ) pMem ;
            LPSTR pSrc = hb_parc(1);
            ULONG n;
            for( n = 0; n < 8 ; n++) pDst[n] = pSrc[n];
         }
         return;
      }
      case __GWST_MEMBER_PCLIPVAR__ :
      {
         PHB_ITEM * p = (PHB_ITEM *) pMem;
         if( p[0] != NULL){hb_itemRelease(p[0]); p[0] = NULL; }
         if( hb_parinfo( 1 ) != HB_IT_NIL )
         {
            p[0] = hb_itemNew(NULL);
            hb_itemCopy(p[0],hb_param( 1 ,  HB_IT_ANY ) );
         }
         return;
      }
      case __GWST_MEMBER_FLOAT__   :
      {
        FLOAT * p  = (FLOAT *) pMem;
        p[0] = (FLOAT) hb_parnd(1);
        return;
      }
      case __GWST_MEMBER_DOUBLE__  :
      {
        double * p  = (double *) pMem;
        p[0] = hb_parnd(1);
        return;
      }
      case __GWST_MEMBER_BINSTR__  :
      {
        LPSTR p  = (LPSTR) pMem;
        LPSTR pSrc;
        ULONG nLen = hb_parclen(1);
        ULONG n;
        if( nLen < nSize){ for( n = nLen ; n < nSize; n++) p[n] = 0;}
        else if( nLen > nSize ) nLen = nSize;
        pSrc = hb_parc(1);
        for( n = nLen ; n < nSize; n++) p[n] = pSrc[n];
        return;
      }
      case __GWST_MEMBER_SZSTR__ :
      {
        LPSTR p  = (LPSTR) pMem;
        LPSTR pSrc;
        ULONG nLen = hb_parclen(1);
        ULONG n;
        if( nLen < nSize){ for( n = nLen ; n < nSize; n++) p[n] = 0;}
        else if( nLen > nSize ) nLen = nSize;
        pSrc = hb_parc(1);
        for( n = nLen ; n < nSize; n++) p[n] = pSrc[n];
        p[(nSize-1)] = 0;
        return;
      }
      case __GWST_MEMBER_DYNSZ__ :
      {
         LPSTR * pp     = (LPSTR *) pMem;
         UINT    nLen  = hb_parclen(1);
         if( pp[0] != NULL ){ free( pp[0]); pp[0] = NULL; }
         if( nLen > 0)
         {
            LPSTR pSrc = hb_parc(1);
            UINT n;
            LPSTR p = pp[0] = (LPSTR) malloc( nLen +1 );
            p[nLen] = 0;
            for( n = nLen ; n < nLen; n++) p[n] = pSrc[n];
         }
         return;
      }
    }
}
//-------------------------------------------------------------------------------------------------------------------------
HB_FUNC( __GWST__ZEROMEMORY__  )
{
   LPSTR p      = (LPSTR) hb_parnl(1);
   UINT  nSize  = (UINT) hb_parnl(2);
   if( (p != NULL) && ( nSize != 0 ) )
   {
      UINT n;
      for(n=0;n<nSize;n++) p[n] = 0;
   }
}
//-------------------------------------------------------------------------------------------------------------------------
void * gwstGetPointer( void )
{
   hb_objSendMsg( hb_stackSelfItem() , "_m__pt_", 0 );
   return ( void * )  hb_parnl( -1 );
}
//-------------------------------------------------------------------------------------------------------------------------
void gwstSetPointer( void * p)
{
   PHB_ITEM pItem = hb_itemPutNL( NULL , (LONG) p);
   hb_objSendMsg( hb_stackSelfItem() , "_m__pt_", 1 , pItem );
   hb_itemRelease( pItem );
}
//-------------------------------------------------------------------------------------------------------------------------




#pragma ENDDUMP

