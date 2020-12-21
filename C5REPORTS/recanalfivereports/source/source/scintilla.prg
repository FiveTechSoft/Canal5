#include "fivewin.ch"
#include "scintilla.ch"
#include "report.ch"
#include "mail.ch"
#include "scilexer.h"

static nError
static oCode
static cLastFind := ""

#define CW_USEDEFAULT      32768

static oReport

CLASS TScintilla FROM TControl

      DATA cFileName

      CLASSDATA lRegisterd AS LOGICAL
      CLASSDATA hLib
      DATA aCopys
      CLASSDATA nInst AS NUMERIC INIT 0
      CLASSDATA aMrus AS ARRAY INIT {}
      CLASSDATA cLineBuffer

      METHOD Default()
      METHOD SetColor( nClrText, nClrPane )


      METHOD New( nRow, nCol, oWnd, nWidth, nHeight ) CONSTRUCTOR
      METHOD End()
      METHOD AddText( cText )                        INLINE ::SendEditor( SCI_ADDTEXT, len( cText ), cText )
      METHOD AddTextCRLF( cText )                    INLINE ::SendEditor( SCI_ADDTEXT, len( cText )+2, cText+CRLF )
      METHOD Backtab()                               INLINE ::SendEditor( SCI_BACKTAB,0,0)
      METHOD CanRedo()                               INLINE ::SendEditor( SCI_CANREDO, 0, 0) != 0
      METHOD CanUndo()                               INLINE ::SendEditor( SCI_CANUNDO, 0, 0) != 0
      METHOD Cancel ()                               INLINE ::SendEditor( SCI_CANCEL ,0,0)
      METHOD Charleft ()                             INLINE ::SendEditor( SCI_CHARLEFT ,0,0)
      METHOD Charleftextend ()                       INLINE ::SendEditor( SCI_CHARLEFTEXTEND ,0,0)
      METHOD Charleftrectextend ()                   INLINE ::SendEditor( SCI_CHARLEFTRECTEXTEND ,0,0)
      METHOD Charright ()                            INLINE ::SendEditor( SCI_CHARRIGHT ,0,0)
      METHOD Charrightextend ()                      INLINE ::SendEditor( SCI_CHARRIGHTEXTEND ,0,0)
      METHOD Charrightrectextend ()                  INLINE ::SendEditor( SCI_CHARRIGHTRECTEXTEND ,0,0)
      METHOD ClearAll()                              INLINE ::SendEditor( SCI_CLEARALL )
      METHOD CopyLine()                              INLINE ::SendEditor( SCI_LINECOPY, 0, 0 )
      METHOD Deleteback ()                           INLINE ::SendEditor( SCI_DELETEBACK ,0,0)
      METHOD Deletebacknotline ()                    INLINE ::SendEditor( SCI_DELETEBACKNOTLINE ,0,0)
      METHOD Dellineleft ()                          INLINE ::SendEditor( SCI_DELLINELEFT ,0,0)
      METHOD Dellineright ()                         INLINE ::SendEditor( SCI_DELLINERIGHT ,0,0)
      METHOD Delwordleft ()                          INLINE ::SendEditor( SCI_DELWORDLEFT ,0,0)
      METHOD Delwordright ()                         INLINE ::SendEditor( SCI_DELWORDRIGHT ,0,0)
      METHOD DlgFindText()
      METHOD Documentend ()                          INLINE ::SendEditor( SCI_DOCUMENTEND ,0,0)
      METHOD Documentendextend ()                    INLINE ::SendEditor( SCI_DOCUMENTENDEXTEND ,0,0)
      METHOD Documentstart ()                        INLINE ::SendEditor( SCI_DOCUMENTSTART ,0,0)
      METHOD Documentstartextend ()                  INLINE ::SendEditor( SCI_DOCUMENTSTARTEXTEND ,0,0)
      METHOD Edittoggleovertype ()                   INLINE ::SendEditor( SCI_EDITTOGGLEOVERTYPE ,0,0)
      METHOD EmptyUndoBuffer()                       INLINE ::SendEditor( EM_EMPTYUNDOBUFFER )
      METHOD FindText( nFlags, ft )                  INLINE ::SendEditor( SCI_FINDTEXT, nFlags, ft )
      METHOD Formfeed ()                             INLINE ::SendEditor( SCI_FORMFEED ,0,0)
      METHOD GetCurLine ( nLength, cText )           INLINE ::SendEditor( SCI_GETCURLINE, nLength, cText )
      METHOD GetCurrentPos ()                        INLINE ::SendEditor( SCI_GETCURRENTPOS, 0, 0)
      METHOD GetCurrentStyle()
      METHOD GetLine( nLine )                        INLINE SC_GetLine( ::hWnd, nLine )
      METHOD GetLineCount ()                         INLINE ::SendEditor( SCI_GETLINECOUNT, 0, 0)
      METHOD GetModify()
      METHOD GetReadOnly()                           INLINE ::SendEditor( SCI_GETREADONLY ) != 0
      METHOD GetSelText ()                           INLINE C5GetSelText(::hWnd, ::SendEditor(SCI_GETSELECTIONEND) - ::SendEditor(SCI_GETSELECTIONSTART) )
      METHOD GetSelectionStart()                     INLINE ::SendEditor( SCI_GETSELECTIONSTART, 0, 0)
      METHOD GetText()                               INLINE SC_GetText( ::hWnd )
      METHOD GoDown()                                INLINE ::SendEditor( SCI_LINEDOWN, 0, 0 )
      METHOD GoEol()                                 INLINE ::SendEditor( SCI_LINEEND, 0, 0 )
      METHOD GoHome()                                INLINE ::SendEditor( SCI_HOME, 0, 0 )
      METHOD GoLeft()                                INLINE ::CharLeft()
      METHOD GoRight()                               INLINE ::CharRight()
      METHOD GoUp()                                  INLINE ::SendEditor( SCI_LINEUP, 0, 0 )
      METHOD GotoLine( nLine)                        INLINE ::SendEditor( SCI_GOTOLINE, nLine-1, 0)
      METHOD GotoPos(nPos)                           INLINE ::SendEditor( SCI_GOTOPOS, nPos, 0)
      METHOD Home ()                                 INLINE ::SendEditor( SCI_HOME ,0,0)
      METHOD Homedisplay ()                          INLINE ::SendEditor( SCI_HOMEDISPLAY ,0,0)
      METHOD Homedisplayextend ()                    INLINE ::SendEditor( SCI_HOMEDISPLAYEXTEND ,0,0)
      METHOD Homeextend ()                           INLINE ::SendEditor( SCI_HOMEEXTEND ,0,0)
      METHOD Homerectextend ()                       INLINE ::SendEditor( SCI_HOMERECTEXTEND ,0,0)
      METHOD Homewrap ()                             INLINE ::SendEditor( SCI_HOMEWRAP ,0,0)
      METHOD Homewrapextend ()                       INLINE ::SendEditor( SCI_HOMEWRAPEXTEND ,0,0)
      METHOD InsertText ( nPos, cText )              INLINE ::SendEditor( SCI_INSERTTEXT, nPos, cText)
      METHOD IsReadOnly()                            INLINE SC_IsReadOnly( ::hWnd )
      METHOD KeyChar( nKey, nFlags )
      METHOD KeyDown( nKey, nFlags )
      METHOD LineFromPosition( nPos)                 INLINE ::SendEditor( SCI_LINEFROMPOSITION, nPos, 0)
      METHOD LineLength( nLine )                     INLINE ::SendEditor( SCI_LINELENGTH, nLine, 0 )
      METHOD Linecopy ()                             INLINE ::SendEditor( SCI_LINECOPY ,0,0)
      METHOD Linecut ()                              INLINE ::SendEditor( SCI_LINECUT ,0,0)
      METHOD Linedelete ()                           INLINE ::SendEditor( SCI_LINEDELETE ,0,0)
      METHOD Linedown ()                             INLINE ::SendEditor( SCI_LINEDOWN ,0,0)
      METHOD Linedownextend ()                       INLINE ::SendEditor( SCI_LINEDOWNEXTEND ,0,0)
      METHOD Linedownrectextend ()                   INLINE ::SendEditor( SCI_LINEDOWNRECTEXTEND ,0,0)
      METHOD Lineduplicate ()                        INLINE ::SendEditor( SCI_LINEDUPLICATE ,0,0)
      METHOD Lineend ()                              INLINE ::SendEditor( SCI_LINEEND ,0,0)
      METHOD Lineenddisplay ()                       INLINE ::SendEditor( SCI_LINEENDDISPLAY ,0,0)
      METHOD Lineenddisplayextend ()                 INLINE ::SendEditor( SCI_LINEENDDISPLAYEXTEND ,0,0)
      METHOD Lineendextend ()                        INLINE ::SendEditor( SCI_LINEENDEXTEND ,0,0)
      METHOD Lineendrectextend ()                    INLINE ::SendEditor( SCI_LINEENDRECTEXTEND ,0,0)
      METHOD Lineendwrap ()                          INLINE ::SendEditor( SCI_LINEENDWRAP ,0,0)
      METHOD Lineendwrapextend ()                    INLINE ::SendEditor( SCI_LINEENDWRAPEXTEND ,0,0)
      METHOD Linescrolldown ()                       INLINE ::SendEditor( SCI_LINESCROLLDOWN ,0,0)
      METHOD Linescrollup ()                         INLINE ::SendEditor( SCI_LINESCROLLUP ,0,0)
      METHOD Linetranspose ()                        INLINE ::SendEditor( SCI_LINETRANSPOSE ,0,0)
      METHOD Lineup ()                               INLINE ::SendEditor( SCI_LINEUP ,0,0)
      METHOD Lineupextend ()                         INLINE ::SendEditor( SCI_LINEUPEXTEND ,0,0)
      METHOD Lineuprectextend ()                     INLINE ::SendEditor( SCI_LINEUPRECTEXTEND ,0,0)
      METHOD Lowercase ()                            INLINE ::SendEditor( SCI_LOWERCASE ,0,0)
      METHOD MarkerAdd( nLine,  nMarkerNumber)       INLINE ::SendEditor( SCI_MARKERADD, nLine, nMarkerNumber)
      METHOD MouseMove( nRow, nCol, nKeyFlags )      INLINE CallWindowProc( ::nOldProc, ::hWnd, WM_MOUSEMOVE, nKeyFlags, nMakeLong( nCol, nRow ) )
      METHOD NewLine ()                              INLINE ::SendEditor( SCI_NEWLINE, 0, 0)
      METHOD Open()
      METHOD OpenFile( cFileName )
      METHOD OptionSetFont()
      METHOD Pagedown ()                             INLINE ::SendEditor( SCI_PAGEDOWN ,0,0)
      METHOD Pagedownextend ()                       INLINE ::SendEditor( SCI_PAGEDOWNEXTEND ,0,0)
      METHOD Pagedownrectextend ()                   INLINE ::SendEditor( SCI_PAGEDOWNRECTEXTEND ,0,0)
      METHOD Pageup ()                               INLINE ::SendEditor( SCI_PAGEUP ,0,0)
      METHOD Pageupextend ()                         INLINE ::SendEditor( SCI_PAGEUPEXTEND ,0,0)
      METHOD Pageuprectextend ()                     INLINE ::SendEditor( SCI_PAGEUPRECTEXTEND ,0,0)
      METHOD Paradown ()                             INLINE ::SendEditor( SCI_PARADOWN ,0,0)
      METHOD Paradownextend ()                       INLINE ::SendEditor( SCI_PARADOWNEXTEND ,0,0)
      METHOD Paraup ()                               INLINE ::SendEditor( SCI_PARAUP ,0,0)
      METHOD Paraupextend ()                         INLINE ::SendEditor( SCI_PARAUPEXTEND ,0,0)
      METHOD Print()
      METHOD Redo()                                  INLINE ::SendEditor( SCI_REDO, 0, 0)
      METHOD ReplaceSel( cText )                     INLINE ::SendEditor( SCI_REPLACESEL, 0, cText )
      METHOD Save()
      METHOD SayMemo()
      METHOD SearchNext ( nFlags, cText)             INLINE ::SendEditor( SCI_SEARCHNEXT, nFlags, cText)
      METHOD SearchPrev ( nFlags, cText)             INLINE ::SendEditor( SCI_SEARCHPREV, nFlags, cText)
      METHOD SendAsEmail()
      METHOD SendEditor( Msg, wParam, lParam )
      METHOD SetFixedFont()
      METHOD SetReadOnly( lOn )                      INLINE ::SendEditor( SCI_SETREADONLY, if( lOn, 1, 0 ), 0 )
      METHOD SetSavePoint()                          INLINE ::SendEditor( SCI_SETSAVEPOINT )
      METHOD SetSel ( nStart,  nEnd )                INLINE ::SendEditor( SCI_SETSEL, nStart, nEnd )
      METHOD SetText( cText )                        INLINE ::SendEditor( SCI_SETTEXT, 0, cText )
      METHOD SetUndoCollection()                     INLINE ::SendEditor( SCI_SETUNDOCOLLECTION )
      METHOD Stutteredpagedown ()                    INLINE ::SendEditor( SCI_STUTTEREDPAGEDOWN ,0,0)
      METHOD StutteredpagedownextenD ()              INLINE ::SendEditor( SCI_STUTTEREDPAGEDOWNEXTEND ,0,0)
      METHOD Stutteredpageup ()                      INLINE ::SendEditor( SCI_STUTTEREDPAGEUP ,0,0)
      METHOD Stutteredpageupextend ()                INLINE ::SendEditor( SCI_STUTTEREDPAGEUPEXTEND ,0,0)
      METHOD StyleSetBold ( nStyle,  bold )
      METHOD StyleSetFont ( nStyle, cFontName)
      METHOD StyleSetFore ( nStyle, fore)
      METHOD StyleSetItalic ( nStyle,  italic)
      METHOD StyleSetSize ( nStyle,  nSizePoints)
      METHOD StyleSetUnderline ( nStyle,  underline)
      METHOD Tab ()                                  INLINE ::SendEditor( SCI_TAB ,0,0)
      METHOD Undo()                                  INLINE ::SendEditor( SCI_UNDO, 0, 0)
      METHOD Uppercase ()                            INLINE ::SendEditor( SCI_UPPERCASE ,0,0)
      METHOD Vchome ()                               INLINE ::SendEditor( SCI_VCHOME ,0,0)
      METHOD Vchomeextend ()                         INLINE ::SendEditor( SCI_VCHOMEEXTEND ,0,0)
      METHOD Vchomerectextend ()                     INLINE ::SendEditor( SCI_VCHOMERECTEXTEND ,0,0)
      METHOD Vchomewrap ()                           INLINE ::SendEditor( SCI_VCHOMEWRAP ,0,0)
      METHOD Vchomewrapextend ()                     INLINE ::SendEditor( SCI_VCHOMEWRAPEXTEND ,0,0)
      METHOD Wordleft ()                             INLINE ::SendEditor( SCI_WORDLEFT ,0,0)
      METHOD Wordleftend ()                          INLINE ::SendEditor( SCI_WORDLEFTEND ,0,0)
      METHOD Wordleftendextend ()                    INLINE ::SendEditor( SCI_WORDLEFTENDEXTEND ,0,0)
      METHOD Wordleftextend ()                       INLINE ::SendEditor( SCI_WORDLEFTEXTEND ,0,0)
      METHOD Wordpartleft ()                         INLINE ::SendEditor( SCI_WORDPARTLEFT ,0,0)
      METHOD Wordpartleftextend ()                   INLINE ::SendEditor( SCI_WORDPARTLEFTEXTEND ,0,0)
      METHOD Wordpartright ()                        INLINE ::SendEditor( SCI_WORDPARTRIGHT ,0,0)
      METHOD Wordpartrightextend ()                  INLINE ::SendEditor( SCI_WORDPARTRIGHTEXTEND ,0,0)
      METHOD Wordright ()                            INLINE ::SendEditor( SCI_WORDRIGHT ,0,0)
      METHOD Wordrightend ()                         INLINE ::SendEditor( SCI_WORDRIGHTEND ,0,0)
      METHOD Wordrightendextend ()                   INLINE ::SendEditor( SCI_WORDRIGHTENDEXTEND ,0,0)
      METHOD Wordrightextend ()                      INLINE ::SendEditor( SCI_WORDRIGHTEXTEND ,0,0)
      METHOD nLine()                                 INLINE ::LineFromPosition( ::GetCurrentPos() )+1
      METHOD nPos( nNewVal )                         SETGET

      METHOD SetAStyle( style, fore, back, size, face )
      METHOD Prueba()
      METHOD Notify( nIdCtrl, nPtrNMHDR )



ENDCLASS

/*********************************************************************/
      METHOD SendEditor( Msg, wParam, lParam ) CLASS TScintilla
/*********************************************************************/

DEFAULT wParam := 0
DEFAULT lParam := 0

return SendMessage( ::hWnd, Msg, wParam, lParam )


/*********************************************************************/
      METHOD End() CLASS TScintilla
/*********************************************************************/

if ::nInst == 0
   FreeLibrary( ::hLib )
endif

return Super:End()


/*********************************************************************/
      METHOD nPos( nNewVal ) CLASS TScintilla
/*********************************************************************/

      if pcount() > 0
         ::GotoPos( nNewVal )
      endif

      return ::GetCurrentPos()



/*********************************************************************/
  METHOD New( nRow, nCol, nWidth, nHeight, oWnd ) CLASS TScintilla
/*********************************************************************/

DEFAULT nRow := 0, nCol := 0, nWidth := 100, nHeight := 100

   ::nTop     = nRow
   ::nLeft    = nCol
   ::nBottom  = nRow + nHeight
   ::nRight   = nCol + nWidth
   ::oWnd     = oWnd
   ::nStyle   = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER, WS_VSCROLL, WS_HSCROLL  )
   ::nId       = ::GetNewId()
   ::cFileName = "Noname"

   //::SetColor( 0, CLR_WHITE )
   DEFINE BRUSH ::oBrush STYLE "NULL"

   if ::nInst == 0
      ::hLib := LoadLibrary( "SciLexer.DLL" )
      ::nInst ++
   endif


   //::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create("Scintilla")
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::aCopys := {}

   SendMessage( ::hWnd, SCI_SETMARGINWIDTHN, 0, 35 )
   ::SendEditor(SCI_SETMARGINWIDTHN, 1, 30)
   //::SendEditor(SCI_SETMARGINTYPEN, 1, SC_MARGIN_NUMBER)
   ::SendEditor(SCI_SETFOLDFLAGS, 16, 0)
   //::SendEditor( SCI_SETPROPERTY, "fold", "1")
   ::SendEditor( SCI_SETMARGINWIDTHN, 2, 25)
   ::SendEditor( SCI_SETMARGINTYPEN, 2, SC_MARGIN_SYMBOL)
   ::SendEditor( SCI_SETMARGINMASKN, 2, SC_MASK_FOLDERS)
   ::SendEditor( SCI_SETMODEVENTMASK, SC_MOD_CHANGEFOLD, 0)
   ::SendEditor( SCI_SETMARGINSENSITIVEN, 2, 1)
   ::SendEditor( SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPEN, SC_MARK_ARROWDOWN)
   ::SendEditor( SCI_MARKERSETFORE, SC_MARKNUM_FOLDEROPEN,50000)
   ::SendEditor( SCI_MARKERSETBACK, SC_MARKNUM_FOLDEROPEN, 0)
   ::SendEditor( SCI_MARKERDEFINE, SC_MARKNUM_FOLDER, SC_MARK_ARROW)
   ::SendEditor( SCI_MARKERSETFORE, SC_MARKNUM_FOLDER, 50000)
   ::SendEditor( SCI_MARKERSETBACK, SC_MARKNUM_FOLDER, 0)
   ::SendEditor( SCI_SETINDENTATIONGUIDES, 1, 0)
   ::SendEditor( SCI_SETHIGHLIGHTGUIDE, 30, 0)



   ::SetFixedFont()
   ::SetSavePoint()

//   ::SetColor( 0, RGB( 222,222,222) )
   ::Prueba()


return Self

*********************************************************************************************************************************
   METHOD SetColor( nClrText, nClrPane ) CLASS TScintilla
*********************************************************************************************************************************


::SendEditor( SCI_STYLESETFORE, STYLE_DEFAULT, nClrText )
::SendEditor( SCI_STYLESETBACK, STYLE_DEFAULT, nClrPane )

return nil

*********************************************************************************************************************************
   METHOD Open() CLASS TScintilla
*********************************************************************************************************************************
local cFileName

cFileName := cGetFile("*.prg", "Seleccione fichero prg")

if !file( cFileName )
   return .f.
endif

::OpenFile( cFileName )

::oWnd:cTitle := "Med - [" + cFileName + "]"

::SetFixedFont()


return nil

METHOD Default() CLASS TScintilla

   local cSintax := "aadd abrwposrec2 abs achoice aclone3 acopy addfontresource adel adir adrives aeval afields afill afindfile agetworkareas ains alert alias alltrim altd amididevices ansilower ansitooem ansiupper aodata appendmenu arc aread arg array asave asc asend asize asort at atail atcbrwposrec atreebmps auxgetcaps auxgetdev auxgetvol auxsetvol b2bin baradjust barinvert barpaint beginpaint bin2d bin2i bin2l bin2w bindtoport bitblt blobdirectget blobdirectimport blobdirectput blobexport blobget blobimport blobrootget blobrootlock blobrootput blobrootunlock bof break bringwindo browse btndisable btnpaint buildcommdcb calldll calldll32 callwindowproc cargv cchr2data cctrl2chr cdlg2chr cdow cfiledisk cfileext cfilemask cfilename cfilenoext cfilepath cfilesubdir cfreadline cgetdir cgetdir32 cgetexpression cgetfile cgetfile32 cgetnewalias changeproc checkmenu childwindo choosecolor choosefont chord chr classcreat clientip clienttoscreen closeclipboard closecomm closemetafile closesocket closewindow closezipfile cmdistruct cmimedec cmimeenc cmonth cnewfilename cntxkey col colorselect colorsqty cputype createcare createcdc createdc createdlgindirect createfont createhatch createmenu createoleobject createpattern createpen createpopupmenu createsolidbrush createwindow crestostr cstrword ctempfile ctl3dlook ctod ctrldrawfo curdir curdrive cursor cursorarrow cursorcatch cursorhand cursoribeam cursorns cursorsize cursorwait cursorwe cvaltochar d2bin date day dbappend dbclearfilter dbclearindex dbclearrelation dbcloseall dbclosearea dbcommit " //+;
                 //"dbcommitall dbcreate dbcreateindex dbcretein dbdelete dbedit dbeval dbf dbfcdx dbfcdxax dbfieldinfo dbfileget dbfileput dbfilter dbfntx dbgobottom dbgoto dbgotop dbinfo dborderinfo dbpack dbpx dbrecall dbrecordinfo dbreindex dbrelation dbrlock dbrlocklist dbrselect dbrunlock dbseek dbselectarea dbsetdefa dbsetdriver dbsetfilter dbsetindex dbsetorder dbsetrelation dbskip dbstruct dbunlock dbunlockall dbusearea dbzap ddeaccessdata ddeack ddeclientt ddecmpstri ddecommand ddeconnect ddedisconn ddefreestr ddegetcommand ddegetdata ddeinitial ddequeryst ddeterminate ddeuniniti decrypt defwindowp deldbfmdx deleted deletedc deletemeta deleteobject delinientr delinisect delresource delwndbrus descend destroycursor destroyico destroymenu destroywindow devmode devout devoutpict devpos dialogboxindirect dibdraw dibfrombitmap dibheight dibpalette dibread dibwidth dibwrite dirchange directory dirmake dirremove diskchange diskname diskspace dispbegin dispbox dispend dispout ditbackgrd dlgfindtext doserror dotsadjust dow dptolp draftmode dragaccept dragfinish dragquerypoint drawbitmap drawfocusr drawgrayed drawgrid drawicon drawmasked drawmenuba drawmsgitem drawtext dtoc dtos duprecord editcell ellipse empty emptyclipboard enablecomm enablemenu enablewindow encrypt enddialog enddoc endmonitor endpage endpaint enumfontfa eof errorblock errorlevel escape escapecomm eval existwnd exitwindowsexec exp extfloodfi extracticon exttextout fattrib fclose fcount fcreate ferase ferror ffmimedec ffmimeenc fieldblock fieldget fieldpos fieldput fieldtype "+;
                 //"fieldwblock file fillevent fillrect findexecut findresource findtext findwindow fklabel fkmax flock floodfill flushcomm fmimedec fmimeenc foldpaint fopen found fread freadstr freelib32 freelibrary frename fseek fsize fwbitmap fwbrushes fwrite gellipse getactive getactivewindow getapplykey getasynckey getbkcolor getcapture getcaretpos getclassname getclientrect getclpdata getcommerror getcoors getcpu getctrlid getcurdir getcursorpos getdatas getdc getdesktopwindow getdevicecaps getdialogbaseunits getdlgbase getdlgitem getdosetkey getdrawite getdrawmenu getdropinfo getenv getfirstinzip getfocus getfontinfo getframeproc getfreefil getfreespace getftime getgridsize gethelpfile gethelptopic gethostbyname gethostname gethwnd32 getinstance getip getkeystat getkeytoggle getlocal getmapmode getmdichlp getmeaitem getmenustate getmetabit getmetafile getmitemid getmodulefilename getnextinzip getnumtask getordnames getparam getparent getpeername getpixel getport getpostvalidate getprevalidate getprinter getproc32 getprocaddress getprofint getprofstr getprop getpvpprofstring getquery getreader getresources getscrollpos getservbyname getstockobject getsubmenu getsyscolor getsysdir getsysmetrics getsystemmenu gettasks gettextalign gettextcolor gettextheight gettextwidth gettickcount getversion getwindir getwindowword getwinflags getwintxtlength getwndapp getwndframe getwndrect getwndtask gfnterase gfntload gfntset gframe ggetpixel gline globaladdatom globalalloc globalcompact globaldata globalfree globalgeta globallock globalrealloc globalsize "+;
                 //"gmode gpolygon gputpixel grect gsetclip gsetexcl gsetpal gwriteat hardcr hasresources header helpindex helppopup helpsearch helptopic hextodec hidecaret hilimenuitem htons i2bin if iif indexext indexkey indexord inet_address inkey inporbyte insertmenu int interruptunregister invalidaterect invertrect isalpha isansi isansilower isansiupper iscdrom ischild iscolor isdefbutton isdigit isdiskette isiconic islower ismenu isoem isoverwnd isprinter isupper iswin95 iswindowvisible iswinnt iszip iszoomed joygetdevcaps joygetnumdevs joygetthreshold joysetcapture joysetthre keyfast keytoggle killtimer l2bin land largefonts lastmenu lastrec lbxdrawitem lbxgetitem lbxgetselitems lbxmeasure lchdir lclose lcreat left len lfn2sfn lgettextline lineto lisdir listen llfnmkdir llfnrmdir lmdiiexist lmidioutopen lmkdir loadaccelerators loadbitmap loadcursor loadicon loadlib32 loadlibrary loadmenu loadresource loadstring loadvalue localshrink log logevent logfile logstatics lopen lower lptodp lrmdir lsaveobject ltrim lwrunning lxor lzcopyfile makewin max maxcol maxrow mcigeterrorstring mcisendcommand mcisendstring mcol mdblclk mdictrladjust mdirecedit measureitem memoedit memoline memoread memory memosetsuper memotran memowrit memstat memvarblock menubegin menudrawitem menuend menumeasureitem menumodal messagebox meterpaint mgetcreate mgetline mgetreplace mhide midinoteon min mlcount mlctopos mleftdown mlpos mod modifymenu month moreheap moveget moveto movewindow mpostolc mpresent mreststate mrightdown mrow msavestate msetbounds msetclip msetcursor "+;
                 //"msetpos msgabout msgalert msgbeep msgdate msgget msginfo msglist msglogo msgmeter msgnoyes msgpaint msgretrycancel msgrun msgsound msgstop msgtoolbar msgwait msgyesno mshow mstate nand nargc nbmpheight ncolorton ndbl2flt nddesharesetinfo ndlgbox nextdlgtabitem nextmem nfilecrc ngetbackrgb ngetforergb nhex nicons nmciopen nmciplay nmciwindow nmididevices nmsgbox nnot nor nrandom nrgb nrgbblue nrgbgreen nrgbred nseriala nserialhd nstrcrc nstrhash ntcwrow ntxpos ntxtlines nwindows nwndchrheight nwrow nwrows nxor oclone oemtoansi openclipboard opencomm oread osend outportbyte outpudebugstring paint3d palbmpdraw palbmpload palbmpread palbtnpain paramcount pbmpcolors pbmpheigh pbmpwidth peekbyte peekmessage peekword pie playmetafile pokebyte pokeword polypolygon postmessage postquitmessage printeresc printerini printersetup prnbinsource prngetdriver prngetname prngetorientation prngetport prngetsize prnlandscape prnoffset prnportrait prnsetcopies prnsetpage prnsetsize raconst radial raenumconnections raenumentries ragetconst rageterror rahangup ras_dialentry readbitmap readcomm readeven readvar realizepalette rectangle rectdotted recv regclosekey regcreatekey regdeletekey regenumkey registerclass regopenkey regqueryvalue regsetvalue releasecapture releasedc removefont removemenu removeprop report resetdc resourcefree restoredc restproc rlnew rpreview rptaddcolumn rptaddgroup rptbegin rptend savedc say3d scan screentoclient scrollwindow selectobject selectpalette sendbinary sendmessage serverip set3dlook setactivewindow setbkcolor "+;
                 //"setbkmode setblackpen setbrushorg setcapture setcaretpos setclassword setclipboarddata setclpdata setcommstate setcurdrive setcursor setdate setdeskwallpaper setdropinfo setfocus setftime setgridsize sethandlecount setidleaction setmapmode setmenu setminmax setmultiple setparent setpixel setpolyfillmode setprop setresources setsockopt settextalign settextcolor settextjustification settime settimer setvieworg setviewportext setwhitepen setwin95look setwindowtext setwnddefault shellabout shellexecute showcaret showcursor showwindow sndplayres sndplaysound socket socketselect spoolfile startdoc startmonitor startpage startplayback startrecord stopplayback stoprecord strbyte strcapfirst strchar strcpy strtoken symname symstat symtblat symtbllen sysrefresh systime syswait tabctrladd tabspaint tcbrwscrol tcdrawcell terminateapp textout thisstruct time timercount timerevent trackpopupmenu treebegin treeend tvinsertitem uchartoval uloadstruct unescape unzipfile updatewindow uvalblank virtualrdd waitrun wbrwline wbrwpane wbrwscroll wbrwselbox windowfrompoint winexec winhelp winuser wndadjbottom wndadjcliente wndadjleft wndadjright wndadjtop wndbitmap wndbottom wndbox wndboxin wndboxraised wndbrush wndcenter wndcopy wndhasscrolls wndheight wndhlineraised wndhraised wndinset wndleft wndmain wndprint wndraised wndsetsize wndtop wndvlineraised wndvraised wndwidth wnetaddconnection wnetbrowse wnetconnectdialog wnetdisconnectdialog wneterror wnetgeterrortext wnetgetuser worksheet writecomm writepprostring wrtieprofstring wsaasyncselect "+;
                 //"wsacleanup wsagetlasterror wsastartup wsay wsayrect wscroll xpadc xpadl xpadr zipblock zipfile zipmsg zipname zipsize ziptype "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      */
/*
   SendMessage( ::hWnd,SCI_SETKEYWORDS, 0, cSintax )

   SendMessage( ::hWnd,SCI_STYLESETFORE, SCE_HJ_KEYWORD, rgb(255,0,0))
   SendMessage( ::hWnd,SCI_STYLESETBACK, SCE_HJ_KEYWORD, rgb(255,255,255))
*/

return ""



*********************************************************************************************************************************
   METHOD Save() CLASS TScintilla
*********************************************************************************************************************************
local hMani
local cFile

if empty( ::cFileName ) .or. !file( ::cFileName )
   cFile := cGetFile( , "Salvar", 0, CurDrive() + ":\" + CurDir(), .t., .t.)
   ::cFileName := cFile
endif

hMani := Fcreate( ::cFileName )
fwrite( hMani, ::GetText() )
fclose( hMani )
::oWnd:cTitle := "Med - [" + ::cFileName + "]"


return nil

*********************************************************************************************************************************
   METHOD OpenFile( cFileName ) CLASS TScintilla
*********************************************************************************************************************************
local cStr

cStr := MemoRead( cFileName )

::SetText( cStr )
::cFilename := cFileName

if ascan( ::aMrus, cFileName ) == 0
   aadd( ::aMrus, cFileName )
endif

AddFile( cFileName )

return nil //SCI_OpenFile( ::hWnd, cFileName )
/*

*********************************************************************************************************************************
      METHOD GetTextRange( nLin0, nCol0, nLin1, nCol1  ) CLASS TScintilla
*********************************************************************************************************************************
DEFAULT nLin0 := 1
DEFAULT nCol0 := 1
DEFAULT nLin1 := -1
DEFAULT nCol1 := -1

return ::SC_GetTextRange( ::hWnd, nLin0, nCol0, nLin1, nCol1 )
*/

#define CFACENAME 14
#define ALTURA    1
#define BOLD      5
#define ITALIC    6
#define UNDERLINE 7

*********************************************************************************************************************************
  METHOD OptionSetFont() CLASS TScintilla
*********************************************************************************************************************************
local oFont
LOCAL aFont

DEFINE FONT oFont FROM USER


if abs(oFont:nInpHeight ) < 5
   MsgStop( "Operación cancelada" )
   return nil
endif

::StyleSetFont      (::GetCurrentStyle(), oFont:cFaceName )
::StyleSetSize      (::GetCurrentStyle(), abs(oFont:nSize) )
::StyleSetBold      (::GetCurrentStyle(), oFont:lBold  )
::StyleSetItalic    (::GetCurrentStyle(), oFont:lItalic )
::StyleSetUnderline (::GetCurrentStyle(), oFont:lUnderline )

oFont:End()

return nil

*********************************************************************************************************************************
   METHOD GetCurrentStyle() CLASS TScintilla
*********************************************************************************************************************************
local nPos := ::SendEditor(SCI_GETCURRENTPOS, 0, 0)

return ::SendEditor(SCI_GETSTYLEAT, nPos, 0)

**********************************************************************************************
 METHOD StyleSetFont( nStyle, cFontName ) CLASS TScintilla
**********************************************************************************************

return ::SendEditor( SCI_STYLESETFONT, nStyle, cFontName)

**********************************************************************************************
 METHOD StyleSetFore( nStyle, fore) CLASS TScintilla
**********************************************************************************************
return ::SendEditor( SCI_STYLESETFORE, nStyle, fore)

**********************************************************************************************
 METHOD StyleSetBold( nStyle,  bold ) CLASS TScintilla
**********************************************************************************************
return ::SendEditor( SCI_STYLESETBOLD, nStyle, bold )

**********************************************************************************************
 METHOD StyleSetItalic( nStyle,  italic) CLASS TScintilla
**********************************************************************************************
return ::SendEditor( SCI_STYLESETITALIC, nStyle, italic)

**********************************************************************************************
 METHOD StyleSetSize( nStyle,  nSizePoints ) CLASS TScintilla
**********************************************************************************************
return ::SendEditor( SCI_STYLESETSIZE, nStyle, nSizePoints)

**********************************************************************************************
 METHOD StyleSetUnderline( nStyle,  underline ) CLASS TScintilla
**********************************************************************************************
return ::SendEditor( SCI_STYLESETUNDERLINE, nStyle, underline)



**********************************************************************************************
 METHOD SetFixedFont() CLASS TScintilla
**********************************************************************************************

::StyleSetFont      (::GetCurrentStyle(), "Courier New" )
::StyleSetSize      (::GetCurrentStyle(), 10 )
::StyleSetBold      (::GetCurrentStyle(), .f.  )
::StyleSetItalic    (::GetCurrentStyle(), .f. )
::StyleSetUnderline (::GetCurrentStyle(), .f. )



return nil

**********************************************************************************************
 METHOD GetModify() CLASS TScintilla
**********************************************************************************************

return ::SendEditor( SCI_GETMODIFY, 0, 0) != 0


**********************************************************************************************
METHOD Print() CLASS TScintilla
**********************************************************************************************

     LOCAL nRecno, oFont
     local o := self

     DEFINE FONT oFont NAME "Courier New" SIZE 0,-12
            // Font sizes for PRINTING are given in "points" not pixels.
            // (Pixels are used for font width and height for SCREENS only.)
            // By using a "0" for width and a "-" in front of the "height" #
            // we tell FiveWin that we're using points instead of pixels.

            // Thus -12 means "12 point," which is used for "10 pitch"
            // non-proportionally spaced Courier type that prints at
            // 6 lines/inch.

            // -10 means a 10 point font printing at 7 lines/inch.

            // Use -9 for a "12 pitch" equal-spaced Courier font printing
            // at 8 lines per inch.


            // Note that in creating the report object, we are leaving out
            // any mention of title or header specs. because those are
            // already included in our .TXT file.
     REPORT oReport ;
          FONT oFont ;
          PREVIEW ;
          CAPTION "Text File Printout"
          //;          TO PRINTER


     COLUMN DATA " " SIZE 76  // * Trick "Data" - we're fooling Mother
                              // Nature here. The memo will go into the " ". *

     END REPORT

             // All title lines, page numbers and headings already exist in
             // our text file, so the next two code statements make sure that
             // FiveWin won't add its own title lines.
     oReport:nTitleUpLine := RPT_NOLINE
     oReport:nTitleDnLine := RPT_NOLINE
     oReport:Margin(.15,RPT_LEFT,RPT_INCHES)
     oReport:Margin(.25,RPT_TOP,RPT_INCHES)
     oReport:Margin(.25,RPT_BOTTOM,RPT_INCHES)
     // I know the top/bottom margins shown here should mathematically cause
     // more than the desired 60 lines per page to print. However, in actual
     // practice with my Panasonic KXP 4450 laser printer emulating the
     // HP LaserJet Plus, this is what I had to use to get 60 lines.  Why?
     // Inscrutible printer driver!  Maybe your printer driver functions in
     // a more mathematically logical fashion.  If so, adjust accordingly.
     // The left margin is set so small here because a margin is already
     // built into the text file itself (in this particular case).

     ACTIVATE REPORT oReport ON INIT o:SayMemo()

     oFont:End()

RETURN NIL

*------------------------

 METHOD SayMemo() CLASS TScintilla

     LOCAL cText, cLine
     LOCAL nFor, nLines, nPageln
     cText := ::GetText()
     nLines := ::GetLineCount()
     nPageln := 0
*     oReport:BackLine(1)     // Not needed here. If used, will cause printing
                              // of subsequent pages to get out of synch by
                              // pushing the start of printing down 1 line
                              // per page.

     FOR nFor := 1 TO nLines

          cLine := ::GetLine( nFor )
          cLine := substr( cLine, 1, len( cLine ) -2 )
          cLine := strtran( cLine, chr(9),"   " )
          cLine := strtran(str(nFor,5)," ","0") + "  " + cLine

          oReport:StartLine()
          oReport:Say(1,cLine)
          oReport:EndLine()

             // The following section checks to see if we've reached the
             // bottom of the page (60 lines). If so, it then calls
             // GetTop() to eliminate empty spaces in the text file between
             // the bottom of the outgoing page and the top line of the
             // next page.  The intent of this code is to get rid of the
             // empty lines that most report generators insert between pages
             // when output is to a text file -- otherwise our page printing
             // would get out of synch with the formating of the original
             // report. This approach only works where printing (including the
             // page number and other page heading data) is supposed to appear
             // at the same place at the top of every page.
          nPageln := nPageln + 1
          IF nPageln = 60
             nFor := GetTop(cText,nFor,nLines)
             nPageln := 0
          ENDIF

     NEXT

*    oReport:Newline()  // Only activate this line if you need to have the
                        // program eject another page upon completing printing.

RETURN NIL

*----------------------

STATIC FUNCTION GetTop(cText,nFor,nLines)
LOCAL Test := .T.,cLine
DO WHILE Test = .T. .AND. nFor <= nLines
   nFor := nFor + 1
   cLine := MemoLine(cText, 76, nFor)
   TEST := EMPTY(cLine)
ENDDO
nFor := nFor - 1
SysRefresh()   // Inserted to allow Windows to catch up with housekeeping
               // that was held up during the "DO WHILE."
RETURN nFor
*----------------------

function SetLastFind( c )
cLastFind := c
return c


****************************************************************************************************
  METHOD DlgFindText( ) CLASS TScintilla
****************************************************************************************************

local oDlg, oGet
local cText := ::GetSelText()
local oClp

if empty( cText )

    DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

    if oClp:Open()
       cText := oClp:GetText()
    endif
    oClp:End()

    if empty( cText )
       cText := if( empty(cLastFind),space(1), cLastFind )
    endif

endif

if mlcount( cText ) > 1
   cText := trim(memoline(cText,,1))
endif


@ 2, 2 GET oGet VAR cText SIZE 100, 25
oGet:Hide()

oDlg := DlgFindText( cText,oGet, {|cText| .t. }, Self )

return nil


#define VK_CTRL_F 6
#define VK_CTRL_K 11
#define VK_CTRL_DOT 190

****************************************************************************************************
METHOD KeyChar( nKey, nFlags ) CLASS TScintilla
****************************************************************************************************

::oWnd:cTitle := "keychar" +str(nKey)
do case
   case nKey == VK_CTRL_F
        ::DlgFindText()
        return 1
endcase

return super:KeyChar( nKey, nFlags )


****************************************************************************************************
METHOD KeyDown( nKey, nFlags ) CLASS TScintilla
****************************************************************************************************
local lControl := GetKeyState( VK_CONTROL )
local lShift := GetKeyState( VK_SHIFT )
local n

::oWnd:cTitle := "keydown" +str(nKey)

do case
   case nKey == VK_CTRL_DOT
        ::DlgFindText()
        return 1

   case nKey == VK_UP .and. lControl

        ::cLineBuffer := ::GetLine( ::nLine() )

        return 1

      case nKey == VK_DOWN .and. lControl

        if !empty( ::cLineBuffer )
           n := ::GetCurrentPos()
           ::SendEditor(SCI_HOME,0,0)
           ::InsertText(::GetCurrentPos(),::cLineBuffer)
           ::SetSel(n,n)
           ::GoLeft()
           ::GoRight()
        endif

        return 1

    case nKey == VK_NEXT

         ::PageDown()
         return 1

    case nKey == VK_PRIOR

         ::PageUp()
         return 1

endcase

return super:KeyDown( nKey, nFlags )


function Lfn2SfnEx( cDir )
local cDirEx := ""
local nDirs := len( cDir ) - len(strtran( cDir, "\", "" ))
local nEn, n
local cAux

for n := 1 to nDirs
    nEn := FindChar( cDir, "\", n )
    cAux := left( cDir, nEn )
    cDirEx := Lfn2Sfn( cAux )
    //? cAux, cDirEx
next

cAux := cDirEx + substr( cDir, nEn+1 )
cDirEx := cAux

return cDirEx

function FindChar( cStr, cChar, nOcurrence )
local nCount := 0
local nLen := len( cStr )
local c, n

for n := 1 to nLen
    if substr( cStr, n, len( cChar ) ) == cChar
       if nOcurrence == ++nCount
          nCount := n
          exit
       endif
    endif
next

return nCount

*****************************************************************************************************
   METHOD SendAsEmail( lAttach ) CLASS TScintilla
*****************************************************************************************************

   local oMail
   DEFAULT lAttach := .f.

   if lAttach
      DEFINE MAIL oMail ;
         SUBJECT "Envio de fichero" ;
         TEXT ::cFileName ;
         FILES ::cFileName,::cFileName ;
         FROM USER ;
         RECEIPT
   else
      DEFINE MAIL oMail ;
         SUBJECT "Envio de fichero" ;
         TEXT ::GetText() ;
         FROM USER ;
         RECEIPT
   endif
   ACTIVATE MAIL oMail



return nil











METHOD SetAStyle( style, fore, back, size, face ) CLASS TScintilla

DEFAULT size := 0
DEFAULT face := ""
DEFAULT back := CLR_WHITE


	::SendEditor( SCI_STYLESETFORE, style, fore )
	::SendEditor( SCI_STYLESETBACK, style, back )
	if size >= 1
		::SendEditor( SCI_STYLESETSIZE, style, size )
	endif
	if !empty( face )
		::SendEditor( SCI_STYLESETFONT, style, face )
	endif

return nil


METHOD Prueba() CLASS TScintilla


local htmlKeyWords
local c1 := "aadd abrwposrec2 abs achoice aclone3 acopy addfontresource adel adir adrives aeval afields afill afindfile agetworkareas ains alert "    +;
	"alias alltrim altd amididevices ansilower ansitooem ansiupper aodata appendmenu arc aread arg array asave asc asend asize asort at "    +;
	"atail atcbrwposrec atreebmps auxgetcaps auxgetdev auxgetvol auxsetvol b2bin baradjust barinvert barpaint beginpaint bin2d bin2i bin2l "    +;
	"bin2w bindtoport bitblt blobdirectget blobdirectimport blobdirectput blobexport blobget blobimport blobrootget blobrootlock "    +;
	"blobrootput blobrootunlock bof break bringwindo browse btndisable btnpaint buildcommdcb calldll calldll32 callwindowproc cargv "    +;
	"cchr2data cctrl2chr cdlg2chr cdow cfiledisk cfileext cfilemask cfilename cfilenoext cfilepath cfilesubdir cfreadline cgetdir cgetdir32 "    +;
	"cgetexpression cgetfile cgetfile32 cgetnewalias changeproc checkmenu childwindo choosecolor choosefont chord chr classcreat clientip "    +;
	"clienttoscreen closeclipboard closecomm closemetafile closesocket closewindow closezipfile cmdistruct cmimedec cmimeenc cmonth "    +;
	"cnewfilename cntxkey col colorselect colorsqty cputype createcare createcdc createdc createdlgindirect createfont createhatch "
local c2 :=	"createmenu createoleobject createpattern createpen createpopupmenu createsolidbrush createwindow crestostr cstrword ctempfile ctl3dlook "    +;
	"ctod ctrldrawfo curdir curdrive cursor cursorarrow cursorcatch cursorhand cursoribeam cursorns cursorsize cursorwait cursorwe "    +;
	"cvaltochar d2bin date day dbappend dbclearfilter dbclearindex dbclearrelation dbcloseall dbclosearea dbcommit dbcommitall dbcreate "  +;
	"dbcreateindex dbcretein dbdelete dbedit dbeval dbf dbfcdx dbfcdxax dbfieldinfo dbfileget dbfileput dbfilter dbfntx dbgobottom dbgoto "    +;
	"dbgotop dbinfo dborderinfo dbpack dbpx dbrecall dbrecordinfo dbreindex dbrelation dbrlock dbrlocklist dbrselect dbrunlock dbseek "+;
	"dbselectarea dbsetdefa dbsetdriver dbsetfilter dbsetindex dbsetorder dbsetrelation dbskip dbstruct dbunlock dbunlockall dbusearea "+;
	"dbzap ddeaccessdata ddeack ddeclientt ddecmpstri ddecommand ddeconnect ddedisconn ddefreestr ddegetcommand ddegetdata ddeinitial "+;
	"ddequeryst ddeterminate ddeuniniti decrypt defwindowp deldbfmdx deleted deletedc deletemeta deleteobject delinientr delinisect "+;
	"delresource delwndbrus descend destroycursor destroyico destroymenu destroywindow devmode devout devoutpict devpos dialogboxindirect "
local c3 :=	"dibdraw dibfrombitmap dibheight dibpalette dibread dibwidth dibwrite dirchange directory dirmake dirremove diskchange diskname "    +;
	"diskspace dispbegin dispbox dispend dispout ditbackgrd dlgfindtext doserror dotsadjust dow dptolp draftmode dragaccept dragfinish "    +;
	"dragquerypoint drawbitmap drawfocusr drawgrayed drawgrid drawicon drawmasked drawmenuba drawmsgitem drawtext dtoc dtos duprecord "    +;
	"editcell ellipse empty emptyclipboard enablecomm enablemenu enablewindow encrypt enddialog enddoc endmonitor endpage endpaint "    +;
	"enumfontfa eof errorblock errorlevel escape escapecomm eval existwnd exitwindowsexec exp extfloodfi extracticon exttextout fattrib "    +;
	"fclose fcount fcreate ferase ferror ffmimedec ffmimeenc fieldblock fieldget fieldpos fieldput fieldtype fieldwblock file fillevent "    +;
	"fillrect findexecut findresource findtext findwindow fklabel fkmax flock floodfill flushcomm fmimedec fmimeenc foldpaint fopen found "    +;
	"fread freadstr freelib32 freelibrary frename fseek fsize fwbitmap fwbrushes fwrite gellipse getactive getactivewindow getapplykey "    +;
	"getasynckey getbkcolor getcapture getcaretpos getclassname getclientrect getclpdata getcommerror getcoors getcpu getctrlid getcurdir "    +;
	"getcursorpos getdatas getdc getdesktopwindow getdevicecaps getdialogbaseunits getdlgbase getdlgitem getdosetkey getdrawite getdrawmenu "    +;
	"getdropinfo getenv getfirstinzip getfocus getfontinfo getframeproc getfreefil getfreespace getftime getgridsize gethelpfile gethelptopic "
local c4 :=	"gethostbyname gethostname gethwnd32 getinstance getip getkeystat getkeytoggle getlocal getmapmode getmdichlp getmeaitem getmenustate "    +;
	"getmetabit getmetafile getmitemid getmodulefilename getnextinzip getnumtask getordnames getparam getparent getpeername getpixel "    +;
	"getport getpostvalidate getprevalidate getprinter getproc32 getprocaddress getprofint getprofstr getprop getpvpprofstring getquery "    +;
	"getreader getresources getscrollpos getservbyname getstockobject getsubmenu getsyscolor getsysdir getsysmetrics getsystemmenu gettasks "    +;
	"gettextalign gettextcolor gettextheight gettextwidth gettickcount getversion getwindir getwindowword getwinflags getwintxtlength "    +;
	"getwndapp getwndframe getwndrect getwndtask gfnterase gfntload gfntset gframe ggetpixel gline globaladdatom globalalloc globalcompact "    +;
	"globaldata globalfree globalgeta globallock globalrealloc globalsize gmode gpolygon gputpixel grect gsetclip gsetexcl gsetpal gwriteat "    +;
	"hardcr hasresources header helpindex helppopup helpsearch helptopic hextodec hidecaret hilimenuitem htons i2bin if iif indexext indexkey "    +;
	"indexord inet_address inkey inporbyte insertmenu int interruptunregister invalidaterect invertrect isalpha isansi isansilower isansiupper "
local c5 :=	"iscdrom ischild iscolor isdefbutton isdigit isdiskette isiconic islower ismenu isoem isoverwnd isprinter isupper iswin95 iswindowvisible "    +;
	"iswinnt iszip iszoomed joygetdevcaps joygetnumdevs joygetthreshold joysetcapture joysetthre keyfast keytoggle killtimer l2bin land "    +;
	"largefonts lastmenu lastrec lbxdrawitem lbxgetitem lbxgetselitems lbxmeasure lchdir lclose lcreat left len lfn2sfn lgettextline lineto "    +;
	"lisdir listen llfnmkdir llfnrmdir lmdiiexist lmidioutopen lmkdir loadaccelerators loadbitmap loadcursor loadicon loadlib32 loadlibrary "    +;
	"loadmenu loadresource loadstring loadvalue localshrink log logevent logfile logstatics lopen lower lptodp lrmdir lsaveobject ltrim "    +;
	"lwrunning lxor lzcopyfile makewin max maxcol maxrow mcigeterrorstring mcisendcommand mcisendstring mcol mdblclk mdictrladjust mdirecedit         "    +;
	"measureitem memoedit memoline memoread memory memosetsuper memotran memowrit memstat memvarblock menubegin menudrawitem menuend                  "    +;
	"menumeasureitem menumodal messagebox meterpaint mgetcreate mgetline mgetreplace mhide midinoteon min mlcount mlctopos mleftdown mlpos            "    +;
	"mod modifymenu month moreheap moveget moveto movewindow mpostolc mpresent mreststate mrightdown mrow msavestate msetbounds msetclip              "    +;
	"msetcursor msetpos msgabout msgalert msgbeep msgdate msgget msginfo msglist msglogo msgmeter msgnoyes msgpaint msgretrycancel msgrun             "
local c6 :=	"msgsound msgstop msgtoolbar msgwait msgyesno mshow mstate nand nargc nbmpheight ncolorton ndbl2flt nddesharesetinfo ndlgbox nextdlgtabitem       "    +;
	"nextmem nfilecrc ngetbackrgb ngetforergb nhex nicons nmciopen nmciplay nmciwindow nmididevices nmsgbox nnot nor nrandom nrgb nrgbblue            "    +;
	"nrgbgreen nrgbred nseriala nserialhd nstrcrc nstrhash ntcwrow ntxpos ntxtlines nwindows nwndchrheight nwrow nwrows nxor oclone oemtoansi         "    +;
	"openclipboard opencomm oread osend outportbyte outpudebugstring paint3d palbmpdraw palbmpload palbmpread palbtnpain paramcount pbmpcolors        "    +;
	"pbmpheigh pbmpwidth peekbyte peekmessage peekword pie playmetafile pokebyte pokeword polypolygon postmessage postquitmessage printeresc          "    +;
	"printerini printersetup prnbinsource prngetdriver prngetname prngetorientation prngetport prngetsize prnlandscape prnoffset prnportrait          "    +;
	"prnsetcopies prnsetpage prnsetsize raconst radial raenumconnections raenumentries ragetconst rageterror rahangup ras_dialentry readbitmap        "    +;
	"readcomm readeven readvar realizepalette rectangle rectdotted recv regclosekey regcreatekey regdeletekey regenumkey registerclass                "
local c7 :=	"regopenkey regqueryvalue regsetvalue releasecapture releasedc removefont removemenu removeprop report resetdc resourcefree restoredc             "    +;
	"restproc rlnew rpreview rptaddcolumn rptaddgroup rptbegin rptend savedc say3d scan screentoclient scrollwindow selectobject selectpalette        "    +;
	"sendbinary sendmessage serverip set3dlook setactivewindow setbkcolor setbkmode setblackpen setbrushorg setcapture setcaretpos                    "    +;
	"setclassword setclipboarddata setclpdata setcommstate setcurdrive setcursor setdate setdeskwallpaper setdropinfo setfocus setftime               "    +;
	"setgridsize sethandlecount setidleaction setmapmode setmenu setminmax setmultiple setparent setpixel setpolyfillmode setprop setresources        "    +;
	"setsockopt settextalign settextcolor settextjustification settime settimer setvieworg setviewportext setwhitepen setwin95look setwindowtext      "    +;
	"setwnddefault shellabout shellexecute showcaret showcursor showwindow sndplayres sndplaysound socket socketselect spoolfile startdoc             "    +;
	"startmonitor startpage startplayback startrecord stopplayback stoprecord strbyte strcapfirst strchar strcpy strtoken symname symstat             "
local c8 :=	"symtblat symtbllen sysrefresh systime syswait tabctrladd tabspaint tcbrwscrol tcdrawcell terminateapp textout thisstruct time timercount         "    +;
	"timerevent trackpopupmenu treebegin treeend tvinsertitem uchartoval uloadstruct unescape unzipfile updatewindow uvalblank virtualrdd             "    +;
	"waitrun wbrwline wbrwpane wbrwscroll wbrwselbox windowfrompoint winexec winhelp winuser wndadjbottom wndadjcliente wndadjleft wndadjright        "    +;
	"wndadjtop wndbitmap wndbottom wndbox wndboxin wndboxraised wndbrush wndcenter wndcopy wndhasscrolls wndheight wndhlineraised wndhraised          "    +;
	"wndinset wndleft wndmain wndprint wndraised wndsetsize wndtop wndvlineraised wndvraised wndwidth wnetaddconnection wnetbrowse wnetconnectdialog  "    +;
	"wnetdisconnectdialog wneterror wnetgeterrortext wnetgetuser worksheet writecomm writepprostring wrtieprofstring wsaasyncselect wsacleanup        "    +;
	"wsagetlasterror wsastartup wsay wsayrect wscroll xpadc xpadl xpadr zipblock zipfile zipmsg zipname zipsize ziptype method class from data classdata                             "

local jsKeyWords := ;
	"if else endif do while enddo case endcase otherwise"



local red, offWhite, darkGreen, darkBlue, lightBlue
local bstyle  := SCE_HB_DEFAULT
local bastyle := SCE_HBA_DEFAULT
local n
local jstyle  := SCE_HJ_DEFAULT
local jastyle := SCE_HJA_DEFAULT
local black   := CLR_BLACK
local white   := CLR_WHITE

htmlKeyWords := c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8


	//::SendEditor(SCI_SETLEXER, SCLEX_FLAGSHIP )
//	::SendEditor(SCI_SETSTYLEBITS, 7)

	::SendEditor(SCI_SETKEYWORDS, 0, htmlKeyWords)
	::SendEditor(SCI_SETKEYWORDS, 1, jsKeyWords)

	::SetAStyle(SCE_FS_KEYWORD, CLR_HRED)
//	::SendEditor( SCI_STYLESETBOLD, SCE_FS_KEYWORD, 1)


	::SetAStyle( SCE_FS_COMMENTLINE, CLR_GREEN)
	::SetAStyle( SCE_FS_OPERATOR, CLR_HBLUE)
	::SetAStyle( SCE_FS_STRING, CLR_CYAN)
	::SetAStyle( SCE_FS_PREPROCESSOR, RGB(92,92,92) )
	::SendEditor( SCI_STYLESETBACK, SCE_FS_PREPROCESSOR, RGB(255,255,192))
	::SendEditor( SCI_STYLESETFONT, SCE_FS_PREPROCESSOR, "Courier New")

        ::StyleSetFont      (SCE_FS_KEYWORD, "Courier New" )//"Fixedsys" )
        ::StyleSetSize      (SCE_FS_KEYWORD, 10 )
        ::StyleSetBold      (SCE_FS_KEYWORD, .t.  )
        ::StyleSetItalic    (SCE_FS_KEYWORD, .f. )
        ::StyleSetUnderline (SCE_FS_KEYWORD, .f. )


/*
	// Set up the global default style. These attributes are used wherever no explicit choices are made.
	::SetAStyle(STYLE_DEFAULT, black, white, 10, "Verdana")
	//::SendEditor(SCI_STYLECLEARALL)	// Copies global style to all other

	red       := RGB(0xFF, 0, 0)
	offWhite  := RGB(0xFF, 0xFB, 0xF0)
	darkGreen := RGB(0, 0x80, 0)
	darkBlue  := RGB(0, 0, 0x80)

	// Hypertext default is used for all the document's text
	//::SetAStyle(SCE_H_DEFAULT, CLR_BLACK, CLR_WHITE, 11, "Times New Roman")
/*
# Lexical states for SCLEX_FLAGSHIP (clipper)
lex FlagShip=SCLEX_FLAGSHIP SCE_B_
val SCE_FS_DEFAULT=0
val SCE_FS_COMMENT=1
val SCE_FS_COMMENTLINE=2
val SCE_FS_COMMENTDOC=3
val SCE_FS_COMMENTLINEDOC=4
val SCE_FS_COMMENTDOCKEYWORD=5
val SCE_FS_COMMENTDOCKEYWORDERROR=6
val SCE_FS_KEYWORD=7
val SCE_FS_KEYWORD2=8
val SCE_FS_KEYWORD3=9
val SCE_FS_KEYWORD4=10
val SCE_FS_NUMBER=11
val SCE_FS_STRING=12
val SCE_FS_PREPROCESSOR=13
val SCE_FS_OPERATOR=14
val SCE_FS_IDENTIFIER=15
val SCE_FS_DATE=16
val SCE_FS_STRINGEOL=17
val SCE_FS_CONSTANT=18
val SCE_FS_ASM=19
val SCE_FS_LABEL=20
val SCE_FS_ERROR=21
val SCE_FS_HEXNUMBER=22
val SCE_FS_BINNUMBER=23

::SetAStyle( SCE_FS_STRING, CLR_YELLOW, CLR_BLUE )


	// Unknown tags and attributes are highlighed in red.
	// If a tag is actually OK, it should be added in lower case to the htmlKeyWords string.
	::SetAStyle(SCE_H_TAG, darkBlue)
	::SetAStyle(SCE_H_TAGUNKNOWN, red)
	::SetAStyle(SCE_H_ATTRIBUTE, darkBlue)
	::SetAStyle(SCE_H_ATTRIBUTEUNKNOWN, red)
	::SetAStyle(SCE_H_NUMBER, RGB(0x80,0,0x80))
	::SetAStyle(SCE_H_DOUBLESTRING, RGB(0,0x80,0))
	::SetAStyle(SCE_H_SINGLESTRING, RGB(0,0x80,0))
	::SetAStyle(SCE_H_OTHER, RGB(0x80,0,0x80))
	::SetAStyle(SCE_H_COMMENT, RGB(0x80,0x80,0))
	::SetAStyle(SCE_H_ENTITY, RGB(0x80,0,0x80))

	::SetAStyle(SCE_H_TAGEND, darkBlue)
	::SetAStyle(SCE_H_XMLSTART, darkBlue)	// <
	::SetAStyle(SCE_H_XMLEND, darkBlue)		// ?>
	::SetAStyle(SCE_H_SCRIPT, darkBlue)		// <scrip
	::SetAStyle(SCE_H_ASP, RGB(0x4F, 0x4F, 0), RGB(0xFF, 0xFF, 0))	// <% ... %
	::SetAStyle(SCE_H_ASPAT, RGB(0x4F, 0x4F, 0), RGB(0xFF, 0xFF, 0))	// <%@ ... %>

	::SetAStyle(SCE_HB_DEFAULT, black)
	::SetAStyle(SCE_HB_COMMENTLINE, darkGreen)
	::SetAStyle(SCE_HB_NUMBER, RGB(0,0x80,0x80))
	::SetAStyle(SCE_HB_WORD, darkBlue)
	::SendEditor(SCI_STYLESETBOLD, SCE_HB_WORD, 1)
	::SetAStyle(SCE_HB_STRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HB_IDENTIFIER, black)

	// This light blue is found in the windows system palette so is safe to use even in 256 colour modes.
	lightBlue := RGB(0xA6, 0xCA, 0xF0)
	// Show the whole section of VBScript with light blue background
	for n = bstyle to  SCE_HB_STRINGEOL

		::SendEditor(SCI_STYLESETFONT, n,"Georgia")
		::SendEditor(SCI_STYLESETBACK, n, lightBlue)
		// This call extends the backround colour of the last style on the line to the edge of the window
		::SendEditor(SCI_STYLESETEOLFILLED, n, 1)
	next

	::SendEditor(SCI_STYLESETBACK, SCE_HB_STRINGEOL, RGB(0x7F,0x7F,0xFF))
	::SendEditor(SCI_STYLESETFONT, SCE_HB_COMMENTLINE,"Comic Sans MS")

	::SetAStyle(SCE_HBA_DEFAULT, black)
	::SetAStyle(SCE_HBA_COMMENTLINE, darkGreen)
	::SetAStyle(SCE_HBA_NUMBER, RGB(0,0x80,0x80))
	::SetAStyle(SCE_HBA_WORD, darkBlue)
	::SendEditor(SCI_STYLESETBOLD, SCE_HBA_WORD, 1)
	::SetAStyle(SCE_HBA_STRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HBA_IDENTIFIER, black)

	// Show the whole section of ASP VBScript with bright yellow background
	for n = bastyle to SCE_HBA_STRINGEOL
		::SendEditor(SCI_STYLESETFONT, n,"Georgia")
		::SendEditor(SCI_STYLESETBACK, n, RGB(0xFF, 0xFF, 0))
		// This call extends the backround colour of the last style on the line to the edge of the window
		::SendEditor(SCI_STYLESETEOLFILLED, n, 1)
	next
	::SendEditor(SCI_STYLESETBACK, SCE_HBA_STRINGEOL, RGB(0xCF,0xCF,0x7F))
	::SendEditor(SCI_STYLESETFONT, SCE_HBA_COMMENTLINE,"Comic Sans MS")

	// If there is no need to support embedded Javascript, the following code can be dropped.
	// Javascript will still be correctly processed but will be displayed in just the default style.

	::SetAStyle(SCE_HJ_START, RGB(0x80,0x80,0))
	::SetAStyle(SCE_HJ_DEFAULT, black)
	::SetAStyle(SCE_HJ_COMMENT, darkGreen)
	::SetAStyle(SCE_HJ_COMMENTLINE, darkGreen)
	::SetAStyle(SCE_HJ_COMMENTDOC, darkGreen)
	::SetAStyle(SCE_HJ_NUMBER, RGB(0,0x80,0x80))
	::SetAStyle(SCE_HJ_WORD, black)
	::SetAStyle(SCE_HJ_KEYWORD, darkBlue)
	::SetAStyle(SCE_HJ_DOUBLESTRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HJ_SINGLESTRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HJ_SYMBOLS, black)

	::SetAStyle(SCE_HJA_START, RGB(0x80,0x80,0))
	::SetAStyle(SCE_HJA_DEFAULT, black)
	::SetAStyle(SCE_HJA_COMMENT, darkGreen)
	::SetAStyle(SCE_HJA_COMMENTLINE, darkGreen)
	::SetAStyle(SCE_HJA_COMMENTDOC, darkGreen)
	::SetAStyle(SCE_HJA_NUMBER, RGB(0,0x80,0x80))
	::SetAStyle(SCE_HJA_WORD, black)
	::SetAStyle(SCE_HJA_KEYWORD, darkBlue)
	::SetAStyle(SCE_HJA_DOUBLESTRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HJA_SINGLESTRING, RGB(0x80,0,0x80))
	::SetAStyle(SCE_HJA_SYMBOLS, black)

	// Show the whole section of Javascript with off white background
	for n := jstyle to SCE_HJ_SYMBOLS

		::SendEditor(SCI_STYLESETFONT, jstyle,"Lucida Sans Unicode")
		::SendEditor(SCI_STYLESETBACK, jstyle, offWhite)
		::SendEditor(SCI_STYLESETEOLFILLED, jstyle, 1)
	next
	::SendEditor(SCI_STYLESETBACK, SCE_HJ_STRINGEOL, RGB(0xDF, 0xDF, 0x7F))
	::SendEditor(SCI_STYLESETEOLFILLED, SCE_HJ_STRINGEOL, 1)

	// Show the whole section of Javascript with brown background
	for n := jastyle  to SCE_HJA_SYMBOLS
		::SendEditor(SCI_STYLESETFONT, jastyle,"Lucida Sans Unicode")
		::SendEditor(SCI_STYLESETBACK, jastyle, RGB(0xDF, 0xDF, 0x7F))
		::SendEditor(SCI_STYLESETEOLFILLED, jastyle, 1)
	next
	::SendEditor(SCI_STYLESETBACK, SCE_HJA_STRINGEOL, RGB(0x0,0xAF,0x5F))
	::SendEditor(SCI_STYLESETEOLFILLED, SCE_HJA_STRINGEOL, 1)
*/
return nil

**********************************************************************************************
  METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TScintilla
**********************************************************************************************

   local nCode := GetNMHDRCode( nPtrNMHDR )
   local line_number, position

   if nCode == SCN_MARGINCLICK
      position :=  GetPosHdr( nPtrNMHDR )
      line_number := ::SendEditor(SCI_LINEFROMPOSITION, position, 0)
      ::MarkerAdd( line_number, 1)

   endif

return nil











*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************
*****************************************************************************************************

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"
#include "commctrl.h"
#include "include\Scintilla.h"


int GetHdr( LPARAM lParam )
{
   struct SCNotification *pMsg =
       (struct SCNotification*)lParam;
    return (pMsg->position);
}



HB_FUNC( GETPOSHDR )
{
   hb_retni( GetHdr( hb_parnl( 1 ) ));
}



BOOL SearchForward( HWND hWnd, LPSTR szText, int nSearchFlags ) //@parm text to search
{
   long lPos;
   TEXTTOFIND tf;
   if (szText == NULL)
      return FALSE;
   lPos = SendMessage(hWnd, SCI_GETCURRENTPOS, 0, 0);
   tf.lpstrText = szText;
   tf.chrg.cpMin = lPos+1;
   tf.chrg.cpMax = SendMessage( hWnd, SCI_GETLENGTH, 0, 0);
   lPos = SendMessage( hWnd, SCI_FINDTEXT, (int) nSearchFlags, (long)&tf);
   if (lPos >= 0)
   {
      SetFocus( hWnd );
      SendMessage( hWnd, SCI_GOTOPOS, lPos, 0);
      SendMessage( hWnd, SCI_SETSEL, tf.chrgText.cpMin, tf.chrgText.cpMax);
      SendMessage( hWnd, SCI_FINDTEXT, (int) nSearchFlags, (long)&tf);
      return TRUE;
   }
   return FALSE;
}
/////////////////////////////////////
// @mfunc Search backward for a given string and select it if found. You may use regular expressions on the text.
// @rvalue BOOL | TRUE if text is ffound else FALSE
//
BOOL SearchBackward( HWND hWnd, LPSTR szText, int nSearchFlags ) //@parm text to search
{
   int lPos;
   int lMinSel;
   TEXTTOFIND tf;
   if (szText == NULL)
      return FALSE;
   lPos = SendMessage(hWnd, SCI_GETCURRENTPOS, 0, 0);
   lMinSel = SendMessage(hWnd,SCI_GETSELECTIONSTART, 0, 0);
   tf.lpstrText = szText;
   if (lMinSel >= 0)
      tf.chrg.cpMin = lMinSel-1;
   else
      tf.chrg.cpMin = lPos-1;
   tf.chrg.cpMax = 0;
   lPos = SendMessage( hWnd, SCI_FINDTEXT, (int) nSearchFlags, (long)&tf);
   if (lPos >= 0)
   {
      SetFocus(hWnd);
      SendMessage( hWnd, SCI_GOTOPOS, lPos, 0);
      SendMessage( hWnd, SCI_SETSEL, tf.chrgText.cpMin, tf.chrgText.cpMax);
      SendMessage( hWnd, SCI_FINDTEXT, (int) nSearchFlags, (long)&tf);
      return TRUE;
   }
   return FALSE;
}


HB_FUNC( SC_ADDTEXT )
{
    SendMessage( (HWND) hb_parnl( 1 ) , SCI_ADDTEXT, hb_parclen( 2 ), (LPARAM) hb_parc( 2 )) ;
    hb_ret();
}

HB_FUNC( SCI_OPENFILE )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   char* fileName = hb_parc( 2 );

        char data[131072];
   FILE *fp;
   int lenFile;

   SendMessage( hWnd, SCI_CLEARALL,0,0);
        SendMessage( hWnd, EM_EMPTYUNDOBUFFER, 0, 0);
        SendMessage( hWnd, SCI_SETSAVEPOINT, 0, 0);
        SendMessage( hWnd, SCI_CANCEL, 0, 0);
        SendMessage( hWnd, SCI_SETUNDOCOLLECTION, 0, 0);

        fp = fopen(fileName, "rb");
        if (fp) {
                lenFile = fread(data, 1, sizeof(data), fp);
                while (lenFile > 0) {
                        SendMessage( hWnd, SCI_ADDTEXT, lenFile, (LPARAM) data );
                        lenFile = fread(data, 1, sizeof(data), fp);
                }
                fclose(fp);
        } else {
                MessageBox(0, "No puedo abrir el fichero", "Atención", MB_OK);
        }
        SendMessage( hWnd, SCI_SETUNDOCOLLECTION, 1, 0);
        SetFocus( hWnd );
        SendMessage( hWnd, EM_EMPTYUNDOBUFFER, 0, 0);
        SendMessage( hWnd, SCI_SETSAVEPOINT, 0, 0 );
        SendMessage( hWnd, SCI_GOTOPOS, 0, 0);
   hb_ret();
}

HB_FUNC( SC_GETTEXT )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   int wLen;
   BYTE * pbyBuffer;
   wLen = SendMessage( hWnd, SCI_GETLENGTH, 0, 0 );
   pbyBuffer = ( char * ) hb_xgrab( wLen+1 );

   SendMessage( hWnd, SCI_GETTEXT, wLen+1, (LPARAM) pbyBuffer );

   hb_retclen( ( char * ) pbyBuffer, wLen+1 );
   hb_xfree( pbyBuffer );
}


HB_FUNC( SC_GETLINE )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   int nLine = hb_parni( 2 )-1;
   int wLen;
   BYTE * pbyBuffer;
   wLen = SendMessage( hWnd, SCI_LINELENGTH, nLine, 0 );
   if( wLen )
   {
      pbyBuffer = ( char * ) hb_xgrab( wLen+1 );
      SendMessage( hWnd, SCI_GETLINE, nLine, (LPARAM) pbyBuffer );
      hb_retclen( ( char * ) pbyBuffer, wLen );
      hb_xfree( pbyBuffer );
   }
   else
      hb_retc("");

}

HB_FUNC( SC_ISREADONLY )
{
    hb_retl( SendMessage( (HWND) hb_parnl( 1 ), SCI_GETREADONLY, 0, 0 ) );
}
/*
HB_FUNC( SC_GETTEXTRANGE )
{


}
#define SCFIND_WHOLEWORD 2
#define SCFIND_MATCHCASE 4
#define SCFIND_WORDSTART 0x00100000
#define SCFIND_REGEXP 0x00200000
#define SCFIND_POSIX 0x00400000
*/


HB_FUNC( SEARCHFORWARD )
{
   hb_retl(SearchForward( (HWND) hb_parnl( 1 ), hb_parc( 2 ), hb_parni( 3 ) ));
}
HB_FUNC( SEARCHBACKWARD )
{
    hb_retl(SearchBackward((HWND) hb_parnl( 1 ), hb_parc( 2 ), hb_parni( 3 ) ));
}


HB_FUNC ( C5GETSELTEXT )
{
   HWND hWnd = (HWND) hb_parnl( 1 );
   int wSize = hb_parni( 2 );
   LPSTR cBuff = ( char * ) hb_xgrab( wSize + 1 );

   SendMessage( hWnd, SCI_GETSELTEXT, (WPARAM)0, (LPARAM)cBuff );

   hb_retclen( cBuff, wSize );
   hb_xfree( cBuff );
}




#pragma ENDDUMP



