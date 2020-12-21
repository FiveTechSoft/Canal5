//-------------------------------------------------------------------------------------------------------------------------
#xcommand BEGIN STRUCTURE <Tag> [ EXTENDING <superClass> ] => ;
          _HB_CLASS <Tag> ;
          ; function <Tag>(...) ;
          ; static s_oClass ;
          ; local oClassInstance ; 
          ; local nScope  := 1 ;
          ; local cSuper  := "GWST" ;
          ; local oSuper ;
          ; local nOffSet := 0     ;
          ; local lUnion  := .F.   ;
          ; local nUnionSize  := 0 ;
          ; local lReadOnly   := .F. ;
          ; local aChild;       
          ; local nSize,cc;       
          [;REQUEST <superClass> ] ;
          ; if s_oClass == NIL ;
             [;  cSuper := <(superClass)>  ; oSuper := <superClass>() ] ;
          ;    s_oClass := HBClass():new(<(Tag)>,__CLS_PARAM( cSuper )) ;
          ;    if oSuper != NIL   ;
          ;       aChild  := aClone( oSuper:_mc__chdef_ ) ;
          ;       nOffset := oSuper:_mc__size_ ;
          ;    end  ;
          ;    if aChild == NIL   ;
          ;       aChild  := {}   ;
          ;    end                ;
          ; #undef  _CLASS_NAME_ ;
          ; #define _CLASS_NAME_ <Tag> ;
          ; #undef  _CLASS_MODE_ ;
          ; #define _CLASS_MODE_ _CLASS_DECLARATION_ ;
          ; #xtranslate CLSMETH <Tag> \<MethodName> => @<Tag>_\<MethodName> ;
          ; #xtranslate DECLCLASS <Tag> => <Tag> ;
          ; #xuntranslate Super() : ;
          ; #xuntranslate Super : ;
          ; #xuntranslate : Super : 
//-------------------------------------------------------------------------------------------------------------------------

#xcommand BEGIN STRUCTURE <Tag> FROM <superClass>  => ;
          _HB_CLASS <Tag> ;
          ; function <Tag>(...) ;
          ; static s_oClass          ;
          ; local oClassInstance     ; 
          ; local nScope  := 1       ;
          ; local nOffSet := 0       ;
          ; local lUnion  := .F.     ;
          ; local nUnionSize  := 0   ;
          ; local lReadOnly   := .F. ;
          ; local aChild      := {}  ;       
          ; local nSize,cc;       
          ; REQUEST <superClass>  ;
          ; if s_oClass == NIL ;
          ;    s_oClass := HBClass():new(<(Tag)>,__CLS_PARAM( <(superClass)> )) ;
          ; DATA _m__shift_   ;
          ; DATA _m__child_   ;
          ; DATA _m__pto_     ;
          ; DATA _m__pt_      ;
          ; METHOD _gwst_(oParent,nShift)   EXTERN gwst__gwst                 ;
          ; METHOD _alloc_( lCopy , pMem )  EXTERN gwst__alloc                ;
          ; METHOD _free_( lCopy )          EXTERN gwst__free                 ;
          ; METHOD _malloc_(n)              EXTERN __GWST__MALLOC__           ;
          ; METHOD _mfree_(pMem )           EXTERN __GWST__MFREE__            ;
          ; METHOD _link_( pMem , lCopy  )  EXTERN gwst__link                 ;
          ; METHOD _unlink_( lCopy  )       EXTERN gwst__unlink               ;
          ; METHOD _zeromemory_()           EXTERN gwst__zeromemory           ;
          ; METHOD _sizeof_( cMember )      EXTERN gwst__sizeof               ;
          ; METHOD _addressof_( cMember )   EXTERN gwst__addressof            ;
          ; METHOD __get__( nPtType , nOffset , nSize )  EXTERN gwst__get     ;
          ; METHOD __set__( val , nPtType , nOffset , nSize ) EXTERN gwst__set ;
          ; #undef  _CLASS_NAME_ ;
          ; #define _CLASS_NAME_ <Tag> ;
          ; #undef  _CLASS_MODE_ ;
          ; #define _CLASS_MODE_ _CLASS_DECLARATION_ ;
          ; #xtranslate CLSMETH <Tag> \<MethodName> => @<Tag>_\<MethodName> ;
          ; #xtranslate DECLCLASS <Tag> => <Tag> ;
          ; #xuntranslate Super() : ;
          ; #xuntranslate Super : ;
          ; #xuntranslate : Super : ;
          
//-------------------------------------------------------------------------------------------------------------------------

#xcommand END STRUCTURE => ;
               CLASSDATA _mc__chdef_ INIT aChild  ;
          ;    CLASSDATA _mc__size_  INIT nOffset ;
          ;    ENDCLASS
          
//-------------------------------------------------------------------------------------------------------------------------

#xcommand MEMBER @ <cls> <m> => ;
          nSize := <cls>():_mc__size_ ;
          ; aAdd( aChild , { {|o,n| <cls>():New(o,n) } , nOffset , nSize } ) ;
          ; _HB_MEMBER <m>() ;
          ; cc := "s:_m__child_[" + LTrim(Str(Len(aChild))) + "]" ;
          ; s_oClass:AddInline( <(m)>,(&("{|s|" + cc + "}")),1 + 32,.F. ) ;
          ; _HB_MEMBER _sz_<m>() ;
          ; s_oClass:AddInline( "_sz_" + <(m)>,(&("{|s|" + LTrim(Str(nSize)) + "}")),33,.F. ) ;
          ; _HB_MEMBER _ad_<m>() ;
          ; s_oClass:AddInline( "_ad_" + <(m)>,(&("{|s|"+LTrim(Str(nOffset))+"}")),33,.F. ) ;
          ; if lUnion ;
          ;    nUnionSize := iif((nUnionSize \< nSize) , nSize ,nUnionSize) ;
          ; else ;
          ;    nOffset += nSize ;
          ; end 
          
//-------------------------------------------------------------------------------------------------------------------------

#xcommand GWST_ADD_MEMBER <m> , <n> , <nt> => ;
          nSize := <n>    ;
          ; _HB_MEMBER _sz_<m>() ;
          ; s_oClass:AddInline( "_sz_" + <(m)>,(&("{|s|" + LTrim(Str(nSize)) + "}")),33,.F. ) ;
          ; _HB_MEMBER _ad_<m>() ;
          ; s_oClass:AddInline( "_ad_" + <(m)>,(&("{|s| "+LTrim(Str(nOffset))+"}")),33,.F. ) ;
          ; _HB_MEMBER <m>() ;
          ; cc := "{|s| s:__get__(" + <(nt)> + "," +LTrim(Str(nOffset))+ "," + <(n)> +") }" ;
          ; s_oClass:AddInline( <(m)>,(&(cc)),33,.F. ) ;
          ; _HB_MEMBER _<m>() ;
          ; cc := "{|s,v | s:__set__(v," + <(nt)> + "," +LTrim(Str(nOffset))+ "," + <(n)> +") }" ;
          ; s_oClass:AddInline( "_" + <(m)>,(&(cc)),1) ;
          ; if lUnion ;
          ;    nUnionSize := iif((nUnionSize \< nSize) , nSize ,nUnionSize) ;
          ; else ;
          ;    nOffset += nSize ;
          ; end 
          
//-------------------------------------------------------------------------------------------------------------------------
#xcommand GWST_SKIP_BYTES( <n> ) => nOffset += <n> ;
//-------------------------------------------------------------------------------------------------------------------------
#xcommand BEGIN UNION => nUnionSize  := 0 ; lUnion := .T.
#xcommand END UNION   => nOffset += nUnionSize ; lUnion := .F.
//-------------------------------------------------------------------------------------------------------------------------

#define __GWST_MEMBER_BOOL__         1
#define __GWST_MEMBER_BYTE__         2
#define __GWST_MEMBER_WORD__         3
#define __GWST_MEMBER_DWORD__        4
#define __GWST_MEMBER_DWORD64__      5
#define __GWST_MEMBER_PCLIPVAR__     6
#define __GWST_MEMBER_FLOAT__        7
#define __GWST_MEMBER_DOUBLE__       8
#define __GWST_MEMBER_LPSTR__        9
#define __GWST_MEMBER_BINSTR__      10
#define __GWST_MEMBER_SZSTR__       11
#define __GWST_MEMBER_DYNSZ__       12
//-------------------------------------------------------------------------------------------------------------------------
#xcommand MEMBER mBOOL           <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_BOOL__
#xcommand MEMBER mBYTE           <m> => GWST_ADD_MEMBER <m> , 1 , __GWST_MEMBER_BYTE__
#xcommand MEMBER mWORD           <m> => GWST_ADD_MEMBER <m> , 2 , __GWST_MEMBER_WORD__
#xcommand MEMBER mINT16          <m> => MEMBER mWORD           <m>
#xcommand MEMBER mSHORT          <m> => MEMBER mWORD           <m>
#xcommand MEMBER mDWORD          <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_DWORD__
#xcommand MEMBER mULONG          <m> => MEMBER mDWORD <m>
#xcommand MEMBER mLONG           <m> => MEMBER mDWORD <m>
#xcommand MEMBER mUINT           <m> => MEMBER mDWORD <m>
#xcommand MEMBER mINT            <m> => MEMBER mDWORD <m>
#xcommand MEMBER mINT32          <m> => MEMBER mDWORD <m>
#xcommand MEMBER mLPARAM         <m> => MEMBER mDWORD <m>
#xcommand MEMBER mWPARAM         <m> => MEMBER mDWORD <m>
#xcommand MEMBER mPOINTER        <m> => MEMBER mDWORD <m>
#xcommand MEMBER mPOINTER32      <m> => MEMBER mDWORD <m>
#xcommand MEMBER mHANDLE         <m> => MEMBER mDWORD <m>
#xcommand MEMBER mHWND           <m> => MEMBER mDWORD <m>
#xcommand MEMBER mHDC            <m> => MEMBER mDWORD <m>
#xcommand MEMBER mPCLIPVAR       <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_PCLIPVAR__
#xcommand MEMBER mCODEBLOCK      <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_PCLIPVAR__
#xcommand MEMBER mLPXBASE        <m> => MEMBER mPCLIPVAR <m>

#xcommand MEMBER mDWORD64        <m> => GWST_ADD_MEMBER <m> , 8 , __GWST_MEMBER_DWORD64__
#xcommand MEMBER mDOUBLE         <m> => GWST_ADD_MEMBER <m> , 8 , __GWST_MEMBER_DOUBLE__ 
#xcommand MEMBER mFLOAT          <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_FLOAT__  
#xcommand MEMBER mLPSTR          <m> => GWST_ADD_MEMBER <m> , 4 , __GWST_MEMBER_LPSTR__  
//-------------------------------------------------------------------------------------------------------------------------
#xcommand MEMBER mBINSTR  <m>  SIZE <n> => GWST_ADD_MEMBER <m> , <n> , __GWST_MEMBER_BINSTR__
#xcommand MEMBER mSZSTR   <m>  SIZE <n> => GWST_ADD_MEMBER <m> , <n> , __GWST_MEMBER_SZSTR__
#xcommand MEMBER mDYNSZ   <m>           => GWST_ADD_MEMBER <m> , 4   , __GWST_MEMBER_DYNSZ__
//-------------------------------------------------------------------------------------------------------------------------
