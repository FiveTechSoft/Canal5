

/* Primitive types */
// #define TMT_STRING   201
// #define TMT_INT      202
// #define TMT_BOOL     203
// #define TMT_COLOR    204
// #define TMT_MARGINS  205
// #define TMT_FILENAME 206
// #define TMT_SIZE     207
// #define TMT_POSITION 208
// #define TMT_RECT     209
// #define TMT_FONT     210
// #define TMT_INTLIST  211


/* Enumerations */

/* BGTYPE Enum */
#define BT_IMAGEFILE  0
#define BT_BORDERFILL 1
#define BT_NONE       2

/* IMAGELAYOUT Enum */
#define IL_VERTICAL   0
#define IL_HORIZONTAL 1

/* BORDERTYPE Enum */
#define BT_RECT      0
#define BT_ROUNDRECT 1
#define BT_ELLIPSE   2

/* FILLTYPE Enum */
#define FT_SOLID          0
#define FT_VERTGRADIENT   1
#define FT_HORZGRADIENT   2
#define FT_RADIALGRADIENT 3
#define FT_TILEIMAGE      4

/* SIZINGTYPE Enum */
#define ST_TRUESIZE 0
#define ST_STRETCH  1
#define ST_TILE     2

/* HALIGN Enum */
#define HA_LEFT   0
#define HA_CENTER 1
#define HA_RIGHT  2

/* CONTENTALIGNMENT Enum */
#define CA_LEFT   0
#define CA_CENTER 1
#define CA_RIGHT  2

/* VALIGN Enum */
#define VA_TOP    0
#define VA_CENTER 1
#define VA_BOTTOM 2

/* OFFSETTYPE Enum */
#define OT_TOPLEFT           0
#define OT_TOPRIGHT          1
#define OT_TOPMIDDLE         2
#define OT_BOTTOMLEFT        3
#define OT_BOTTOMRIGHT       4
#define OT_BOTTOMMIDDLE      5
#define OT_MIDDLELEFT        6
#define OT_MIDDLERIGHT       7
#define OT_LEFTOFCAPTION     8
#define OT_RIGHTOFCAPTION    9
#define OT_LEFTOFLASTBUTTON  10
#define OT_RIGHTOFLASTBUTTON 11
#define OT_ABOVELASTBUTTON   12
#define OT_BELOWLASTBUTTON   13

/* ICONEFFECT Enum */
#define ICE_NONE   0
#define ICE_GLOW   1
#define ICE_SHADOW 2
#define ICE_PULSE  3
#define ICE_ALPHA  4

/* TEXTSHADOWTYPE Enum */
#define TST_NONE       0
#define TST_SINGLE     1
#define TST_CONTINUOUS 2

/* GLYPHTYPE Enum */
#define GT_NONE       0
#define GT_IMAGEGLYPH 1
#define GT_FONTGLYPH  2

/* IMAGESELECTTYPE Enum */
#define IST_NONE 0
#define IST_SIZE 1
#define IST_DPI  2

/* TRUESIZESCALINGTYPE Enum */
#define TSST_NONE 0
#define TSST_SIZE 1
#define TSST_DPI  2

/* GLYPHFONTSIZINGTYPE Enum */
#define GFST_NONE 0
#define GFST_SIZE 1
#define GFST_DPI  2


/* PROPERTIES */

/* Misc properties */
#define TMT_COLORSCHEMES 401
#define TMT_SIZES        402
#define TMT_CHARSET      403

/* Documentation properties */
#define TMT_DISPLAYNAME 601
#define TMT_TOOLTIP     602
#define TMT_COMPANY     603
#define TMT_AUTHOR      604
#define TMT_COPYRIGHT   605
#define TMT_URL         606
#define TMT_VERSION     607
#define TMT_DESCRIPTION 608
#define TMT_FIRST_RCSTRING_NAME   TMT_DISPLAYNAME
#define TMT_LAST_RCSTRING_NAME    TMT_DESCRIPTION

/* Font theme metric properties */
#define TMT_CAPTIONFONT      801
#define TMT_SMALLCAPTIONFONT 802
#define TMT_MENUFONT         803
#define TMT_STATUSFONT       804
#define TMT_MSGBOXFONT       805
#define TMT_ICONTITLEFONT    806
#define TMT_FIRSTFONT TMT_CAPTIONFONT
#define TMT_LASTFONT  TMT_ICONTITLEFONT

/* Bool theme metric properties */
#define TMT_FLATMENUS 1001
#define TMT_FIRSTBOOL   TMT_FLATMENUS
#define TMT_LASTBOOL    TMT_FLATMENUS

/* Size theme metric properties */
#define TMT_SIZINGBORDERWIDTH  1201
#define TMT_SCROLLBARWIDTH     1202
#define TMT_SCROLLBARHEIGHT    1203
#define TMT_CAPTIONBARWIDTH    1204
#define TMT_CAPTIONBARHEIGHT   1205
#define TMT_SMCAPTIONBARWIDTH  1206
#define TMT_SMCAPTIONBARHEIGHT 1207
#define TMT_MENUBARWIDTH       1208
#define TMT_MENUBARHEIGHT      1209
#define TMT_FIRSTSIZE   TMT_SIZINGBORDERWIDTH
#define TMT_LASTSIZE    TMT_MENUBARHEIGHT

/* Int theme metric properties */
#define TMT_MINCOLORDEPTH 1301
#define TMT_FIRSTINT   TMT_MINCOLORDEPTH
#define TMT_LASTINT    TMT_MINCOLORDEPTH

/* String theme metric properties */
#define TMT_CSSNAME 1401
#define TMT_XMLNAME 1402
#define TMT_FIRSTSTRING   TMT_CSSNAME
#define TMT_LASTSTRING    TMT_XMLNAME

/* Color theme metric properties */
#define TMT_SCROLLBAR               1601
#define TMT_BACKGROUND              1602
#define TMT_ACTIVECAPTION           1603
#define TMT_INACTIVECAPTION         1604
#define TMT_MENU                    1605
#define TMT_WINDOW                  1606
#define TMT_WINDOWFRAME             1607
#define TMT_MENUTEXT                1608
#define TMT_WINDOWTEXT              1609
#define TMT_CAPTIONTEXT             1610
#define TMT_ACTIVEBORDER            1611
#define TMT_INACTIVEBORDER          1612
#define TMT_APPWORKSPACE            1613
#define TMT_HIGHLIGHT               1614
#define TMT_HIGHLIGHTTEXT           1615
#define TMT_BTNFACE                 1616
#define TMT_BTNSHADOW               1617
#define TMT_GRAYTEXT                1618
#define TMT_BTNTEXT                 1619
#define TMT_INACTIVECAPTIONTEXT     1620
#define TMT_BTNHIGHLIGHT            1621
#define TMT_DKSHADOW3D              1622
#define TMT_LIGHT3D                 1623
#define TMT_INFOTEXT                1624
#define TMT_INFOBK                  1625
#define TMT_BUTTONALTERNATEFACE     1626
#define TMT_HOTTRACKING             1627
#define TMT_GRADIENTACTIVECAPTION   1628
#define TMT_GRADIENTINACTIVECAPTION 1629
#define TMT_MENUHILIGHT             1630
#define TMT_MENUBAR                 1631
#define TMT_FIRSTCOLOR  TMT_SCROLLBAR
#define TMT_LASTCOLOR   TMT_MENUBAR


/* hue substitutions */
#define TMT_FROMHUE1 1801
#define TMT_FROMHUE2 1802
#define TMT_FROMHUE3 1803
#define TMT_FROMHUE4 1804
#define TMT_FROMHUE5 1805
#define TMT_TOHUE1   1806
#define TMT_TOHUE2   1807
#define TMT_TOHUE3   1808
#define TMT_TOHUE4   1809
#define TMT_TOHUE5   1810

/* color substitutions */
#define TMT_FROMCOLOR1 2001
#define TMT_FROMCOLOR2 2002
#define TMT_FROMCOLOR3 2003
#define TMT_FROMCOLOR4 2004
#define TMT_FROMCOLOR5 2005
#define TMT_TOCOLOR1   2006
#define TMT_TOCOLOR2   2007
#define TMT_TOCOLOR3   2008
#define TMT_TOCOLOR4   2009
#define TMT_TOCOLOR5   2010


/* Bool rendering properties */
#define TMT_TRANSPARENT         2201
#define TMT_AUTOSIZE            2202
#define TMT_BORDERONLY          2203
#define TMT_COMPOSITED          2204
#define TMT_BGFILL              2205
#define TMT_GLYPHTRANSPARENT    2206
#define TMT_GLYPHONLY           2207
#define TMT_ALWAYSSHOWSIZINGBAR 2208
#define TMT_MIRRORIMAGE         2209
#define TMT_UNIFORMSIZING       2210
#define TMT_INTEGRALSIZING      2211
#define TMT_SOURCEGROW          2212
#define TMT_SOURCESHRINK        2213

/* Int rendering properties */
#define TMT_IMAGECOUNT          2401
#define TMT_ALPHALEVEL          2402
#define TMT_BORDERSIZE          2403
#define TMT_ROUNDCORNERWIDTH    2404
#define TMT_ROUNDCORNERHEIGHT   2405
#define TMT_GRADIENTRATIO1      2406
#define TMT_GRADIENTRATIO2      2407
#define TMT_GRADIENTRATIO3      2408
#define TMT_GRADIENTRATIO4      2409
#define TMT_GRADIENTRATIO5      2410
#define TMT_PROGRESSCHUNKSIZE   2411
#define TMT_PROGRESSSPACESIZE   2412
#define TMT_SATURATION          2413
#define TMT_TEXTBORDERSIZE      2414
#define TMT_ALPHATHRESHOLD      2415
#define TMT_WIDTH               2416
#define TMT_HEIGHT              2417
#define TMT_GLYPHINDEX          2418
#define TMT_TRUESIZESTRETCHMARK 2419
#define TMT_MINDPI1             2420
#define TMT_MINDPI2             2421
#define TMT_MINDPI3             2422
#define TMT_MINDPI4             2423
#define TMT_MINDPI5             2424

/* Font rendering properties */
#define TMT_GLYPHFONT 2601

/* Filename rendering properties */
#define TMT_IMAGEFILE       3001
#define TMT_IMAGEFILE1      3002
#define TMT_IMAGEFILE2      3003
#define TMT_IMAGEFILE3      3004
#define TMT_IMAGEFILE4      3005
#define TMT_IMAGEFILE5      3006
#define TMT_STOCKIMAGEFILE  3007
#define TMT_GLYPHIMAGEFILE  3008

/* String rendering properties */
#define TMT_TEXT 3201

/* Position rendering properties */
#define TMT_OFFSET              3401
#define TMT_TEXTSHADOWOFFSET    3402
#define TMT_MINSIZE             3403
#define TMT_MINSIZE1            3404
#define TMT_MINSIZE2            3405
#define TMT_MINSIZE3            3406
#define TMT_MINSIZE4            3407
#define TMT_MINSIZE5            3408
#define TMT_NORMALSIZE          3409

/* Margin rendering properties */
#define TMT_SIZINGMARGINS   3601
#define TMT_CONTENTMARGINS  3602
#define TMT_CAPTIONMARGINS  3603

/* Color rendering properties */
#define TMT_BORDERCOLOR             3801
#define TMT_FILLCOLOR               3802
// #define TMT_TEXTCOLOR               3803
#define TMT_EDGELIGHTCOLOR          3804
#define TMT_EDGEHIGHLIGHTCOLOR      3805
#define TMT_EDGESHADOWCOLOR         3806
#define TMT_EDGEDKSHADOWCOLOR       3807
#define TMT_EDGEFILLCOLOR           3808
#define TMT_TRANSPARENTCOLOR        3809
#define TMT_GRADIENTCOLOR1          3810
#define TMT_GRADIENTCOLOR2          3811
#define TMT_GRADIENTCOLOR3          3812
#define TMT_GRADIENTCOLOR4          3813
#define TMT_GRADIENTCOLOR5          3814
#define TMT_SHADOWCOLOR             3815
#define TMT_GLOWCOLOR               3816
#define TMT_TEXTBORDERCOLOR         3817
#define TMT_TEXTSHADOWCOLOR         3818
#define TMT_GLYPHTEXTCOLOR          3819
#define TMT_GLYPHTRANSPARENTCOLOR   3820
#define TMT_FILLCOLORHINT           3821
#define TMT_BORDERCOLORHINT         3822
#define TMT_ACCENTCOLORHINT         3823

/* Enum rendering properties */
#define TMT_BGTYPE              4001
#define TMT_BORDERTYPE          4002
#define TMT_FILLTYPE            4003
#define TMT_SIZINGTYPE          4004
#define TMT_HALIGN              4005
#define TMT_CONTENTALIGNMENT    4006
#define TMT_VALIGN              4007
#define TMT_OFFSETTYPE          4008
#define TMT_ICONEFFECT          4009
#define TMT_TEXTSHADOWTYPE      4010
#define TMT_IMAGELAYOUT         4011
#define TMT_GLYPHTYPE           4012
#define TMT_IMAGESELECTTYPE     4013
#define TMT_GLYPHFONTSIZINGTYPE 4014
#define TMT_TRUESIZESCALINGTYPE 4015

/* custom properties */
#define TMT_USERPICTURE     5001
#define TMT_DEFAULTPANESIZE 5002
#define TMT_BLENDCOLOR      5003

 /* PARTS &amp; STATES */

 /* BUTTON parts */

 // #define CLS_NORMAL 1

 /* COMBOBOX parts */

// #define CP_DROPDOWNBUTTON 1

 /* COMBOBOX DROPDOWNBUTTON states */
// #define CBXS_NORMAL   1


 /* EDIT parts */
// #define EP_EDITTEXT 1

// #define EP_CARET    2

 /* EDIT EDITTEXT states */
// #define ETS_NORMAL   1


 /* MENUBAND parts */
// #define MDP_NEWAPPBUTTON 1
/* sepErator isn&#39;t a typo, as per microsofts headers */
 #define MDP_SEPERATOR    2

/* MENUBAND NEWAPPBUTTON parts */
/* MENUBAND NEWAPPBUTTON states */
// #define MDS_NORMAL     1
// #define MDS_HOT        2
// #define MDS_PRESSED    3

