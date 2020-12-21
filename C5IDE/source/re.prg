// FiveWin Resources Editor

#include "FiveWin.ch"
#include "Splitter.ch"
#include "TCBrowse.ch"

#define WM_SETFONT          0x0030

#define ES_CENTER           0x0001
#define ES_UPPERCASE        0x0008
#define ES_LOWERCASE        0x0010
#define ES_PASSWORD         0x0020
#define ES_AUTOVSCROLL      0x0040
#define ES_NOHIDESEL        0x0100
#define ES_OEMCONVERT       0x0400
#define ES_NUMBER           0x2000

#define SS_CENTER           0x00000001
#define SS_RIGHT            0x00000002
#define SS_ICON             0x00000003
#define SS_GRAYRECT         0x00000005
#define SS_BLACKFRAME       0x00000007
#define SS_GRAYFRAME        0x00000008
#define SS_USERITEM         0x0000000A
#define SS_LEFTNOWORDWRAP   0x0000000C
#define SS_OWNERDRAW        0x0000000D
#define SS_BITMAP           0x0000000E
#define SS_ENHMETAFILE      0x0000000F
#define SS_ETCHEDHORZ       0x00000010
#define SS_ETCHEDVERT       0x00000011
#define SS_ETCHEDFRAME      0x00000012
#define SS_TYPEMASK         0x0000001F
#define SS_NOPREFIX         0x00000080
#define SS_NOTIFY           0x00000100
#define SS_CENTERIMAGE      0x00000200
#define SS_RIGHTJUST        0x00000400
#define SS_REALSIZEIMAGE    0x00000800
#define SS_SUNKEN           0x00001000
#define SS_ENDELLIPSIS      0x00004000
#define SS_PATHELLIPSIS     0x00008000
#define SS_WORDELLIPSIS     0x0000C000
#define SS_ELLIPSISMASK     0x0000C000

#define CBS_OWNERDRAWVARIABLE 0x0020
#define CBS_HASSTRINGS        0x0200
#define CBS_NOINTEGRALHEIGHT  0x0400
#define CBS_UPPERCASE         0x2000
#define CBS_LOWERCASE         0x4000

#define BS_RADIOBUTTON      0x00000004
#define BS_3STATE           0x00000005
#define BS_AUTO3STATE       0x00000006
#define BS_USERBUTTON       0x00000008
#define BS_OWNERDRAW        0x0000000B
#define BS_LEFTTEXT         0x00000020
#define BS_TEXT             0x00000000
#define BS_ICON             0x00000040
#define BS_BITMAP           0x00000080
#define BS_LEFT             0x00000100
#define BS_RIGHT            0x00000200
#define BS_CENTER           0x00000300
#define BS_TOP              0x00000400
#define BS_BOTTOM           0x00000800
#define BS_VCENTER          0x00000C00
#define BS_PUSHLIKE         0x00001000
#define BS_MULTILINE        0x00002000
#define BS_NOTIFY           0x00004000
#define BS_FLAT             0x00008000
#define BS_RIGHTBUTTON      BS_LEFTTEXT

#define LBS_NOREDRAW          0x0004
#define LBS_OWNERDRAWVARIABLE 0x0020
#define LBS_HASSTRINGS        0x0040
#define LBS_MULTICOLUMN       0x0200
#define LBS_EXTENDEDSEL       0x0800
#define LBS_NODATA            0x2000
#define LBS_NOSEL             0x4000

#define DS_SETFONT            0x40
#define DS_3DLOOK             0x0004
#define DS_FIXEDSYS           0x0008
#define DS_NOFAILCREATE       0x0010
#define DS_CONTROL            0x0400
#define DS_CENTER             0x0800
#define DS_CENTERMOUSE        0x1000
#define DS_CONTEXTHELP        0x2000

#define DTS_UPDOWN          0x0001
#define DTS_SHOWNONE        0x0002
#define DTS_SHORTDATEFORMAT 0x0000
#define DTS_LONGDATEFORMAT  0x0004
#define DTS_SHORTDATECENTURYFORMAT 0x000C
#define DTS_TIMEFORMAT      0x0009
#define DTS_APPCANPARSE     0x0010
#define DTS_RIGHTALIGN      0x0020

#define GW_CHILD              5
#define GW_HWNDNEXT           2

static oWnd, oImageList, oTree

static aStyles := { { "ES_LEFT",           ES_LEFT },;
   	                { "ES_CENTER",         ES_CENTER },;
   	                { "ES_RIGHT",          ES_RIGHT },;
   	                { "ES_MULTILINE",      ES_MULTILINE },;
   	                { "ES_UPPERCASE",      ES_UPPERCASE },;
   	                { "ES_LOWERCASE",      ES_LOWERCASE },;
   	                { "ES_PASSWORD",       ES_PASSWORD },;
   	                { "ES_AUTOVSCROLL",    ES_AUTOVSCROLL },;
   	                { "ES_AUTOHSCROLL",    ES_AUTOHSCROLL },;
   	                { "ES_NOHIDESEL",      ES_NOHIDESEL },;
   	                { "ES_OEMCONVERT",     ES_OEMCONVERT },;
   	                { "ES_READONLY",       ES_READONLY },;
    	              { "ES_WANTRETURN",     ES_WANTRETURN },;
   	                { "ES_NUMBER",         ES_NUMBER },;
   	                { "WS_CHILD",          WS_CHILD },;
   	                { "WS_VISIBLE",        WS_VISIBLE },;
   	                { "WS_GROUP",          WS_GROUP },;
   	                { "WS_BORDER",         WS_BORDER },;
   	                { "WS_VSCROLL",        WS_VSCROLL },;
   	                { "WS_HSCROLL",        WS_HSCROLL },;
   	                { "WS_TABSTOP",        WS_TABSTOP },;
   	                { "WS_DISABLED",       WS_DISABLED },;
   	                { "SS_LEFT",           SS_LEFT  },;
   	                { "SS_CENTER",         SS_CENTER },;
   	                { "SS_RIGHT",          SS_RIGHT },;
   	                { "SS_ICON",           SS_ICON },;
   	                { "SS_BLACKRECT",      SS_BLACKRECT },;
   	                { "SS_GRAYRECT",       SS_GRAYRECT },;
   	                { "SS_WHITERECT",      SS_WHITERECT },;
   	                { "SS_BLACKFRAME",     SS_BLACKFRAME },;
   	                { "SS_GRAYFRAME",      SS_GRAYFRAME },;
   	                { "SS_WHITEFRAME",     SS_WHITEFRAME },;
   	                { "SS_USERITEM",       SS_USERITEM },;
   	                { "SS_SIMPLE",         SS_SIMPLE },;
   	                { "SS_LEFTNOWORDWRAP", SS_LEFTNOWORDWRAP },;
   	                { "SS_OWNERDRAW",      SS_OWNERDRAW },;
   	                { "SS_BITMAP",         SS_BITMAP },;
   	                { "SS_ENHMETAFILE",    SS_ENHMETAFILE },;
   	                { "SS_ETCHEDHORZ",     SS_ETCHEDHORZ },;
   	                { "SS_ETCHEDVERT",     SS_ETCHEDVERT },;
   	                { "SS_ETCHEDFRAME",    SS_ETCHEDFRAME },;
   	                { "SS_TYPEMASK",       SS_TYPEMASK },;
   	                { "SS_NOPREFIX",       SS_NOPREFIX },;
   	                { "SS_NOTIFY",         SS_NOTIFY },;
   	                { "SS_CENTERIMAGE",    SS_CENTERIMAGE },;
   	                { "SS_RIGHTJUST",      SS_RIGHTJUST },;
   	                { "SS_REALSIZEIMAGE",  SS_REALSIZEIMAGE },;
   	                { "SS_SUNKEN",         SS_SUNKEN },;
   	                { "SS_ENDELLIPSIS",    SS_ENDELLIPSIS },;
   	                { "SS_PATHELLIPSIS",   SS_PATHELLIPSIS },;
   	                { "SS_WORDELLIPSIS",   SS_WORDELLIPSIS },;
   	                { "SS_ELLIPSISMASK",   SS_ELLIPSISMASK },;
                    { "CBS_SIMPLE",            CBS_SIMPLE },;
   	                { "CBS_DROPDOWN",          CBS_DROPDOWN },;
   	                { "CBS_DROPDOWNLIST",      CBS_DROPDOWNLIST },;
   	                { "CBS_OWNERDRAWFIXED",    CBS_OWNERDRAWFIXED },;
   	                { "CBS_OWNERDRAWVARIABLE", CBS_OWNERDRAWVARIABLE },;
   	                { "CBS_AUTOHSCROLL",       CBS_AUTOHSCROLL },;
   	                { "CBS_OEMCONVERT",        CBS_OEMCONVERT },;
   	                { "CBS_SORT",              CBS_SORT },;
   	                { "CBS_HASSTRINGS",        CBS_HASSTRINGS },;
   	                { "CBS_NOINTEGRALHEIGHT",  CBS_NOINTEGRALHEIGHT },;
   	                { "CBS_DISABLENOSCROLL",   CBS_DISABLENOSCROLL },;
   	                { "CBS_UPPERCASE",         CBS_UPPERCASE },;
   	                { "CBS_LOWERCASE",         CBS_LOWERCASE },;
                    { "BS_PUSHBUTTON",        	 BS_PUSHBUTTON },;
   	                { "BS_DEFPUSHBUTTON",        BS_DEFPUSHBUTTON },;
   	                { "BS_CHECKBOX",             BS_CHECKBOX },;
   	                { "BS_AUTOCHECKBOX",         BS_AUTOCHECKBOX },;
   	                { "BS_RADIOBUTTON",          BS_RADIOBUTTON },;
   	                { "BS_3STATE",               BS_3STATE },;
   	                { "BS_AUTO3STATE",           BS_AUTO3STATE },;
   	                { "BS_GROUPBOX",             BS_GROUPBOX },;
   	                { "BS_USERBUTTON",           BS_USERBUTTON },;
   	                { "BS_AUTORADIOBUTTON",      BS_AUTORADIOBUTTON },;
   	                { "BS_OWNERDRAW",            BS_OWNERDRAW },;
   	                { "BS_LEFTTEXT",             BS_LEFTTEXT },;
   	                { "BS_TEXT",                 BS_TEXT },;
   	                { "BS_ICON",                 BS_ICON },;
   	                { "BS_BITMAP",               BS_BITMAP },;
   	                { "BS_LEFT",                 BS_LEFT },;
   	                { "BS_RIGHT",                BS_RIGHT },;
   	                { "BS_CENTER",               BS_CENTER },;
   	                { "BS_TOP",                  BS_TOP },;
   	                { "BS_BOTTOM",               BS_BOTTOM },;
   	                { "BS_VCENTER",              BS_VCENTER },;
   	                { "BS_PUSHLIKE",             BS_PUSHLIKE },;
   	                { "BS_MULTILINE",            BS_MULTILINE },;
   	                { "BS_NOTIFY",               BS_NOTIFY },;
   	                {	"BS_FLAT",                 BS_FLAT },;
   	                {	"BS_RIGHTBUTTON",          BS_RIGHTBUTTON },;
                    { "LBS_NOTIFY",              LBS_NOTIFY },;
   	                { "LBS_SORT",                LBS_SORT },;
   	                { "LBS_NOREDRAW",            LBS_NOREDRAW },;
   	                { "LBS_MULTIPLESEL",         LBS_MULTIPLESEL },;
   	                { "LBS_OWNERDRAWFIXED",      LBS_OWNERDRAWFIXED },;
   	                { "LBS_OWNERDRAWVARIABLE",   LBS_OWNERDRAWVARIABLE },;
   	                { "LBS_HASSTRINGS",          LBS_HASSTRINGS },;
   	                { "LBS_USETABSTOPS",         LBS_USETABSTOPS },;
   	                { "LBS_NOINTEGRALHEIGHT",    LBS_NOINTEGRALHEIGHT },;
   	                { "LBS_MULTICOLUMN",         LBS_MULTICOLUMN },;
   	                { "LBS_WANTKEYBOARDINPUT",   LBS_WANTKEYBOARDINPUT },;
   	                { "LBS_EXTENDEDSEL",         LBS_EXTENDEDSEL },;
   	                { "LBS_DISABLENOSCROLL",     LBS_DISABLENOSCROLL },;
   	                { "LBS_NODATA",              LBS_NODATA },;
   	                { "LBS_NOSEL",               LBS_NOSEL },;
   	                { "LBS_STANDARD",            LBS_STANDARD },;
                    { "DTS_UPDOWN",              DTS_UPDOWN },;
                    { "DTS_SHOWNONE",            DTS_SHOWNONE },;
                    { "DTS_SHORTDATEFORMAT",     DTS_SHORTDATEFORMAT },;
                    { "DTS_LONGDATEFORMAT",      DTS_LONGDATEFORMAT },;
                    { "DTS_SHORTDATECENTURYFORMAT", DTS_SHORTDATECENTURYFORMAT },;
                    { "DTS_TIMEFORMAT",          DTS_TIMEFORMAT },;
                    { "DTS_APPCANPARSE",         DTS_APPCANPARSE },;
                    { "DTS_RIGHTALIGN",          DTS_RIGHTALIGN },;
   	                { "1", 1 },;
   	                { "2", 2 },;
   	                { "3", 3 },;
   	                { "0", 0 } }

static aDlgStyles := { { "WS_BORDER",      WS_BORDER },;
	                     { "WS_CAPTION",     WS_CAPTION },;
	                     { "WS_MINIMIZEBOX", WS_MINIMIZEBOX },;
	                     { "WS_POPUP",       WS_POPUP },;
	                     { "WS_DLGFRAME",    WS_DLGFRAME },;
	                     { "WS_SYSMENU",     WS_SYSMENU },;
	                     { "WS_CHILD",       WS_CHILD },;
	                     { "WS_OVERLAPPED",  WS_OVERLAPPED },;
	                     { "WS_VISIBLE",     WS_VISIBLE },;
	                     { "WS_THICKFRAME",  WS_THICKFRAME },;
	                     { "0x4L",           4 },;
	                     { "4",              4 },;
	                     { "DS_MODALFRAME",  DS_MODALFRAME },;
	                     { "DS_3DLOOK",      DS_3DLOOK } }

//----------------------------------------------------------------------------//
/*
function OpenRcFile()

   local oBar, oMenuNew
   local hBorland := LoadLibrary( "BWCC32.dll" )

   BWCCRegister( GetResources() )

   DEFINE WINDOW oWnd FROM 3, 6 TO 20, 70 ;
      TITLE FWVERSION + " Resources Editor" ;
      MENU BuildMenu() MDI

   DEFINE BUTTONBAR oBar SIZE 24, 27 OF oWnd 2007 // _3D

   MENU oMenuNew POPUP
      MENUITEM "New &Dialog" RESOURCE "Dialog"
      MENUITEM "New &Bitmap" RESOURCE "Bitmap"
      MENUITEM "New &Icon"   RESOURCE "Icon"
   ENDMENU

   DEFINE BUTTON OF oBar  ;
      TOOLTIP "New" NOBORDER RESOURCE "New" MENU oMenuNew

   DEFINE BUTTON OF oBar  ;
      TOOLTIP "Open" NOBORDER RESOURCE "Open" ;
      ACTION OpenRCFile()

   DEFINE BUTTON OF oBar  ;
      TOOLTIP "Save" NOBORDER RESOURCE "Save"

   DEFINE BUTTON OF oBar GROUP ;
      TOOLTIP "Exit" NOBORDER RESOURCE "Exit" ACTION oWnd:End()

   oImageList = TImageList():New()

   oImageList:Add( TBitmap():Define( "folder",,  oWnd ),;
                   TBitmap():Define( "fldmask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "dialog",,  oWnd ),;
                   TBitmap():Define( "dlgmask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "icon",,    oWnd ),;
                   TBitmap():Define( "icomask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "bitmap",,  oWnd ),;
                   TBitmap():Define( "bmpmask",, oWnd ) )

   SET MESSAGE OF oWnd TO "Ready" NOINSET CLOCK DATE KEYBOARD 2007

   ACTIVATE WINDOW oWnd MAXIMIZED ;
      ON INIT InitFWHControls()
      // VALID MsgYesNo( "Want to end ?" )

   oImageList:End()

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu 2007
      MENUITEM "&File"
      MENU
         MENUITEM "&New"  RESOURCE "new"
         MENUITEM "&Open" RESOURCE "Open" ;
            ACTION OpenRCFile()

         MENUITEM "&Save as..."
         SEPARATOR
         MENUITEM "&Exit..." ACTION oWnd:End() RESOURCE "Exit"
      ENDMENU
      MENUITEM "&Edit"
      oMenu:AddMDI()
      oMenu:AddHelp( "FiveWin Resources Editor", "FiveTech 1993-2007" )
   ENDMENU

return oMenu
*/
//----------------------------------------------------------------------------//

function OpenRCFile()

   local oWndRC, oTree, oMemo, oSplit
   local cRCFile := cGetFile( "*.rc", "Select a resources file" )
   local cTxtFile, cLine, nFrom := 1, cItemText := "", cText
   local oItem, oBmpItem, oDlgItem, oIcoItem, oMnuItem, oMnuString

   DEFINE WINDOW oWndRC FROM 100, 300 TO 400, 700 PIXEL TITLE cRCFile



   oTree = TTreeView():New( 2, 0, oWndRC, , , .T., .F., 200, 300 )

   oTree:bChanged = { | oItem | oItem := oTree:GetSelected(),;
                      If( oItem != nil, oMemo:SetText( oItem:Cargo ),) }
   oTree:bLDblClick = { || ShowDialog( oTree:GetSelected() ) }

   oImageList = TImageList():New()

   oImageList:Add( TBitmap():Define( "folder",,  oWnd ),;
                   TBitmap():Define( "fldmask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "dialog",,  oWnd ),;
                   TBitmap():Define( "dlgmask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "icon",,    oWnd ),;
                   TBitmap():Define( "icomask",, oWnd ) )
   oImageList:Add( TBitmap():Define( "bitmap",,  oWnd ),;
                   TBitmap():Define( "bmpmask",, oWnd ) )


   oTree:SetImageList( oImageList )

   @ 0, 25.7 GET oMemo VAR cItemText MEMO OF oWndRC SIZE 300, 100

   @ 0, 200 SPLITTER oSplit ;
      VERTICAL _3DLOOK ;
      PREVIOUS CONTROLS oTree ;
      HINDS CONTROLS oMemo ;
      SIZE 4, 200 PIXEL ;
      OF oWndRC

   oSplit:AdjClient()

   if ! Empty( cRCFile )
      cTxtFile = MemoRead( cRCFile )

      while nFrom < Len( cTxtFile )
         cLine = ExtractLine( cTxtFile, @nFrom )
         SysRefresh()

         if Upper( StrToken( cLine, 2 ) ) == "BITMAP"
            if oBmpItem == nil
               oBmpItem = oTree:Add( "Bitmaps" )
            endif
            oBmpItem:Add( StrToken( cLine, 1 ), 3, StrToken( cLine, 3 ) )
         endif

         if Upper( StrToken( cLine, 2 ) ) == "DIALOG"
            if oDlgItem == nil
               oDlgItem = oTree:Add( "Dialogs" )
            endif
            oItem = oDlgItem:Add( StrToken( cLine, 1 ), 1 )
            cText = cLine + CRLF
            while ( SubStr( cLine, 1, 1 ) != "}" .and. SubStr( cLine, 1, 3 ) != "END" ) .and. ;
                  nFrom <= Len( cTxtFile )
               cLine = ExtractLine( cTxtFile, @nFrom )
               cText += cLine + CRLF
               SysRefresh()
            end
            oItem:Cargo = cText
         endif

         if Upper( StrToken( cLine, 2 ) ) == "ICON"
            if oIcoItem == nil
               oIcoItem = oTree:Add( "Icons" )
            endif
            oIcoItem:Add( StrToken( cLine, 1 ), 2, StrToken( cLine, 3 ) )
         endif

         if Upper( StrToken( cLine, 2 ) ) == "MENU"
            if oMnuItem == nil
               oMnuItem = oTree:Add( "Menus" )
            endif
            oMnuItem:Add( StrToken( cLine, 1 ), 2 )
         endif

         if Upper( StrToken( cLine, 1 ) ) == "STRINGTABLE"
            if oMnuString == nil
               oMnuString = oTree:Add( "Strings" )
            endif
            oMnuString:Add( StrToken( cLine, 2 ), 2 )
         endif

      end
   endif

   oWndRC:bResized := {||oSplit:AdjClient()}

   oWndRC:Show()

return nil

//----------------------------------------------------------------------------//

function ShowDialog( oItem )

   local cText, cLine, nFrom := 1
   local cCaption := "", nTop, nLeft, nWidth, nHeight, nStyle, nFontSize, cFontName
   local oDlg, cResource := "", cFirst, nControls := 0
   local oFnt

   if oItem == nil
      return nil
   endif

   cText = oItem:Cargo
   if Empty( cText )
      return nil
   endif
   cLine = ExtractLine( cText, @nFrom )

   nTop    = Val( SubStr( StrToken( cLine, 1, "," ), RAt( " ", StrToken( cLine, 1, "," ) ) + 1 ) )
   nLeft   = Val( StrToken( cLine, 2, "," ) )
   nWidth  = Val( StrToken( cLine, 3, "," ) )
   nHeight = Val( StrToken( cLine, 4, "," ) )

   while nFrom < Len( cText )
      cLine = ExtractLine( cText, @nFrom )
      cLine = StrTran( cLine, Chr( 9 ), "   " ) // remove Tab chars
      cFirst = Upper( AllTrim( StrToken( cLine, 1 ) ) )

      do case
      	 case cFirst == "CAPTION"
              cCaption = StrToken( cLine, 2, '"' )

         case cFirst == "STYLE"
              nStyle = ParseDlgStyle( AllTrim( SubStr( cLine, 6 ) ) )
              if lAnd( nStyle, WS_CHILD )
                 nStyle = nXor( nStyle, WS_CHILD )
              endif
              if nAnd( nStyle, WS_CAPTION ) != WS_CAPTION
                 nStyle = nOr( nStyle, WS_CAPTION )
              endif

         case cFirst == "FONT"
              nFontSize = Val( StrToken( StrToken( cLine, 1, "," ), 2 ) )
              cFontName = StrToken( cLine, 2, '"' )

         case cFirst == "CONTROL"
              cResource += ParseControl( cLine )
              nControls++

         case cFirst $ "PUSHBUTTON,DEFPUSHBUTTON,LISTBOX,EDITTEXT,LTEXT,RTEXT,GROUPBOX,CHECKBOX,COMBOBOX,RADIOBUTTON"
              cResource += ParseStdControl( cLine )
              nControls++
      endcase
   end

   DEFAULT nFontSize := 8, cFontName := "Ms Sans Serif"

   cResource = cDlg2Chr( nControls, nTop, nLeft, nTop + nHeight, nLeft + nWidth,;
                         cCaption, nStyle, nFontSize, cFontName ) + cResource

   DEFINE DIALOG oDlg

   oDlg:cResData = cResource

   ACTIVATE DIALOG oDlg ;
      ON INIT InitControls( oDlg ) ;
      ON PAINT DrawGrid( oDlg:hWnd, hDC, cPS, 8, 8 )

return nil

//----------------------------------------------------------------------------//

function ParseDlgStyle( cStyle )

   local nStyle := nOr( DS_SETFONT, WS_OVERLAPPEDWINDOW ), cToken, nAt

   while ! Empty( cStyle )
      cToken = AllTrim( StrToken( cStyle, 1, "|" ) )

      if ( nAt := AScan( aDlgStyles, { | a | cToken == a[ 1 ] } ) ) != 0
       	 nStyle = nOr( nStyle, aDlgStyles[ nAt ][ 2 ] )
      else
         MsgAlert( "Dialog style not found: " + cToken,;
                   "Please report this to FiveTech Software" )
      endif
      if At( "|", cStyle ) != 0
         cStyle = SubStr( cStyle, At( "|", cStyle ) + 1 )
      else
         cStyle = ""
      endif
   end

return nStyle

//----------------------------------------------------------------------------//

function ParseControl( cLine )

   local nTop, nLeft, nWidth, nHeight, nId, nAt
   local cClassName, cStyle, nStyle := nOr( WS_VISIBLE, WS_CHILD, WS_TABSTOP ), cCaption, cToken

   cCaption = StrToken( cLine, 2, '"' )
   cLine = StrToken( cLine, 1, '"' ) + '"-"' + StrToken( cLine, 3, '"' ) + '"' + ;
           StrToken( cLine, 4, '"' ) + '"' + StrToken( cLine, 5, '"' )
   nId     = Val( StrToken( cLine, 1, "," ) )
   nLeft   = Val( StrToken( cLine, 5, "," ) )
   nTop    = Val( StrToken( cLine, 6, "," ) )
   nWidth  = Val( StrToken( cLine, 7, "," ) )
   nHeight = Val( StrToken( cLine, 8, "," ) )
   cClassName = StrToken( cLine, 4, '"' )
   cStyle  = StrToken( cLine, 4, "," )

   if cClassName == "EDIT"
      cClassName = "edit"
   endif
   if Upper( cClassName ) == "TFOLDER"
      cClassName = "SysTabControl32"
   endif

   while ! Empty( cStyle )
      cToken = AllTrim( StrToken( cStyle, 1, "|" ) )

      if ( nAt := AScan( aStyles, { | a | cToken == a[ 1 ] } ) ) != 0
       	 nStyle = nOr( nStyle, aStyles[ nAt ][ 2 ] )
      else
         if SubStr( cToken, 1, 3 ) != "NOT"
            MsgAlert( "Style not found: " + cToken,;
                      "Please report this to FiveTech Software" )
         endif
      endif
      if At( "|", cStyle ) != 0
         cStyle = SubStr( cStyle, At( "|", cStyle ) + 1 )
      else
         cStyle = ""
      endif
   end

return cCtrl2Chr( nTop, nLeft, nTop + nHeight, nLeft + nWidth, nId, nStyle,;
                  cClassName, cCaption )

//----------------------------------------------------------------------------//

function ParseStdControl( cLine )

   local nTop, nLeft, nWidth, nHeight, nId, nAt
   local cClassName, cStyle, nStyle := nOr( WS_VISIBLE, WS_CHILD, WS_TABSTOP ), cCaption, cToken

   cClassName = StrToken( cLine, 1 )

   do case
   	  case cClassName == "PUSHBUTTON"
   	       cClassName = "Button"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( cLine, 2, "," ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft = Val( StrToken( cLine, 4, "," ) )
           nHeight = Val( StrToken( cLine, 5, "," ) )
           nWidth  = Val( StrToken( cLine, 6, "," ) )

   	  case cClassName == "DEFPUSHBUTTON"
   	       cClassName = "Button"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( cLine, 2, "," ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft = Val( StrToken( cLine, 4, "," ) )
           nHeight = Val( StrToken( cLine, 5, "," ) )
           nWidth  = Val( StrToken( cLine, 6, "," ) )
           nStyle = nOr( nStyle, BS_DEFPUSHBUTTON )

   	  case cClassName == "LISTBOX"
   	       cClassName = "ListBox"
   	       nId  = Val( StrToken( StrToken( cLine, 2 ), 1, "," ) )
           nTop = Val( StrToken( cLine, 2, "," ) )
           nLeft   = Val( StrToken( cLine, 3, "," ) )
           nHeight  = Val( StrToken( cLine, 4, "," ) )
           nWidth   = Val( StrToken( cLine, 5, "," ) )
           cCaption = ""
           cStyle  = StrToken( cLine, 6, "," )

   	  case cClassName == "EDITTEXT"
   	       cClassName = "Edit"
   	       nId  = Val( StrToken( cLine, 2 ) )
           nTop = Val( StrToken( cLine, 2, "," ) )
           nLeft   = Val( StrToken( cLine, 3, "," ) )
           nHeight  = Val( StrToken( cLine, 4, "," ) )
           nWidth   = Val( StrToken( cLine, 5, "," ) )
           cStyle = StrToken( cLine, 6, "," )
           if Empty( cStyle )
              cStyle = "WS_BORDER"
           endif
           cCaption = ""

   	  case cClassName == "LTEXT"
   	       cClassName = "static"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( StrToken( cLine, 2, "," ) ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft   = Val( StrToken( cLine, 4, "," ) )
           nHeight  = Val( StrToken( cLine, 5, "," ) )
           nWidth   = Val( StrToken( cLine, 6, "," ) )
           cStyle = "ES_LEFT"

   	  case cClassName == "RTEXT"
   	       cClassName = "static"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( StrToken( cLine, 2, "," ) ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft   = Val( StrToken( cLine, 4, "," ) )
           nHeight  = Val( StrToken( cLine, 5, "," ) )
           nWidth   = Val( StrToken( cLine, 6, "," ) )
           cStyle = "ES_RIGHT"

   	  case cClassName == "GROUPBOX"
   	       cClassName = "button"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( StrToken( cLine, 2, "," ) ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft   = Val( StrToken( cLine, 4, "," ) )
           nHeight  = Val( StrToken( cLine, 5, "," ) )
           nWidth   = Val( StrToken( cLine, 6, "," ) )
           cStyle = StrToken( cLine, 7, "," )

   	  case cClassName == "CHECKBOX"
   	       cClassName = "Button"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( cLine, 2, "," ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft = Val( StrToken( cLine, 4, "," ) )
           nHeight = Val( StrToken( cLine, 5, "," ) )
           nWidth  = Val( StrToken( cLine, 6, "," ) )
           cStyle = StrToken( cLine, 7, "," )

   	  case cClassName == "COMBOBOX"
   	       cClassName = "ComboBox"
   	       nId  = Val( StrToken( StrToken( cLine, 2 ), 1, "," ) )
           nTop = Val( StrToken( cLine, 2, "," ) )
           nLeft   = Val( StrToken( cLine, 3, "," ) )
           nHeight  = Val( StrToken( cLine, 4, "," ) )
           nWidth   = Val( StrToken( cLine, 5, "," ) )
           cCaption = ""
           cStyle  = StrToken( cLine, 6, "," )

   	  case cClassName == "RADIOBUTTON"
   	       cClassName = "Button"
           cCaption = StrToken( cLine, 2, '"' )
           cLine = StrToken( cLine, 1, '"' ) + '"-"' + SubStr( cLine, RAt( '"', cLine ) + 1 )
   	       nId  = Val( StrToken( cLine, 2, "," ) )
           nTop = Val( StrToken( cLine, 3, "," ) )
           nLeft = Val( StrToken( cLine, 4, "," ) )
           nHeight = Val( StrToken( cLine, 5, "," ) )
           nWidth  = Val( StrToken( cLine, 6, "," ) )
           cStyle = StrToken( cLine, 7, "," )

   endcase

   while ! Empty( cStyle )
      cToken = AllTrim( StrToken( cStyle, 1, "|" ) )

      if ( nAt := AScan( aStyles, { | a | cToken == a[ 1 ] } ) ) != 0
       	 nStyle = nOr( nStyle, aStyles[ nAt ][ 2 ] )
      else
         if SubStr( cToken, 1, 3 ) != "NOT"
            MsgAlert( "Style not found: " + cToken, "Please report this to FiveTech Software" )
         endif
      endif
      if At( "|", cStyle ) != 0
         cStyle = SubStr( cStyle, At( "|", cStyle ) + 1 )
      else
         cStyle = ""
      endif
   end

return cCtrl2Chr( nLeft, nTop, nLeft + nWidth, nTop + nHeight, nId, nStyle,;
                  cClassName, cCaption )

//----------------------------------------------------------------------------//

function InitFWHControls()

   local oDlg, oCtrl

   DEFINE DIALOG oDlg

   @ 2, 2 LISTBOX oCtrl FIELDS "" OF oDlg

   @ 2, 2 BTNBMP oCtrl OF oDlg

   @ 2, 2 BITMAP oCtrl OF oDlg

   @ 2, 2 TABS oCtrl OF oDlg

   @ 2, 2 BROWSE oCtrl OF oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT oDlg:End()

return nil

//----------------------------------------------------------------------------//

DLL32 FUNCTION BWCCRegister( hInst AS LONG ) AS WORD PASCAL LIB "BWCC32.DLL"

//----------------------------------------------------------------------------//

function InitControls( oDlg )

   local hDlg := oDlg:hWnd, hCtrl := GetWindow( hDlg, GW_CHILD ), oCtrl

   if hCtrl != 0
      oCtrl = TControl()
      oCtrl:oWnd = oDlg
      oCtrl:hWnd = hCtrl
      oCtrl:Link()
      AAdd( oDlg:aControls, oCtrl )
      oCtrl:lDrag = .T.
      oCtrl:bGotFocus = { || oCtrl:ShowDots() }
   endif

   while hCtrl != 0
      hCtrl = GetWindow( hCtrl, GW_HWNDNEXT	)
      if hCtrl != 0
         oCtrl = TControl()
         oCtrl:oWnd = oDlg
         oCtrl:hWnd = hCtrl
         oCtrl:Link()
         AAdd( oDlg:aControls, oCtrl )
         oCtrl:lDrag = .T.
         oCtrl:bGotFocus = { || oCtrl:ShowDots() }
      endif
   end

return nil

//----------------------------------------------------------------------------//
