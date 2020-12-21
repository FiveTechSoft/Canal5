#include "fivewin.ch"
#include "wnddsgn.ch"
#include "spthemes.ch"



CLASS TDsgnSlider FROM TShape

      DATA lActive
      DATA lTicks
      DATA lVertical
      DATA nAlign
      DATA nBtn
      DATA nClrBar
      DATA nMax
      DATA nMin
      DATA nTicks
      DATA nTipo
      DATA nVal

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD ContextMenu( nRow, nCol )
      METHOD PaintClassicArrow( hDC, nLeft, nTop, blanco, gris0, gris1, gris2 )

ENDCLASS

************************************************************************************************
      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TDsgnSlider
************************************************************************************************

   if nTop != nil .and. (nBottom-nTop < 10 .or. nRight-nLeft < 10)
      nBottom := nTop + 24
      nRight  := nLeft + 150
   endif


   super:New( nTop, nLeft, nBottom, nRight, oWnd )
  ::cObjName         := ::GetObjName()

   ::lActive      := .t.
   ::lBorder      := .f.
   ::lTicks       := .t.
   ::lVertical    := .f.
   ::nAlign       := nOr(DT_SINGLELINE,DT_VCENTER,DT_CENTER)
   ::nBtn         := 0
   ::nClrBar      := RGB(0,0,140)
   ::nClrBorder   := 0
   ::nClrPane     := GetSysColor( COLOR_BTNFACE)
   //::nClrPane     := RGB( 220,220,220 )
   ::nMax         := 10
   ::nMin         := 0
   ::nTicks       := 11
   ::nTipo        := BOTON
   ::nVal         := 7

   ::cCaption     := "botón"
   ::bContextMenu := {|nRow,nCol| ::ContextMenu( nRow, nCol ) }


   ::aProperties := { "aDotsActives"   ,;
                      "aRect"          ,;
                      "lActive"        ,;
                      "lCanSize" ,;
                      "lCanMove"       ,;
                      "lTicks"         ,;
                      "lVertical"      ,;
                      "lVertical"      ,;
                      "lVisible"       ,;
                      "nAlign"         ,;
                      "nBtn"           ,;
                      "nClrBar"        ,;
                      "nClrPane"       ,;
                      "nClrText"       ,;
                      "nMax"           ,;
                      "nMin"           ,;
                      "nTicks"         ,;
                      "nTipo"          ,;
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
  METHOD Paint( hDC ) CLASS TDsgnSlider
*************************************************************************************************
    local rc    := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }
    local rc2   := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }
    local blanco := CreatePen( PS_SOLID, 1, RGB( 255, 255, 255 ))
    local gris0  := CreatePen( PS_SOLID, 1, RGB( 241, 239, 226 ))
    local gris1  := CreatePen( PS_SOLID, 1, RGB( 157, 157, 161 ))
    local gris2  := CreatePen( PS_SOLID, 1, RGB( 113, 111, 110 ))
    local rcText
    local hOldPen
    local i
    local nTick0, nTick1
    local nLine
    local nBtn
    local nHW
    local nLeft, nTop
    local hTheme
    local hPenTick := nil
    local nProp

    if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()

       hTheme := C5_OpenThemeData(::oWnd:hWnd, "TRACKBAR")


       if hTheme != nil

          nProp := ::nVal / ( ::nMax - ::nMin )

          if ::lVertical
             C5_DrawThemeBackground( hTheme, hDC, TKP_TICSVERT,TSVS_NORMAL , rc )

             rc    := { ::aRect[1]+9, ::aRect[2]+20, ::aRect[3]-9, ::aRect[2]+24 }
             if ::nBtn == 2
                rc[2] :=  ::nLeft + 11
                rc[4] :=  ::nLeft + 15
             endif
             C5_DrawThemeBackground( hTheme, hDC, TKP_TRACKVERT, TRVS_NORMAL, rc )

             rc    := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }
             rc[1] := rc[1] + ((rc[3]-rc[1])*(1-nProp))
             rc[3] := rc[1] + 11
             rc[2] := rc[2] + 11
             rc[4] := rc[2] + 22
             do case
                case ::nBtn == 0
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMBVERT, TUVS_NORMAL, rc )
                case ::nBtn == 1
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMBLEFT, TUVLS_NORMAL, rc )
                case ::nBtn == 2
                     rc[2] := ::nLeft + 3
                     rc[4] := ::nLeft + 25
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMBRIGHT, TUVRS_NORMAL, rc )
             endcase

          else
             C5_DrawThemeBackground( hTheme, hDC, TKP_TICS,TSS_NORMAL , rc )

             rc    := { ::aRect[1]+20, ::aRect[2]+9, ::aRect[1]+24, ::aRect[4]-9 }
             if ::nBtn == 2
                rc[1] :=  ::nTop  + 11
                rc[3] :=  ::nTop  + 15
             endif
             C5_DrawThemeBackground( hTheme, hDC, TKP_TRACK, TRS_NORMAL, rc )

             rc    := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }
             rc[2] := rc[2] + ((rc[4]-rc[2])*(1-nProp))
             rc[4] := rc[2] + 11
             rc[1] := rc[1] + 11
             rc[3] := rc[1] + 22
             do case
                case ::nBtn == 0
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMB, TUS_NORMAL, rc )
                case ::nBtn == 1
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMBTOP, TUTS_NORMAL, rc )
                case ::nBtn == 2
                     rc[1] := ::nTop  + 3
                     rc[3] := ::nTop  + 25
                     C5_DrawThemeBackground( hTheme, hDC, TKP_THUMBBOTTOM, TUBS_NORMAL, rc )
             endcase

          endif

          SelectObject( hDC, hOldPen )
          DeleteObject( hPenTick )

          C5_CloseThemeData()
          rc    := { ::aRect[1], ::aRect[2], ::aRect[3], ::aRect[4] }

       endif

    else


        if ::lBorder
           FillSolidRect(hDC, rc, GetSysColor(COLOR_BTNFACE), 0 )
        else
           FillSolidRect(hDC, rc, GetSysColor(COLOR_BTNFACE) )
        endif

        rcText := {rc[1],rc[2],rc[3],rc[4]}

        if ::lModalFrame
           rc := {::aRect[1],::aRect[2],::aRect[3],::aRect[4]}
           DrawEdge( hDC, rc, BDR_SUNKENOUTER, BF_RECT )
           rc[1]++; rc[2]++; rc[3]--; rc[4]--
           DrawEdge( hDC, rc, BDR_SUNKENINNER, BF_RECT )
           rc[1]--; rc[2]--; rc[3]++; rc[4]++
        endif

    endif

    if ::lTicks

       do case
          case ::nBtn == 1

               nTick0 :=  7
               nLine  := 21
               nBtn   := 11

          case ::nBtn == 0

               nTick0 :=  7
               nTick1 := 34
               nLine  := 20
               nBtn   := 11

          case ::nBtn == 2

               nTick1 := 26
               nLine  := 11
               nBtn   :=  3
       endcase

    else

       do case
          case ::nBtn == 1
               nLine := 13
               nBtn  := 3

          case ::nBtn == 0
               nLine := 12
               nBtn  :=  3

          case ::nBtn == 2
               nLine := 11
               nBtn  := 3
       endcase
    endif

    if ::lVertical

       nHW = (rc[3]-rc[1]-18-9)/(::nTicks-1)
       rc2[1] += 9
       rc2[3] := rc[3] - 9
       rc2[2] += nLine
       rc2[4] := rc2[2]+4
    else
       nHW := (rc[4]-rc[2]-18-9)/(::nTicks-1)
       rc2[1] += nLine
       rc2[3] := rc2[1] + 4
       rc2[2] += 9
       rc2[4] := rc[4]-9
    endif

    if lTemas() .and. !::oWnd:lPocketPc()  .and. C5_IsAppThemed() .and. C5_IsThemeActive()
       color := GetThemeColor (hTheme, TKP_TICS, TSS_NORMAL)
       hPenTick := CreatePen( PS_SOLID, 1, color )
       hOldPen := SelectObject( hDC, hPenTick )
    else

        DrawEdge( hdc, rc2, BDR_SUNKENOUTER, BF_RECT )
        rc2[1]++; rc2[2]++; rc2[3]--; rc2[4]--
        DrawEdge( hdc, rc2, BDR_SUNKENINNER, BF_RECT )

        hOldPen := SelectObject( hDC, gris1 )
        if ::lVertical
           ::PaintClassicArrow( hDC, rc[2]+nBtn, rc[1]+9, blanco, gris0, gris1, gris2 )
        else
           ::PaintClassicArrow( hDC, rc[2]+9, rc[1]+nBtn, blanco, gris0, gris1, gris2 )
        endif
    endif

    for i := 0 to ::nTicks -1

        if ::lVertical

           nTop := ::nTop + 14 + ( nHW * (i-1) ) + nHW

           if ::lTicks .and. ( ::nBtn == 0 .or. ::nBtn == 1 )
              MoveTo( hDC, ::nLeft + nTick0, nTop )
              LineTo( hDC, ::nLeft + nTick0+ 4, nTop )
           endif

           if ::lTicks .and. ( ::nBtn == 0 .or. ::nBtn == 2 )
              MoveTo( hDC, ::nLeft + nTick1, nTop )
              LineTo( hDC, ::nLeft + nTick1+ 4, nTop  )
           endif
        else
           nLeft := ::nLeft + 14 +( nHW * (i-1) ) + nHW

           if ::lTicks .and. ( ::nBtn == 0 .or. ::nBtn == 1 )
              MoveTo( hDC, nLeft, ::nTop + nTick0 )
              LineTo( hDC, nLeft, ::nTop + nTick0 + 4 )
           endif

           if ::lTicks .and. (::nBtn == 0 .or. ::nBtn == 2 )
              MoveTo( hDC, nLeft, ::nTop + nTick1 )
              LineTo( hDC, nLeft, ::nTop + nTick1 + 4 )
           endif
        endif

    next



    SelectObject( hDC, hOldPen )
    DeleteObject( blanco )
    DeleteObject( gris0  )
    DeleteObject( gris1  )
    DeleteObject( gris2  )
    if hPenTick <> nil
       DeleteObject( hPenTick )
    endif


if ::oWnd:oSelected != nil .and. (::oWnd:oSelected:nItemId == ::nItemId .or. ::lSelected)
   ::DotsSelect( hDC )
endif
return nil


***************************************************************************************************
      METHOD ContextMenu( nRow, nCol ) CLASS TDsgnSlider
***************************************************************************************************
local oMenu
local o := self


    MenuAddItem("lBorder"      ,,o:lBorder       ,,{|oMenuItem|::lBorder     := !::lBorder     ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lActive"      ,,o:lActive       ,,{|oMenuItem|::lActive     := !::lActive     ,::Refresh()},,,,,,,.F.,,,.F. )
    MenuAddItem("lVertical"    ,,o:lVertical     ,,{|oMenuItem|::lVertical   := !::lVertical   ,::Refresh()},,,,,,,.F.,,,.F. )
    MENUITEM "Flecha"
    MENU
       MenuAddItem("Both"      ,,o:nBtn == 0     ,,{|oMenuItem|::nBtn    := 0   ,::Refresh()},,,,,,,.F.,,,.F. )
       MenuAddItem("Up"        ,,o:nBtn == 1     ,,{|oMenuItem|::nBtn    := 1   ,::Refresh()},,,,,,,.F.,,,.F. )
       MenuAddItem("Down"      ,,o:nBtn == 2     ,,{|oMenuItem|::nBtn    := 2   ,::Refresh()},,,,,,,.F.,,,.F. )
    ENDMENU


   SEPARATOR



return nil


***************************************************************************************************
   METHOD PaintClassicArrow( dc, nLeft, nTop, blanco, gris0, gris1, gris2 ) CLASS TDsgnSlider
***************************************************************************************************

  local rc
  local hOldPen

  // boton vertical

  if !::lVertical

     rc := {nTop, nLeft, nTop + 21, nLeft + 10 }
     FillSolidRect( dc, rc, GetSysColor( COLOR_BTNFACE ) )

     do case
        case ::nBtn == 0  // Both

             hOldPen := SelectObject( dc, blanco )
             MoveTo( dc, nLeft, nTop + 20 )
             LineTo( dc, nLeft, nTop )
             LineTo( dc, nLeft + 11, nTop )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc,  gris0 )
             MoveTo( dc, nLeft+ 1, nTop + 19 )
             LineTo( dc, nLeft+ 1, nTop +  1 )
             LineTo( dc, nLeft+ 10, nTop +  1 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris1 )
             MoveTo( dc, nLeft+ 1, nTop + 20 )
             LineTo( dc, nLeft+ 9, nTop + 20 )
             LineTo( dc, nLeft+ 9, nTop +  1 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris2 )
             MoveTo( dc, nLeft, nTop + 21 )
             LineTo( dc, nLeft + 10, nTop + 21 )
             LineTo( dc, nLeft + 10, nTop )
             SelectObject( dc, hOldPen )

        case ::nBtn == 1 // top

             hOldPen := SelectObject( dc, blanco )
             MoveTo( dc, nLeft+4, nTop +  1 )
             LineTo( dc, nLeft  , nTop +  5 )
             LineTo( dc, nLeft  , nTop + 21 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris0 )
             MoveTo( dc, nLeft+ 4, nTop +   2 )
             LineTo( dc, nLeft+ 1, nTop +   5 )
             LineTo( dc, nLeft+ 1, nTop + 20 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris1 )
             MoveTo( dc, nLeft+ 1, nTop + 20 )
             LineTo( dc, nLeft+ 9, nTop + 20 )
             LineTo( dc, nLeft+ 9, nTop +  5 )
             LineTo( dc, nLeft+ 4, nTop      )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris2 )
             MoveTo( dc, nLeft, nTop + 21 )
             LineTo( dc, nLeft + 10, nTop + 21 )
             LineTo( dc, nLeft + 10, nTop +  5 )
             LineTo( dc, nLeft +  4, nTop -1   )
             SelectObject( dc, hOldPen )

        case ::nBtn == 2 // down

             hOldPen := SelectObject( dc, blanco )
             MoveTo( dc, nLeft +  9, nTop )
             LineTo( dc, nLeft, nTop )
             LineTo( dc, nLeft, nTop + 16 )
             LineTo( dc, nLeft+5, nTop + 21 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc, gris0 )
             MoveTo( dc, nLeft+ 8, nTop +  1 )
             LineTo( dc, nLeft+ 1, nTop +  1 )
             LineTo( dc, nLeft+ 1, nTop + 16 )
             LineTo( dc, nLeft+ 5, nTop + 20 )
             SelectObject( dc, hOldPen );

             hOldPen := SelectObject( dc, gris1 )
             MoveTo( dc, nLeft+ 9, nTop +  1 )
             LineTo( dc, nLeft+ 9, nTop + 16 )
             LineTo( dc, nLeft+ 4, nTop + 21 )
             SelectObject( dc, hOldPen )

             hOldPen := SelectObject( dc,  gris2 )
             MoveTo( dc,  nLeft + 10, nTop )
             LineTo( dc,  nLeft + 10, nTop + 16 )
             LineTo( dc,  nLeft +  4, nTop + 22 )
             SelectObject( dc,  hOldPen )

     endcase

  else

     rc := { nTop, nLeft , nTop + 10, nLeft + 21 }
     FillSolidRect( dc, rc, GetSysColor( COLOR_BTNFACE ) )
     do case
        case ::nBtn == 0 // Both

             hOldPen := SelectObject( dc,  blanco )
             MoveTo( dc,  nLeft + 20, nTop )
             LineTo( dc,  nLeft, nTop )
             LineTo( dc,  nLeft, nTop + 11 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris0 )
             MoveTo( dc,  nLeft+ 19, nTop +  1 )
             LineTo( dc,  nLeft+ 1, nTop +  1 )
             LineTo( dc,  nLeft+ 1, nTop + 10 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris1 )
             MoveTo( dc,  nLeft+ 1, nTop + 9 )
             LineTo( dc,  nLeft+ 20, nTop + 9 )
             LineTo( dc,  nLeft+ 20, nTop  )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris2 )
             MoveTo( dc,  nLeft, nTop + 10 )
             LineTo( dc,  nLeft + 21, nTop + 10 )
             LineTo( dc,  nLeft + 21, nTop - 1 )
             SelectObject( dc,  hOldPen )

        case ::nBtn == 1 // top

             hOldPen := SelectObject( dc,  blanco )
             MoveTo( dc,  nLeft+ 1, nTop +  4 )
             LineTo( dc,  nLeft+ 5, nTop  )
             LineTo( dc,  nLeft+21, nTop )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris0 )
             MoveTo( dc,  nLeft+  2, nTop + 4 )
             LineTo( dc,  nLeft+  5, nTop + 1 )
             LineTo( dc,  nLeft+ 20, nTop + 1 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris1 )
             MoveTo( dc,  nLeft+  1, nTop + 5 )
             LineTo( dc,  nLeft+  5, nTop + 9 )
             LineTo( dc,  nLeft+ 20, nTop + 9 )
             LineTo( dc,  nLeft+ 20, nTop     )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris2 )
             MoveTo( dc,  nLeft     , nTop +  5 )
             LineTo( dc,  nLeft +  5, nTop + 10 )
             LineTo( dc,  nLeft + 21, nTop + 10 )
             LineTo( dc,  nLeft + 21, nTop -  1 )
             SelectObject( dc,  hOldPen )

        case ::nBtn == 2 // down

             hOldPen := SelectObject( dc,  blanco )
             MoveTo( dc,  nLeft   , nTop + 10 )
             LineTo( dc,  nLeft   , nTop      )
             LineTo( dc,  nLeft+16, nTop      )
             LineTo( dc,  nLeft+21, nTop +  5 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris0 )
             MoveTo( dc,  nLeft+ 1, nTop +  9 )
             LineTo( dc,  nLeft+ 1, nTop +  1 )
             LineTo( dc,  nLeft+17, nTop +  1 )
             MoveTo( dc,  nLeft+17, nTop      )
             LineTo( dc,  nLeft+22, nTop +  5 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris1 )
             MoveTo( dc,  nLeft+ 1, nTop +  9 )
             LineTo( dc,  nLeft+16, nTop +  9 )
             LineTo( dc,  nLeft+21, nTop +  4 )
             SelectObject( dc,  hOldPen )

             hOldPen := SelectObject( dc,  gris2 )
             MoveTo( dc,  nLeft     , nTop + 10 )
             LineTo( dc,  nLeft + 16, nTop + 10 )
             LineTo( dc,  nLeft + 22, nTop +  4 )
             SelectObject( dc,  hOldPen )
     endcase
  endif

return nil







