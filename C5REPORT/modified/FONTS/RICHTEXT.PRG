#define PHYSICALWIDTH    110 
#define PHYSICALHEIGHT   111 
#define PHYSICALOFFSETX  112 
#define PHYSICALOFFSETY  113 
#define HORZSIZE 4 
#define VERTSIZE 6 
#define HORZRES  8 
#define VERTRES 10 
#define LOGPIXELSX       88 
#define LOGPIXELSY       90 

STATIC FUNCTION PrintMixed (lPreview) 

  LOCAL oPrn, cName := "Mixed Printtest", aLine, nLine 
  LOCAL aMargins 
  LOCAL aPhysMarg := Array(4) 
  LOCAL nPhysWidth, nPhysHeight 
  LOCAL nHorzRes, nVertRes, nHorzSize, nVertSize 
  LOCAL nTMarg, nLMarg, nRMarg, nBMarg 
  LOCAL dpiX, dpiY 
  LOCAL nL := 0, nT := 0, aPos, aFrom, aTo, i,y:= 0.5 
  LOCAL aRect := Array (4) 

  DEFAULT lPreview := .f. 

  //? oDoc:RtfSize() // 1.048.576 

  PRINT oPrn NAME cName FROM USER //PREVIEW 

  nHorzRes := GETDEVICECAPS( oPrn:hDC, HORZRES ) // 9314,Druckbereich in Pixel, 47,2 Pixel/mm = 197mm 
  nVertRes := GETDEVICECAPS( oPrn:hDC, VERTRES ) // 

  nHorzSize := GETDEVICECAPS( oPrn:hDC, HORZSIZE )/10 // 197, Druckbereich in mm (cm) 
  nVertSize := GETDEVICECAPS( oPrn:hDC, VERTSIZE )/10 // height in mm 

  dpiX :=  GETDEVICECAPS( oPrn:hDC, LOGPIXELSX)   // 1200, Druckauflösung in dpi (pixel pro inch) 
  dpiY :=  GETDEVICECAPS( oPrn:hDC, LOGPIXELSY) 

  nPhysWidth  := GETDEVICECAPS( oPrn:hDC, PHYSICALWIDTH ) // 9921, gesamte Druckbreite incl. nicht bedruckbarer Bereich 
  nPhysHeight := GETDEVICECAPS( oPrn:hDC, PHYSICALHEIGHT ) 
  aPhysMarg[1] := GETDEVICECAPS( oPrn:hDC, PHYSICALOFFSETY ) // 280, linker nicht bedruckbarer Bereich 
  aPhysMarg[2] := GETDEVICECAPS( oPrn:hDC, PHYSICALOFFSETX ) // 280, oberer nicht bedruckbarer Rand 
  aPhysMarg[3] := nPhysHeight - nVertRes - aPhysMarg[1]      // unterer rand 
  aPhysMarg[4] := nPhysWidth - nHorzRes - aPhysMarg[2]       // rechter Rand = PHYSICALWIDTH-HORZRES-PHYSICALOFFSETX 

  aMargins := PageGetMargins ()                                          // in 1/100 mm 
  nTMarg := aMargins[ 1 ] / 2540 * GETDEVICECAPS( oPrn:hDC, LOGPIXELSY ) // pixel 
  nLMarg := aMargins[ 2 ] / 2540 * GETDEVICECAPS( oPrn:hDC, LOGPIXELSX ) 
  nRMarg := aMargins[ 3 ] / 2540 * GETDEVICECAPS( oPrn:hDC, LOGPIXELSX ) 
  nBMarg := aMargins[ 4 ] / 2540 * GETDEVICECAPS( oPrn:hDC, LOGPIXELSY ) 

  AEval( aMargins, { |x,y|  aMargins[y] := x/1000 } )        // Margin in cm 

  aPos := oPrn:Pix2Mmtr (nTMarg,nLMarg) 

  aPos[1] := aPos[1]/10 
  aPos[2] := aPos[2]/10 


  PAGE 

   for i := 1 TO 35 
     oPrn:CmSay (aPos[1]+y,aPos[2], "Line "+Str(i,2)+" ,Testline") 
     aPos[1] := aPos[1] + y 
   next 

   aFrom := oPrn:Cmtr2Pix (aPos[1]+1,aPos[2]) 
   aTo   := oPrn:Cmtr2Pix (nVertSize-aMargins[4],nHorzSize-aMargins[3]) // (nRow,nCol) 
   aRect := {aFrom[1],aFrom[2],aTo[1],aTo[2]} 

   oPrn:Box (aRect[1],aRect[2],aRect[3],aRect[4]) // (top,left,bottom,right) 
  //aLine := oDoc:PrintBox (If( lPreview, oPrn:hDCOut, oPrn:hDC ), aFrom[1]+50,aFrom[2]+50,aTo[2]-5,aTo[1]-5, 0) 
  // oPrn:Say (aLine[2]+100,nLMarg, "Zeile 2 des Testausdruckes") 

    PrintRect (oPrn:hDC, aRect[1]+250, aRect[2]+250, aRect[3]-100, aRect[4]-100) 
 // oPrn:Say (aLine[2]+100,nLMarg, "Zeile 2 des Testausdruckes") 

   ENDPAGE 

  ENDPRINT 

RETURN (nil) 




#define PIXELPERCM 472.44 
//----------------------------------------------------------------------------// 
STATIC FUNCTION PrintRect (hDC, nTop, nLeft, nBottom, nRight) 

  LOCAL lResult //:= .f. 
  DEFAULT nTop := 2.5,;    // cm 
          nLeft := 2.5,; 
          nBottom := nTop + 15,; 
          nRight := nLeft + 10 
/* 
  nTop := nTop * PIXELPERCM    // umrechnen in pixel 
  nLeft := nLeft * PIXELPERCM 
  nBottom := nBottom * PIXELPERCM 
  nRight := nRight * PIXELPERCM 
*/ 

  lResult := REPrintRect (oRTF:hWnd, hDC, nTop, nLeft, nBottom, nRight) 
  ? lResult[1],lResult[2],lResult[3] 

RETURN (nil) 


#pragma BEGINDUMP 

#include <Windows.h> 
#include <HbApi.h> 
#include <Richedit.h> 

//------------------------------------------------------------------------------------------------------------------------------ 
HB_FUNC( REPRINTRECT ) 
{ 
    HWND hwnd = (HWND) hb_parnl (1); 
    HDC  hdc  = (HDC) hb_parnl (2); 
    BOOL bSuccess = TRUE; 
    //INT  nSuccess = 0; 

    int TwipsPerPixelX = 1440/GetDeviceCaps (hdc,LOGPIXELSX);  //Twips per Pixel 
    int TwipsPerPixelY = 1440/GetDeviceCaps (hdc,LOGPIXELSY); 

    int cxPhysOffset = GetDeviceCaps(hdc, PHYSICALOFFSETX); 
    int cyPhysOffset = GetDeviceCaps(hdc, PHYSICALOFFSETY); 
    //int cxPhys = GetDeviceCaps(hdc, PHYSICALWIDTH); 
    //int cyPhys = GetDeviceCaps(hdc, PHYSICALHEIGHT); 

    int nHorzRes = GetDeviceCaps( hdc, HORZRES ); // Printarea in pixel  
    int nVertRes = GetDeviceCaps( hdc, VERTRES ); // 

    int nTop    = (hb_parnl(3)==NULL) ? cyPhysOffset : hb_parnl(3) ; 
    int nLeft   = (hb_parnl(4)==NULL) ? cxPhysOffset : hb_parnl(4) ; 
    int nBottom = (hb_parnl(5)==NULL) ? cyPhysOffset+nVertRes : hb_parnl(5) ; 
    int nRight  = (hb_parnl(6)==NULL) ? cxPhysOffset+nHorzRes : hb_parnl(6) ; 

    long lPrinted = 0; 
    //long lToPrint = 0; 

    FORMATRANGE fr; 
    //CHARRANGE cr; 

    //SetMapMode (hdc, MM_TEXT); 

    fr.hdc = hdc; 
    fr.hdcTarget = hdc; 

    fr.rcPage.top = 0; 
    fr.rcPage.left = 0; 
    fr.rcPage.bottom = nVertRes*TwipsPerPixelY; 
    fr.rcPage.right  = nHorzRes*TwipsPerPixelX; 
    //fr.rc.top   =  fr.rcPage.top+1440; 
    //fr.rc.left  =  fr.rcPage.left+1440; 
    //fr.rc.bottom = fr.rcPage.bottom; 
    //fr.rc.right =  fr.rcPage.right; 
    fr.rc.top   =  nTop*TwipsPerPixelY; 
    fr.rc.left  =  nLeft*TwipsPerPixelX; 
    fr.rc.bottom = nBottom*TwipsPerPixelY; 
    fr.rc.right =  nRight*TwipsPerPixelX; 

    //fr.chrg.cpMin = 0; 
    //fr.chrg.cpMax = -1; 

    SendMessage(hwnd, EM_SETSEL, 0, -1);                  // Select the entire contents. 
    SendMessage(hwnd, EM_EXGETSEL, 0, (LPARAM)&fr.chrg);  // Put the selection into a CHARRANGE. 

    //lToPrint = SendMessage (hwnd, WM_GETTEXTLENGTH,0,0); 
    //lToPrint = SendMessage (hwnd, WM_GETTEXTLENEX,0,0); 

    //SendMessage(hwnd, EM_FORMATRANGE, (WPARAM) 0, (LPARAM) 0); 

    while (fr.chrg.cpMin < fr.chrg.cpMax ) //&& bSuccess) 
    { 
       // nSuccess = StartPage(hdc); 
       // bSuccess = nSuccess >= 0; 
       // if (!fSuccess) break; 
        lPrinted = SendMessage(hwnd, EM_FORMATRANGE, (WPARAM) 1, (LPARAM) &fr); 
        //lPrinted = SendMessage(hwnd, EM_FORMATRANGE, (WPARAM) 0, (LPARAM) &fr); 
        //           SendMessage(hwnd, EM_DISPLAYBAND, (WPARAM) 0, (LPARAM) &fr.rc); 

        if (lPrinted <= fr.chrg.cpMin) 
          { 
            bSuccess = FALSE; 
            break; 
          } 
        fr.chrg.cpMin = lPrinted; 
        fr.rc.top   =  fr.rcPage.top+1440;     // define new area for the next pages 
        //fr.rc.left  =  fr.rcPage.left+1440; 
        fr.rc.bottom = fr.rcPage.bottom; 
        //fr.rc.right =  fr.rcPage.right; 
        EndPage (hdc); 
    } 

    SendMessage(hwnd, EM_FORMATRANGE, (WPARAM) 0, (LPARAM) 0); 

    hb_reta (3); 

    hb_stornl (lPrinted, -1, 1); 
    hb_stornl (fr.rc.top, -1, 2); 
    hb_stornl (fr.rc.bottom, -1, 3); 

    //hb_retni (lPrinted); 

} 

#pragma ENDDUMP 
