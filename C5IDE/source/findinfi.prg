#include "fivewin.ch"
#include "Directry.ch"

#define ODT_MENU        1
#define ODT_LISTBOX     2
#define ODT_COMBOBOX    3
#define ODT_BUTTON      4
#define ODA_DRAWENTIRE  0x0001
#define ODA_SELECT      0x0002
#define ODA_FOCUS       0x0004
#define ODS_SELECTED    0x0001
#define ODS_GRAYED      0x0002
#define ODS_DISABLED    0x0004
#define ODS_CHECKED     0x0008
#define ODS_FOCUS       0x0010
#define ODS_DEFAULT         0x0020
#define ODS_COMBOBOXEDIT    0x1000

#define COLOR_HIGHLIGHTTEXT  14
#define COLOR_HIGHLIGHT      13

#define ETO_OPAQUE                   0x0002
#define ETO_CLIPPED                  0x0004

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000


static oWnd
static oLbx
static oFont
static lCancel := .f.
static cBuscando

function Buscando( c )
if c != nil; cBuscando := c; endif
return cBuscando

function findinfiles( oPage, nShow )


local oDlg
local lValid := .f.
local aRect
local oCbxFind, aCbxFind := {}
local oCbxTipos, aCbxTipos := {}
local oCbxRutas, aCbxRutas := {}
local oBtnDir
local oChkMay, lMay := .f.
local oChkRec, lRec := .t.
local oChkExp, lExp := .f.
local cTipos := padr("*.PRG", 255 )
local cRutas := padr(CurDrive() + ":\" + GetCurDir(), 255)
local cDir
local aLines := {}
local cVar := ""
local cFind := space(255)

//DEFAULT nShow := 0

DEFINE DIALOG oDlg NAME "FINDINFILES" OF oPage

       REDEFINE COMBOBOX oCbxFind  VAR cFind  ID 104 ITEMS aCbxFind  OF oDlg
       REDEFINE COMBOBOX oCbxTipos VAR cTipos ID 105 ITEMS aCbxTipos OF oDlg
       REDEFINE COMBOBOX oCbxRutas VAR cRutas ID 106 ITEMS aCbxRutas OF oDlg

       REDEFINE BUTTON oBtnDir ID 108 OF oDlg ACTION ( cDir := cGetDir("Seleccione Ruta", alltrim( cRutas ) ),;
                                                       if( !empty( cDir ),;
                                                           (oCbxRutas:oGet:VarPut( cDir ), oCbxRutas:oGet:Refresh()),))

       REDEFINE CHECKBOX oChkMay VAR lMay ID 101 OF oDlg
       REDEFINE CHECKBOX oChkRec VAR lRec ID 102 OF oDlg
       //REDEFINE CHECKBOX oChkExp VAR lExp ID 103 OF oDlg

       REDEFINE BUTTON ID 1 OF oDlg ACTION ( Buscar( oCbxFind, oCbxTipos, oCbxRutas, lMay, lRec, lExp))
       REDEFINE BUTTON ID 2 OF oDlg ACTION lCancel := .t.

ACTIVATE DIALOG oDlg NOWAIT VALID lValid  ON INIT oDlg:Move( 0, 0, 2000, 2000, .t. )




//ON INIT if( nShow == 1, oWnd:Maximize(),oWnd:Move( 6, 6, 640, 480,.t.))

//min 556,438

return nil

function ShowWndFind()
local cVar
local aLines := {}
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )

DEFINE FONT oFont NAME "Courier New" SIZE 0, -12
//DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -10


if Aplicacion():oWndFindFiles == nil

   DEFINE WINDOW Aplicacion():oWndFindFiles MDICHILD ;
          TITLE "Buscar en ficheros" ;
          OF Aplicacion():oWnd ;
          FROM 0, 0 TO aClient[3]-Aplicacion():oWnd:oBar:nHeight(), 200 PIXEL ;
          COLOR 0, CLR_WHITE

     @ 0, 0 LISTBOX oLbx VAR cVar ITEMS aLines SIZE 100, 300 PIXEL OF Aplicacion():oWndFindFiles FONT oFont ON DBLCLICK AbreFichero() ;
            COLOR 0, CLR_WHITE BITMAPS {0}

            oLbx:bRClicked := {| nRow, nCol | Contextual( nRow, nCol ) }

            oLbx:nBmpHeight := 20 //30
            oLbx:bDrawItem := {| hDC, nItem, cText, rc, lFocus, lSelected, hBitmap | PintaItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap ) }

          Aplicacion():oWndFindFiles:oClient := oLbx

   ACTIVATE WINDOW Aplicacion():oWndFindFiles VALID ( lValid := .t. ) ;
          ON INIT Aplicacion():oWndFindFiles:Move( 0, Aplicacion():oToolBox:nRight,;
                                             aClient[4]-Aplicacion():oToolBox:nWidth,aClient[3]-Aplicacion():oWnd:oBar:nHeight, .t.)


else
   Aplicacion():oWndFindFiles:Show()

endif


return nil


static function Buscar( oCbxFind, oCbxTipos, oCbxRutas, lExacto, lRecursivo )
local aLines
local cLine
local cStr := ""
local cBuscar := alltrim(oCbxFind:oGet:VarGet())
local cRuta   := alltrim(oCbxRutas:oGet:VarGet())
local cTipos  := alltrim(oCbxTipos:oGet:VarGet())

if right( cRuta, 1 ) == "\"
   cRuta := substr( cRuta, 1, len( cRuta )-1 )
endif

if empty( cBuscar )
   MsgAlert( "Debe especificar busqueda","Atención")
   return nil
endif

AAdd( oLbx:aItems, 'Buscando "' + cBuscar + '"  en [' + cRuta + "]" )
oLbx:SendMsg( 384, 0, "Buscando " + cBuscar + "  en [" + cRuta + "]" )
//oLbx:Add(" " )

Buscando( cBuscar )

aLines := FindInFile( cBuscar, cRuta, cTipos, lExacto, lRecursivo  )
oLbx:GoTop()


cBuscar := oCbxFind: oGet:VarGet()
cRuta   := oCbxRutas:oGet:VarGet()
cTipos  := oCbxTipos:oGet:VarGet()

oCbxFind:oGet:VarPut( cBuscar )
oCbxFind:oGet:Refresh()

oCbxRutas:oGet:VarPut( cRuta )
oCbxRutas:oGet:Refresh()

oCbxTipos:oGet:VarPut( cTipos )
oCbxTipos:oGet:Refresh()

if lCancel
   MsgStop( "Acción cancelada","Atención")
   lCancel := .f.
   return nil
endif


return nil




function FindInFile( cBuscar, cDir, cMask, lExacto, lRecursivo )
local aDir, cFile, cStr, nEn, nLines, nEnLine, cLine, cAux, nLen, cAux2, n, cNewDir
local nLastEn := 0
local aLines := {}
local lPrimera := .t.

DEFAULT lExacto := .f.
DEFAULT lRecursivo := .f.

aDir := Directory( cDir + "\*.*", "D" )

nLen := len(aDir)

for n := 1 to nLen

    cFile := aDir[n]

    nLastEn := 0

    if lCancel
       return .f.
    endif


    if lRecursivo .and. ("D" $ cFile[F_ATTR]) .and. (cFile[F_NAME] != ".") .AND. (cFile[F_NAME] != "..")
        cNewDir := cDir + "\" + cFile[F_NAME]
        SysRefresh()
        FindInFile( cBuscar, cNewDir , cMask, lExacto, lRecursivo )
        if lCancel
           return .f.
        endif
    else


       if "." +lower(cFileExt( cFile[F_NAME])) $ lower(cMask)

          Aplicacion():oWndFindFiles:cTitle := cDir + "\" +cFile[F_NAME]

          cStr   := Memoread( cDir + "\" + cFile[F_NAME] )
          cAux   := Memoread( cDir + "\" + cFile[F_NAME] )
          lPrimera := .t.
          nLines := 0
          do while ( nEn := at( if( lExacto, cBuscar,lower(cBuscar)), if( lExacto, cStr, lower(cStr)) ) ) != 0

             if lPrimera
                lPrimera := .f.
                AAdd( oLbx:aItems, "" )
                oLbx:SendMsg( 384, 0, "" )
                AAdd( oLbx:aItems, cDir + "\" + cFile[F_NAME] )
                oLbx:SendMsg( 384, 0, cDir + "\" + cFile[F_NAME] )
             endif

             nLines  += ((len( left( cStr, nEn ) )-len(strtran( left( cStr, nEn ),CRLF,"")))/2)
             cLine   := memoline( cAux,254,nLines+1 )
             cStr    := substr( cStr, nEn+1 )
             AAdd( oLbx:aItems, str(nLines+1,6) + ":  " + cLine )
             oLbx:SendMsg( 384, 0, str(nLines+1,6) + ":  " + cLine )
             SysRefresh()
          enddo

       endif
    endif

next

return nil


function PintaItem( hDC, nItem, ctext, rc, lFocus, lSelected, hBitmap )
local nTop, nLeft, n
local nWidth := 0
local nHeight := 0
local nMode
local hOldFont := SelectObject( hDC, oFont:hFont )
local nEn
local nW
local c1, c2
local cBuscar := alltrim( Buscando() )
rc[2] += 3

nMode := SetBkMode( hDC, 1 )
if lSelected
   FillSolidRect( hDC, rc, CLR_HGRAY )
else
   FillSolidRect( hDC, rc, CLR_WHITE )
endif

SetTextColor( hDC, RGB(0,0,128) )

/*
if hBitmap != 0
   nWidth := nBmpWidth( hBitmap )
   nHeight := nBmpHeight( hBitmap )
   nTop := rc[1] + (rc[3]-rc[1])/2 - nHeight/2
   DrawMasked( hDC, hBitmap, nTop, rc[2]+2 )
endif
*/
nEn := at( lower(cBuscar), lower(cText) )

if nEn > 0
   c1 := substr( cText, 1, nEn-1 )
   nW := GetTextWidth( hDC, c1, oFont:hFont )
   rc[4] := rc[2] + nW
   DrawText( hDC, c1, {rc[1], rc[2], rc[3], rc[4] }, nOr( DT_VCENTER, DT_SINGLELINE ) )

   SetTextColor( hDC, RGB( 0,100,0) )
   rc[2] := rc[4]
   nW := GetTextWidth( hDC, cBuscar, oFont:hFont )
   rc[4] := rc[2] + nW
   DrawText( hDC, substr( cText, nEn, len( cBuscar ) ), {rc[1], rc[2] , rc[3], rc[4] }, nOr( DT_VCENTER, DT_SINGLELINE ) )

   SetTextColor( hDC, RGB(0,0,150) )
   c2 := substr( cText, nEn + len( cBuscar ) )
   rc[2] := rc[4]
   nW := GetTextWidth( hDC, c2, oFont:hFont )
   rc[4] := rc[2] + nW
   DrawText( hDC, c2, {rc[1], rc[2] , rc[3], rc[4] }, nOr( DT_VCENTER, DT_SINGLELINE ) )
else
   SetTextColor( hDC, RGB( 128,0,150) )
   DrawText( hDC, cText, {rc[1], rc[2] , rc[3], rc[4] }, nOr( DT_VCENTER, DT_SINGLELINE ) )
endif

SetBkMode( hDC, nMode )
SelectObject( hDC, hOldFont )

return nil





function LbxDrawItem( nPStruct, aBitmaps, aItems, nBmpWidth, bDrawItem )

local aInfo := GetDrawItemStruct( nPStruct )
local CtlType    := aInfo[1]
local CtlID      := aInfo[2]
local itemID     := aInfo[3]
local itemAction := aInfo[4]
local itemState  := aInfo[5]
local hWndItem   := aInfo[6]
local hDC        := aInfo[7]
local nTop       := aInfo[8]
local nLeft      := aInfo[9]
local nBottom    := aInfo[10]
local nRight     := aInfo[11]
local rgbFore, rgbBack

do case
   case itemAction == ODA_DRAWENTIRE .or. itemAction == ODA_SELECT

        if bDrawItem != nil
           if itemID+1 > len( aItems ); return " "; endif
           return eval( bDrawItem, hDC, itemID+1, aItems[itemID+1], {nTop, nLeft, nBottom, nRight}, lAnd( itemState, ODS_FOCUS ),lAnd( itemState, ODS_SELECTED )) //, if( len( abitmaps ) > 0, aBitmaps[itemID+1],0) )
        endif

        if lAnd( itemState, ODS_FOCUS )
           DrawFocusRect( hDC, nTop,nLeft,nBottom,nRight )
        endif
        if lAnd( itemState, ODS_SELECTED )
           rgbFore := SetTextColor( hDC, GetSysColor( COLOR_HIGHLIGHTTEXT ) )
           rgbBack := SetBkColor( hDC, GetSysColor( COLOR_HIGHLIGHT ) )
           FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, GetSysColor( COLOR_HIGHLIGHT ) )
        else
           FillSolidRect( hDC, {nTop, nLeft, nBottom, nRight}, CLR_WHITE	 )
        endif

        DrawText( hDC, aItems[itemID + 1], {nTop, nLeft + 2, nBottom, nRight}, nOr( DT_VCENTER, DT_SINGLELINE ) )

        if lAnd( itemState, ODS_SELECTED )
           SetTextColor( hDC, rgbFore )
           SetBkColor( hDC, rgbBack )
        endif

        if lAnd( itemState, ODS_FOCUS )
           DrawFocusRect( hDC, nTop, nLeft, nBottom, nRight )
        endif

endcase



static function Abrefichero()

local cLine := oLbx:GetSelText()
local nLine, cFile, n
local oCode
local nIni, nEnd

if substr( cLine, 7, 1 ) == ":"
   nLine := val( left( cLine, 6 ))
   for n := oLbx:GetPos to 1 step -1
       if left( oLbx:aItems[n], 1 ) != " "
          cFile := alltrim( oLbx:aItems[n] )
          exit
       endif
   next
endif

if file( cFile )
   oCode := OpenCode( cFile )
   oCode:GotoLine( nLine )
   nIni := oCode:nPos
   oCode:GoEol()
   nEnd := oCode:nPos
   oCode:SetSel( nIni, nEnd )
   oCode:SetFocus()
endif

return nil




static function contextual( nRow, nCol )
local oMnu


 MENU oMnu POPUP
    MENUITEM "Limpiar" ACTION ( if( len( oLbx:aItems ) > 0, (oLbx:Reset(), oLbx:Add( " " )),) )
    MENUITEM " "
    MENUITEM " "
    MENUITEM " "
 ENDMENU
 ACTIVATE MENU oMnu AT nRow, nCol OF oLbx

return nil

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"


/*typedef struct tagDRAWITEMSTRUCT {
    UINT CtlType;
    UINT CtlID;
    UINT itemID;
    UINT itemAction;
    UINT itemState;
    HWND hwndItem;
    HDC hDC;
    RECT rcItem;
    ULONG_PTR itemData;
}*/

HB_FUNC( GETDRAWITEMSTRUCT )
{
   LPDRAWITEMSTRUCT lp = ( LPDRAWITEMSTRUCT ) hb_parnl( 1 );

   hb_reta( 12 );

   hb_storvni( lp->CtlType      ,    -1, 1  );
   hb_storvni( lp->CtlID        ,    -1, 2  );
   hb_storvni( lp->itemID       ,    -1, 3  );
   hb_storvni( lp->itemAction   ,    -1, 4  );
   hb_storvni( lp->itemState    ,    -1, 5  );
   hb_storvni( ( LONG ) lp->hwndItem     ,    -1, 6  );
   hb_storvni( ( LONG ) lp->hDC          ,    -1, 7  );
   hb_storvni( lp->rcItem.top   ,    -1, 8  );
   hb_storvni( lp->rcItem.left  ,    -1, 9  );
   hb_storvni( lp->rcItem.bottom,    -1, 10 );
   hb_storvni( lp->rcItem.right ,    -1, 11 );
   hb_storvnd( lp->itemData     ,    -1, 12 );

}




HB_FUNC( ALPHABLEND )
{
   typedef BOOL (CALLBACK* LPALPHABLEND)( HDC hdcDest,
                                          int nXOriginDest,
                                          int nYOriginDest,
                                          int nWidthDest,
                                          int nHeightDest,
                                          HDC hdcSrc,
                                          int nXOriginSrc,
                                          int nYOriginSrc,
                                          int nWidthSrc,
                                          int nHeightSrc,
                                          BLENDFUNCTION blendFunction);
   HINSTANCE hLib;
   LPALPHABLEND AlphaBlend;

   BLENDFUNCTION m_bf;
   HDC hDCMem ;
   HBITMAP hOldBmp;
   m_bf.BlendOp = AC_SRC_OVER;
   m_bf.BlendFlags = 0;
   m_bf.SourceConstantAlpha = (hb_pcount()==7 ? hb_parni(7):0 ) ;
   m_bf.AlphaFormat = 0;



   hLib = LoadLibrary( "msimg32.dll" );
   if( hLib )
   {
       hDCMem = CreateCompatibleDC( (HDC) hb_parnl(1) );
       AlphaBlend = ((LPALPHABLEND) GetProcAddress( hLib, "AlphaBlend" ));

       hOldBmp = (HBITMAP) SelectObject( hDCMem, (HBITMAP) hb_parnl(2) );

       AlphaBlend(( HDC) hb_parnl(1), hb_parni(3), hb_parni(4), hb_parni(5), hb_parni(6),
                   hDCMem,         0,           0, hb_parni(5), hb_parni(6), m_bf);

       SelectObject( hDCMem, hOldBmp );
       DeleteDC( hDCMem );
       FreeLibrary( hLib );
   }

}
#pragma ENDDUMP
