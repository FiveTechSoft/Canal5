
//----------------------------------------------------------------------------//
//                  Definiciones de winuser para myGUI                        //
//----------------------------------------------------------------------------//

#ifndef __WINUSER__
    #define __WINUSER__

#define CW_USEDEFAULT       2147483648

#define BM_GETCHECK                                                          240
#define BM_SETCHECK                                                          241
#define BM_GETSTATE                                                          242
#define BM_SETSTATE                                                          243
#define BM_SETSTYLE                                                          242
#define BM_CLICK                                                             245
#define BM_GETIMAGE                                                          246
#define BM_SETIMAGE                                                          247

#define BS_SOLID                                                               0
#define BS_NULL                                                                1
#define BS_HOLLOW                                                        BS_NULL
#define BS_HATCHED                                                             2
#define BS_PATTERN                                                             3
#define BS_INDEXED                                                             4
#define BS_DIBPATTERN                                                          5

#define BS_PUSHBUTTON                                                          0
#define BS_DEFPUSHBUTTON                                                       1
#define BS_CHECKBOX                                                            2
#define BS_AUTOCHECKBOX                                                        3
#define BS_RADIOBUTTON                                                         4
#define BS_3STATE                                                              5
#define BS_AUTO3STATE                                                          6
#define BS_GROUPBOX                                                            7
#define BS_USERBUTTON                                                          8
#define BS_AUTORADIOBUTTON                                                     9
#define BS_OWNERDRAW                                                          11
#define BS_LEFTTEXT                                                           32
#define BS_TEXT                                                                0
#define BS_ICON                                                               64
#define BS_BITMAP                                                            128
#define BS_LEFT                                                              256
#define BS_RIGHT                                                             512
#define BS_CENTER                                                            768
#define BS_TOP                                                              1024
#define BS_BOTTOM                                                           2048
#define BS_VCENTER                                                          3072
#define BS_PUSHLIKE                                                         4096
#define BS_MULTILINE                                                        8192
#define BS_NOTIFY                                                          16384
#define BS_FLAT                                                            32768
#define BS_RIGHTBUTTON                                               BS_LEFTTEXT

#define COLOR_SCROLLBAR	                                                       0
#define COLOR_BACKGROUND                                                       1
#define COLOR_ACTIVECAPTION                                                    2
#define COLOR_INACTIVECAPTION                                                  3
#define COLOR_MENU                                                             4
#define COLOR_WINDOW		                                                   5
#define COLOR_WINDOWFRAME	                                                   6
#define COLOR_MENUTEXT		                                                   7
#define COLOR_WINDOWTEXT	                                                   8
#define COLOR_CAPTIONTEXT  	                                                   9
#define COLOR_ACTIVEBORDER	                                                  10
#define COLOR_INACTIVEBORDER	                                              11
#define COLOR_APPWORKSPACE	                                                  12
#define COLOR_HIGHLIGHT		                                                  13
#define COLOR_HIGHLIGHTTEXT	                                                  14
#define COLOR_BTNFACE                                                         15
#define COLOR_BTNSHADOW                                                       16
#define COLOR_GRAYTEXT                                                        17
#define COLOR_BTNTEXT		                                                  18
#define COLOR_INACTIVECAPTIONTEXT                                             19
#define COLOR_BTNHIGHLIGHT                                                    20
#define COLOR_3DDKSHADOW                                                      -1
#define COLOR_3DLIGHT                                                         22

#define CBN_ERRSPACE                                                          -1
#define CBN_SELCHANGE                                                          1
#define CBN_DBLCLK                                                             2
#define CBN_SETFOCUS                                                           3
#define CBN_KILLFOCUS                                                          4
#define CBN_EDITCHANGE                                                         5
#define CBN_EDITUPDATE                                                         6
#define CBN_DROPDOWN                                                           7
#define CBN_CLOSEUP                                                            8
#define CBN_SELENDOK                                                           9
#define CBN_SELENDCANCEL                                                      10

#define CBS_SIMPLE                                                             1
#define CBS_DROPDOWN                                                           2
#define CBS_DROPDOWNLIST                                                       3
#define CBS_OWNERDRAWFIXED                                                    16
#define CBS_OWNERDRAWVARIABLE                                                 32
#define CBS_AUTOHSCROLL                                                       64
#define CBS_OEMCONVERT                                                       128
#define CBS_SORT                                                             256
#define CBS_HASSTRINGS                                                       512
#define CBS_NOINTEGRALHEIGHT                                                1024
#define CBS_DISABLENOSCROLL                                                 2048

#define CS_VREDRAW                                                             1
#define CS_HREDRAW                                                             2
#define CS_OWNDC                                                              32
#define CS_CLASSDC                                                            64
#define CS_PARENTDC                                                          128
#define CS_SAVEBITS                                                         2048
#define CS_DBLCLKS                                                             8
#define CS_BYTEALIGNCLIENT                                                  4096
#define CS_BYTEALIGNWINDOW                                                  8192
#define CS_NOCLOSE                                                           512
#define CS_KEYCVTWINDOW                                                        4
#define CS_NOKEYCVT                                                          256
#define CS_GLOBALCLASS                                                     16384

#define ANSI_CHARSET	                                                       0
#define DEFAULT_CHARSET                                                        1
#define SYMBOL_CHARSET	                                                       2
#define SHIFTJIS_CHARSET                                                     128
#define HANGEUL_CHARSET                                                      129
#define CHINESEBIG5_CHARSET                                                  136
#define OEM_CHARSET	                                                     255

#define DT_TOP                                                                 0
#define DT_LEFT                                                                0
#define DT_CENTER                                                              1
#define DT_RIGHT                                                               2
#define DT_VCENTER                                                             4
#define DT_BOTTOM                                                              8
#define DT_WORDBREAK                                                          16
#define DT_SINGLELINE                                                         32
#define DT_EXPANDTABS                                                         64
#define DT_TABSTOP                                                           128
#define DT_NOCLIP                                                            256
#define DT_EXTERNALLEADING                                                   512
#define DT_CALCRECT                                                         1024
#define DT_NOPREFIX                                                         2048
#define DT_INTERNAL                                                         4096

#define DS_ABSALIGN                                                            1
#define DS_SYSMODAL                                                            2
#define DS_LOCALEDIT                                                          32
#define DS_SETFONT                                                            64
#define DS_MODALFRAME                                                        128
#define DS_NOIDLEMSG                                                         256

#define EM_GETSEL                                                            176
#define EM_SETSEL                                                            177
#define EM_GETRECT                                                           178
#define EM_SETRECT                                                           179
#define EM_SETRECTNP                                                         180
#define EM_SCROLL                                                            181
#define EM_LINESCROLL                                                        182
#define EM_SCROLLCARET                                                       183
#define EM_GETMODIFY                                                         184
#define EM_SETMODIFY                                                         185
#define EM_GETLINECOUNT                                                      186
#define EM_LINEINDEX                                                         187
#define EM_SETHANDLE                                                         188
#define EM_GETHANDLE                                                         189
#define EM_GETTHUMB                                                          190
#define EM_LINELENGTH                                                        193
#define EM_REPLACESEL                                                        194
#define EM_GETLINE                                                           196
#define EM_LIMITTEXT                                                         197
#define EM_CANUNDO                                                           198
#define EM_UNDO                                                              199
#define EM_FMTLINES                                                          200
#define EM_LINEFROMCHAR                                                      201
#define EM_SETTABSTOPS                                                       203
#define EM_SETPASSWORDCHAR                                                   204
#define EM_EMPTYUNDOBUFFER                                                   205
#define EM_GETFIRSTVISIBLELINE                                               206
#define EM_SETREADONLY                                                       207
#define EM_SETWORDBREAKPROC                                                  208
#define EM_GETWORDBREAKPROC                                                  209
#define EM_GETPASSWORDCHAR                                                   210
#define EM_SETMARGINS                                                        211
#define EM_GETMARGINS                                                        212
#define EM_SETLIMITTEXT                                             EM_LIMITTEXT
#define EM_GETLIMITTEXT                                                      213
#define EM_POSFROMCHAR                                                       214
#define EM_CHARFROMPOS                                                       215

#define EN_SETFOCUS                                                          256
#define EN_KILLFOCUS                                                         512
#define EN_CHANGE                                                            768
#define EN_UPDATE                                                           1024
#define EN_ERRSPACE                                                         1280
#define EN_MAXTEXT                                                          1281
#define EN_HSCROLL                                                          1537
#define EN_VSCROLL                                                          1538

#define ES_LEFT                                                                0
#define ES_CENTER                                                              1
#define ES_RIGHT                                                               2
#define ES_MULTILINE                                                           4
#define ES_UPPERCASE                                                           8
#define ES_LOWERCASE                                                          16
#define ES_PASSWORD                                                           32
#define ES_AUTOVSCROLL                                                        64
#define ES_AUTOHSCROLL                                                       128
#define ES_NOHIDESEL                                                         256
#define ES_OEMCONVERT                                                       1024
#define ES_READONLY                                                         2048
#define ES_WANTRETURN                                                       4096
#define ES_NUMBER                                                           8192

#define ETO_GRAYED                                                             1
#define ETO_OPAQUE                                                             2
#define ETO_CLIPPED                                                            4

#define FW_DONTCARE                                                            0
#define FW_THIN                                                              100
#define FW_EXTRALIGHT                                                        200
#define FW_LIGHT                                                             300
#define FW_NORMAL                                                            400
#define FW_MEDIUM                                                            500
#define FW_SEMIBOLD                                                          600
#define FW_BOLD                                                              700
#define FW_EXTRABOLD                                                         800
#define FW_HEAVY                                                             900
#define FW_ULTRALIGHT                                              FW_EXTRALIGHT
#define FW_REGULAR                                                     FW_NORMAL
#define FW_DEMIBOLD                                                  FW_SEMIBOLD
#define FW_ULTRABOLD                                                FW_EXTRABOLD
#define FW_BLACK                                                        FW_HEAVY

#define OUT_DEFAULT_PRECIS                                                     0
#define OUT_STRING_PRECIS                                                      1
#define OUT_CHARACTER_PRECIS                                                   2
#define OUT_STROKE_PRECIS                                                      3
#define OUT_TT_PRECIS	                                                       4
#define OUT_DEVICE_PRECIS                                                      5
#define OUT_RASTER_PRECIS                                                      6
#define OUT_TT_ONLY_PRECIS                                                     7

#define CLIP_DEFAULT_PRECIS                                                    0
#define CLIP_CHARACTER_PRECIS                                                  1
#define CLIP_STROKE_PRECIS                                                     2
#define CLIP_MASK                                                             15
#define CLIP_LH_ANGLES                                                        16
#define CLIP_TT_ALWAYS	                                                      32
#define CLIP_EMBEDDED                                                        128

#define DEFAULT_QUALITY                                                        0
#define DRAFT_QUALITY                                                          1
#define PROOF_QUALITY                                                          2

#define DEFAULT_PITCH                                                          0
#define FIXED_PITCH                                                            1
#define VARIABLE_PITCH                                                         2

#define GWL_WNDPROC                                                           -4
#define GWW_HINSTANCE                                                         -6
#define GWW_HWNDPARENT                                                        -8
#define GWW_ID                                                               -12
#define GWL_STYLE                                                            -16
#define GWL_EXSTYLE                                                          -20

#define HTERROR                                                               -2
#define HTTRANSPARENT                                                         -1
#define HTNOWHERE                                                              0
#define HTCLIENT                                                               1
#define HTCAPTION                                                              2
#define HTSYSMENU                                                              3
#define HTSIZE                                                                 4
#define HTMENU                                                                 5
#define HTHSCROLL                                                              6
#define HTVSCROLL                                                              7
#define HTMINBUTTON                                                            8
#define HTMAXBUTTON                                                            9
#define HTLEFT                                                                10
#define HTRIGHT                                                               11
#define HTTOP                                                                 12
#define HTTOPLEFT                                                             13
#define HTTOPRIGHT                                                            14
#define HTBOTTOM                                                              15
#define HTBOTTOMLEFT                                                          16
#define HTBOTTOMRIGHT                                                         17
#define HTBORDER                                                              18
#define HTGROWBOX                                                         HTSIZE
#define HTREDUCE                                                     HTMINBUTTON
#define HTZOOM                                                       HTMAXBUTTON

#define HINSTANCE_ERROR                                                       32

#define HWND_DESKTOP                                                           0
#define HWND_TOP                                                               0
#define HWND_BOTTOM	                                                       1
#define HWND_TOPMOST                                                          -1
#define HWND_NOTOPMOST                                                        -2
#define HWND_BROADCAST	                                                      -1

#define HS_HORIZONTAL                                                          0
#define HS_VERTICAL                                                            1
#define HS_FDIAGONAL                                                           2
#define HS_BDIAGONAL                                                           3
#define HS_CROSS                                                               4
#define HS_DIAGCROSS                                                           5

#define IDOK                                                                   1
#define IDCANCEL                                                               2
#define IDABORT                                                                3
#define IDRETRY                                                                4
#define IDIGNORE                                                               5
#define IDYES                                                                  6
#define IDNO                                                                   7

#define IDC_ARROW                                                          32512
#define IDC_IBEAM                                                          32513
#define IDC_WAIT                                                           32514
#define IDC_CROSS                                                          32515
#define IDC_UPARROW	                                                       32516
#define IDC_SIZEALL                                                        32646
#define IDC_ICON                                                           32641
#define IDC_SIZENWSE                                                       32642
#define IDC_SIZENESW                                                       32643
#define IDC_SIZEWE                                                         32644
#define IDC_SIZENS                                                         32645
#define IDC_APPSTARTING                                                    32650
#define IDC_NO                                                            "crNo"
#define IDC_HANDPT                                                 "crHandPoint"

#define IDI_APPLICATION                                                    32512
#define IDI_HAND                                                           32513
#define IDI_QUESTION                                                       32514
#define IDI_EXCLAMATION                                                    32515
#define IDI_ASTERISK                                                       32516

#define DRIVERVERSION                                                          0
#define TECHNOLOGY                                                             2
#define HORZSIZE                                                               4
#define VERTSIZE                                                               6
#define HORZRES                                                                8
#define VERTRES                                                               10
#define BITSPIXEL                                                             12
#define PLANES                                                                14
#define NUMBRUSHES                                                            16
#define NUMPENS                                                               18
#define NUMMARKERS                                                            20
#define NUMFONTS                                                              22
#define NUMCOLORS                                                             24
#define PDEVICESIZE                                                           26
#define CURVECAPS                                                             28
#define LINECAPS                                                              30
#define POLYGONALCAPS                                                         32
#define TEXTCAPS                                                              34
#define CLIPCAPS                                                              36
#define RASTERCAPS                                                            38
#define ASPECTX                                                               40
#define ASPECTY                                                               42
#define ASPECTXY                                                              44
#define LOGPIXELSX                                                            88
#define LOGPIXELSY                                                            90
#define SIZEPALETTE                                                          104
#define NUMRESERVED                                                          106
#define COLORRES                                                             108

#define LB_ADDSTRING                                                         384
#define LB_INSERTSTRING                                                      385
#define LB_DELETESTRING                                                      386
#define LB_SELITEMRANGEEX                                                    387
#define LB_RESETCONTENT                                                      388
#define LB_SETSEL                                                            389
#define LB_SETCURSEL                                                         390
#define LB_GETSEL                                                            391
#define LB_GETCURSEL                                                         392
#define LB_GETTEXT                                                           393
#define LB_GETTEXTLEN                                                        394
#define LB_GETCOUNT                                                          395
#define LB_SELECTSTRING                                                      396
#define LB_DIR                                                               397
#define LB_GETTOPINDEX                                                       398
#define LB_FINDSTRING                                                        399
#define LB_GETSELCOUNT                                                       400
#define LB_GETSELITEMS                                                       401
#define LB_SETTABSTOPS                                                       402
#define LB_GETHORIZONTALEXTENT                                               403
#define LB_SETHORIZONTALEXTENT                                               404
#define LB_SETCOLUMNWIDTH                                                    405
#define LB_ADDFILE                                                           406
#define LB_SETTOPINDEX                                                       407
#define LB_GETITEMRECT                                                       408
#define LB_GETITEMDATA                                                       409
#define LB_SETITEMDATA                                                       410
#define LB_SELITEMRANGE                                                      411
#define LB_SETANCHORINDEX                                                    412
#define LB_GETANCHORINDEX                                                    413
#define LB_SETCARETINDEX                                                     414
#define LB_GETCARETINDEX                                                     415
#define LB_SETITEMHEIGHT                                                     416
#define LB_GETITEMHEIGHT                                                     417
#define LB_FINDSTRINGEXACT                                                   418
#define LB_SETLOCALE                                                         421
#define LB_GETLOCALE                                                         422
#define LB_SETCOUNT                                                          423
#define LB_INITSTORAGE                                                       424
#define LB_ITEMFROMPOINT                                                     425
#define LB_MSGMAX                                                            432

#define LBN_ERRSPACE                                                      ( -2 )
#define LBN_SELCHANGE                                                          1
#define LBN_DBLCLK                                                             2
#define LBN_SELCANCEL                                                          3
#define LBN_SETFOCUS                                                           4
#define LBN_KILLFOCUS                                                          5

#define LBS_NOTIFY                                                             1
#define LBS_SORT                                                               2
#define LBS_NOREDRAW                                                           4
#define LBS_MULTIPLESEL                                                        8
#define LBS_OWNERDRAWFIXED                                                    16
#define LBS_OWNERDRAWVARIABLE                                                 32
#define LBS_HASSTRINGS                                                        64
#define LBS_USETABSTOPS                                                      128
#define LBS_NOINTEGRALHEIGHT                                                 256
#define LBS_MULTICOLUMN                                                      512
#define LBS_WANTKEYBOARDINPUT                                               1024
#define LBS_EXTENDEDSEL                                                     2048
#define LBS_DISABLENOSCROLL                                                 4096
#define LBS_NODATA                                                          8192
#define LBS_NOSEL                                                          16384
#define LBS_STANDARD          ( LBS_NOTIFY + LBS_SORT + WS_VSCROLL + WS_BORDER )

#define MF_INSERT                                                              0
#define MF_CHANGE                                                            128
#define MF_APPEND                                                            256
#define MF_DELETE                                                            512
#define MF_REMOVE                                                           4096
#define MF_BYCOMMAND                                                           0
#define MF_BYPOSITION                                                       1024
#define MF_SEPARATOR                                                        2048
#define MF_ENABLED                                                             0
#define MF_GRAYED                                                              1
#define MF_DISABLED                                                            2
#define MF_UNCHECKED                                                           0
#define MF_CHECKED                                                             8
#define MF_USECHECKBITMAPS                                                   512
#define MF_STRING                                                              0
#define MF_BITMAP                                                              4
#define MF_OWNERDRAW                                                         256
#define MF_POPUP                                                              16
#define MF_MENUBARBREAK                                                       32
#define MF_MENUBREAK                                                          64
#define MF_UNHILITE                                                            0
#define MF_HILITE                                                            128
#define MF_SYSMENU                                                          8192
#define MF_HELP                                                            16384
#define MF_MOUSESELECT                                                     32768

#define PM_NOREMOVE	                                                           0
#define PM_REMOVE                                                              1
#define PM_NOYIELD                                                             2

#define PS_SOLID                                                               0
#define PS_DASH                                                                1
#define PS_DOT                                                                 2
#define PS_DASHDOT                                                             3
#define PS_DASHDOTDOT                                                          4
#define PS_NULL                                                                5
#define PS_INSIDEFRAME                                                         6

#define SB_HORZ                                                                0
#define SB_VERT                                                                1
#define SB_CTL                                                                 2
#define SB_BOTH                                                                3

#define SB_LINEUP                                                              0
#define SB_LINELEFT                                                            0
#define SB_LINEDOWN                                                            1
#define SB_LINERIGHT                                                           1
#define SB_PAGEUP                                                              2
#define SB_PAGELEFT                                                            2
#define SB_PAGEDOWN                                                            3
#define SB_PAGERIGHT                                                           3
#define SB_THUMBPOSITION                                                       4
#define SB_THUMBTRACK                                                          5
#define SB_TOP                                                                 6
#define SB_LEFT                                                                6
#define SB_BOTTOM                                                              7
#define SB_RIGHT                                                               7
#define SB_ENDSCROLL                                                           8

#define SBS_HORZ                                                               0
#define SBS_VERT                                                               1
#define SBS_TOPALIGN                                                           2
#define SBS_LEFTALIGN                                                          2
#define SBS_BOTTOMALIGN                                                        4
#define SBS_RIGHTALIGN                                                         4
#define SBS_SIZEBOXTOPLEFTALIGN                                                2
#define SBS_SIZEBOXBOTTOMRIGHTALIGN                                            4
#define SBS_SIZEBOX                                                            8
#define SBS_SIZEGRIP                                                          16

#define SEM_FAILCRITICALERRORS                                                 1
#define SEM_NOGPFAULTERRORBOX                                                  2
#define SEM_NOOPENFILEERRORBOX                                             32768

#define SIZE_RESTORED	                                                       0
#define SIZE_MINIMIZED	                                                       1
#define SIZE_MAXIMIZED	                                                       2
#define SIZE_MAXSHOW	                                                       3
#define SIZE_MAXHIDE	                                                       4

#define SM_CXSCREEN                                                            0
#define SM_CYSCREEN	                                                       1
#define SM_CXVSCROLL	                                                       2
#define SM_CYHSCROLL	                                                       3
#define SM_CYCAPTION	                                                       4
#define SM_CXBORDER	                                                       5
#define SM_CYBORDER	                                                       6
#define SM_CXDLGFRAME	                                                       7
#define SM_CYDLGFRAME	                                                       8
#define SM_CYVTHUMB	                                                       9
#define SM_CXHTHUMB	                                                      10
#define SM_CXICON	                                                      11
#define SM_CYICON	                                                      12
#define SM_CXCURSOR	                                                      13
#define SM_CYCURSOR	                                                      14
#define SM_CYMENU	                                                      15
#define SM_CXFULLSCREEN                                                       16
#define SM_CYFULLSCREEN                                                       17
#define SM_CYKANJIWINDOW                                                      18
#define SM_MOUSEPRESENT                                                       19
#define SM_CYVSCROLL	                                                      20
#define SM_CXHSCROLL	                                                      21
#define SM_DEBUG	                                                      22
#define SM_SWAPBUTTON	                                                      23
#define SM_RESERVED1	                                                      24
#define SM_RESERVED2	                                                      25
#define SM_RESERVED3	                                                      26
#define SM_RESERVED4	                                                      27
#define SM_CXMIN	                                                      28
#define SM_CYMIN	                                                      29
#define SM_CXSIZE	                                                      30
#define SM_CYSIZE	                                                      31
#define SM_CXFRAME	                                                      32
#define SM_CYFRAME	                                                      33
#define SM_CXMINTRACK	                                                      34
#define SM_CYMINTRACK	                                                      35
#define SM_CXDOUBLECLK                                                        36
#define SM_CYDOUBLECLK                                                        37
#define SM_CXICONSPACING                                                      38
#define SM_CYICONSPACING                                                      39
#define SM_MENUDROPALIGNMENT                                                  40
#define SM_PENWINDOWS                                                         41
#define SM_DBCSENABLED                                                        42
#define SM_CMETRICS                                                           43

#define SW_HIDE		                                                       0
#define SW_SHOWNORMAL	                                                       1
#define SW_NORMAL	                                                       1
#define SW_SHOWMINIMIZED                                                       2
#define SW_SHOWMAXIMIZED                                                       3
#define SW_MAXIMIZE	                                                       3
#define SW_SHOWNOACTIVATE                                                      4
#define SW_SHOW		                                                       5
#define SW_MINIMIZE	                                                       6
#define SW_SHOWMINNOACTIVE                                                     7
#define SW_SHOWNA	                                                       8
#define SW_RESTORE                                                             9

#define SWP_NOSIZE                                                             1
#define SWP_NOMOVE                                                             2
#define SWP_NOZORDER                                                           4
#define SWP_NOREDRAW                                                           8
#define SWP_NOACTIVATE                                                        16
#define SWP_FRAMECHANGED                                                      32
#define SWP_SHOWWINDOW                                                        64
#define SWP_HIDEWINDOW                                                       128
#define SWP_NOCOPYBITS                                                       256
#define SWP_NOOWNERZORDER                                                    512
#define SWP_DRAWFRAME                                           SWP_FRAMECHANGED
#define SWP_NOREPOSITION                                       SWP_NOOWNERZORDER
#define SWP_NOSENDCHANGING                                                  1024
#define SWP_DEFERERASE                                                      8192

#define TRANSPARENT                                                            1
#define OPAQUE                                                                 2

#define MB_OK	                                                               0
#define MB_OKCANCEL                                                            1
#define MB_ABORTRETRYIGNORE                                                    2
#define MB_YESNOCANCEL                                                         3
#define MB_YESNO                                                               4
#define MB_RETRYCANCEL                                                         5
#define MB_TYPEMASK                                                           15
#define MB_ICONHAND                                                           16
#define MB_ICONQUESTION                                                       32
#define MB_ICONEXCLAMATION                                                    48
#define MB_ICONASTERISK                                                       64
#define MB_ICONMASK                                                          240
#define MB_ICONINFORMATION                                       MB_ICONASTERISK
#define MB_ICONSTOP                                                  MB_ICONHAND
#define MB_DEFBUTTON1                                                          0
#define MB_DEFBUTTON2                                                        256
#define MB_DEFBUTTON3                                                        512
#define MB_DEFMASK                                                          3840
#define MB_APPLMODAL                                                           0
#define MB_SYSTEMMODAL                                                      4096
#define MB_TASKMODAL                                                        8192
#define MB_NOFOCUS                                                         32768

#define VK_LBUTTON                                                             1
#define VK_RBUTTON                                                             2
#define VK_CANCEL                                                              3
#define VK_MBUTTON                                                             4
#define VK_BACK                                                                8
#define VK_TAB                                                                 9
#define VK_CLEAR                                                              12
#define VK_RETURN                                                             13
#define VK_SHIFT                                                              16
#define VK_CONTROL                                                            17
#define VK_MENU                                                               18
#define VK_PAUSE                                                              19
#define VK_CAPITAL                                                            20
#define VK_ESCAPE                                                             27
#define VK_SPACE                                                              32
#define VK_PRIOR                                                              33
#define VK_NEXT                                                               34
#define VK_END                                                                35
#define VK_HOME                                                               36
#define VK_LEFT                                                               37
#define VK_UP                                                                 38
#define VK_RIGHT                                                              39
#define VK_DOWN                                                               40
#define VK_SELECT                                                             41
#define VK_PRINT                                                              42
#define VK_EXECUTE                                                            43
#define VK_SNAPSHOT                                                           44
#define VK_INSERT                                                             45
#define VK_DELETE                                                             46
#define VK_HELP                                                               47
#define VK_NUMPAD0                                                            96
#define VK_NUMPAD1                                                            97
#define VK_NUMPAD2                                                            98
#define VK_NUMPAD3                                                            99
#define VK_NUMPAD4                                                           100
#define VK_NUMPAD5                                                           101
#define VK_NUMPAD6                                                           102
#define VK_NUMPAD7                                                           103
#define VK_NUMPAD8                                                           104
#define VK_NUMPAD9                                                           105
#define VK_MULTIPLY                                                          106
#define VK_ADD                                                               107
#define VK_SEPARATOR                                                         108
#define VK_SUBTRACT                                                          109
#define VK_DECIMAL                                                           110
#define VK_DIVIDE                                                            111
#define VK_F1                                                                112
#define VK_F2                                                                113
#define VK_F3                                                                114
#define VK_F4                                                                115
#define VK_F5                                                                116
#define VK_F6                                                                117
#define VK_F7                                                                118
#define VK_F8                                                                119
#define VK_F9                                                                120
#define VK_F10                                                               121
#define VK_F11                                                               122
#define VK_F12                                                               123
#define VK_F13                                                               124
#define VK_F14                                                               125
#define VK_F15                                                               126
#define VK_F16                                                               127
#define VK_F17                                                               128
#define VK_F18                                                               129
#define VK_F19                                                               130
#define VK_F20                                                               131
#define VK_F21                                                               132
#define VK_F22                                                               133
#define VK_F23                                                               134
#define VK_F24                                                               135
#define VK_NUMLOCK                                                           144
#define VK_SCROLL                                                            145

#define WA_INACTIVE                                                            0
#define WA_ACTIVE                                                              1
#define WA_CLICKACTIVE                                                         2

#define WHITE_BRUSH                                                            0
#define LTGRAY_BRUSH                                                           1
#define GRAY_BRUSH                                                             2
#define DKGRAY_BRUSH                                                           3
#define BLACK_BRUSH                                                            4
#define HOLLOW_BRUSH                                                           5
#define NULL_BRUSH                                                             5
#define WHITE_PEN                                                              6
#define BLACK_PEN                                                              7
#define NULL_PEN                                                               8
#define OEM_FIXED_FONT                                                        10
#define ANSI_FIXED_FONT                                                       11
#define ANSI_VAR_FONT                                                         12
#define SYSTEM_FONT                                                           13
#define DEVICE_DEFAULT_FONT                                                   14
#define DEFAULT_PALETTE                                                       15
#define SYSTEM_FIXED_FONT                                                     16

#define WM_COMPACTING                                                         65
#define WM_WININICHANGE                                                       26
#define WM_SYSCOLORCHANGE                                                     21
#define WM_QUERYNEWPALETTE                                                   783
#define WM_PALETTEISCHANGING                                                 784
#define WM_PALETTECHANGED                                                    785
#define WM_FONTCHANGE                                                         29
#define WM_SPOOLERSTATUS                                                      42
#define WM_DEVMODECHANGE                                                      27
#define WM_TIMECHANGE                                                         30
#define WM_NULL                                                                0
#define WM_USER                                                             1024
#define WM_PENWINFIRST                                                       896
#define WM_PENWINLAST                                                        911
#define WM_COALESCE_FIRST                                                    912
#define WM_COALESCE_LAST                                                     927
#define WM_POWER                                                              72
#define WM_QUERYENDSESSION                                                    17
#define WM_ENDSESSION                                                         22
#define WM_QUIT                                                               18
#define WM_SYSTEMERROR                                                        23
#define WM_CREATE                                                              1
#define WM_DESTROY                                                             2
#define WM_NCCREATE                                                          129
#define WM_NCDESTROY                                                         130
#define WM_SHOWWINDOW                                                         24
#define WM_SETREDRAW                                                          11
#define WM_ENABLE                                                             10
#define WM_SETTEXT                                                            12
#define WM_GETTEXT                                                            13
#define WM_GETTEXTLENGTH                                                      14
#define WM_WINDOWPOSCHANGING                                                  70
#define WM_WINDOWPOSCHANGED                                                   71
#define WM_MOVE                                                                3
#define WM_SIZE                                                                5
#define WM_QUERYOPEN                                                          19
#define WM_CLOSE                                                              16
#define WM_GETMINMAXINFO                                                      36
#define WM_PAINT                                                              15
#define WM_ERASEBKGND                                                         20
#define WM_ICONERASEBKGND                                                     39
#define WM_NCPAINT                                                           133
#define WM_NCCALCSIZE                                                        131
#define WM_NCHITTEST                                                         132
#define WM_QUERYDRAGICON                                                      55
#define WM_DROPFILES                                                         563
#define WM_ACTIVATE                                                            6
#define WM_ACTIVATEAPP                                                        28
#define WM_NCACTIVATE                                                        134
#define WM_SETFOCUS                                                            7
#define WM_KILLFOCUS                                                           8
#define WM_KEYDOWN                                                           256
#define WM_KEYUP                                                             257
#define WM_CHAR                                                              258
#define WM_DEADCHAR                                                          259
#define WM_SYSKEYDOWN                                                        260
#define WM_SYSKEYUP                                                          261
#define WM_SYSCHAR                                                           262
#define WM_SYSDEADCHAR                                                       263
#define WM_KEYFIRST                                                          256
#define WM_KEYLAST                                                           264
#define WM_MOUSEMOVE                                                         512
#define WM_LBUTTONDOWN                                                       513
#define WM_LBUTTONUP                                                         514
#define WM_LBUTTONDBLCLK                                                     515
#define WM_RBUTTONDOWN                                                       516
#define WM_RBUTTONUP                                                         517
#define WM_RBUTTONDBLCLK                                                     518
#define WM_MBUTTONDOWN                                                       519
#define WM_MBUTTONUP                                                         520
#define WM_MBUTTONDBLCLK                                                     521
#define WM_MOUSEFIRST                                                        512
#define WM_MOUSELAST                                                         521
#define WM_NCMOUSEMOVE                                                       160
#define WM_NCLBUTTONDOWN                                                     161
#define WM_NCLBUTTONUP                                                       162
#define WM_NCLBUTTONDBLCLK                                                   163
#define WM_NCRBUTTONDOWN                                                     164
#define WM_NCRBUTTONUP                                                       165
#define WM_NCRBUTTONDBLCLK                                                   166
#define WM_NCMBUTTONDOWN                                                     167
#define WM_NCMBUTTONUP                                                       168
#define WM_NCMBUTTONDBLCLK                                                   169
#define WM_MOUSEACTIVATE                                                      33
#define WM_CANCELMODE                                                         31
#define WM_TIMER                                                             275
#define WM_INITMENU                                                          278
#define WM_INITMENUPOPUP                                                     279
#define WM_MENUSELECT                                                        287
#define WM_MENUCHAR                                                          288
#define WM_COMMAND                                                           273
#define WM_HSCROLL                                                           276
#define WM_VSCROLL                                                           277
#define WM_SETCURSOR                                                          32
#define WM_SYSCOMMAND                                                        274
#define WM_MDICREATE                                                         544
#define WM_MDIDESTROY                                                        545
#define WM_MDIACTIVATE                                                       546
#define WM_MDIRESTORE                                                        547
#define WM_MDINEXT                                                           548
#define WM_MDIMAXIMIZE                                                       549
#define WM_MDITILE                                                           550
#define WM_MDICASCADE                                                        551
#define WM_MDIICONARRANGE                                                    552
#define WM_MDIGETACTIVE                                                      553
#define WM_MDISETMENU                                                        560
#define WM_CHILDACTIVATE                                                      34
#define WM_INITDIALOG                                                        272
#define WM_NEXTDLGCTL                                                         40
#define WM_NOTIFY                        78  // 0x004E
#define WM_PARENTNOTIFY                                                      528
#define WM_ENTERIDLE                                                         289
#define WM_GETDLGCODE                                                        135
#define WM_CTLCOLOR                                                           25
#define WM_SETFONT                                                            48
#define WM_GETFONT                                                            49
#define WM_DRAWITEM                                                           43
#define WM_MEASUREITEM                                                        44
#define WM_DELETEITEM                                                         45
#define WM_COMPAREITEM                                                        57
#define WM_QUEUESYNC                                                          35
#define WM_COMMNOTIFY                                                         68
#define WM_CUT                                                               768
#define WM_COPY                                                              769
#define WM_PASTE                                                             770
#define WM_CLEAR                                                             771
#define WM_UNDO                                                              772
#define WM_RENDERFORMAT                                                      773
#define WM_RENDERALLFORMATS                                                  774
#define WM_DESTROYCLIPBOARD                                                  775
#define WM_DRAWCLIPBOARD                                                     776
#define WM_PAINTCLIPBOARD                                                    777
#define WM_SIZECLIPBOARD                                                     779
#define WM_VSCROLLCLIPBOARD                                                  778
#define WM_HSCROLLCLIPBOARD                                                  782
#define WM_ASKCBFORMATNAME                                                   780
#define WM_CHANGECBCHAIN                                                     781
#define WM_SETICON                                                           128
#define WM_CTLCOLORMSGBOX                                                    306
#define WM_CTLCOLOREDIT                                                      307
#define WM_CTLCOLORLISTBOX                                                   308
#define WM_CTLCOLORBTN                                                       309
#define WM_CTLCOLORDLG                                                       310
#define WM_CTLCOLORSCROLLBAR                                                 311
#define WM_CTLCOLORSTATIC                                                    312

#define CB_USER                                                              320
//#define CB_USER                                                        WM_USER
#define CB_GETEDITSEL                                            ( CB_USER + 0 )
#define CB_LIMITTEXT                                             ( CB_USER + 1 )
#define CB_SETEDITSEL                                            ( CB_USER + 2 )
#define CB_ADDSTRING                                             ( CB_USER + 3 )
#define CB_DELETESTRING                                          ( CB_USER + 4 )
#define CB_DIR                                                   ( CB_USER + 5 )
#define CB_GETCOUNT                                              ( CB_USER + 6 )
#define CB_GETCURSEL                                             ( CB_USER + 7 )
#define CB_GETLBTEXT                                             ( CB_USER + 8 )
#define CB_GETLBTEXTLEN                                          ( CB_USER + 9 )
#define CB_INSERTSTRING                                         ( CB_USER + 10 )
#define CB_RESETCONTENT                                         ( CB_USER + 11 )
#define CB_FINDSTRING                                           ( CB_USER + 12 )
#define CB_SELECTSTRING                                         ( CB_USER + 13 )
#define CB_SETCURSEL                                            ( CB_USER + 14 )
#define CB_SHOWDROPDOWN                                         ( CB_USER + 15 )
#define CB_GETITEMDATA                                          ( CB_USER + 16 )
#define CB_SETITEMDATA                                          ( CB_USER + 17 )
#define CB_GETDROPPEDCONTROLRECT                                ( CB_USER + 18 )
#define CB_SETITEMHEIGHT                                        ( CB_USER + 19 )
#define CB_GETITEMHEIGHT                                        ( CB_USER + 20 )
#define CB_SETEXTENDEDUI                                        ( CB_USER + 21 )
#define CB_GETEXTENDEDUI                                        ( CB_USER + 22 )
#define CB_GETDROPPEDSTATE                                      ( CB_USER + 23 )
#define CB_FINDSTRINGEXACT                                      ( CB_USER + 24 )

#define VER_PLATFORM_WIN32s                                                    0
#define VER_PLATFORM_WIN32_WINDOWS                                             1
#define VER_PLATFORM_WIN32_NT                                                  2

#define WS_OVERLAPPED                                                          0
#define WS_POPUP                                                      2147483648
#define WS_CHILD                                                      1073741824
#define WS_CLIPSIBLINGS                                                 67108864
#define WS_CLIPCHILDREN                                                 33554432
#define WS_VISIBLE                                                     268435456
#define WS_DISABLED                                                    134217728
#define WS_MINIMIZE                                                    536870912
#define WS_MAXIMIZE                                                     16777216
#define WS_CAPTION                                                      12582912
#define WS_BORDER                                                        8388608
#define WS_DLGFRAME                                                      4194304
#define WS_VSCROLL                                                       2097152
#define WS_HSCROLL                                                       1048576
#define WS_SYSMENU                                                        524288
#define WS_THICKFRAME                                                     262144
#define WS_MINIMIZEBOX                                                    131072
#define WS_MAXIMIZEBOX                                                     65536
#define WS_GROUP                                                          131072
#define WS_TABSTOP                                                         65536
#define WS_OVERLAPPEDWINDOW        ( WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + ;
                                     WS_THICKFRAME + WS_MINIMIZEBOX + ;
                                     WS_MAXIMIZEBOX )
#define WS_POPUPWINDOW                     ( WS_POPUP + WS_BORDER + WS_SYSMENU )
#define WS_CHILDWINDOW                                                  WS_CHILD
#define WS_TILED                                                  WS_OVERLAPPED
#define WS_ICONIC                                                    WS_MINIMIZE
#define WS_SIZEBOX                                                 WS_THICKFRAME
#define WS_TILEDWINDOW                                       WS_OVERLAPPEDWINDOW

/*
 * Extended Window Styles
*/

#define WS_EX_DLGMODALFRAME               1
#define WS_EX_NOPARENTNOTIFY              4
#define WS_EX_TOPMOST                     8
#define WS_EX_ACCEPTFILES                16
#define WS_EX_TRANSPARENT                32
#define WS_EX_MDICHILD                   64
#define WS_EX_TOOLWINDOW                128
#define WS_EX_WINDOWEDGE                256
#define WS_EX_CLIENTEDGE                512
#define WS_EX_CONTEXTHELP              1024

#define WS_EX_RIGHT                    4096
#define WS_EX_LEFT                        0
#define WS_EX_RTLREADING               8192
#define WS_EX_LTRREADING                  0
#define WS_EX_LEFTSCROLLBAR           16384
#define WS_EX_RIGHTSCROLLBAR              0

#define WS_EX_CONTROLPARENT           65536
#define WS_EX_STATICEDGE             131072
#define WS_EX_APPWINDOW              262144

#define WS_EX_OVERLAPPEDWINDOW  (WS_EX_WINDOWEDGE + WS_EX_CLIENTEDGE)
#define WS_EX_PALETTEWINDOW     (WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST)

#define WS_EX_LAYERED               524288
#define WS_EX_NOINHERITLAYOUT       1048576 // Disable inheritence of mirroring by children
#define WS_EX_LAYOUTRTL             4194304 // Right to left mirroring
#define WS_EX_NOACTIVATE          134217728

 * User Button Notification Codes

  #define BN_CLICKED          0
  #define BN_PAINT            1
  #define BN_HILITE           2
  #define BN_UNHILITE         3
  #define BN_DISABLE          4
  #define BN_DOUBLECLICKED    5
  #define BN_PUSHED           BN_HILITE
  #define BN_UNPUSHED         BN_UNHILITE
  #define BN_DBLCLK           BN_DOUBLECLICKED
  #define BN_SETFOCUS         6
  #define BN_KILLFOCUS        7

#define IMAGE_BITMAP        0
#define IMAGE_ICON          1
#define IMAGE_CURSOR        2
#define IMAGE_ENHMETAFILE   3

#define LR_DEFAULTCOLOR          0
#define LR_MONOCHROME            1
#define LR_COLOR                 2
#define LR_COPYRETURNORG         4
#define LR_COPYDELETEORG         8
#define LR_LOADFROMFILE         16
#define LR_LOADTRANSPARENT      32
#define LR_DEFAULTSIZE          64
#define LR_VGACOLOR            128
#define LR_LOADMAP3DCOLORS    4096
#define LR_CREATEDIBSECTION   8192
#define LR_COPYFROMRESOURCE  16384
#define LR_SHARED            32768

/*
 * Static Control Mesages
 */

#define STM_SETICON            368
#define STM_GETICON            369
#define STM_SETIMAGE           370
#define STM_GETIMAGE           371
#define STN_CLICKED         0
#define STN_DBLCLK          1
#define STN_ENABLE          2
#define STN_DISABLE         3
#define STM_MSGMAX             372

/*
 * Static Control Constants
 */
#define SS_LEFT                       0
#define SS_CENTER                     1
#define SS_RIGHT                      2
#define SS_ICON                       3
#define SS_BLACKRECT                  4
#define SS_GRAYRECT                   5
#define SS_WHITERECT                  6
#define SS_BLACKFRAME                 7
#define SS_GRAYFRAME                  8
#define SS_WHITEFRAME                 9
#define SS_USERITEM                  10
#define SS_SIMPLE                    11
#define SS_LEFTNOWORDWRAP            12
#define SS_OWNERDRAW                 13
#define SS_BITMAP                    14
#define SS_ENHMETAFILE               15
#define SS_ETCHEDHORZ                16
#define SS_ETCHEDVERT                17
#define SS_ETCHEDFRAME               18
#define SS_TYPEMASK                  31
#define SS_NOPREFIX                 128 // Don't do "&" character translation
#define SS_NOTIFY                   256
#define SS_CENTERIMAGE              512
#define SS_RIGHTJUST               1024
#define SS_REALSIZEIMAGE           2048
#define SS_SUNKEN                  4096
#define SS_ENDELLIPSIS            16384
#define SS_PATHELLIPSIS           32768
#define SS_WORDELLIPSIS           49152
#define SS_ELLIPSISMASK           49152


/*
 * Class field offsets for GetClassLong()
 */
#define GCL_MENUNAME        (-8)
#define GCL_HBRBACKGROUND   (-10)
#define GCL_HCURSOR         (-12)
#define GCL_HICON           (-14)
#define GCL_HMODULE         (-16)
#define GCL_CBWNDEXTRA      (-18)
#define GCL_CBCLSEXTRA      (-20)
#define GCL_WNDPROC         (-24)
#define GCL_STYLE           (-26)
#define GCW_ATOM            (-32)

#endif

//----------------------------------------------------------------------------//

