#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"


CLASS TDsgnPrgBar FROM TShape

      DATA aProperties


      DATA lFlat
      DATA lActive
      DATA nClrText
      DATA nClrPane
      DATA nClrBarra
      DATA lClientEdge
      DATA lStaticEdge
      DATA lPorcentaje
      DATA lVertical
      DATA lBorder
      DATA nMax, nMin, nVal
      DATA lSmooth

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD GenPrg( lDialog, cFrom, cHeader )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnPrgBar
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 23
      nRight  := nLeft + 120
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )

   ::lFlat         := .f.
   ::nClrText      := CLR_WHITE
   ::nClrBorder    := 0
   ::cCaption      := "ProgressBar"
   ::nClrPane      := GetSysColor( COLOR_BTNFACE )
   ::nClrBarra     := CLR_BLUE
   ::lActive       := .t.
   ::lStaticEdge   := .t.
   ::lPorcentaje   := .t.
   ::lBorder       := .t.
   ::nMinHeight    := 1
   ::nMinWidth     := 1
   ::nMax          := 10
   ::nMin          := 0
   ::nVal          := 7
   ::lSmooth       := .f.
   ::lVertical     := .f.
  ::cObjName         := ::GetObjName()

   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "cCaption"       ,;
                      "lActive"        ,;
                      "lBorder"        ,;
                      "lCanSize"       ,;
                      "lCanMove"       ,;
                      "lClientEdge"    ,;
                      "lSmooth"        ,;
                      "lStaticEdge"    ,;
                      "lPorcentaje"    ,;
                      "lVertical"      ,;
                      "lVisible"       ,;
                      "nClrBarra"      ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nMax"           ,;
                      "nMin"           ,;
                      "nVal"           ,;
                      "xMaxHeight"     ,;
                      "xMaxWidth"      ,;
                      "xMinHeight"     ,;
                      "xMinWidth"      }

  if oCbxComponentes() != nil
     oCbxComponentes():Add( ::cObjName )
  endif

return self



*************************************************************************************************
  METHOD Paint( hDC ) CLASS TDsgnPrgBar
*************************************************************************************************
local rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local rc2 := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
local nHW
local nWidth, nLeft, nTop, nRight, nBottom, nProp
local hTheme

if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

   hTheme := C5_OpenThemeData(::oWnd:hWnd, "PROGRESS")

   if hTheme != nil


      nProp := ::nVal / ( ::nMax - ::nMin )
      if ::lVertical
         C5_DrawThemeBackground( hTheme, hDC, PP_BARVERT, , rc )
         rc[1]+=3;rc[2]+=3;rc[3]-=3;rc[4]-=3
         rc[3] := rc2[1] + ((rc2[3]-rc2[1])*(1-nProp))
         C5_DrawThemeBackground( hTheme, hDC, PP_CHUNKVERT, , rc )
      else
         C5_DrawThemeBackground( hTheme, hDC, PP_BAR, , rc )
         rc[1]+=3;rc[2]+=3;rc[3]-=3;rc[4]-=3
         rc[4] := rc2[2] + ((rc2[4]-rc2[2])*(1-nProp))
         C5_DrawThemeBackground( hTheme, hDC, PP_CHUNK, , rc )
      endif

      C5_CloseThemeData()

   endif

else

    FillSolidRect( hDC, rc, ::nClrPane );

    if ::lStaticEdge
            DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
    endif

    if ::lBorder
       rc2[1]++;rc2[2]++;rc2[3]-=2;rc2[4]-=2
            Box( hDC, rc2, 0 )
    endif

    nHW := if( ::lVertical,::nWidth, ::nHeight )

    nHW := int( nHW * 0.6 )

    nWidth := 0
    nLeft  := rc2[2]
    nTop   := rc2[1]+ rc2[3]-rc2[1]
    nRight := rc2[2]
    nBottom := rc2[3]

    nProp := ::nVal / ( ::nMax - ::nMin )

    do while .t.

            if ::lSmooth

                    if ::lVertical

                            nTop    := rc2[1] + (rc2[3]-rc2[1])-( (rc2[3]-rc2[1]) * nProp )
                            nLeft   := rc2[2] + 4
                            nBottom := rc2[3] - if(::lSmooth,0,2)
                            nRight  := rc2[4] - 4

                    else
                            nTop    := rc2[1] + 2
                            nLeft   := rc2[2] + if(::lSmooth,0,2)
                            nRight  := rc2[2] +((rc2[4]-rc2[2])*nProp)
                            nBottom := rc2[1] +(rc2[3]-rc2[1])-1
     endif
            else
                    if ::lVertical
                            nLeft   := rc2[2] + 2
                            nBottom := nTop - if(::lSmooth,0,2)
                            nRight  := rc2[4] - 2
                            nTop    := nBottom - nHW
                            if nTop <  rc2[1] + ((rc2[3]-rc2[1])*(1-nProp))
           exit
                            endif
                    else
                            nLeft   := nRight + if(::lSmooth,0,2)
                            nTop    := rc2[1] +2
                            nRight  := nLeft + nHW
                            nBottom := rc2[1] +(rc2[3]-rc2[1])-1
                            if nRight > rc2[2] + ((rc2[4]-rc2[2])* nProp)
                                exit
                            endif
     endif
            endif

            FillSolidRect(hDC, {nTop,nLeft,nBottom,nRight}, ::nClrBarra )

            if ::lSmooth
                    exit
       endif

    enddo

endif


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif

return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnPrgBar
***************************************************************************************************
local oMenu
local o := self

   MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder        := !::lBorder       ,::Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("lStaticEdge"  ,,o:lStaticEdge   ,,{|oMenuItem|::lStaticEdge    := !::lStaticEdge   ,::Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("lVertical"    ,,o:lVertical     ,,{|oMenuItem|::lVertical      := !::lVertical     ,::Refresh()},,,,,,,.F.,,,.F. )
   MenuAddItem("lSmooth"      ,,o:lSmooth       ,,{|oMenuItem|::lSmooth        := !::lSmooth       ,::Refresh()},,,,,,,.F.,,,.F. )
   SEPARATOR


return nil


***************************************************************************************************
  METHOD GenPrg( lDialog, cFrom, cHeader, cFunciones ) CLASS TDsgnPrgBar
***************************************************************************************************
local cRet := ""
local cObject
local nNum
local cVar

cObject := ::cObjName
cVar    := "n" + substr( cObject, 2 )

DEFAULT lDialog := .t.
DEFAULT cFrom := "oWnd"
DEFAULT cHeader := ""
DEFAULT cFunciones := ""

 cHeader += "local " + cObject + CRLF
 cHeader += "local " + cVar    + " := 0" + CRLF

 cRet += "        @ " + ::cStrTop(lDialog) + ", " + ::cStrLeft(lDialog) + " METER " + cObject + " VAR " + cVar + " ;" + CRLF +;
         "                 TOTAL " + alltrim(str( ::nMax )) + " ; " + CRLF +;
         "                 SIZE " + ::cStrWidth(lDialog) + ", " + ::cStrHeight(lDialog) + " PIXEL ; " + CRLF +;
         "                 PROMPT " + '"' + alltrim(::cCaption) + '"  ;' + CRLF +;
         "                 BARCOLOR " + alltrim(str(::nClrBarra )) + ", " + alltrim(str(::nClrText)) + "; " + CRLF +;
         "                 OF " + cFrom
 if !::lPorcentaje
    cRet += "; " + CRLF
    cRet += "                 NOPERCENTAGE "
 endif
 cRet += CRLF

return cRet
