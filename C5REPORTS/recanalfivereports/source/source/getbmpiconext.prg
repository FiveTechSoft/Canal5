HB_FUNC( GETBMPICONEXT )
{

	SHFILEINFO    sfi;
   HDC dcMem;
   HDC hDC;
   HBITMAP bmpMem, hOldBmp;

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

   DrawIconEx( dcMem, 0, 0, sfi.hIcon, 16, 16, NULL, NULL, DI_NORMAL );
   DestroyIcon( sfi.hIcon );
   SelectObject( dcMem, hOldBmp );
   DeleteDC( dcMem );
   DeleteDC( hDC );
	hb_retnl( (LONG) bmpMem );

}
