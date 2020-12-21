#include "fivewin.ch"
#include "Constant.ch"
#include "winuser.ch"
#include "wnddsgn.ch"

//#include "defines.ch"

#define DSTINVERT           5570569  //(DWORD)0x00550009
#define GWL_STYLE        -16
#define GW_CHILD           5
#define GW_HWNDNEXT        2
#define GWL_EXSTYLE      -20

#define TESTPARTNER        1
#define SAVEBITMAP         2
#define COPYBITMAP         3
#define CMPWND1            4
#define CMPWND2            5
#define COPYAREA           6
#define VERINFO            7
#define STOREINFO          8

#define HWND_TOP        ((HWND)0)
#define HWND_BOTTOM     ((HWND)1)
#define HWND_TOPMOST    ((HWND)-1)
#define HWND_NOTOPMOST  ((HWND)-2)

#define SS_ICON             3

STATIC nMiMensaje
static lPrimera := .t.

STATIC oDlgShow, oGet11, oGet21, oGet31, oGet41, oGet51, oGet61, oGet71, oGet81, oGet91, oGet101, oGet111
static oRad
static nRad := 4
static hWndMain
static oDsgn := nil
static hBmpDesk

CLASS TSpy FROM TControl

   DATA lBitmap AS LOGICAL INIT .F.
   DATA hIco
   DATA hWndOld
   DATA lCaptured
   DATA aoFiles
   DATA cClassname
   DATA aVarNames AS ARRAY
   CLASSDATA hWndCmp1 AS NUMERIC INIT 0
   CLASSDATA hWndCmp2 AS NUMERIC INIT 0
   DATA hCursor
   DATA nType
   DATA lGroup
   DATA aEqualAs
   DATA oGost
   DATA lGostCapture
   DATA aRect
   DATA aPos

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cResName, nType, lBitmap ) CONSTRUCTOR

   METHOD Display    () INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
   METHOD Paint()

   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )
   METHOD SmallestWindowFromPoint( point )
   METHOD HighlightWindow( hwnd, fDraw )
   METHOD GenCode( hWnd )
   METHOD GenCodeRC( hWnd )
   METHOD GenForm( hWnd )
   METHOD Destroy()
   METHOD GenDbfRc( cFile )
   METHOD GenDbfPrg( cFile )
   METHOD GetItems( hWnd )
   METHOD TakeDrop( aFiles )
   METHOD BuscaRel( aFiles )
   METHOD SaveBmp( hWnd, cFileName )
   METHOD SaveBmp2( hWnd, cFileName )
   METHOD GetStrMenu( hMenu )
   METHOD GetVarName( cClase )
   METHOD CaptureWnd( hWnd )
   METHOD CmpWnd( hWnd )
   METHOD CmpVisual( hWnd )
   METHOD Comparar( a1, a2 )
   METHOD End() INLINE if( ::hBitmap, DeleteObject( ::hIco ), DestroyIcon( ::hIco ) ) , oDsgn := nil, super:End()

   METHOD Capturador()
   METHOD MoveGost(nRow,nCol )
   METHOD BtnUpGost()
   METHOD Pinta( hDC )

ENDCLASS


/*****************************************************************************************/
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cResname, nType, lBitmap )  CLASS TSpy
/*****************************************************************************************/

   local o := self

   DEFAULT nTop := 10
   DEFAULT nLeft := 10
   DEFAULT nWidth := 100
   DEFAULT nHeight := 100
   DEFAULT cResName := ""
   DEFAULT nType := 0
   DEFAULT lBitmap := .f.

   ::nTop        := nTop
   ::nLeft       := nLeft
   ::nRight      := nLeft + nWidth
   ::nBottom     := nTop + nHeight
   ::oWnd        := oWnd
   ::nType       := nType
   ::hWndOld     := 0
   ::lCaptured   := .f.
   ::cClassname  := "TSPY"
   ::aProperties := {"nTop","nLeft","nWidth","nHeight"}
   ::lGroup      := .f.
   ::aEqualAs    := {}

   ::lBitmap := lBitmap

   if ::lBitmap
      ::hIco := LoadBitmap( GetInstance(), cResName  )
   else
      if empty( cResName )
         ::hIco := LoadIcon( GetInstance(), "magic")
      else
         ::hIco := LoadIcon( GetInstance(), cResName )
      endif
   endif

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   ::aoFiles := {}
   ::aVarNames := {}

   ::SetColor( 0, GetSysColor( COLOR_BTNFACE ) )
   nMiMensaje := RegisterWindowMessage( "WM_SCRIP_TESTPARNER" )

   if !Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::bDropFiles := {|nRow,nCol,aFiles| o:TakeDrop( aFiles ) }
   DragAcceptFiles( ::hWnd, .t. )

   //Aplicacion():oWnd:Minimize()
//   ::Restore()
//   ::GoTop()

return self

/*****************************************************************************************/
   METHOD Destroy() CLASS TSpy
/*****************************************************************************************/

DestroyIcon( ::hIco )

return 0

/*****************************************************************************************/
   METHOD SaveBmp( hWnd, hBmp ) CLASS TSpy
/*****************************************************************************************/

DibWrite( "screen.bmp", DibFromBitmap( hBmp ) )


return nil

/*****************************************************************************************/
   METHOD SaveBmp2( hWnd, cBmpFile ) CLASS TSpy
/*****************************************************************************************/
local hBmp := DibFromBitmap( WndBitmap( hWnd ) )

DEFAULT cBmpFile := "screen.bmp"

DibWrite( cBmpFile, hBmp )


return nil

/*****************************************************************************************/
   METHOD Paint() CLASS TSpy
/*****************************************************************************************/

   if ::lBitmap
      DrawBitmap( ::hDC, ::hIco, 3, 3 )
   else
      DrawIcon( ::hDC, 3,3, ::hIco )
   endif

return nil

/*****************************************************************************************/
   METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TSpy
/*****************************************************************************************/

   SetCapture( ::hWnd )
   ::lCaptured := .t.
   ::DestroyToolTip()
   if ::nType == COPYAREA
      ::oWnd:Move( 10000,10000,,,.t.)
      ::hCursor := LoadCursor(0,32515)
      SetCursor( ::hCursor )
   else
      CursorMagic()
   endif

return 0

/*****************************************************************************************/
   METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSpy
/*****************************************************************************************/
local pt
local PID
local hWnd
local n
local a
local cText



if ::lCaptured

   if ::nType == COPYAREA
      SetCursor( ::hCursor )
   else
      CursorMagic()
      pt := GetCursorPos() //ClientToScreen ( ::hWnd, pt )
      hWnd := ::SmallestWindowFromPoint( pt )
      //PID := GetWindowThreadProcessId ( hWnd )
      //if GetCurrentProcessId () == PID
      //	return 0
      //endif

      if ::hWndOld   == hWnd .or.;
         ::hWnd      == hWnd .or.;
         ::oWnd:hWnd == hWnd .or. GetParent( hWnd ) == ::oWnd:hWnd
         return 0			// prevent flickering
      endif

      if ::hWndOld != 0
         ::HighlightWindow(::hWndOld,.f.)
      endif

      ::HighlightWindow(hWnd,.t.)
      //oWnd():oMsgBar:SetMsg(GetClassName(hWnd))

      ShowDatos( hWnd )
      lPrimera := .t.

      ::hWndOld := hWnd
   endif
else
   if !empty( ::cToolTip )
      ::ShowTooltip()
   endif
endif

return 0

/*****************************************************************************************/
   METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TSpy
/*****************************************************************************************/
local oMenu, oClp, a
local this := self
local oWndAux
local cCode
local oEditor
//local oDsgn
local hBmp := 0

if ::lCaptured

   if ::hWndOld != 0
   	::HighlightWindow( ::hWndOld,.f.)
   endif

   if ::hWndOld != 0

      do case
         case nRad == 1

              cCode   := ::GenCode( ::hWndOld )
              oEditor := NuevoCode()
              oEditor:AddText( cCode )

         case nRad == 4

              hWndMain := nil
              ::GenForm( ::hWndOld )
              //hBmp := CaptureWindow( ::hWndOld )
              //DibWrite( "prueba.bmp", DibFromBitmap( hBmp ) )
              //DeleteObject( hBmp )

              hWndMain := nil
              ::oWnd:End()
              oDlgShow := nil
      /*
      //::GenCode( ::hWndOld )
      //::SaveBmp( ::hWndOld )

      do case
         case ::nType == 0
              MENU oMenu POPUP
                 MENUITEM "Ver contenido" ACTION ( memowrit( "text.txt", ::GetItems( ::hWndOld ) ),;
                                   ShellExecute( GetActiveWindow() ,nil, cFilePath(GetModuleFileName(GetInstance())) + "text.txt",'','',5) )

                 MENUITEM "Copy Text"                                         ACTION ( oClp := TClipBoard():New(), if( oClp:Open(), ( oClp:SetText( GetWindowText( ::hWndOld ) ), oClp:Close()),),oClp:End())

                 MENUITEM "Copy Id:" + alltrim( str(GetDlgCtrlID ( ::hWndOld ))) ACTION ( oClp := TClipBoard():New(), if( oClp:Open(), ( oClp:SetText( alltrim(str(GetDlgCtrlID ( ::hWndOld ))) ), oClp:Close()),),oClp:End())
                 MENUITEM "Ver menu" ACTION ( memowrit( "text.txt", ::GetStrMenu( GetMenu( ::hWndOld ) )),;
                                      ShellExecute( GetActiveWindow() ,nil, cFilePath(GetModuleFileName(GetInstance())) + "text.txt",'','',5) )
                 //MENUITEM "Save as bmp" ACTION ( this:SaveBmp( this:hWndOld ), ShellExecute( GetActiveWindow() ,nil, cFilePath(GetModuleFileName(GetInstance())) + "screen.bmp",'','',5),oWnd:Hide() )
                 //MENUITEM "Copy bmp" ACTION ( this:CaptureWnd( this:hWndOld ), ShellExecute( GetActiveWindow() ,nil, "w.bmp",'','',5),oWnd:Hide() )

                 MENUITEM "Copy Código prg"  ACTION ( oClp := TClipBoard():New(), if( oClp:Open(), ( oClp:SetText( ::GenCode(this:hWndOld) ), oClp:Close()),),oClp:End())
                 //MENUITEM "Comparar ventanas"  ACTION ( ::CmpWnd(this:hWndOld) )

              ENDMENU

              a := GetCursorPos()
              a := ScreenToClient( ::oWnd:hWnd, a )

              ACTIVATE POPUP oMenu AT a[1], a[2] OF ::oWnd

         case ::nType == TESTPARTNER

              SendMessage ( this:hWndOld,nMiMensaje,10000,0)

         case ::nType == VERINFO

              ::oWnd:Hide()
              SysWait( 1 )
              SysRefresh()
              SendMessage ( this:hWndOld,nMiMensaje,10000,1)
              ::oWnd:Show()

         case ::nType == STOREINFO

              ::oWnd:Hide()
              SysWait( 1 )
              SysRefresh()
              SendMessage ( this:hWndOld,nMiMensaje,10000,2)
              ::oWnd:Show()

         case ::nType == SAVEBITMAP

              this:SaveBmp( this:hWndOld )
              ShellExecute( GetActiveWindow() ,nil, cFilePath(GetModuleFileName(GetInstance())) + "screen.bmp",'','',5)
              //oWnd:Hide()

         case ::nType == COPYBITMAP

              this:CaptureWnd( this:hWndOld )
              //CaptureWnd( this:hWndOld )
              //ShellExecute( GetActiveWindow() ,nil, "w.bmp",'','',5)
              //oWnd:Hide()

         case ::nType == CMPWND1
              DestroyIcon( ::hIco )
              ::hIco := LoadIcon( GetInstance(), "dialog" )
              ::Refresh()
              ::CmpWnd(this:hWndOld)

         case ::nType == CMPWND2

              DestroyIcon( ::hIco )
              ::hIco := LoadIcon( GetInstance(), "dialog" )
              ::Refresh()
              ::CmpWnd(this:hWndOld)
      */
      endcase

   endif

   ::hWndOld := 0

   CursorArrow()

   //SendMessage (hStatic,STM_SETIMAGE,IMAGE_BITMAP,(long)hBmpCross)
   ReleaseCapture()
   ::lCaptured := .f.

endif

return 0

#define LISTBOX_BASE    383

#define LB_ADDSTRING         ( LISTBOX_BASE +  1 )
#define LB_INSERTSTRING      ( LISTBOX_BASE +  2 )
#define LB_DELETESTRING      ( LISTBOX_BASE +  3 )
#define LB_RESETCONTENT      ( LISTBOX_BASE +  5 )
#define LB_SETSEL            ( LISTBOX_BASE +  6 )
#define LB_SETCURSEL         ( LISTBOX_BASE +  7 )
#define LB_GETSEL            ( LISTBOX_BASE +  8 )
#define LB_GETCURSEL         ( LISTBOX_BASE +  9 )

#define TCM_FIRST               0x1300      // Tab control messages
#define TCM_GETITEMCOUNT        (TCM_FIRST + 4)


/*****************************************************************************************/
   METHOD GetItems( hWnd ) CLASS TSpy
/*****************************************************************************************/
local cStr := ""
local nCount
local n
local cClassName := upper( GetClassName( hWnd ) )

do case
   case cClassName == "SYSTABCONTROL32"
        ? GetTcmText( hWnd )
   case cClassName == "SYSLISTVIEW32"
        //nCount := SendMessage( hWnd, TCM_GETITEMCOUNT )
        //for n := 1 to nCount
        //    cStr += GetTcmText( hWnd, n ) + CRLF
        //next


   case cClassName == "LISTBOX"
        nCount := SendMessage( hWnd, LB_GETCOUNT, 0, 0 )
        for n := 0 to nCount - 1
            cStr += GetLbxText( hWnd, n ) + CRLF
        next
endcase

return cStr



/*****************************************************************************************/
   METHOD GetStrMenu( hMenu  ) CLASS TSpy
/*****************************************************************************************/
local str := ""
local nCount
local n
local hSubMenu

if hMenu == 0
   return str
endif

nCount := GetmItemCount( hMenu )

for n := 0 to nCount - 1
    str += GetMenuString( hMenu, n ) + CRLF
    hSubMenu := GetSubMenu( hMenu, n )
    if hSubMenu != 0
       str += ::GetStrMenu( hSubMenu ) + CRLF
    endif
next

str := strtran( str, "&", "" )

return str


/*****************************************************************************************/
  METHOD SmallestWindowFromPoint( point ) CLASS TSpy
/*****************************************************************************************/
	local rect, rcTemp
	local hParent, hWnd, hTemp

	hWnd := WindowFromPoint( point[2], point[1] )
	if hWnd != 0

		rect := GetWndRect( hWnd )
		hParent := GetParent( hWnd )

		// Has window a parent?
		if hParent != 0

			// Search down the Z-Order
			hTemp := hWnd
			do while .t.

				hTemp  := GetWindow( hTemp, GW_HWNDNEXT )

				// Search window contains the point, hase the same parent, and is visible?
				rcTemp := GetWndRect( hTemp )
				if PtInRect( point[1],point[2], rcTemp  ) .and. GetParent(hTemp) == hParent .and. IsWindowVisible(hTemp)

					// Is it smaller?
					if (rcTemp[4] - rcTemp[2]) * (rcTemp[3] - rcTemp[1]) < ((rect[4] - rect[2]) * (rect[3] - rect[1]))
						// Found new smaller window!
						hWnd := hTemp
						rect := GetWndRect(hWnd)
					endif
				endif
				if hTemp == 0
				   exit
				endif
			enddo
		endif
	endif

	return hWnd





/*****************************************************************************************/
   METHOD HighlightWindow( hwnd, fDraw ) CLASS TSpy
/*****************************************************************************************/

   #define DINV                3
   local hdc
   local rc
   local bBorderOn
   bBorderOn := fDraw

   if hwnd == 0 .or. !IsWindow(hwnd)
       return 0
   endif

   hdc := GetWindowDC(hwnd)
   rc := GetWndRect(hwnd)
   rc := OffsetRect(rc, -rc[2], -rc[1])

   if (!IsRectEmpty(rc))

       PatBlt(hdc, rc[2], rc[1], rc[4] - rc[2], DINV,  DSTINVERT)
       PatBlt(hdc, rc[2], rc[3] - DINV, DINV, -(rc[3] - rc[1] - 2 * DINV), DSTINVERT)
       PatBlt(hdc, rc[4] - DINV, rc[1] + DINV, DINV, rc[3] - rc[1] - 2 * DINV, DSTINVERT)
       PatBlt(hdc, rc[4], rc[3] - DINV, -(rc[4] - rc[2]), DINV, DSTINVERT)

   endif

   ReleaseDC(hwnd, hdc)

return 0

*******************************************************************************************
   METHOD GetVarName( cClase ) CLASS TSpy
*******************************************************************************************
local cName, n
local nNum := 1
local lFind := .f.

if len( ::aVarNames ) == 0
   aadd( ::aVarNames, cClase + "1" )
   return ::aVarNames[1]
endif

for n := len( ::aVarNames ) to 1 step -1

    if lower(substr( ::aVarNames[n], 1, len( cClase ) )) == lower(cClase)
       nNum := val( right( ::aVarNames[n], 1 )) + 1
       cName := cClase + alltrim( str( nNum ) )
       aadd( ::aVarNames, cName )
       lFind := .t.
       exit
    endif

next

if !lFind
   cName := cClase + alltrim( str( nNum ) )
   aadd( ::aVarNames, cName )
endif

return cName

/*****************************************************************************************/
   METHOD GenCode( hwnd, lxChild, cFrom, lRC ) CLASS TSpy
/*****************************************************************************************/
local o, n, nLen, nStyle
local cFw := ""
local cRc := ""
local cAux
local hTemp
local cPrg := ""
local aRect
local cText, nTop, nLeft, nWidth, nHeight, cClass, nBottom, nRight
local hCtrl
local nUnits
local oDlg
local cStyle := ""
local cRCSty := ""
local cRCStyEx := ""
local nId
local cFileName
local cCurPath
local cOVar, cuVar

local lCaption      := .f.
local lPopup        := .f.
local lChild        := .f.
local lMinimize     := .f.
local lVisible      := .f.
local lDisable      := .f.
local lClipSiblings := .f.
local lClipChildren := .f.
local lMaximize     := .f.
local lBorder       := .f.
local lDlgFrame     := .f.
local lVScroll      := .f.
local lHScroll      := .f.
local lSysMenu      := .f.
local lThickFrame   := .f.
local lGroup        := .f.
local lTabStop      := .f.
local lMinimizeBox  := .f.
local lMaximizeBox  := .f.

nStyle  :=  GetWindowLong( hWnd, GWL_STYLE )

DEFAULT lxChild := .f.
DEFAULT cFrom  := "oDlg"

aRect   := GetCoors( hWnd )

nTop    := aRect[1]
nLeft   := aRect[2]
nWidth  := aRect[4]-aRect[2]
nHeight := aRect[3]-aRect[1]
nBottom := nTop + nHeight
nRight  := nLeft + nWidth


nUnits := GetDlgBaseUnits()
nLeft   = MulDiv(nLeft, 4, nLoWord(nUnits))
nTop    = MulDiv(nTop, 8, nHiWord(nUnits))
nRight  = MulDiv(nRight, 4, nLoWord(nUnits))
nBottom = MulDiv(nBottom, 8, nHiWord(nUnits))
nWidth  = nRight - nLeft
nHeight = nBottom - nTop


cText   := GetWindowText( hWnd )
cClass  := lower( GetClassName( hWnd ))

nID     := GetDlgCtrlID ( ::hWndOld )

if nID == 65535
   nID := -1
endif

//wqout2( GetStyles( hWnd ), cClass + cText )

do case
   case cClass == "static"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " SAY " + '"'+ cText + '" ;'+ CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF

   case cClass == "edit"

        coVar := ::GetVarName("oGet")
        cuVar := ::GetVarName("cVar")

        cPrg += space(7) + "@ " + strtrim( nTop )+ ", " + strtrim( nLeft ) + " GET " + coVar + " VAR " + cuVar + " ;"

        hTemp := GetWindow( hWnd, GW_CHILD )
        if hTemp != 0
           cPrg += space( 12 ) + "// Posiblemente se trate de TBtnGet"
        endif

        cPrg += CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF



   case cClass == "button"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BUTTON " + '"'+ cText + '" ;'+ CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom

        if at("cancel", lower(strtran(cText,"&",""))) != 0
           cPrg += ";" + CRLF
           cPrg += space(12) + " ACTION " + alltrim( cFrom ) + ":End()" + CRLF
        endif

        cPrg += CRLF


   case cClass == "listbox"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " LISTBOX "
        if SendMessage( hWnd, LB_GETCOUNT ) > 0
           cPrg += '"' + GetLbxText( hWnd, 0 ) + '"'
        endif
        cPrg += " ITEMS {"
        for n = 1 to SendMessage( hWnd, LB_GETCOUNT )

           if n > 1
              cPrg += ', '
           endif
           cPrg += '"' + GetLbxText( hWnd, n-1 ) + '"'
        next

        cPrg += " } ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "combobox"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " COMBOBOX "

        if SendMessage( hWnd, CB_GETCOUNT ) > 0
           cPrg += '"' + GetCbxText( hWnd, 0 ) + '"'
        endif

        cPrg += " ITEMS {"

        for n = 1 to SendMessage( hWnd, CB_GETCOUNT )

           if n > 1
              cPrg += ", "
           endif
           cPrg += '"' + GetCbxText( hWnd, n-1 ) + '"'
        next

        cPrg += " } ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "twbrowse"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " LISTBOX " + "FIELDS [<Flds,...>] ;" + CRLF
        cPrg += space(12) + "[ ALIAS <cAlias> ] ;" + CRLF
        cPrg += space(12) + "[ FIELDSIZES, SIZES, COLSIZES <aColSizes,...> ] ;" + CRLF
        cPrg += space(12) + "[ HEAD,HEADER,HEADERS,TITLE <aHeaders,...> ] ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "tbitmap"

        lMkDir( "almacen" )
        cCurPath := CurDrive() + ":\" + GetCurDir()
        cCurPath += if( right(cCurPath,1) != "\","\","") + "almacen\"
        cFileName := cNewFileName( cCurPath+"bmp", "bmp")
        ::SaveBmp2( hWnd, cFileName )

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BITMAP ;" + CRLF
        cPrg += space(12) + 'FILE "' + LFN2SFNEX( cFileName ) + '" ;' + CRLF
        cPrg += space(12) + "NOBORDER ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "ticon"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " ICON ;" + CRLF
        cPrg += space(12) + "[ NAME, RESNAME, RESOURCE <cResName> ] ;" + CRLF
        cPrg += space(12) + "[ FILENAME, FILE, DISK <cBmpFile> ] ;" + CRLF
        cPrg += space(12) + "[ BORDER ] ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "ttabs"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " TABS ;" + CRLF
        cPrg += space(12) + "[ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "tmeter"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " METER nActual ;"+ CRLF
        cPrg += space(12) + "[ TOTAL <nTotal> ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF


   case cClass == "tbtnbmp"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BTNBMP ;" + CRLF
        cPrg += space(12) + "[ <resource: NAME, RESNAME, RESOURCE> <cResName1> [,<cResName2>[,<cResName3>] ] ] ;" + CRLF
        cPrg += space(12) + "[ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>[,<cBmpFile3>] ] ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF


   case cClass == "msctls_updown32"

   case cClass == "tfolder"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " FOLDER  ;" + CRLF
        cPrg += space(12) + "OF " + cFrom + ";" + CRLF
        cPrg += space(12) + "PROMPT "

        nLen := ChildsCount( hWnd )

        for n := 1 to nLen
            if n > 1
               cPrg += ", "
            endif
            cPrg += "cDlgName" + strtrim( n )
        next

        cPrg += " PIXEL" + CRLF + CRLF

        n := 0
        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           n++
           cPrg += ::GenCode( hCtrl, .T., "oFolder:oDlgName" + strtrim( n ) )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo


   case cClass == "#32770" .or. cClass == "bordlg"

        aRect   := GetWndRect( hWnd )

        nTop    := aRect[1]
        nLeft   := aRect[2]
        nWidth  := aRect[4]-aRect[2]
        nHeight := aRect[3]-aRect[1]

        if !lxChild
           cPrg += "DEFINE DIALOG " + cFrom + " ;" + CRLF
           cPrg += space(7) + "FROM " + strtrim( nTop )+ ", " + strtrim( nLeft ) + " TO " + strtrim( nTop + nHeight ) + ", " + strtrim( nLeft + nWidth ) + " PIXEL ;" + CRLF
           cPrg += space(7) + 'TITLE "' + cText + '"'+ CRLF + CRLF
        endif

        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           nStyle := GetWindowLong( hCtrl, GWL_STYLE )

           cPrg += ::GenCode( hCtrl, .T., cFrom )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo

        if !lxChild
           cPrg += "ACTIVATE DIALOG " + cFrom
           cAux := ""
           for n := 1 to len( ::aVarNames )
               cAux += "local " + ::aVarNames[n] + CRLF
           next
           cAux += CRLF
           cPrg := cAux + cPrg

        endif



endcase

return cPrg

/*****************************************************************************************/
   //METHOD GenForm( hwnd, oDsgn, lExplore ) CLASS TSpy
   METHOD GenForm( hwnd, lExplore, oParent ) CLASS TSpy
/*****************************************************************************************/
local n, nLen, nStyle
local aRect, cPrg
local cText, nTop, nLeft, nWidth, nHeight, cClass, nBottom, nRight
local hCtrl
local nUnits
local oDlg
local nId
local cFileName
local cCurPath
local cOVar, cuVar
local cFrom  := "oDlg"
local oShape
local aPoint
local h
local rc

DEFAULT lExplore := .t.

aRect := GetWndRect( hwnd )

if oDsgn != nil
   aPoint := {aRect[1],aRect[2]}
   aPoint := ScreenToClient( hWndMain, aPoint )
   nTop  := aPoint[1] //+ 24//oDsgn:oForm:nHCaption
   nLeft := aPoint[2]
else
   nTop    := aRect[1]
   nLeft   := aRect[2]
endif

nWidth  := aRect[4]-aRect[2]
nHeight := aRect[3]-aRect[1]

nStyle := GetWindowLong( hWnd, GWL_STYLE )

//if oDsgn != nil
//   aRect := oDsgn:oForm:GetClientRect()
//   nTop  += aRect[1]
//   nLeft += 4
//endif

nBottom := nTop + nHeight
nRight  := nLeft + nWidth

cText   := GetWindowText( hWnd )
cClass  := lower( GetClassName( hWnd ))

nID     := GetDlgCtrlID ( ::hWndOld )

if nID == 65535
   nID := -1
endif


do case
   case cClass == "systabcontrol32"
        ? GetTcmText( hWnd )

   case cClass == "syslistview32"
        ? GetTcmText2( hWnd )

   case GetWindow( hWnd, GW_CHILD ) != 0 .and. cClass != "tcombobox" .and. lExplore .and. cClass != "combobox" .and. cClass != "tfolder"

        aRect   := GetWndRect( hWnd )

        nTop    := aRect[1]
        nLeft   := aRect[2]
        nWidth  := aRect[4]-aRect[2]
        nHeight := aRect[3]-aRect[1]

        if lPrimera
           hWndMain := hWnd
           oDsgn := Designer(,,nWidth+8, nHeight+8)
           oDsgn:SetSize( nWidth+8, nHeight+8, .t. )
           oDsgn:oWnd:cTitle := cText
           nTopWnd := nTop
           nLeftWnd := nLeft
           lPrimera := .f.
        else
           ::GenForm( hWnd, .f. )
        endif

        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           nStyle := GetWindowLong( hCtrl, GWL_STYLE )

           ::GenForm( hCtrl )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo

        oDsgn:Refresh()

   case cClass == "static" .or. cClass == "tsay" .or. cClass == "tlabel"

        if nAnd( nStyle, SS_ICON ) == SS_ICON .or. nAnd( nStyle, SS_BITMAP ) == SS_BITMAP
           lMkDir( "almacen" )
           cCurPath := CurDrive() + ":\" + GetCurDir()
           cCurPath += if( right(cCurPath,1) != "\","\","") + "almacen\"
           cFileName := cNewFileName( cCurPath+"bmp", "bmp")
           ::SaveBmp2( hWnd, cFileName )
           oShape := TDsgnImg():New( nTop,nLeft,nBottom,nRight, oDsgn )
           oShape:cFileName := cFileName
        else
           if nAnd( nStyle, SS_ETCHEDHORZ ) == SS_ETCHEDHORZ
           else
              if nAnd( nStyle, SS_ETCHEDVERT ) == SS_ETCHEDVERT
              else
                 oShape := TDsgnSay():New( nTop,nLeft,nBottom,nRight, oDsgn )
                 oShape:cCaption := cText
              endif
           endif
           if nAnd( nStyle, SS_RIGHT ) == SS_RIGHT
              oShape:cAlign := "Right"
           elseif nAnd( nStyle, SS_CENTER ) == SS_CENTER
              oShape:cAlign := "Center"
           else
              oShape:cAlign := "Left"
           endif
        endif

   case cClass == "edit" .or. cClass == "tget" .or. cClass == "tedit" .or. cClass == "tmemo" .or. cClass == "subedit"

        oShape := TDsgnEdit():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:cCaption := cText

   case cClass == "button"     .or. ;
        cClass == "tbutton"    .or. ;
        cClass == "tcheckbox"  .or. ;
        cClass == "tgroupbox"  .or. ;
        cClass == "tradio"

        if nAnd( nStyle, BS_GROUPBOX ) == BS_GROUPBOX .or. cClass == "tgroupbox"
           oShape := TDsgnGrp():New( nTop,nLeft,nBottom,nRight, oDsgn )
        else
           if ( nAnd( nStyle, BS_CHECKBOX ) == BS_CHECKBOX .or. nAnd( nStyle, BS_AUTOCHECKBOX ) == BS_AUTOCHECKBOX ) .or. cClass == "tcheckbox"
              oShape := TDsgnBtn():New( nTop,nLeft,nBottom,nRight, oDsgn, CHECK )
              oShape:lChecked := IsButtonChecked(hWnd)
           else
              if ( nAnd( nStyle, BS_RADIOBUTTON ) == BS_RADIOBUTTON .OR. nAnd( nStyle, BS_AUTORADIOBUTTON ) == BS_AUTORADIOBUTTON ) .or. cClass == "tradio"
                 oShape := TDsgnBtn():New( nTop,nLeft,nBottom,nRight, oDsgn, RADIODSGN )
                 oShape:lChecked := IsButtonChecked(hWnd)
              else
                 oShape := TDsgnBtn():New( nTop,nLeft,nBottom,nRight, oDsgn, BOTON )
              endif
           endif
        endif

        oShape:cCaption := cText


   case cClass == "listbox" .or. cClass == "tlistbox"

        oShape := TDsgnLbx():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:cCaption := cText

   case cClass == "combobox" .or. cClass == "tcombobox"

        oShape := TDsgnCbx():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:cCaption := cText
        h := hWndComboList( hWnd )
        if h != 0
           rc := GetWndRect( h )
           oShape:nHeight := rc[3]-rc[1]+21
        endif

   case cClass == "twbrowse"

        oShape := TDsgnBrowse():New( nTop, nLeft, nBottom, nRight, oDsgn )

   case cClass == "tbitmap" .or. cClass == "timage"

        lMkDir( "almacen" )
        cCurPath := CurDrive() + ":\" + GetCurDir()
        cCurPath += if( right(cCurPath,1) != "\","\","") + "almacen\"
        cFileName := cNewFileName( cCurPath+"bmp", "bmp")
        ::SaveBmp2( hWnd, cFileName )

        oShape := TDsgnImg():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:cFileName := cFileName

   case cClass == "ticon"

   case cClass == "ttabs"

   case cClass == "tmeter"

        oShape := TDsgnPrgBar():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:lVertical := nHeight > nWidth


   case cClass == "tbtnbmp"

        oShape := TDsgnBtn():New( nTop,nLeft,nBottom,nRight, oDsgn, BOTON )
        oShape:cCaption := cText


   case cClass == "tfolder"

        oShape := TDsgnFolder():New( nTop,nLeft,nBottom,nRight, oDsgn )

        nLen := ChildsCount( hWnd )

        for n := 1 to nLen
            oShape:AddPage()
        next



   case cClass == "msctls_trackbar32"

        oShape := TDsgnSlider():New( nTop,nLeft,nBottom,nRight, oDsgn )

        oShape:lVertical := nBottom - nTop > nRight - nLeft


   case cClass == "msctls_updown32"

        oShape := TDsgnScroll():New( nTop,nLeft,nBottom,nRight, oDsgn, .t. )

   case cClass == "syslistview32"

        oShape := TDsgnListView():New( nTop,nLeft,nBottom,nRight, oDsgn )
        oShape:nStyle := SendMessage( hWnd, LVM_GETVIEW, 0, 0 )

   case cClass == "systreeview32"

        oShape := TDsgnTreeView():New( nTop,nLeft,nBottom,nRight, oDsgn )

   case cClass == "toolbarwindow32"


//   case cClass == "#32770" .and. lower( GetClassName( hWnd )) .and. IsChildWindow( hWnd )


   //case cClass == "#32770" .or. cClass == "bordlg" .or. cClass == "twindow"  .or.;
   //     nAnd( nStyle, WS_CAPTION ) == WS_CAPTION  .or. cClass == "mdiclient"
   /*
   otherwise

        aRect   := GetWndRect( hWnd )

        nTop    := aRect[1]
        nLeft   := aRect[2]
        nWidth  := aRect[4]-aRect[2]
        nHeight := aRect[3]-aRect[1]

        if lPrimera
           oDsgn := Designer()
           oDsgn:SetSize( nWidth, nHeight, .t. )
           lPrimera := .f.
        endif

        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           nStyle := GetWindowLong( hCtrl, GWL_STYLE )

           ::GenForm( hCtrl, oDsgn )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo
        oDsgn:Refresh()
        */
endcase

return nil


/*****************************************************************************************/
   METHOD GenCodeRC( hwnd, lChild, cFrom ) CLASS TSpy
/*****************************************************************************************/
local o, n, nLen, nStyle
local c := ""
local cAux
local hTemp
local cPrg := ""
local aRect
local cText, nTop, nLeft, nWidth, nHeight, cClass
local hCtrl
local cStyle := ""

nStyle  :=  GetWindowLong( hWnd, GWL_STYLE )

DEFAULT lChild := .f.
DEFAULT cFrom  := ""


aRect   := GetCoors( hWnd )

nTop    := aRect[1]
nLeft   := aRect[2]
nWidth  := aRect[4]-aRect[2]
nHeight := aRect[3]-aRect[1]
cText   := GetWindowText( hWnd )

cClass := lower(GetClassName( hWnd ))

do case
   case cClass == "static"

        // comprobar el estilo


           if nAnd( nStyle, SS_CENTER ) == SS_CENTER
              cStyle += "SS_CENTER" + CRLF
           endif
           if nAnd( nStyle, SS_RIGHT ) == SS_RIGHT
              cStyle += "SS_RIGHT" + CRLF
           endif
           if nAnd( nStyle, SS_ICON ) == SS_ICON
              cStyle += "SS_ICON" + CRLF
           endif
           if nAnd( nStyle, SS_BLACKRECT ) == SS_BLACKRECT
              cStyle += "SS_BLACKRECT" + CRLF
           endif
           if nAnd( nStyle, SS_GRAYRECT ) == SS_GRAYRECT
              cStyle += "SS_GRAYRECT" + CRLF
           endif
           if nAnd( nStyle, SS_WHITERECT ) == SS_WHITERECT
              cStyle += "SS_WHITERECT" + CRLF
           endif
           if nAnd( nStyle, SS_BLACKFRAME ) == SS_BLACKFRAME
              cStyle += "SS_BLACKFRAME" + CRLF
           endif
           if nAnd( nStyle, SS_GRAYFRAME ) == SS_GRAYFRAME
              cStyle += "SS_GRAYFRAME" + CRLF
           endif
           if nAnd( nStyle, SS_WHITEFRAME ) == SS_WHITEFRAME
              cStyle += "SS_WHITEFRAME" + CRLF
           endif
           if nAnd( nStyle, SS_USERITEM ) == SS_USERITEM
              cStyle += "SS_USERITEM" + CRLF
           endif
           if nAnd( nStyle, SS_SIMPLE ) == SS_SIMPLE
              cStyle += "SS_SIMPLE" + CRLF
           endif
           if nAnd( nStyle, SS_LEFTNOWORDWRAP ) == SS_LEFTNOWORDWRAP
              cStyle += "SS_LEFTNOWORDWRAP" + CRLF
           endif
           if nAnd( nStyle, SS_OWNERDRAW ) == SS_OWNERDRAW
              cStyle += "SS_OWNERDRAW" + CRLF
           endif
           if nAnd( nStyle, SS_BITMAP ) == SS_BITMAP
              cStyle += "SS_BITMAP" + CRLF
           endif
           if nAnd( nStyle, SS_ENHMETAFILE ) == SS_ENHMETAFILE
              cStyle += "SS_ENHMETAFILE" + CRLF
           endif
           if nAnd( nStyle, SS_ETCHEDHORZ ) == SS_ETCHEDHORZ
              cStyle += "SS_ETCHEDHORZ" + CRLF
           endif
           if nAnd( nStyle, SS_ETCHEDVERT ) == SS_ETCHEDVERT
              cStyle += "SS_ETCHEDVERT" + CRLF
           endif
           if nAnd( nStyle, SS_ETCHEDFRAME ) == SS_ETCHEDFRAME
              cStyle += "SS_ETCHEDFRAME" + CRLF
           endif
           if nAnd( nStyle, SS_TYPEMASK ) == SS_TYPEMASK
              cStyle += "SS_TYPEMASK" + CRLF
           endif
           if nAnd( nStyle, SS_NOPREFIX ) == SS_NOPREFIX
              cStyle += "SS_NOPREFIX" + CRLF
           endif
           if nAnd( nStyle, SS_NOTIFY ) == SS_NOTIFY
              cStyle += "SS_NOTIFY" + CRLF
           endif
           if nAnd( nStyle, SS_CENTERIMAGE ) == SS_CENTERIMAGE
              cStyle += "SS_CENTERIMAGE" + CRLF
           endif
           if nAnd( nStyle, SS_RIGHTJUST ) == SS_RIGHTJUST
              cStyle += "SS_RIGHTJUST" + CRLF
           endif
           if nAnd( nStyle, SS_REALSIZEIMAGE ) == SS_REALSIZEIMAGE
              cStyle += "SS_REALSIZEIMAGE" + CRLF
           endif
           if nAnd( nStyle, SS_SUNKEN ) == SS_SUNKEN
              cStyle += "SS_SUNKEN" + CRLF
           endif
           if nAnd( nStyle, SS_ENDELLIPSIS ) == SS_ENDELLIPSIS
              cStyle += "SS_ENDELLIPSIS" + CRLF
           endif
           if nAnd( nStyle, SS_PATHELLIPSIS ) == SS_PATHELLIPSIS
              cStyle += "SS_PATHELLIPSIS" + CRLF
           endif
           if nAnd( nStyle, SS_WORDELLIPSIS ) == SS_WORDELLIPSIS
              cStyle += "SS_WORDELLIPSIS" + CRLF
           endif
           if nAnd( nStyle, SS_ELLIPSISMASK ) == SS_ELLIPSISMASK
              cStyle += "SS_ELLIPSISMASK" + CRLF
           endif

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " SAY " + '"'+ cText + '" ;'+ CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF

   case cClass == "edit"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " GET " + '"cVar" ;'+ CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "button"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BUTTON " + '"'+ cText + '" ;'+ CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "listbox"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " LISTBOX "
        if SendMessage( hWnd, LB_GETCOUNT ) > 0
           cPrg += '"' + GetLbxText( hWnd, 0 ) + '"'
        endif
        cPrg += " ITEMS {"
        for n = 1 to SendMessage( hWnd, LB_GETCOUNT )

           if n > 1
              cPrg += ', '
           endif
           cPrg += '"' + GetLbxText( hWnd, n-1 ) + '"'
        next

        cPrg += " } ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "combobox"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " COMBOBOX "

        if SendMessage( hWnd, CB_GETCOUNT ) > 0
           cPrg += '"' + GetCbxText( hWnd, 0 ) + '"'
        endif

        cPrg += " ITEMS {"

        for n = 1 to SendMessage( hWnd, CB_GETCOUNT )

           if n > 1
              cPrg += ", "
           endif
           cPrg += '"' + GetCbxText( hWnd, n-1 ) + '"'
        next

        cPrg += " } ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "twbrowse"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " LISTBOX " + "FIELDS [<Flds,...>] ;" + CRLF
        cPrg += space(12) + "[ ALIAS <cAlias> ] ;" + CRLF
        cPrg += space(12) + "[ FIELDSIZES, SIZES, COLSIZES <aColSizes,...> ] ;" + CRLF
        cPrg += space(12) + "[ HEAD,HEADER,HEADERS,TITLE <aHeaders,...> ] ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "tbitmap"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BITMAP ;" + CRLF
        cPrg += space(12) + "[ NAME, RESNAME, RESOURCE <cResName> ] ;" + CRLF
        cPrg += space(12) + "[ FILENAME, FILE, DISK <cBmpFile> ] ;" + CRLF
        cPrg += space(12) + "[ NOBORDER, NO BORDER ] ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "ticon"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " ICON ;" + CRLF
        cPrg += space(12) + "[ NAME, RESNAME, RESOURCE <cResName> ] ;" + CRLF
        cPrg += space(12) + "[ FILENAME, FILE, DISK <cBmpFile> ] ;" + CRLF
        cPrg += space(12) + "[ BORDER ] ;" + CRLF
        cPrg += space(12) + "SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "ttabs"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " TABS ;" + CRLF
        cPrg += space(12) + "[ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF+ CRLF

   case cClass == "tmeter"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " METER nActual ;"+ CRLF
        cPrg += space(12) + "[ TOTAL <nTotal> ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF


   case cClass == "tbtnbmp"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " BTNBMP ;" + CRLF
        cPrg += space(12) + "[ <resource: NAME, RESNAME, RESOURCE> <cResName1> [,<cResName2>[,<cResName3>] ] ] ;" + CRLF
        cPrg += space(12) + "[ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>[,<cBmpFile3>] ] ] ;" + CRLF
        cPrg += space(12) + " SIZE " + strtrim( nWidth ) + ", " + strtrim( nHeight ) + " PIXEL OF " + cFrom + CRLF + CRLF


   case cClass == "tfolder"

        cPrg += space(7) + "@ " + strtrim( nTop )+", " + strtrim( nLeft ) + " FOLDER  ;" + CRLF
        cPrg += space(12) + "OF oDlg ;" + CRLF
        cPrg += space(12) + "PROMPT "

        nLen := ChildsCount( hWnd )

        for n := 1 to nLen
            if n > 1
               cPrg += ", "
            endif
            cPrg += "cDlgName" + strtrim( n )
        next

        cPrg += " PIXEL" + CRLF + CRLF

        n := 0
        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           n++
           cPrg += ::GenCode( hCtrl, .T., "oFolder:oDlgName" + strtrim( n ) )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo


   case cClass == "#32770"

        aRect   := GetWndRect( hWnd )

        nTop    := aRect[1]
        nLeft   := aRect[2]
        nWidth  := aRect[4]-aRect[2]
        nHeight := aRect[3]-aRect[1]

        if !lChild
           cPrg += "DEFINE WINDOW oDlg ;" + CRLF
           cPrg += space(7) + "FROM " + strtrim( nTop )+ ", " + strtrim( nLeft ) + " TO " + strtrim( nTop + nHeight ) + ", " + strtrim( nLeft + nWidth ) + " PIXEL ;" + CRLF
           cPrg += space(7) + 'TITLE "' + cText + '"'+ CRLF + CRLF
        endif

        hCtrl := GetWindow( hWnd, GW_CHILD )

        do while hCtrl != 0

           nStyle := GetWindowLong( hCtrl, GWL_STYLE )

           cPrg += ::GenCode( hCtrl, .T., if( empty(cFrom), "oDlg", cFrom ) )

           hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )

        enddo

        if !lChild
           cPrg += "ACTIVATE WINDOW oDlg "
           MemoWrit( "cCode.prg", cPrg )
        endif

endcase

return cPrg




METHOD GenDbfRC( cDbfName, nFiles ) CLASS TSpy

	local n, nId := 110
	local cRC := "", cCH := "", cButton := ""
	local aFields, cRow
	local cRCFile := ""
	local lButton := .F.
	local nMax := 0

	if Empty( cDbfName ) .or. ! File( cDbfName )
		MsgAlert( "Please select a DBF file first!" )
		return nil
	endif

	cursorwait()

	USE ( cDbfName )
	aFields = DbStruct()

   for n := 1 to len( aFields )
       nMax := max( nMax, 45 + aFields[ n ][ 3 ] * 7 )
   next

   nMax += 4

   nMax := max( 300, nMax )

   cRC += '#include "..\include\WinApi.ch"' + CRLF
   cRC += '//#define DS_MODALFRAME       0x80L' + CRLF
	cRC += Alias() + " DIALOG 32, 18, " + alltrim(str(nMax,4)) + " ," + Str( ( Len( aFields ) * 14)+43) + CRLF
	cRC += "STYLE DS_MODALFRAME | WS_POPUP | WS_CAPTION | WS_SYSMENU" + CRLF
	cRC += 'CAPTION "' + Alias() + '"' + CRLF
	cRC += 'FONT 8, "MS Sans Serif"' + CRLF
	cRC += "BEGIN" + CRLF

	for n = 1 to Len( aFields )
  		cRC += "#define ID_" + PadR( aFields[ n ][ 1 ], 11 ) + Str( nId, 4 ) + CRLF
      nID += 10
   next

   nID := 110
	for n = 1 to Len( aFields )

		do case

			case aFields[ n ][ 2 ] $ "CND"
				cRC += '   LTEXT "' + Upper(left(aFields[ n ][ 1 ],1))+ lower(substr(aFields[ n ][ 1 ],2)) + '"' + ;
					Space( 10 - Len( aFields[ n ][ 1 ] ) ) + ", -1, 3," + Str( 5 + 14 * ( n - 1 ), 4 ) + ", 41, 8" + CRLF

				cRC += "   EDITTEXT ID_" + aFields[ n ][ 1 ] + ;
					", 45," + Str( 3 + 14 * ( n - 1 ), 4 ) + ", " + ;
					Str( aFields[ n ][ 3 ] * 7, 4 ) + ", 12" + CRLF

			case aFields[ n ][ 2 ] == "L"
				cRC += '   CONTROL "' + aFields[ n ][ 1 ] + ;
					'", ID_' + aFields[ n ][ 1 ] + ;
					', "BUTTON", BS_AUTOCHECKBOX | WS_CHILD | WS_VISIBLE | WS_TABSTOP, ' + ;
					"45, " + Str( 3 + 14 * ( n - 1 ), 4 ) + ;
					", 50, 12" + CRLF

			case aFields[ n ][ 2 ] == "M"
				cRC += '   LTEXT "' + aFields[ n ][ 1 ] + '"' + ;
					Space( 10 - Len( aFields[ n ][ 1 ] ) ) + ", -1, 100," + ;
					Str( 5 + 14 * ( n - 1 ), 4 ) + ", 41, 8" + CRLF

				//            cRC += '   CONTROL "' + aFields[ n ][ 1 ] + ;
				cRC += '   CONTROL "' + "" + ;
					'", ID_' + aFields[ n ][ 1 ] + ;
					', "EDIT", ES_LEFT | ES_MULTILINE | ES_WANTRETURN | WS_CHILD | WS_VISIBLE | WS_BORDER | WS_VSCROLL | WS_TABSTOP , ' + ;
					"145, " + Str(3 + 14 * ( n - 1 ), 4 ) + ", "  + "77, 63" + CRLF
				//^^^ gotta put out to the right somewhere so you can see it
				//    and not sit under a bunch of other controls
		endcase

		nId += 10

	next


		cRow := alltrim(str(len(aFields)*14+12))
		cRC += 'PUSHBUTTON "|<", ' + alltrim(str(nId   ))+ ',   50, ' + cRow +', 37, 12   '     + CRLF
		cRC += 'PUSHBUTTON "<", ' + alltrim(str(nId+=10))+ ',   99, ' + cRow +', 37, 12   '     + CRLF
		cRC += 'PUSHBUTTON ">", ' + alltrim(str(nId+=10))+ ',  148, ' + cRow +', 37, 12   '     + CRLF
		cRC += 'PUSHBUTTON ">|", ' + alltrim(str(nId+=10))+ ', 197, ' + cRow +', 37, 12   '     + CRLF
		cRC += 'PUSHBUTTON "Ok", ' + alltrim(str(nId+=10))+ ', 246, ' + cRow +', 37, 12   '     + CRLF

	cRC += "END" + CRLF

	//MemoWrit( Alias() + ".ch", cCH )


	USE

return nil

/************************************************************************************/
  METHOD GenDbfPrg( cDbfName, nType  ) CLASS TSpy
/************************************************************************************/

	local n, nId := 110
	local cPrg := "", cCH := "", cButton := ""
	local aFields, cRow
	local cPrgFile := ""
	local lButton := .F.
	local nMax := 0
	local cAux, cVar, coVar
	local acVars := {}

	if Empty( cDbfName ) .or. ! File( cDbfName )
		MsgAlert( "Please select a DBF file first!" )
		return nil
	endif

	cursorwait()

	USE ( cDbfName )
	aFields = DbStruct()

   for n := 1 to len( aFields )
       nMax := max( nMax, 45 + aFields[ n ][ 3 ] * 7 )
   next

   nMax += 4


   for n := 1 to len( aFields )
		cPrg += "#define ID_" + PadR( aFields[ n ][ 1 ], 11 ) + Str( nId, 4 ) + CRLF
		nId+=10
   next
   nId := 110

   cPrg += CRLF

   cPrg += '#include "Fivewin.ch"' + CRLF
   cPrg += CRLF
   cPrg += CRLF
   cPrg += "Function main()" + CRLF
   cPrg += CRLF

   for n := 1 to len( aFields )
       cVar  :=  lower( aFields[ n ][ 2 ]) + Upper(left(aFields[ n ][ 1 ],1))+ lower(substr(aFields[ n ][ 1 ],2))
       coVar := "o" + Upper(left(aFields[ n ][ 1 ],1))+ lower(substr(aFields[ n ][ 1 ],2))
       cPrg += "local " + coVar + CRLF
       cPrg += "local " + cVar + " := "
       aadd( acVars, {cVar, nId, coVar } )
       nId += 10

       do case
          case aFields[ n ][ 2 ] == "C"
               cPrg += 'space(' + alltrim( str(aFields[ n ][ 3 ]))+ ')' + CRLF
          case aFields[ n ][ 2 ] == "D"
               cPrg += 'ctod("  -  -    ")' + CRLF
          case aFields[ n ][ 2 ] == "N"
               cAux := space(aFields[ n ][ 3 ])
               cAux := strtran( cAux, " ","0" )
               if aFields[ n ][ 4 ] != 0
                  cAux := left( cAux, aFields[ n ][ 3 ] - aFields[ n ][ 4 ]-1) + "." + substr( cAux,aFields[ n ][ 3 ] - aFields[ n ][ 4 ]+1)
               endif
               cPrg += cAux + CRLF
          case aFields[ n ][ 2 ] == "L"
               cPrg += ".f." + CRLF
       endcase

   next

   for n := 1 to 5
       cVar := "oBtn" +alltrim(str(nId))
       cPrg += "local " + cVar + CRLF
       aadd( acVars, {cVar, nId }  )
       nId+=10
   next

   cPrg += CRLF
   cPrg += 'local oDlg' + CRLF
   cPrg += 'local dateformat := set( _SET_DATEFORMAT, "dd-mm-yyyy" )' + CRLF
   cPrg += CRLF

   cPrg += 'DEFINE DIALOG oDlg NAME ' + '"' + Alias() + '"' + CRLF + CRLF

	for n = 1 to Len( aFields )


		do case

			case aFields[ n ][ 2 ] $ "CND"

              cPrg += '       REDEFINE GET ' + acVars[n,3] + " VAR " + acVars[n,1] + ' ID ' + alltrim(str(acVars[n][2])) +  " OF oDlg " + CRLF

			case aFields[ n ][ 2 ] == "L"

              cPrg += '       REDEFINE CHECKBOX ' + acVars[n,3]  + " VAR " + acVars[n,1] + ' ID ' + alltrim(str(acVars[n][2])) + " OF oDlg " + CRLF

			case aFields[ n ][ 2 ] == "M"

              cPrg += '       REDEFINE GET ' + acVars[n,3]  + " VAR " + acVars[n,1] + ' ID ' + alltrim(str(acVars[n][2])) + " OF oDlg ;" + CRLF
              cPrg += '                MULTILINE' + CRLF

		endcase

	next

   cPrg += '       REDEFINE BUTTON ' + acVars[len(acVars)-4][1] + ' ID ' + alltrim(str(acVars[len(acVars)-4][2])) + ' OF oDlg ACTION GoTop()' + CRLF
   cPrg += '       REDEFINE BUTTON ' + acVars[len(acVars)-3][1] + ' ID ' + alltrim(str(acVars[len(acVars)-3][2])) + ' OF oDlg ACTION GoUp()' + CRLF
   cPrg += '       REDEFINE BUTTON ' + acVars[len(acVars)-2][1] + ' ID ' + alltrim(str(acVars[len(acVars)-2][2])) + ' OF oDlg ACTION GoDown()' + CRLF
   cPrg += '       REDEFINE BUTTON ' + acVars[len(acVars)-1][1] + ' ID ' + alltrim(str(acVars[len(acVars)-1][2])) + ' OF oDlg ACTION GoBottom()' + CRLF
   cPrg += '       REDEFINE BUTTON ' + acVars[len(acVars)  ][1] + ' ID ' + alltrim(str(acVars[len(acVars)  ][2])) + ' OF oDlg ACTION oDlg:End()' + CRLF

   cPrg += CRLF
   cPrg += 'ACTIVATE DIALOG oDlg CENTERED'+ CRLF
   cPrg += CRLF

   cPrg += 'set( _SET_DATEFORMAT, dateformat )' + CRLF

   cPrg += CRLF
  	cPrg += 'return nil'     + CRLF

   cPrg += CRLF
   cPrg += CRLF
   cPrg += "Function GoTop( acVars )" + CRLF
   cPrg += CRLF
   cPrg += "return nil" + CRLF

   cPrg += CRLF
   cPrg += CRLF
   cPrg += "Function GoUp( acVars )" + CRLF
   cPrg += CRLF
   cPrg += "return nil" + CRLF

   cPrg += CRLF
   cPrg += CRLF
   cPrg += "Function GoDown( acVars )" + CRLF
   cPrg += CRLF
   cPrg += "return nil" + CRLF

   cPrg += CRLF
   cPrg += CRLF
   cPrg += "Function GoBottom( acVars )" + CRLF
   cPrg += CRLF
   cPrg += "return nil" + CRLF


	//MemoWrit( Alias() + ".ch", cCH )
	MemoWrit( "_"+alias() + ".prg", cPrg )

	USE

return nil



METHOD TakeDrop( aFiles ) CLASS TSpy

   local n, lBrowsed := .F.

   //return ::BuscaRel( aFiles )

  do case
     case ::nType == CMPWND1
     case ::nType == CMPWND2

     otherwise
          for n = 1 to Len( aFiles )
             if upper(Right( aFiles[ 1 ], 3 )) != "DBF"
                MsgAlert( "Solo ficheros dbf!!!" )
             else
       		   cursorwait()
       		   ::GenDbfRc(aFiles[ n ], 1  )
       		   ::GenDbfPrg(aFiles[ n ], 1  )
       	      cursorarrow()
             endif
          next
  endcase
return nil

/************************************************************************************/
   METHOD BuscaRel( aFiles ) CLASS TSpy
/************************************************************************************/
local n, n2
local oFile, oFile2

asize( ::aoFiles, 0 )

for n := 1 to len( aFiles )
    aadd( ::aoFiles, TRelDbf():New( aFiles[n] ) )
next


for n := 1 to len( ::aoFiles )
    oFile := ::aoFiles[n]
    for n2 := 1 to len( ::aoFiles )
        oFile2 := ::aoFiles[n2]
        if !(oFile == oFile2)
           oFile:BuscaRel( oFile2 )
        endif
    next
next

for n := 1 to len( ::aoFiles )
    for n2 := 1 to len( ::aoFiles[n]:aRelaciones )
        ? "Posible relación entre " + cFileName( ::aoFiles[n]:cDbfName ) + " y " + ::aoFiles[n]:aRelaciones[n2,1] ,;
          "por los campos " + ::aoFiles[n]:aRelaciones[n2,2]
    next
next


return nil

*******************************************************************************************
  METHOD CaptureWnd( hWnd ) CLASS TSpy
*******************************************************************************************

WndCopy2( hWnd, 45 )


return nil


*******************************************************************************************
   METHOD CmpWnd( hWnd ) CLASS TSpy
*******************************************************************************************
local aControls1 := {}
local aControls2 := {}
local hCtrl := 0
local oDlg, oLbx1, oLbx2
local cVar1, cVar2
local aItem1 := {}
local aItem2 := {}
local o := self
local cText
local n

if ::hWndCmp1 == 0
   ::hWndCmp1 := hWnd
   DibWrite( "screen1.bmp", DibFromBitmap( WndBitmap( ::hWndCmp1 ) ) )
   MsgInfo( "Seleccione la siguiente ventana" )
   return nil
endif

::hWndCmp2 := hWnd
DibWrite( "screen2.bmp", DibFromBitmap( WndBitmap( ::hWndCmp2 ) ) )

 // ::hWndCmp1
 hCtrl := GetWindow( ::hWndCmp1, GW_CHILD )
 do while hCtrl != 0
    cText := GetWindowText( hCtrl )
    if !empty( ctext )
       aadd( aControls1, cText   )
    endif
    hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )
 enddo

 hCtrl := 0
 // ::hWndCmp2
 hCtrl := GetWindow( ::hWndCmp2, GW_CHILD )
 do while hCtrl != 0
    cText := GetWindowText( hCtrl )
    if !empty( ctext )
       aadd( aControls2, cText   )
    endif

    hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )
 enddo

 if !empty( aControls1 ) .and. !empty( aControls2 )

    DEFINE DIALOG oDlg ;
          FROM 110, 96 TO 526, 804 PIXEL ;
          TITLE "Comparar ventanas"

          @ 133, 286 BUTTON "OK" ;
                SIZE 44, 11 PIXEL OF oDlg  ACTION oDlg:End()

          @ 147, 286 BUTTON "Cancel" ;
                SIZE 44, 12 PIXEL OF oDlg  ACTION oDlg:End()

          @ 162, 286 BUTTON "Help" ;
                SIZE 44, 11 PIXEL OF oDlg

          @ 17, 22 LISTBOX  oLbx1 VAR aControls1[1] ITEMS aControls1 ;
                SIZE 121, 157 PIXEL OF oDlg

          @ 17, 149 LISTBOX oLbx2 VAR aControls2[1] ITEMS aControls2 ;
                SIZE 121, 157 PIXEL OF oDlg

          @ 17, 286 BUTTON "Comparar" ;
                SIZE 44, 12 PIXEL OF oDlg ACTION o:Comparar( aControls1, aControls2 )

          @ 31, 286 BUTTON "Visual" ;
                SIZE 44, 12 PIXEL OF oDlg ACTION o:CmpVisual()

   ACTIVATE DIALOG oDlg
else
   MsgInfo( "Una de las ventanas no tiene controles o no se encuentra abierta" )
endif
::hWndCmp1 := 0
::hWndCmp2 := 0


for n := 1 to len( ::oWnd:aControls )
    o := ::oWnd:aControls[n]
    if o:ClassName() == "TSPY" .and. ( o:nType == CMPWND1 .OR. o:nType == CMPWND2 )
       DestroyIcon( o:hIco )
       o:hIco := LoadIcon( GetInstance(), "dlgempty" )
       o:Refresh()
    endif
next

return nil


/************************************************************************************/
   METHOD CmpVisual( ) CLASS TSpy
/************************************************************************************/
local oDlg, oBmp1, oBmp2
local aRect1 := GetWndRect( ::hWndCmp1 )
local aRect2 := GetWndRect( ::hWndCmp2 )


DEFINE DIALOG oDlg TITLE "Comparación visual de las ventanas - Pincha en la imagen"

     @ 0, 0 BITMAP oBmp1 FILE "screen1.bmp" OF oDlg SIZE aRect1[4]-aRect1[2], aRect1[3]-aRect1[1] PIXEL NOBORDER ON CLICK (oBmp1:Hide(), oBmp2:Show())
     @ 0, 0 BITMAP oBmp2 FILE "screen2.bmp" OF oDlg SIZE aRect2[4]-aRect2[2], aRect2[3]-aRect2[1] PIXEL NOBORDER ON CLICK (oBmp2:Hide(), oBmp1:Show())

ACTIVATE DIALOG oDlg CENTERED ON INIT (  oDlg:SetSize( max(oBmp1:nWidth, oBmp2:nWidth), max( oBmp1:nHeight + 24,oBmp2:nHeight + 24), .t. ),oBmp2:Hide() ) //

return nil

/************************************************************************************/
   METHOD Comparar( a1, a2 ) CLASS TSpy
/************************************************************************************/
local n, n2
local c1, c2, cStr := ""
local lFind := .f.

for n := 1 to len( a1 )
    lFind := .f.
    c1 := a1[n]
    for n2 := 1 to len( a2 )
        if c1 == a2[n2]
           lFind := .t.
           exit
        endif
    next
    if !lFind
       cStr += c1 + CRLF
    endif
next

MemoEdit( cStr, "Cadenas que estan en la primera y no en la segunda ventana" )

cStr := ""
for n := 1 to len( a2 )
    lFind := .f.
    c1 := a2[n]
    for n2 := 1 to len( a1 )
        if c1 == a1[n2]
           lFind := .t.
           exit
        endif
    next
    if !lFind
       cStr += c1 + CRLF
    endif
next

MemoEdit( cStr, "Cadenas que estan en la segunda ventana y no en la primera" )


return nil

/*****************************************************************************************/
   METHOD Capturador() CLASS TSpy
/*****************************************************************************************/
local oBrush
local oCursor

local o := self
local hBmp

   if hBmpDesk != nil
      DeleteObject( hBmpDesk )
   endif

   hBmpDesk := WndCopy4( GetDeskTopWindow(), GetWndRect(GetDeskTopWindow()) )


 DEFINE CURSOR oCursor CROSS

 DEFINE BRUSH oBrush STYLE "NULL"
 syswait(0.3)

 DEFINE WINDOW ::oGost FROM 0, 0 TO GetSysMetrics( 1 ), GetSysMetrics( 0 ) PIXEL STYLE WS_POPUP  CURSOR oCursor BRUSH oBrush

        ::lGostCapture := .f.
        ::aRect := {0,0,0,0}
        ::oGost:bLClicked  := {| nRow, nCol | o:aPos := {nRow, nCol}, o:oGost:Capture(), o:lGostCapture := .t. }
        ::oGost:bMMoved    := {| nRow, nCol | o:MoveGost( nRow, nCol ) }
        ::oGost:bLButtonUp := {| nRow, nCol | o:BtnUpGost() }
        ::oGost:bPainted   := {| hDC | o:Pinta( hDC ) }

 ::oGost:Show()

 return nil

/*****************************************************************************************/
   METHOD Pinta( hDC ) CLASS TSpy
/*****************************************************************************************/

DrawBitmap( hDC, hBmpDesk, 0, 0 )

return nil



/*****************************************************************************************/
   METHOD MoveGost( nRow, nCol ) CLASS TSpy
/*****************************************************************************************/

if ::lGostCapture

   DrawFocusRect( ::oGost:GetDC(), ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] )

   if nRow < ::aPos[1]
      ::aRect[1] := nRow
      ::aRect[3] := ::aPos[1]
   else
      ::aRect[3] := nRow
      ::aRect[1] := ::aPos[1]
   endif

   if nCol < ::aPos[2]
      ::aRect[2] := nCol
      ::aRect[4] := ::aPos[2]
   else
      ::aRect[4] := nCol
      ::aRect[2] := ::aPos[2]
   endif

   DrawFocusRect( ::oGost:hDC, ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] )

   ::oGost:ReleaseDC()

endif

return nil



/*****************************************************************************************/
   METHOD BtnUpGost() CLASS TSpy
/*****************************************************************************************/
local hBmp

::lGostCapture := .f.
DrawFocusRect( ::oGost:GetDC(), ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] )
::oGost:ReleaseDC()
hBmp := WndCopy4( ::oGost:hWnd, {::aRect[1]+1, ::aRect[2]+1, ::aRect[3]-1, ::aRect[4]-1} )

::SaveBmp(, hBmp  )

DeleteObject( hBmp )
ReleaseCapture()
::oGost:End()

ShellExecute( GetActiveWindow() ,nil, cFilePath(GetModuleFileName(GetInstance())) + "screen.bmp",'','',5)
::oWnd:Show()
::oWnd:Move( 10, 10,,,.f.)
SysRefresh()

return nil


/************************************************************************************/
/************************************************************************************/
/************************************************************************************/

CLASS TRelDbf

      DATA aStruct
      DATA cDbfName
      DATA aRelaciones

      METHOD New( cDbfName ) CONSTRUCTOR
      METHOD Igual( oRelDbf2 ) OPERATOR "=="
      METHOD BuscaRel( oRelDbf2 )

ENDCLASS


/*************************************************************************/
   METHOD New( cDbfName ) CLASS TRelDbf
/*************************************************************************/

   ::cDbfName := cDbfName
   USE ( cDbfName )
   ::aStruct :=  DbStruct()
   USE
   ::aRelaciones := {}

return self


/*************************************************************************/
   METHOD Igual( oRelDbf2 ) CLASS TRelDbf
/*************************************************************************/
local n, n2, n3, n4
local lIguales := .t.

if len( ::aStruct ) != len( oRelDbf2:aStruct )
   return .f.
endif

for n := 1 to len( ::aStruct )
    for n2 := 1 to 4
        if ::aStruct[n,n2] != oRelDbf2:aStruct[n, n2]
           lIguales := .f.
           exit
        endif
    next
    if !lIguales
       exit
    endif
next

return lIguales


/*************************************************************************/
  METHOD BuscaRel( oRelDbf2 ) CLASS TRelDbf
/*************************************************************************/
local n, n2, n3
local lIguales := .f.
local cCampo
local cTipo
local nLen
local nDec


for n := 1 to len( ::aStruct )
    cCampo := ::aStruct[n,1]
    cTipo  := ::aStruct[n,2]
    nLen   := ::aStruct[n,3]
    nDec   := ::aStruct[n,4]

    if  cTipo == "L" .or. cTipo == "M"
        loop
    endif

    for n2 := 1 to len( oRelDbf2:aStruct )
        lIguales := .t.
        for n3 := 1 to 4
            if ::aStruct[n,n3] != oRelDbf2:aStruct[n2, n3]
               lIguales := .f.
               exit
            endif
        next
        if lIguales
           aadd( ::aRelaciones, { oRelDbf2:cDbfName, cCampo, cTipo, nLen, nDec } )
        endif
    next
next

return nil



























static function OffsetRect( rc, x, y )

rc[1] := rc[1] + y
rc[2] := rc[2] + x
rc[3] := rc[3] + y
rc[4] := rc[4] + x

return rc


function strtrim( nVal ) ; return alltrim( str( nVal ))

static function GetStyles( hWnd )


local aCtrlStyles := {;
	{ "Button", "BS_PUSHBUTTON",BS_PUSHBUTTON},;
	{ "Button", "BS_DEFPUSHBUTTON",BS_DEFPUSHBUTTON},;
	{ "Button", "BS_CHECKBOX",BS_CHECKBOX},;
	{ "Button", "BS_AUTOCHECKBOX",BS_AUTOCHECKBOX},;
	{ "Button", "BS_RADIOBUTTON",BS_RADIOBUTTON},;
	{ "Button", "BS_3STATE",BS_3STATE},;
	{ "Button", "BS_AUTO3STATE",BS_AUTO3STATE},;
	{ "Button", "BS_GROUPBOX",BS_GROUPBOX},;
	{ "Button", "BS_USERBUTTON",BS_USERBUTTON},;
	{ "Button", "BS_AUTORADIOBUTTON",BS_AUTORADIOBUTTON},;
	{ "Button", "BS_OWNERDRAW",BS_OWNERDRAW},;
	{ "Button", "BS_LEFTTEXT",BS_LEFTTEXT},;
	{ "Button", "BS_TEXT",BS_TEXT},;
	{ "Button", "BS_ICON",BS_ICON},;
	{ "Button", "BS_BITMAP",BS_BITMAP},;
	{ "Button", "BS_LEFT",BS_LEFT},;
	{ "Button", "BS_RIGHT",BS_RIGHT},;
	{ "Button", "BS_CENTER",BS_CENTER},;
	{ "Button", "BS_TOP",BS_TOP},;
	{ "Button", "BS_BOTTOM",BS_BOTTOM},;
	{ "Button", "BS_VCENTER",BS_VCENTER},;
	{ "Button", "BS_PUSHLIKE",BS_PUSHLIKE},;
	{ "Button", "BS_MULTILINE",BS_MULTILINE},;
	{ "Button", "BS_NOTIFY",BS_NOTIFY},;
	{ "Button", "BS_FLAT",BS_FLAT},;
	{ "Button", "BS_RIGHTBUTTON",BS_RIGHTBUTTON},;
	{ "Static", "SS_LEFT",SS_LEFT},;
	{ "Static", "SS_CENTER",SS_CENTER},;
	{ "Static", "SS_RIGHT",SS_RIGHT},;
	{ "Static", "SS_ICON",SS_ICON},;
	{ "Static", "SS_BLACKRECT",SS_BLACKRECT},;
	{ "Static", "SS_GRAYRECT",SS_GRAYRECT},;
	{ "Static", "SS_WHITERECT",SS_WHITERECT},;
	{ "Static", "SS_BLACKFRAME",SS_BLACKFRAME},;
	{ "Static", "SS_GRAYFRAME",SS_GRAYFRAME},;
	{ "Static", "SS_WHITEFRAME",SS_WHITEFRAME},;
	{ "Static", "SS_USERITEM",SS_USERITEM},;
	{ "Static", "SS_SIMPLE",SS_SIMPLE},;
	{ "Static", "SS_LEFTNOWORDWRAP",SS_LEFTNOWORDWRAP},;
	{ "Static", "SS_OWNERDRAW",SS_OWNERDRAW},;
	{ "Static", "SS_BITMAP",SS_BITMAP},;
	{ "Static", "SS_ENHMETAFILE",SS_ENHMETAFILE},;
	{ "Static", "SS_ETCHEDHORZ",SS_ETCHEDHORZ},;
	{ "Static", "SS_ETCHEDVERT",SS_ETCHEDVERT},;
	{ "Static", "SS_ETCHEDFRAME",SS_ETCHEDFRAME},;
	{ "Static", "SS_NOPREFIX",SS_NOPREFIX},;
	{ "Static", "SS_NOTIFY",SS_NOTIFY},;
	{ "Static", "SS_CENTERIMAGE",SS_CENTERIMAGE},;
	{ "Static", "SS_RIGHTJUST",SS_RIGHTJUST},;
	{ "Static", "SS_REALSIZEIMAGE",SS_REALSIZEIMAGE},;
	{ "Static", "SS_SUNKEN",SS_SUNKEN},;
	{ "Static", "SS_ENDELLIPSIS",SS_ENDELLIPSIS},;
	{ "Static", "SS_PATHELLIPSIS",SS_PATHELLIPSIS},;
	{ "Static", "SS_WORDELLIPSIS",SS_WORDELLIPSIS},;
	{ "Edit", "ES_LEFT",ES_LEFT},;
	{ "Edit", "ES_CENTER",ES_CENTER},;
	{ "Edit", "ES_RIGHT",ES_RIGHT},;
	{ "Edit", "ES_MULTILINE",ES_MULTILINE},;
	{ "Edit", "ES_UPPERCASE",ES_UPPERCASE},;
	{ "Edit", "ES_LOWERCASE",ES_LOWERCASE},;
	{ "Edit", "ES_PASSWORD",ES_PASSWORD},;
	{ "Edit", "ES_AUTOVSCROLL",ES_AUTOVSCROLL},;
	{ "Edit", "ES_AUTOHSCROLL",ES_AUTOHSCROLL},;
	{ "Edit", "ES_NOHIDESEL",ES_NOHIDESEL},;
	{ "Edit", "ES_OEMCONVERT",ES_OEMCONVERT},;
	{ "Edit", "ES_READONLY",ES_READONLY},;
	{ "Edit", "ES_WANTRETURN",ES_WANTRETURN},;
	{ "Edit", "ES_NUMBER",ES_NUMBER},;
	{ "ComboBox", "CBS_SIMPLE",CBS_SIMPLE},;
	{ "ComboBox", "CBS_DROPDOWN",CBS_DROPDOWN},;
	{ "ComboBox", "CBS_DROPDOWNLIST",CBS_DROPDOWNLIST},;
	{ "ComboBox", "CBS_OWNERDRAWFIXED",CBS_OWNERDRAWFIXED},;
	{ "ComboBox", "CBS_OWNERDRAWVARIABLE",CBS_OWNERDRAWVARIABLE},;
	{ "ComboBox", "CBS_AUTOHSCROLL",CBS_AUTOHSCROLL},;
	{ "ComboBox", "CBS_OEMCONVERT",CBS_OEMCONVERT},;
	{ "ComboBox", "CBS_SORT",CBS_SORT},;
	{ "ComboBox", "CBS_HASSTRINGS",CBS_HASSTRINGS},;
	{ "ComboBox", "CBS_NOINTEGRALHEIGHT",CBS_NOINTEGRALHEIGHT},;
	{ "ComboBox", "CBS_DISABLENOSCROLL",CBS_DISABLENOSCROLL},;
	{ "ComboBox", "CBS_UPPERCASE",CBS_UPPERCASE},;
	{ "ComboBox", "CBS_LOWERCASE",CBS_LOWERCASE},;
	{ "ListBox", "LBS_NOTIFY",LBS_NOTIFY},;
	{ "ListBox", "LBS_SORT",LBS_SORT},;
	{ "ListBox", "LBS_NOREDRAW",LBS_NOREDRAW},;
	{ "ListBox", "LBS_MULTIPLESEL",LBS_MULTIPLESEL},;
	{ "ListBox", "LBS_OWNERDRAWFIXED",LBS_OWNERDRAWFIXED},;
	{ "ListBox", "LBS_OWNERDRAWVARIABLE",LBS_OWNERDRAWVARIABLE},;
	{ "ListBox", "LBS_HASSTRINGS",LBS_HASSTRINGS},;
	{ "ListBox", "LBS_USETABSTOPS",LBS_USETABSTOPS},;
	{ "ListBox", "LBS_NOINTEGRALHEIGHT",LBS_NOINTEGRALHEIGHT},;
	{ "ListBox", "LBS_MULTICOLUMN",LBS_MULTICOLUMN},;
	{ "ListBox", "LBS_WANTKEYBOARDINPUT",LBS_WANTKEYBOARDINPUT},;
	{ "ListBox", "LBS_EXTENDEDSEL",LBS_EXTENDEDSEL},;
	{ "ListBox", "LBS_DISABLENOSCROLL",LBS_DISABLENOSCROLL},;
	{ "ListBox", "LBS_NODATA",LBS_NODATA},;
	{ "ListBox", "LBS_NOSEL",LBS_NOSEL},;
	{ "ListBox", "LBS_STANDARD",LBS_STANDARD},;
	{ "Scrollbar", "SBS_HORZ",SBS_HORZ},;
	{ "Scrollbar", "SBS_VERT",SBS_VERT},;
	{ "Scrollbar", "SBS_TOPALIGN",SBS_TOPALIGN},;
	{ "Scrollbar", "SBS_LEFTALIGN",SBS_LEFTALIGN},;
	{ "Scrollbar", "SBS_BOTTOMALIGN",SBS_BOTTOMALIGN},;
	{ "Scrollbar", "SBS_RIGHTALIGN",SBS_RIGHTALIGN},;
	{ "Scrollbar", "SBS_SIZEBOXTOPLEFTALIGN",SBS_SIZEBOXTOPLEFTALIGN},;
	{ "Scrollbar", "SBS_SIZEBOXBOTTOMRIGHTALIGN",SBS_SIZEBOXBOTTOMRIGHTALIGN},;
	{ "Scrollbar", "SBS_SIZEBOX",SBS_SIZEBOX    },;
	{ "Scrollbar", "SBS_SIZEGRIP",SBS_SIZEGRIP  },; //	{ "User", "WS_OVERLAPPED",WS_OVERLAPPED     },;
	{ "User", "WS_POPUP",WS_POPUP               },;
	{ "User", "WS_CHILD",WS_CHILD               },;
	{ "User", "WS_MINIMIZE",WS_MINIMIZE         },;
	{ "User", "WS_VISIBLE",WS_VISIBLE           },;
	{ "User", "WS_DISABLED",WS_DISABLED         },;
	{ "User", "WS_CLIPSIBLINGS",WS_CLIPSIBLINGS },;
	{ "User", "WS_CLIPCHILDREN",WS_CLIPCHILDREN },;
	{ "User", "WS_MAXIMIZE",WS_MAXIMIZE         },;
	{ "User", "WS_CAPTION",WS_CAPTION           },;
	{ "User", "WS_DLGFRAME",WS_DLGFRAME         },;
	{ "User", "WS_VSCROLL",WS_VSCROLL           },;
	{ "User", "WS_HSCROLL",WS_HSCROLL           },;
	{ "User", "WS_SYSMENU",WS_SYSMENU           },;
	{ "User", "WS_THICKFRAME",WS_THICKFRAME     },;
	{ "User", "WS_GROUP",WS_GROUP               },;
	{ "User", "WS_TABSTOP",WS_TABSTOP           },;
	{ "User", "WS_MINIMIZEBOX",WS_MINIMIZEBOX   },;
	{ "User", "WS_MAXIMIZEBOX",WS_MAXIMIZEBOX   } }


local n, cClass, nLen, nStyle
local aStyles := {}
local lFind := .f.

cClass := GetClassName( hWnd )
nStyle := GetWindowLong( hWnd, GWL_STYLE )

nLen := len( aCtrlStyles )

for n := 1 to nLen
    if cClass ==  aCtrlStyles[n,1]
       lFind := .t.
       exit
    endif
next

if !lFind
   cClass := "User"
endif

for n := 1 to nLen
    if cClass == aCtrlStyles[n,1]
       if nAnd( nStyle, aCtrlStyles[n,3] ) == aCtrlStyles[n,3]
          aadd( aStyles, aCtrlStyles[n,2] )
       endif
    endif
next

return aStyles

static function WQout2( aParams, cTitle )

    local cOut := ""

    if valtype( aParams ) == "A"
       AEval( aParams, { | c |  cOut :=  cOut + CRLF + cValToChar( c ) } )
       nMsgBox( cOut, cTitle )
    endif

return nil





function ShowDatos( hWnd )


local cVar11  := space(100)
local cVar21  := space(100)
local cVar31  := space(100)
local cVar41  := space(100)
local cVar51  := space(100)
local cVar61  := space(100)
local cVar71  := space(100)
local cVar81  := space(100)
local cVar91  := space(100)
local cVar101 := space(100)
local cVar111 := space(100)
local a       := GetCoors(hWnd)

DEFAULT hWnd := 0


//Aplicacion():oWnd:Hide() //Move(0,0,200,200,.t.)

if FindWindow( 0, "CanalFive Spy" ) == 0

   DEFINE DIALOG oDlgShow ;
          FROM 635-635, 948-948 TO 944-635, 1220-948 PIXEL ;
          TITLE "CanalFive Spy"

          TSpy():New( 10, 110, 20, 20, oDlgShow,"espiar",7,.t.)

          //@ 3, 3 TO 3 + 97, 3+127 PROMPT  "Window" OF oDlgShow PIXEL

          @ 90, 3 GROUP TO 3 + 42, 96+ 127 PROMPT  "Parent Window" OF oDlgShow PIXEL



          @ 12, 8 SAY "hWnd" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 11, 36 GET oGet11 VAR cVar11 ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 22, 8 SAY "ID" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 21, 36 GET oGet21 VAR cVar21 ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 32, 8 SAY "Texto" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 31, 36 GET oGet31 VAR cVar31 ;
                SIZE 91, 9 PIXEL OF oDlgShow

          @ 42, 8 SAY "Clase" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 41, 36 GET oGet41 VAR cVar41 ;
                SIZE 91, 9 PIXEL OF oDlgShow

          @ 52, 8 SAY "Estilo" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 51, 36 GET oGet51 VAR cVar51 ;
                SIZE 91, 9 PIXEL OF oDlgShow

          @ 62, 8 SAY "Coords." ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 60, 36 GET oGet61 VAR cVar61 ;
                SIZE 91, 9 PIXEL OF oDlgShow


          @ 71, 8 SAY "hWnd" ;
                SIZE 67, 9 PIXEL OF oDlgShow
          @ 70, 36 GET oGet91 VAR cVar91 ;
                SIZE 91, 9 PIXEL OF oDlgShow

          @ 81, 8 SAY "Text" ;
                SIZE 67, 9 PIXEL OF oDlgShow
          @ 80, 36 GET oGet101 VAR cVar101 ;
                SIZE 91, 9 PIXEL OF oDlgShow

          @ 91, 8 SAY "Estilo" ;
                SIZE 67, 9 PIXEL OF oDlgShow

          @ 90, 36 GET oGet111 VAR cVar111 ;
                SIZE 91, 9 PIXEL OF oDlgShow

         // @ 120, 36 RADIO oRad VAR nRad ;
         //           ITEMS "Prg","RC prg","RC","Design" ;
         //           OF oDlgShow ;
         //           SIZE 200, 18 ;
         //           PIXEL

          oDlgShow:bStart := {|| BringWindowToTop( oDlgShow:hWnd ) }

   ACTIVATE DIALOG oDlgShow NOWAIT CENTERED ON INIT ( SetWindowPos( oDlgShow:hWnd, -1, 0, GetSysMetrics(0)-oDlgShow:nWidth,  0, 0, 65)) ;
            VALID (Aplicacion():oWnd:Show(), .t.)

 //oRad:aItems[1]:Move( 225,25, 60,18,.t.),;
 //oRad:aItems[2]:Move( 225,85, 60,18,.t.),;
 //oRad:aItems[3]:Move( 225,145,50,18,.t.),;
 //oRad:aItems[4]:Move( 225,195,70,18,.t.),;



else


   if hWnd == 0
      return nil
   endif

   oGet11:VarPut ( alltrim(str(hWnd)))                             ; oGet11:Refresh()
   oGet21:VarPut ( alltrim(str(GetDlgCtrlID(hWnd))))               ; oGet21:Refresh()
   oGet31:VarPut ( alltrim(GetWindowText(hWnd)))                   ; oGet31:Refresh()
   oGet41:VarPut ( alltrim(GetClassName(hWnd)))                    ; oGet41:Refresh()
   oGet51:VarPut ( alltrim(str(GetWindowLong( hWnd, GWL_STYLE )))) ; oGet51:Refresh()
   oGet61:VarPut ( "("+ ast(a[1])+","+ast(a[2])+")-("+ ast(a[4]-a[2])+","+ast(a[3]-a[1])+")"  ); oGet61:Refresh()
   oGet91:VarPut ( ast(GetParent(hWnd))  )               ; oGet91:Refresh()

   if GetParent( hWnd ) != 0
      oGet101:VarPut( GetWindowText( GetParent(hWnd)) )  ; oGet101:Refresh()
      oGet111:VarPut( GetClassName( GetParent(hWnd)) )   ; oGet111:Refresh()
   endif
endif



return nil

function CapturaRect()
local oIcon1
local oWnd
local oSpy

 DEFINE DIALOG oWnd FROM 0, 0 TO 0,0  SIZE 118, 79 ;
        TITLE "Capturador"

          oSpy := TSpy():New( 10, 20.50, 20, 20, oWnd,"espiar",7,.t.)

oWnd:lHelpIcon := .f.

ACTIVATE DIALOG oWnd CENTERED ON INIT ( oWnd:Hide(),sysrefresh(),oSpy:Capturador() )

return nil

return nil



function ast( n ); return alltrim(str(n))



#pragma BEGINDUMP

#include <windows.h>
#include <winuser.h>
#include <commctrl.h>
#include "hbapi.h"

HINSTANCE GetInstance( void );
HINSTANCE GetResources( void );
void RegisterResource( HANDLE hRes, LPSTR szType );
void pascal DelResource( HANDLE hRes );
#define BM_GETCHECK        0x00F0

BOOL SPGetComboBoxInfo( HWND hWnd, PCOMBOBOXINFO pcbi )
{
   typedef BOOL (CALLBACK* LPFNDLLFUNC)( HWND, PCOMBOBOXINFO );
   HINSTANCE hLib;
   LPFNDLLFUNC GetComboBoxInfo;
   BOOL bRet = FALSE;

   hLib = LoadLibrary( "User32.dll" );
   if( hLib )
   {
       GetComboBoxInfo = ((LPFNDLLFUNC) GetProcAddress( hLib, "GetComboBoxInfo" ));
       bRet = (BOOL) GetComboBoxInfo( hWnd, pcbi );
       FreeLibrary( hLib );
   }
   return bRet;
}


// Obtener el HWND de la lista desplegable del combobox
HB_FUNC( HWNDCOMBOLIST )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   SPGetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndList ) ;
}
HB_FUNC( WNDCOPY4 )  //  hWnd        Copies any Window to the Clipboard!
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );

   HDC  hDC  = GetWindowDC( hWnd );
   int x = hb_parvni( 2, 2 )+1;
   int y = hb_parvni( 2, 1 )+1;
   int cx = hb_parvni( 2, 4 ) - x-2;
   int cy = hb_parvni( 2, 3 ) - y-2;
   HDC  hMemDC;
   RECT rct;
   HBITMAP hBitmap, hOldBmp;




   GetWindowRect( hWnd, &rct );

   {
      hMemDC  = CreateCompatibleDC( hDC );

      hBitmap = CreateCompatibleBitmap( hDC, cx, cy );
      hOldBmp = ( HBITMAP ) SelectObject( hMemDC, hBitmap );

      StretchBlt(hMemDC, 0, 0, cx, cy, hDC, x, y,cx, cy,  SRCCOPY );

      SelectObject( hMemDC, hOldBmp );
      DeleteDC( hMemDC );
   }
   ReleaseDC( hWnd, hDC );
   hb_retnl( (LONG ) hBitmap );
}


HB_FUNC( WNDCOPY2 )  //  hWnd        Copies any Window to the Clipboard!
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   BOOL bAll = TRUE ; //hb_parl( 2 );
   HDC  hDC  = GetWindowDC( hWnd );
   WORD wX, wY;
   HDC  hMemDC;
   RECT rct;
   HBITMAP hBitmap, hOldBmp;
   BOOL bColor = TRUE; //_parl( 3 );
   int nRel = hb_parni( 2 );

   //CursorWait();

   GetWindowRect( hWnd, &rct );

   wX = rct.right - rct.left + 1;
   wY = rct.bottom - rct.top + 1;
   wX = wX * nRel / 100;
   wY = wY * nRel / 100;

//   if( GlobalCompact( 0 ) < ( wX * wY ) / 8 )
//      MessageBox( 0, NotEnough, Error, 0 );
//   else
   {
      hMemDC  = CreateCompatibleDC( hDC );

      hBitmap = CreateCompatibleBitmap( hDC, wX, wY );
      hOldBmp = ( HBITMAP ) SelectObject( hMemDC, hBitmap );

      StretchBlt(hMemDC, 0, 0, wX, wY, hDC, 0, 0,rct.right - rct.left + 1, rct.bottom - rct.top + 1,  SRCCOPY );

      OpenClipboard( hWnd );
      EmptyClipboard();
      SetClipboardData( CF_BITMAP, hBitmap );
      CloseClipboard();

      SelectObject( hMemDC, hOldBmp );
      DeleteDC( hMemDC );
   }
   ReleaseDC( hWnd, hDC );
//   CursorArrow();
}

HB_FUNC( GETLBXTEXT )
{
 char sz[300];
 SendMessage( (HWND) hb_parnl( 1 ), LB_GETTEXT, hb_parni( 2 ), ( LPARAM) sz );
 hb_retc( sz );
}

HB_FUNC( GETCBXTEXT )
{
 char sz[300];
 SendMessage( (HWND) hb_parnl( 1 ), CB_GETLBTEXT, hb_parni( 2 ), ( LPARAM) sz );
 hb_retc( sz );
}

HB_FUNC( CHILDSCOUNT )
{
   int nChilds = 0;
   HWND hCtrl = GetWindow(( HWND ) hb_parnl( 1 ), GW_CHILD );
   while ( hCtrl != NULL )
   {
      nChilds++;
      hCtrl = GetWindow(( HWND ) hCtrl, GW_HWNDNEXT );
   }
   hb_retni( nChilds );
}

HB_FUNC( GETWINDOWTHREADPROCESSID )
{
   DWORD PID;
   GetWindowThreadProcessId ((HWND) hb_parnl( 1 ), &PID);
   hb_parnl( PID );
}

HB_FUNC( GETCURRENTPROCESSID )
{
   hb_parnl( GetCurrentProcessId() );
}

HB_FUNC( ISRECTEMPTY )
{
   RECT rc;
   rc.top = hb_parvni( 1, 1 );
   rc.left = hb_parvni( 1, 2 );
   rc.bottom = hb_parvni( 1, 3 );
   rc.right = hb_parvni( 1, 4 );
   hb_retl( IsRectEmpty( &rc ) );
}

HB_FUNC( PATBLT )
{
  hb_retl( PatBlt( (HDC) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parnl( 6 ) ) );
}

static far BYTE MagicXor[] = {
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        };
static far BYTE MagicAnd[] = {
                0xFF, 0xCF, 0xFF, 0xFF, 0xFF, 0xB7, 0xFF, 0xFF, 0xFF, 0xBB, 0xFF, 0xFF, 0xFF, 0xD9, 0xFF, 0xFF,
                0xF9, 0xE2, 0xFF, 0xFF, 0xF9, 0xF6, 0x7F, 0xFF, 0xE6, 0x78, 0x3F, 0xFF, 0xE6, 0x7C, 0x1F, 0xFF,
                0xF9, 0xFE, 0x0F, 0xFF, 0xF9, 0xFF, 0x07, 0xFF, 0xFF, 0xFF, 0x83, 0xFF, 0xFF, 0xFF, 0xC1, 0xFF,
                0xCF, 0xFF, 0xE0, 0xFF, 0xCF, 0xFF, 0xF0, 0x7F, 0x33, 0x9F, 0xF8, 0x3F, 0x33, 0x9F, 0xFC, 0x1F,
                0xCE, 0x67, 0xFE, 0x0F, 0xCE, 0x67, 0xFF, 0x07, 0xFF, 0x9F, 0xFF, 0x83, 0xFF, 0x9F, 0xFF, 0xC1,
                0xFF, 0xFF, 0xFF, 0xE1, 0xFF, 0xFF, 0xFF, 0xF3, 0xE7, 0xFE, 0x7F, 0xFF, 0xE7, 0xFE, 0x7F, 0xFF,
                0x99, 0xF9, 0x9F, 0xFF, 0x99, 0xF9, 0x9F, 0xFF, 0xE7, 0xFE, 0x7F, 0xFF, 0xE7, 0xFE, 0x7F, 0xFF,
                0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
        }  ;

static far HCURSOR hMagic  = 0;

HB_FUNC( CURSORMAGIC )
{
   if( ! hMagic )
   {
      hMagic = CreateCursor( GetInstance(), 11, 2, 32, 32, MagicAnd, MagicXor );
      RegisterResource( hMagic, "CUR" );

   }

   SetCursor( hMagic );
}


   HB_FUNC( ISBUTTONCHECKED )
   {
      hb_retl( SendMessage( ( HWND ) hb_parnl( 1 ), BM_GETCHECK, 0, 0 ) );
   }

   HB_FUNC( GETDLGCTRLID )
   {
      hb_retni( GetDlgCtrlID( ( HWND ) hb_parnl( 1 ) ) );
   }


   HB_FUNC( FONTINFO ) // ( hFont )  --> aInfo
   {
      TEXTMETRIC tm;
      HFONT hFont;
      HWND hWnd      = ( HWND ) hb_parnl( 1 );
      HDC hDC        = GetDC( hWnd );
      HFONT hOldFont ;
      char cName[ 80 ];

      hFont    = ( HFONT ) SendMessage( hWnd, 49, 0, 0 ) ;
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

      GetTextMetrics( hDC, &tm );
      GetTextFace( hDC, sizeof( cName ), cName );
      SelectObject( hDC, hOldFont );
      ReleaseDC( hWnd, hDC );

      hb_reta( 4 );
      hb_storvni( tm.tmHeight, -1, 1 );
      hb_storvni( tm.tmAveCharWidth, -1, 2 );
      hb_storvl( tm.tmWeight == FW_BOLD, -1, 3 );
      hb_storvc( cName, -1, 4 );
   }
   /*
   //LONG GetDialogBaseUnits(VOID);
   HB_FUNC( GETDIALOGBASEUNITS )
   {
      hb_retnl( GetDialogBaseUnits( ));
   }
   */
   /*BOOL MapDialogRect( HWND hDlg, LPRECT lpRect );*/
   /*
   HB_FUNC( MAPDIALOGRECT )
   {
      HWND hDlg = ( HWND ) hb_parnl( 1 );
      RECT  rct;
      rct.top    = hb_parni( 2, 1 );
      rct.left   = hb_parni( 2, 2 );
      rct.bottom = hb_parni( 2, 3 );
      rct.right  = hb_parni( 2, 4 );

      MapDialogRect( hDlg, &rct );

      hb_reta( 4 );
      rct.top    = hb_storni( -1, 1 );
      rct.left   = hb_storni( -1, 2 );
      rct.bottom = hb_storni( -1, 3 );
      rct.right  = hb_storni( -1, 4 );
   }
   */

   /*HB_FUNC( PRINTWINDOW )
   {
      hb_retl( PrintWindow( ( HWND ) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ), NULL ));
   }*/

   HB_FUNC( FROMPIXEL )
   {
      //void CDlgUnits::FromPixels(long& x, long& y)
      LONG dlgUnits;
      HWND hDlg = (HWND) hb_parnl( 1 );
      int cx, cy;
      int x = hb_parni( 2 );
      int y = hb_parni( 3 );

   	if (hDlg)
   	{
   		// this is a bit messy ebcause there is no MapDialogRect() in reverse
   		RECT rect;
   		rect.top = 0;
   		rect.left = 0;
   		rect.bottom = 1000;
   		rect.right = 1000;

   		MapDialogRect(hDlg, &rect);

   		x = MulDiv(x, 1000, rect.right);
   		y = MulDiv(y, 1000, rect.right);
   	}
   	else
   	{
   		dlgUnits = GetDialogBaseUnits();
   		cx = LOWORD(dlgUnits);
   		cy = HIWORD(dlgUnits);

   		x = MulDiv(x, 4, cx);
   		y = MulDiv(y, 8, cy);
   	}
   	hb_reta( 2 );
   	hb_storvni( x, -1, 1 );
   	hb_storvni( y, -1, 2 );
	}




   /*HMENU GetMenu( HWND hWnd );*/
   HB_FUNC( GETMENU )
   {
      hb_retnl( ( LONG ) GetMenu( ( HWND ) hb_parnl( 1 ) ) );
   }

   /*HMENU GetSubMenu( HMENU hMenu, int nPos );*/
   /*
   HB_FUNC( GETSUBMENU )
   {
      hb_retnl( ( LONG ) GetSubMenu( ( HMENU ) hb_parnl( 1 ), hb_parni( 2 ) ) );
   }
   */
   /*int GetMenuString(          HMENU hMenu,
    UINT uIDItem,
    LPTSTR lpString,
    int nMaxCount,
    UINT uFlag
);
*/
   /*
   HB_FUNC( GETMENUSTRING )
   {
       char sz[300];
       GetMenuString( ( HMENU ) hb_parnl( 1 ), hb_parni( 2 ), sz, 300, MF_BYPOSITION );
       hb_retc( sz );
   }
   */
   HB_FUNC( GETTCMTEXT )
   {
  	 //TCITEM item;
 	 //ZeroMemory(&item, sizeof(TCITEM) );
         //item.mask = TCIF_TEXT;
         //SendMessage( (HWND) hb_parnl( 1 ), TCM_GETITEM, (WPARAM) hb_parni( 2 ), (LPARAM) &item );
       int nIndex;
       TCITEM * plvi;
       TCITEM  lvi;
       LPTSTR pClipData;
       HGLOBAL hClipData;
       HANDLE hProcess;
       HWND hwndLV = (HWND) hb_parnl( 1 );
       int nCount = TabCtrl_GetItemCount(hwndLV);
       // Open a handle to the remote process's kernel object
       DWORD dwProcessId;

       GetWindowThreadProcessId(hwndLV, &dwProcessId);
       hProcess = OpenProcess( PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE, FALSE, dwProcessId);

       if (hProcess == NULL) {
          MessageBox(0, __TEXT("Could not communicate with process"), "Atención", MB_OK | MB_ICONWARNING);
          hb_ret();
          return;
       }

       // Prepare a buffer to hold the ListView's data.
       // Note: Hardcoded maximum of 10240 chars for clipboard data.
    	// Note: Clipboard only accepts data that is in a block allocated with
    	//       GlobalAlloc using the GMEM_MOVEABLE and GMEM_DDESHARE flags.
       hClipData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, sizeof(TCHAR) * 10240);
       pClipData = (LPTSTR) GlobalLock(hClipData);
       pClipData[0] = 0;

       // Allocate memory in the remote process's address space
       plvi = (TCITEM*) VirtualAllocEx(hProcess, NULL, 4096, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);

       // Get each ListView item's text data
       for ( nIndex = 0; nIndex < nCount; nIndex++) {

          // Initialize a local LV_ITEM structure
          lvi.mask = TCIF_TEXT;
          //lvi.iItem = nIndex;
          //lvi.iSubItem = 0;
          // NOTE: The text data immediately follows the LV_ITEM structure
          //       in the memory block allocated in the remote process.
          lvi.pszText = (LPTSTR) (plvi + 1);
          lvi.cchTextMax = 100;

          // Write the local LV_ITEM structure to the remote memory block
          WriteProcessMemory(hProcess, plvi, &lvi, sizeof(lvi), NULL);

          // Tell the ListView control to fill the remote LV_ITEM structure
          TabCtrl_GetItem(hwndLV, nIndex, plvi);

          // If this is not the first item, add a carriage-return/linefeed
          if (nIndex > 0) lstrcat(pClipData, __TEXT("\r\n"));

          // Read the remote text string into the end of our clipboard buffer
          ReadProcessMemory(hProcess, plvi + 1, &pClipData[lstrlen(pClipData)], 1024, NULL);
       }
       // Free the memory in the remote process's address space
       VirtualFreeEx(hProcess, plvi, 0, MEM_RELEASE);
       CloseHandle(hProcess);
       hb_retc( pClipData );
   }

   HB_FUNC( GETTCMTEXT2 )
   {
  	 //TCITEM item;
 	 //ZeroMemory(&item, sizeof(TCITEM) );
         //item.mask = TCIF_TEXT;
         //SendMessage( (HWND) hb_parnl( 1 ), TCM_GETITEM, (WPARAM) hb_parni( 2 ), (LPARAM) &item );
       int nIndex;
       LV_ITEM* plvi;
       LV_ITEM lvi;
       LPTSTR pClipData;
       HGLOBAL hClipData;
       HANDLE hProcess;
       HWND hwndLV = (HWND) hb_parnl( 1 );
       int nCount = ListView_GetItemCount(hwndLV);
       // Open a handle to the remote process's kernel object
       DWORD dwProcessId;

       GetWindowThreadProcessId(hwndLV, &dwProcessId);
       hProcess = OpenProcess( PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE, FALSE, dwProcessId);

       if (hProcess == NULL) {
          MessageBox(0, __TEXT("Could not communicate with process"), "Atención", MB_OK | MB_ICONWARNING);
          hb_ret();
          return;
       }

       // Prepare a buffer to hold the ListView's data.
       // Note: Hardcoded maximum of 10240 chars for clipboard data.
    	// Note: Clipboard only accepts data that is in a block allocated with
    	//       GlobalAlloc using the GMEM_MOVEABLE and GMEM_DDESHARE flags.
       hClipData = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, sizeof(TCHAR) * 10240);
       pClipData = (LPTSTR) GlobalLock(hClipData);
       pClipData[0] = 0;

       // Allocate memory in the remote process's address space
       plvi = (LV_ITEM*) VirtualAllocEx(hProcess, NULL, 4096, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);

       // Get each ListView item's text data
       for ( nIndex = 0; nIndex < nCount; nIndex++) {

          // Initialize a local LV_ITEM structure
          lvi.mask = LVIF_TEXT;
          lvi.iItem = nIndex;
          lvi.iSubItem = 0;
          // NOTE: The text data immediately follows the LV_ITEM structure
          //       in the memory block allocated in the remote process.
          lvi.pszText = (LPTSTR) (plvi + 1);
          lvi.cchTextMax = 100;

          // Write the local LV_ITEM structure to the remote memory block
          WriteProcessMemory(hProcess, plvi, &lvi, sizeof(lvi), NULL);

          // Tell the ListView control to fill the remote LV_ITEM structure
          ListView_GetItem(hwndLV, plvi);

          // If this is not the first item, add a carriage-return/linefeed
          if (nIndex > 0) lstrcat(pClipData, __TEXT("\r\n"));

          // Read the remote text string into the end of our clipboard buffer
          ReadProcessMemory(hProcess, plvi + 1, &pClipData[lstrlen(pClipData)], 1024, NULL);
       }
       // Free the memory in the remote process's address space
       VirtualFreeEx(hProcess, plvi, 0, MEM_RELEASE);
       CloseHandle(hProcess);
       hb_retc( pClipData );
   }


HB_FUNC( CAPTUREWINDOW )
{
	 HWND hWnd = ( HWND ) hb_parnl( 1 );
    HDC hDC;
    HDC hDCMem = CreateCompatibleDC(NULL);
    HBITMAP hBmp = NULL;
    RECT rect;
    HGDIOBJ hOld;
    GetWindowRect(hWnd, & rect);
    {
        hDC = GetDC(hWnd);
        hBmp = CreateCompatibleBitmap(hDC, rect.right - rect.left, rect.bottom - rect.top);
        ReleaseDC(hWnd, hDC);
    }

    hOld = (HBITMAP) SelectObject(hDCMem, hBmp);


    SendMessage(hWnd, WM_PAINT, (WPARAM) hDCMem, 0);
    SendMessage(hWnd, WM_PRINT, (WPARAM) hDCMem, PRF_CHILDREN | PRF_CLIENT | PRF_ERASEBKGND | PRF_NONCLIENT | PRF_OWNED| PRF_CHECKVISIBLE);
    SelectObject(hDCMem, hOld);
    DeleteObject(hDCMem);

    OpenClipboard(hWnd);

    EmptyClipboard();
    SetClipboardData(CF_BITMAP, hBmp);
    CloseClipboard();

    hb_retnl( (LONG) hBmp );

}


HB_FUNC( ISCHILDWINDOW )
{
   hb_retl( GetWindowLong( ( HWND )hb_parnl( 1 ), GWL_STYLE ) && WS_CHILD );
}







#pragma ENDDUMP
