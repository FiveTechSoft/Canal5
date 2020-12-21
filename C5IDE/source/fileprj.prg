#include "fivewin.ch"


   CLASS TFilePrj

         DATA cCarpeta
         DATA cName
         DATA lExcludeCmp
         METHOD New( cName, cCarpeta ) CONSTRUCTOR

   ENDCLASS

   ******************************************************************************************************************************
     METHOD New( cName, cCarpeta ) CLASS TFilePrj
   ******************************************************************************************************************************

     DEFAULT cCarpeta := ".\"

     ::cName       := alltrim( cName )
     ::lExcludeCmp := .f.
     ::cCarpeta    := cCarpeta

   return self

