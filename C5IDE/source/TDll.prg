#include "fivewin.ch"
#include "constant.ch"
#include "fileio.ch"

/*	0x0001 = Cursor
	0x0002 = Bitmap
	0x0003 = Icon
	0x0004 = Menu
	0x0005 = Dialog
	0x0006 = String Table
	0x0007 = Font Directory
	0x0008 = Font
	0x0009 = Accelerators Table
	0x000A = RC Data (custom binary data)
	0x000B = Message table
	0x000C = Group Cursor
	0x000E = Group Icon
	0x0010 = Version Information
	0x0011 = Dialog Include
	0x0013 = Plug'n'Play
	0x0014 = VXD
	0x0015 = Animated Cursor
	0x2002 = Bitmap (new version)
	0x2004 = Menu (new version)
	0x2005 = Dialog (new version)*/


function Recursos( cFile )


     local oVerDll
     local oTree
     local oItem1, oItem2, oItem3, oItem4
     local oBrush
     local oImageList
     local oWnd := Aplicacion():oWnd
     local oBar
     local o
     local oRoot, oRoot2
     local oRoot0
     local n, n2

local aTipos := {}
local aTipoRes := {"Cursor"        ,;   //  1
                   "Bitmap"        ,;   //  2
                   "Icono"         ,;   //  3
                   "Menu"          ,;   //  4
                   "Dialogo"       ,;   //  5
                   "String Table"  ,;   //  6
                   "FontDir"       ,;   //  7
                   "Font"          ,;   //  8
                   "Acelerador"    ,;   //  9
                   "RCData"        ,;   // 10
                   "TablaMensages" ,;   // 11
                   "GroupCursor"   ,;   // 12
                   "13"            ,;   // 13
                   "GroupIcon"     ,;   // 14
                   "15"            ,;   // 15
                   "Versión"       ,;   // 16
                   "DlgInclude"    ,;   // 17
                   "18"            ,;   // 18
                   "PlugPlay"      ,;   // 19
                   "VXD"           ,;   // 20
                   "AniCursor"     ,;   // 21
                   "AniIcon"       ,;   // 22
                   "Html" }             // 23


     aTipos := VerTipos( cFile )
     if ( valtype( aTipos ) == "N" .and. aTipos == -1 ) .or. len( aTipos ) == 0
        MsgStop( "No existen recursos en " + cFile, "Atención" )
        return 0
     endif

     oImageList = TImageList():New(16,16,"toolbar\image1.bmp")

     DEFINE BRUSH oBrush STYLE "NULL"

     DEFINE WINDOW oVerDll TITLE cFile  OF oWnd MDICHILD  BRUSH obrush

            //oVerDll:oWndClient:SetBrush( oBrush )

         /*   DEFINE BUTTONBAR oBar OF oVerDll 3D SIZE 25, 25

                   DEFINE BUTTON OF oBar NAME "plus"   NOBORDER   TOOLTIP "Expandir"    ACTION o:oTree:ExpandAll()
                   DEFINE BUTTON OF oBar NAME "minus"  NOBORDER   TOOLTIP "Contraer"    ACTION o:oTree:ColapseAll()
                   DEFINE BUTTON OF oBar NAME "props"   NOBORDER  TOOLTIP "Propiedades"
           */

            oTree := TTreeView():New( 1, 1, oVerDll, 0, CLR_WHITE,.t., .f., 1000, 1000 )
            oTree:SetImageList( oImageList )

            oRoot  := TTVItem():New( oTree, , cFileName( cFile ), 5, .t.,  oTree,,"prj",.t. )

            for n := 1 to len( aTipos )
                if valtype( aTipos[n] ) != "N"
                   loop
                endif

                oItem := TTVItem():New( oTree,, aTipoRes[n] , 6, .t., oRoot,,,.t.,.t. )
                aNames := VerNombres( cFile, aTipos[n] )
                if ( valtype( aNames ) == "N" .and. aNames == -1 ) .or. len( aNames ) == 0
                   loop
                endif
                for n2 := 1 to len( aNames )
                    TTVItem():New( oTree,, cValToChar(aNames[n2]), 6, .t., oItem,,,.t.,.t. )
                next
            next
            oVerDll:oClient := oTree

      ACTIVATE WINDOW oVerDll ON INIT oVerDll:Resize() VALID( oVerDll := nil, oImageList:End(),.T.)


   return nil

return nil

function RecursosRes( cFileName )

local nSize, buffer
local h := fopen( cFileName, FO_READ )
local nPuntero := 1

if empty( h )
   MsgInfo( "No se pudo abrir el fichero " + cFileName, "Atención")
   return nil
endif

nSize  := fsize( cFileName )
buffer := space( nSize )
h      := fopen( cFileName, FO_READ )
fread( h, @buffer, nSize )

cCabecera   := substr( buffer, nPuntero, 32 )
nPuntero += 32










fclose( h )

return nil









#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

   char szBuffer[80]; // print buffer for EnumResourceTypes
   DWORD cbWritten;   // number of bytes written to res. info. file
   size_t cbString;      // length of string in sprintf
   HRESULT hResult;
   HANDLE hFile;
   static int nTipos = 0;
   static int nNames = 0;

   // Declare callback functions.
   BOOL EnumTypesFunc2( HANDLE hModule, LPTSTR lpType, LONG lParam);
   BOOL EnumTypesFunc( HANDLE hModule, LPTSTR lpType, LONG lParam);
   BOOL EnumNamesFunc( HANDLE hModule, LPCTSTR lpType, LPTSTR lpName, LONG lParam);
   BOOL EnumNamesFunc2( HANDLE hModule, LPCTSTR lpType, LPTSTR lpName, LONG lParam);
   BOOL EnumLangsFunc( HANDLE hModule, LPCTSTR lpType, LPCTSTR lpName, WORD wLang, LONG lParam);


HB_FUNC( VERTIPOS )
{
   UINT LastErrorMode = SetErrorMode( 1 );
   HANDLE hExe = LoadLibrary( hb_parc( 1 ) );
   if ( hExe == NULL )
   {
      //MessageBox( 0, "No se pudo cargar el recurso","Atención",0);
      hb_retni(-1);
      return;
   }
   nTipos = 0;
   EnumResourceTypes(hExe, (ENUMRESTYPEPROC)EnumTypesFunc2,  0);
   if( nTipos )
   {
      hb_reta(nTipos);
      nTipos = 0;
      EnumResourceTypes(hExe, (ENUMRESTYPEPROC)EnumTypesFunc2,  1);
   }
}

BOOL EnumTypesFunc2( HANDLE hModule, LPTSTR lpType, LONG lParam)
{
   size_t cbString;
   HRESULT hResult;

    // Write the resource type to a resource information file.
    // The type may be a string or an unsigned decimal
    // integer, so test before printing.
    nTipos++;
    if( lParam )
    {
       if ((ULONG)lpType & 0xFFFF0000)
       {
          hb_storvc( lpType, -1, nTipos );

       }
       else
       {
          hb_storvni( (int) lpType, -1, nTipos );
       }
    }
    return TRUE;
}

HB_FUNC( VERNOMBRES )
{
   UINT LastErrorMode = SetErrorMode( 1 );
   HANDLE hExe = LoadLibrary( hb_parc( 1 ) );
   if ( hExe == NULL )
   {
      //MessageBox( 0, "No se pudo cargar el recurso","Atención",0);
      hb_retni(-1);
      return;
   }
   nNames = 0;
   EnumResourceNames(hExe, MAKEINTRESOURCE(hb_parni( 2 )),(ENUMRESNAMEPROC)EnumNamesFunc2,  0);
   if( nNames )
   {
      hb_reta(nNames);
      nNames = 0;
      EnumResourceNames(hExe, MAKEINTRESOURCE(hb_parni( 2 )),(ENUMRESNAMEPROC)EnumNamesFunc2,  1);
   }
}

BOOL EnumNamesFunc2(HANDLE hModule,LPCTSTR lpType,LPTSTR lpName,LONG lParam)
{
   size_t cbString;
   HRESULT hResult;

    // Write the resource type to a resource information file.
    // The type may be a string or an unsigned decimal
    // integer, so test before printing.
    nNames++;
    if( lParam )
    {
       if ((ULONG)lpName & 0xFFFF0000)
       {
          hb_storvc( lpName, -1, nNames );

       }
       else
       {
          hb_storvni( (int) lpName, -1, nNames );
       }
    }
    return TRUE;
}


HB_FUNC( SETERRORMODE )
{
    hb_retni( SetErrorMode( hb_parni( 1 )));
}

HB_FUNC( VERRECURSOS )
{

   // Load the .EXE whose resources you want to list.
   UINT LastErrorMode = SetErrorMode( 1 );
   HANDLE hExe = LoadLibrary( hb_parc(1) );
   if ( hExe == NULL )
   {

      return;
   }
   hFile = CreateFile("resinfo.txt",GENERIC_READ | GENERIC_WRITE,0,(LPSECURITY_ATTRIBUTES) NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,(HANDLE) NULL);

   if (hFile == INVALID_HANDLE_VALUE) {
       MessageBox( 0, "Could not open file.","Atención",0);
       return;
   }

   cbString = strlen(szBuffer);

   WriteFile(hFile,szBuffer,(DWORD) cbString, &cbWritten, NULL);

   EnumResourceTypes(hExe, (ENUMRESTYPEPROC)EnumTypesFunc,  0);

   FreeLibrary(hExe);
   CloseHandle(hFile);

}

//    FUNCTION: EnumTypesFunc(HANDLE, LPSTR, LONG)
//
//    PURPOSE:  Resource type callback
BOOL EnumTypesFunc( HANDLE hModule, LPTSTR lpType, LONG lParam)
{
   size_t cbString;
   HRESULT hResult;

    // Write the resource type to a resource information file.
    // The type may be a string or an unsigned decimal
    // integer, so test before printing.
    if ((ULONG)lpType & 0xFFFF0000)
    {
      hResult = wsprintf( szBuffer,  "Type: %s\n", lpType);
      if (FAILED(hResult))
      {
         return;
      }
    }
    else
    {
      hResult = wsprintf(szBuffer,  "Type: %u\n", (USHORT)lpType);
      if (FAILED(hResult))
      {
      // Add code to fail as securely as possible.
         return;
      }
//        cbString = sprintf(szBuffer, "Type: %u\n", (USHORT)lpType);
    }
   cbString = strlen(szBuffer);
   if (FAILED(hResult))
      {
      // Add code to fail as securely as possible.
         return;
      }
    WriteFile(hFile, szBuffer, (DWORD) cbString, &cbWritten, NULL);
    // Find the names of all resources of type lpType.
    EnumResourceNames(hModule, lpType,(ENUMRESNAMEPROC)EnumNamesFunc, 0);

    return TRUE;
}

//    FUNCTION: EnumNamesFunc(HANDLE, LPSTR, LPSTR, LONG)
//
//    PURPOSE:  Resource name callback
BOOL EnumNamesFunc(HANDLE hModule,LPCTSTR lpType,LPTSTR lpName,LONG lParam)
{
    size_t cbString;
   HRESULT hResult;

     // Write the resource name to a resource information file.
     // The name may be a string or an unsigned decimal
     // integer, so test before printing.
    if ((ULONG)lpName & 0xFFFF0000)
    {
      hResult = wsprintf(szBuffer,  "\tName: %s\n", lpName);
      if (FAILED(hResult))
      {
         return;
      }
    }
    else
    {
      hResult = wsprintf(szBuffer,  "\tName: %u\n", (USHORT)lpName);
      if (FAILED(hResult))
      {
         return;
      }
    }
   cbString = strlen(szBuffer);
   if (FAILED(hResult))
      {
         return;
      }

    WriteFile(hFile, szBuffer, (DWORD) cbString, &cbWritten, NULL);
    // Find the languages of all resources of type
    // lpType and name lpName.
    EnumResourceLanguages(hModule, lpType, lpName, (ENUMRESLANGPROC)EnumLangsFunc, 0);
    return TRUE;
}

//    FUNCTION: EnumLangsFunc(HANDLE, LPSTR, LPSTR, WORD, LONG)
//
//    PURPOSE:  Resource language callback
BOOL EnumLangsFunc( HANDLE hModule, LPCTSTR lpType, LPCTSTR lpName, WORD wLang, LONG lParam )
{
    HANDLE hResInfo;
    char szBuffer[80];
    size_t cbString = 0;
   HRESULT hResult;

    hResInfo = FindResourceEx(hModule, lpType, lpName, wLang);
    // Write the resource language to the resource information file.
   hResult = wsprintf(szBuffer,  "\t\tLanguage: %u\n", (USHORT) wLang);
   if (FAILED(hResult))
   {
      // Add code to fail as securely as possible.
         return;
   }
   cbString = strlen(szBuffer);
   if (FAILED(hResult))
      {
      // Add code to fail as securely as possible.
         return;
      }
//    cbString = sprintf(szBuffer, "\t\tLanguage: %u\n", (USHORT)wLang);
    WriteFile(hFile, szBuffer, (DWORD) cbString,
        &cbWritten, NULL);
    // Write the resource handle and size to buffer.
    cbString = sprintf(szBuffer,
        "\t\thResInfo == %lx,  Size == %lu\n\n",
        hResInfo,
        SizeofResource(hModule, hResInfo));
    WriteFile(hFile, szBuffer, (DWORD) cbString,
        &cbWritten, NULL);
    return TRUE;
}






#pragma ENDDUMP

