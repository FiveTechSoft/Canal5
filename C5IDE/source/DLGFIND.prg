// Class for Windows standard Common Dialog FindText.
// FindText is a Non-Modal Dialog created and managed by Windows.

// Here FiveWin turns it into a Clipper object and let Clipper
// manages it normally

#include "FiveWin.ch"

#ifdef __XPP__
   #define Super ::TDialog
#endif

//----------------------------------------------------------------------------//

CLASS TDlgFind FROM TDialog

   CLASSDATA  nFindMsgString

   DATA bAction

   METHOD New( cText, bAction ) CONSTRUCTOR

   METHOD Command( nWParam, nLParam )

   METHOD CtlColor( hWndChild, hDCChild ) VIRTUAL

   METHOD HandleEvent( nMsg, nWParam, nLParam )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cText, oEdit, bAction ) CLASS TDlgFind

   local nFindMsgString

   ::lModal    = .f.
   ::lCentered = .f.
   ::lHelpIcon = .t.
   ::bAction := bAction

   RegDialog( ::hWnd := FindText( cText, oEdit:hWnd, Self, @nFindMsgString ) )

   if ::nFindMsgString == nil
      ::nFindMsgString = nFindMsgString
   endif

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDlgFind

   if nMsg == ::nFindMsgString
      MsgBeep()
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

function DlgFindText( cText, oEdit, bAction )

   local oDlg := TDlgFind():New( cText, oEdit, bAction )

return oDlg

//----------------------------------------------------------------------------//
   METHOD Command( nWParam, nLParam )
//----------------------------------------------------------------------------//

   local nNotifyCode, nID, hWndCtl
   local cText
   #ifdef __CLIPPER__
      nNotifyCode = nHiWord( nLParam )
      nID         = nWParam
      hWndCtl     = nLoWord( nLParam )
   #else
      nNotifyCode = nHiWord( nWParam )
      nID         = nLoWord( nWParam )
      hWndCtl     = nLParam
   #endif

   do case
      case nNotifyCode == BN_CLICKED
           if nID == 1 // Buscar siguiente
              cText := GetWindowText( GetDlgItem( ::hWnd, 1152 ) )
              SetLastFind( cText )
              if ::bAction != nil
                 eval( ::bAction, cText )
              endif
              ::SetFocus(GetDlgItem(::hWnd,1))
           else
              if nId == 2
                 ::End()
              endif
           endif
   endcase



return 0
