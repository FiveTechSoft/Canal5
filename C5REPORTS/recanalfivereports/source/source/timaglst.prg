// Class TImageList (suport for CommCtrl ImageList controls)

#include "FiveWin.ch"

//----------------------------------------------------------------------------//

CLASS TImageList

   DATA  hImageList
   DATA  aBitmaps
   DATA  nSize
   DATA  nHeight, nWidth

   METHOD New( nWidth, nHeight, cFileName )  // Size of the images

   METHOD Add( oBmpImage, oBmpMask ) INLINE ;
      AAdd( ::aBitmaps, oBmpImage ), AAdd( ::aBitmaps, oBmpMask ),;
      ILAdd( ::hImageList, If( oBmpImage != nil, oBmpImage:hBitmap, 0 ),;
                           If( oBmpMask != nil, oBmpMask:hBitmap, 0 ) )

   METHOD AddIcon( oIcon )

   METHOD AddMasked( oBmpImage, nClrMask ) INLINE ;
      AAdd( ::aBitmaps, oBmpImage ),;
      ILAddMasked( ::hImageList, If( oBmpImage != nil, oBmpImage:hBitmap, 0 ),;
                   nClrMask )

   METHOD End()

   METHOD SetBkColor( nColor ) INLINE ILSetBkColor( ::hImageList, nColor )
   METHOD Draw( hDC, nImage, nTop, nLeft, lDisable )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nWidth, nHeight, cFileName ) CLASS TImageList

   DEFAULT nWidth := 16, nHeight := 16

   ::nWidth := nWidth
   ::nHeight := nHeight

   if !file( cFileName )
      ::hImageList = ILCreate( nWidth, nHeight )
   else
      ::hImageList := ReadImageList( cFileName, nWidth, 10, rgb(255,0,255) )
   endif
   ::aBitmaps   = {}

return Self

//----------------------------------------------------------------------------//

METHOD AddIcon( oIcon ) CLASS TImageList

   local oIco

   if ValType( oIcon ) == "C"
      if File( "oIcon" )
         DEFINE ICON oIco FILENAME oIcon
      else
         DEFINE ICON oIco RESOURCE oIcon
      endif
   else
      oIco = oIcon
   endif

return ILAddIcon( ::hImageList, oIco:hIcon )

//----------------------------------------------------------------------------//

METHOD End() CLASS TImageList

   local n

   ILDestroy( ::hImageList )

   for n = 1 to Len( ::aBitmaps )
      ::aBitmaps[ n ]:End()
   next

   ::aBitmaps = {}

return nil


***********************************************************************************************************
    METHOD Draw( hDC, nImage, nTop, nLeft, lDisable ) CLASS TImageList
***********************************************************************************************************

ImageList_Draw( ::hImageList, nImage, hDC, nLeft, nTop, 0 )

return nil






//----------------------------------------------------------------------------//


#pragma BEGINDUMP
#include <windows.h>
#include <hbapi.h>
#include <commctrl.h>


HB_FUNC( READIMAGELIST )
{

   hb_retnl( (long) ImageList_LoadImage(  NULL,
                                    hb_parc(1),
                                    hb_parni(2),
                                    hb_parni(3),
                          (COLORREF)hb_parnl(4),
                      IMAGE_BITMAP, LR_LOADFROMFILE | LR_CREATEDIBSECTION ) );

}


HB_FUNC( ILCREATE )
{                                                  // ILC_COLORDDB | ILC_MASK
   hb_retnl( ( LONG ) ImageList_Create( hb_parnl( 1 ), hb_parnl( 2 ),
           ILC_COLORDDB | ILC_MASK, 0, 50 ) );
}


HB_FUNC( IMAGELIST_DRAW )
{
   hb_retl( ImageList_Draw((HIMAGELIST) hb_parnl( 1 ), hb_parni(2)    ,
                           (HDC) hb_parnl(3), hb_parni(4), hb_parni(5),
                           (UINT) hb_parni(6)))                       ;

}

#pragma ENDDUMP
