#include "fivewin.ch"
#include "wnddsgn.ch"

#define ILC_COLOR32             0x0020
#define ILC_MASK                0x0001

#define SOLODES

#define SIZE_RESTORED   0
#define SIZE_MINIMIZED  1
#define SIZE_MAXIMIZED  2


static oApp, oTray, oIcon
static lThemed     := .f.
static lEnableUndo := .f.
static lFromUndo   := .f.
static lxPocketPC  := .f.
static hFreeImage
static nFreeInstance := 0
static oWndCode

function main( p1, p2, p3 )


   lTemas( .t. )

   oApp := TApp():New( p1, p2, p3, oIcon )

   oApp:oInspector := ListPropEx()
   Designer()

   ACTIVATE WINDOW oApp:oWnd ;
        ON INIT ( oTray := TTrayIcon():New( oApp:oWnd, oIcon, "#5", { || Designer() }, { | nRow, nCol | oApp:MenuTray( nRow, nCol, oTray ) } ) );
        VALID ( oTray:End(), oApp:SaveConfig(), .t. ) ;


return nil


function Aplicacion(); return oApp

function lTemas( lTemas )

if pcount() > 0
   lThemed := lTemas
endif

return lThemed


function EnableUndo() ; lEnableUndo := .t.  ; return 0
function DisableUndo(); lEnableUndo := .f.  ; return 0
function lMetoEnUndo()                      ; return lEnableUndo
function BeginFromUndo() ; lFromUndo := .t. ; return 0
function EndFromUndo()   ; lFromUndo := .f. ; return 0
function lFromUndo();                         return lFromUndo


CLASS TApp

      DATA p1, p2, p3
      DATA oWnd
      DATA oMenu
      DATA oBar
      DATA oWndPrj
      DATA oProyecto
      DATA oOutPut
      DATA aProyectos
      DATA oSolucion
      DATA oGestIDs
      DATA oWndInspect
      DATA oInspector
      DATA oCbxControles
      DATA oToolBox
      DATA lCerrarToolBox AS LOGICAL INIT .F.
      DATA nState
      DATA oDFocus
      DATA oImgFocus
      DATA oWndFindFiles
      DATA oWndViewDbfs
      DATA oWndViewImgs
      DATA oWndVisores
      DATA nTop, nLeft, nBottom, nRight
      DATA nTopForm, nLeftForm
      DATA nTopTool, nLeftTool, nBottomTool, nRightTool
      DATA nTopProp, nLeftProp, nBottomProp, nRightProp


      METHOD New() CONSTRUCTOR
      METHOD Activate()
      METHOD End()            INLINE ::oWnd:End()

      METHOD Nuevo()
      METHOD NuevoFile( cType )
      METHOD NuevoProyecto( nProyecto, cName, cLocation )
      METHOD CurDir()         INLINE CurDrive() + ":" + If( Empty( CurDir() ), "", "\" + CurDir() )
      METHOD LastDir()        INLINE ::CurDir()
      METHOD Menu()
      METHOD Barra()
      METHOD Abrir()
      METHOD Ftp()
      METHOD Incrustar( nHelp )
      METHOD SavePrj( cFileName )
      METHOD LoadPrj( cFileName )
      METHOD MainReSize( nMode )
      METHOD MenuTray( nRow, nCol, oTray )
      METHOD Parametros()
      METHOD ValidaNombreProy( oNombre, oPath )
      METHOD GenCode()
      METHOD LoadConfig()
      METHOD SaveConfig()

ENDCLASS

***********************************************************************************
  METHOD New( p1, p2, p3, oIcon ) CLASS TApp
***********************************************************************************

local o := self
local oBrush
local oMenu

p1 := "dsgn"

::p1 := p1
::p2 := p2
::p3 := p3

DEFINE ICON oIcon NAME "form"

   //oMenu := self:Menu()
  ::oWndInspect := nil
  ::aProyectos := {}

  ::LoadConfig()

  //::oWnd := TWndApp():New( , , , , "Designer", , oMenu, , , 0, 8421504, .f., .f., 4, , , .f. )
  //DEFINE WINDOW ::oWnd FROM 0, 0 TO 75, 800 PIXEL TITLE "Designer" MENU oMenu BORDER NONE
  //::oWnd := TWindowMain():New( ::nTop, ::nLeft, ::nBottom, ::nRight, "Designer",, oMenu,,oIcon,,,,,,, Upper("NONE"), !.F., !.F., !.F., !.F., .T. )

  DEFINE WINDOW ::oWnd TITLE "Designer" FROM ::nTop, ::nLeft TO ::nBottom, ::nRight PIXEL ICON oIcon


       //  ::oWnd:bReSized    = { | nMode, nWidth, nHeight | ::MainResize( nMode ) }

       ::Barra()

       ::lCerrarToolBox := .f.
       ::nState := DSGN_SELECT
        //VisorCodigo()

return self

******************************************************************
  METHOD GenCode( ) CLASS TApp
******************************************************************


return nil


***************************************************************************************************************
  METHOD SaveConfig( ) CLASS TApp
***************************************************************************************************************
 local oIni
 local cFile := ".\config.ini"
 local rc := GetWndRect(::oWnd:hWnd )
 local rc2
 local rc3 := {280, 600}
 local rc4

if Aplicacion():oToolBox != nil
   rc2 := GetWndRect(Aplicacion():oToolBox:hWnd )
endif

      INI oIni FILE cFile
         SET SECTION "MainWindow"                   ENTRY "Top"              OF oIni TO rc[1]
         SET SECTION "MainWindow"                   ENTRY "Left"             OF oIni TO rc[2]
         SET SECTION "MainWindow"                   ENTRY "Width"            OF oIni TO rc[4]-rc[2]
         SET SECTION "MainWindow"                   ENTRY "Height"           OF oIni TO rc[3]-rc[1]-1

      if Aplicacion():oInspector != nil
         rc4 := GetWndRect(Aplicacion():oInspector:hWnd )
         SET SECTION "Inspector"                   ENTRY "Top"              OF oIni TO rc4[1]
         SET SECTION "Inspector"                   ENTRY "Left"             OF oIni TO rc4[2]
         SET SECTION "Inspector"                   ENTRY "Bottom"           OF oIni TO rc4[3]
         SET SECTION "Inspector"                   ENTRY "Right"            OF oIni TO rc4[4]
      endif

      if Aplicacion():oToolBox != nil
         SET SECTION "ToolWindow"                   ENTRY "Top"              OF oIni TO rc2[1]
         SET SECTION "ToolWindow"                   ENTRY "Left"             OF oIni TO rc2[2]
         SET SECTION "ToolWindow"                   ENTRY "Bottom"           OF oIni TO rc2[3]
         SET SECTION "ToolWindow"                   ENTRY "Right"            OF oIni TO rc2[4]
      endif

         SET SECTION "FormWindow"                   ENTRY "Top"              OF oIni TO rc3[1]
         SET SECTION "FormWindow"                   ENTRY "Left"             OF oIni TO rc3[2]
      ENDINI

return 0

***************************************************************************************************************************************
   METHOD LoadConfig() CLASS TApp
***************************************************************************************************************************************
local oIni
local cIniFile := ".\config.ini"
local nTop    := 200
local nLeft   := 200
local nWidth  := 200
local nHeight := 55
local nRed, nGreen, nBlue
local rc2 := {100, 100, 873, 350}
local rc4 := {100, 100, 500, 400}
local rc3 := {280, 600}

    INI oIni FILE cIniFile

        GET ::nTop              SECTION "MainWindow"                   ENTRY "Top"               OF oIni DEFAULT nTop
        GET ::nLeft             SECTION "MainWindow"                   ENTRY "Left"              OF oIni DEFAULT nLeft
        GET nWidth              SECTION "MainWindow"                   ENTRY "Width"             OF oIni DEFAULT nWidth
        GET nHeight             SECTION "MainWindow"                   ENTRY "Height"            OF oIni DEFAULT nHeight

        GET ::nTopTool          SECTION "ToolWindow"                   ENTRY "Top"               OF oIni DEFAULT rc2[1]
        GET ::nLeftTool         SECTION "ToolWindow"                   ENTRY "Left"              OF oIni DEFAULT rc2[2]
        GET ::nBottomTool       SECTION "ToolWindow"                   ENTRY "Bottom"            OF oIni DEFAULT rc2[3]
        GET ::nRightTool        SECTION "ToolWindow"                   ENTRY "Right"             OF oIni DEFAULT rc2[4]

        GET ::nTopProp          SECTION "Inspector"                   ENTRY "Top"               OF oIni DEFAULT rc4[1]
        GET ::nLeftProp         SECTION "Inspector"                   ENTRY "Left"              OF oIni DEFAULT rc4[2]
        GET ::nBottomProp       SECTION "Inspector"                   ENTRY "Bottom"            OF oIni DEFAULT rc4[3]
        GET ::nRightProp        SECTION "Inspector"                   ENTRY "Right"             OF oIni DEFAULT rc4[4]


        GET ::nTopForm          SECTION "FormWindow"                   ENTRY "Top"               OF oIni DEFAULT rc3[1]
        GET ::nLeftForm         SECTION "FormWindow"                   ENTRY "Left"              OF oIni DEFAULT rc3[2]


    ENDINI

    ::nBottom := ::nTop + nHeight
    ::nRight  := ::nLeft + nWidth



return 0


******************************************************************
  METHOD MainResize( nMode ) CLASS TApp
******************************************************************
   local rc := GetClientRect(::oWnd:hWnd)

   DEFAULT nMode := SIZE_RESTORED

   do case
      case nMode == SIZE_MINIMIZED

           if ::oWndInspect != nil
              ::oWndInspect:Hide()
           endif

      case nMode == SIZE_MAXIMIZED

           if ::oWndInspect != nil
              ::oWndInspect:Show()
           endif

      case nMode == SIZE_RESTORED

           if ::oWndInspect != nil
              ::oWndInspect:Show()
           endif

   endcase


return nil


************************************************************************************
  METHOD Activate() CLASS TApp
************************************************************************************

local oIcon, oIcon1
local o := self

DEFINE ICON oIcon NAME "dialogo"
DEFINE ICON oIcon1 NAME "icon"

ACTIVATE WINDOW ::oWnd MAXIMIZED VALID (o:lCerrarToolBox := .t., .t.)//;
//    ON INIT ( oTray := TTrayIcon():New(o:oWnd,oIcon,"Testing tray ...",{||ShowDatos()},{|nRow,nCol|o:MenuTray(nRow,nCol,oTray)}),;
//               o:Parametros() ) ;
//               VALID (o:lCerrarToolBox := .t.,oTray:End(), .t.);
//               ON RIGHT CLICK oTray:SetIcon( oIcon1, "Another" )

return nil

************************************************************************************
  METHOD Parametros()  CLASS TApp
************************************************************************************

if ::p1 != nil
   do case
      case ::p1 == "spy"
           ShowDatos()

      case ::p1 == "findfiles"
           FindInFiles( 1 )

      case ::p1 == "img"
           WndFold()
           //Aplicacion():oToolBox:cargo:SetOption( 1 ) // Herramientas
           Aplicacion():oToolBox:cargo:cargo[1]:SetOption( 4 )
           ImageEditor()

      case ::p1 == "dsgn"
           WndFold()
           //Aplicacion():oToolBox:cargo:SetOption( 1 ) // Herramientas
           //Aplicacion():oToolBox:cargo:cargo[1]:SetOption( 1 )
           designer()


   endcase
endif

return nil


************************************************************************************
  METHOD MenuTray( nRow, nCol, oTray )  CLASS TApp
************************************************************************************

LOCAL oMenu
local o := self

   MENU oMenu POPUP
      MENUITEM "Spy" ACTION Showdatos()
      MENUITEM "Designer" ACTION Designer()
      MENUITEM "Show" ACTION o:oWnd:Show()
      MENUITEM "Hide" ACTION o:oWnd:Show()
      MENUITEM "Capturar" ACTION CapturaRect()

      SEPARATOR
      MENUITEM "Close Application"   ACTION o:end()
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow-10, nCol+10 OF oTray:oWnd

RETURN NIL

************************************************************************************
  METHOD Menu() CLASS TApp
************************************************************************************

local oMenu

MENU oMenu


   MENUITEM "&Fichero"
   MENU
      MENUITEM "Nuevo"
      MENU
       MENUITEM "Formulario" ACTION Designer()
       MENUITEM "Ventanas"


         MENUITEM "Formulario" ACTION Designer()

      ENDMENU
      MENUITEM "Abrir"
      MENUITEM "Cerrar"
      SEPARATOR
      MENUITEM "Añadir nuevo item..."     ACTION ::Nuevo()
      MENUITEM "Añadir existente item..."
      MENUITEM "Añadir proyecto"
      MENU
         MENUITEM "Nuevo proyecto"
         MENUITEM "Existente proyecto"
      ENDMENU
      MENUITEM "Salvar"
      MENUITEM "Salvar como..." ACTION ::GenCode()
      MENUITEM "Salvar todo"
      SEPARATOR
      MENUITEM "Configurar página..."     ACTION PrinterSetup()
      MENUITEM "Imprimir"
      SEPARATOR
      MENUITEM "Recientes proyectos"
      MENUITEM "Salir" ACTION oApp:End()
   ENDMENU
   MENUITEM "Edición"
   MENU
      MENUITEM "Undo" ACTION if( ::oWnd:oWndActive != nil, if( ::oWnd:oWndActive:bUndo  != nil, eval( ::oWnd:oWndActive:bUndo ),),)
      MENUITEM "Redo"
      SEPARATOR
      MENUITEM "Cortar"
      MENUITEM "Copiar"   ACTION if( ::oWnd:oWndActive != nil, if( ::oWnd:oWndActive:bCopy  != nil, eval( ::oWnd:oWndActive:bCopy ),),)
      MENUITEM "Pegar"    ACTION if( ::oWnd:oWndActive != nil, if( ::oWnd:oWndActive:bPaste != nil, eval( ::oWnd:oWndActive:bPaste ),),)
      MENUITEM "Borrar"
      SEPARATOR
      MENUITEM "Seleccionar todos"
      SEPARATOR
      MENUITEM "Buscar y Reemplazar"
      MENUITEM "Ir a"
   ENDMENU
   MENUITEM "Proyecto"
   MENU
      MENUITEM "Añadir Clase..."
      MENUITEM "Añadir Recurso..."
      SEPARATOR
      MENUITEM "Añadir nuevo elemento..."
      MENUITEM "Apadir existente elemento..."
      SEPARATOR
      MENUITEM "Nueva carpeta"
      SEPARATOR
      MENUITEM "Poner proyecto activo"
      SEPARATOR
      MENUITEM "Propiedades..."   ACTION WndFold()
   ENDMENU
   MENUITEM "Construir"
   MENU
      MENUITEM "Construir"
      MENUITEM "Reconstruir"
      MENUITEM "Limpiar"
      SEPARATOR
      MENUITEM "Configuración"
      SEPARATOR
      MENUITEM "Compilar"           + chr(9) + "Ctrl+F7"
   ENDMENU
   MENUITEM "Debug"
   MENU
      MENUITEM "Ventanas"
      SEPARATOR
      MENUITEM "Ejecutar"           + chr(9) + "F5"
      MENUITEM "Ejecutar sin debug" + chr(9) + "Ctrl+F5"
      SEPARATOR
      MENUITEM "Entrar"             + chr(9) + "F11"
      MENUITEM "Paso a paso"        + chr(9) + "F10"
      SEPARATOR
      MENUITEM "Nuevo Breakpoint"   + chr(9) + "Ctrl+B"
      MENUITEM "Borrar todos BreakPoints"  + chr(9) + "Ctrl+Shift+F9"
   ENDMENU
   MENUITEM "Herramientas"
   MENU
      MENUITEM "Spy"             ACTION WinExec( "WinSpy.exe" )
      MENUITEM "Documentar"
      MENUITEM "Visor Dbfs"
      MENUITEM "Macros"
   ENDMENU
   MENUITEM "Ventana"
   MENU
      MENUITEM "Nueva ventana"
      MENUITEM "Split"
      MENUITEM "Mosáico horizontal"
      MENUITEM "Mosáico vertical"
      MENUITEM "Cascada"
   ENDMENU
ENDMENU


return oMenu




************************************************************************************
  METHOD Barra() CLASS TApp
************************************************************************************
local oNuevo
local oMenuNuevo
local oMenuAdd
local o27

MENU oMenuNuevo POPUP
   MENUITEM "Nuevo proyecto"             NAME "nuevo"  ACTION Aplicacion():NuevoProyecto() //NewProj()
   MENUITEM "Prg"                        NAME "source" ACTION NuevoCode()
   MENUITEM "ch"                         NAME ""
   MENUITEM "C"                          NAME ""
   MENUITEM "h"                          NAME ""
   MENUITEM "Clase"                      NAME ""
   MENUITEM "Ventana"                    NAME ""
   MENUITEM "Diálogo"                    NAME ""
   MENUITEM "Menú"                       NAME ""
   MENUITEM "Imágen"                     NAME ""
   MENUITEM "Icono"                      NAME ""
   MENUITEM "RC"                         NAME ""
   MENUITEM "String Table"               NAME ""
   MENUITEM "DBF"                        NAME ""
   MENUITEM "Indice"                     NAME ""
   MENUITEM "Documentar"                 NAME ""
ENDMENU

MENU oMenuAdd POPUP
   MENUITEM "Añadir nuevo item..."       NAME "newitem"
   MENUITEM "Añadir item existente..."   NAME "item"
   MENUITEM "Añadir Clase"               NAME "class"
ENDMENU


 DEFINE BUTTONBAR ::oBar 3D SIZE 28,30  OF ::oWnd LOOK2007

 //    DEFINE BUTTON OF ::oBar NAME "nuevo"            NOBORDER MENU oMenuNuevo   ACTION ::Nuevo()
 //    DEFINE BUTTON OF ::oBar NAME "add"              NOBORDER MENU oMenuAdd
 //    DEFINE BUTTON OF ::oBar NAME "abrir"            NOBORDER                    ACTION OpenRcFile()  //()::Abrir()
 //    DEFINE BUTTON OF ::oBar NAME "ftp"              NOBORDER                    ACTION ::Ftp()
 //    DEFINE BUTTON OF ::oBar NAME "save"             NOBORDER ACTION if( oWndActive() != nil, oWndActive():SaveFile(),)
 //    DEFINE BUTTON OF ::oBar NAME "save"             NOBORDER ACTION if( ::oWnd:oWndActive != nil, ::oWnd:oWndActive:SaveFormat(),)
 //    DEFINE BUTTON OF ::oBar NAME "saveall"          NOBORDER
 //    DEFINE BUTTON OF ::oBar NAME "cortar" GROUP     NOBORDER
 //    DEFINE BUTTON OF ::oBar NAME "copiar"           NOBORDER
 //    DEFINE BUTTON OF ::oBar NAME "pegar"            NOBORDER
 //    DEFINE BUTTON OF ::oBar NAME "undo"   GROUP     NOBORDER ACTION if( ::oWnd:oWndActive != nil, if( ::oWnd:oWndActive:bUndo  != nil, eval( ::oWnd:oWndActive:bUndo ),),)
 //    DEFINE BUTTON OF ::oBar NAME "redo"             NOBORDER

 //    DEFINE BUTTON OF ::oBar NAME "findinfi"         NOBORDER ACTION FindInFiles()
 //  DEFINE BUTTON OF ::oBar NAME "props"            NOBORDER ACTION WndFold()
 //    DEFINE BUTTON OF ::oBar NAME "tools"            NOBORDER ACTION Visores()

 //    DEFINE BUTTON OF ::oBar NAME "web"              NOBORDER ACTION Navega()
      DEFINE BUTTON OF ::oBar NAME "dialog"           NOBORDER ACTION Designer()             TOOLTIP "F11 - Editor dialogos"
      DEFINE BUTTON OF ::oBar NAME "save"             NOBORDER
      DEFINE BUTTON OF ::oBar NAME "start"            NOBORDER
      DEFINE BUTTON OF ::oBar NAME "spy"              NOBORDER ACTION ShowDatos()
      DEFINE BUTTON OF ::oBar NAME "spy"              NOBORDER ACTION CapturaRect()

 //    DEFINE BUTTON OF ::oBar NAME "dialog"           NOBORDER ACTION GenPrg()
 //    DEFINE BUTTON OF ::oBar NAME "ppc"              NOBORDER ACTION Designer(1)            TOOLTIP "Pocket PC"
 //    DEFINE BUTTON OF ::oBar NAME "mobile2"          NOBORDER ACTION Designer(2)            TOOLTIP "Pocket PD Square Screen"
 //    DEFINE BUTTON OF ::oBar NAME "mobile1"          NOBORDER ACTION Designer(3)            TOOLTIP "Mobile"
 //    DEFINE BUTTON OF ::oBar NAME "rc"               NOBORDER ACTION Rc2Prg()               TOOLTIP "RC2PRG"
 //    DEFINE BUTTON OF ::oBar NAME "traduce"          NOBORDER ACTION Translate()            TOOLTIP "Traducir"
 //    DEFINE BUTTON o27 OF ::oBar NAME "themes","clasic"  ACTION ( lTemas( !lTemas() ),;
 //                                                              o27:lPressed      := lTemas()  ,;
 //                                                              RefreshWnds() )  NOBORDER
 //
 //
 //
 //
 //    DEFINE BUTTON OF ::oBar NAME "cximage"          NOBORDER ACTION ::Incrustar( 7 ) GROUP TOOLTIP "Editor imagenes"
 //    DEFINE BUTTON OF ::oBar NAME "printer"          NOBORDER ACTION DsgnPrt(0)       GROUP TOOLTIP "Editor Reports"

   /*  DEFINE BUTTON OF ::oBar                         ACTION ::NuevoProyecto()
     DEFINE BUTTON OF ::oBar                         ACTION ListProp()
     DEFINE BUTTON OF ::oBar                         ACTION Informes()
     DEFINE BUTTON OF ::oBar                         ACTION GetPrgs()
     DEFINE BUTTON OF ::oBar                         ACTION ::SavePrj() TOOLTIP "Save project"
     DEFINE BUTTON OF ::oBar                         ACTION ::LoadPrj() TOOLTIP "Load project"
     DEFINE BUTTON OF ::oBar                         //ACTION Redirect() TOOLTIP "Ventana de OutPut"
     //DEFINE BUTTON OF ::oBar                         ACTION RunCommand('FINDSTR /N /O /C:"DEFINE WINDOW" d:\fwh26\SOURCE\*.PRG') TOOLTIP "Test de OutPut"
     DEFINE BUTTON OF ::oBar                         //ACTION RunCommand('C:\prg\harbour\bin\harbour.exe') TOOLTIP "Test de OutPut"
     DEFINE BUTTON OF ::oBar                         ACTION FindInFiles()
     DEFINE BUTTON OF ::oBar                         ACTION Designer() GROUP
    */



return 0

function RefreshWnds()
local n
local nW, nH

for n := 1 to len( Aplicacion():oWnd:oWndClient:aWnd )
    nW := Aplicacion():oWnd:oWndClient:aWnd[n]:nWidth
    nH := Aplicacion():oWnd:oWndClient:aWnd[n]:nHeight
    Aplicacion():oWnd:oWndClient:aWnd[n]:SetSize( nW+1, nH,.t.)
    Aplicacion():oWnd:oWndClient:aWnd[n]:SetSize( nW  , nH,.t.)
next

return 0









    #define LVSIL_SMALL             1


************************************************************************************
  METHOD Nuevo( oTreeItem, lAddPrj ) CLASS TApp
************************************************************************************
local o := self
local oDlg
local oFolder
local oListview, oName, oLoca, oAdd, oChk
local oListview2
local lAdd
local cName := space(100)
local cLoca := space(255)
local cAux
local oImageList
local nStyle := nOr(ILC_COLOR32, ILC_MASK)
local oI1, oI2, oI3, oI4, oI5, oI6, oI7, oI8
local nOpcion := 0
local cFile
local oFile
local cCarpeta := ""
local lOk := .f.
local oK, oHelp, oCancel
local nProyecto

if oTreeItem != nil
   cCarpeta := oTreeItem:cPrompt
endif

DEFAULT lAddPrj := .f.




if !empty( cCarpeta )
   cCarpeta := alltrim( cCarpeta )
   do case
      case cCarpeta == "Prgs"
           oFile := ::NuevoFile( "prg", .f. )
           return oTreeItem:Add( oFile:cFileName, 3, "prg" )
      case cCarpeta == "Chs" .or. cCarpeta == "h"
           return ::NuevoFile( "h" )
      case cCarpeta == "Imagenes"
           return ::NuevoFile( "bmp")
   endcase
endif



lAdd := lAddPrj

oImageList =  TImageList():New(16,16,"toolbar\image1.bmp")

DEFINE DIALOG oDlg NAME "NUEVO"

    REDEFINE FOLDER oFolder ID 110 OF oDlg ;
       PROMPTS "Proyecto","Fichero" ;
       DIALOGS "NEWFILE","NEWFILE"

       // 1ª Solapa. Proyectos
       REDEFINE LISTVIEW oListview     ID 101 OF oFolder:aDialogs[1]
       REDEFINE CHECKBOX oChk VAR lAdd ID 102 OF oFolder:aDialogs[1]
       REDEFINE GET oName VAR cName    ID 103 OF oFolder:aDialogs[1]
       REDEFINE GET oLoca VAR cLoca    ID 104 OF oFolder:aDialogs[1]
       REDEFINE BUTTON oAdd            ID 105 OF oFolder:aDialogs[1] ACTION ( nOpcion := oListView:nOption, cAux := cGetFolder("Seleccione un directorio", ::LastDir() ), if( !empty( cAux ), ( cLoca := cAux, oLoca:Refresh()), ) )

       REDEFINE LISTVIEW oListview2    ID 101 OF oFolder:aDialogs[2]


   REDEFINE BUTTON oHelp   ID 3 OF oDlg ACTION MsgInfo("Help")
   REDEFINE BUTTON oK      ID 1 OF oDlg ACTION  if( o:ValidaNombreProy( oName, oLoca ),(lOk := .t., oDlg:End() ),.f.)
   REDEFINE BUTTON oCancel ID 2 OF oDlg ACTION oDlg:End()


ACTIVATE DIALOG oDlg CENTERED ON INIT  ( oChk:Hide(),;
                                         oListView:SetImageList( oImageList,  LVSIL_SMALL ),;
                                         oListView:InsertItem( 20, "Proyecto Consola" )    ,;
                                         oListView:InsertItem(  2, "Proyecto Windows" )    ,;
                                         oListView:InsertItem( 19, "Proyecto Pocket PC" )  ,;
                                         oListView:InsertItem( 11, "Librería" )            ,;
                                         oListView:InsertItem( 21, "Wizzard" )             ,;
                                         oListView2:SetImageList( oImageList,  LVSIL_SMALL ),;
                                         oListView2:InsertItem(  3, "Prg"           ),;
                                         oListView2:InsertItem(  1, "ch"            ),;
                                         oListView2:InsertItem(  9, "C"             ),;
                                         oListView2:InsertItem( 10, "h"             ),;
                                         oListView2:InsertItem( 27, "Clase"         ),;
                                         oListView2:InsertItem( 23, "Ventana"       ),;
                                         oListView2:InsertItem( 23, "Diálogo"       ),;
                                         oListView2:InsertItem( 24, "Menú"          ),;
                                         oListView2:InsertItem( 26, "Imágen"        ),;
                                         oListView2:InsertItem( 18, "Icono"         ),;
                                         oListView2:InsertItem( 13, "RC"            ),;
                                         oListView2:InsertItem(  3, "String Table"  ),;
                                         oListView2:InsertItem(  4, "DBF"           ),;
                                         oListView2:InsertItem( 22, "Indice"        ),;
                                         oListView2:InsertItem( 25, "Documentar"    ))


if lOk

    do case
       case oFolder:nOption == 1 // Proyectos
            do case
               case oListView:nOption == 1
                    nProyecto := CONSOLA_PRJ
               case oListView:nOption == 2
                    nProyecto := WINDOWS_PRJ
               case oListView:nOption == 3
                    nProyecto := PPC_PRJ
               case oListView:nOption == 4
                    nProyecto := LIBRERIA_PRJ
               case oListView:nOption == 5
                    nProyecto := WIZZARD_PRJ
               otherwise
                    nProyecto := WINDOWS_PRJ
            endcase

            ::NuevoProyecto( nProyecto, cName, cLoca )

       case oFolder:nOption == 2 // Archivos

       //::NuevoFile( {"prj","bmp","h","dbf","html","ico","prg","rc","prg"}[nOpcion] )

    endcase


    if nOpcion == 0
       return nil
    endif

endif

return 0



************************************************************************************
  METHOD ValidaNombreProy( oNombre, oPath ) CLASS TApp
************************************************************************************

 if empty( oNombre:VarGet() )
    MsgAlert( "No se puede dejar vacío el nombre del proyecto")
    oNombre:SetFocus()
    return .f.
 endif

 if empty(oPath:VarGet())
    MsgAlert( "No se puede dejar vacío la ruta del proyecto")
    oPath:SetFocus()
    return .f.
 endif
 if !file( oPath:VarGet()+"\"+"nul.ext" )
    if !MsgYesNo( "No existe el diretorio. ¿Desea crearlo?" )
       oPath:SetFocus()
       return .f.
    else
       ? "Crear directorio"
    endif
 endif

 if file( oPath:VarGet() + "\"+ oNombre:VarGet()+".prj" )
    if !MsgYesNo( "Ya existe el proyecto " + oNombre:VarGet() + CRLF +;
                  "¿Desea sobreescribirlo?" )
       oNombre:SetFocus()
       return .f.
    else
       ? "sobreescribir"
    endif
 endif





 return .t.





************************************************************************************
  METHOD NuevoFile( cType ) CLASS TApp
************************************************************************************
local o


do case
   case cType == "prj"
        ::NuevoProyecto()
   case cType == "bmp"
        __CopyFile( Curdrive()+":\"+Curdir()+"\sample.bmp", Curdrive()+":\"+Curdir()+"\image.bmp")
        ShellExecute( Aplicacion():oWnd:hwnd,"open",Lfn2sfnEx(Curdrive()+":\"+Curdir()+"\image.bmp") )

   case cType == "h"
        o := OpenCode()
        o:AddTextCRLF( '/*                                                                        ')
        o:AddTextCRLF( ' * $Id: <fichero>,<version> <año>/<mes>/<dia> <hora>:<minutos>:<segundos> <autor> Exp $')
        o:AddTextCRLF( ' */                                                                       ')
        o:AddTextCRLF( '                                                                          ')
        o:AddTextCRLF( '/*                                                                        ')
        o:AddTextCRLF( ' * Harbour Project source code:                                           ')
        o:AddTextCRLF( ' * Header file for box drawing                                            ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * Copyright 1999 {list of individual authors and e-mail addresses}       ')
        o:AddTextCRLF( ' * www - http://www.harbour-project.org                                   ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * This program is free software; you can redistribute it and/or modify   ')
        o:AddTextCRLF( ' * it under the terms of the GNU General Public License as published by   ')
        o:AddTextCRLF( ' * the Free Software Foundation; either version 2, or (at your option)    ')
        o:AddTextCRLF( ' * any later version.                                                     ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * This program is distributed in the hope that it will be useful,        ')
        o:AddTextCRLF( ' * but WITHOUT ANY WARRANTY; without even the implied warranty of         ')
        o:AddTextCRLF( ' * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          ')
        o:AddTextCRLF( ' * GNU General Public License for more details.                           ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * You should have received a copy of the GNU General Public License      ')
        o:AddTextCRLF( ' * along with this software; see the file COPYING.  If not, write to      ')
        o:AddTextCRLF( ' * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,        ')
        o:AddTextCRLF( ' * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/). ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * As a special exception, the Harbour Project gives permission for       ')
        o:AddTextCRLF( ' * additional uses of the text contained in its release of Harbour.       ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * The exception is that, if you link the Harbour libraries with other    ')
        o:AddTextCRLF( ' * files to produce an executable, this does not by itself cause the      ')
        o:AddTextCRLF( ' * resulting executable to be covered by the GNU General Public License.  ')
        o:AddTextCRLF( ' * Your use of that executable is in no way restricted on account of      ')
        o:AddTextCRLF( ' * linking the Harbour library code into it.                              ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * This exception does not however invalidate any other reasons why       ')
        o:AddTextCRLF( ' * the executable file might be covered by the GNU General Public License.')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * This exception applies only to the code released by the Harbour        ')
        o:AddTextCRLF( ' * Project under the name Harbour.  If you copy code from other           ')
        o:AddTextCRLF( ' * Harbour Project or Free Software Foundation releases into a copy of    ')
        o:AddTextCRLF( ' * Harbour, as the General Public License permits, the exception does     ')
        o:AddTextCRLF( ' * not apply to the code that you add in this way.  To avoid misleading   ')
        o:AddTextCRLF( ' * anyone as to the status of such modified files, you must delete        ')
        o:AddTextCRLF( ' * this exception notice from them.                                       ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' * If you write modifications of your own for Harbour, it is your choice  ')
        o:AddTextCRLF( ' * whether to permit this exception to apply to your modifications.       ')
        o:AddTextCRLF( ' * If you do not wish that, delete this exception notice.                 ')
        o:AddTextCRLF( ' *                                                                        ')
        o:AddTextCRLF( ' */                                                                       ')
   case cType == "prg"
        o := OpenCode()
endcase


return o


************************************************************************************
  METHOD Abrir( lCodigo, lRecursos, lImagen, lForm ) CLASS TApp
************************************************************************************

local cFiltro := ""

local cFileName, cExt

DEFAULT lCodigo := .t., lRecursos := .t., lImagen := .t.

if lCodigo
   cFiltro +=    "Código (*.prg) | *.prg; |"                          +;
                 "Cabecera (*.ch) | *.ch; |"                          +;
                 "C (*.c *.cpp) | *.c;*.cpp; |"                       +;
                 "H (*.h) | *.h; |"
endif

if lRecursos
   cFiltro += "Recursos (*.rc *.res *.dll ) | *.rc;*.res;*.dll; |"
endif

if lImagen
   cFiltro += "Imágenes (*.bmp *.gif *.jpg *.ico *.png *.tif ) | *.bmp;*.gif;*.jpg;*.ico;*.png;*.tif; |"
endif

if lForm
   cFiltro += "Formularios (*.ffm) | *.ffm; |"
endif

   cFileName := cGetFile( cFiltro, "Selecciona fichero" )
   if !file( cFileName )
      return .f.
   endif
   cExt := lower(cFileExt( cFileName ))

   do case
      case cExt == "prg" .or. cExt == "ch" .or. cExt == "c" .or. cExt == "cpp" .or. cExt == "rc" .or. cExt == "h"
           OpenCode( cFileName )
      case cExt == "bmp" .or. cExt == "jpg" .or. cExt == "gif" .or. cExt == "ico"
           ImageEditor( cFileName )
      case cExt == "dll"
           Recursos( cFileName )
      case cExt == "res"
           RecursosRes( cFileName )
      case cExt == "ffm"

   endcase

return nil

************************************************************************************
  METHOD Ftp() CLASS TApp
************************************************************************************
local h

Winexec( "easyftp.exe /sv ftp.arrakis.es /us canal_five /pw gomez2 /up" )

return nil







METHOD Incrustar( nGuia )

local oWnd, cTitle
local aTitles  := { "Fivewin Programming Guide",;
                    "Fivewin Functions guide",;
                    "Fivewin command guide",;
                    "Fivewin Classes",;
                    "FiveODBC Guide",;
                    "Editor de diálogos",;
                    "demo"}
local hWnd
local aFicheros := {"doc\FWPROG.HLP","doc\FWFUN.HLP","doc\FWCMD.HLP","doc\FWCLASS.HLP","doc\FIVEODBC.HLP","DialogEditor.exe","CxImage.exe"}


cTitle := aTitles[nGuia]

ShellExecute( Aplicacion():oWnd:hwnd,"open",CurDrive() + ":\" + CurDir() + "\" + aFicheros[nGuia] )

syswait( 1 )

hWnd := FindWindow( 0, cTitle )

if hWnd != 0

   DEFINE WINDOW oWnd TITLE cTitle OF Aplicacion():oWnd  ICON "dialogo"

   SetParent( hWnd, oWnd:hWnd )

   SetWindowLong( hWnd, -16, nOr( WS_CLIPCHILDREN, WS_VISIBLE, WS_VSCROLL, WS_HSCROLL ) )
   SetWindowPos ( hWnd, -1, 0, 0, 0, 0, nOr(SWP_NOSIZE, SWP_NOMOVE, SWP_FRAMECHANGED ) )

   ACTIVATE WINDOW oWnd ;
            ON INIT oWnd:SetSize( oWnd:nWidth, oWnd:nHeight+1,.t.) ;
            ON RESIZE MoveWindow( hWnd, 0, 0, nWidth, nHeight, .t. )

endif


return nil

***************************************************************************
  METHOD NuevoProyecto( nProyecto, cName, cLocation ) CLASS TApp
***************************************************************************
local oPrj

DEFAULT nProyecto := WINDOWS_PRJ
DEFAULT cName := "Proyecto1"
DEFAULT cLocation := Curdrive()+":\"+Curdir()+"\"

if ::oWndPrj == nil

   ::oProyecto := TProyecto():New( cName )
   ::oProyecto:CreaArbol()

endif

::oWndPrj:SetFocus()


return nil


function GetPrgs()

local aPrgs := Aplicacion():oProyecto:oTree:aGetItems( {|x| lower(cFileExt(x:cargo:cFileName)) == "prg" } )
local o


for each o in aPrgs
    ? o:cargo:cFileName
next

return nil


************************************************************************************
  METHOD SavePrj( cFileName ) CLASS TApp
************************************************************************************

DEFAULT cFileName := cGetFile( "*.5pj","Guardar proyecto como...", 1, , .t. )

if cFileExt( cFileName ) == ""
   cFileName += ".5pj"
endif

::oProyecto:oTree:SaveFile( cFileName )

return nil


************************************************************************************
  METHOD LoadPrj( cFileName ) CLASS TApp
************************************************************************************

DEFAULT cFileName := cGetFile( "*.5pj","Seleccione proyecto " )

if file( cFileName )
   ::oProyecto:oTree:LoadFile( cFileName )
endif

return nil


CLASS TWndApp FROM TWindow

      CLASSDATA lRegistered AS LOGICAL

      METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
            oBrush, oIcon, nClrFore, nClrBack, lVScroll,;
            lHScroll, nMenuInfo, cBorder, oWnd, lPixel ) CONSTRUCTOR

      METHOD HandleEvent   ( nMsg, nWParam, nLParam )

ENDCLASS

****************************************************************************************
   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
               oBrush, oIcon, nClrFore, nClrBack, lVScroll,;
               lHScroll, nMenuInfo, cBorder, oWnd, lPixel ) CLASS TWndApp
****************************************************************************************

//   ::nMenuInfo := 2

   super:New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
               oBrush, oIcon, nClrFore, nClrBack, lVScroll,;
               lHScroll, nMenuInfo, cBorder, oWnd, lPixel )

return self


//***************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWndApp
//***************************************************************************************************

//LogFile( "msgs.txt", { nMsg, nWParam, nLParam } )

return super:HandleEvent( nMsg, nWParam, nLParam )

function F2 ()
? "f2"
return 0

function F3 ()
? "f3"
return 0

function F4 ()
? "f4"
return 0

function F5 ()
? "f5"
return 0

function F6 ()
? "f6"
return 0

function F7 ()
? "f7"
return 0

function F8 ()
? "f8"
return 0

function F9 ()
? "f9"
return 0

function F10()
? "f10"
return 0

function F11()
Designer()
return 0

function F12()
? "f12"
return 0


Function hLib()

if hFreeImage == nil
   hFreeImage := LoadLibrary( "FreeImage.dll" )
endif
nFreeInstance++

return hFreeImage

Function FreeFreeImage()
--nFreeInstance

if nFreeInstance <= 0
   FreeLibrary( hFreeImage )
   hFreeImage := nil
   nFreeInstance := 0
endif

return nil



function GenPrg()
return ""







#pragma BEGINDUMP


#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
#include "hbset.h"
#include "hbapiitm.h"
#include "..\include\uxtheme.h"

HINSTANCE GetInstance( void );

/*
HB_FUNC( EXTCREATEPEN )
{
   LOGBRUSH lb;
   lb.lbStyle = hb_parnl( 1 );
   lb.lbColor = (COLORREF) hb_parnl( 3 );
   lb.lbHatch = hb_parnl( 5 );

   hb_retnl( (LONG) ExtCreatePen( (DWORD) hb_parnl( 1 ),
                                  (DWORD) hb_parnl( 2 ),
                                  &lb                  ,
                                  (DWORD) hb_parnl( 4 ),
                                  NULL ) ) ;
}
*/

HB_FUNC( SETACTIVEWINDOW )
{
         hb_retnl( (LONG) SetActiveWindow( ( HWND ) hb_parnl( 1 )));
}

HB_FUNC( SETFOREGROUNDWINDOW )
{
         hb_retnl( (LONG) SetForegroundWindow( ( HWND ) hb_parnl( 1 )));
}

HB_FUNC( CREATECOMPATIBLEDC )
{
         hb_retnl( (LONG) CreateCompatibleDC( ( HDC ) hb_parnl( 1 )));

}

HB_FUNC( CREATECOMPATIBLEBITMAP )
{
     hb_retnl( (LONG) CreateCompatibleBitmap( (HDC) hb_parnl(1), hb_parni(2), hb_parni(3)));
}


HB_FUNC( CREATEHATCHBRUSH )
{
   hb_retnl( (LONG) CreateHatchBrush( hb_parni( 1 ), hb_parnl( 2 ) ) );
}

HB_FUNC( CREATERECTRGN )
{
    hb_retnl( (LONG) CreateRectRgn( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

HB_FUNC( SELECTCLIPRGN )
{
    hb_retni( SelectClipRgn( ( HDC ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ) ) );
}

HB_FUNC( EXCLUDECLIPRECT )
{
  hb_retni( ExcludeClipRect( ( HDC ) hb_parnl( 1 ),         // handle to DC
                                     hb_parni( 2 ),
                                     hb_parni( 3 ),
                                     hb_parni( 4 ),
                                     hb_parni( 5 )));
}

HB_FUNC( CREATERECTRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parvni( 1, 1 );
    rc.left = hb_parvni( 1, 2 );
    rc.bottom = hb_parvni( 1, 3 );
    rc.right = hb_parvni( 1, 4 );

    hb_retnl( (LONG) CreateRectRgnIndirect( &rc ) );
}


HB_FUNC( CREATEELLIPTICRGN )
{
    hb_retnl( (LONG) CreateEllipticRgn( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}


HB_FUNC( CREATEELLIPTICRGNINDIRECT )
{
    RECT rc;

    rc.top = hb_parvni( 1, 1 );
    rc.left = hb_parvni( 1, 2 );
    rc.bottom = hb_parvni( 1, 3 );
    rc.right = hb_parvni( 1, 4 );

    hb_retnl( (LONG) CreateEllipticRgnIndirect( &rc ) );
}

BOOL Array2Point(PHB_ITEM aPoint, POINT *pt )
{
   if (HB_IS_ARRAY(aPoint) && hb_arrayLen(aPoint) == 2) {
      pt->x = hb_arrayGetNL(aPoint,1);
      pt->y = hb_arrayGetNL(aPoint,2);
      return TRUE ;
   }
   return FALSE;
}

BOOL Array2Rect(PHB_ITEM aRect, RECT *rc )
{
   if (HB_IS_ARRAY(aRect) && hb_arrayLen(aRect) == 4) {
      rc->left   = hb_arrayGetNL(aRect,1);
      rc->top    = hb_arrayGetNL(aRect,2);
      rc->right  = hb_arrayGetNL(aRect,3);
      rc->bottom = hb_arrayGetNL(aRect,4);
      return TRUE ;
   }
   return FALSE;
}


HB_FUNC( CREATEPOLYGONRGN )
{
   POINT * Point ;
   POINT pt ;
   int iCount ;
   int i ;
   PHB_ITEM aParam ;
   PHB_ITEM aSub ;

   if (ISARRAY( 1 ) )
   {
       iCount = (int) hb_parinfa( 1, 0 ) ;
       Point = (POINT *) hb_xgrab( iCount * sizeof (POINT) ) ;
       aParam = hb_param(1,HB_IT_ARRAY);

       for ( i = 0 ; i<iCount ; i++ )
       {
          aSub = hb_itemArrayGet( aParam, i+1 );

          if ( Array2Point(aSub, &pt ))
               *(Point+i) = pt ;
          else {
            hb_retnl(0);
            hb_xfree(Point);
            return ;
          }
       }

       hb_retnl( (LONG) CreatePolygonRgn( Point, iCount, hb_parni( 2 ) ) ) ;
       hb_xfree(Point);

   }
   else
    hb_retnl( 0 );

}


HB_FUNC( CREATEPOLYPOLYGONRGN )
{
   POINT * Point ;
   INT * PolyPoints ;
   int iPolyCount ;
   int iCount ;
   POINT pt ;
   int i ;
   PHB_ITEM aParam ;
   PHB_ITEM aSub ;

   if (ISARRAY( 1 ) && ISARRAY( 2 ) )
   {
       iPolyCount = hb_parinfa(2,0) ;
       PolyPoints = ( INT *) hb_xgrab( iPolyCount * sizeof( INT ) ) ;

       for ( i=0 ; i < iPolyCount ; i++ )
       {
          *(PolyPoints+i) = hb_parvni( 2,i+1) ;
       }

       iCount = hb_parinfa( 1, 0 ) ;
       Point = (POINT *) hb_xgrab( iCount * sizeof (POINT) ) ;
       aParam = hb_param(1,HB_IT_ARRAY);

       for ( i = 0 ; i<iCount ; i++ )
       {
          aSub = hb_itemArrayGet( aParam, i+1 );

          if ( Array2Point(aSub, &pt ))
               *(Point+i) = pt ;
          else {
            hb_retnl(0);
            hb_xfree(PolyPoints);
            hb_xfree(Point);
            return ;
          }
       }

       hb_retnl( (LONG) CreatePolyPolygonRgn( Point, PolyPoints, iPolyCount, hb_parni( 3 ) ) ) ;
       hb_xfree(PolyPoints);
       hb_xfree(Point);

   }
   else
    hb_retnl( 0 );

}

HB_FUNC( CREATEROUNDRECTRGN )
{
   hb_retnl( (LONG) CreateRoundRectRgn( hb_parni( 1 ),
                                        hb_parni( 2 ),
                                        hb_parni( 3 ),
                                        hb_parni( 4 ),
                                        hb_parni( 5 ),
                                        hb_parni( 6 ) ) ) ;
}

HB_FUNC( SETRECTRGN )
{
   hb_retl( SetRectRgn( (HRGN) hb_parnl( 1 ),
                        hb_parni( 2 )       ,
                        hb_parni( 3 )       ,
                        hb_parni( 4 )       ,
                        hb_parni( 5 )      ) ) ;
}

HB_FUNC( EQUALRGN )
{
   hb_retl( EqualRgn( (HRGN) hb_parnl( 1 ), (HRGN) hb_parnl( 2 ) ) ) ;
}


HB_FUNC( COMBINERGN )
{
   HRGN hrgnDest;
   HRGN hrgnSrc1 = ( HRGN ) hb_parnl( 1 );
   HRGN hrgnSrc2 = ( HRGN ) hb_parnl( 2 );
   int fnCombineMode = hb_parni( 3 );
   hb_retni( CombineRgn( hrgnDest, hrgnSrc1, hrgnSrc2, fnCombineMode ));

}

HB_FUNC( PATHTOREGION )
{
   hb_retnl( (LONG) PathToRegion( (HDC) hb_parnl( 1 ) ) ) ;
}

HB_FUNC( OFFSETRGN )
{
   hb_retni( OffsetRgn( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) ;
}


HB_FUNC( GETRGNBOX )
{
   RECT rc;
   hb_retni( GetRgnBox( (HRGN) hb_parnl( 1 ), &rc ) ) ;
   hb_storvnl( rc.left  , 2 ,2 );
   hb_storvnl( rc.top   , 2, 1 );
   hb_storvnl( rc.right , 2 ,4 );
   hb_storvnl( rc.bottom, 2, 3 );
}


HB_FUNC( PTINREGION )
{
   hb_retl( PtInRegion( (HRGN) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) ;
}

HB_FUNC( RECTINREGION )
{
    RECT rc;

   if (ISARRAY( 2 ) && Array2Rect( hb_param( 2, HB_IT_ARRAY ), &rc ) )
      hb_retl( RectInRegion( (HRGN) hb_parnl( 1 ), &rc ) ) ;
}

HB_FUNC( DRAWFOCUSRECT )  //RECT

{
   RECT rct ;
   HDC  hDC = ( HDC ) hb_parni( 1 );

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   DrawFocusRect( hDC, &rct );

}

HB_FUNC( FILLSOLIDRECT )
{
    RECT rct;
    COLORREF nColor;
    HPEN hPen, hOldPen;
    HDC hDC = ( HDC ) hb_parnl( 1 );
    rct.top    = hb_parvni( 2, 1 );
    rct.left   = hb_parvni( 2, 2 );
    rct.bottom = hb_parvni( 2, 3 );
    rct.right  = hb_parvni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parvnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right-1, rct.top );
       LineTo( hDC, rct.right-1, rct.bottom-1 );
       LineTo( hDC, rct.left, rct.bottom-1 );
       LineTo( hDC, rct.left, rct.top );
       SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }

}

HB_FUNC( PTINRECT )
   {
      POINT pt;
      RECT  rct;

      pt.y = hb_parnl( 1 );
      pt.x = hb_parnl( 2 );

      rct.top    = hb_parvni( 3, 1 );
      rct.left   = hb_parvni( 3, 2 );
      rct.bottom = hb_parvni( 3, 3 );
      rct.right  = hb_parvni( 3, 4 );

      hb_retl( PtInRect( &rct, pt ) );
   }

   HB_FUNC( INTERSECTRECT )
   {

      RECT rc, rc01, rc02;
      RECT rc0, rc1;

      rc01.top = hb_parvni( 1, 1 );
      rc01.left = hb_parvni( 1, 2 );
      rc01.bottom = hb_parvni( 1, 3 );
      rc01.right = hb_parvni( 1, 4 );

      rc02.top = hb_parvni( 2, 1 );
      rc02.left = hb_parvni( 2, 2 );
      rc02.bottom = hb_parvni( 2, 3 );
      rc02.right = hb_parvni( 2, 4 );

      rc0 = rc01;
      rc1 = rc02;

      hb_retl( IntersectRect( &rc, &rc0, &rc1 ) );

   }

   HB_FUNC( SETROP2 )  // (hdc, fnDrawMode)
   {
      hb_retni( ( LONG ) SetROP2( ( HDC ) hb_parni( 1 ), hb_parnl( 2 ) ));
   }

   HB_FUNC( UNIONRECT )
   {

      RECT rc, rc0, rc1;


      rc0.top    = hb_parvni( 1, 1 );
      rc0.left   = hb_parvni( 1, 2 );
      rc0.bottom = hb_parvni( 1, 3 );
      rc0.right  = hb_parvni( 1, 4 );

      rc1.top    = hb_parvni( 2, 1 );
      rc1.left   = hb_parvni( 2, 2 );
      rc1.bottom = hb_parvni( 2, 3 );
      rc1.right  = hb_parvni( 2, 4 );

      UnionRect( &rc, &rc0, &rc1 );
      hb_reta(4);

      hb_storvni( rc.top    , -1, 1 );
      hb_storvni( rc.left   , -1, 2 );
      hb_storvni( rc.bottom , -1, 3 );
      hb_storvni( rc.right  , -1, 4 );

   }

   HB_FUNC( DRAWEDGE )
   {
      HDC hDC     = (HDC) hb_parnl( 1 );
      RECT rc;
      HBRUSH hOldBrush;
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);

      hb_retl( DrawEdge( hDC, &rc, hb_parnl( 3 ), hb_parnl( 4 ) ) );
   }

   HB_FUNC( FONTCAPTION )
   {
        BOOL bTool = hb_parl(1);
        HFONT hFont;
        NONCLIENTMETRICS info;
        //BOOL bRet;
        info.cbSize = sizeof(info);
        SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof(info), &info, 0 );
        if( bTool )
        {
            hFont = CreateFontIndirect( &info.lfSmCaptionFont );
        }
        else
        {
            hFont = CreateFontIndirect( &info.lfCaptionFont );
        }
        hb_retnl( (LONG) hFont );
   }
/*
typedef struct tagNONCLIENTMETRICS {  UINT cbSize;
  int iBorderWidth;
  int iScrollWidth;
  int iScrollHeight;
  int iCaptionWidth;
  int iCaptionHeight;
  LOGFONT lfCaptionFont;
  int iSmCaptionWidth;
  int iSmCaptionHeight;
  LOGFONT lfSmCaptionFont;
  int iMenuWidth ;
  int iMenuHeight;
  LOGFONT lfMenuFont;
  LOGFONT lfStatusFont;
  LOGFONT lfMessageFont;
}
*/
   HB_FUNC( METRICSCAPTION )
   {
      HFONT hFont;
        NONCLIENTMETRICS info;
        //BOOL bRet;
        info.cbSize = sizeof(info);
        SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof(info), &info, 0 );
        hb_reta( 7 );
        hb_storvni( info.iCaptionWidth,    -1, 1 );
        hb_storvni( info.iCaptionHeight,   -1, 2 );
        hb_storvni( info.iSmCaptionWidth,  -1, 3 );
        hb_storvni( info.iSmCaptionHeight, -1, 4 );
        hb_storvni( info.iBorderWidth,     -1, 5 );
        hb_storvni( info.iMenuWidth ,      -1, 6 );
        hb_storvni( info.iMenuHeight,      -1, 7 );
   }

   HB_FUNC( DRAWCAPTION )
   {
      RECT rc;
      rc.top    = hb_parvni( 3, 1);
      rc.left   = hb_parvni( 3, 2);
      rc.bottom = hb_parvni( 3, 3);
      rc.right  = hb_parvni( 3, 4);

       hb_retl( DrawCaption( ( HWND )hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ), &rc, hb_parni(4)));
   }

   HB_FUNC( BOX )
   {
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen;
      HPEN hOldPen;
      RECT rc;

      if( hb_pcount() > 3 )
      {
         hPen = CreatePen( hb_parni(4),1, (COLORREF)hb_parnl( 3 ));
      }
      else
      {
         hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 3 ));
      }
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, rc.left, rc.top, NULL );
      LineTo( hDC, rc.right, rc.top );
      LineTo( hDC, rc.right, rc.bottom );
      LineTo( hDC, rc.left, rc.bottom );
      LineTo( hDC, rc.left, rc.top );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
   }

   HB_FUNC( LINE )
   {
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 6 ));
      HPEN hOldPen;
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, hb_parni( 3 ), hb_parni( 2 ), NULL );
      LineTo( hDC, hb_parni( 5 ), hb_parni( 4 ) );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
   }


   HB_FUNC( ISWINDOWVISIBLE )
   {
      hb_retl( IsWindowVisible( (HWND) hb_parnl(1) ) );
   }

   //////////////////////////////////////////////////////////////////////////   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////

   LPWSTR AnsiToWide( LPSTR cAnsi )
   {
      WORD wLen;
      LPWSTR cString;

      wLen  = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, 0, 0 );

      cString = (LPWSTR) hb_xgrab( wLen * 2 );
      MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cAnsi, -1, cString, wLen );

      return ( cString );
   }

   //--------------------------------------------------------------------------

   LPSTR WideToAnsi( LPWSTR cWide )
   {
      WORD wLen;
      LPSTR cString;

      wLen = WideCharToMultiByte( CP_ACP, 0, cWide, -1, cString, 0, NULL, NULL );

      cString = (LPSTR) hb_xgrab( wLen );
      WideCharToMultiByte( CP_ACP, 0, cWide, -1, cString, wLen, NULL, NULL );

      return ( cString );
   }


   HB_FUNC ( ANSITOWIDE )  // ( cAnsiStr ) -> cWideStr
   {
      WORD wLen;
      LPSTR cOut;

      wLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, hb_parc( 1 ), -1, 0, 0 );
      cOut = ( char * ) hb_xgrab( wLen * 2 );
      MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, hb_parc( 1 ), -1, ( LPWSTR ) cOut, wLen );

      hb_retclen( cOut, wLen * 2 - 1 );
      hb_xfree( cOut );
   }

   //--------------------------------------------------------------------------

   HB_FUNC ( WIDETOANSI )  // ( cWideStr, nLen ) -> cAnsiStr
   {
      WORD wLen;
      LPWSTR cWideStr;
      LPSTR cOut;

      cWideStr = ( LPWSTR ) hb_parc( 1 );
      wLen = WideCharToMultiByte( CP_ACP, WC_COMPOSITECHECK, cWideStr, -1, cOut, 0, NULL, NULL );
      cOut = ( char * ) hb_xgrab( wLen );
      WideCharToMultiByte( CP_ACP, WC_COMPOSITECHECK, cWideStr, -1, cOut, wLen, NULL, NULL );

      hb_retc( cOut );
      hb_xfree( cOut );
   }

   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   // ~~~~~~~ MANEJO DE TEMAS ~~~~~~
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
   // C5_ISTHEMEACTIVE
   // C5_OPENTHEMEDATA
   // C5_CLOSETHEMEDATA
   // C5_GETCURRENTTHEMENAME
   // C5_DRAWTHEMEBACKGROUND

   HB_FUNC( C5_ISAPPTHEMED )
   {
      typedef BOOL (CALLBACK* LPFNDLLFUNC2)();
      HINSTANCE hLib;
      LPFNDLLFUNC2 IsAppThemed;
      BOOL bIsAppThemed = FALSE;

      hLib = LoadLibrary( "uxtheme.dll" );
      if( hLib )
      {
          (LPFNDLLFUNC2)IsAppThemed = ((LPFNDLLFUNC2) GetProcAddress( hLib, "IsAppThemed" ));
          bIsAppThemed = (BOOL) IsAppThemed();
          FreeLibrary( hLib );
      }
      hb_retl(bIsAppThemed);
   }


   HB_FUNC( C5_ISTHEMEACTIVE ) // --> BOOL
   {
      typedef BOOL (CALLBACK* LPFNDLLFUNC2)();
      HINSTANCE hLib;
      LPFNDLLFUNC2 IsThemeActive;
      BOOL bIsActive = FALSE;

      hLib = LoadLibrary( "uxtheme.dll" );
      if( hLib )
      {
          IsThemeActive = ((LPFNDLLFUNC2) GetProcAddress( hLib, "IsThemeActive" ));
          bIsActive = (BOOL) IsThemeActive();
          FreeLibrary( hLib );
      }
      hb_retl(bIsActive);
   }

   HB_FUNC( C5_OPENTHEMEDATA ) //( ::hWnd, cTheme )
   {
     typedef HTHEME   ( FAR PASCAL  *LPOPENTHEMEDATA )( HWND hwnd, LPCSTR pszClassList );
     LPWSTR cTheme = AnsiToWide( hb_parc( 2 ) );
     HINSTANCE hLib;
     LPOPENTHEMEDATA OpenThemeData;

     hLib = LoadLibrary( "uxtheme.dll" );

     if ( hLib )
     {
         OpenThemeData = (LPOPENTHEMEDATA) GetProcAddress( hLib, "OpenThemeData" );
         hb_retnl( ( LONG ) OpenThemeData( ( HWND ) hb_parnl( 1 ) , ( LPCSTR ) cTheme ) ); //
         FreeLibrary( hLib );
     }
     hb_xfree( cTheme );
   }

   HB_FUNC( C5_CLOSETHEMEDATA )
   {
      typedef HRESULT  ( FAR PASCAL  *LPCLOSETHEMEDATA )     ( HTHEME hTheme );
      HINSTANCE hLib ;
      LPCLOSETHEMEDATA CloseThemeData;
      hLib = LoadLibrary( "uxtheme.dll" );
      if ( hLib )
      {
          CloseThemeData = (LPCLOSETHEMEDATA) GetProcAddress( hLib, "CloseThemeData" );
          hb_retni( CloseThemeData( (HTHEME) hb_parnl( 1 ) ) );
          FreeLibrary( hLib );
      }
   }


   HB_FUNC( C5_GETCURRENTTHEMENAME )
   {
     typedef HRESULT  ( FAR PASCAL  *LPGETCURRENTTHEMENAME) ( LPWSTR pszThemeFileName, int cchMaxNameChars, LPWSTR pszColorBuff, int cchMaxColorChars, LPWSTR pszSizeBuff, int cchMaxSizeChars);
     WCHAR pszThemeFileName[MAX_PATH];
     HINSTANCE hLib;
     LPGETCURRENTTHEMENAME GetCurrentThemeName;
     LPSTR cOut;

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         GetCurrentThemeName = (LPGETCURRENTTHEMENAME) GetProcAddress( hLib, "GetCurrentThemeName" );
         GetCurrentThemeName( (LPWSTR) pszThemeFileName, MAX_PATH, NULL, 0, NULL, 0 );
         cOut = WideToAnsi( pszThemeFileName );
         hb_retc( cOut );
         hb_xfree( cOut );
         FreeLibrary( hLib );
     }
   }

   HB_FUNC( C5_DRAWTHEMEBACKGROUND ) //( ::hTheme, hDC, nPartID, nStateID, pRect, pClipRect )
   {
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEBACKGROUND )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, const RECT *pRect, const RECT *pClipRect );
     HINSTANCE hLib;
     LPDRAWTHEMEBACKGROUND DrawThemeBackground;
     int iRet;
     RECT pRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeBackground = (LPDRAWTHEMEBACKGROUND) GetProcAddress( hLib, "DrawThemeBackground" );
         iRet = DrawThemeBackground( ( HTHEME ) hb_parnl( 1 ),
                                          (HDC) hb_parnl( 2 ),
                                                hb_parni( 3 ),
                                                hb_parni( 4 ),
                                                &pRect,
                                                NULL );
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
   }

/*HRESULT DrawThemeIcon(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pRect,
    HIMAGELIST himl,
    int iImageIndex
);*/

   HB_FUNC( C5_DRAWTHEMEICON ) //( ::hTheme, hDC, nPartID, nStateID, pRect, himl, index )
   {
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEICON )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, const RECT *pRect, HIMAGELIST il, int index );
     HINSTANCE hLib;
     LPDRAWTHEMEICON DrawThemeIcon;
     int iRet;
     RECT pRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeIcon = (LPDRAWTHEMEICON) GetProcAddress( hLib, "DrawThemeIcon" );
         iRet = DrawThemeIcon( ( HTHEME )     hb_parnl( 1 ),
                               ( HDC )        hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &pRect,
                               ( HIMAGELIST ) hb_parnl( 6 ),
                                              hb_parni( 7 ));
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
   }

/*HRESULT DrawThemeEdge(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pDestRect,
    UINT uEdge,
    UINT uFlags,
    RECT *pContentRect
);*/
HB_FUNC( C5_DRAWTHEMEEDGE )
{
     typedef HRESULT  ( FAR PASCAL  *LPDRAWTHEMEEDGE )( HTHEME hTheme,
                                                        HDC hdc,
                                                        int iPartId,
                                                        int iStateId,
                                                        const RECT *pDestRect,
                                                        UINT uEdge,
                                                        UINT uFlags,
                                                        RECT *pContentRect );
     HINSTANCE hLib;
     LPDRAWTHEMEEDGE DrawThemeEdge;
     int iRet;
     RECT pRect;
     RECT pContentRect;

     pRect.top    = hb_parvnl( 5, 1 );
     pRect.left   = hb_parvnl( 5, 2 );
     pRect.bottom = hb_parvnl( 5, 3 );
     pRect.right  = hb_parvnl( 5, 4 );

     pContentRect.top    = hb_parvnl( 5, 1 );
     pContentRect.left   = hb_parvnl( 5, 2 );
     pContentRect.bottom = hb_parvnl( 5, 3 );
     pContentRect.right  = hb_parvnl( 5, 4 );

     hLib = LoadLibrary( "uxtheme.dll" );
     if ( hLib )
     {
         DrawThemeEdge = (LPDRAWTHEMEEDGE) GetProcAddress( hLib, "DrawThemeEdge" );
         iRet = DrawThemeEdge( ( HTHEME )     hb_parnl( 1 ),
                               ( HDC )        hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &pRect,
                                              hb_parni( 6 ),
                                              hb_parni( 7 ),
                                              &pContentRect );
         FreeLibrary( hLib );
     }
     hb_retni( iRet );
}


/*HRESULT DrawThemeText(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    LPCWSTR pszText,
    int iCharCount,
    DWORD dwTextFlags,
    DWORD dwTextFlags2,
    const RECT *pRect
);*/

   HB_FUNC( C5_DRAWTHEMETEXT ) //( ::hWnd, cTheme )
   {
     typedef HRESULT ( FAR PASCAL  *LPDRAWTHEMETEXT )( HTHEME hTheme,
                                                       HDC hdc,
                                                       int iPartId,
                                                       int iStateId,
                                                       LPCWSTR pszText,
                                                       int iCharCount,
                                                       DWORD dwTextFlags,
                                                       DWORD dwTextFlags2,
                                                       RECT *rc );

     LPCWSTR pszText = AnsiToWide( hb_parc( 5 ) );
     HINSTANCE hLib;
     LPDRAWTHEMETEXT DrawThemeText;
     RECT rc;

     rc.top     = hb_parvnl( 8, 1 );
     rc.left    = hb_parvnl( 8, 2 );
     rc.bottom  = hb_parvnl( 8, 3 );
     rc.right   = hb_parvnl( 8, 4 );


     hLib = LoadLibrary( "uxtheme.dll" );

     if ( hLib )
     {
         DrawThemeText = (LPDRAWTHEMETEXT) GetProcAddress( hLib, "DrawThemeText" );
         hb_retnl( ( LONG ) DrawThemeText( ( HTHEME ) hb_parnl( 1 ),
                            ( HDC )    hb_parnl( 2 ),
                            hb_parni( 3 ),
                            hb_parni( 4 ),
                 (LPCWSTR)  pszText,
                            -1,
                            hb_parnl( 6 ),
                            hb_parnl( 7 ),
                            &rc ) );          //
         FreeLibrary( hLib );
     }
     hb_xfree( pszText );
   }

/*HRESULT GetThemeBackgroundContentRect(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    const RECT *pBoundingRect,
    RECT *pContentRect
);
*/


HB_FUNC( GETTHEMEFONT )   //(::hTheme, hDC, nPartID, nStateID, nPropID, pFont)
{

  LOGFONT plf;
  HFONT hFont;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEFONT )( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, int iPropId, LOGFONT *pFont);
  HINSTANCE hLib;
  LPGETTHEMEFONT GetThemeFont;

  ZeroMemory( &plf, sizeof(plf) );

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeFont = (LPGETTHEMEFONT) GetProcAddress( hLib, "GetThemeFont" );
      hb_retnl( ( LONG ) GetThemeFont((HTHEME) hb_parnl( 1 ),
                       ( HDC ) hb_parnl( 2 ),
                       hb_parni( 3 ),
                       hb_parni( 4 ),
                       hb_parni( 5 ),
                       &plf ) );          //
      hFont = CreateFontIndirect( &plf );
      hb_retnl( (long) hFont );
      FreeLibrary( hLib );
      return;
  }
  hb_ret();
}


/*HRESULT GetThemeSysFont(          HTHEME hTheme,
    int iFontID,
    LOGFONT *plf
);*/

HB_FUNC( GETTHEMESYSFONT )   //(::hTheme, hDC, nPartID, nStateID, nPropID, pFont)
{
  LOGFONT plf;
  HFONT hFont;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMESYSFONT )( HTHEME hTheme, int iFontID,LOGFONT *pFont);
  HINSTANCE hLib;
  LPGETTHEMESYSFONT GetThemeSysFont;

  ZeroMemory( &plf, sizeof(plf) );

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeSysFont = (LPGETTHEMESYSFONT) GetProcAddress( hLib, "GetThemeSysFont" );
      GetThemeSysFont((HTHEME) hb_parnl( 1 ),
                               hb_parni( 2 ),
                               &plf );          //
      hFont = CreateFontIndirect( &plf );
      hb_retnl( (long) hFont );
      FreeLibrary( hLib );
      return;
  }
  hb_ret();

}

HB_FUNC(GETTHEMECOLOR)   //(::hTheme, nPartID, nStateID, nPropID, pColor)
{
  COLORREF color;
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMECOLOR )( HTHEME hTheme, int iPartId, int iStateId, int nPropID, COLORREF *color);
  HINSTANCE hLib;
  LPGETTHEMECOLOR GetThemeColor;
  int iPropId = 204;
  if( hb_pcount() > 3 )
  {
     iPropId = hb_parni( 4 );
  }

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeColor = (LPGETTHEMECOLOR) GetProcAddress( hLib, "GetThemeColor" );
      hb_retnl( ( LONG ) GetThemeColor((HTHEME) hb_parnl( 1 ),
                                               hb_parni( 2 ),
                                               hb_parni( 3 ),
                                               iPropId,
                                               &color ) );          //
      FreeLibrary( hLib );
      hb_retnl( (long) color );
      return;
  }
  hb_ret();
}

/*HRESULT GetThemeMetric(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    int iPropId,
    int *piVal
);
*/
HB_FUNC( GETTHEMEMETRIC )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEMETRIC )( HTHEME hTheme, HDC hDC, int iPartId, int iStateId, int iPropId, int *piVal );
  HINSTANCE hLib;
  LPGETTHEMEMETRIC GetThemeMetric;
  int iVal = 0;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeMetric = (LPGETTHEMEMETRIC) GetProcAddress( hLib, "GetThemeMetric" );
      GetThemeMetric((HTHEME) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                                                     hb_parni( 3 ),
                                                     hb_parni( 4 ),
                                                     hb_parni( 5 ),
                                                     &iVal ) ;
      FreeLibrary( hLib );
      hb_retni( iVal );
      return;
  }
  hb_retni( iVal );
}
/*
HRESULT GetThemePartSize(          HTHEME hTheme,
    HDC hdc,
    int iPartId,
    int iStateId,
    RECT *prc,
    THEMESIZE eSize,
    SIZE *psz
);*/

HB_FUNC( GETTHEMEPARTSIZE )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEPARTSIZE )(HTHEME hTheme, HDC hdc, int iPartId,
                                                         int iStateId, RECT * pRect, enum THEMESIZE eSize, SIZE *psz);
  HINSTANCE hLib;
  LPGETTHEMEPARTSIZE GetThemePartSize;
  SIZE sz;
  sz.cx = 0;
  sz.cy = 0;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemePartSize = (LPGETTHEMEPARTSIZE) GetProcAddress( hLib, "GetThemePartSize" );
      GetThemePartSize((HTHEME) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                                                       hb_parni( 3 ),
                                                       hb_parni( 4 ),
                                                (RECT*) NULL,
                                                       TS_TRUE,
                                                       &sz ) ;
        FreeLibrary( hLib );
      hb_retni( sz.cy );
      return;
  }
  hb_retni( sz.cy );
}

HB_FUNC( GETTHEMESYSCOLOR )
{

  COLORREF color;
  typedef COLORREF ( FAR PASCAL  *LPGETTHEMESYSCOLOR )( HTHEME hTheme, int iColorID );
  HINSTANCE hLib;
  LPGETTHEMESYSCOLOR GetThemeSysColor;

  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeSysColor = (LPGETTHEMESYSCOLOR) GetProcAddress( hLib, "GetThemeSysColor" );
      GetThemeSysColor((HTHEME) hb_parnl( 1 ), hb_parni( 2 )) ;          //
      FreeLibrary( hLib );
      hb_retnl( (long) color );
      return;
  }
  hb_ret();

}

/*HRESULT GetThemeBackgroundContentRect( HTHEME hTheme,
                                         HDC hdc,
                                         int iPartId,
                                         int iStateId,
                                         const RECT *pBoundingRect,
                                         RECT *pContentRect
);
*/
HB_FUNC( GETTHEMEBACKGROUNDCONTENTRECT )
{
  typedef HRESULT ( FAR PASCAL  *LPGETTHEMEBACKGROUNDCONTENTRECT )(HTHEME hTheme,
                                         HDC hdc,
                                         int iPartId,
                                         int iStateId,
                                         const RECT *pBoundingRect,
                                         RECT *pContentRect );
  HINSTANCE hLib;
  LPGETTHEMEBACKGROUNDCONTENTRECT GetThemeBackgroundContentRect;
  RECT rcout;
  RECT rc;

  rc.top     = hb_parvnl( 5, 1 );
  rc.left    = hb_parvnl( 5, 2 );
  rc.bottom  = hb_parvnl( 5, 3 );
  rc.right   = hb_parvnl( 5, 4 );

  rcout.top     = hb_parvnl( 5, 1 );
  rcout.left    = hb_parvnl( 5, 2 );
  rcout.bottom  = hb_parvnl( 5, 3 );
  rcout.right   = hb_parvnl( 5, 4 );



  hLib = LoadLibrary( "uxtheme.dll" );

  if ( hLib )
  {
      GetThemeBackgroundContentRect = (LPGETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hLib, "GetThemeBackgroundContentRect" );
      GetThemeBackgroundContentRect( (HTHEME) hb_parnl( 1 ),
                                     (HDC)    hb_parnl( 2 ),
                                              hb_parni( 3 ),
                                              hb_parni( 4 ),
                                              &rc          ,
                                              &rcout );          //
      FreeLibrary( hLib );

  }
  hb_reta(4);

  hb_storvni( rcout.top    , -1, 1 );
  hb_storvni( rcout.left   , -1, 2 );
  hb_storvni( rcout.bottom , -1, 3 );
  hb_storvni( rcout.right  , -1, 4 );
}

HB_FUNC( STRETCHBLT )
{
   hb_retl( StretchBlt( (HDC) hb_parnl( 1 )   ,
                        hb_parni( 2 )         ,
                        hb_parni( 3 )         ,
                        hb_parni( 4 )         ,
                        hb_parni( 5 )         ,
                        (HDC) hb_parnl( 6 )   ,
                        hb_parni( 7 )         ,
                        hb_parni( 8 )         ,
                        hb_parni( 9 )         ,
                        hb_parni( 10 )        ,
                        (DWORD) hb_parnl( 11 )
                        ) ) ;
}


HB_FUNC( REGISTERWINDOWMESSAGE )
{
     hb_retni( RegisterWindowMessage( ( LPCTSTR ) hb_parc(1)));
}

HB_FUNC( SETBRUSHORGEX )
{
   SetBrushOrgEx( (HDC) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), NULL );
   hb_ret();
}

/*BOOL SetWindowOrgEx(
  HDC hdc,        // handle to device context
  int X,          // new x-coordinate of window origin
  int Y,          // new y-coordinate of window origin
  LPPOINT lpPoint // original window origin
);*/
HB_FUNC( SETWINDOWORGEX )
{
   POINT pt;
   pt.x = 0;
   pt.y = 0;
   SetWindowOrgEx( (HDC) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), &pt );
   hb_reta( 2 );
   hb_storvni( pt.y, -1, 1 );
   hb_storvni( pt.x, -1, 2 );

}

HB_FUNC( DSGNBORDE )
{

   HDC dc = (HDC) hb_parnl( 1 );
   HBITMAP bmp  = LoadBitmap( GetInstance(), "brush" );
   HBITMAP bmp2 = LoadBitmap( GetInstance(), "brush" );
   int nXMiddle;
        int nYMiddle;
   COLORREF color;
   HBRUSH br, br2, hOldBrush;
   POINT pt;
   RECT rc, rcPaint;

   rc.top    = hb_parvni( 2, 1 );
   rc.left   = hb_parvni( 2, 2 );
   rc.bottom = hb_parvni( 2, 3 );
   rc.right  = hb_parvni( 2, 4 );

        br2 = CreatePatternBrush( bmp2 );
        br = CreatePatternBrush( bmp );

        nXMiddle = (rc.right-rc.left) / 2;
        nYMiddle = (rc.bottom-rc.top) / 2;

   hOldBrush = (HBRUSH) SelectObject( dc, br );
   color = SetBkColor( dc, RGB( 255,0,0) );

   SetBrushOrgEx( dc, rc.left, rc.top, NULL );
        SetRect( &rcPaint, rc.left, rc.top, rc.right, rc.top + 7 );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );


   SetBrushOrgEx( dc, rc.left, rc.top, NULL );
        SetRect( &rcPaint, rc.left, rc.top, rc.left + 7, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );

   SetBrushOrgEx( dc, rc.left, rc.bottom - 7, NULL );
        SetRect( &rcPaint, rc.left, rc.bottom - 7, rc.right, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br );

   SetBrushOrgEx( dc, rc.right - 7, rc.top, NULL );
        SetRect( &rcPaint, rc.right - 7, rc.top, rc.right, rc.bottom );
        PatBlt( dc, rcPaint.left, rcPaint.top, rcPaint.right-rcPaint.left, rcPaint.bottom-rcPaint.top, PATCOPY );
        //FillRect( dc, &rcPaint, br2 );

   SelectObject( dc, hOldBrush );
   SetBkColor( dc, color );

        DeleteObject( bmp );
        DeleteObject( bmp2 );
        DeleteObject( br );
        DeleteObject( br2 );

}

HB_FUNC( EXTCREATEPEN )
{
   int numValues = 0;
   HPEN pen;
   LOGBRUSH lb;
   lb.lbStyle = BS_SOLID;
   lb.lbColor = (COLORREF)hb_parnl( 2 );
   lb.lbHatch = 0;

   pen = ExtCreatePen(PS_GEOMETRIC | PS_SOLID | PS_ENDCAP_SQUARE | PS_JOIN_BEVEL, hb_parni( 1 ), &lb, numValues, NULL);

   hb_retnl( (long) pen );
}


    void GradientFill95( HDC hDC, RECT rct, COLORREF crStart, COLORREF crEnd, int bVertical )
    {
    	// Get the starting RGB values and calculate the incremental
    	// changes to be applied.

            int nSegments = 100;
    	COLORREF cr;
    	int nR = GetRValue(crStart);
    	int nG = GetGValue(crStart);
    	int nB = GetBValue(crStart);

    	int neB = GetBValue(crEnd);
    	int neG = GetGValue(crEnd);
    	int neR = GetRValue(crEnd);


    	int nDiffR = (neR - nR);
    	int nDiffG = (neG - nG);
    	int nDiffB = (neB - nB);

    	int ndR = 256 * (nDiffR) / (max(nSegments,1));
    	int ndG = 256 * (nDiffG) / (max(nSegments,1));
    	int ndB = 256 * (nDiffB) / (max(nSegments,1));

    	int nCX = (rct.right-rct.left) / max(nSegments,1);
    	int nCY = (rct.bottom-rct.top) / max(nSegments,1);
    	int nTop = rct.top;
    	int nBottom = rct.bottom;
    	int nLeft = rct.left;
    	int nRight = rct.right;

            HPEN hPen;
            HPEN hOldPen;
            HBRUSH hBrush;
            HBRUSH pbrOld;

            int i;

    	if(nSegments > ( rct.right - rct.left ) )
    		nSegments = ( rct.right - rct.left );


    	nR *= 256;
    	nG *= 256;
    	nB *= 256;

    	hPen    = CreatePen( PS_NULL, 1, 0 );
    	hOldPen = (HPEN) SelectObject( hDC, hPen );

    	for (i = 0; i < nSegments; i++, nR += ndR, nG += ndG, nB += ndB)
    	{
    		// Use special code for the last segment to avoid any problems
    		// with integer division.

    		if (i == (nSegments - 1))
    		{
    			nRight  = rct.right;
    			nBottom = rct.bottom;
    		}
    		else
    		{
    			nBottom = nTop + nCY;
    			nRight = nLeft + nCX;
    		}

    		cr = RGB(nR / 256, nG / 256, nB / 256);

    		{

    			hBrush = CreateSolidBrush( cr );
    			pbrOld = (HBRUSH) SelectObject( hDC, hBrush );

    			if( bVertical )
    			   Rectangle(hDC, rct.left, nTop, rct.right, nBottom + 1 );
    			else
    			   Rectangle(hDC, nLeft, rct.top, nRight + 1, rct.bottom);

    			(HBRUSH) SelectObject( hDC, pbrOld );
    			DeleteObject( hBrush );
    		}

    		// Reset the left side of the drawing rectangle.

    		nLeft = nRight;
    		nTop = nBottom;
    	}

    	(HPEN) SelectObject( hDC, hOldPen );
    	DeleteObject( hPen );
    }

// hDC, aRect, nClr1, nClr2
// Utilizar mejor C5Degrada
    HB_FUNC( DEGRADA95 )
    {
            RECT rct;

            rct.top    = hb_parvni( 2, 1 );
            rct.left   = hb_parvni( 2, 2 );
            rct.bottom = hb_parvni( 2, 3 );
            rct.right  = hb_parvni( 2, 4 );

            GradientFill95( ( HDC ) hb_parnl( 1 ) , rct, hb_parnl( 3 ), hb_parnl( 4 ), hb_parl(5) );

    }


HB_FUNC( CREATEBOLD )
{
        LOGFONT lf;
      GetObject( ( HFONT ) hb_parnl( 1 ) , sizeof( LOGFONT ), &lf );
      lf.lfWeight = FW_BOLD;
                  hb_retnl( (LONG) CreateFontIndirect( &lf ));
}


HB_FUNC( WBRWSCROLL ) // ( hWnd, nRows, hFont ) --> nil
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int wRows  = hb_parni( 2 );
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   int nHLine = hb_parni( 4 );
   RECT rct;
   TEXTMETRIC tm;



   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );
   GetTextMetrics( hDC, &tm );
   if( hb_pcount() == 4 )
   {
      tm.tmHeight = nHLine;
   }
   else
   {
     tm.tmHeight += 1;
   }

   rct.top += tm.tmHeight;
   //rct.bottom -= ( ( rct.bottom - rct.top ) % tm.tmHeight );

   ScrollWindowEx( hWnd, 0, -( tm.tmHeight * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

HB_FUNC( DRAWFRAMECONTROL )
{
      RECT rc;
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);

       hb_retl( DrawFrameControl( (HDC) hb_parnl( 1 ), &rc, hb_parni( 3 ), hb_parni( 4 ) ) );
}




HB_FUNC( HWNDCOMBO )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndCombo ) ;
}

HB_FUNC( HWNDCOMBOEDIT )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndItem ) ;
   //hb_retnl( (LONG)cbi.hwndList ) ;
}

HB_FUNC( HWNDCOMBOLIST )
{
   COMBOBOXINFO cbi      ;
   ZeroMemory( &cbi, sizeof( COMBOBOXINFO ) );
   cbi.cbSize = sizeof(COMBOBOXINFO);

   GetComboBoxInfo( (HWND) hb_parnl( 1 ), &cbi );

   hb_retnl( (LONG)cbi.hwndList ) ;
}
// no funciona en w95 revisar GetComboBoxInfo


HB_FUNC( GETDEFAULTFONTNAME )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retc( lf.lfFaceName );

}

HB_FUNC( GETDEFAULTFONTHEIGHT )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retni( lf.lfHeight );
}

HB_FUNC( GETDEFAULTFONTWIDTH )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retni( lf.lfWidth );
}

HB_FUNC( GETDEFAULTFONTITALIC )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfItalic );
}

HB_FUNC( GETDEFAULTFONTUNDERLINE )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfUnderline );
}

HB_FUNC( GETDEFAULTFONTBOLD )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) ( lf.lfWeight == 700 ) );
}

HB_FUNC( GETDEFAULTFONTSTRIKEOUT )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfStrikeOut );
}

HB_FUNC( XDLGUNITS )
{
   HDC dc = GetDC(NULL);
   HFONT hFont = (HFONT) hb_parnl( 1 );
   LOGFONT lf, lf2;
   HFONT hSysFont;
   TEXTMETRIC tm;
   int cx, cxSys;
   int avgWidth, avgWidthSys;
   int basex;

   HFONT hOldFont = (HFONT)SelectObject(dc, hFont);
   GetObject( ( HFONT ) hFont  , sizeof( LOGFONT ), &lf );
   GetTextMetrics(dc, &tm);
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&cx);
   SelectObject(dc, hOldFont);

   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf2 );
   //GetObject( ( HFONT ) GetStockObject( SYSTEM_FONT )  , sizeof( LOGFONT ), &lf );
   lf2.lfWidth = lf.lfWidth;
   lf2.lfHeight = lf.lfHeight;
   hSysFont = CreateFontIndirect( &lf2 );
   hOldFont = (HFONT) SelectObject( dc, hSysFont );
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&cxSys);
   SelectObject(dc, hOldFont);
   DeleteObject( hSysFont );
   ReleaseDC(NULL, dc);

   avgWidth = (cx/(26+1))/2;
   avgWidthSys = (cxSys/(26+1))/2;

   basex = ( 2*avgWidth/avgWidthSys );
   hb_retni(basex);
}

HB_FUNC( YDLGUNITS )
{
   HDC dc = GetDC(NULL);
   HFONT hFont = (HFONT) hb_parnl( 1 );
   HFONT hSysFont;
   LOGFONT lf, lf2;
   TEXTMETRIC tm, tm2;
   int basey;

   HFONT hOldFont = (HFONT)SelectObject(dc, hFont);
   GetTextMetrics(dc, &tm);
   SelectObject(dc, hOldFont);

   GetObject( ( HFONT ) hFont  , sizeof( LOGFONT ), &lf );
   GetObject( ( HFONT ) GetStockObject( SYSTEM_FONT )  , sizeof( LOGFONT ), &lf2 );
   lf2.lfWidth = lf.lfWidth;
   lf2.lfHeight = lf.lfHeight;
   hSysFont = CreateFontIndirect( &lf2 );
   hOldFont = (HFONT)SelectObject(dc, hSysFont);
   GetTextMetrics(dc, &tm2);
   SelectObject(dc, hOldFont);
   DeleteObject( hSysFont );

   ReleaseDC(NULL, dc);
   basey = (2*tm.tmHeight/tm2.tmHeight);
   hb_retni( basey );
}

HB_FUNC( XYDLGUNITS )
{
   int avgWidth, avgHeight;
   HDC dc = GetDC(NULL);
   HFONT hFontOld = (HFONT)SelectObject(dc,(HFONT)hb_parnl( 1 ));
   SIZE size;
   TEXTMETRIC tm;

   GetTextMetrics(dc,&tm);
   GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,&size);
   avgWidth = (size.cx/26+1)/2;
   avgHeight = (WORD)tm.tmHeight;
   SelectObject(dc,hFontOld);
   ReleaseDC(NULL, dc);
   hb_reta(2);
   hb_storvni( avgWidth, -1, 1 );
   hb_storvni( avgHeight, -1, 2 );
}

 /*
HB_FUNC(  GETPTSIZE ) //( HDC &dc, HFONT &font, SIZE *pSize )
{
    HFONT oldfont = 0;
    HDC dc = GetDC(NULL);
    static char *sym = "abcdefghijklmnopqrstuvwxyz"
                       "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    SIZE sz;
    sz.cx = hb_parni( 2 );
    sz.cy = hb_parni( 3 );
    TEXTMETRICA t;
    oldfont = (HFONT)SelectObject(dc,hb_parnl(1));
    GetTextMetricsA(dc,&t);
    GetTextExtentPointA(dc,sym, 52, &sz);
    pSize->cy = t.tmHeight;
    pSize->cx = (sz.cx / 26 + 1) / 2;
    SelectObject(dc,oldfont);
}
*/

HB_FUNC ( DRIVETYPE )
{
   #if defined(HB_OS_WIN_32)
      unsigned int uiType;
      char * pDrive = (char *) hb_xgrab( hb_parclen( 1 )+3 ); // allow space for '\0' & ":\"
      strcpy( pDrive, (char *) hb_parcx(1) );

      if ( strstr( pDrive, ":" ) == NULL )
      {
         strcat( pDrive, ":" ) ;
      }

      if ( strstr( pDrive, "\\" ) == NULL )
      {
         strcat( pDrive, "\\" ) ;
      }

      uiType = GetDriveType( pDrive );

      if ( uiType  == DRIVE_RAMDISK )
      {
         hb_retni( 0 );  // RAM Drive - Clipper compatible
      }
      else if (uiType == DRIVE_REMOVABLE )
      {
         hb_retni( 2 );  // Floppy Drive - Clipper compatible
      }
      else if (uiType == DRIVE_FIXED )
      {
         hb_retni( 3 );  // Hard Drive  - Clipper compatible
      }
      else if (uiType == DRIVE_CDROM )
      {
         hb_retni( 4 );  // CD-Rom Drive - xHarbour extension
      }
      else if (uiType == DRIVE_REMOTE )
      {
         hb_retni( 5 );  // Network Drive - xHarbour extension
      }
      else
      {
         hb_retni( 9 );  // Unknow Drive - xHarbour extension
      }
      hb_xfree( pDrive );
   #else
      hb_retni(9);
   #endif

}

HB_FUNC( GETBMPICONEXT )
{

   SHFILEINFO    sfi;
   HDC dcMem;
   HDC hDC;
   HBITMAP bmpMem, hOldBmp;
   RECT rct;
   COLORREF nColor;

	SHGetFileInfo(
		   hb_parc( 1 ),
		   FILE_ATTRIBUTE_NORMAL,
		   &sfi,
		   sizeof(SHFILEINFO),
		   SHGFI_ICON | SHGFI_SMALLICON | SHGFI_USEFILEATTRIBUTES);


   hDC = CreateDC( "DISPLAY","","",NULL);

   dcMem = CreateCompatibleDC( hDC );
   bmpMem = CreateCompatibleBitmap( hDC, 16, 16 );
   hOldBmp = (HBITMAP) SelectObject( dcMem, bmpMem );
   rct.top    = 0;
   rct.left   = 0;
   rct.bottom = 16;
   rct.right  = 16;

   nColor = SetBkColor( dcMem, RGB(255,255,255) );
   ExtTextOut( dcMem, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
   SetBkColor( dcMem, nColor );

   DrawIconEx( dcMem, 0, 0, sfi.hIcon, 16, 16, NULL, NULL, DI_NORMAL );
   DestroyIcon( sfi.hIcon );
   SelectObject( dcMem, hOldBmp );
   DeleteDC( dcMem );
   DeleteDC( hDC );
   hb_retnl( (LONG) bmpMem );
}

HB_FUNC( SETSTRETCHBLTMODE )
{
   hb_retni( SetStretchBltMode( (HDC) hb_parnl( 1 ), hb_parni( 2 ) ) ) ;
}

void DrawBitmapEx( HDC hdc, HBITMAP hbm, WORD wCol, WORD wRow, WORD wWidth,
                 WORD wHeight, DWORD dwRaster )
{
    HDC       hDcMem, hDcMemX;
    BITMAP    bm, bmx;
    HBITMAP   hBmpOld, hbmx, hBmpOldX;

    if( !hdc || !hbm )
       return;

    hDcMem  = CreateCompatibleDC( hdc );
    hBmpOld = ( HBITMAP ) SelectObject( hDcMem, hbm );

    if( ! dwRaster )
       dwRaster = SRCCOPY;

    GetObject( hbm, sizeof( BITMAP ), ( LPSTR ) &bm );

    if( ! wWidth || ! wHeight )
       BitBlt( hdc, wRow, wCol, bm.bmWidth, bm.bmHeight, hDcMem, 0, 0, dwRaster );
    else
    {
       hDcMemX          = CreateCompatibleDC( hdc );
       bmx              = bm;
       bmx.bmWidth      = wWidth;
       bmx.bmHeight     = wHeight;

       bmx.bmWidthBytes = ( bmx.bmWidth * bmx.bmBitsPixel + 15 ) / 16 * 2;

       hbmx = CreateBitmapIndirect( &bmx );

       SetStretchBltMode (hDcMemX, COLORONCOLOR);
       hBmpOldX = ( HBITMAP ) SelectObject( hDcMemX, hbmx );
       StretchBlt( hDcMemX, 0, 0, wWidth, wHeight, hDcMem, 0, 0,
                   bm.bmWidth, bm.bmHeight, dwRaster );
       BitBlt( hdc, wRow, wCol, wWidth, wHeight, hDcMemX, 0, 0, dwRaster );
       SelectObject( hDcMemX, hBmpOldX );
       DeleteDC( hDcMemX );
       DeleteObject( hbmx );
    }

    SelectObject( hDcMem, hBmpOld );
    DeleteDC( hDcMem );
}
HB_FUNC( DRAWBITMAPEX ) //  hDC, hBitmap, nRow, nCol, nWidth, nHeight, nRaster
{
   DrawBitmapEx( ( HDC ) hb_parnl( 1 ), ( HBITMAP ) hb_parnl( 2 ),
               hb_parni( 3 ), hb_parni( 4 ),
               hb_parni( 5 ), hb_parni( 6 ), hb_parnl( 7 ) );
}


   HB_FUNC( MULDIV )
   {
      hb_retni( MulDiv( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
   }


HB_FUNC( SETSCROLLRANGE )
{
   hb_retl( SetScrollRange( (HWND) hb_parnl( 1 ),
                            hb_parni( 2 )       ,
                            hb_parni( 3 )       ,
                            hb_parni( 4 )       ,
                            hb_parl( 5 )
                          ) ) ;
}

HB_FUNC( GETSCROLLINFOPOS )
{
   SCROLLINFO si ;
   si.cbSize = sizeof(SCROLLINFO) ;
   si.fMask  = SIF_TRACKPOS ;

   if ( GetScrollInfo( (HWND) hb_parnl( 1 ), hb_parni( 2 ), &si ) )
      hb_retni( si.nTrackPos );
   else
      hb_retni( 0 );

}


HB_FUNC( SUMAESTILO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style | hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_STYLE, style );
}

//--------------------------------------------------------------------------

HB_FUNC( RESTAESTILO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style & ~hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_STYLE, style );
}

HB_FUNC( SUMAESTILOEXTENDIDO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style | hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_EXSTYLE, style );

}

//--------------------------------------------------------------------------

HB_FUNC( RESTAESTILOEXTENDIDO )
{
   int i;
   int style = hb_parnl( 2 );

   for ( i = 3; i <= hb_pcount(); i++ )
      style = style & ~hb_parnl( i );

   SetWindowLong( (HWND) hb_parnl( 1 ), GWL_EXSTYLE, style );
}


//HB_FUNC( LINE )
//{
//   HDC hDC = (HDC) hb_parnl( 1 );
//   int nTop = hb_parni( 2 );
//   int nLeft = hb_parni( 3 );
//   int nBottom = hb_parni( 4 );
//   int nRight = hb_parni( 5 );
//   COLORREF color = (COLORREF) hb_parnl(6);
//   HPEN hPen, hOldPen;
//   hPen = CreatePen( PS_SOLID, 1, color );
//   hOldPen = (HPEN) SelectObject( hDC, hPen );
//   MoveToEx( hDC, nLeft, nTop, NULL );
//   LineTo( hDC, nRight, nBottom );
//   SelectObject( hDC, hOldPen );
//   DeleteObject( hPen );
//}
//
//

HB_FUNC( ALPHABLEND )
{

}


HB_FUNC( FREELIBRARY ) // ( hDll ) --> nil
{
   hb_retnl( FreeLibrary( ( HINSTANCE ) hb_parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( LOADLIBRARY ) // ( cDllName ) --> hDll
{
   hb_retnl( ( LONG ) LoadLibrary( hb_parc( 1 ) ) );
}

#pragma ENDDUMP



//function TOLEAUTO() ; return 0
//function CREATEOBJECT() ; return 0
function curdrive() ; return hb_curdrive()


CLASS TWindowMain FROM TWindow

      CLASSDATA lRegistered AS LOGICAL

      METHOD HandleEvent( nMsg, nWParam, nLParam )

ENDCLASS

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWindowMain

if nMsg == 28




endif

return super:HandleEvent( nMsg, nWParam, nLParam )


*************************************************************************************
   function VisorCodigo()
*************************************************************************************


  DEFINE WINDOW oWndCode TITLE "Visor code" FROM 10, 500 TO 310, 1200 PIXEL

        /*  DEFINE BUTTONBAR oBar SIZE 23, 27 OF oWndCHild _3D

          DEFINE BUTTON OF oBar NOBORDER

          DEFINE BUTTON OF oBar NOBORDER  NAME "new"      GROUP
          DEFINE BUTTON OF oBar NOBORDER  NAME "open"            ACTION OpenCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "saveed"          ACTION SaveCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "printer"         ACTION PrintCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "cut"       GROUP
          DEFINE BUTTON OF oBar NOBORDER  NAME "copy"
          DEFINE BUTTON OF oBar NOBORDER  NAME "paste"
          DEFINE BUTTON OF oBar NOBORDER  NAME "undoed"    GROUP ACTION UndoCode()   WHEN CanUndoCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "redoed"          ACTION RedoCode()   WHEN CanRedoCode()
          DEFINE BUTTON OF oBar NOBORDER  NAME "finded"    GROUP ACTION DlgFindText()

          DEFINE BUTTON OF oBar                                  ACTION FindTip() //InsertX()
          DEFINE BUTTON OF oBar                                  ACTION FindMark()
          DEFINE BUTTON OF oBar                                  ACTION FindLine()
          //DEFINE BUTTON OF oBar NOBORDER  NAME "bmps\fonts.bmp"       ACTION OptionSetFont()


      //oCode := TCodeMax():New(0, 0, 1, 1, oWndChild )
      */
      oCode := TScintilla():New(0, 0, 1, 1, oWndCode )
      oCode:SetFocus()

      oWndCode:oClient := oCode
      oWndCode:ToolWindow()
      oWndCode:Show()

   //ACTIVATE WINDOW oWndChild MAXIMIZED


return nil

function oWndCode() ; return oWndCode
