#include "fivewin.ch"
#include "wnddsgn.ch"


CLASS TDsgnScroll FROM TShape

      DATA aProperties

      DATA lFlat
      DATA lActive
      DATA lVertical

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lVertical ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )


ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lVertical ) CLASS TDsgnScroll
************************************************************************************************

if lVertical == nil; lVertical := .t.; endif

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      if lVertical
         nBottom := nTop + 65
         nRight  := nLeft + 18
      else
         nBottom := nTop + 18
         nRight  := nLeft + 60
      endif
   endif

  ::cObjName         := ::GetObjName()


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lVertical     := lVertical
   ::lFlat         := .f.
   ::lActive       := .t.

   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lVertical"      ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lFlat"          ,;
                      "lVisible"       ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnScroll
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}

if .f.
   return ::PaintContour( hDC )
endif

if ::lVertical
   ::PaintVScroll( hDC, .t., .f., .f., .T. )
else
   ::PaintHScroll( hDC, .t. ,.f., .f., .T. )
endif

if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil






***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnScroll
***************************************************************************************************
local oMenu
local o := self

    MenuAddItem("Flat"         ,,o:lFlat         ,,{|oMenuItem|::lFlat          := !::lFlat         ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive        := !::lActive       ,::Refresh()},,,,,,,.F.,,,.F. )

   SEPARATOR


return nil


