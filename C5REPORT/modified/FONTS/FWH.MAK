##############################################################################
# Template make file for FWH and Borland Make tool                           #
# Copyright FiveTech 2002                                                    #
# Written by Ignacio Ortiz de Zuñiga                                         #
##############################################################################


# Make directives ############################################################

.autodepend
.swap
.suffixes: .prg .hrb

# Flags for modules to include: YES | NO (must be UPPERCASE)##################

RES_FILE      = YES
LNK_DBFNTX    = YES
LNK_DBFCDX    = YES
LNK_DEBUG     = NO
LNK_ADVANTAGE = NO
LNK_ODBC      = NO
MAP_FILE      = NO

# Application directories & filenames ########################################

APP_NAME         = c5report  # (Your EXE name without extension)
APP_PRG_DIR      = .
APP_OBJ_DIR      = obj  # (create the app\obj directory first)
APP_INCLUDE_DIR  = .
APP_EXE_DIR      = .
APP_RES_DIR      = res
APP_CPP_DIR      = .

APP_EXE  = $(APP_EXE_DIR)\$(APP_NAME).exe
APP_RC   = $(APP_RES_DIR)\$(APP_NAME).rc
APP_RES  = $(APP_RES_DIR)\$(APP_NAME).res
APP_MAP  = $(APP_RES_DIR)\$(APP_NAME).map

# Paths for dependent files ##################################################

.path.c   = $(APP_CPP_DIR)
.path.prg = $(APP_PRG_DIR)
.path.hrb = $(APP_OBJ_DIR)
.path.obj = $(APP_OBJ_DIR)

# Application PRG files (your PRG files go here) #############################

APP_PRG_LIST =     \
    prueba.prg     \
    bmpitem.prg    \
    c5report.prg   \
    c5stbar.prg    \
    c5printer.prg  \
    itemdetail.prg \
    itemfield.prg  \
    itemelip.prg   \
    itemline.prg   \
    itemrect.prg   \
    itemtext.prg   \
    itemelip.prg   \
    propery.prg   \
    rptitem.prg    \
    rule.prg       \
    listprop.prg   \
    itemfield.prg  \
    lbxfont.prg    \
    lbxcolor.prg   \
    functions.prg

APP_CPP_LIST = \
   ces.c

# Contruction of the rest dependency lists ###################################

APP_PRGS = $(APP_PRG_LIST)
APP_HRBS = $(APP_PRG_LIST:.prg=.hrb)
APP_OBJS = $(APP_PRG_LIST:.prg=.obj) $(APP_CPP_LIST:.c=.obj)

# C5

C5_DIR         = \canal5
C5_LIB_DIR     = $(C5_DIR)\libreria

# Fivewin directories ########################################################

FIVEWIN_INCLUDE_DIR = \fwh\include
FIVEWIN_LIB_DIR     = \fwh\lib

# Fivewin libraries ##########################################################

FIVE_LIB  = $(FIVEWIN_LIB_DIR)\fiveHx.lib
FIVEC_LIB = $(FIVEWIN_LIB_DIR)\fiveHC.lib

# Harbour directories & flags ################################################

HARBOUR_INCLUDE_DIR = \xharbour\include
HARBOUR_EXE_DIR     = \xharbour\bin
HARBOUR_LIB_DIR     = \xharbour\lib
HARBOUR_FLAGS       = -i$(APP_INCLUDE_DIR);$(FIVEWIN_INCLUDE_DIR);$(HARBOUR_INCLUDE_DIR) -n -m -w -es2 -gc0 -p
HARBOUR_EXE         = $(HARBOUR_EXE_DIR)\harbour.exe

# Harbour libraries ##########################################################

RTL_LIB    = $(HARBOUR_LIB_DIR)\rtl.lib
VM_LIB     = $(HARBOUR_LIB_DIR)\vm.lib
GTWIN_LIB  = $(HARBOUR_LIB_DIR)\gtgui.lib
LANG_LIB   = $(HARBOUR_LIB_DIR)\lang.lib
MACRO_LIB  = $(HARBOUR_LIB_DIR)\macro.lib
RDD_LIB    = $(HARBOUR_LIB_DIR)\rdd.lib
DBFNTX_LIB = $(HARBOUR_LIB_DIR)\dbfntx.lib
DBFSIX_LIB = $(HARBOUR_LIB_DIR)\hbsix.lib
DBFDBT_LIB = $(HARBOUR_LIB_DIR)\dbfdbt.lib
DBFFPT_LIB = $(HARBOUR_LIB_DIR)\dbffpt.lib
DBFCDX_LIB = $(HARBOUR_LIB_DIR)\dbfcdx.lib
DEBUG_LIB  = $(HARBOUR_LIB_DIR)\debug.lib
COMMON_LIB = $(HARBOUR_LIB_DIR)\common.lib
PP_LIB     = $(HARBOUR_LIB_DIR)\pp.lib





#FCLASS_LIB = $(HARBOUR_LIB_DIR)\fclass.lib


# Advantage libraries ########################################################

RDDADS_LIB = $(HARBOUR_LIB_DIR)\rddads.lib
ACE32_LIB  = $(FIVEWIN_LIB_DIR)\ace32.lib

#ACE32_LIB =  $(HARBOUR_LIB_DIR)\ace32.lib

# Borlanc directories & flags ################################################

BORLANDC_INCLUDE_DIR = \BCC55\include
BORLANDC_EXE_DIR     = \BCC55\bin
BORLANDC_LIB_DIR     = \BCC55\lib
BORLANDC_COMP_FLAGS  = -c -O2 -I$(HARBOUR_INCLUDE_DIR) -I$(BORLANDC_INCLUDE_DIR)
BORLANDC_COMP_EXE    = $(BORLANDC_EXE_DIR)\bcc32.exe
BORLANDC_LINK_FLAGS  = -Gn -aa -Tpe -s -I$(APP_OBJ_DIR) -L$(BORLANDC_LIB_DIR)
BORLANDC_LINK_EXE    = $(BORLANDC_EXE_DIR)\ilink32.exe
BORLANDC_RES_EXE     = $(BORLANDC_EXE_DIR)\brc32.exe

!if $(MAP_FILE) != YES
   BORLANDC_LINK_FLAGS = $(BORLANDC_LINK_FLAGS) -x
!endif

# Borland libraries & files ##################################################

STARTUP_OBJ  = $(BORLANDC_LIB_DIR)\c0w32.obj
CW32_LIB     = $(BORLANDC_LIB_DIR)\cw32.lib
IMPORT32_LIB = $(BORLANDC_LIB_DIR)\import32.lib
ODBC32_LIB   = $(BORLANDC_LIB_DIR)\psdk\odbc32.lib

# Dependencies ###############################################################

all: $(APP_OBJS) $(APP_HRBS) $(APP_EXE)

!if $(RES_FILE) == YES
all: $(APP_RES)
!endif

# Implicit Rules #############################################################

.c.obj:
   $(BORLANDC_COMP_EXE) $(BORLANDC_COMP_FLAGS) -D__HARBOUR__;HB_API_MACROS -o$@ $**

.prg.hrb:
   $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@

.hrb.obj:
   $(BORLANDC_COMP_EXE) $(BORLANDC_COMP_FLAGS) -o$@ $**

# Explicit Rules #############################################################

!if $(RES_FILE) == YES
$(APP_RES) : $(APP_RC)
   $(BORLANDC_RES_EXE) -r $**

$(APP_EXE) :: $(APP_RES)
   @if exist $(APP_EXE) del $(APP_EXE) > nul
!endif

$(APP_EXE) :: $(APP_OBJS)
   @echo $(STARTUP_OBJ) + > make.tmp
   @echo $(**), + >> make.tmp
   @echo $(APP_EXE), + >> make.tmp
   @echo $(APP_MAP), + >> make.tmp

   @echo $(C5_LIB_DIR)\Xlib\xc5h.lib + >> make.tmp

   @echo $(FIVE_LIB) + >> make.tmp
   @echo $(FIVEC_LIB) + >> make.tmp

   @echo $(RTL_LIB) + >> make.tmp
   @echo $(VM_LIB) + >> make.tmp
   @echo $(GTWIN_LIB) + >> make.tmp
   @echo $(LANG_LIB) + >> make.tmp
   @echo $(MACRO_LIB) + >> make.tmp
   @echo $(RDD_LIB) + >> make.tmp
!if $(LNK_DBFNTX) == YES
   @echo $(DBFNTX_LIB) + >> make.tmp
#   @echo $(DBFDBT_LIB) + >> make.tmp
!endif
!if $(LNK_DBFCDX) == YES
   @echo $(DBFCDX_LIB) + >> make.tmp
   @echo $(DBFSIX_LIB) + >> make.tmp
   @echo $(DBFFPT_LIB) + >> make.tmp
!endif
!if $(LNK_DEBUG) == YES
   @echo $(DEBUG_LIB) + >> make.tmp
!endif
   @echo $(COMMON_LIB) + >> make.tmp
   @echo $(PP_LIB) + >> make.tmp
!if $(LNK_ADVANTAGE) == YES
   @echo $(RDDADS_LIB) + >> make.tmp
   @echo $(ACE32_LIB) + >> make.tmp
!endif
!if $(LNK_ODBC) == YES
   @echo $(ODBC32_LIB) + >> make.tmp
!endif
   @echo $(CW32_LIB) + >> make.tmp
   @echo $(BORLANDC_LIB_DIR)\psdk\rasapi32.lib + >> make.tmp
   @echo $(BORLANDC_LIB_DIR)\psdk\nddeapi.lib + >> make.tmp
   @echo $(BORLANDC_LIB_DIR)\psdk\iphlpapi.lib + >> make.tmp
   @echo $(BORLANDC_LIB_DIR)\psdk\msimg32.lib + >> make.tmp
   @echo $(IMPORT32_LIB), + >> make.tmp
!if $(RES_FILE) == YES
   @echo ,$(APP_RES) >> make.tmp
!endif
   $(BORLANDC_LINK_EXE) $(BORLANDC_LINK_FLAGS) @make.tmp
   @del $(APP_EXE_DIR)\$(APP_NAME).tds
   @del make.tmp
