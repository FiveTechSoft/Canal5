#include "fivewin.ch"

function NewProj()
local oPrj
local oDlg
local oHB,oBCC, oFindHB, oFindBCC, oFindPrgs, oFindIncs, oFindLibs
local cHB  := padr("c:\prg\harbour",300)
local cBCC := padr("c:\prg\bcc55",300)
local oPrgs, oIncludes, oLibs
local cPrgs, cIncludes, cLibs
local lOk := .f.
local cOutDir := space( 300 )
local oK, oC
local oOutDir


oPrj := TProyecto2():New()
oPrj:cOutName := "prueba"
oPrj:Load()

cOutDir   := oPrj:cPrgDir
cPrgs     := oPrj:cPrgs()
cIncludes := oPrj:cIncludes()
cLibs     := oPrj:cLibs()

DEFINE DIALOG oDlg NAME "CONFIGDIR"

   REDEFINE GET oHb VAR cHB ID 101 OF oDlg
   REDEFINE BUTTON oFindHB ID 102 OF oDlg ACTION SelDir( oHb, cHB )

   REDEFINE GET oBCC VAR cBcc ID 103 OF oDlg
   REDEFINE BUTTON oFindBCC ID 104 OF oDlg ACTION SelDir( oBCC, cBCC )

   REDEFINE GET oOutDir VAR cOutDir ID 113 OF oDlg
   REDEFINE BUTTON oFindBCC ID 114 OF oDlg ACTION SelDir( oOutDir, cOutDIr )


   REDEFINE GET oPrgs      VAR cPrgs     ID 105 OF oDlg MULTILINE
   REDEFINE BUTTON oFindPrgs             ID 110 OF oDlg ACTION AddFile( oPrgs, "*.prg" )
   REDEFINE GET oIncludes  VAR cIncludes ID 106 OF oDlg MULTILINE
   REDEFINE BUTTON oFindIncs             ID 111 OF oDlg ACTION AddDir( oIncludes )
   REDEFINE GET oLibs      VAR cLibs     ID 107 OF oDlg MULTILINE
   REDEFINE BUTTON oFindLibs             ID 112 OF oDlg ACTION AddFile( oLibs, "lib" )

   REDEFINE BUTTON oK ID 108 OF oDlg ACTION (lOk := .t., oDlg:End())
   REDEFINE BUTTON oC ID 109 OF oDlg ACTION (lOk := .f., oDlg:End())

ACTIVATE DIALOG oDlg CENTERED

if !lOk
   return nil
endif

oPrj:cPrgToA( cPrgs )
oPrj:cIncToA( cIncludes )
oPrj:cLibToA( cLibs )
/*
oPrj:cPrgDir := cFilePath( oPrj:aGetFiles("prg")[1] )
oPrj:cPrgDir := lower(substr(oPrj:cPrgDir, 1, len( oPrj:cPrgDir )-1))
*/
oPrj:cPrgDir := cOutDir


oPrj:GenMake()
oPrj:Save()


return nil

static function AddFile( oGet, cMask )
local cPrg := cGetFile( cMask, "Selecciona fichero")
oGet:Append( lower(LFN2SFN(cPrg)) )
oGet:Refresh()

return nil

function AddDir( oGet )
local cNewDir := cGetDir( "Seleccione directorio" )
oGet:Append( cNewDir )
oGet:Refresh()

return nil


function SelDir( oGet, cDir )
local cNewDir

? cDir
? "eo"
cNewDir := cGetDir( "Seleccione directorio", alltrim(cDir)  )

if !empty( cNewDir )
   oGet:cText := cNewDir
   oGet:Refresh()
endif

return nil






CLASS TProyecto2

    DATA aFiles
    DATA cDir                 INIT ""
    DATA cDriver              INIT "DBFCDX"

    DATA cBCDir               INIT "c:\prg\bcc55"
    DATA cHbDir               INIT "c:\prg\harbour"

    DATA cObjDir              INIT ""
    DATA cOutDir              INIT ""
    DATA cOutExt              INIT ""
    DATA cOutName             INIT ""
    DATA cPrgDir              INIT ""
    DATA cResFile             INIT ""

    DATA cType

    DATA aLibs                INIT {}
    DATA aIncs                INIT {}
    DATA lxResFile AS LOGICAL INIT .f.
    DATA lxMapFile AS LOGICAL INIT .f.


    DATA cHbFlags             INIT "-n -m -w -es2 -gc0"
    DATA cCCmpFlags           INIT "-c -O2"
    DATA cCLnkFlags           INIT "-Gn -aa -Tpe -s "  //


    METHOD New( cFileName ) CONSTRUCTOR
    METHOD Open( cFileName ) CONSTRUCTOR
    METHOD Load( cFileName )
    METHOD LoadDef()
    METHOD Save()
    METHOD SaveAs( cFileName )

    METHOD AddFile( cFileName )
    METHOD DelFile( cFileName )
    METHOD DelTypes( cExt )
    METHOD RenFile( cFileName, cNewFile )
    METHOD Reset()

    METHOD aGetFiles( cExt )
    METHOD cGetPaths( aInfo )
    METHOD GenMake()
    METHOD lResFile( lValue ) INLINE if( empty( ::cResFile ), .f., .t. )
    METHOD lMapFile( lValue ) SETGET

    METHOD cPrgs()
    METHOD cIncludes()
    METHOD cLibs()

    METHOD cPrgToA( cPrgs )
    METHOD cIncToA( cIncs )
    METHOD cLibToA( cLibs )



ENDCLASS

************************************************************************************************
  METHOD New( cType ) CLASS TProyecto2
************************************************************************************************

  DEFAULT cType := "EXE"

  ::aFiles    := {}
  ::cType     := cType

return self

************************************************************************************************
  METHOD Open( cFileName ) CLASS TProyecto2
************************************************************************************************

  ::cFileName  := cFileName

  ::Load( cFileName )

return self

************************************************************************************************
  METHOD Load( cFileName ) CLASS TProyecto2
************************************************************************************************
local oIni
local nLen
local n
local cVal := space(255)
local cFile := ::cOutName+".prj"
? cFile

if !file( cFile )
   ::LoadDef()
   return nil
endif

INI oIni FILE ".\" + cFile
    GET ::cHBDir       SECTION "DIRS"   ENTRY "HBDIR"   OF oIni DEFAULT ""
    GET ::cBcDir       SECTION "DIRS"   ENTRY "BCCDIR"  OF oIni DEFAULT ""
    GET ::cPrgDir      SECTION "DIRS"   ENTRY "OUTDIR"  OF oIni DEFAULT ""

    GET nLen           SECTION "PRGS"   ENTRY "LENGTH"  OF oIni DEFAULT 0
    for n=1 to nLen
      GET cVal SECTION "PRGS" ENTRY "FILE" + alltrim(str( n ) ) OF oIni DEFAULT ""
      ::AddFile( cVal )
    next n

    GET nLen SECTION "INCLUDES"   ENTRY "LENGTH"  OF oIni       DEFAULT 0
    for n=1 to nLen
      GET cVal SECTION "INCLUDES" ENTRY "DIR" + alltrim(str( n ) ) OF oIni DEFAULT ""
      aadd( ::aIncs, cVal )
    next n

    GET nLen SECTION "LIBS"   ENTRY "LENGTH"  OF oIni           DEFAULT 0
    for n=1 to nLen
      GET cVal SECTION "LIBS" ENTRY "LIB" + alltrim( str( n ) ) OF oIni DEFAULT ""
      aadd( ::aLibs, cVal )
    next n
ENDINI


return nil

************************************************************************************************
  METHOD Save() CLASS TProyecto2
************************************************************************************************
local oIni
local n
local aPrgs := ::aGetFiles( "prg" )

// salvar el proyecto
// Dar valor a ::cDir

INI oIni FILE ".\"+::cOutName+".prj"
    SET SECTION "DIRS"   ENTRY "HBDIR"   OF oIni TO ::cHBDir
    SET SECTION "DIRS"   ENTRY "BCCDIR"  OF oIni TO ::cBcDir
    SET SECTION "DIRS"   ENTRY "OUTDIR"  OF oIni TO alltrim(::cPrgDir)
    SET SECTION "PRGS"   ENTRY "LENGTH"  OF oIni TO len( aPrgs )
    for n=1 to Len(aPrgs)
      SET SECTION "PRGS" ENTRY "FILE" + alltrim(str( n ) ) OF oIni TO aPrgs[n]
    next n
    SET SECTION "INCLUDES"   ENTRY "LENGTH"  OF oIni TO len( ::aIncs )
    for n=1 to Len(::aIncs)
      SET SECTION "INCLUDES" ENTRY "DIR" + alltrim(str( n ) ) OF oIni TO ::aIncs[n]
    next n
    SET SECTION "LIBS"   ENTRY "LENGTH"  OF oIni TO len( ::aLibs )
    for n=1 to Len(::aLibs)
      SET SECTION "LIBS" ENTRY "LIB" + alltrim( str( n ) ) OF oIni TO ::aLibs[n]
    next n
ENDINI

return nil


************************************************************************************************
  METHOD SaveAs( cFileName ) CLASS TProyecto2
************************************************************************************************

::cFileName := cFileName

// salvar el proyecto
::Save()


return nil


************************************************************************************************
  METHOD DelFile( cFileName ) CLASS TProyecto2
************************************************************************************************
local n, nLen

nLen := len( ::aFiles )

for n := 1 to nLen
    if ::aFiles[n]:cFileName == cFileName
       adel ( ::aFiles, n )
       asize( ::aFiles, nLen-1 )
       exit
    endif
next

return nil

************************************************************************************************
  METHOD DelTypes( cExt ) CLASS TProyecto2
************************************************************************************************
local n, nLen

nLen := len( ::aFiles )

for n := 1 to nLen
    if lower(cFileExt(::aFiles[n]:cFileName)) == lower(cExt)
       adel ( ::aFiles, n )
       asize( ::aFiles, nLen-1 )
       exit
    endif
next

return nil



************************************************************************************************
  METHOD AddFile( cFileName ) CLASS TProyecto2
************************************************************************************************
local n, nLen
local lFind := .f.
nLen := len( ::aFiles )

for n := 1 to nLen
    if ::aFiles[n]:cFileName == cFileName
       lFind := .t.
       exit
    endif
next


if !lFind
   aadd( ::aFiles, TItemPrj():New( self, cFileName ) )
else
   MsgAlert( "Atención","Ya existe el fichero: " + cFileName )
endif

return lFind

************************************************************************************************
  METHOD RenFile( cFileName, cNewFile ) CLASS TProyecto2
************************************************************************************************
local n, nLen
nLen := len( ::aFiles )

for n := 1 to nLen
    if ::aFiles[n]:cFileName == cFileName
       ::aFiles[n]:cFileName := cNewFile
       exit
    endif
next

return nil



************************************************************************************************
  METHOD aGetFiles( cExt ) CLASS TProyecto2
************************************************************************************************

local n, nLen
local aItems := {}
nLen := len( ::aFiles )

for n := 1 to nLen
    if cFileExt(upper(::aFiles[n]:cFileName)) == upper( cExt )
       aadd( aItems, ::aFiles[n]:cFileName )
    endif
next

return aItems

************************************************************************************************
  METHOD cGetPaths( aInfo ) CLASS TProyecto2
************************************************************************************************

local n, nLen
local aItems := {}
local cItems := ""
local cPath
nLen := len( aInfo )

for n := 1 to nLen
    cPath := cFilePath( aInfo[n] )
    cPath := substr( cPath, 1, len( cPath )-1 )
    if ascan( aItems, cPath ) == 0
       aadd( aItems, cPath )
       cItems += lower(cPath) + ";"
    endif
next

return substr( cItems, 1, len( cItems ) - 1 )


************************************************************************************************
  METHOD Reset() CLASS TProyecto2
************************************************************************************************
::cFileName := ""
::aFiles    := {}
::cDir      := ""
return nil

************************************************************************************************
  METHOD lMapFile( lValue ) CLASS TProyecto2
************************************************************************************************
if pcount() > 0
   ::lxMapFile := lValue
endif

return ::lxMapFile

************************************************************************************************
  METHOD LoadDef( ) CLASS TProyecto2
************************************************************************************************


  ::aIncs     := {"c:\prg\bcc55\include","c:\prg\harbour\include","c:\prg\fwh24b\include"}
  ::cOutDir   := ""
  ::cPrgDir   := ""
  ::cObjDir   := "."
  ::cOutName  := ""
  ::cResFile  := ""
  ::aLibs     := {"c:\prg\fwh24b\lib\fiveH.lib"    ,;
                  "c:\prg\fwh24b\lib\fiveHC.lib"   ,;
                  "c:\prg\harbour\lib\rtl.lib"     ,;
                  "c:\prg\harbour\lib\vm.lib"      ,;
                  "c:\prg\harbour\lib\gtwin.lib"   ,;
                  "c:\prg\harbour\lib\lang.lib"    ,;
                  "c:\prg\harbour\lib\macro.lib"   ,;
                  "c:\prg\harbour\lib\rdd.lib"     ,;
                  "c:\prg\harbour\lib\dbfntx.lib"  ,;
                  "c:\prg\harbour\lib\dbfcdx.lib"  ,;
                  "c:\prg\harbour\lib\common.lib"  ,;
                  "c:\prg\harbour\lib\pp.lib"      ,;
                  "c:\prg\bcc55\lib\cw32.lib"      ,;
                  "c:\prg\bcc55\lib\import32.lib"}


return nil

************************************************************************************************
    METHOD cPrgs() CLASS TProyecto2
************************************************************************************************
local cPrgs := ""
local aPrgs := ::aGetFiles( "prg" )
local n, nLen

nLen := len( aPrgs )

for n := 1 to nLen
    cPrgs += lower(aPrgs[n]) + CRLF
next

return cPrgs

************************************************************************************************
    METHOD cIncludes() CLASS TProyecto2
************************************************************************************************
local cIncludes := ""

local n, nLen

nLen := len( ::aIncs )

for n := 1 to nLen
    cIncludes += lower(::aIncs[n]) + CRLF
next

return cIncludes
************************************************************************************************
    METHOD cLibs() CLASS TProyecto2
************************************************************************************************
local cLibs := ""

local n, nLen

nLen := len( ::aLibs )

for n := 1 to nLen
    cLibs += lower(::aLibs[n]) + CRLF
next

return cLibs


************************************************************************************************
    METHOD cPrgToA( cPrgs ) CLASS TProyecto2
************************************************************************************************
local n, nLines


::DelTypes( "prg" )
nLines := mlcount(cPrgs)
if nLines == 0
   return nil
endif

for n := 1 to nLines
    ::AddFile( lower(rtrim(memoline( cPrgs,,n))) )
next

return nil

************************************************************************************************
    METHOD cIncToA( cIncs ) CLASS TProyecto2
************************************************************************************************
local n, nLines

nLines := mlcount(cIncs)
if nLines == 0
   return nil
endif
asize(::aIncs, 0 )

for n := 1 to nLines
    aadd( ::aIncs, lower(rtrim(memoline( cIncs,,n))) )
next

return nil
************************************************************************************************
    METHOD cLibToA( cLibs ) CLASS TProyecto2
************************************************************************************************
local n, nLines


nLines := mlcount(cLibs)
if nLines == 0
   return nil
endif
asize(::aLibs, 0 )

for n := 1 to nLines
    aadd( ::aLibs, lower(rtrim(memoline( cLibs,,n))) )
next

return nil

************************************************************************************************
  METHOD GenMake() CLASS TProyecto2
************************************************************************************************
local cStr   := ""
local aPrgs  := ::aGetFiles( "prg" )
local aLibs  := ::aLibs
local h
local n, nLen

cStr += "# Make directives ############################################################" + CRLF

cStr += ".autodepend"                                                                    + CRLF
cStr += ".swap"                                                                          + CRLF
cStr += ".suffixes: .prg .hrb"                                                           + CRLF + CRLF

cStr += "# Flags for modules to include: YES | NO (must be UPPERCASE)##################" + CRLF + CRLF

cStr += "RES_FILE      = " + if( ::lResFile(),"YES","NO")                                + CRLF
cStr += "LNK_DBFNTX    = " + if( ::cDriver == "DBFNTX","YES","NO")                       + CRLF
cStr += "LNK_DBFCDX    = " + if( ::cDriver == "DBFCDX","YES","NO")                       + CRLF
cStr += "LNK_DEBUG     = NO"                                                             + CRLF
cStr += "LNK_ADVANTAGE = " + if( ::cDriver == "ADS","YES","NO")                          + CRLF
cStr += "LNK_ODBC      = " + if( ::cDriver == "ODBC","YES","NO")                         + CRLF
cStr += "MAP_FILE      = " + if( ::lMapFile(),"YES","NO")                                + CRLF



cStr += "# Application directories & filenames ########################################" + CRLF + CRLF

cStr += "APP_NAME         = " + ::cOutName                                               + CRLF
cStr += "APP_PRG_DIR      = " + ::cPrgDir                                                + CRLF
cStr += "APP_OBJ_DIR      = " + ::cObjDir                                                + CRLF
cStr += "APP_EXE_DIR      = $(APP_PRG_DIR)"                                              + CRLF
cStr += "APP_RES_DIR      = $(APP_PRG_DIR)"                                              + CRLF + CRLF

cStr += "APP_EXE  = $(APP_EXE_DIR)\$(APP_NAME).exe"                                      + CRLF
cStr += "APP_RC   = $(APP_RES_DIR)\$(APP_NAME).rc"                                       + CRLF
cStr += "APP_RES  = $(APP_RES_DIR)\$(APP_NAME).res"                                      + CRLF
cStr += "APP_MAP  = $(APP_RES_DIR)\$(APP_NAME).map"                                      + CRLF + CRLF

cStr += "# Paths for dependent files ##################################################" + CRLF

cStr += ".path.prg = " + ::cGetPaths( aPrgs ) + CRLF

cStr += ".path.hrb = $(APP_OBJ_DIR)"                                                     + CRLF
cStr += ".path.obj = $(APP_OBJ_DIR)"                                                     + CRLF + CRLF

cStr += "# Application PRG files (your PRG files go here) #############################" + CRLF + CRLF

cStr += "APP_PRG_LIST = "

nLen := len( aPrgs )
for n := 1 to nLen
    cStr += if(n==1,"",space( 15 )) + lower(cFileNoPath(rtrim(aPrgs[n]))) + if( n < nLen .and. nLen > 1," \",CRLF )                       + CRLF
next

cStr += CRLF + "# Contruction of the rest dependency lists ###################################"   + CRLF + CRLF

cStr += "APP_PRGS = $(APP_PRG_LIST)"                                                       + CRLF
cStr += "APP_HRBS = $(APP_PRG_LIST:.prg=.hrb)"                                             + CRLF
cStr += "APP_OBJS = $(APP_PRG_LIST:.prg=.obj)"                                             + CRLF + CRLF

cStr += "# Harbour directories & flags ################################################"   + CRLF + CRLF

cStr += "HARBOUR_DIR          = " +::cHbDir                                                     + CRLF
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

cStr += " -L" + ::cGetPaths( ::aLibs ) + CRLF

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



CLASS TItemPrj

      DATA oProject
      DATA cFileName

      METHOD New( oProject, cFileName ) CONSTRUCTOR

ENDCLASS

METHOD New( oProject, cFileName ) CLASS TItemPrj

    ::oProject   := oProject
    ::cFileName  := cFileName



return self

