#include "fivewin.ch"

CLASS TProperty

      DATA oObject
      DATA cProperty
      DATA cText
      DATA bProperty
      DATA cCategory
      DATA cType

      METHOD New( cProperty, cText, bProperty, cCategory, cType ) CONSTRUCTOR

      METHOD Set( uValue ) INLINE oSend( ::oObject,"_" + ::cProperty, uValue )
      METHOD Get( )        INLINE oSend( ::oObject, ::cProperty )

ENDCLASS

***********************************************************************************
  METHOD New( cProperty, cText, bProperty, cCategory, cType ) CLASS TProperty
***********************************************************************************

   ::cProperty  := cProperty
   ::cText      := cText
   ::bProperty  := bProperty
   ::cCategory  := cCategory
   ::cType      := cType

return self


