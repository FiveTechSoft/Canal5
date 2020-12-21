#include "fivewin.ch"
#include "wnddsgn.ch"
#include "Constant.ch"
#include "Slider.ch"
#include "SPlitter.ch"
#include "xBrowse.ch"


static oShowImg

function Visores()
local oVisores
local oWnd
local oBrush
local o
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )


DEFINE BRUSH oBrush STYLE "NULL"

if Aplicacion():oWndVisores != nil
   Aplicacion():oWndVisores:Show()
else

   //Aplicacion():oWndInspect
   DEFINE WINDOW Aplicacion():oWndVisores TITLE "Visores" MDICHILD OF Aplicacion():oWnd BRUSH oBrush ;
          FROM 0, 0 TO aClient[3]-Aplicacion():oWnd:oBar:nHeight(), 200 PIXEL


          oVisores := VisToolBar( Aplicacion():oWndVisores )
          Aplicacion():oWndVisores:oClient := oVisores


   ACTIVATE WINDOW Aplicacion():oWndVisores ;
            ON INIT ( Aplicacion():oWndVisores:Move( 0, 0,Aplicacion():oToolBox:nRight , aClient[3]-Aplicacion():oWnd:oBar:nHeight(), .t.) ) ;
            VALID (Aplicacion():oWndVisores:Hide(),Aplicacion():lCerrarToolBox)
endif

return nil


function VisToolBar( oPage )
local oWnd, oDlg
local oToolBar
local oToolBar0
local oToolBar1
local oBtnFld
local oSlide1
local nVar1 := 10


        oBtnFld  := TBtnFolder():New( 0, 0, 400, 100, oPage )

        oPage:oClient := oBtnFld

        oToolBar0 := TCtrlToolBar():New( 0, 0, 100, 100, oBtnFld, "Ficheros", "toolbar\image4.bmp", {||.t.} )
        aadd( oBtnFld:aFolders, oToolBar0 )


        oToolBar := TCtrlToolBar():New( 0, 0, 100, 100, oBtnFld, "DBFs", "toolbar\image4.bmp", {||.t.} )
        aadd( oBtnFld:aFolders, oToolBar )

        oToolBar1 := TCtrlToolBar():New( 0, 0, 100, 100, oBtnFld, "Imágenes", "toolbar\image4.bmp", {||.t.}  ) //26
        aadd( oBtnFld:aFolders, oToolBar1 )

        FindFiles( oToolBar0 )
        FindDbfs( oToolBar )
        FindImgs( oToolBar1 )

        oBtnFld:SetOption( 1 )


return oBtnFld


function FindFIles( oPage )

Local oDirL1

 oDirL1 := TDirList():New( 0, 0, 300, 230, oPage, ,,, .t. )

 oPage:oClient := oDirL1

return nil


function FindDbfs( oPage )

Local oDirL1

 oDirL1 := TDirList():New( 0, 0, 300, 230, oPage,,,,,,".dbf",.f., {|| ViewDbfs( oDirL1 ) } )
 oPage:oClient := oDirL1

return nil

function FindImgs( oPage )

Local oDirL1

 oDirL1 := TDirList():New( 0, 0, 300, 230, oPage,,,,,,".jpg.bmp.gif.tif.ico",.f., {|| ViewImgs( oDirL1 ) } )
 oDirL1:oLbx:bChange :=  {|| ViewImgs( oDirL1 ) }
 oPage:oClient := oDirL1

return nil



function ViewDbfs( oDirL )
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )
local oFont, oFld, oLbx
local oBrw, aStruc
local oBrw2
local cAlias
local oDsgn
local oBrush
local cFile := oDIrL:cFullName()



//if Aplicacion():oWndViewDbfs == nil

   DEFINE FONT oFont NAME "Tahoma" SIZE 0, -12

   USE ( cFile ) NEW ALIAS ( cAlias := GetNewAlias( "CUST" ) ) SHARED

   DEFINE WINDOW Aplicacion():oWndViewDbfs MDICHILD ;
          TITLE "Visor Dbfs - " + lower(cFile) ;
          OF Aplicacion():oWnd ;
          COLOR 0, CLR_WHITE  PIXEL

   @ 1, 1 FOLDER oFld PROMPTS "Vista","Estructura", "Diálogo" OF Aplicacion():oWndViewDbfs FONT oFont


          oBrw2 := TXBrowse():New( oFld:aDialogs[1] )
          oBrw2:nMarqueeStyle := MARQSTYLE_HIGHLROW
          oBrw2:lColDividerComplete := .t.
          oBrw2:nColDividerStyle    := LINESTYLE_BLACK
          oBrw2:nRowDividerStyle    := LINESTYLE_BLACK


          oBrw2:SetRDD()
          oBrw2:CreateFromCode()

          oFld:aDialogs[1]:oCLient := oBrw2

          Aplicacion():oWndViewDbfs:oClient := oFld

      oBrw := TXBrowse():New( oFld:aDialogs[2] )

      aStruc := DBStruct()

      oBrw:SetArray( aStruc )



      oBrw:aCols[1]:cHeader := Padr("NAME", 15)

      oBrw:aCols[2]:cHeader       := "TYPE"
      oBrw:aCols[2]:nDataStrAlign := AL_CENTER
      oBrw:aCols[2]:nHeadStrAlign := AL_CENTER

      oBrw:aCols[3]:cHeader       := "SIZE"
      oBrw:aCols[3]:nDataStrAlign := AL_RIGHT
      oBrw:aCols[3]:nHeadStrAlign := AL_RIGHT

      oBrw:aCols[4]:cHeader       := "LENGTH"
      oBrw:aCols[4]:nDataStrAlign := AL_RIGHT
      oBrw:aCols[4]:nHeadStrAlign := AL_RIGHT

      *oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL
      oBrw:lRecordSelector := .f.

          oBrw:nMarqueeStyle := MARQSTYLE_HIGHLROW
          oBrw:lColDividerComplete := .t.
          oBrw:nColDividerStyle    := LINESTYLE_BLACK
          oBrw:nRowDividerStyle    := LINESTYLE_BLACK



      oBrw:CreateFromCode()

      oFld:aDialogs[2]:oClient := oBrw

    //DEFINE BRUSH oBrush STYLE "NULL"

    oDsgn := TDsgnEditor():New( 6, 6, 500, 500, oFld:aDialogs[3] )
    //oDsgn:SetBrush( oBrush )

    oDsgn:nType := 0

    //oFld:aDialogs[4]:oClient := oDsgn

    oDsgn:oForm := TWndDsgn():New( 0, 0, 500, 500, oDsgn )
    oDsgn:bResized := {|| AdjustDsgn( oDsgn ) }
    AdjustDsgn( oDsgn )

    oDsgn:DbfToDialog( cFile )


   ACTIVATE WINDOW Aplicacion():oWndViewDbfs ; //            VALID  (Aplicacion():oWndViewDbfs := nil, .t. ) ;
            ON INIT Aplicacion():oWndViewDbfs:Move( 0, 200, aClient[4]-200,;
                                                            aClient[3]-Aplicacion():oWnd:oBar:nHeight, .t.)

//else
//   Aplicacion():oWndViewDbfs:Show()
//endif


return nil


function ViewImgs( oDirL )
local aClient := GetClientRect( Aplicacion():oWnd:hWnd )
local cFile := oDIrL:cFullName()
local oBar, o


//if Aplicacion():oWndViewDbfs == nil

if Aplicacion():oWndViewImgs == nil

   DEFINE FONT oFont NAME "Tahoma" SIZE 0, -12

   DEFINE WINDOW Aplicacion():oWndViewImgs MDICHILD ;
          TITLE "Visor Imágenes - " + lower(cFile) ;
          OF Aplicacion():oWnd ;
          COLOR 0, RGB(238,238,238)  PIXEL

          DEFINE BUTTONBAR oBar OF Aplicacion():oWndViewImgs  BOTTOM 3D

          oShowImg := TShowImg():New( 0, 0, aClient[4], aClient[3], Aplicacion():oWndViewImgs, oDirL, cFile )

          Aplicacion():oWndViewImgs:oClient := oShowImg


          DEFINE BUTTON o OF oBar NAME "toleft"   NOBORDER ACTION ( oDirL:oLbx:GoUp(), oShowImg:SetImage( oDIrL:cFullName ))
          DEFINE BUTTON OF oBar NAME "toright"  NOBORDER   ACTION ( oDirL:oLbx:GoDown(), oShowImg:SetImage( oDIrL:cFullName ))
          DEFINE BUTTON OF oBar NAME "actual"   NOBORDER GROUP
          DEFINE BUTTON OF oBar NAME "diapos"   NOBORDER
          DEFINE BUTTON OF oBar NAME "zoom2"    NOBORDER GROUP  ACTION (oShowImg:nZoom := min( oShowImg:nZoom+0.25,10), oShowImg:Refresh() )
          DEFINE BUTTON OF oBar NAME "unzoom"   NOBORDER        ACTION (oShowImg:nZoom := max( oShowImg:nZoom-0.25,1) , oShowImg:Refresh() )
          DEFINE BUTTON OF oBar NAME "rotari"   NOBORDER GROUP  ACTION (oShowImg:RotateRight( 90 ), oShowImg:Refresh() )
          DEFINE BUTTON OF oBar NAME "rotale"   NOBORDER        ACTION (oShowImg:RotateLeft( 90 ), oShowImg:Refresh() )
          DEFINE BUTTON OF oBar NAME "delbmp"   NOBORDER GROUP
          DEFINE BUTTON OF oBar NAME "printbmp" NOBORDER
          DEFINE BUTTON OF oBar NAME "editbmp"  NOBORDER



          DEFINE BUTTON OF oBar NAME "savebmp"  NOBORDER



   ACTIVATE WINDOW Aplicacion():oWndViewImgs ; //            VALID  (Aplicacion():oWndViewDbfs := nil, .t. ) ;
            ON INIT ( Aplicacion():oWndViewImgs:Move( 0, Aplicacion():oToolBox:nRight, aClient[4]-Aplicacion():oToolBox:nWidth,;
                      aClient[3]-Aplicacion():oWnd:oBar:nHeight, .t.), Mueve( oBar ) ) ;
            VALID (Aplicacion():oWndViewImgs := nil, .t. )

else

    Aplicacion():oWndViewImgs:Show()
    oShowImg:SetImage( cFile )
    oShowImg:Refresh(.t.)


endif

//else
//   Aplicacion():oWndViewDbfs:Show()
//endif


return nil

function Mueve( oBar )
local o

for n := 1 to len( oBar:aControls )
    o := oBar:aControls[n]
    o:Move( o:nTop, o:nLeft + 200,,,.t.)
next

return





function GetNewAlias( cDbfName )

   static n := 0

return cDbfName + StrZero( ++n, 2 )


