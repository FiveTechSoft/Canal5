#include "fivewin.ch"


#define HORZSIZE            4
#define VERTSIZE            6
#define HORZRES             8
#define VERTRES            10
#define LOGPIXELSX         88
#define LOGPIXELSY         90



CLASS TC5Rule FROM TControl

      DATA oLinked
      DATA nOffset    AS NUMERIC INIT 0
      DATA lVertical  AS LOGICAL INIT .F.
      DATA nGuia      AS NUMERIC INIT 0
      DATA hBmpMem
      DATA nInit      AS NUMERIC INIT 0
      DATA aGuias     AS ARRAY   INIT {}

      CLASSDATA lRegistered AS LOGICAL

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrText, nClrPane, lVertical, oLinked ) CONSTRUCTOR
      METHOD Destroy()    INLINE DeleteObject(::hBmpMem), super:Destroy()
      METHOD Display()    INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Paint()
      METHOD HandleEvent( nMsg, nWParam, nLParam )
      METHOD MakeRule()
      METHOD LButtonDown ( nRow, nCol )
      METHOD MouseMove( nRow, nCol )
      METHOD GetCoords( nGuia )
      METHOD Resize()   INLINE ::MakeRule()

ENDCLASS

******************************************************************************************************************
      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nClrText, nClrPane, lVertical, oLinked ) CLASS TC5Rule
******************************************************************************************************************

  if nClrText  == nil ; nClrText     := CLR_BLACK ; endif
  if nClrPane  == nil ; nClrpane     := CLR_WHITE ; endif
  if lVertical == nil ; lVertical    := .t.       ; endif

  ::oWnd       := oWnd
  ::nTop       := nTop
  ::nLeft      := nLeft
  ::nBottom    := ::nTop + nHeight
  ::nRight     := ::nLeft + nWidth
  ::nClrText   := nClrText
  ::nClrPane   := nClrPane
  ::oLinked    := oLinked
  ::lVertical  := lVertical

  if ::lVertical
     ::nInit := ::oLinked:aCoords[1]
  else
     ::nInit := ::oLinked:aCoords[2]
  endif

  ::nStyle  := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

  ::nId     := ::GetNewId()
  ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )

  if ! Empty( oWnd:hWnd )
     ::Create()
     ::lVisible = .t.
     oWnd:AddControl( Self )
  else
     oWnd:DefControl( Self )
     ::lVisible  = .f.
  endif

return self


******************************************************************************************************************
      METHOD Paint() CLASS TC5Rule
******************************************************************************************************************
local rc := GetClientRect(::hWnd)
local n, nLen
local oFont, hOldFont
local nT,nL


if ::hBmpMem == nil
   ::MakeRule()
endif

DrawBitmap( ::hDC, ::hBmpMem, 0, 0 )

if ::lVertical

   Moveto( ::hDC, rc[2], ::nGuia+::nOffset )
   Lineto( ::hDC, rc[4], ::nGuia+::nOffset )

else

   Moveto( ::hDC, ::nGuia+::nOffset , rc[1])
   Lineto( ::hDC, ::nGuia+::nOffset , rc[3])

endif

nLen := len( ::aGuias )
if nLen > 0
   oFont := TFont():New( "Marlett", 0, -18, .f., .f.,0, 0, 0, .f., .f.,.f., 1,0,0,0, ,0 )
   hOldFont := SelectObject( ::hDC, oFont:hFont )
   SetBkMode(::hDC, 1 )
   SetTextColor(::hDC, CLR_HBLUE )
   if ::lVertical
      For n := 1 to nLen
          nT := (::oLinked:aCoords[1]+vMM2Pix(::aGuias[n]))*::oLinked:nZoom/100
          nL := 18
          TextOut( ::hDC, nT-8 , nL, chr(0x34))
      next
   else
      For n := 1 to nLen
          nT := 18
          nL := (::oLinked:aCoords[2]+hMM2Pix(::aGuias[n]))*::oLinked:nZoom/100
          TextOut( ::hDC, nT, nL-8, chr(0x36))
      next
   endif
   SelectObject( ::hDC, hOldFont )
   oFont:End()

endif


return 0

***********************************************************************************************************************************
      METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TC5Rule
***********************************************************************************************************************************

do case
   case nMsg == 20
        return 1
endcase

return super:HandleEvent( nMsg, nWParam, nLParam )



***********************************************************************************************************************************
      METHOD MakeRule() CLASS TC5Rule
***********************************************************************************************************************************
local hDC      := CreateDC( "DISPLAY",0,0,0 )
local hDCMem
local hOldBmp
local rc       := GetClientRect(::hWnd)
local n
local nCount   := -1
local nCount2  := 0
local nCount3  := 0
local hres     := GetDeviceCaps(hdc,HORZRES)                  // {display width in pixels}
local vres     := GetDeviceCaps(hdc,VERTRES)                  // {display height in pixels}
local hsiz     := GetDeviceCaps(hdc,HORZSIZE)                 // {display width in mm}
local vsiz     := GetDeviceCaps(hdc,VERTSIZE)                 // {display height in mm}
local HPixByMM := (hres/hsiz ) * ::oLinked:nZoom/100          // pixels hay en un mm horizontal
local VPixByMM := (vres/vsiz ) * ::oLinked:nZoom/100          // pixels hay en un mm vertical
local oFont, hOldFont
local nW := rc[4]-rc[2]
local nH := rc[3]-rc[1]
local nVIni := - ::oLinked:aCoords[1] * ::oLinked:nZoom/100
local nHIni := - ::oLinked:aCoords[2] * ::oLinked:nZoom/100
local nT, nL
local nMM

if ::hBmpMem != nil
   DeleteObject( ::hBmpMem )
endif

hDCMem    := CreateCompatibleDC( hDC )
::hBmpMem := CreateCompatibleBitmap( hDC, nW, nH )
hOldBmp   := SelectObject( hDCMem, ::hBmpMem )

if ::lVertical
   HorizontalGradient( hDCMem, rc, ::nClrPane , CLR_WHITE )
else
   VerticalGradient  ( hDCMem, rc , CLR_WHITE, ::nClrPane )
endif
if ::nGuia < 0
   ::nGuia := 3
endif

SetBkMode( hDCMem, 1 )

DEFINE FONT oFont NAME "Tahoma" SIZE 0,-10 //NESCAPEMENT 900

if ::lVertical

   nMM     := nVIni/VPixByMM
   nCount  := -1
   nCount2 := (((::nInit-::oLinked:aCoords[1])* ::oLinked:nZoom/100)/VPixByMM)%10 -1
   nCount3 := (((::nInit-::oLinked:aCoords[1])* ::oLinked:nZoom/100)/VPixByMM)%5  -1

   for n := nVIni to nH + nVIni step VPixByMM

       nCount  ++
       nCount2 ++
       nCount3 ++
       nMM++

       if ::oLinked:nZoom >= 60 .or. ( nCount2 >= 10 )
          Moveto( hDCMem,                           0 , nCount * VPixByMM )
          Lineto( hDCMem, 10 + if( nCount3 >= 5, 5, 0), nCount * VPixByMM )
       endif

       if nCount3 >= 5; nCount3 := 0; endif

       if nCount2 >= 10
          nCount2  := 0
          hOldFont := SelectObject( hDCMem, oFont:hFont )
          TextOut( hDCMem, nCount * VPixByMM, 15, alltrim(str(nMM/10,0 )))
          SelectObject( hDCMem, hOldFont )
       endif

   next
   Moveto( hDCMem,       0, 0 )
   Lineto( hDCMem,       0, rc[3] )
   Moveto( hDCMem, rc[4]-1, 0 )
   Lineto( hDCMem, rc[4]-1, rc[3] )

else

   nMM     := nHIni/HPixByMM
   nCount  := -1
   nCount2 := (((::nInit-::oLinked:aCoords[2])* ::oLinked:nZoom/100)/HPixByMM)%10
   nCount3 := (((::nInit-::oLinked:aCoords[2])* ::oLinked:nZoom/100)/HPixByMM)%5

   for n := nHIni to nW+nHIni step HPixByMM

       nCount  ++
       nCount2 ++
       nCount3 ++
       nMM++

       if ::oLinked:nZoom >= 60 .or. ( nCount2 >= 10 )
          Moveto( hDCMem, nCount * HPixByMM,                           0  )
          Lineto( hDCMem, nCount * HPixByMM, 10 + if( nCount3 >= 5, 5, 0) )
       endif

       if nCount3 >= 5; nCount3 := 0; endif

       if nCount2 >= 10
          nCount2  := 0
          hOldFont := SelectObject( hDCMem, oFont:hFont )
          TextOut( hDCMem, 15, nCount * HPixByMM, alltrim(str(nMM/10,0 )))
          SelectObject( hDCMem, hOldFont )
       endif

   next
   Moveto( hDCMem,     0,     0 )
   Lineto( hDCMem, rc[4],     0 )
   Moveto( hDCMem,     0, rc[3]-1 )
   Lineto( hDCMem, rc[4], rc[3]-1 )
endif

SelectObject( hDCMem, hOldBmp )
DeleteDC( hDC )
DeleteDC( hDCMem )


oFont:End()

return 0

***********************************************************************************************************************************
  METHOD LButtonDown ( nRow, nCol ) CLASS TC5Rule
***********************************************************************************************************************************
local nMM
local n
local nLen := len( ::aGuias )

//nRow := nRow * 100 / ::oLinked:nZoom
//nCol := nCol * 100 / ::oLinked:nZoom

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::GetCoords(n))
       adel( ::aGuias, n )
       asize( ::aGuias, nLen-1)
       ::Refresh()
       ::oLinked:Refresh()
       return 0
    endif
next


if ::lVertical
   nMM     := vPix2MM(nRow*::oLinked:nInvRatio) - vPix2MM(::oLinked:aCoords[1] )
else
   nMM     := hPix2MM(nCol*::oLinked:nInvRatio) - hPix2MM(::oLinked:aCoords[2] )
endif


aadd( ::aGuias, nMM )

::Refresh()
::oLinked:Refresh()

Return 0

***********************************************************************************************************************************
   METHOD MouseMove( nRow, nCol ) CLASS TC5Rule
***********************************************************************************************************************************
local n
local nLen := len( ::aGuias )
local nFind := 0

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::GetCoords( n ) )
       nFind := n
       exit
    endif
next

if nFind == 0
   CursorArrow()
else
   CursorHand()
endif

return 0

***********************************************************************************************************************************
  METHOD GetCoords( nGuia ) CLASS TC5Rule
***********************************************************************************************************************************
local n
local nT, nL

if nGuia > len( ::aGuias )
   return {0,0,0,0}
endif

if ::lVertical
  nT := (::oLinked:aCoords[1]+vMM2Pix(::aGuias[nGuia]))*::oLinked:nZoom/100
  nL := 18
else
  nT := 18
  nL := (::oLinked:aCoords[2]+hMM2Pix(::aGuias[nGuia]))*::oLinked:nZoom/100
endif

return {nT,nL,nT+10,nL+10}
