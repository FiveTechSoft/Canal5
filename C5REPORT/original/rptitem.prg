#include "fivewin.ch"
#include "c5report.ch"


CLASS TC5RptItem

      CLASSDATA nInitID INIT 100

      DATA aBmp           AS ARRAY INIT {0,0,0,0}
      DATA aCoords        AS ARRAY INIT {0,0,0,0}
      DATA aEnablePoints
      DATA aOldPos        AS ARRAY INIT {0,0,0,0}
      DATA aPoints        AS ARRAY INIT {}
      DATA aProperties    AS ARRAY INIT {}
      DATA aText          AS ARRAY INIT {0,0,0,0}
      DATA aEvents        AS ARRAY INIT {}
      DATA bAction
      DATA cAction        AS CHARACTER INIT ""
      DATA cBmp
      DATA cCaption
      DATA cDbf           AS CHARACTER INIT ""
      DATA cFaceName
      DATA cProperty1
      DATA cProperty2
      DATA cProperty3
      DATA cProperty4
      DATA cType
      DATA lBold
      DATA lEnable        AS LOGICAL INIT .T.
      DATA lFromNew       AS LOGICAL INIT .T.
      DATA lInvertido     AS LOGICAL INIT .F.
      DATA lItalic
      DATA lMain          AS LOGICAL INIT .F.
      DATA lMoviendo      AS LOGICAL INIT .F.
      DATA lRoundRect     AS LOGICAL INIT .T.
      DATA lSelected      AS LOGICAL INIT .F.
      DATA lShowLines     AS LOGICAL INIT .T.
      DATA lStrike
      DATA lTransparent   AS LOGICAL INIT .F.
      DATA lUnder
      DATA lVertical      AS LOGICAL INIT .F.
      DATA nClrPane       AS NUMERIC INIT CLR_WHITE
      DATA nClrPen        AS NUMERIC INIT 0
      DATA nClrText       AS NUMERIC INIT CLR_BLACK
      DATA nColor
      DATA nColumnas      AS NUMERIC INIT 3
      DATA nFilas         AS NUMERIC INIT 4
      DATA nGiro          AS NUMERIC INIT 0
      DATA nHFont
      DATA nHText         AS NUMERIC INIT 0
      DATA nId
      DATA nPen           AS NUMERIC INIT 1
      DATA nRH            AS NUMERIC INIT 10
      DATA nRW            AS NUMERIC INIT 10
      DATA nType
      DATA nWFont
      DATA oWnd

      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cCaption, cBmp, bAction, cBmpOver, lEnable, nColor, nType ) CONSTRUCTOR
      METHOD AddProp( cProperty, cText, bProperty, cCategory )
      METHOD CreateProps()              VIRTUAL
      METHOD Edit( )
      METHOD EditText( )
      METHOD GetCoords()                INLINE ::aCoords
      METHOD GetID()                    VIRTUAL
      METHOD GetNewId()                 INLINE If( ::nInitId == nil, ::nInitId := 100,),++::nInitId
      METHOD GetType()                  VIRTUAL
      METHOD IsOver( nRow, nCol )
      METHOD IsOverIntern( nRow, nCol ) INLINE .f.
      METHOD IsOverPt( nRow, nCol )
      METHOD Load( cStr, lPaste )       VIRTUAL
      METHOD MoveTo( aPos, lRefresh )
      METHOD MoveX   ( n )              INLINE ::nLeft := ::nLeft + n, ::nRight := ::nRight + n
      METHOD MoveY   ( n )              INLINE ::nTop  := ::nTop + n, ::nBottom := ::nBottom + n
      METHOD OffsetX( nVal )
      METHOD OffsetY( nVal )
      METHOD Paint( hDC )
      METHOD PaintPts( hDC )
      METHOD PropComunes( oItem )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD Refresh()                  INLINE ::oWnd:Refresh()
      METHOD Save()
      METHOD SelInto()                  VIRTUAL
      METHOD SelectFont()
      METHOD SetMultiProperties()
      METHOD SetProperties()
      METHOD SetPropertyMain( uValue )  VIRTUAL
      METHOD aGetPoints ()
      METHOD cItemName  ()              VIRTUAL
      METHOD nBottom    ( nNew )        SETGET
      METHOD nHeight    ( nNew )        SETGET
      METHOD nLeft      ( nNew )        SETGET
      METHOD nMMBottom  ()              INLINE vPix2MM( ::aCoords[3] )
      METHOD nMMHFont   ()              INLINE vPix2MM( ::nHFont )
      METHOD nMMHeight  ()              INLINE vPix2MM( ::aCoords[3]-::aCoords[1] )
      METHOD nMMLeft    ()              INLINE hPix2MM( ::aCoords[2] )
      METHOD nMMRight   ()              INLINE hPix2MM( ::aCoords[4] )
      METHOD nMMTop     ()              INLINE vPix2MM( ::aCoords[1] )
      METHOD nMMWidth   ()              INLINE hPix2MM( ::aCoords[4]-::aCoords[2] )
      METHOD nMedH      ()              INLINE ::nTop  +  ::nHeight/2
      METHOD nMedW      ()              INLINE ::nLeft +  ::nWidth/2
      METHOD nPixHFont  ( nMM )         INLINE vMM2Pix( nMM )
      METHOD nPixHeight ( nMM )         INLINE vMM2Pix( nMM )
      METHOD nPixLeft   ( nMM )         INLINE hMM2Pix( nMM )
      METHOD nPixTop    ( nMM )         INLINE vMM2Pix( nMM )
      METHOD nPixWidth  ( nMM )         INLINE hMM2Pix( nMM )
      METHOD nRealBottom( nNewVal )     SETGET
      METHOD nRealHeight( nNew )        SETGET
      METHOD nRealLeft  ( nNewVal )     SETGET
      METHOD nRealRight ( nNewVal )     SETGET
      METHOD nRealTop   ( nNewVal )     SETGET
      METHOD nRealWidth ( nNew )        SETGET
      METHOD nRight     ( nNew )        SETGET
      METHOD nTop       ( nNew )        SETGET
      METHOD nWidth     ( nNew )        SETGET




ENDCLASS

**************************************************************************************************************************************
      METHOD New( oWnd, nTop, nLeft, nWidth, nHeight, cCaption, cBmp, bAction, cBmpOver, lEnable, nColor, nType ) CLASS TC5RptItem
**************************************************************************************************************************************

   if cCaption  == nil; cCaption  := " "      ; endif
   if cBmp     == nil;  cBmp      := " "      ; endif
   if cBmpOver == nil;  cBmpOver  := " "      ; endif
   if lEnable  == nil;  lEnable   :=       .t.; endif
   if nColor   == nil;  nColor    := CLR_BLACK; endif
   if nType    == nil;  nType     :=         1; endif // bmp + texto

   ::oWnd       := oWnd
   ::aCoords[1] := nTop
   ::aCoords[2] := nLeft
   ::aCoords[3] := (nTop + nHeight)
   ::aCoords[4] := (nLeft + nWidth)
   ::cBmp       := cBmp
   ::lEnable    := lEnable
   ::nID        := ::GetNewID()
   ::nColor     := nColor
   ::nType      := nType
   ::aEnablePoints := {.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}




return self

******************************************************************************************************************
      METHOD Paint( hDC ) CLASS TC5RptItem
******************************************************************************************************************

 local nT := ::nTop      + ::oWnd:nRTop
 local nL := ::nLeft     + ::oWnd:nRLeft
 local nB := ::nBottom   + ::oWnd:nRTop
 local nR := ::nRight    + ::oWnd:nRLeft
 local hPenDotted := CreatePen( PS_SOLID, 1, 0 )//RGB(201,201,201) )
 local hOldPen2

   hOldPen2 := SelectObject( hDC, hPenDotted )
   Moveto( hDC, nL, nT )
   Lineto( hDC, nR, nT )
   Lineto( hDC, nR, nB )
   Lineto( hDC, nL, nB )
   Lineto( hDC, nL, nT )
   SelectObject( hDC, hOldPen2 )

   DeleteObject( hPenDotted )

return nil


******************************************************************************************************************
  METHOD PaintPts( hDC ) CLASS TC5RptItem
******************************************************************************************************************
local nT, nL, nB, nR, nD
local hBrush, hOldBrush
local lMain := ( ::oWnd:oSelected != nil .and. ::oWnd:oSelected:nID == ::nID )

if !::oWnd:lCaptured  .and. ( lMain .or. ::lSelected )

      ::aPoints := ::aGetPoints()

      if lMain .and. ::oWnd:lSelecteds
         hBrush := CreateSolidBrush( CLR_HGRAY )
         hOldBrush := SelectObject( hDC, hBrush )
      endif

      if !empty( ::aPoints )

             nD := ::oWnd:nZoom/100

	      DrawFocusRect(hDC, ::aPoints[1,1]*nD-3,;
	                         ::aPoints[1,2]*nD-3,;
	                         ::aPoints[5,1]*nD+3,;
	                         ::aPoints[5,2]*nD+3 )

             if ::aEnablePoints[1]
                nT := ::aPoints[1,1]; nL := ::aPoints[1,2]
		Ellipse( hDC,  nL*nD-6, nT*nD-6, nL*nD, nT*nD)
             endif

             if ::aEnablePoints[2]
                nT := ::aPoints[2,1]; nL := ::aPoints[2,2]
		Ellipse( hDC,  nL*nD-3, nT*nD-6, nL*nD+3, nT*nD)
             endif

             if ::aEnablePoints[3]
                nT := ::aPoints[3,1]; nL := ::aPoints[3,2]
		Ellipse( hDC,  nL*nD, nT*nD-6, nL*nD+6, nT*nD)
             endif

             if ::aEnablePoints[4]
                nT := ::aPoints[4,1]; nL := ::aPoints[4,2]
		Ellipse( hDC,  nL*nD, nT*nD-3, nL*nD+6, nT*nD+3)
             endif

             if ::aEnablePoints[5]
                nT := ::aPoints[5,1]; nL := ::aPoints[5,2]
		Ellipse( hDC,  nL*nD, nT*nD, nL*nD+6, nT*nD+6)
             endif

             if ::aEnablePoints[6]
                nT := ::aPoints[6,1]; nL := ::aPoints[6,2]
		Ellipse( hDC,  nL*nD-3, nT*nD, nL*nD+3, nT*nD+6)
             endif

             if ::aEnablePoints[7]
                nT := ::aPoints[7,1]; nL := ::aPoints[7,2]
		Ellipse( hDC,  nL*nD-6, nT*nD, nL*nD, nT*nD+6)
             endif

             if ::aEnablePoints[8]
                nT := ::aPoints[8,1]; nL := ::aPoints[8,2]
		Ellipse( hDC,  nL*nD-6, nT*nD-3, nL*nD, nT*nD+3)
             endif

      endif

      if lMain
         SelectObject( hDC, hOldBrush )
         DeleteObject( hBrush )
      endif

else
   ::aPoints := {}
endif

return 0



******************************************************************************************************************
      METHOD IsOverPt( nRow, nCol )  CLASS TC5RptItem
******************************************************************************************************************
local n
local nLen := len(::aPoints )



if !::lEnable
   return 0
endif


for n := 1 to nLen
    if ::aEnablePoints[n] .and. PtInRect( nRow, nCol, {::aPoints[n,1],::aPoints[n,2],::aPoints[n,1]+6,::aPoints[n,2]+6} )
       return n
    endif
next


return 0

******************************************************************************************************************
      METHOD IsOver  ( nRow, nCol )   CLASS TC5RptItem
******************************************************************************************************************
local lRet := .f.
local nTop
local nLeft
local nBottom
local nRight

if !::lEnable
   return .f.
endif

nTop    := (::aCoords[1] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
nLeft   := (::aCoords[2] + ::oWnd:aCoords[2])*::oWnd:nZoom/100
nBottom := (::aCoords[3] + ::oWnd:aCoords[1])*::oWnd:nZoom/100
nRight  := (::aCoords[4] + ::oWnd:aCoords[2])*::oWnd:nZoom/100


do case
   case ::nType == 3 // línea vertical
        lRet := PtInRect( nRow, nCol, {nTop,nLeft-3,nBottom,nRight+3} )
   case ::nType == 4 // línea horizontal
        lRet := PtInRect( nRow, nCol, {nTop-3,nLeft,nBottom+3,nRight} )
   otherwise
      lRet := PtInRect( nRow, nCol, {nTop,nLeft,nBottom,nRight} ) .and.;
              if( !::lTransparent,.t., !PtInRect( nRow, nCol, {nTop+5,nLeft+5,nBottom-5,nRight-5} ))
endcase

//FillSolidRect(::oWnd:GetDC(),{nTop,nLeft,nBottom,nRight}, 0 )
//::oWnd:ReleaseDC()

return lRet

******************************************************************************************************************
      METHOD nTop   ( nNew )  CLASS TC5RptItem
******************************************************************************************************************

   if nNew != nil
      ::aCoords[1] := nNew
   endif

return ::aCoords[1] * ::oWnd:nZoom/100


******************************************************************************************************************
      METHOD nLeft  ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[2] := nNew
   endif

return ::aCoords[2]  * ::oWnd:nZoom/100

******************************************************************************************************************
      METHOD nBottom( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[3] := nNew
   endif

return ::aCoords[3] * ::oWnd:nZoom/100

******************************************************************************************************************
      METHOD nRight ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[4] := nNew
   endif

return ::aCoords[4]  * ::oWnd:nZoom/100


******************************************************************************************************************
      METHOD nWidth ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
if valtype( nNew ) == "C"; nNew := val( nNew ) ; endif

   if nNew != nil
      ::aCoords[4] := ::aCoords[2] + nNew
   endif

return ::nRight-::nLeft

******************************************************************************************************************
      METHOD nHeight ( nNew )   CLASS TC5RptItem
******************************************************************************************************************

if valtype( nNew ) == "C"; nNew := val( nNew ) ; endif

   if nNew != nil
      ::aCoords[3] := ::aCoords[1] + nNew
   endif

return ::nBottom-::nTop

******************************************************************************************************************
      METHOD nRealTop ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
local nH := ::aCoords[3]-::aCoords[1]

   if nNew != nil
      ::aCoords[1] := nNew
      ::aCoords[3] := nNew + nH
   endif

return ::aCoords[1]

******************************************************************************************************************
      METHOD nRealLeft ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
local nW := ::aCoords[4]-::aCoords[2]

   if nNew != nil
      ::aCoords[2] := nNew
      ::aCoords[4] := nNew + nW
   endif

return ::aCoords[2]

******************************************************************************************************************
      METHOD nRealBottom ( nNew )   CLASS TC5RptItem
******************************************************************************************************************

   if nNew != nil
      ::aCoords[3] := nNew
   endif

return ::aCoords[3]

******************************************************************************************************************
      METHOD nRealRight ( nNew )   CLASS TC5RptItem
******************************************************************************************************************

   if nNew != nil
      ::aCoords[4] := nNew
   endif

return ::aCoords[4]


******************************************************************************************************************
      METHOD nRealWidth ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[4] := ::aCoords[2] + nNew
   endif

return ::aCoords[4] - ::aCoords[2]

******************************************************************************************************************
      METHOD nRealHeight ( nNew )   CLASS TC5RptItem
******************************************************************************************************************
   if nNew != nil
      ::aCoords[3] := ::aCoords[1] + nNew
   endif

return ::aCoords[3]-::aCoords[1]


******************************************************************************************************************
      METHOD Edit()   CLASS TC5RptItem
******************************************************************************************************************
do case
   case ::nType == 1
        ::EditText()
   case ::nType == 2
        ::EditBmp()
endcase

return 0

******************************************************************************************************************
      METHOD EditText()   CLASS TC5RptItem
******************************************************************************************************************
local cOldVar
local rc
local cText := ::cCaption
local oFont
local o := self
local lOk := .f.
local oDlg
local cVar1 := padr( ::cCaption, 1000 )
local oGet1
local oBtn1
local oBtn2
local oBtn3

DEFINE DIALOG oDlg ;
       FROM 259, 146 TO 611, 744 PIXEL ;
       TITLE "Editar texto"

       @ 25, 28 GET oGet1 VAR cVar1 ;
             SIZE 249, 105 PIXEL OF oDlg MULTILINE

       @ 143, 153 BUTTON oBtn1 PROMPT "Aceptar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (lOk := .t., oDlg:End())

       @ 143, 199 BUTTON oBtn2 PROMPT "Cancelar" ;
             SIZE 44, 12 PIXEL OF oDlg ACTION (oDlg:End())

       @ 143, 244 BUTTON oBtn3 PROMPT "Ayuda" ;
             SIZE 44, 12 PIXEL OF oDlg

ACTIVATE DIALOG oDlg


if lOk
   ::cCaption := cVar1
   ::oWnd:Refresh()
endif




return 0


******************************************************************************************************************
   METHOD aGetPoints() CLASS TC5RptItem
******************************************************************************************************************

local aPoints
local nT,nL,nB,nR
local nMedH
local nMedW

   nT := ::aCoords[1] + ::oWnd:aCoords[1]
   nL := ::aCoords[2] + ::oWnd:aCoords[2]
   nB := ::aCoords[3] + ::oWnd:aCoords[1]
   nR := ::aCoords[4] + ::oWnd:aCoords[2]



   nMedH := (nB-nT)/2
   nMedW := (nR-nL)/2

   aPoints := {{nT      , nL          },;
               {nT      , nL+nMedW    },;
               {nT      , nR          },;
               {nT+nMedH, nR          },;
               {nB        , nR          },;
               {nB        , nL+nMedW    },;
               {nB        , nL          },;
               {nT+nMedH, nL          }}

return aPoints

******************************************************************************************************************
      METHOD Save( ) CLASS TC5RptItem
******************************************************************************************************************

local cStr


cStr := str(::nType,3)

cStr +=  str(::aCoords[1],4)
cStr +=  str(::aCoords[2],4)
cStr +=  str(::aCoords[3],4)
cStr +=  str(::aCoords[4],4)

do case
   //case ::nType == C5VLINE .or. ::nType == C5HLINE
   //
   //     cStr += ( str(::nPen, 2  )                  )
   //     cStr += ( str(::nClrPen,8)                  )

    case ::nType == C5RECT // rectangulo

        cStr += ( str(::nPen, 2 )                   )
        cStr += ( str(::nClrPen,8)                  )
        cStr += ( str(::nClrPane,8)                 )
        cStr += ( if( ::lTransparent,  ".t.",".f.") )

    case ::nType == C5RORECT // rectangulo

        cStr += ( str(::nPen, 2 )                   )
        cStr += ( str(::nClrPen,8)                  )
        cStr += ( str(::nClrPane,8)                 )
        cStr += ( if( ::lTransparent,  ".t.",".f.") )
        cStr += ( str(::nRW, 3)                     )
        cStr += ( str(::nRH, 3)                     )

    case ::nType == C5DBF

        cStr += ( str(::cDbf, 255 )                 )

    case ::nType == 100000

        cStr += ( if( ::lTransparent,  ".t.",".f.") )
        cStr += ( if( ::lRoundRect,  ".t.",".f.") )
        cStr += ( str(::nFilas,3)                 )
        cStr += ( str(::nColumnas,3)              )


endcase



return cStr



******************************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags )  CLASS TC5RptItem
******************************************************************************************************************
local oMenu


MENU oMenu POPUP

   MENUITEM "Cut" ACTION ::oWnd:Cut()
   MENUITEM "Copy" ACTION ::oWnd:Copy()
   MENUITEM "Paste" ACTION ::oWnd:Paste()

   if ::lEnable
      MENUITEM "Disable" ACTION (::lEnable := .f., ::oWnd:Refresh())
   else
      MENUITEM "Enable" ACTION  (::lEnable := .t., ::oWnd:Refresh())
   endif

   do case
      case ::nType == C5TEXTO
           MENUITEM "Font"               ACTION ::SelectFont()
           MENUITEM "Vertical"
           MENUITEM "Invertido"
           MENUITEM "Color de texto"     ACTION ( ::nClrText := ChooseColor( ::nClrText ), ::oWnd:Refresh())
           MENUITEM "Color de Fondo"     ACTION ( ::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())
           MENUITEM "Editar texto"       ACTION ( ::EditText(), ::oWnd:Refresh() )
      case ::nType == C5BITMAP
           MENUITEM "Seleccionar imagen"
      //case ::nType == C5VLINE .or. ::nType == C5HLINE
      //     MENUITEM "Grueso"
      //     MENUITEM "Color"
      case ::nType == C5RECT
           MENUITEM "Grueso"
           MENUITEM "Color línea"        ACTION ( ::nClrPen  := ChooseColor( ::nClrPen  ), ::oWnd:Refresh())
           MENUITEM "Color Fondo"        ACTION ( ::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())
           if ::lTransparent
              MENUITEM "No Transparente" ACTION (::lTransparent := .f., ::oWnd:Refresh())
           else
              MENUITEM "Transparente"    ACTION (::lTransparent := .t., ::oWnd:Refresh())
           endif
      case ::nType == C5RORECT
           MENUITEM "Grueso"
           MENUITEM "Color línea"        ACTION ( ::nClrPen  := ChooseColor( ::nClrPen  ), ::oWnd:Refresh())
           MENUITEM "Color Fondo"        ACTION ( ::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())
           if ::lTransparent
              MENUITEM "No Transparente" ACTION (::lTransparent := .f., ::oWnd:Refresh())
           else
              MENUITEM "Transparente"    ACTION (::lTransparent := .t., ::oWnd:Refresh())
           endif
           MENUITEM "Ancho esquina"
           MENUITEM "Alto esquina"
      case ::nType == C5ELIPSE
           MENUITEM "Grueso"
           MENUITEM "Color línea"        ACTION ( ::nClrPen  := ChooseColor( ::nClrPen  ), ::oWnd:Refresh())
           MENUITEM "Color Fondo"        ACTION ( ::nClrPane := ChooseColor( ::nClrPane ), ::oWnd:Refresh())
           if ::lTransparent
              MENUITEM "No Transparente" ACTION (::lTransparent := .f., ::oWnd:Refresh())
           else
              MENUITEM "Transparente"    ACTION (::lTransparent := .t., ::oWnd:Refresh())
           endif

      case ::nType == C5DBF

           MENUITEM "Seleccionar tabla" ACTION ( ::cDbf := cGetFile( "*.dbf", "Seleccione tabla"),::oWnd:Refresh())

      case ::nType == 100000

           MENUITEM "Mostar líneas" ACTION ( ::lShowLines := !::lShowLines,::oWnd:Refresh())
           MENUITEM "Esquinas redondeadas" ACTION ( ::lRoundRect := !::lRoundRect,::oWnd:Refresh())
           MENUITEM "Transparente"    ACTION (::lTransparent := .t., ::oWnd:Refresh())
           MENUITEM "Filas"
           MENU
             MENUITEM  "1" ACTION ( ::nFilas :=    1, ::oWnd:Refresh())
             MENUITEM  "2" ACTION ( ::nFilas :=    2, ::oWnd:Refresh())
             MENUITEM  "3" ACTION ( ::nFilas :=    3, ::oWnd:Refresh())
             MENUITEM  "4" ACTION ( ::nFilas :=    4, ::oWnd:Refresh())
             MENUITEM  "5" ACTION ( ::nFilas :=    5, ::oWnd:Refresh())
             MENUITEM  "6" ACTION ( ::nFilas :=    6, ::oWnd:Refresh())
             MENUITEM  "7" ACTION ( ::nFilas :=    7, ::oWnd:Refresh())
             MENUITEM  "8" ACTION ( ::nFilas :=    8, ::oWnd:Refresh())
             MENUITEM  "9" ACTION ( ::nFilas :=    9, ::oWnd:Refresh())
             MENUITEM "10" ACTION ( ::nFilas :=   10, ::oWnd:Refresh())
             MENUITEM "11" ACTION ( ::nFilas :=   11, ::oWnd:Refresh())
             MENUITEM "12" ACTION ( ::nFilas :=   12, ::oWnd:Refresh())
             MENUITEM "13" ACTION ( ::nFilas :=   13, ::oWnd:Refresh())
             MENUITEM "14" ACTION ( ::nFilas :=   14, ::oWnd:Refresh())
             MENUITEM "15" ACTION ( ::nFilas :=   15, ::oWnd:Refresh())
             MENUITEM "16" ACTION ( ::nFilas :=   16, ::oWnd:Refresh())
             MENUITEM "17" ACTION ( ::nFilas :=   17, ::oWnd:Refresh())
             MENUITEM "18" ACTION ( ::nFilas :=   18, ::oWnd:Refresh())
             MENUITEM "19" ACTION ( ::nFilas :=   19, ::oWnd:Refresh())
             MENUITEM "20" ACTION ( ::nFilas :=   20, ::oWnd:Refresh())
           ENDMENU
           MENUITEM "Columnas"
           MENU
             MENUITEM  "1" ACTION ( ::nColumnas :=    1, ::oWnd:Refresh())
             MENUITEM  "2" ACTION ( ::nColumnas :=    2, ::oWnd:Refresh())
             MENUITEM  "3" ACTION ( ::nColumnas :=    3, ::oWnd:Refresh())
             MENUITEM  "4" ACTION ( ::nColumnas :=    4, ::oWnd:Refresh())
             MENUITEM  "5" ACTION ( ::nColumnas :=    5, ::oWnd:Refresh())
             MENUITEM  "6" ACTION ( ::nColumnas :=    6, ::oWnd:Refresh())
             MENUITEM  "7" ACTION ( ::nColumnas :=    7, ::oWnd:Refresh())
             MENUITEM  "8" ACTION ( ::nColumnas :=    8, ::oWnd:Refresh())
             MENUITEM  "9" ACTION ( ::nColumnas :=    9, ::oWnd:Refresh())
             MENUITEM "10" ACTION ( ::nColumnas :=   10, ::oWnd:Refresh())
             MENUITEM "11" ACTION ( ::nColumnas :=   11, ::oWnd:Refresh())
             MENUITEM "12" ACTION ( ::nColumnas :=   12, ::oWnd:Refresh())
             MENUITEM "13" ACTION ( ::nColumnas :=   13, ::oWnd:Refresh())
             MENUITEM "14" ACTION ( ::nColumnas :=   14, ::oWnd:Refresh())
             MENUITEM "15" ACTION ( ::nColumnas :=   15, ::oWnd:Refresh())
             MENUITEM "16" ACTION ( ::nColumnas :=   16, ::oWnd:Refresh())
             MENUITEM "17" ACTION ( ::nColumnas :=   17, ::oWnd:Refresh())
             MENUITEM "18" ACTION ( ::nColumnas :=   18, ::oWnd:Refresh())
             MENUITEM "19" ACTION ( ::nColumnas :=   19, ::oWnd:Refresh())
             MENUITEM "20" ACTION ( ::nColumnas :=   20, ::oWnd:Refresh())
           ENDMENU

   endcase

ENDMENU
ACTIVATE POPUP oMenu AT nRow, nCol OF ::oWnd

return 0




******************************************************************************************************************
   METHOD SelectFont()  CLASS TC5RptItem
******************************************************************************************************************

   local aFont, oFont
   local nRGBColor := ::nClrText

   //DATA cFaceName, nWFont, nHFont, lUnder, lBold, lItalic

   if nRGBColor != nil
      aFont := ChooseFont( { ::nHFont,::nWFont,0,0,if(::lBold,700,400),::lItalic,::lUnder,::lStrike,0,0,0,0,0,::cFaceName }, @nRGBColor )
   else
      aFont := ChooseFont( { ::nHFont,::nWFont,0,0,if(::lBold,700,400),::lItalic,::lUnder,::lStrike,0,0,0,0,0,::cFaceName } )
   endif

   if ! Empty( aFont[ LF_FACENAME ] ) // the user pressed Esc
      ::cFaceName := aFont[ LF_FACENAME ]
      ::nHFont    := aFont[ LF_HEIGHT ]
      ::nWFont    := aFont[ LF_WIDTH ]
      ::lUnder    := aFont[ LF_UNDERLINE ]
      ::lBold     := ! ( aFont[ LF_WEIGHT ] == FW_NORMAL )
      ::lItalic   := aFont[ LF_ITALIC ]
      ::lStrike   := aFont[ LF_STRIKEOUT ]
      ::nClrText  := nRGBColor
   endif
   ::oWnd:Refresh()

return 0

******************************************************************************************************************
   METHOD SetProperties( lReset ) CLASS TC5RptItem
******************************************************************************************************************
Local oInsp
Local nGroup
Local cGroup
local oProp
local n
local nLen


if ::oWnd:lSelecteds
   return ::SetMultiProperties()
endif

oInsp := Inspector()
nLen  := len( ::aProperties )

     oInsp:Reset()
     oInsp:oObject := self

     cGroup := "Información"
     nGroup := oInsp:AddGroup( cGroup )
     oInsp:AddItem( "", "Tipo", ::GetType() ,,nGroup,,.F. )
     oInsp:AddItem( "nID",          "ID",    ::nID,,nGroup )

     for n := 1 to nLen

         oProp := ::aProperties[n]

         if cGroup != oProp:cCategory
            cGroup := oProp:cCategory
            nGroup := oInsp:AddGroup( cGroup )
         endif

         oInsp:AddItem( oProp:cProperty, oProp:cText, oSend(Self,oProp:cProperty) , oProp:cType , nGroup ,,, oProp:bProperty )

     next

     oInsp:GoTop()
     oInsp:Refresh()

return nil

******************************************************************************************************************
   METHOD SetMultiProperties( lReset ) CLASS TC5RptItem
******************************************************************************************************************
Local cGroup
Local nGroup
Local oInsp
local oItem
local aProperties
local aAux
local aAux2
local aSelecteds
local n
local n2
local nEn
local nLen, nLen2
local oProp
local lComun

aProperties := {}
aAux        := {}
aAux2       := {}
aSelecteds  := {}
nLen        := len( ::oWnd:aItems )

for n := 1 to nLen
    if ::oWnd:aItems[n]:lSelected
       aadd( aSelecteds, ::oWnd:aItems[n] )
    endif
next

nLen := len( aSelecteds )
aAux := aSelecteds[1]:PropComunes( aSelecteds[2] )

for n := 3 to nLen
    oItem := aSelecteds[n]
    for n2 := 1 to len( aAux )
        nEn := ascan( oItem:aProperties, {|o| aAux[n2] != nil .and.;
                                              o != nil        .and.;
                                              o:cProperty == aAux[n2]:cProperty .and.;
                                              len(o:cProperty) == len(aAux[n2]:cProperty) } )
        if nEn == 0
           aAux[n2] := nil
        endif
    next
next

for n := 1 to len( aAux )
    if aAux[n] != nil
       aadd( aProperties, aAux[n] )
    endif
next

     oInsp       := Inspector()


     oInsp:Reset()
     oInsp:oObject := aSelecteds

     nLen := len( aProperties )
     for n := 1 to nLen

         oProp := aProperties[n]

         if cGroup != oProp:cCategory
            cGroup := oProp:cCategory
            nGroup := oInsp:AddGroup( cGroup )
         endif

         oInsp:AddItem( oProp:cProperty, oProp:cText,OSend( if(::oWnd:oSelected != nil, ::oWnd:oSelected, aSelecteds[1]), oProp:cProperty ) , oProp:cType , nGroup ,,, oProp:bProperty )

     next

     oInsp:GoTop()
     oInsp:Refresh()

return nil



*************************************************************************************************
      METHOD MoveTo( aPos, lRefresh ) CLASS TC5RptItem
*************************************************************************************************

DEFAULT lRefresh := .f.

::nRealTop    := aPos[1]
::nRealLeft   := aPos[2]
::nRealBottom := aPos[3]
::nRealRight  := aPos[4]

if lRefresh
   ::oWnd:Refresh()
endif

return nil

*******************************************************************************************************************************
      METHOD OffsetX( nVal ) CLASS TC5RptItem
*******************************************************************************************************************************

if valtype( nVal ) == "C"; nVal := val( nVal ) ; endif

::aCoords[2] += nVal
::aCoords[4] += nVal

return nVal


*******************************************************************************************************************************
      METHOD OffsetY( nVal ) CLASS TC5RptItem
*******************************************************************************************************************************

if valtype( nVal ) == "C"; nVal := val( nVal ) ; endif

::aCoords[1] += nVal
::aCoords[3] += nVal

return 0

*******************************************************************************************************************************
  METHOD AddProp( cProperty, cText, bProperty, cCategory, cType ) CLASS TC5RptItem
*******************************************************************************************************************************
local oProp

oProp := TProperty():New( cProperty, cText, bProperty, cCategory, cType )

aadd( ::aProperties, oProp )

return oProp

*******************************************************************************************************************************
  METHOD PropComunes( oItem ) CLASS TC5RptItem
*******************************************************************************************************************************
local nLen1
local nLen2
local aComunes
local n
local nEn
local cProperty

aComunes := {}

nLen1 := len( ::aProperties )

for n := 1 to nLen1
    cProperty := ::aProperties[n]:cProperty
    nEn := ascan( oItem:aProperties, {|o| o != nil .and. cProperty == o:cProperty .and. len( cProperty ) == len( o:cProperty ) } )
    if nEn != 0
       aadd( aComunes, ::aProperties[n] )
    endif
next

return aComunes
