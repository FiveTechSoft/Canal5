#Include "FiveWin.ch"

STATIC oWnd

Function Main()

   LOCAL oBar

   DEFINE WINDOW oWnd MDI

      DEFINE BUTTONBAR oBar SIZE 23, 24 _3D OF oWnd
      DEFINE BUTTON  OF oBar       NOBORDER NAME '16EndApp'  ACTION t()

   ACTIVATE WINDOW oWnd

Retu Nil

static function t()

*    LOCAL oPanel := TPanelEx():New( 0, 0, 100, 230, oWnd, rgb(173,197,229) )
*    oList := TListProp():New( 205, 1, 228, 300, , {"","",""},{20, 100, 100}, oPanel, , , ,,,, oFont )
    LOCAL oList, oFont
    LOCAL cGroup, nGroup

    DEFINE FONT oFont NAME "Verdana" SIZE 0,-11

msginfo(1)

    oList := TListProp():New( 205, 1, 228, 300, , {"","",""},{20, 100, 100}, oWnd, , , ,,,, oFont )

    oList:nLineStyle := 2

msginfo(2)

     oList:Reset()
     cGroup := "Información"
     nGroup := oList:AddGroup( cGroup )
     oList:AddItem( "", "Tipo", 'TOTI',,nGroup,,.F. )
     oList:AddItem( "nID",          "ID",    999,,nGroup )

*         oList:AddItem( oProp:cProperty, oProp:cText, oSend(Self,oProp:cProperty) , oProp:cType , nGroup ,,, oProp:bProperty )
         oList:AddItem( 'Prop 1', 'Propietat 1', 'Send' , 'Tipus', nGroup ,,, {|| msginfo('a')} )

     oList:GoTop()
     oList:Refresh()



retu nil


