// Quick and easy browse

#include "FiveWin.ch"
#include "Report.ch"
#include "InKey.ch"

#define ENGLISH

//----------------------------------------------------------------------------//

function Browse( cTitle, cListName, bNew, bModify, bDelete, bSearch, bList,;
                 aColSizes )

   local oDlg, oLbx, oFont
   local btnNew, btnModify, btnDelete, btnSearch, btnList, btnEnd
   local n, cText

   DEFAULT cTitle  := "Browse", cListName := "Fields",;
           bNew    := { || oLbx:RecAdd(), oLbx:Refresh() },;
           bDelete := { || RecDelete( oLbx ) },;
           bModify := { || RecModify( oLbx ) },;
           bList   := { || Report( oLbx ) }

   DEFINE DIALOG oDlg FROM 3, 3 TO 26, 79 TITLE cTitle FONT oFont

   @ 0.1, 1.4 SAY cListName  OF oDlg

   @ 1, 1 LISTBOX oLbx FIELDS ;
      SIZE 284, 137  OF oDlg

   oLbx:bLDblClick = { | nRow, nCol | btnList:Click() }
   oLbx:bKeyDown   = { | nKey, nFlags | KeyDown( oLbx, nKey, nFlags ) }
   oLbx:bKeyChar   = { | nKey, nFlags | KeyChar( oLbx, nKey, nFlags ) }
   oLbx:aActions   = Array( ( Alias() )->( FCount() ) )

   if aColSizes != nil
      oLbx:aColSizes = aColSizes
   endif

   for n = 1 to Len( oLbx:aActions )
      oLbx:aActions[ n ] = { || MsgInfo( "Column action" ) }
   next

#ifdef ENGLISH

   @ 8.7,  1.4 BUTTON btnNew    PROMPT "&New"    OF oDlg SIZE 40, 12
   @ 8.7,  9.5 BUTTON btnModify PROMPT "&Modify" OF oDlg SIZE 40, 12
   @ 8.7, 17.6 BUTTON btnDelete PROMPT "&Delete" OF oDlg SIZE 40, 12
   @ 8.7, 25.7 BUTTON btnSearch PROMPT "&Search" OF oDlg SIZE 40, 12
   @ 8.7, 33.8 BUTTON btnList   PROMPT "S&elect"  OF oDlg SIZE 40, 12
   @ 8.7, 41.9 BUTTON btnEnd    PROMPT "E&xit"   OF oDlg SIZE 40, 12

#else

   @ 8.7,  1.4 BUTTON btnNew    PROMPT "&Nuevo"    OF oDlg SIZE 40, 12
   @ 8.7,  9.5 BUTTON btnModify PROMPT "&Modifica" OF oDlg SIZE 40, 12
   @ 8.7, 17.6 BUTTON btnDelete PROMPT "&Elimina"  OF oDlg SIZE 40, 12
   @ 8.7, 25.7 BUTTON btnSearch PROMPT "&Buscar"   OF oDlg SIZE 40, 12
   @ 8.7, 33.8 BUTTON btnList   PROMPT "S&eleccionar" OF oDlg SIZE 40, 12
   @ 8.7, 41.9 BUTTON btnEnd    PROMPT "&Salir"    OF oDlg SIZE 40, 12

#endif

   btnNew:bAction    = { || Eval( bNew, oDlg ),;
                         oLbx:GoBottom(), oLbx:SetFocus() }

   btnModify:bAction = If( bModify != nil,;
                           { || Eval( bModify, oDlg ),;
                           oLbx:Refresh(), oLbx:SetFocus() },)

   btnDelete:bAction = If( bDelete != nil,;
                           { || Eval( bDelete, oDlg ),;
                           oLbx:Refresh(), oLbx:SetFocus() },)

   btnSearch:bAction = If( bSearch != nil,;
                           { || Eval( bSearch, oDlg ),;
                           oLbx:Refresh(), oLbx:SetFocus() },)

   btnList:bAction   = { || cText := ( Alias() )->Codigo, oDlg:End() }

   btnEnd:bAction    = { || oDlg:End() }

   ACTIVATE DIALOG oDlg

return cText

//----------------------------------------------------------------------------//

function Report( oLbx )

   local oRpt
   local n
   local cAlias := If( oLbx != nil, oLbx:cAlias, Alias() )

   REPORT oRpt TITLE "Report: " + cAlias ;
      HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
      FOOTER "Page: " + Str( oRpt:nPage, 3 ) ;
      PREVIEW

      if Empty( oRpt ) .or. oRpt:oDevice:hDC == 0
         return nil
      endif

      for n = 1 to FCount()
         oRpt:AddColumn( TrColumn():New( { FInfo1( cAlias, n ) },,;
                     { FInfo2( cAlias, n ) },,,,,,,,,, oRpt ) )
      next

   ENDREPORT

   ACTIVATE REPORT oRpt

   GO TOP

return nil

//----------------------------------------------------------------------------//

static function FInfo1( cAlias, n )
return { || ( cAlias )->( FieldName( n ) ) }

static function FInfo2( cAlias, n )
return { || ( cAlias )->( FieldGet( n ) ) }

//----------------------------------------------------------------------------//

static function RecModify( oLbx )

   local n := 1
   local nCols := ( oLbx:cAlias )->( FCount() )
   local u := ( oLbx:cAlias )->( FieldGet( 1 ) )

   while n <= nCols .and. oLbx:lEditCol( n, @u )
      oLbx:DrawSelect()
      SysRefresh()
      if ( oLbx:cAlias )->( RLock() )
         ( oLbx:cAlias )->( FieldPut( n, u ) )
         UNLOCK
      else
         MsgAlert( "DataBase non available" )
         n = nCols + 1
      endif
      n++
      if n <= nCols
         u = ( oLbx:cAlias )->( FieldGet( n ) )
      endif
   end

return nil

//----------------------------------------------------------------------------//

static function EditCell( oLbx, nRow, nCol )

   local nColumn := oLbx:nAtCol( nCol )
   local u := ( oLbx:cAlias )->( FieldGet( nColumn ) )

   if ValType( ( oLbx:cAlias )->( FieldGet( nColumn ) ) ) == "M"
      if MemoEdit( @u )
         if ( oLbx:cAlias )->( RLock() )
            ( oLbx:cAlias )->( FieldPut( nColumn, u ) )
            UNLOCK
            oLbx:DrawSelect()
         else
            MsgAlert( "DataBase non available" )
         endif
      endif
   else
      if oLbx:lEditCol( nColumn, @u )
         if ( oLbx:cAlias )->( RLock() )
            ( oLbx:cAlias )->( FieldPut( nColumn, u ) )
            UNLOCK
            oLbx:DrawSelect()
         else
            MsgAlert( "DataBase non available" )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function KeyDown( oLbx, nKey, nFlags )

   do case
      case nKey == VK_DELETE
           RecDelete( oLbx )
   endcase

return nil

//----------------------------------------------------------------------------//

static function KeyChar( oLbx, nKey, nFlags )

   do case
      case nKey == K_ENTER
           RecModify( oLbx )
   endcase

return nil

//----------------------------------------------------------------------------//

static function RecDelete( oLbx )

   if MsgYesNo( "Delete this record ?", "Please, confirm" )
      DELETE
      PACK
      oLbx:Refresh()
   endif

return nil

//----------------------------------------------------------------------------//
