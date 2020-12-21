#include "fivewin.ch"


#define CARPETA 13
#define WM_SETFONT   48  // 0x30

   CLASS TProyecto

         DATA cPrjName
         DATA cPath

         DATA lResFile
         DATA cDriver
         DATA lMapFile
         DATA cOutName

         DATA cPrgDir
         DATA cObjDir
         DATA cIncDir
         DATA cCesDir
         DATA oTree
         DATA oOutPut
         DATA oConfig
         DATA oConfWnd
         DATA oConfTree
         DATA oHarbour
         DATA oC
         DATA oFive
         DATA oPaths
         DATA oFlagsCmpHb
         DATA oFlagsCmpC
         DATA oFlagsLnkC

         METHOD New( cPrjName, cPath ) CONSTRUCTOR

         METHOD ActionTree( oItem )
         METHOD AddProj( lMain )
         METHOD AddExistFileToFolder( oItem )
         METHOD AddFile( oFile, oItemFolder )
         METHOD AddFolder( cName, oItemFolder )
         METHOD AddRuta( oItem )
         METHOD Borrar( oItem )
         METHOD Compilar( oItem )
         METHOD CreaArbol()
         METHOD Configuracion()
         METHOD ExisteNombre( cName, oItem )
         METHOD GenMake( oItem )
         METHOD GetImageType( cTipo )
         METHOD LoadConfig( cFileName )
         METHOD Menu( nRow, nCol )
         METHOD ModificarNombre( oItem )
         METHOD NuevaCarpeta( oItem )
         METHOD Open( oItem )
         METHOD Properties() VIRTUAL
         METHOD Restaurar( oItem )
         METHOD SaveConfig( oItem, cFileName )
         METHOD SetCesDir( cCarpeta )
         METHOD SetIncDir( cCarpeta )
         METHOD SetObjDir( cCarpeta )
         METHOD SetPrgDir( cCarpeta )
         METHOD SetPrgMain( oItem )
         METHOD SetAsMainPrj( oItem )
         METHOD VaciarPapelera()
         METHOD VerPropiedades( oItem )
         METHOD aGetFiles( cExt )
         METHOD cGetFiles( cExt, cSep )
         METHOD oPapelera()        INLINE ::oTree:Find( {|x| x:cPrompt == "Papelera" .and. x:cTipo == "bas" } )
         METHOD Zoom( oItem )


   ENDCLASS


   ******************************************************************************************************************************
     METHOD New( cPrjName, cPath ) CLASS TProyecto
   ******************************************************************************************************************************

     DEFAULT cPath := CurDrive() + ":\" + CurDir()

     ::cPrjName   := alltrim(cPrjName)
     ::cPath      := cPath
     ::cIncDir    := ""
     ::cPrgDir    := ""
     ::cObjDir    := ""
     ::cCesDir    := ""
     ::oConfWnd   := nil

   return self

   ******************************************************************************************************************************
         METHOD AddFolder( cName, oItemFolder ) CLASS TProyecto
   ******************************************************************************************************************************

       aadd( ::aCarpetas, cName )

   return len( ::aCarpetas )

   ******************************************************************************************************************************
         METHOD AddFile( cName, cCarpeta ) CLASS TProyecto
   ******************************************************************************************************************************

       local oFile := TFilePrj():New( cName, cCarpeta )
       local nEn

       nEn := ascan( ::aFiles, cName )

       if nEn > 0
          MsgStop( "Ya existe el fichero " + cName, "Atención")
          return -1
       endif

       aadd( ::aFiles, oFile )


   return len( ::aFiles )



   ******************************************************************************************************************************
         METHOD cGetFiles( cExt, cSep ) CLASS TProyecto
   ******************************************************************************************************************************
       local n
       local nLen := len( ::aFiles )
       local cStr := ""
       local cFile

       DEFAULT cSep := " "

       for n := 1 to len( ::aFiles )
           cFile := ::aFiles[n]
           if lower(cFileExt( cFile )) == lower(cExt)
              cStr += cFile + if( n < len( ::aFiles ), cSep, CRLF )
           endif
       next

       return cStr

   ******************************************************************************************************************************
         METHOD aGetFiles( cExt ) CLASS TProyecto
   ******************************************************************************************************************************
       local n
       local nLen := len( ::aFiles )
       local aRet := {}
       local cFile

       for each cFile in ::aFiles
           if lower(cFileExt( cFile )) == lower(cExt)
              aadd( aRet, cFile )
           endif
       next

       return aRet


   ************************************************************************************************
      METHOD SetPrgDir( cCarpeta ) CLASS TProyecto
   ************************************************************************************************
      local nEn

      nEn := ascan( ::aCarpetas, {|c| lower(c) == lower(cCarpeta) } )
      if nEn == 0
         MsgStop( "Carpeta " + cCarpeta + " no encontrada", "Atención. PrdDir" )
         return .f.
      endif

      ::cPrdDir := cCarpeta

      return .t.



   ************************************************************************************************
      METHOD SetObjDir( cCarpeta ) CLASS TProyecto
   ************************************************************************************************
      local nEn

      nEn := ascan( ::aCarpetas, {|c| lower(c) == lower(cCarpeta) } )
      if nEn == 0
         MsgStop( "Carpeta " + cCarpeta + " no encontrada", "Atención. ObjDir" )
         return .f.
      endif

      ::cObjDir := cCarpeta

      return .t.

   ************************************************************************************************
      METHOD SetIncDir( cCarpeta ) CLASS TProyecto
   ************************************************************************************************
      local nEn

      nEn := ascan( ::aCarpetas, {|c| lower(c) == lower(cCarpeta) } )
      if nEn == 0
         MsgStop( "Carpeta " + cCarpeta + " no encontrada", "Atención. IncDir" )
         return .f.
      endif

      ::cIncDir := cCarpeta

      return .t.

   ************************************************************************************************
      METHOD SetCesDir( cCarpeta ) CLASS TProyecto
   ************************************************************************************************
      local nEn

      nEn := ascan( ::aCarpetas, {|c| lower(c) == lower(cCarpeta) } )
      if nEn == 0
         MsgStop( "Carpeta " + cCarpeta + " no encontrada", "Atención. IncDir" )
         return .f.
      endif

      ::cCesDir := cCarpeta

      return .t.


   ************************************************************************************************
     METHOD GenMake( oItem ) CLASS TProyecto
   ************************************************************************************************

     local cStr   := ""
     local aLibs  := ::Aplication():aLibs
     local h
     local n, nLen
     local cPrgFiles, cCFiles

     cStr += "# Make directives ############################################################"          + CRLF

     cStr += ".autodepend"                                                                             + CRLF
     cStr += ".swap"                                                                                   + CRLF
     cStr += ".suffixes: .prg .hrb"                                                                    + CRLF + CRLF

     cStr += "# Flags for modules to include: YES | NO (must be UPPERCASE)##################"          + CRLF + CRLF

     cStr += "RES_FILE      = " + if( ::lResFile(),"YES","NO")                                         + CRLF
     cStr += "LNK_DBFNTX    = " + if( ::cDriver == "DBFNTX","YES","NO")                                + CRLF
     cStr += "LNK_DBFCDX    = " + if( ::cDriver == "DBFCDX","YES","NO")                                + CRLF
     cStr += "LNK_DEBUG     = NO"                                                                      + CRLF
     cStr += "LNK_ADVANTAGE = " + if( ::cDriver == "ADS","YES","NO")                                   + CRLF
     cStr += "LNK_ODBC      = " + if( ::cDriver == "ODBC","YES","NO")                                  + CRLF
     cStr += "MAP_FILE      = " + if( ::lMapFile(),"YES","NO")                                         + CRLF



     cStr += "# Application directories & filenames ########################################"          + CRLF + CRLF

     cStr += "APP_NAME         = " + ::cOutName                                                        + CRLF
     cStr += "APP_PRG_DIR      = " + ::cPrgDir                                                         + CRLF
     cStr += "APP_OBJ_DIR      = " + ::cObjDir                                                         + CRLF
     cStr += "APP_C_DIR        = " + ::cCesDir                                                         + CRLF
     cStr += "APP_EXE_DIR      = $(APP_PRG_DIR)"                                                       + CRLF
     cStr += "APP_RES_DIR      = $(APP_PRG_DIR)"                                                       + CRLF + CRLF

     cStr += "APP_EXE  = $(APP_EXE_DIR)\$(APP_NAME).exe"                                               + CRLF
     cStr += "APP_RC   = $(APP_RES_DIR)\$(APP_NAME).rc"                                                + CRLF
     cStr += "APP_RES  = $(APP_RES_DIR)\$(APP_NAME).res"                                               + CRLF
     cStr += "APP_MAP  = $(APP_RES_DIR)\$(APP_NAME).map"                                               + CRLF + CRLF

     cStr += "# Paths for dependent files ##################################################"          + CRLF

     cStr += ".path.prg = $(APP_PRG_DIR)"                                                              + CRLF
     cStr += ".path.hrb = $(APP_OBJ_DIR)"                                                              + CRLF
     cStr += ".path.obj = $(APP_OBJ_DIR)"                                                              + CRLF + CRLF
     cStr += ".path.c   = $(APP_PRG_DIR)"                                                              + CRLF + CRLF

     cStr += "# Application PRG files (your PRG files go here) #############################"          + CRLF + CRLF

     cStr += "APP_PRG_LIST = "
     cStr += ::cGetFiles( "prg", " \" + CRLF )                                                         + CRLF + CRLF

     cStr += "# Application C files (your C files go here) #############################"              + CRLF + CRLF

     cStr += "APP_C_LIST = "
     cStr += ::cGetFiles( "c", " \" + CRLF )                                                           + CRLF + CRLF


     cStr += CRLF + "# Contruction of the rest dependency lists ###################################"   + CRLF + CRLF

     cStr += "APP_PRGS = $(APP_PRG_LIST)"                                                              + CRLF
     cStr += "APP_HRBS = $(APP_PRG_LIST:.prg=.hrb)"                                                    + CRLF
     cStr += "APP_OBJS = $(APP_PRG_LIST:.prg=.obj) $(APP_C_LIST:.c=.obj)"                              + CRLF + CRLF

     cStr += "# Harbour directories & flags ################################################"          + CRLF + CRLF

     cStr += "HARBOUR_DIR          = " +::cHbDir                                                       + CRLF
     cStr += "HARBOUR_FLAGS        = " +::cHbFlags

     nLen := len( ::aIncs )
     if nLen > 0
        cStr += " -i"
     endif
     for n := 1 to nLen
         cStr += ::aIncs[n] + if( n < nLen, ";","")
     next
     cStr += CRLF

     cStr += "HARBOUR_EXE          = $(HARBOUR_DIR)\bin\harbour.exe"                             + CRLF
     cStr += "BORLANDC_DIR         = " + ::cBCDir                                                + CRLF

     cStr += "BORLANDC_COMP_FLAGS  = " + ::cCCmpFlags

     nLen := len( ::aIncs )
     if nLen > 0
        cStr += " -I"
     endif
     for n := 1 to nLen
         cStr += ::aIncs[n] + if( n < nLen, ";","")
     next
     cStr += CRLF

     cStr += "BORLANDC_COMP_EXE    = $(BORLANDC_DIR)\bin\bcc32.exe"                             + CRLF
     cStr += "BORLANDC_LINK_FLAGS  = " + ::cCLnkFlags

     cStr += " -L" + ::cGetPaths( aLibs ) + CRLF

     cStr += "BORLANDC_LINK_EXE    = $(BORLANDC_DIR)\bin\ilink32.exe"                           + CRLF
     cStr += "BORLANDC_RES_EXE     = $(BORLANDC_DIR)\bin\brc32.exe"                             + CRLF

     cStr += "!if $(MAP_FILE) != YES"                                                           + CRLF
     cStr += "   BORLANDC_LINK_FLAGS = $(BORLANDC_LINK_FLAGS) -x"                               + CRLF
     cStr += "!endif"                                                                           + CRLF + CRLF

     cStr += "# Dependencies ###############################################################"   + CRLF + CRLF

     cStr += "all: $(APP_OBJS) $(APP_HRBS) $(APP_EXE)"                                          + CRLF + CRLF

     cStr += "!if $(RES_FILE) == YES"                                                           + CRLF
     cStr += "all: $(APP_RES)"                                                                  + CRLF
     cStr += "!endif"                                                                           + CRLF

     cStr += "# Implicit Rules #############################################################"   + CRLF + CRLF

     cStr += ".prg.hrb:"                                                                        + CRLF
     cStr += "   $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@"                                      + CRLF + CRLF

     cStr += ".hrb.obj:"                                                                        + CRLF
     cStr += "   $(BORLANDC_COMP_EXE) $(BORLANDC_COMP_FLAGS) -o$@ $**"                          + CRLF + CRLF

     cStr += ".c.obj:"                                                                          + CRLF
     cStr += "   $(BORLANDC_COMP_EXE) $(BORLANDC_COMP_FLAGS) -o$@ $**"                          + CRLF + CRLF


     cStr += "# Explicit Rules #############################################################"   + CRLF + CRLF

     cStr += "!if $(RES_FILE) == YES"                                                           + CRLF
     cStr += "$(APP_RES) : $(APP_RC)"                                                           + CRLF
     cStr += "   $(BORLANDC_RES_EXE) -r $**"                                                    + CRLF + CRLF

     cStr += "$(APP_EXE) :: $(APP_RES)"                                                         + CRLF
     cStr += "   @if exist $(APP_EXE) del $(APP_EXE) > nul"                                     + CRLF
     cStr += "!endif"                                                                           + CRLF + CRLF

     cStr += "$(APP_EXE) :: $(APP_OBJS)"                                                        + CRLF
     cStr += "   @echo $(BORLANDC_DIR)\lib\c0w32.obj + > make.tmp"                              + CRLF
     cStr += "   @echo $(**), + >> make.tmp"                                                    + CRLF
     cStr += "   @echo $(APP_EXE), + >> make.tmp"                                               + CRLF
     cStr += "   @echo $(APP_MAP), + >> make.tmp"                                               + CRLF

     nLen := len( aLibs )
     for n := 1 to nLen
         cStr += "   @echo " + lower(aLibs[n]) + " + >> make.tmp"                               + CRLF
     next

     cStr += "!if $(RES_FILE) == YES"                                                           + CRLF
     cStr += "   @echo ,$(APP_RES) >> make.tmp"                                                 + CRLF
     cStr += "!endif"                                                                           + CRLF
     cStr += "   $(BORLANDC_LINK_EXE) $(BORLANDC_LINK_FLAGS) @make.tmp"                         + CRLF
     cStr += "   @del $(APP_EXE_DIR)\$(APP_NAME).tds"                                           + CRLF
     //cStr += "   @del make.tmp"                                                                 + CRLF


     h := fcreate( ::cOutName + ".mak" )
     fwrite( h, cStr )
     fclose( h )


     return nil

   ************************************************************************************************
     METHOD CreaArbol() CLASS TProyecto
   ************************************************************************************************

     local oItem1, oItem2, oItem3, oItem4
     local oBrush
     local oImageList
     local oWnd := Aplicacion():oWnd
     local oBar
     local o := self
     local oRoot, oRoot2
     local oRoot0


     if Aplicacion():oWndPrj != nil
        return ::oWndChild:SetFocus()
     endif


     oImageList = TImageList():New(16,16,"toolbar\image1.bmp")

     DEFINE BRUSH oBrush STYLE "NULL"

     DEFINE WINDOW Aplicacion():oWndPrj TITLE "Proyecto" OF oWnd MDICHILD  BRUSH obrush

            //Aplicacion():oWndPrj:oWndClient:SetBrush( oBrush )

            DEFINE BUTTONBAR oBar OF Aplicacion():oWndPrj 3D SIZE 25, 25

                   DEFINE BUTTON OF oBar NAME "plus"   NOBORDER   TOOLTIP "Expandir"    ACTION o:oTree:ExpandAll()
                   DEFINE BUTTON OF oBar NAME "minus"  NOBORDER   TOOLTIP "Contraer"    ACTION o:oTree:ColapseAll()
                   DEFINE BUTTON OF oBar NAME "props"   NOBORDER  TOOLTIP "Propiedades"


            ::oTree := TTreeView():New( 1, 1, Aplicacion():oWndPrj, 0, CLR_WHITE,.t., .f., 1000, 1000 )
            ::oTree:SetImageList( oImageList )

            Aplicacion():oSolucion := TTVItem():New( ::oTree,, "Solucion", 5, .t., ::oTree,,"sol",.t. )

            ::AddProj(.t.)

            TTVItem():New( ::oTree,, "Papelera", 12, .t., ::oTree,,"bas",.t.,.f.  )

            ::oTree:Expand()
            ::oTree:SetBrush( oBrush )
            ::oTree:bRClicked := {|nRow,nCol| o:Menu( nRow, nCol, o:oTree ) }

            Aplicacion():oWndPrj:oClient := ::oTree

      ACTIVATE WINDOW Aplicacion():oWndPrj ON INIT Aplicacion():oWndPrj:Resize() VALID( Aplicacion():oWndPrj := nil, oImageList:End(),.T.)


   return nil


   ************************************************************************************************
         METHOD AddProj( lMain ) CLASS TProyecto
   ************************************************************************************************

   local oRoot

   DEFAULT lMain := .f.

   oRoot  := TTVItem():New( ::oTree,, ::cPrjName + space(7), 5, .t.,  Aplicacion():oSolucion,,"prj",.t. )
   oRoot:lMain := lMain
   aadd( Aplicacion():aProyectos, oRoot )

              TTVItem():New( ::oTree,, "Prg"      , 6, .t., oRoot,,"prg",.t.,.t. )
              TTVItem():New( ::oTree,, "Includes" , 6, .t., oRoot,,"ch",.t.,.t. )
              TTVItem():New( ::oTree,, "C"        , 6, .t., oRoot,,"c",.t.,.t. )
              TTVItem():New( ::oTree,, "Recursos" , 6, .t., oRoot,,"rc",.t.,.t. )
              TTVItem():New( ::oTree,, "Imágenes" , 6, .t., oRoot,,"img",.t.,.t. )
              TTVItem():New( ::oTree,, "Librerias", 6, .t., oRoot,,"lib",.t.,.t. )

   oRoot:Expand()

   return nil



   ************************************************************************************************
         METHOD Configuracion() CLASS TProyecto
   ************************************************************************************************

     local oItem1, oItem2, oItem3, oItem4
     local oBrush
     local oImageList
     local oWnd := Aplicacion():oWnd
     local oBar
     local o := self
     local oRoot, oRoot2
     local oRoot0



     if ::oConfWnd != nil
        return ::oConfWnd:SetFocus()
     endif


     oImageList = TImageList():New(16,16,"toolbar\image1.bmp")

     DEFINE BRUSH oBrush STYLE "NULL"

     DEFINE WINDOW ::oConfWnd TITLE "Proyecto" OF oWnd MDICHILD  BRUSH obrush

            DEFINE BUTTONBAR oBar OF ::oConfWnd 3D SIZE 25, 25

                   DEFINE BUTTON OF oBar NAME "plus"   NOBORDER   TOOLTIP "Expandir"    ACTION o:oConfTree:ExpandAll()
                   DEFINE BUTTON OF oBar NAME "minus"  NOBORDER   TOOLTIP "Contraer"    ACTION o:oConfTree:ColapseAll()
                   DEFINE BUTTON OF oBar NAME "props"   NOBORDER  TOOLTIP "Propiedades"


            ::oConfTree := TTreeView():New( 1, 1, ::oConfWnd, 0, CLR_WHITE,.t., .f., 1000, 1000 )
            ::oConfTree:SetImageList( oImageList )

            ::oConfig := TTVItem():New( ::oConfTree,, "Configuracion", CARPETA, .t., ::oConfTree,,"config",.t.,.f. )

                      ::oHarbour := TTVItem():New( ::oConfTree,, "Harbour" , CARPETA, .t., ::oConfig,,"cfg",.t.,.f. )
                      oItem4 := TTVItem():New( ::oConfTree,, "Flags compilador" , 11, .t., ::oHarbour,,"cfg" )
                          ::oFlagsCmpHb := TTVItem():New( ::oConfTree,,"-n -m -w -es0 -gc0", 11, .t., oItem4,,"flags" )
                          ::oFlagsCmpHb:bAction :=  {|oItem| ::Open( oItem ) }

                      oItem1   := TTVItem():New( ::oConfTree,, "Librerias" , 11, .t., ::oHarbour,,"lib" )

                                 TTVItem():New( ::oConfTree,, "rtl.lib"   , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "vm.lib"    , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "gtwin.lib" , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "lang.lib"  , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "macro.lib" , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "rdd.lib"   , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "dbfntx.lib", 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "dbfdbt.lib", 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "dbfcdx.lib", 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "debug.lib" , 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "common.lib", 11, .t., oItem1,,"lib" )
                                 TTVItem():New( ::oConfTree,, "pp.lib"    , 11, .t., oItem1,,"lib" )


            ::oC := TTVItem():New( ::oConfTree,, "C", CARPETA, .t., ::oConfig,,"cfg",.t.,.f. )

                 oItem4 := TTVItem():New( ::oConfTree,, "Compilador" , 11, .t., ::oC,,"lib" )
                 oItem4 := TTVItem():New( ::oConfTree,, "Flags compilador" , 11, .t., oItem4,,"lib" )
                          ::oFlagsCmpC := TTVItem():New( ::oConfTree,,"-c -O2", 11, .t., oItem4,,"flags" )
                          ::oFlagsCmpC:bAction :=  {|oItem| ::Open( oItem ) }

                 oItem4 := TTVItem():New( ::oConfTree,, "Linkador" , 11, .t., ::oC,,"lib" )
                 oItem4 := TTVItem():New( ::oConfTree,, "Flags Linkador" , 11, .t., oItem4,,"cfg" )
                          ::oFlagsLnkC := TTVItem():New( ::oConfTree,,"-Gn -aa -Tpe -s ", 11, .t., oItem4,,"flags" )
                          ::oFlagsLnkC:bAction :=  {|oItem| ::Open( oItem ) }

                 oItem4 := TTVItem():New( ::oConfTree,, "Compilador de recursos" , 11, .t., ::oC,,"lib" )
                           TTVItem():New( ::oConfTree,, "Flags recursos" , 11, .t., oItem4,,"cfg" )


                 oItem2 := TTVItem():New( ::oConfTree,, "Librerias" , 11, .t., ::oC,,"lib",.t.,.f. )

                                       TTVItem():New( ::oConfTree,,"c0w32.obj"         , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"cw32.lib"          , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"import32.lib"      , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"psdk\odbc32.lib"   , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"psdk\rasapi32.lib" , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"psdk\nddeapi.lib"  , 11, .t., oItem2,,"lib" )
                                       TTVItem():New( ::oConfTree,,"psdk\iphlpapi.lib" , 11, .t., oItem2,,"lib" )

            ::oFive := TTVItem():New( ::oConfTree,, "FiveWin", CARPETA, .t., ::oConfig,,"cfg",.t.,.f. )
                oItem2 :=  TTVItem():New( ::oConfTree,, "Librerias" , 11, .t., ::oFIve,,"lib",.t.,.f.  )
                               TTVItem():New( ::oConfTree,,"Fiveh.lib"  , 11, .t., oItem2,,"lib" )
                               TTVItem():New( ::oConfTree,,"Fivehc.lib" , 11, .t., oItem2,,"lib" )

            ::oPaths := TTVItem():New( ::oConfTree,, "Paths",28 , .t., ::oConfig,,"cfg",.t.,.f.  )
                               TTVItem():New( ::oConfTree,,"Prgs"     ,3 , .t., ::oPaths,,"paths" )
                               TTVItem():New( ::oConfTree,,"Includes" ,1 , .t., ::oPaths,,"paths" )
                               TTVItem():New( ::oConfTree,,"Libs"     ,11 , .t., ::oPaths,,"paths" )
                               TTVItem():New( ::oConfTree,,"Objs"     ,13 , .t., ::oPaths,,"paths" )


            ::oConfTree:SetBrush( oBrush )
            ::oConfTree:Expand()
            ::oPaths:Expand()


            ::oConfTree:bRClicked := {|nRow,nCol| o:Menu( nRow, nCol, o:oConfTree ) }

            ::oConfWnd:oClient := ::oConfTree

      ACTIVATE WINDOW o:oConfWnd ON INIT o:oConfWnd:Resize() VALID( o:oConfWnd := nil, oImageList:End(),.T.)


    return nil


   ************************************************************************************************
         METHOD GetImageType( cTipo ) CLASS TProyecto
   ************************************************************************************************
   do case
      case cTipo == "prg"
           return  3
      case cTipo == "ch"
           return  1
      case cTipo == "c"
           return  9
      case cTipo == "h"
           return 10
      case cTipo == "rc"
           return  2
      case cTipo == "img"
           return 0
      case cTipo == "lib"
           return  11
      case cTipo == "paths"
           return  17
   endcase

   return 14

   ************************************************************************************************
      METHOD Menu( nRow, nCol, oArbol ) CLASS TProyecto
   ************************************************************************************************

   local oMenu
   local oItem
   local lActivate := .t.
   local oPapelera := ::oPapelera()


   SendMessage( ::oTree:hWnd, WM_LBUTTONDOWN, 0, nMakeLong( nCol, nRow ) )

   oItem := oArbol:HitTest( nRow, nCol )
   if oItem == nil
      lActivate := .f.
   else
      if oItem:cTipo == "config"
         MENU oMenu POPUP
            MENUITEM "Salvar configuración" ACTION ::SaveConfig( oItem )
            MENUITEM "Cargar configuración" ACTION ::LoadConfig(  )
            SEPARATOR
            MENUITEM "Zoom"                 ACTION ::Zoom( oItem )
         ENDMENU
      else
         if oItem:lFolder
            MENU oMenu POPUP
                 MENUITEM "Añadir"
                 MENU
                    if oItem:cTipo == "sol"
                       MENUITEM "Nuevo proyecto"                  ACTION ::AddProj()
                    else
                       MENUITEM "Nuevo elemento"                  ACTION Aplicacion():Nuevo( oItem, .t. ), oItem:Expand()
                       MENUITEM "Elemento existente a la carpeta" ACTION ::AddExistFileToFolder( oItem )
                       MENUITEM "Nueva carpeta"                   ACTION ::NuevaCarpeta( oItem )
                       MENUITEM "Ruta"                            ACTION ::AddRuta( oItem )
                    endif
                 ENDMENU
                 if oItem:cTipo == "prj"
                    MENUITEM "Build"                              ACTION ::GenMake()
                    MENUITEM "Borrar"                             ACTION ::Borrar( oItem )
                    MENUITEM "Renombrar"                          ACTION ::ModificarNombre( oItem )
                    MENUITEM "Poner como Proyecto principal"      ACTION ::SetAsMainPrj( oItem )
                 else
                    MENUITEM "Cortar"                             ACTION oItem:Copy(.t.)
                    MENUITEM "Copiar"                             ACTION oItem:Copy()
                    MENUITEM "Pegar"                              ACTION oItem:Paste(oItem)
                    MENUITEM "Borrar"                             ACTION ::Borrar( oItem )
                    MENUITEM "Renombrar"                          ACTION ::ModificarNombre( oItem )
                 endif
                 SEPARATOR
                 MENUITEM "Propiedades"                        ACTION ::VerPropiedades( oItem )
                 if oPapelera != nil .and. oItem:nID == oPapelera:nID .and. len( oPapelera:aItems ) > 0
                    MENUITEM "Vaciar papelera"                 ACTION if( MsgYesNo( "¿Esta seguro de vaciar la papelera?"), ::VaciarPapelera(),MsgInfo( "Operación cancelada","Atención"))
                 endif
                 SEPARATOR
                 MENUITEM "Zoom"                 ACTION ::Zoom( oItem )
              ENDMENU
         else

            if !oItem:lFolder

               MENU oMenu POPUP

                    MENUITEM "Abrir"                           ACTION ::Open( oItem )

                    if oItem:cTipo == "paths"
                       MENUITEM "Añadir ruta"                  ACTION ::AddRuta( oItem )
                    endif

                    SEPARATOR

                    if oItem:cTipo == "prg" .or. oItem:cTipo == "c"
                       MENUITEM "Compilar"                     ACTION ::Compilar( oItem )
                    endif

                    MENUITEM "Cortar"                          ACTION oItem:Copy(.t.)
                    MENUITEM "Copiar"                          ACTION oItem:Copy()
                    MENUITEM "Pegar"                           ACTION oItem:Paste(oItem)
                    MENUITEM "Borrar"                          ACTION ::Borrar( oItem )

                    if oPapelera != nil .and. oItem:oParent:nID == oPapelera:nID
                       MENUITEM "Restaurar"                    ACTION ::Restaurar( oItem )
                    endif

                    SEPARATOR
                    MENUITEM "Propiedades"                     ACTION ::VerPropiedades( oItem )

                    if oItem:cTipo == "prg" .or. oItem:cTipo == "c"
                       SEPARATOR
                       MENUITEM "Activar como principal"       ACTION ::SetPrgMain( oItem )
                    endif
               ENDMENU
           endif
         endif
      endif
   endif

   if lActivate
      ACTIVATE MENU oMenu OF ::oTree AT nRow, nCol
   endif


return nil

**************************************************************************************************
   METHOD AddExistFileToFolder( oItem ) CLASS TProyecto
**************************************************************************************************
local cGetFile
local aGetFiles
local cFiltro
local nImage, n, nEn
local cPrompt, cRuta, cTipo

if !oItem:lFolder
   return nil
endif

do case
   case oItem:cTipo == "prg"
        nImage := 3
        cFiltro := "Código (*.prg) | *.prg; |"

   case oItem:cTipo == "ch"
        nImage := 1
        cFiltro := "Cabecera (*.ch *.h) | *.ch;*.h; |"

   case oItem:cTipo == "c"
        nImage := 9
        cFiltro := "C (*.c *.cpp) | *.c;*.cpp; |"

   case oItem:cTipo == "rc"
        nImage := 3
        cFiltro := "Recursos (*.rc *.res *.dll ) | *.rc;*.res;*.dll; |"

   case oItem:cTipo == "img"
        nImage := 0
        cFiltro := "Imágenes (*.bmp *.gif *.jpg *.ico *.cur ) | *.bmp;*.gif;*.jpg;*.ico;*.cur; |"

   case oItem:cTipo == "lib"
        nImage := 11
        cFiltro := "Librerias (*.lib ) | *.lib; |"

   otherwise
        nImage := 3
        cFiltro := "Código (*.prg) | *.prg; |" + ;
                      "Cabecera (*.ch) | *.ch; |" + ;
                      "C (*.c *.cpp) | *.c;*.cpp; |" +;
                      "H (*.h) | *.h; |" +;
                      "Recursos (*.rc *.res *.dll ) | *.rc;*.res;*.dll; |" +;
                      "Imágenes (*.bmp *.gif *.jpg *.ico *.cur ) | *.bmp;*.gif;*.jpg;*.ico;*.cur; |"

endcase

aGetFiles := cGetFileEx( cFiltro, "Insertar ficheros en el proyecto" )



if len(aGetFiles)>0

   if valtype( aGetFiles ) == "C"
      cGetFile := aGetFiles
      if ::oTree:Find( {|x| lower(alltrim(x:cFileName )) == lower(alltrim(cGetFile)) } ) != nil
         MsgStop( "Ya existe en el proyecto" + CRLF + cGetFile, "Atención" )
         return nil
      endif
      cRuta := cFilePath( cGetFile )
      cRuta := substr( cRuta, 1, len( cRuta )-1)
      TTVItem():New( ::oTree, , lower(cFileName(cGetFile)), ::GetImageType(oItem:cTipo), oItem:GetCheckState(), oItem, , oItem:cTipo, .f., .f., cRuta )

   else
      for n := 1 to len( aGetFiles )
         cGetFile := aGetFiles[n]
         if ::oTree:Find( {|x| alltrim(x:cFileName) == alltrim(cGetFile) } ) != nil
            MsgStop( "Ya existe en el proyecto" + CRLF + cGetFile, "Atención" )
            loop
         endif
         cRuta := cFilePath( cGetFile )
         cRuta := substr( cRuta, 1, len( cRuta )-1)
         TTVItem():New( ::oTree, , lower(cFileName(cGetFile)), ::GetImageType(oItem:cTipo), oItem:GetCheckState(), oItem, , oItem:cTipo, .f., .f., cRuta )
      next
   endif

   oItem:Expand()
endif


return nil

**************************************************************************************************
  METHOD Open( oItem ) CLASS TProyecto
**************************************************************************************************
local cTipo := oItem:cTipo

do case
   case cTipo == "flags"
        ::ModificarNombre( oItem, "Modificar Flags" )
   case cTipo == "prg"

endcase

return nil

**************************************************************************************************
  METHOD NuevaCarpeta( oItem ) CLASS TProyecto
**************************************************************************************************


  local oItem1

  oItem1 :=  TTVItem():New( ::oTree,,"Nueva", CARPETA, .t., oItem,,oItem:cTipo,.t.,.t. )


  oItem:Expand()

return nil


**************************************************************************************************
   METHOD VerPropiedades( oItem ) CLASS TProyecto
**************************************************************************************************
local oDlg
local cRuta := oItem:cRuta
local cName := oItem:cPrompt
local oRuta, oName


if oItem:cTipo == "prj"
   ::Configuracion()
else

   DEFINE DIALOG oDlg NAME "PROPERTIES"

       REDEFINE GET oRuta VAR cRuta ID 101 OF oDlg READONLY
       REDEFINE GET onAME VAR cName ID 102 OF oDlg READONLY

   ACTIVATE DIALOG oDlg CENTERED

endif

return nil

**************************************************************************************************
   METHOD ModificarNombre( oItem, cTitle ) CLASS TProyecto
**************************************************************************************************
local oDlg
local cRuta := oItem:cRuta
local cTipo := oItem:cTipo
local cName := padr(oItem:cPrompt, 400 )
local oRuta, oName
local oHelp, oOk, oCancel

DEFAULT cTitle := "Modificar nombre"

DEFINE DIALOG oDlg NAME "MODIFYNAME"


    REDEFINE GET oRuta VAR cRuta ID 101 OF oDlg READONLY

    REDEFINE GET oName VAR cName ID 102 OF oDlg

    REDEFINE BUTTON oHelp   ID 3 OF oDlg
    REDEFINE BUTTON oOk     ID 1 OF oDlg ACTION if( ::ExisteNombre( cName, oItem ).and. cTipo != "flags", MsgAlert( "Existe nombre: " + alltrim(cName), "Corrija" ),( oItem:SetText( alltrim(cName)+ "    " ), oDlg:End()))
    REDEFINE BUTTON oCancel ID 2 OF oDlg ACTION oDlg:End()

ACTIVATE DIALOG oDlg CENTERED ON INIT ( oName:SetFocus(), oDlg:cTitle := cTitle )

return nil


**************************************************************************************************
  METHOD AddRuta( oItem ) CLASS TProyecto
**************************************************************************************************

local cDir := cGetDir( "Seleccione ruta", if( empty( oItem:cRuta ), "c:\", oItem:cRuta ) )
local lFallo := .f.
local nLen, n

if oItem:cTipo != "paths"

   oItem:cRuta := cDir

else

   if oItem:oParent:cTipo == "paths"
      oItem := oItem:oParent
   endif

   TTVItem():New(  ::oTree, , cDir, ::GetImageType(oItem:cTipo), oItem:GetCheckState(), oItem,, oItem:cTipo, .f., .f., cDir )

endif

return nil

**************************************************************************************************
   METHOD ExisteNombre( cName, oItem ) CLASS TProyecto
**************************************************************************************************

if ::oTree:Find( { |x| lower( alltrim(x:cPrompt)) == lower(alltrim( cName )) .and. oItem:nId != x:nId } ) != nil
   return .t.
endif

return .f.

**************************************************************************************************
   METHOD Borrar( oItem ) CLASS TProyecto
**************************************************************************************************
local oSave
local cTime
local oPapelera := ::oPapelera()
local lDefinitivo

If !MsgYesNo( "¿Esta seguro de borrar este elemento?","Atención" )
   return nil
endif

if len( oItem:aItems ) > 0
   MsgStop( "No puede borrar items que contengan elementos", "Corrija" )
   return nil
endif

lDefinitivo := GetKeyState( VK_SHIFT )


if !lDefinitivo .and. oPapelera:nID != oItem:oParent:nID
   cTime := "-" + time()
   oSave := TTVItem():New( ::oTree,, oItem:cPrompt+cTime , oItem:nImage, oItem:GetCheckState(), oPapelera, oItem:nImage2,,oItem:cTipo,oItem:lFolder, oItem:lChgImage, oItem:cRuta )
   oSave:oLastParent := oItem:oParent

endif

oItem:DeleteItem()
::oTree:Refresh()

if !lDefinitivo
   if len( oPapelera:aItems ) > 0
      oPapelera:SetImage( 8 )
   else
      oPapelera:SetImage(12)
   endif
endif

return nil


**************************************************************************************************
  METHOD Restaurar( oItem ) CLASS TProyecto
**************************************************************************************************
local oSave


oSave := TTVItem():New( ::oTree, , substr(oItem:cPrompt,1,len( oItem:cPrompt)-9) , oItem:nImage, oItem:GetCheckState(), oItem:oLastParent, oItem:nImage2,oItem:cTipo,oItem:lFolder, oItem:lChgImage, oItem:cRuta )

oSave:oLastParent := nil
oItem:DeleteItem()
::oTree:Refresh()

if (len(::oPapelera:aItems ) == 0 )
   ::oPapelera:SetImage(12)
endif


return nil

**************************************************************************************************
  METHOD VaciarPapelera() CLASS TProyecto
**************************************************************************************************
local oItem

do while len( ::oPapelera:aItems ) > 0
   ::oPapelera:aItems[1]:DeleteItem()
enddo
::oPapelera:SetImage( 12 )
::oTree:Refresh()


return nil

**************************************************************************************************
  METHOD ActionTree( oItem ) CLASS TProyecto
**************************************************************************************************
local cTipo := oItem:cTipo
local cFile


do case
   case cTipo == "prg" .or.;
        cTipo == "c"   .or.;
        cTipo == "h"   .or.;
        cTipo == "ch"  .or.;
        cTipo == "txt"
        cFile := oItem:cRuta + if( left( oItem:cRuta, 1 ) == "\","","\" ) + oItem:cPrompt
        OpenCode( cFile )

endcase


return nil


**************************************************************************************************
  METHOD SetPrgMain( oItem ) CLASS TProyecto
**************************************************************************************************
local aItems := ::oTree:aGetItems( {|x| x:cTipo == "prg" } )
local oI
local cFile := oItem:cRuta + if( left( oItem:cRuta, 1 ) == "\","","\" ) + oItem:cPrompt

local cStr := memoread( cFile )

if empty( cStr )
   MsgStop( "No se pudo encontrar " + cFile, "Corrija" )
   return nil
endif

if at( "functionmain(", strtran(lower(cStr)," ","") ) == 0
   if !MsgYesNo( 'No se encontró "function main()" en el fichero ' + CRLF + CRLF + cFile + CRLF + CRLF +"¿Desea continuar con la operación?","Atención")
      MsgStop("Operación cancelada","Atención")
      return nil
   endif
endif


for each oI in aItems
    oI:lMain := .f.
    oI:SetText(alltrim(oI:cPrompt ))
next

oItem:SetText(oItem:cPrompt + space( 4 ))
oItem:lMain := .t.

::oTree:Refresh()

return nil


**************************************************************************************************
   METHOD Compilar( oItem ) CLASS TProyecto
**************************************************************************************************

? "compilar" + oItem:cFileName


return nil

**************************************************************************************************
   METHOD SaveConfig( oItem, cFileName ) CLASS TProyecto
**************************************************************************************************

if cFileName == nil
   if file( oItem:cRuta + "\" + oItem:cPrompt + ".cfg" )
      cFileName := oItem:cRuta + "\" + oItem:cPrompt + ".cfg"
   endif
endif

DEFAULT cFileName := cGetFile( "*.cfg","Guardar configuración como...", 1, , .t. )

if cFileExt( cFileName ) == ""
   cFileName += ".cfg"
endif

::oTree:SaveFile( cFileName )

return nil

**************************************************************************************************
   METHOD LoadConfig( cFileName ) CLASS TProyecto
**************************************************************************************************


DEFAULT cFileName := cGetFile( "*.cfg","Cargar configuración", 1, , .t. )

if cFileExt( cFileName ) == ""
   cFileName += ".cfg"
endif

if file( cFileName )
   //::oConfig:DeleteBranches()
   //::oConfig := ::oTree:Load( MemoRead( cFileName ),oItem)
endif


return nil

**************************************************************************************************
   METHOD Zoom( oItem ) CLASS TProyecto
**************************************************************************************************

local oWnd
local oTree
local oBar
local oImageList := TImageList():New(16,16,"toolbar\image1.bmp")
local oFont
local o



DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -14

DEFINE WINDOW oWnd FROM 10, 10 TO 400, 400 PIXEL TITLE oItem:cPrompt MDICHILD OF Aplicacion():oWnd

       DEFINE BUTTONBAR oBar OF oWnd 3D SIZE 25, 25

              DEFINE BUTTON OF oBar NAME "plus"   NOBORDER   TOOLTIP "Expandir"    ACTION oTree:ExpandAll()
              DEFINE BUTTON OF oBar NAME "minus"  NOBORDER   TOOLTIP "Contraer"    ACTION oTree:ColapseAll()
              DEFINE BUTTON OF oBar NAME "props"   NOBORDER  TOOLTIP "Propiedades"


       oTree := TTreeView():New( 1, 1, oWnd, 0, CLR_WHITE,.t., .f., 1000, 1000 )
       oTree:SetFont( oFont )
       oTree:SetImageList( oImageList )
       o := TTVItem():New( oTree,, "Zoom", 5, .t., oTree,,"zoom",.t. )

       oItem:Copy()
       o:Paste( o )

       oWnd:oClient := oTree
       o:Expand()

ACTIVATE WINDOW oWnd ON INIT WndCenter( oWnd:hWnd )



return nil

***************************************************************************
   METHOD SetAsMainPrj( oItemRef )  CLASS TProyecto
***************************************************************************

::oTree:aevalitems( ::oTree:aItems, {|oItem| oItem:lMain := oItem:nID == oItemRef:nID })
::oTree:Refresh()

return nil




