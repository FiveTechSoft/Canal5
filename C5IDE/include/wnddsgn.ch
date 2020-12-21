#define DFC_CAPTION             1
#define DFC_MENU                2
#define DFC_SCROLL              3
#define DFC_BUTTON              4

#define DFC_POPUPMENU           5


#define DFCS_CAPTIONCLOSE       0x0000
#define DFCS_CAPTIONMIN         0x0001
#define DFCS_CAPTIONMAX         0x0002
#define DFCS_CAPTIONRESTORE     0x0003
#define DFCS_CAPTIONHELP        0x0004

#define DFCS_MENUARROW          0x0000
#define DFCS_MENUCHECK          0x0001
#define DFCS_MENUBULLET         0x0002
#define DFCS_MENUARROWRIGHT     0x0004
#define DFCS_SCROLLUP           0x0000
#define DFCS_SCROLLDOWN         0x0001
#define DFCS_SCROLLLEFT         0x0002
#define DFCS_SCROLLRIGHT        0x0003
#define DFCS_SCROLLCOMBOBOX     0x0005
#define DFCS_SCROLLSIZEGRIP     0x0008
#define DFCS_SCROLLSIZEGRIPRIGHT 0x0010

#define DFCS_BUTTONCHECK        0x0000
#define DFCS_BUTTONRADIOIMAGE   0x0001
#define DFCS_BUTTONRADIOMASK    0x0002
#define DFCS_BUTTONRADIO        0x0004
#define DFCS_BUTTON3STATE       0x0008
#define DFCS_BUTTONPUSH         0x0010

#define DFCS_INACTIVE           0x0100
#define DFCS_PUSHED             0x0200
#define DFCS_CHECKED            0x0400


#define DFCS_TRANSPARENT        0x0800
#define DFCS_HOT                0x1000


#define DFCS_ADJUSTRECT         0x2000
#define DFCS_FLAT               0x4000
#define DFCS_MONO               0x8000


/* 3D border styles */
#define BDR_RAISEDOUTER 0x0001
#define BDR_SUNKENOUTER 0x0002
#define BDR_RAISEDINNER 0x0004
#define BDR_SUNKENINNER 0x0008

#define BDR_OUTER       nOr(BDR_RAISEDOUTER , BDR_SUNKENOUTER)
#define BDR_INNER       nOr(BDR_RAISEDINNER , BDR_SUNKENINNER)
#define BDR_RAISED      nOr(BDR_RAISEDOUTER , BDR_RAISEDINNER)
#define BDR_SUNKEN      nOr(BDR_SUNKENOUTER , BDR_SUNKENINNER)


#define EDGE_RAISED     nOr(BDR_RAISEDOUTER , BDR_RAISEDINNER)
#define EDGE_SUNKEN     nOr(BDR_SUNKENOUTER , BDR_SUNKENINNER)
#define EDGE_ETCHED     nOr(BDR_SUNKENOUTER , BDR_RAISEDINNER)
#define EDGE_BUMP       nOr(BDR_RAISEDOUTER , BDR_SUNKENINNER)

/* Border flags */
#define BF_LEFT         0x0001
#define BF_TOP          0x0002
#define BF_RIGHT        0x0004
#define BF_BOTTOM       0x0008

#define BF_TOPLEFT      nOr(BF_TOP , BF_LEFT)
#define BF_TOPRIGHT     nOr(BF_TOP , BF_RIGHT)
#define BF_BOTTOMLEFT   nOr(BF_BOTTOM , BF_LEFT)
#define BF_BOTTOMRIGHT  nOr(BF_BOTTOM , BF_RIGHT)
#define BF_RECT         nOr(BF_LEFT , BF_TOP , BF_RIGHT , BF_BOTTOM)

#define BF_DIAGONAL     0x0010

// For diagonal lines, the BF_RECT flags specify the end point of the
// vector bounded by the rectangle parameter.
#define BF_DIAGONAL_ENDTOPRIGHT     nOr(BF_DIAGONAL , BF_TOP , BF_RIGHT)
#define BF_DIAGONAL_ENDTOPLEFT      nOr(BF_DIAGONAL , BF_TOP , BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMLEFT   nOr(BF_DIAGONAL , BF_BOTTOM , BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMRIGHT  nOr(BF_DIAGONAL , BF_BOTTOM , BF_RIGHT)


#define BF_MIDDLE       0x0800  /* Fill in the middle */
#define BF_SOFT         0x1000  /* For softer buttons */
#define BF_ADJUST       0x2000  /* Calculate the space left over */
#define BF_FLAT         0x4000  /* For flat rather than 3D borders */
#define BF_MONO         0x8000  /* For monochrome borders */


#define BOTON     1
#define RADIODSGN 2
#define CHECK     3

#define COLOR_MENU              4
#define COLOR_BTNFACE           15
#define SM_CYCAPTION            4
#define SM_CYSMCAPTION          51

#define DC_ACTIVE           0x0001
#define DC_SMALLCAP         0x0002
#define DC_ICON             0x0004
#define DC_TEXT             0x0008
#define DC_INBUTTON         0x0010
#define DC_GRADIENT         0x0020

#define TRANSPARENT         1
#define OPAQUE              2
#define COLOR_CAPTIONTEXT       9

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
#define DT_END_ELLIPSIS             0x00008000
#define DEFAULT_GUI_FONT    17
#define NULL_BRUSH          5
#define WHITE_PEN           6
#define COLOR_GRAYTEXT          17

#define WM_NCACTIVATE                   0x0086
#define WM_NCPAINT                      0x0085
#define TMT_TEXTCOLOR     3803

#define SWP_NOSIZE          0x0001
#define SWP_NOMOVE          0x0002
#define SWP_NOZORDER        0x0004
#define SWP_NOREDRAW        0x0008
#define SWP_NOACTIVATE      0x0010
#define SWP_FRAMECHANGED    0x0020  /* The frame changed: send WM_NCCALCSIZE */
#define SWP_SHOWWINDOW      0x0040
#define SWP_HIDEWINDOW      0x0080
#define SWP_NOCOPYBITS      0x0100
#define SWP_NOOWNERZORDER   0x0200  /* Don't do owner Z ordering */
#define SWP_NOSENDCHANGING  0x0400
#define WM_NCHITTEST     132  // 0x84
#define HTCLIENT            1
#define HTCAPTION           2
#define HTSYSMENU           3
#define HTGROWBOX           4
#define HTSIZE              HTGROWBOX
#define HTMENU              5
#define HTHSCROLL           6
#define HTVSCROLL           7
#define HTMINBUTTON         8
#define HTMAXBUTTON         9
#define HTLEFT              10
#define HTRIGHT             11
#define HTTOP               12
#define HTTOPLEFT           13
#define HTTOPRIGHT          14
#define HTBOTTOM            15
#define HTBOTTOMLEFT        16
#define HTBOTTOMRIGHT       17
#define HTBORDER            18
#define HTREDUCE            HTMINBUTTON
#define HTZOOM              HTMAXBUTTON
#define HTSIZEFIRST         HTLEFT
#define HTSIZELAST          HTBOTTOMRIGHT
#define TMT_COLOR           204
#define TMT_STRING          201
#define TMT_INT             202
#define TMT_BOOL            203

#define TMT_MARGINS         205
#define TMT_FILENAME        206
#define TMT_SIZE            207
#define TMT_POSITION        208
#define TMT_RECT            209
#define TMT_FONT            210
#define TMT_INTLIST         211

#define WM_NCMBUTTONUP                  0x00A8
#define LVM_FIRST           4096
#define LVM_GETVIEW         (4096 + 143)

#define TOPBAR   1
#define LEFTBAR  2
#define RIGHTBAR 3
#define DOWNBAR  4
#define FLOATBAR 5

#define DSGN_SELECT   0
#define DSGN_BTN      1
#define DSGN_CHEK     2
#define DSGN_GET      3
#define DSGN_COMBO    4
#define DSGN_LISTBOX  5
#define DSGN_GROUPBOX 6
#define DSGN_RADIO    7
#define DSGN_SAY      8
#define DSGN_PICTURE  9
#define DSGN_HSCROLL  10
#define DSGN_VSCROLL  11
#define DSGN_SLIDER   12
#define DSGN_SPIN     13
#define DSGN_PROGRESS 14
#define DSGN_LISTVIEW 15
#define DSGN_TREE     16
#define DSGN_TABCTRL  17
#define DSGN_CUSTOM   18
#define DSGN_VLINE    19
#define DSGN_HLINE    20
#define DSGN_STFRAME  22
#define DSGN_FOLDER   23
#define DSGN_BAR      24
#define DSGN_MENU     25
#define DSGN_BROWSE   26
#define DSGN_BTNBMP   27
#define DSGN_USER     28
#define DSGN_ICON     29
#define DSGN_PANEL    30
#define DSGN_VISTAMENU    31



#define CONSOLA_PRJ    1
#define WINDOWS_PRJ    2
#define PPCP_PRJ       3
#define LIBRERIA_PRJ   4
#define WIZZARD_PRJ    5

