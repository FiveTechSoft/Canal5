#include "fivewin.ch"

#define CREA_CONTROL 1

CLASS TTerceros FROM TShape

      DATA hWndServer
      DATA nIDCtrl

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
      METHOD Pide( nAction, uVal1, uVal2, uVal3, uVal4 )
      METHOD GetPropiedad( cPropiedad )
      METHOD Paint( hDC )

ENDCLASS

METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TTerceros

   ::nIDCtrl := ::Pide( CREA_CONTROL )

return self


METHOD Pide( nAccion, uVal1, uVal2 ) CLASS TTerceros

return SendMessage( ::hWndServer, nAccion, ::nIdCtrl, uVal2 )


METHOD GetPropiedad( cPropiedad ) CLASS TTerceros


