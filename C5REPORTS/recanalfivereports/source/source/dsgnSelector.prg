#include "fivewin.ch"
#include "Constant.ch"

#define COLOR_WINDOW              5
#define COLOR_WINDOWTEXT          8
#define COLOR_BTNFACE            15
#define COLOR_BTNSHADOW          16

#define PI   3.14159265359
#define DEG  PI / 180


CLASS TDsgnSelector FROM TShape

      DATA   nOrigin
      DATA   nLast

      DATA   nRow, nCol, nPos
      DATA   nArc, nRadius
      DATA   nClrBtn, nClrMarks

      DATA   bPos

      DATA   nMin, nMax

      DATA   nMarks, lExact
      DATA   aMarks

      METHOD NewShape   ( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CONSTRUCTOR

      METHOD Default()

      METHOD Paint( hDC )
      METHOD ShowFocus( lFocused )
      METHOD Position( nPos, nInit, nDeviation )


ENDCLASS

*********************************************************************************************************
   METHOD NewShape( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnSelector
*********************************************************************************************************

 local nAngle1 := 0, nAngle2 := 360, ;
       nMin := 0, nMax := 10, lExact := .f., nMarks := 0


  ::hWnd := 0

  super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::nOrigin = MIN( MAX( nAngle1, 0 ), 360 ) * DEG
   ::nLast   = MIN( MAX( nAngle2, 0 ), 360 ) * DEG

   ::nMin   = nMin
   ::nMax   = nMax
   ::lExact = If( nMarks > 1, lExact, .f. )
   ::nMarks = nMarks

  ::cObjName         := ::GetObjName()
  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

  ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }

  ::Default()


return self

************************************************************************************************************
   METHOD Default() CLASS TDsgnSelector
************************************************************************************************************

    local nVal

   local aRect := ::GetClientRect( ::hWnd )

   local n, nMark, nMarks := ::nMarks * 2
   local nLap

   //if ValType( Eval( ::bSetGet ) ) == "U"
      nVal := ::nMin
   //else
   //   if ::nMin > ::nMax
   //      nVal := Max( Min( Eval( ::bSetGet ), ::nMin ), ::nMax )
   //   else
   //      nVal := Min( Max( Eval( ::bSetGet ), ::nMin ), ::nMax )
   //   endif
   //endif

   //Eval( ::bSetGet, nVal )

   ::nRow = Int( aRect[ 3 ] / 2 )
   ::nCol = Int( aRect[ 4 ] / 2 )

   ::nRadius = Min( ::nRow, ::nCol ) - 12

   ::nArc  := If( ::nOrigin >= ::nLast, ::nLast + ( 2 * PI - ::nOrigin ), ;
                  ::nLast - ::nOrigin)
   ::nPos  := ::nGetPos( nVal )

   nMark := ::nOrigin

   ::aMarks := ARRAY( nMarks )

   if nMarks / 2 - 1 == 0
     nLap := ::nArc
   else
     nLap := ::nArc / ( nMarks / 2 - 1 )
   endif

   for n := 1 to nMarks step 2
       ::aMarks[ n ]     := ::nRow - Cos( nMark ) * ( ::nRadius + 2 )
       ::aMarks[ n + 1 ] := ::nCol + Sin( nMark ) * ( ::nRadius + 2 )
       nMark += nLap
   next

   // ::nClrBtn   := GetSysColor( COLOR_BTNFACE )
   ::nClrMarks := ::nClrText

return nil


METHOD Paint( hDCMem ) CLASS TDsgnSelector

   local hDC := 0
   local hFont

   local nRow := Round( ::nRow - ::nRadius * Cos( ::nPos ), 0)
   local nCol := Round( ::nCol + ::nRadius * Sin( ::nPos ), 0)
   local nX   := 0
   local nY   := 0

   if hDCMem == nil
      hDC := GetDC( ::hWnd )
      hDCMem := hDC
   else
      nX := ::nLeft
      nY := ::nTop
   endif

   DrawSelector ( hDCMem, ::nRow+nY, ::nCol+nX, ::nRadius, nRow+nY, nCol+nX, ;
                  ::aMarks, ::nClrBtn, ::nClrMarks )

   If !::lCaptured
      ::ShowFocus( hDCMem, ::lFocused )
   endif


   if hDC != 0
      ReleaseDC( ::hWnd, hDC )
   else
      if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
         ::DotsSelect( hDCMem )
      endif
   endif


return Super:Paint()

****************************************************************************************************************************
  METHOD ShowFocus( hDC, lFocused ) CLASS TDsgnSelector
****************************************************************************************************************************



   local aRect := ::GetClientRect( ::hWnd )

   local hOldPen, hPen := CreatePen( PS_SOLID, 1, ::nClrPane )

   //hDC   := GetDC( ::hWnd )

   hOldPen = SelectObject( hDC, hPen )

   MoveTo( hDC, 0, 0 )
   LineTo( hDC, 0, aRect[ 3 ] - 1, hPen )
   LineTo( hDC, aRect[ 4 ] - 1, aRect[ 3 ] - 1 , hPen )
   LineTo( hDC, aRect[ 4 ] - 1 , 0, hPen )
   LineTo( hDC, 0, 0, hPen )

   if lFocused
      DrawFocusRect( hDC, 0, 0, aRect[ 3 ], aRect[ 4 ] )
   endif

   SelectObject( hDC, hOldPen )

   //ReleaseDC( ::hWnd, hDC )

   DeleteObject( hPen );

return nil

****************************************************************************************************************************
  METHOD Position( nPos, nInit, nDeviation ) CLASS TDsgnSelector
****************************************************************************************************************************

   static nDev := 0
   static nOldPos


   if nPos = nil

      if nInit = nil
         nPos := nOldPos
      else
         nPos := nOldPos := ::nPos // ::nGetPos( Eval( ::bSetGet ) )
         nDev := if( nDeviation != nil, nDeviation, nPos - nInit )
      endif

   else

      nPos := AdjPos( nPos += nDev )

      nPos := EvalPos( nPos, ::nOrigin, ::nLast )

   endif

   ::nPos := nPos

   ::Refresh()

   nOldPos := nPos



return nil
static function EvalPos( nPos, nInit, nLast )
  static nLimit

  if nInit > nLast

     if nPos < nInit .and. nPos > nLast
        if nLimit = nil
           nPos := nLimit := if( nInit - nPos < nPos - nLast, nInit, nLast )
        else
           nPos := nLimit
        endif
     else
        nLimit := nil
     endif

  else

     if nPos < nInit .or. nPos > nLast
        if nLimit = nil
           nPos := nLimit := if( nPos < nInit, nInit, nLast )
        else
           nPos := nLimit
        endif
     else
        nLimit := nil
     endif

  endif

return nPos


static function AdjPos( nPos )
return  nPos + if( nPos < 0, 2 * PI, if( nPos > 2 * PI, -2 * PI, 0 ) )

