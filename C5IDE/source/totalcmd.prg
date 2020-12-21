#include "fivewin.ch"
#include "splitter.ch"
#include "Struct.ch"
#include "wnddsgn.ch"

#define CBM_INIT 4 //&& should move to prg header

#define DIB_RGB_COLORS 0 //&& should move to prg header
#define COLORONCOLOR                 3


#define LB_GETTEXT           393 //   0x0189
#define INTERNET_SERVICE_FTP    1
#define FTP_PORT               21

#define GW_HWNDFIRST          0
#define GW_HWNDLAST           1
#define GW_HWNDNEXT           2
#define GWL_STYLE           -16


#define CS_DBLCLKS            8
#define COLOR_ACTIVECAPTION   2
#define COLOR_WINDOW          5
#define COLOR_CAPTIONTEXT     9
#define COLOR_HIGHLIGHT      13
#define COLOR_HIGHLIGHTTEXT  14
#define COLOR_BTNFACE        15
#define COLOR_BTNTEXT        18

#define WM_SETFONT           48  // 0x30

// Lines Styles
#define LINES_NONE            0
#define LINES_BLACK           1
#define LINES_GRAY            2
#define LINES_3D              3
#define LINES_DOTED           4
#define LINES_V_BLACK         5
#define LINES_V_GRAY          6
#define LINES_H_BLACK         7
#define LINES_H_GRAY          8

#define SRCCOPY 13369376
#define SM_CYHSCROLL          3
#define TA_LEFT               0
#define TA_RIGHT              2

#define ETO_OPAQUE            2
#define ETO_CLIPPED           4


static hWinINet
static aSorts := { 1,0,0,0 }
static nSort := 1




function TotalCmd( oWnd )
//local oWnd
local oLbx, oLbx2, oSplit
local cVar := ""
local aItems1 := {}
local aItems2 := {}
local aAux
local aFiles1[50]
local aFiles2 := {}
local n2
local cName
local oFont
local oBar
local cServer   := space( 30 )
local cUser     := space( 30 )
local cPassword := space( 30 )
local cPath     := space( 30 )

local oDirL1, oDirL2

//oWnd:oBrush:End()

DEFINE FONT oFont NAME "Microsoft Sans Serif" SIZE 0,-11 //BOLD


//DEFINE DIALOG oWnd FROM 0, 0 TO 10, 10 PIXEL OF oVista STYLE nOr(WS_POPUP, WS_CHILD )
       DEFINE BUTTONBAR oBar _3D SIZE 32, 32 OF oWnd

           DEFINE BUTTON OF oBar
           DEFINE BUTTON OF oBar

    oWnd:SetFont( oFont )


    oDirL1 := TDirList():New( 32, 0, 500, 500, oWnd )
    oDirL2 := TDirList():New(32,505,500, 500, oWnd )

    @ 32, 500  SPLITTER oSplit ;
              VERTICAL ;
              PREVIOUS CONTROLS oDirL1:oLbx ;
              HINDS CONTROLS oDirL2:oLbx ;
              LEFT MARGIN 100 ;
              RIGHT MARGIN 140 ;
              SIZE 5, 1600  PIXEL ;
              OF oWnd ;
              _3DLOOK ;
              UPDATE

oWnd:bResized := {||Size(oDirL1:oLbx,oDirL2:oLbx,oSplit )}


//ACTIVATE WINDOW oWnd ON RESIZE Size( oDirL1:oLbx, oDirL2:oLbx, oSplit ) MAXIMIZED


return oWnd





function Size( oLbx, oLbx2, oSplit )
local aRect := GetClientRect( oLbx:oWnd:hWnd )

oLbx2:nWidth := aRect[4]-oSplit:nRight
oLbx:nHeight := aRect[3]-32
oLbx2:nHeight := aRect[3]-32


return nil





function conectar( oLbx, sServer, sUser, sPassword, cPath )
local oInternet := TInternet():New()
local oFtp, aAux, aFiles := {}
local n

oFtp := TFtp():New( sServer, oInternet, sUser, sPassword )

if right( cPath, 1 ) != "/"
   cPath += "/"
endif

aAux := oFtp:Directory( "/" + cPath  )
for n := 1 to len( aAux )
    aadd( aFiles, aAux[n,1] )
next

oLbx:SetItems( aFiles )

oInternet:End()


RETURN .T.



function FindIniNWord( cText, nPalabra )
local nLen
local n := 0
local nWord := 1
local cChar
local lEspacio := .f.
local nEn := 0

nLen := len( cText )

for n := 1 to nLen

    cChar := substr( cText, n, 1 )

    if cChar == " "
       lEspacio := .t.
    else
       if lEspacio
          nWord++
          lEspacio := .f.
          if nWord == nPalabra
             nEn := n
             exit
          endif
       endif
    endif
next

return nEn


function SubstrFrom( cText, nWord, nLen )
local nEn

nEn := FindIniNWord( cText, nWord )

DEFAULT nLen := len( cText ) - nEn + 1

return Substr( cText, nEn, nLen )

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "objbase.h"
#include "Rpcdce.h"


HB_FUNC( CREATEGUID )
{
 GUID guid;
 unsigned char* str;
 CoCreateGuid(&guid);
 UuidToString((UUID*)&guid, &str);

 hb_retc( (char*) str );
}


#pragma ENDDUMP




//----------------------------------------------------------------------------//

CLASS TWBrowse2 FROM TWBrowse


      CLASSDATA lRegistered AS LOGICAL

      DATA oDirList

      DATA nSort AS NUMERIC INIT 1
      METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, aColSizes, oWnd,;
            cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
            oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
            lPixel, bWhen, lDesign, bValid, bLClick, aActions ) CONSTRUCTOR
      METHOD Default()

      METHOD DrawLine( nRow ) INLINE ;
                  wBrwLine( ::hWnd, ::hDC, If( nRow == nil, ::nRowPos, nRow ), ;
                  Eval( ::bLine, Self ), ::GetColSizes(), ::nColPos,;
                  ::nClrText, ::nClrPane,;
                  If( ::oFont != nil, ::oFont:hFont, 0 ),;
                  ValType( ::aColSizes ) == "B", ::aJustify, nil, ::nLineStyle,,, ::oVScroll,;
                  ::bLogicLen  )
      METHOD DrawSelect()
      METHOD Paint()
      METHOD MouseMove() VIRTUAL
ENDCLASS

METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, aColSizes, oWnd,;
            cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
            oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
            lPixel, bWhen, lDesign, bValid, bLClick, aActions ) CLASS TWBrowse2

   local o := Self

   DEFAULT nRow := 0, nCol := 0, nHeigth := 100, nWidth := 100,;
           oWnd := GetWndDefault(), oFont := oWnd:oFont, nClrFore := CLR_BLACK,;
           nClrBack := CLR_WHITE,; //GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., cAlias := Alias(), lPixel := .f.,;
           lDesign  := .f.

   #ifdef __XPP__
      DEFAULT cAlias := ""
   #endif

   ::cCaption   = ""
   ::nTop       = nRow //* If( lPixel, 1, BRSE_CHARPIX_H ) // 14
   ::nLeft      = nCol //* If( lPixel, 1, BRSE_CHARPIX_W )  //8
   ::nBottom    = ::nTop + nHeigth - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::oWnd       = oWnd
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::nStyle     = nOr( WS_CHILD, WS_VSCROLL, WS_HSCROLL, WS_BORDER, WS_VISIBLE, WS_TABSTOP,;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        = ::GetNewId()
   ::cAlias     = cAlias
   ::bLine      = bLine
   ::lAutoEdit  = .f.
   ::lAutoSkip  = .f.
   ::lIconView  = .f.
   ::lCellStyle = .f.
   ::nIconPos   = 0
   ::SetFilter( cField, uVal1, uVal2 )

   //::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nLen       = 0
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor

   //::nLineStyle    := LINES_3D
   ::nLineStyle    := LINES_GRAY
   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := GetSysColor( COLOR_BTNTEXT )
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := CLR_WHITE

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::nVScrollPos   = 0

   DEFINE FONT oFont NAME "Tahoma" SIZE 0, -13

//   ::SetColor( nClrFore, nClrBack )
   ::SetColor( 0, CLR_WHITE )

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      if oFont != nil
         ::SetFont( oFont )
      endif
      //::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      ::oFont := oFont
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif

   if lDesign
      ::CheckDots()
   endif


return Self

METHOD DrawSelect() CLASS TWBrowse2

   if ::lCellStyle
      ::DrawLine()
      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle,;
                ::nColAct, ::lFocused, ::oVScroll, ::bLogicLen )
   else
      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle, nil,;
                ::lFocused, ::oVScroll, ::bLogicLen )
   endif

return nil


METHOD Default() CLASS TWBrowse2

   local n, aFields
   local cAlias := Alias()
   local nElements, nTotal := 0

   DEFAULT ::aHeaders := {}, ::aColSizes := {}


   DEFAULT nElements := Len( Eval( ::bLine, Self ) )

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_VSCROLL ) .or. ;
      GetClassName( ::hWnd ) == "ListBox"
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
      ::nLen := Eval( ::bLogicLen, Self )
      ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )
      ::VSetRange()
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_HSCROLL )
      if ::Cargo == nil // it is not a tree
         DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
            RANGE 1, Len( ::GetColSizes() )
         AEval( ::GetColSizes(), { | nSize | nTotal += nSize } )
         ::oHScroll:SetPage( nTotal / ::nWidth() )
      endif
   endif

   if ::uValue1 != nil
      Eval( ::bGoTop, Self )
   endif
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

METHOD Paint() CLASS TWBrowse2

   local n := 1, nSkipped := 1, nLines
   local aInfo := ::DispBegin()

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   if ::lIconView
      ::DrawIcons()
      return 0
   endif

   if ::nRowPos == 1 .and. ! Empty( ::cAlias ) .and. ;
      Upper( ::cAlias ) != "ARRAY"
      if ! ( ::cAlias )->( EoF() )
         ( ::cAlias )->( DbSkip( -1 ) )
         if ! ( ::cAlias )->( BoF() )
            ( ::cAlias )->( DbSkip() )
         endif
      endif
   endif

   WBrwLine( ::hWnd, ::hDC, 0, ::aHeaders, ::GetColSizes(),;
               ::nColPos, ::nClrForeHead, ::nClrBackHead,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                  ::aJustify, nil, ::nLineStyle,,, ::oVScroll, ::bLogicLen )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) > 0

      ::Skip( 1 - ::nRowPos )

      #ifndef __CLIPPER__
         nLines = ::nRowCount()
         while n <= nLines .and. nSkipped == 1
            ::DrawLine( n )
            nSkipped = ::Skip( 1 )
            if nSkipped == 1
               n++
            endif
         end
         ::Skip( ::nRowPos - n )
      #else
          // WBrwPane() returns the nº of visible rows
          // WBrwPane recieves at aColSizes the Array or a Block
          // to get dinamically the Sizes !!!
         ::Skip( ::nRowPos - wBrwPane( ::hWnd, ::hDC, Self, ::bLine,;
              ::aColSizes, ::nColPos, ::nClrText, ::nClrPane,;
              If( ::oFont != nil, ::oFont:hFont, 0 ), ::aJustify, ::nLineStyle ) )
      #endif

      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif

      ::DrawSelect()
   endif

   if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
      ::lHitTop    = ( ::cAlias )->( BoF() )
      ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

   ::DispEnd( aInfo )

return 0



static function wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen )
   local nTxtHeight, hOldFont
   local nColStart  := -1
   local nWidth     := WndWidth( hWnd ) - If( oVScroll != nil .and. ;
                       Eval( bLogicLen ) > 1,;
                       GetSysMetrics( SM_CYHSCROLL ) + 3, 0 )
   local nRow := nRowPos, nTop, nBottom, nLeft, nRight, n
   local lReleaseDC := .f.
   local nForeColor, nBackColor
   local  hPen, hOld, hBrush

   DEFAULT lTree := .f.

   if Empty( hDC )
      hDC = GetDC( hWnd )
      lReleaseDC = .t.
   endif

   hOldFont   = SelectObject( hDC, hFont )
   nTxtHeight = GetTextHeight( hWnd, hDC ) + 1

   nTop    = nTxtHeight * nRow
   nBottom = nTop + nTxtHeight - 1

   SetTextColor( hDC, If( ValType( nClrText ) == "B",;
                 nClrText := Eval( nClrText ), nClrText ) )
   SetBkColor( hDC, If( ValType( nClrPane ) == "B",;
               nClrPane := Eval( nClrPane ), nClrPane ) )

   for n := nColPos to Len( aValues )
      nLeft   = nColStart + 1
      nRight  = Min( nColStart := ( nLeft + aColSizes[ n ] - 1 ), nWidth )
      if nLeft > nWidth
         exit
      endif
      if n == Len( aValues )
         nRight = nWidth
      endif

      if ValType( aValues[ n ] ) == "N"
         hBrush = CreateSolidBrush( GetBkColor( hDC ) )
         hOld   = SelectObject( hBrush )
         FillRect( hDC, { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                   LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. nLineStyle == ;
                   LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, hBrush )
         DrawMasked( hDC, aValues[ n ], nTop, nLeft + 0 )
         DeleteObject( aValues[n] )
         SelectObject( hOld )
         DeleteObject( hBrush )
      else
         if nColAct != nil .and. n == nColAct
            SetTextColor( hDC, nClrText )
            SetBkColor( hDC, nClrPane )
         else
            if nRowPos != 0
               SetTextColor( hDC, If( nColAct != nil, GetSysColor( COLOR_BTNTEXT ),;
                             nClrText ) )
               SetBkColor( hDC, If( nRowPos == 0, GetSysColor( COLOR_BTNFACE ),;
                       If( nColAct == nil, nClrPane, GetSysColor( COLOR_WINDOW ) ) ) )
            endif
         endif
         if ! lTree
            if nRowPos == 0 .and. IsAppThemed()

               DrawHeader( hWnd, hDC, nTop - 1, nLeft, nBottom, nRight, aValues[ n ] )
            else
            if aJustify != nil .and. aJustify[ n ]
               SetTextAlign( hDC, TA_RIGHT )
               ExtTextOut( hDC, nTop, nRight - 2,;
                           { nTop, nLeft, nBottom, nRight + If( (nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) },; //socs + If((nLineStyle == LINES_NONE .OR. nLineStyle == LINES_H_GRAY .OR. nLineStyle == LINES_H_BLACK) .AND. nRowPos#0 ,2,0),;
                           cValToChar( aValues[ n ] ) )
            else
               SetTextAlign( hDC, TA_LEFT )
               ExtTextOut( hDC, nTop, nLeft + 2,;
                           { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                        nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) },;
                           cValToChar( aValues[ n ] ) )
            endif
            endif
         else
            DrawText( hDC, cValToChar( aValues[ n ] ),;
                      { nTop, nLeft + 4, nBottom, nRight } )
         endif
      endif
      if ! lTree
         if nRowPos == 0
            if ! IsAppThemed()
               WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
               WndBoxRaised( hDC, nTop, nLeft, nBottom - 1, nRight - 1 )
            endif
         else
            do case
               case nLineStyle == LINES_BLACK
                    WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )

               case nLineStyle == LINES_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nTop - 2 )
                    LineTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_3D
                    WndBoxRaised( hDC, nTop, nLeft, nBottom, nRight )

               case nLineStyle == LINES_DOTED
                    SetTextColor( hDC, CLR_BLACK )
                    FrameDot( hDC, nTop - 1, nLeft - 1, nBottom, nRight )

               case nLineStyle == LINES_V_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 1, nTop - 2 )
                    LineTo( hDC, nLeft - 1, nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_V_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 1, nTop - 2 )
                    LineTo( hDC, nLeft - 1, nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    MoveTo( hDC, nLeft - 2, nBottom )
                    LineTo( hDC, nRight , nBottom )
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )
            endcase
         endif
      endif

      if nColPos > nWidth
         exit
      endif
   next

   SelectObject( hDC, hOldFont )

   if lReleaseDC
      ReleaseDC( hWnd, hDC )
   endif

return nil



CLASS TDirList

      DATA aAux
      DATA aFtPs
      DATA aItems
      DATA bAction
      DATA bChange
      DATA cMask
      DATA cPath
      DATA lActionDef
      DATA lCarpetas
      DATA lDrives
      DATA lFTPs
      DATA lFicheros
      DATA lInfoExtend
      DATA nIniName
      DATA oLbx

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lDrives, lCarpetas, lFicheros, lFTPs, cMask, lActionDef, bAction ) CONSTRUCTOR


      METHOD cFullName(n) INLINE ::cPath + ::cFile()
      METHOD cFile(n)
      METHOD cName(n)
      METHOD cExt(n)
      METHOD cSize(n)
      METHOD cDate(n)
      METHOD cTime(n)
      METHOD cAttrib(n)

      METHOD Sort( nCol )
      METHOD Reload()
      METHOD Pulsa( nKey )
      METHOD MiDir( cPath )
      METHOD IniName( lIsDir, cLine )
      METHOD GetBmpDrive( cDrive )
      METHOD AdjTop()
      METHOD AdjClient()


ENDCLASS

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lDrives, lCarpetas, lFicheros, lInfoExtend, lFTPs, cMask, lActionDef, bAction ) CLASS TDirList

   local o := self

   DEFAULT lDrives       := .t.
   DEFAULT lCarpetas     := .t.
   DEFAULT lFicheros     := .t.
   DEFAULT lInfoExtend   := .f.
   DEFAULT lFTPs         := .t.
   DEFAULT lActionDef    := .t.



    ::aAux          := {}
    ::cPath         := "G:\"
    ::aItems        := {}
    ::nIniName      := 0
    ::lDrives       := lDrives
    ::lCarpetas     := lCarpetas
    ::lFicheros     := lFicheros
    ::lInfoExtend   := lInfoExtend
    ::lFTPs         := lFtps
    ::lActionDef    := lActionDef
    ::bAction       := bAction

    ::aFTPS       := {} // {"ftp.arrakis.es","canal_five","gomez2"},;
                        // {"ftp.canalfive.com","paco","iborra"}}

    ::oLbx := TWBrowse2():New( nTop, nLeft, nWidth, nHeight,;
                               {|| {0,"","","","","","" } },;
                               {" ","Nombre","Tamaño","Fecha","Hora","Atributos"},;
                               {20,150,50,100,100,40},oWnd,,,,,,,,,0,12632256,,.F.,,.T.,,.F.,,,)
    ::oLbx:oDirList := self


    ::cMask := cMask

   if ::lInfoExtend
      ::oLbx:aActions := { {||.t.},{||o:Sort(1)},{||o:Sort(2)} ,{||o:Sort(3)} ,{||o:Sort(4)} }
   else
      ::oLbx:aHeaders  := {" ","Nombre"}
      ::oLbx:aColSizes := {20,150}
      ::oLbx:aActions  := { {||.t.},{||o:Sort(1)} }
   endif



    ::oLbx:nLineStyle := LINES_NONE
    ::oLbx:SetArray( ::aItems )

    ::Reload()

    ::oLbx:Default()

    ::oLbx:bLdblClick  := {|| o:Pulsa()}
    ::oLbx:bKeyDown    := {|nKey| o:Pulsa( nKey ) }
    ::oLbx:aJustify    := AFill( Array( 6 ), .F. )
    ::oLbx:aJustify[3] := .t.


return self



****************************************************************************
   METHOD GetBmpDrive( cDrive ) CLASS TDirList
****************************************************************************
local aBmpDrives := { "empty"   ,;
                      "carpeta" ,;
                      "hddisk"  ,;
                      "cdrom"   ,;
                      "netdrive",;
                      "ftp2" }

local hBmp := 0
local nType

if at( "ftp.", lower(::aItems[::oLbx:nAt,1] )) != 0
   hBmp := LoadBitmap( GetResources(), aBmpDrives[6] )
else
   if at( "D", ::aItems[::oLbx:nAt,5] ) != 0
      hBmp := LoadBitmap( GetResources(), aBmpDrives[2] )
   else
      nType := DriveType( alltrim(::aItems[::oLbx:nAt,1])  )
      if nType == 3
         hBmp := LoadBitmap( GetResources(), aBmpDrives[3] )
      else
         if nType == 4
            hBmp := LoadBitmap( GetResources(), aBmpDrives[4] )
         else
            hBmp := GetBmpIconExt(::cPath+::aItems[::oLbx:nAt,1])
         endif
      endif
   endif
endif
if hBmp == 0
   hBmp := LoadBitmap( GetResources(), aBmpDrives[1] )
endif

return hBmp

****************************************************************************
   METHOD Reload() CLASS TDirList
****************************************************************************

local cName, n
local o := self
local aDrives
local oFtp
local bFTP
local cPath := ""
LOCAL cExt

asize( ::aAux, 0         )

aDrives := aDrives()

if at( "ftp.", lower(::cPath) ) != 0

   CursorWait()

   nFTP := ascan( ::aFtps, {|x| lower(x[1]) == lower(substr(::cPath, 1, at("/",::cPath)-1 )) } )

   if nFtp != 0
      oFTP := qFTPClient():New(::aFtps[nFTp,1], 21,bFTP,,::aFtps[nFtp,2],::aFtps[nFtp,3] )
      oFTP:lPassive := .f.
      oFTP:nTimeOut := 60
      if oFTP:Connect()
         cPath := substr( ::cPath, at( "/", ::cPath ) )
         oFTP:DIR(cPath)
         oFTP:Quit()
         ::aAux := oFtp:aItems()
      else
          ? "No se pudo conectar"
      endif
   else
       ? "no se pudo conectar"
   endif
   oFTP:End()
else
   ::aAux := Directory( ::cPath + "*.*", "DA" )
endif

asize( ::aItems, 0 )

if len( ::aAux ) > 0
   for n := 1 to len( ::aAux )
       if len( ::aAux[n,1] ) == 1 .and. ::aAux[n,1] == "."
          loop
       endif
       if ::lCarpetas
          if at( "D",::aAux[n,5]) != 0
             aadd( ::aItems, { ::aAux[n,1],;
                               if( ::aAux[n,2]== 0,"",cValToChar(::aAux[n,2])),;
                               cValToChar(::aAux[n,3]),;
                               cValToChar(::aAux[n,4]),;
                               cValToChar(::aAux[n,5])} )
          endif
       endif
   next

   for n := 1 to len( ::aAux )
       if len( ::aAux[n,1] ) == 1 .and. ::aAux[n,1] == "."
          loop
       endif
       if ::lFicheros
          if at( "D",::aAux[n,5]) == 0
             if ::cMask != nil
                cExt := lower(cFileExt(::aAux[n,1]))
                if empty( cExt ) .or. At( "." + cExt , lower(::cMask ) ) == 0
                   loop
                endif
             endif
             aadd( ::aItems, { ::aAux[n,1],;
                               if( ::aAux[n,2]== 0,"",cValToChar(::aAux[n,2])),;
                               cValToChar(::aAux[n,3]),;
                               cValToChar(::aAux[n,4]),;
                               cValToChar(::aAux[n,5]) } ) //, o:cAttrib(n)
          endif
       endif
   next
endif


if ::lDrives
   for n := 1 to len( aDrives )
       aadd( ::aItems, { aDrives[n]+"\", "", "","","" } ) //, o:cAttrib(n)
   next
endif


if ::lFtps
   for n := 1 to len( ::aFtps )
       aadd( ::aItems, { ::aFtps[n,1], "", "","","" } )
   next
endif



if ::lInfoExtend
   ::oLbx:bLine := {||{ o:GetBmpDrive(),upper(left(o:aItems[o:oLbx:nAt, 1],1))+ lower(substr(o:aItems[o:oLbx:nAt, 1],2)),;
                        transform(o:aItems[o:oLbx:nAt, 2],"@E 999,999,999,999,999"),;
                        o:aItems[o:oLbx:nAt, 3],;
                        o:aItems[o:oLbx:nAt, 4],;
                        o:aItems[o:oLbx:nAt, 5]}} //                    o:aItems[o:oLbx:nAt, 6]
else
   ::oLbx:bLine := {||{ o:GetBmpDrive(),;
                        upper(left(o:aItems[o:oLbx:nAt, 1],1))+ lower(substr(o:aItems[o:oLbx:nAt, 1],2))}} //                    o:aItems[o:oLbx:nAt, 6]

endif
::oLbx:nAt := 1
::oLbx:SetArray( ::aItems )
::oLbx:Refresh()
::oLbx:GoTop()

return nil
/*
     DIRECTORY() Subarray Structure
     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
     Position     Metasymbol     Directry.ch
     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
     1            cName          F_NAME
     2            cSize          F_SIZE
     3            dDate          F_DATE
     4            cTime          F_TIME
     5            cAttributes    F_ATTR
     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/


**********************************************************************
  METHOD cFile(n) CLASS TDirList
**********************************************************************

DEFAULT n := ::oLbx:nAt

return ::aItems[n,1]



**********************************************************************
  METHOD cName(n) CLASS TDirList
**********************************************************************
local o := self

if ::aAux[n,5]
   return "["+::aAux[n,1]+"]"
endif

return cFileNoExt( ::aAux[n,1] )


**********************************************************************
  METHOD cExt(n) CLASS TDirList
**********************************************************************

if ::aAux[n,5]
   return "<DIR>"
endif

return substr(::aAux[n,1], rat(".", ::aAux[n,1])+1)


**********************************************************************
  METHOD cSize(n) CLASS TDirList
**********************************************************************

if ::aAux[n,5]
   return ""
endif

return transform(::aAux[n,2],"@E 999,999,999,999,999")

**********************************************************************
  METHOD cDate(n) CLASS TDirList
**********************************************************************

return ::aAux[n,3]

**********************************************************************
  METHOD cTime(n) CLASS TDirList
**********************************************************************

return ::aAux[n,4]


**********************************************************************
  METHOD cAttrib(n) CLASS TDirList
**********************************************************************

return ::aAux[n,5]

**************************************************************
  METHOD Pulsa( nKey ) CLASS TDirList
**************************************************************

local cItem := ::aItems[::oLbx:nAt,1]
local cExt  := ::aItems[::oLbx:nAt,2]

if nKey != nil
   do case
      case nKey == 116
           return ::Reload()

      case nKey != VK_RETURN
           return nil
   endcase
endif

if at( ":\", cItem ) != 0
   ::cPath := alltrim(cItem)
   //::oLbx:oWnd:cTitle := ::cPath
   return ::Reload()
endif

if at( "ftp.", lower(::aItems[::oLbx:nAt,1] ) ) != 0 .and. cItem != ".."
   // cargando dir de un directorio
   ::cPath := ::aItems[::oLbx:nAt,1] + "/"
   //::oLbx:oWnd:cTitle := ::cPath
else

   if at( "D", ::aItems[::oLbx:nAt,5] ) == 0
      if ::lActionDef
         ShellExecute( GetActiveWindow() ,nil, ::cPath + cItem ,'','',5)
      else
         if ::bAction != nil
            return eval( ::bAction, self )
         endif
      endif

      return nil
   endif

   // directorio
   cItem := strtran(cItem,"[","")
   cItem := strtran(cItem,"]","")

   if At( "..", cItem ) != 0
      if at( "ftp.",lower(::cPath) ) != 0
         if len( ::cPath ) - len( strtran( ::cPath, "/","") ) > 1
            ::cPath := left( ::cPath, rat( "/", substr( ::cPath, 1, len( ::cPath) - 1 ) ) )
         else
            return nil
         endif
      else
         if len( ::cPath ) - len( strtran( ::cPath, "\","") ) > 1
            ::cPath := left( ::cPath, rat( "\", substr( ::cPath, 1, len( ::cPath) - 1 ) ) )
         else
            return nil
         endif
      endif
   else
      if at( "ftp.",lower(::cPath) ) != 0
         ::cPath += cItem + "/"
      else
         ::cPath += cItem + "\"
      endif
   endif

   ::cPath := alltrim( ::cPath )
   //::oLbx:oWnd:cTitle := ::cPath

endif

::Reload()

if ::bChange != nil
   eval( ::bChange, ::aItems )
endif

return nil


METHOD Midir( cPath ) CLASS TDirList
local cstrdir, n
local lIsDir
local cDate, cTime, cName, nSize
local nLines
local cLine
local aDir := {}
local h
local cSort
local aDrives := aDrives()

DEFAULT cPath := "G:\"

//cSort := "/O:" + if( ::oLbx:aSorts[::oLbx:nSort] == 1,"-","") + substr( "NESD",::oLbx:nSort,1)
cSort := "/O:" + if( aSorts[nSort] == 1,"-","") + "G"+ substr( "NESD",nSort,1)

h := fcreate( "b.bat" ) ; fwrite( h, "mode con cols=320" + CRLF + 'dir "' + cPath  + '" ' + cSort + ' /4 /-c /o:g > files.txt' ); fclose( h )
WAITRUN( "b.bat",0 )

cStrDir := memoread( "files.txt" )
nLines  := mlcount( cStrDir )

for n := 1 to nLines

    cLine  := memoline( cStrDir, 400,n )
    lIsDir := at( "<DIR>", cLine ) != 0

    if !isdigit(left( cLine,1))
       loop
    endif

    if ::nIniName == 0
       ::nIniName := ::IniName( lIsDir, cLine )
    endif

    cDate := alltrim(substr( cLine,  1, 10 ))
    cTime := alltrim(substr( cLine, 13,  5 ))
    cName := AnsiToOem(alltrim(substr( cLine, ::nIniName )))
    nSize := 0
    if at( "<DIR>", cLine ) == 0
       lIsDir := .f.
       nSize := val(substr( cLine, 18, 21 ))
    endif
    if lIsDir
       aadd( aDir, { cName, nSize, cDate, cTime, lIsDir } )
    endif

next

for n := 1 to nLines

    cLine  := memoline( cStrDir, 400,n )
    lIsDir := at( "<DIR>", cLine ) != 0

    if !isdigit(left( cLine,1))
       loop
    endif

    if ::nIniName == 0
       ::nIniName := ::IniName( lIsDir, cLine )
    endif

    cDate := alltrim(substr( cLine,  1, 10 ))
    cTime := alltrim(substr( cLine, 13,  5 ))
    cName := AnsiToOem(alltrim(substr( cLine, ::nIniName )))
    nSize := 0
    if at( "<DIR>", cLine ) == 0
       lIsDir := .f.
       nSize := val(substr( cLine, 18, 21 ))
    endif
    if !lIsDir
       aadd( aDir, { cName, nSize, cDate, cTime, lIsDir } )
    endif

next


return aDir

METHOD Sort( nSort0 ) CLASS TDirList

nSort := nSort0
//::oLbx:aSorts[::oLbx:nSort] := if( ::oLbx:aSorts[::oLbx:nSort] == 1,0,1)
aSorts[nSort0] := if( aSorts[nSort0] == 1,0,1)

::Reload()

return nil


 METHOD IniName( lIsDir, cLine ) CLASS TDirList

 local nLen := len( cLine )
 local n
 local nEn
 local cLetra


 if lIsDir
    nEn := AT( "<DIR>",cLine )
    for n := nEn + 5 to nLen
        if substr( cLine, n, 1 ) != " "
           return  n - 1
        endif
    next
 else
    for n := 18 to nLen
        cLetra := substr( cLine, n, 1 )
        if cLetra != " "
           nEn := n
           exit
        endif
    next
    for n := nEn to nLen
        cLetra := substr( cLine, n, 1 )
        if cLetra == " "
           return n + 1
        endif
    next
 endif

return 1

METHOD AdjTop() CLASS TDirList

return WndAdjTop( ::oLbx:hWnd )

METHOD AdjClient() CLASS TDirList

return WndAdjClient( ::oLbx:hWnd )


CLASS TImageBrw FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA aItems
      DATA nOption
      DATA nFirst
      DATA nSizeItem
      DATA bChange
      DATA nRows
      DATA nCols
      DATA nLen

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aItems ) CONSTRUCTOR
      METHOD Display() INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD Paint()
      //METHOD HScroll( nWParam, nLParam )
      METHOD VScroll( nWParam, nLParam )
      METHOD KeyDown( nKey, nFlags )
      METHOD LButtonDown( nRow, nCols, nKeyFlags )
      METHOD Destroy() INLINE TerminateGdiPlus(), super:Destroy()

ENDCLASS


***************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, aItems ) CLASS TImageBrw
***************************************************************************************************

   ::nTop         := nTop
   ::nLeft        := nLeft
   ::nBottom      := ::nTop + nHeight - 1
   ::nRight       := ::nLeft + nWidth - 1
   ::oWnd         := oWnd
   ::nStyle       := nOR( WS_BORDER, WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN, WS_TABSTOP, WS_VSCROLL )
   ::nId          := ::GetNewId()
   ::nOption      := 4
   ::nFirst       := 1
   ::lCaptured    := .f.
   ::nSizeItem    := 100
   ::aItems       := {}

   ::SetColor( 0, CLR_WHITE )

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      //::oFont := oFont
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif
   InitGdiPlus()

   DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self

return Self

*************************************************************************************************
   METHOD Paint() CLASS TImageBrw
*************************************************************************************************

   local hImage := 0
   local nHItem := 4 + 5 + ::nSizeItem + 20
   local nWItem := 4 + 5 + ::nSizeItem + 5
   local n, n2
   local nCols, nColumna
   local nRows, nFila
   local aRect   := GetClientRect( ::hWnd )
   local nWidth  := aRect[4]-aRect[2]
   local nHeight := aRect[3]-aRect[1]
   local nTop, nLeft, nBottom, nRight
   local rc
   local nLen := len( ::aItems )
   local cExt := ""
   local cFile
   local nHImage
   local nWImage
   local nFactor
   local hOldFont :=  SelectObject( ::hDC, GetStockObject( DEFAULT_GUI_FONT ) )
   local color

   nFila    := 0
   nColumna := 0

   ::nCols := int( nWidth  / nWItem )
   ::nRows := int( nHeight / nHItem )
   ::nLen  := nLen

   nCols := ::nCols
   nRows := ::nRows

   if empty( ::aItems )
      return nil
   endif

   for n := ::nFirst to nLen

       cFile  := ::aItems[n]
       cExt   := lower( right( cFile, 3 ) )
       hImage := 0

       do case
          case cExt == "ico"
               hImage := ExtractIcon(cFile)

          case cExt == "bmp"
               hImage := ReadBitmap( ::hDC, cFile )

          case cExt == "jpg" .or. cExt == "gif" .or. cExt == "png" .or. cExt == "wmf" .or. cExt == "emf"
               hImage := LoadJPG( cFile )

       endcase

       if hImage == 0
          loop
       endif

       if nColumna >= nCols
          nFila++
          if nFila >= nRows
             exit
          endif
          nColumna := 0
       endif

       nTop    := nFila       * nHItem
       nLeft   := nColumna    * nWItem
       nBottom := nTop  + nHItem
       nRight  := nLeft + nWItem

       nColumna++

       rc := {nTop, nLeft, nBottom, nRight}

       if n == ::nOption
          FillSolidRect( ::hDC, {nTop+5, nLeft+5, nBottom-20, nRight-5}, if( GetFocus()==::hwnd,RGB(49,106,197),CLR_HGRAY) )
          FillSolidRect( ::hDC, {nTop+5+3, nLeft+5+3, nBottom-20-3, nRight-5-3}, CLR_WHITE )
       else
          Box( ::hDC, {nTop+5, nLeft+5, nBottom-20, nRight-5}, CLR_HGRAY )
       endif

       do case
          case cExt == "ico"

               DrawIcon( ::hDC, nTop + 4 + 5 + ::nSizeItem/2 - 32/2, nLeft + 4 + 5 + ::nSizeItem/2 - 32/2, hImage )
               DestroyIcon( hImage )

          case cExt == "bmp" .or. cExt == "jpg"

               nHImage := nBmpHeight( hImage )
               nWImage := nBmpWidth( hImage )

               if nHImage > nWImage     //alta
                  nFactor := ::nSizeItem / nHImage
               else
                  nFactor := ::nSizeItem /  nWImage
               endif

               if nFactor >= 1
                  nFactor := 1
               endif

               nHImage :=  min( nHImage  * nFactor, ::nSizeItem - 3 )      // ::nHSmImg
               nWImage :=  min( nWImage  * nFactor, ::nSizeItem - 5 )

               DrawBitmapEx( ::hDC, hImage, nTop + 4 + 5 + ::nSizeItem/2 - nHImage/2,;
                                  nLeft + 4 + 5 + ::nSizeItem/2 - nWImage/2,;
                                  nWImage, nHImage, SRCCOPY )

               DeleteObject( hImage )

       endcase

       if hImage != 0
          rc[1] += ::nSizeItem + 10
          rc[3] := rc[1] + 18
          SetBkMode( ::hDC, 1 )
          cFile := left( cFileName( cFile ), 1 ) + lower(substr( cFileName( cFile ), 2 ) )
          if n == ::nOption
             rc[2] += 4 ; rc[4] -= 4
             FillSolidRect( ::hDC, rc, if( GetFocus()==::hwnd,RGB(49,106,197),CLR_HGRAY) )
             color := SetTextColor( ::hDC, CLR_WHITE )
             rc[2] -= 4 ; rc[4] += 4
          endif
          DrawText( ::hDC, cFile , rc, nOr( DT_SINGLELINE, DT_VCENTER, DT_CENTER ) )
          if n == ::nOption
             SetTextColor( ::hDC, color )
          endif
          SetBkMode( ::hDC, 0 )
       endif

   next
   SelectObject( ::hDC, hOldFont )


return nil

***************************************************************************************************
  METHOD KeyDown( nKey, nFlags ) CLASS TImageBrw
***************************************************************************************************

  do case
     case nKey == VK_UP
          ::nOption := max( ::nOption - ::nCols, 1 )
     case nKey == VK_DOWN
          ::nOption := min( ::nOption + ::nCols, ::nLen )
     case nKey == VK_LEFT
          ::nOption := max( ::nOption -1, 1 )
     case nKey == VK_RIGHT
          ::nOption := min( ::nOption + 1, ::nLen )
     otherwise
          return super:keyDown( nKey, nFlags )
  endcase
  ::Refresh()

return 0


***************************************************************************************************
  METHOD LButtonDown( nRow, nCols, nKeyFlags ) CLASS TImageBrw
***************************************************************************************************

 SetFocus( ::hWnd )

return super:LButtonDown( nRow, nCols, nKeyFlags )

***************************************************************************************************
  METHOD VScroll( nWParam, nLParam ) CLASS TImageBrw
***************************************************************************************************

   local nLen
   local nScrHandle  := nLParam
   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )
   local nFirst      := ::nFirst

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   if nScrHandle == 0                   // Window ScrollBar
      if ::oVScroll != nil
         do case
            case nScrollCode == SB_LINEUP
                    ::nFirst -= 4
                    ::nFirst := max( 1, ::nFirst )

            case nScrollCode == SB_LINEDOWN
                    ::nFirst += 4
                    ::nFirst := min( len( ::aItems ), ::nFirst )

         endcase
         if nFirst != ::nFirst
            ::Refresh()
         endif
       endif
   endif

return 0




#pragma BEGINDUMP
#include <windows.h>

#include "hbapi.h"


HINSTANCE hLib;

LPWSTR A2W( LPSTR cAnsi )
{
   WORD wLen;
   LPWSTR cString;

   wLen  = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, 0, 0 );

   cString = (LPWSTR) hb_xgrab( wLen * 2 );
   MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, cString, wLen );

   return ( cString );
}


HB_FUNC( INITGDIPLUS )
{
    typedef void (*MYPROC2)();
    MYPROC2 pFunc2;
    hLib = LoadLibrary( "testdll2.dll" );
    if( pFunc2 = ( MYPROC2 ) GetProcAddress( hLib, "InitGdiPlus" ) )
        pFunc2();
    hb_ret();
}



HB_FUNC( TERMINATEGDIPLUS )
{
    typedef void (*MYPROC2)();
    MYPROC2 pFunc2;
    if( pFunc2 = ( MYPROC2 ) GetProcAddress( hLib, "TerminateGdiPlus" ) )
        pFunc2();
    FreeLibrary( hLib );
    hb_ret();

}



HB_FUNC( SAVEFILE )
{
    typedef void (*MYPROC)(HBITMAP, LPWSTR, int);

    MYPROC pFunc;

    if( hLib )
    {
       if( pFunc = ( MYPROC ) GetProcAddress( hLib, "SaveFile" ) )
	{

           pFunc( (HBITMAP) hb_parnl( 1 ), A2W( hb_parc( 2 ) ), hb_parni( 3 ) );

        }
    }
    hb_ret();
}

HB_FUNC( LOADJPG )
{

    typedef HBITMAP (*MYPROC)(LPWSTR);


    MYPROC pFunc;


    HBITMAP bmp;

    if( hLib )
    {
       if( pFunc = ( MYPROC ) GetProcAddress( hLib, "LoadJPG" ) )
	{

           bmp = pFunc( A2W( hb_parc( 1 ) ) );

        }
    }
    hb_retnl( (LONG) bmp );
}


HB_FUNC( DRAWIMAGE )
{

    typedef void (*MYPROC)(HDC, HBITMAP, int, int);

    MYPROC pFunc;

    if( hLib )
    {
       if( pFunc = ( MYPROC ) GetProcAddress( hLib, "DrawImage2" ) )
	{

           pFunc( (HDC) hb_parnl( 1 ), (HBITMAP) hb_parnl( 2 ), hb_parni(3), hb_parni(4) );

        }
    }
}

#pragma ENDDUMP


