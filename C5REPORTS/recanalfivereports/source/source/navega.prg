#include "fivewin.ch"


static oCombo, oActivex


function Navega( cURL )

   local oWnd,  oBar
   local aItems := {}
   local cItem

   if empty( cURL )
      cItem := space( 500 )
   else
      cItem := cURl
      aadd( aItems, cUrl )
   endif

   DEFAULT cURL := "http://www.canalfive.com/foro"



   DEFINE WINDOW oWnd TITLE "WebBrowser" MDICHILD OF Aplicacion():oWnd

      DEFINE BUTTONBAR oBar OF oWnd 3D SIZE 30,32

         DEFINE BUTTON OF oBar NAME "left"    ACTION oActivex:Do( "GoBack"  )  NOBORDER
         DEFINE BUTTON OF oBar NAME "right"   ACTION oActivex:Do( "GoForward"  )  NOBORDER
         DEFINE BUTTON OF oBar NAME "stop"    ACTION oActivex:Do( "Stop"    )  NOBORDER
         DEFINE BUTTON OF oBar NAME "refresh" ACTION oActivex:Do( "Refresh" )  NOBORDER
         DEFINE BUTTON OF oBar NAME "home"    ACTION oActivex:Do( "GoHome"  )  NOBORDER

         @ 5, 200 COMBOBOX oCombo VAR cItem ITEMS aItems SIZE 300, 400 PIXEL OF oBar STYLE CBS_DROPDOWN FONT oWnd:oFont;
                 ON CHANGE GoWeb()

                 oCombo:oGet:bChange := {|nKey, nFlags, Self | GoEdit( nKey, nFlags, Self ) }



         @ 4, 520 BTNBMP OF oBar PIXEL NAME "ir" ACTION GoWeb( ) NOBORDER

   oActiveX = TActiveX():New( oWnd, "Shell.Explorer" )

   oWnd:oClient = oActiveX // To fill the entire window surface

   //oActiveX:Do( "GoHome" )
   oActiveX:Do( "Navigate", cURl )

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil


static function GoWeb()

local cUrl := oCombo:VarGet()
local nEn
local ret

if empty( cUrl ) .or. len( cUrl ) < 8
   return nil
endif
nEn := oCombo:FindString( cUrl )
if nEn == 0
   oCombo:Add( cUrl )
   ret := oActiveX:Do( "Navigate", cUrl )
endif


return ret

static function GoEdit( nKey, nFlags, Self )

if nKey != nil .and. nKey == VK_RETURN

   GoWeb()

endif

return .t.

