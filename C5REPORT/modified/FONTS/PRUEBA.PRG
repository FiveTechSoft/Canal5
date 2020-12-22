#include "fivewin.ch"
#include "c5report.ch"
#include "constant.ch"
#include "splitter.ch"


#define ARROW  0

static nTime := 1

static nActivo := ARROW
static oList
static oBar
static oBar1
static oBar2
static oBar3
static oWnd
static oReport
static o
static oArrow
static oUndo
static oRedo
static oTree
static oRoot
static oHSplit
static oVSplit

static oFixed
static oFacename
static oHFont
static oBold
static oUnder
static oItalic
static oStrike
static oClrText
static oClrPane
static oTimer
static lFixed := .f.
static oPreview
static oClient
static hWnd


function main( hWnd, cUser, cPwd )

local  o,   oPanel, oFont, nGroup, oMenu, oSizes
local nSize := "10"
local aSizes := {"8","9","10","12","14","16","18","20","22","24","26","28","36","48","72"}
local hDC, aFonts
local nTop := 20

o := array(30)

//? "recibido", hWnd, cUser, cPwd
//
//return 500

DEFINE FONT oFont NAME "Verdana" SIZE 0,-11

MENU oMenu
     MENUITEM "Archivo"
     MENUITEM "Edición"
     MENU
        MENUITEM "Cortar"
        MENUITEM "Copiar"
        MENUITEM "Pegar"
        SEPARATOR
        MENUITEM "Seleccionar todo" ACTION oReport():SelectAll() ;
            ACCELERATOR ACC_CONTROL, Asc( "A" )

     ENDMENU
     MENUITEM "Formato"
     MENUITEM "Vista"
ENDMENU


DEFINE WINDOW oWnd TITLE "CanalFive Report" COLOR 0, CLR_GRAY  MENU oMenu

    oBar := TC5StBar():New( 0,0,4300,60,oWnd,CLR_WHITE,rgb(173,197,229))
    oBar:lBorder := .t.
    oWnd:oTop := oBar

    oBar1 := TC5StBar():New( 0,0,580,30,oBar,CLR_WHITE,rgb(173,197,229))
    oBar1:lBorder := .t.
    o[ 1] := oBar1:AddItem( , "new",     {|| oReport:Nuevo(),     ResetBar(1,.f.)} )
    o[ 2] := oBar1:AddItem( , "open",    {|| oReport:Load(),      ResetBar(1,.f.)} )
    o[ 3] := oBar1:AddItem( , "save",    {|| oReport:Save(),      ResetBar(1,.f.)} )
    o[ 4] := oBar1:AddItem( , "print",   {|| oReport:Print(),     ResetBar(1,.f.)} )
    oPreview := oBar1:AddItem( , "preview", {|| oReport:Preview(),   ResetBar(1,.f.)} )

             oBar1:Separator()
    o[ 5] := oBar1:AddItem( , "cut" ,    {|| oReport:Cut(),       ResetBar(1,.f.)} )
    o[ 6] := oBar1:AddItem( , "copy",    {|| oReport:Copy(),      ResetBar(1,.f.)} )
    o[ 7] := oBar1:AddItem( , "paste",   {|| oReport:Paste(),     ResetBar(1,.f.)} )
             oBar1:Separator()
    o[26] := oBar1:AddItem( , "zoomout", {|| oReport:Zoom( max(10,oReport:Zoom()-10 )),     ResetBar(1,.f.)} )
    o[27] := oBar1:AddItem( , "zoomin",  {|| oReport:Zoom( oReport:Zoom()+10 )        ,     ResetBar(1,.f.)} )
             oBar1:Separator()
    oUndo := oBar1:AddItem( , "undo",    {|| oReport:Undo() } )
    oUndo := oBar1:AddItem( , "redo",    {||.t.} )
             oBar1:Separator()
             oBar1:AddItem( , "toback",    {|| oReport:ToBack() } )
             oBar1:AddItem( , "tofront",   {|| oReport:ToFront() } )
             oBar1:Separator()
             oBar1:AddItem( , "altop",    {|| oReport:Align(1) } )
             oBar1:AddItem( , "alleft",   {|| oReport:Align(2) } )
             oBar1:AddItem( , "albottom", {|| oReport:Align(3) } )
             oBar1:AddItem( , "alright",  {|| oReport:Align(4) } )



    oBar2 := TC5StBar():New( 30,0,300,30,oBar,CLR_WHITE,rgb(173,197,229))
    oBar2:lBorder := .t.

    oArrow := oBar2:AddItem( , "curarrow",  {||( nActivo := ARROW,ResetBar(2, .f.), oArrow:lChecked := .t.)} )
    o[09]  := oBar2:AddItem( , "text",      {||( nActivo := C5TEXTO,          ResetBar(2,.f.), o[ 9]:lChecked := .t.)} )
    o[10]  := oBar2:AddItem( , "image",     {||( nActivo := C5BITMAP,         ResetBar(2,.f.), o[10]:lChecked := .t.)} )
    o[11]  := oBar2:AddItem( , "line",      {||( nActivo := C5LINE,           ResetBar(2,.f.), o[11]:lChecked := .t.)} )
    o[12]  := oBar2:AddItem( , "box",       {||( nActivo := C5RECT,           ResetBar(2,.f.), o[12]:lChecked := .t.)} )
    o[13]  := oBar2:AddItem( , "elipse",    {||( nActivo := C5ELIPSE,         ResetBar(2,.f.), o[13]:lChecked := .t.)} )
    o[14]  := oBar2:AddItem( , "field",     {||( nActivo := C5FIELD,          ResetBar(2,.f.), o[14]:lChecked := .t.)} )
     oBar2:Separator()
     oBar2:AddItem(,"Photo", {|| oReport():GetBoxes() } )

    oBar3 := TC5StBar():New( 30,300,420,30,oBar,CLR_WHITE,rgb(173,197,229))
    oBar3:lBorder := .t.
    oBar3:oFont := oFont

    o[16]  := oBar3:AddItem( )
    o[16]:nFixWidth := 30
    o[16]:lHide := .t.

    @ 9, 8 CHECKBOX oFixed VAR lFixed PROMPT "" SIZE 12, 12 PIXEL OF oBar3
    oFixed:cTooltip := "Fijar valores para items nuevos"

    oFaceName  := oBar3:AddItem( , ,      {|| C5SetVar( "cFaceName", oReport:cFaceName ), oFaceName:cTooltip := oReport:cFaceName } )
    oFaceName:nFixWidth := 120
    oFaceName:bPopup := {|nRow, nCol | C5SetVar( "cFaceName", xSelFont( nRow, nCol, "Verdana" )),;
                                       oFaceName:cPrompt := oReport:cFaceName, oFaceName:Refresh(), oFaceName:cTooltip := oReport:cFaceName }

    o[17]  := oBar3:AddItem( )
    o[17]:nFixWidth := 55
    o[17]:lHide := .t.

    @ 5, 165 COMBOBOX oHFont VAR nSize ITEMS aSizes OF oBar3 SIZE 40, 200 PIXEL FONT oFont ;
             ON CHANGE C5SetVar( "nHFont", val(nSize) )

    oBold    := oBar3:AddItem( , "bold",     {||(   oBold:lChecked   := !oBold:lChecked  ), C5SetVar( "lBold",  oBold  :lChecked)} )
    oItalic  := oBar3:AddItem( , "italic",   {||(   oItalic:lChecked := !oItalic:lChecked), C5SetVar( "lItalic",oItalic:lChecked)} )
    oUnder   := oBar3:AddItem( , "under",    {||(   oUnder:lChecked  := !oUnder:lChecked ), C5SetVar( "lUnder", oUnder :lChecked)} )
    oStrike  := oBar3:AddItem( , "strike",   {||(   oStrike:lChecked := !oStrike:lChecked), C5SetVar( "lStrike",oStrike:lChecked)} )

    oClrText  := oBar3:AddItem(, "textclr",   {|| C5SetVar( "nClrText", oReport:nClrText ) } )
    oClrText:bPopup := {|nRow, nCol | C5SetVar( "nClrText", xSelColor( nRow, nCol, oReport:nClrText ) ) }



    oClrPane  := oBar3:AddItem("  " , "paneclr",   {||C5SetVar( "nClrPane", oReport:nClrPane ) } )
    oClrPane:bPopup := {|nRow, nCol | C5SetVar( "nClrPane", xSelColor( nRow, nCol, oReport:nClrPane ) ) }


    oPanel := TPanelEx():New( 0, 0, 100, 230, oWnd, rgb(173,197,229) )
    oWnd:oLeft := oPanel

    oTree := TTreeViewEx():New( 0, 1, oPanel, CLR_BLACK, CLR_WHITE, .T., .F., 228, 200 )
          oRoot := oTree:Add( "Informe" )


    oList := TListProp():New( 205, 1, 228, 300, , {"","",""},{20, 100, 100}, oPanel, , , ,,,, oFont )

    oList:nLineStyle := 2

       @ 200, 2 SPLITTER oHSplit ;
              HORIZONTAL ;
              PREVIOUS CONTROLS oTree ;
              HINDS CONTROLS oList ;
              LEFT MARGIN 70 ;
              SIZE 3000, 4  PIXEL ;
              COLOR rgb(173,197,229) ;
              OF oPanel ; //  _3DLOOK ;
              UPDATE

    oClient := TPanelEx():New( oBar:nHeight()-1, oPanel:nWidth+5 , 100, 230, oWnd, rgb(173,197,229) )

*    oReport := TC5Report():New( 35,31, 550, 784, oClient,0,rgb(173,197,229), { 20, 20, 297+20, 210+20 } )

    oReport := TC5Report():New( 35,31, 550, 784, oClient,0,rgb(173,197,229), { 20, 20, 210+20, 148+20 } )

          oRoot:cargo := oReport
                                                                             //
    oReport:oHRule := TC5Rule():New(  4, 30, 2000,   30, oClient, CLR_BLACK, rgb(173,197,229), .f., oReport )
    oReport:oVRule := TC5Rule():New( 34,  0,   30, 2000, oClient, CLR_BLACK, rgb(173,197,229), .t., oReport )

    oClient:bResized := {|| oReport:SetSize( oClient:nWidth-35,oClient:nHeight-35,.t.),;
                            oReport:oHRule:SetSize( oClient:nWidth-35,oReport:oHRule:nHeight,.t. ),;
                            oReport:oVRule:SetSize( oReport:oVRule:nWidth,oClient:nHeight-35,.t. ) }

    @ oBar:nHeight()-1, 231 SPLITTER oVSplit ;
           VERTICAL ;
           PREVIOUS CONTROLS oPanel ;
           HINDS CONTROLS oClient ;
           LEFT MARGIN 1 ;
           SIZE 4, 3000  PIXEL ;
           COLOR rgb(173,197,229) ;
           OF oWnd ;
           UPDATE

    oReport:SetProperties( .t. )
    oTree:bChanged := {|| oReport:TreeToReport() } //, oReport():SetFocus()
    //oTree:bLButtonUp := {|| oReport():SetFocus() }
    oTree:Expand()


    oPanel:bResized := {|| oTree  :nWidth := oPanel:nWidth-2,;
                           oHSplit:SetSize( oPanel:nWidth,4,.t.),oHSplit:_CoorsUpdate(),;
                           oList:SetSize( oPanel:nWidth-2, oPanel:nHeight-oHSplit:nTop-4,.t.) }

    //oWnd:bResized := {|| oHSplit:AdjBottom(),oVSplit:AdjRight()}

    oWnd:bResized := {|nSizeType| oClient:SetSize(GetClientRect(oWnd:hWnd)[4]-oPanel:nWidth,GetClientRect(oWnd:hWnd)[3]-oBar:nHeight(),.t.)}
    //Move( oBar:nHeight(),;
    //                     oPanel:nWidth,;
    //                     GetClientRect(oWnd:hWnd)[4]-oPanel:nWidth,GetClientRect(oWnd:hWnd)[3],.t.),;
    //                     oList:nHeight := oPanel:nHeight - oHSplit:nTop-10  }
                         //oHSplit:AdjRight()}

  // DEFINE TIMER oTimer INTERVAL nTime*60000 OF oWnd ACTION MsgInfo( "CanalFive Report. Beta 004" + CRLF +;
  //                                                            "http://www.canalfive.com"   + CRLF +;
  //                                                            "Paco García & Oskar Liria" )
  // oTimer:Activate()

  SetKey( VK_F8, {||HidePanelLeft()} )




ACTIVATE WINDOW oWnd
*ACTIVATE WINDOW oWnd MAXIMIZED

//oTimer:End()

return nil

********************************************************************************************
  function C5SetVar( cVarName, uVal )
********************************************************************************************

  if cVarName == "nClrText"
     OSend( oReport, "_nxClrText", uVal )
  else
    if cVarName == "nClrPane"
       OSend( oReport, "_nxClrPane", uVal )
    else
       OSend( oReport, "_" + cVarName, uVal )
    endif
  endif

  if oReport:oSelected != nil
     OSend( oReport:oSelected, "_" + cVarName, uVal )
  endif

  if oReport:lSelecteds
     aeval( oReport:aItems, {|o| if( o:lSelected, OSend( o, "_" + cVarName, uVal ),) } )
  endif

  oReport:Refresh()

return uVal

**********************************
 function ResetBar( nBar, lBar )
**********************************
 local n, nLen
 local o

 DEFAULT lBar := .t.
 DEFAULT lBar := 1

 do case
    case nBar == 1
         o := oBar1
    case nBar == 2
         o := oBar2
    case nBar == 3
         o := oBar3

endcase


 nLen := len( o:aItems )
 for n := 1 to nLen
     o:aItems[n]:lChecked := .f.
 next

 if lBar
    o:aItems[1]:lChecked := .t.
    nActivo := ARROW
    oArrow:lChecked := .t.
 endif
 o:Refresh()

return nil


function oWnd() ;      return oWnd
function oVSplit() ;   return oVSplit
function nGetActivo(); return nActivo
function oReport();    return oReport
function SelArrow();   ResetBar(2, .t. ); return 0
function Inspector();  return oList
function oUndo();      return oUndo
function oRedo();      return oRedo
function oTree();      return oTree
function oRoot( uVal )
  if uVal != nil
     oRoot := uVal
  endif
return oRoot
function lFixed() ; return lFixed
function oFaceName( cNewVal )

if cNewVal != nil
   oFaceName:cPrompt := cNewVal
   oFaceName:Refresh()
endif

return oReport:cFacename

function oBold( lNewVal )
if lNewVal != nil
   oBold:lChecked := lNewVal
   oBold:Refresh()
endif
return oReport:lBold

function oItalic( lNewVal )
if lNewVal != nil
   oItalic:lChecked := lNewVal
   oItalic:Refresh()
endif
return oReport:lItalic

function oUnder( lNewVal )
if lNewVal != nil
   oUnder:lChecked := lNewVal
   oUnder:Refresh()
endif
return oReport:lUnder

function oStrike( lNewVal )
if lNewVal != nil
   oStrike:lChecked := lNewVal
   oStrike:Refresh()
endif
return oReport:lStrike


function HidePanelLeft()

if GetKeyState( VK_CONTROL )

   if oVSplit():nLeft > 1
      oVSplit():SetPosition( 1 )
   else
      ShowPanelLeft()
   endif

endif

return 0

function ShowPanelLeft()
oVSplit():SetPosition( 231 )
return 0












#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_BTNSHADOW     16
#define COLOR_BTNHIGHLIGHT  20

#define FD_BORDER            8
#define FD_HEIGHT           22

#define WINDING              2
#define SC_KEYMENU       61696   // 0xF100

#define TVS_HASBUTTONS       1
#define TVS_HASLINES         2
#define TVS_LINESATROOT      4
#define TVS_SHOWSELALWAYS   32 //   0x0020
#define TVS_DISABLEDRAGDROP 16 //   0x0010

#ifdef __CLIPPER__
   #define CTRL_NAME "SysTreeView"
#else
   #define CTRL_NAME "SysTreeView32"
#endif

#ifdef __XPP__
   #define Super ::TControl
   #define ScanItems ScanItem
#endif

CLASS TTreeViewEx FROM TTreeView

      METHOD New( nTop, nLeft, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CONSTRUCTOR

      METHOD DelItem( oITem )

ENDCLASS

METHOD New( nTop, nLeft, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CLASS TTreeViewEx

   DEFAULT nTop     := 0, nLeft := 0,;
           oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200, nHeight := 150

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP, WS_BORDER, WS_VSCROLL, ;
                      TVS_HASBUTTONS, TVS_HASLINES, TVS_LINESATROOT, TVS_SHOWSELALWAYS, TVS_DISABLEDRAGDROP)

   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::aItems    = {}

   if ! Empty( oWnd:hWnd )
      ::Create( CTRL_NAME )
      oWnd:AddControl( Self )
      ::SetColor( nClrFore, nClrBack )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

*******************************************************************************************
      METHOD DelItem( oITem ) CLASS TTreeViewEx
*******************************************************************************************

local n
local oItemPa :=  oItem:GetParent()
local nLen := len( oITemPa:aItems )

for n := 1 to nLen
    if oITemPa:aItems[n]:hItem == oITem:hItem
       adel(oITemPa:aItems,n)
       asize(oITemPa:aItems,nLen-1)
       TVDeleteItem( ::hWnd, oItem:hItem )
       exit
    endif
next
::Refresh()

return 0

static function SearchItem( aItems, hItem )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := SearchItem( aItems[ n ]:aItems, hItem ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:hItem == hItem
         return aItems[ n ]
      endif
   next

return nil




#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "math.h"


#pragma ENDDUMP



