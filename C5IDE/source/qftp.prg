#include "fivewin.ch"
#include "common.ch"
#include "qftp.ch"
#include "Constant.ch"

//#define BLOCK_SIZE 10240
#define BLOCK_SIZE 1024

static aCodes := {}
static aDesc  := {}
static oFtp



CLASS qFTPClient

  DATA oSocket       AS OBJECT INIT nil
  DATA oTrnSocket    AS OBJECT INIT nil
  DATA cServer       AS CHARACTER INIT ""
  DATA cServerIP     AS CHARACTER INIT ""
  DATA cUser         AS CHARACTER INIT ""
  DATA cPass         AS CHARACTER INIT ""
  DATA cBuffer       AS CHARACTER INIT ""
  DATA cLastCmd      AS CHARACTER INIT ""
  DATA cReply        AS CHARACTER INIT ""
  DATA cDirBuffer    AS CHARACTER INIT ""
  DATA cDataIP       AS CHARACTER INIT ""

  DATA nPort         AS NUMERIC INIT 21
  DATA nDataPort     AS NUMERIC INIT 21

  DATA nStatus       AS NUMERIC INIT 0
  DATA nRetrHandle   AS NUMERIC INIT 0

  DATA bResolving    AS Codeblock init nil
  DATA bResolved     AS Codeblock init nil
  DATA bDump         AS Codeblock init nil
  DATA bAbort        AS Codeblock init nil
  DATA bStorProg     AS Codeblock init nil

  DATA lResolved     AS Logical Init .F.
  DATA lConnected    AS Logical Init .F.
  DATA lClosed       AS Logical Init .F.
  DATA lSent         AS Logical Init .F.
  DATA lSendFile     AS Logical Init .F.
  DATA lPassive      AS Logical Init .F.
  DATA lSentUser     AS Logical Init .F.

  DATA acDir         AS Array
  DATA acReply       AS Array
  DATA acAllReply    AS Array

  DATA nRetrFSize    AS NUMERIC INIT 0
  DATA nRetrBRead    AS NUMERIC INIT 0

  DATA nTimeOut      AS NUMERIC INIT 20

  DATA aItems        AS Array

  METHOD New(pcServer, pnPort, pbDump, bAbort, pcUser, pcPass)    CONSTRUCTOR
  METHOD End()
  METHOD Connect()
  METHOD OnConnect()
  METHOD OnRead()
  METHOD OnClose()
  METHOD Port()
  METHOD Cd(pcPath)
  METHOD Pwd()
  METHOD XfrType(pcType)
  METHOD Stor(pcLocal, pcRemote, pbStorProg, oMeter)
  METHOD StorAccept()
  METHOD StorClose()
  METHOD Dir(pcLoc)
  METHOD DirAccept()
  METHOD DirRead()
  METHOD DirClose()
  METHOD Dump()
  METHOD Quit()
  METHOD DoWait()
  METHOD Del(pcFile)
  METHOD Rename(pcFrom, pcTo)
  METHOD MkDir(pcDir)
  METHOD RmDir(pcDir)
  METHOD Retr(pcRemote, pcLocal)
  METHOD RetrAccept()
  METHOD RetrRead()
  METHOD RetrClose()
  METHOD Abort()
  METHOD Pasv()

  METHOD aItems()

ENDCLASS

//---------------------------------------------------------------------------------------------//

METHOD New(pcServer, pnPort, pbDump, bAbort, pcUser, pcPass) CLASS qFTPClient

  /*
   Creates FTP Object

   Parameters : pcServer  : Servername e.g. ftp.microsoft.com or 207.46.133.140
                pnPort    : Server FTP Port. Defaults to 21
                pbDump    : Codeblock to send all commands sent, and replies received to. Useful for logging, etc.
                bAbort    : Codeblock, which if eval's to True, will abort any current waiting process.
                pcUser    : User name to log-in with
                pcPass    : Password to log-in with

  */

  DEFAULT pcServer := "10.1.1.2"
  DEFAULT pnPort := 21
  DEFAULT bAbort := {|| .f.}
  DEFAULT pcUser := "anonymous"
  DEFAULT pcPass  := "fwuser@fivetech.com"

  ::cServer    := pcServer
  ::nPort      := pnPort
  ::bAbort     := bAbort

  ::bDump      := pbDump

  ::acDir      := {}
  ::acReply    := {}
  ::acAllReply := {}

  ::cUser      := pcUser
  ::cPass      := pcPass

  if empty( aCodes )
     BuildCodeArrs()
  endif

return self

//---------------------------------------------------------------------------------------------//

METHOD Dump(pcMsg) CLASS qFTPClient

  if ValType(::bDump) == "B" .and. ValType(pcMsg) == "C"
    Eval(::bDump, pcMsg)
  endif

return nil

//---------------------------------------------------------------------------------------------//

METHOD Connect() CLASS qFTPClient

  local nReturn
  LOCAL lOK     := .t.

  ::lResolved := .F.

  ::oSocket := TSocket():New(0)

  if Val(::cServer) > 0
    ::cServerIP := ::cServer
    if ValType(::bResolved) == "B"
      Eval(::bResolved, Self)
    endif
    ::lResolved := .T.

  else
    if ValType(::bResolving) == "B"
      Eval(::bResolving, Self)
    endif

    ::lResolved := .f.

    ::cServerIP := GetHostByName(Alltrim(::cServer))  // PK Note this hogs the pc for up to 35 seconds if it cannot be resolved

    if Val(::cServerIP) == 0

      //MsgAlert("Could not resolve server name '" + ::cServer + "'", ::cTitle)
    else
      if ValType(::bResolved) == "B"
        Eval(::bResolved, Self)
      endif
      ::lResolved := .T.
    endif
  endif

  if ::lResolved

    ::oSocket:bConnect := {|oSocket| ::OnConnect(oSocket)}
    ::oSocket:bRead    := {|oSocket| ::OnRead(oSocket)}
    ::oSocket:bClose   := {|oSocket| ::OnClose(oSocket)}

    ::nStatus := ST_CONNECTING

    ::oSocket:Connect(::cServerIP, ::nPort)

    ::DoWait(ST_CONNECTING)

    lOK := ::nStatus == ST_CONNECTED
  endif

return lOk

//---------------------------------------------------------------------------------------------//

METHOD OnConnect(poSocket) CLASS qFTPClient

  If Val(poSocket:ClientIP()) == 0
    ::lConnected := .F.
    ::nStatus := ST_CONNECTERR
  endif

return nil

//---------------------------------------------------------------------------------------------//

METHOD OnRead(poSocket) CLASS qFTPClient

  local cData := ""
  local nPos  := 0
  local cCmd  := ""
  local ni

  cData := poSocket:GetData()

  ::cBuffer += cData

  nPos := At(CRLF, ::cBuffer)

  Do While nPos > 0 .and. !Eval(::bAbort)
    AAdd(::acReply   , Left(::cBuffer, nPos - 1))
    AAdd(::acAllReply, Left(::cBuffer, nPos - 1))
    ::cBuffer := Substr(::cBuffer, nPos + 2)
    nPos := At(CRLF, ::cBuffer)
  Enddo

  If Len(::acReply) > 0
    cCmd := Left(::acReply[1], 3)
  else
    cCmd := "zzz"
  endif

  nPos := Ascan(::acReply, {| cReply | Left(cReply, 4) == cCmd + " "})

  If nPos > 0
    // Full reply received


    // Aeval(::acReply, {| cReply | ::Dump("R:" + NTRIM(::nStatus) + ":" + cReply)})

    Aeval(::acReply, {| cReply | ::Dump("R:" + CodeDesc(::nStatus) + ":" + cReply)})

    ::cReply := ATail(::acReply)
    cCmd := Left(::acReply[1], 3)
    ::acReply := {}

    Do Case
      Case ::nStatus == ST_CONNECTING
        Do Case
          Case cCmd == "220"
            // Ready for user
            poSocket:SendData("USER " + Alltrim(::cUser) + CRLF)
            ::Dump("S:USER " + Alltrim(::cUser))
            ::lSentUser := .t.
          Case cCmd == "331"
            poSocket:SendData("PASS " + Alltrim(::cPass) + CRLF)
            ::Dump("S:PASS " + replicate("*",len( ::cPass) ))
          Case cCmd == "230"
            ::nStatus := ST_CONNECTED
            ::lConnected := .T.
          Otherwise
            ::nStatus := ST_CONNECTERR
        EndCase
      Case ::nStatus == ST_DOCWD
        Do Case
          Case cCmd == "250" // OK
            ::nStatus := ST_DONECWD
          Otherwise
            ::nStatus := ST_CWDERROR
        EndCase
      Case ::nStatus == ST_DOQUIT
        Do Case
          Case cCmd == "221"
            ::nStatus := ST_QUITOK
            ::lConnected := .f.
          Otherwise
            ::nStatus := ST_QUITBAD
        EndCase
      Case ::nStatus == ST_DODELETE
        Do Case
          Case cCmd == "250" // OK
            ::nStatus := ST_DELETEOK
          Otherwise
            ::nStatus := ST_DELETEBAD
        EndCase

      Case ::nStatus == ST_DOPWD
        Do Case
          Case cCmd == "257" // OK
            ::nStatus := ST_DONEPWD
          Otherwise
            ::nStatus := ST_PWDERROR
        EndCase

      Case ::nStatus == ST_DOPORT
        Do Case
          Case cCmd == "200" // OK
            ::nStatus := ST_PORTOK
          Otherwise
            ::nStatus := ST_PORTBAD
        EndCase

      Case ::nStatus == ST_DOTYPE
        Do Case
          Case cCmd == "200" // OK
            ::nStatus := ST_TYPEOK
          Otherwise
            ::nStatus := ST_TYPEBAD
        EndCase

      Case ::nStatus == ST_DOSTOR
        Do Case
          Case cCmd == "150"
            ::nStatus := ST_STOROK
            ::lSendFile := .t.
          Otherwise
            ::nStatus := ST_STORBAD
        EndCase

      Case ::nStatus == ST_STOROK
        Do Case
          Case cCmd == "226" // OK
            ::nStatus := ST_STORDONE
          Otherwise
            ::nStatus := ST_STORBAD
        EndCase

      Case ::nStatus == ST_DOPASV
        Do Case
          Case cCmd == "227" // OK
            ::nStatus := ST_PASVOK
          Otherwise
            ::nStatus := ST_PASVBAD
        EndCase
      Case ::nStatus == ST_DODIR
        Do Case
          Case cCmd == "150"
            ::nStatus := ST_DIROK
          Otherwise
            ::nStatus := ST_DIRBAD
        EndCase
      Case ::nStatus == ST_DIROK .or. ::nStatus == ST_DIRREADY
        Do Case
          Case cCmd == "226"
            ::nStatus := ST_DIRDONE
          Otherwise
            ::nStatus := ST_DIRBAD
        EndCase
      Case ::nStatus == ST_DORETR
        Do Case
          Case cCmd == "150"
            ::nStatus := ST_RETROK
          Otherwise
            ::nStatus := ST_RETRBAD
        EndCase
      Case ::nStatus == ST_RETROK
        Do Case
          Case cCmd == "226"
            ::nStatus := ST_RETRDONE
          Otherwise
            ::nStatus := ST_RETRBAD
        EndCase
      Case ::nStatus == ST_DORENFROM
        Do Case
          Case cCmd == "350"
            ::nStatus := ST_RENFROMOK
          Otherwise
            ::nStatus := ST_RENFROMBAD
        EndCase
      Case ::nStatus == ST_DORENTO
        Do Case
          Case cCmd == "250"
            ::nStatus := ST_RENTOOK
          Otherwise
            ::nStatus := ST_RENTOBAD
        EndCase
      Case ::nStatus == ST_DOQUIT
        Do Case
          Case cCmd == "221" // OK
            ::nStatus := ST_QUITOK
          Otherwise
            ::nStatus := ST_QUITBAD
        EndCase
      Case ::nStatus == ST_DOMKDIR
        Do Case
          Case cCmd == "257" // OK
            ::nStatus := ST_MKDIROK
          Otherwise
            ::nStatus := ST_MKDIRBAD
        EndCase
      Case ::nStatus == ST_DOABOR
        Do Case
          Case cCmd  == "225" // OK
            ::nStatus := ST_ABOROK
          Otherwise
            ::nStatus := ST_ABORBAD
        EndCase
      Case ::nStatus == ST_DORMDIR
        Do Case
          Case cCmd == "250" // OK
            ::nStatus := ST_RMDIROK
          Otherwise
            ::nStatus := ST_RMDIRBAD
        EndCase
      Case cCmd == "530"
        ::lConnected := .f.

      Otherwise
        ::Dump("E:Unknown exception on cmd " + cCmd + " status " + NTRIM(::nStatus))
        // B Hopp, 08/10/2001
        ::Dump("E:All replys from server follow...")
        ::Dump(" ")
        FOR nI := 1 TO LEN(::acAllReply)
            ::Dump("E:" + ::acAllReply[nI])
        NEXT
    EndCase

    nPos := At(CRLF, ::cBuffer)

  Endif


return nil

//---------------------------------------------------------------------------------------------//

METHOD Dir(pcLoc) CLASS qFTPClient

  local lOK       := .t.
  local cPort     := ""
  local nPos      := 0
  local cLine     := ""
  local cSepChar := ""

  DEFAULT pcLoc := ""

  ::acDir := {}
  ::cDirBuffer := ""

  ::oTrnSocket := TSocket():New(0)

  if !::lPassive
    cPort := ::Port(::oTrnSocket)

    ::oTrnSocket:bAccept := { | poSocket | ::DirAccept(poSocket:nSocket)}
    ::oTrnSocket:Listen()

    ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))

    ::nStatus := ST_DOPORT
    ::Dump("S:" + cPort)

    ::oSocket:SendData(cPort + CRLF)

    Do While ::nStatus == ST_DOPORT .and. !::lClosed .and. !Eval(::bAbort)
      SysRefresh()
    Enddo

    if ::nStatus <> ST_PORTOK
      ::Dump("737 from byron")
      lOK := .f.
    endif
  else
    if ::Pasv()
      if ::nDataPort > 0
        ::oTrnSocket:bConnect := { | poSocket | ::DirAccept(poSocket)}
        ::oTrnSocket:bRead   := { | poSocket | ::DirRead  (poSocket)}
        ::oTrnSocket:bClose  := { | poSocket | ::DirClose (poSocket)}
        ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
        ::oTrnSocket:Connect(::cDataIP, ::nDataPort)

        lOK := .t.
      else
        ::Dump("751 from byron")
        lOK := .f.
      endif
    endif
  endif


  if lOK
    ::nStatus := ST_DODIR
    ::Dump("S:" + RTrim("LIST " + pcLoc) + CRLF)

    ::oSocket:SendData(RTrim("LIST " + pcLoc) + CRLF)


    ::DoWait(ST_DODIR)

    ::DoWait(ST_DIROK)

    if ::nStatus == ST_DIRDONE .or. ::nStatus == ST_DIRREADY
      ::DoWait(ST_DIRDONE)
      if ::nStatus == ST_DIRREADY
        ::Dump("I:Interpreting dir listing.")
        cSepChar := CRLF
        nPos := At(cSepChar, ::cDirBuffer)
        If nPos == 0
          cSepChar := Chr(10)
        Endif
        ::acDir := {}
        Do While nPos > 0 .and. !Eval(::bAbort)

          cLine := Alltrim(Left(::cDirBuffer, nPos - 1))
          ::cDirBuffer := Substr(::cDirBuffer, nPos + Len(cSepChar))
          cLine := Alltrim(StrTran(cLine, Chr(0), ""))

          AAdd(::acDir, cLine)

          nPos := At(cSepChar, ::cDirBuffer)
          SysRefresh()
        Enddo
      else
      ::Dump("791 from byron")
        lOK := .f.
        ::Abort()
        ::oTrnSocket:End()
      endif
    else
      ::Dump("797 from byron")
      lOK := .f.
      ::Abort()
      ::oTrnSocket:End()
    endif
  endif

return lOK

*************************************************************************************************
  METHOD aItems() CLASS QFTPClient
*************************************************************************************************
local aItems := {}
local cLine, n
local cName
local cSize
local dDateTime
local cAttributes


if empty( ::acDir )
   return nil
endif

aadd( aItems, {"..", 0, "", " ", "D"} )
for n := 1 to len( ::acDir )
    cLine       := ::acDir[n]
    cName       := substr( cLine, 56 )
    nSize       := val(substr( cLine, 55-23, 10 ))
    dDateTime   := substr( cLine, 55-12, 12 )
    cAttributes := if( left( cLine, 1 ) == "d","D"," ")
    aadd( aItems, {cName, cSize, dDateTime, " ", cAttributes} )
next

return aItems


//---------------------------------------------------------------------------------------------//

METHOD DirAccept(pSocket) CLASS qFTPClient


  local oSocket

  if !::lPassive
    oSocket := TSocket():Accept(pSocket)
    oSocket:bRead   := { | poSocket | ::DirRead  (poSocket)}
    oSocket:bClose  := { | poSocket | ::DirClose (poSocket)}
  endif
  ::Dump("I:Dir data connection established")

return nil

//---------------------------------------------------------------------------------------------//

METHOD DirRead(poSocket) CLASS qFTPClient

  local cData := poSocket:GetData()

  ::cDirBuffer += cData

  ::Dump("I:Dir data received")

return nil

//---------------------------------------------------------------------------------------------//

METHOD DirClose(poSocket) CLASS qFTPClient

  ::Dump("I:Dir Data Socket closed")
  ::nStatus := ST_DIRREADY
  ::Dump("R:" + CRLF + ::cDirBuffer)
  poSocket:Close()
return nil

//---------------------------------------------------------------------------------------------//


METHOD OnClose(poSocket) CLASS qFTPClient

  ::Dump("I:Server closed down")

  ::lClosed := .T.

  ::nStatus := ST_CLOSED

  ::oSocket:Close()

  If ValType(::oTrnSocket) == "O"
    ::oTrnSocket:Close()
  endif

return nil

//---------------------------------------------------------------------------------------------//

METHOD End() CLASS qFTPClient

  ::oSocket:End()

  If ValType(::oTrnSocket) == "O"
    ::oTrnSocket:End()
  endif

return nil

//---------------------------------------------------------------------------------------------//

METHOD Port( oTransSocket ) CLASS qFTPClient

   local cIp := GetIp( ::oSocket:nSocket )
   local nPort
   local cPort
   local cComplement

   BindToPort( oTransSocket:nSocket, 0 )    // Get a free port from 1024 - 5000

   nPort       := GetPort( oTransSocket:nSocket )
   cPort       := AllTrim( Str( Int( nPort / 256 ), 3 ) )
   cComplement := AllTrim( Str( Int( nPort % 256 ), 3 ) )

   oTransSocket:nPort := nPort

return ("PORT " + StrTran( AllTrim( StrTran( cIp, ".", "," ) ) + ;
       "," + cPort + "," + cComplement, " ", "" ))

//---------------------------------------------------------------------------------------------//

METHOD Cd(pcPath) CLASS qFTPClient

  local lOK := .t.

  ::nStatus := ST_DOCWD

  ::oSocket:SendData("CWD " + pcPath + CRLF)

  ::Dump("S:CWD " + pcPath)

  ::DoWait(ST_DOCWD)

  lOK := ::nStatus == ST_DONECWD

return lOK

//---------------------------------------------------------------------------------------------//

METHOD XfrType(pcType) CLASS qFTPClient

  local lOK := .t.

  DEFAULT pcType := "I"

  ::nStatus := ST_DOTYPE

  ::oSocket:SendData("TYPE " + pcType + CRLF)

  ::Dump("S:TYPE " + pcType)

  ::DoWait(ST_DOTYPE)

  lOK := ::nStatus == ST_TYPEOK

return lOK

//---------------------------------------------------------------------------------------------//

METHOD Stor(pcLocal, pcRemote, pbStorProgress,oMeter) CLASS qFTPClient

  local cRemFile  := ""
  local nPos      := 0
  local cPort     := ""
  local lOK       := True

  DEFAULT pcRemote := ""

  DEFAULT pbStorProgress := {|| nil }

  ::bStorProg := pbStorProgress

  ::lSendFile := False
  if Empty(pcRemote)
    if (nPos := RAt('\', pcLocal)) > 0
      cRemFile := Substr(pcLocal, nPos + 1)
    else
      cRemFile := pcLocal
    endif
  else
    cRemFile := pcRemote
  endif

  if lOK
    ::XfrType("I")

    Do While ::nStatus == ST_DOTYPE .and. !::lClosed .and. !Eval(::bAbort)
      SysRefresh()
    Enddo

    if ::nStatus <> ST_TYPEOK
      lOK := False
    endif
  endif

  if lOK
    ::oTrnSocket := TSocket():New(0)

    if !::lPassive
      cPort := ::Port(::oTrnSocket)
      ::oTrnSocket:bAccept := { | poSocket | ::StorAccept(poSocket:nSocket, pcLocal,oMeter)}
      ::oTrnSocket:Listen()
      ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))

      ::nStatus := ST_DOPORT

      ::oSocket:SendData(cPort + CRLF)
      ::Dump("S:" + cPort)

      Do While ::nStatus == ST_DOPORT .and. !::lClosed .and. !Eval(::bAbort)
        SysRefresh()
      Enddo

      if ::nStatus <> ST_PORTOK
        lOK := False
      endif
    else
      if ::Pasv()
        if ::nDataPort > 0
          ::oTrnSocket:bConnect := { | poSocket | ::StorAccept(poSocket, pcLocal,oMeter)}
          ::oTrnSocket:bClose  := { | poSocket | ::StorClose (poSocket,oMeter)}
          ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
          ::oTrnSocket:Connect(::cDataIP, ::nDataPort)

          lOK := True
        else
          lOK := False
        endif
      endif
    endif
  endif


  if lOk
    ::nStatus := ST_DOSTOR
    ::Dump("S:STOR " + cRemFile)
    ::oSocket:SendData("STOR " + cRemFile + CRLF)

    ::DoWait(ST_DOSTOR)
    ::DoWait(ST_STOROK)

    if ::nStatus <> ST_STORDONE
      lOK := False
      ::Abort()
      ::oTrnSocket:End()
    endif
  endif

return lOK

//---------------------------------------------------------------------------------------------//

METHOD StorAccept(pSocket, pcFile, oMeter) CLASS qFTPClient

  local oSocket := NIL
  local hFile   := 0
  local cBuffer := ""
  local nSent   := 0
  local nTotal  := 0
  local lClosed := False
  local nNow      := 0
  local nSize

  IF !::lPassive
     oSocket := TSocket():Accept(pSocket)
     oSocket:bClose  := {| poSocket | ::StorClose(poSocket), lClosed := True}
  else
    oSocket := pSocket
  Endif


  Do While !::lSendFile .and. !::lClosed .and. !Eval(::bAbort)
    SysRefresh()
  Enddo


  if ::lSendfile
    ::Dump("I:Store data connection established")

    nNow := Seconds()
    hFile := FOpen(pcFile)
    if hFile > 0
      nSize := Directory(pcFile)[1,2]
      Do While True
        cBuffer := Space(BLOCK_SIZE)
        nSent := FRead(hFile, @cBuffer, BLOCK_SIZE)
        cBuffer := Left(cBuffer, nSent)
        oSocket:SendData(cBuffer)
        nTotal += nSent

        Eval(::bStorProg, Round(nTotal / nSize * 100, 2))

        if nSent < BLOCK_SIZE .or. lClosed .or. Eval(::bAbort)
          Exit
        endif
        SysRefresh()

      Enddo
      FClose(hFile)
      ::Dump("I:" + NTRIM(nTotal) + " bytes of file sent in " + LTrim(Str(Seconds() - nNow, 16, 2)) + " seconds. Closing socket")
      ::Dump("I:Waiting for acknowledgement ")

      oSocket:Close()
    else
      oSocket:Close()
      oSocket:End()
    endif
    SysRefresh()
  endif

return nil

//---------------------------------------------------------------------------------------------//

METHOD StorClose(poSocket) CLASS qFTPClient

  ::Dump("I:Store socket closed")
  poSocket:Close()

return nil

//---------------------------------------------------------------------------------------------//

METHOD Quit() CLASS qFTPClient

  local lRetVal := .t.

  ::Dump("S:QUIT")
  ::nStatus := ST_DOQUIT
  ::oSocket:SendData("QUIT" + CRLF)

  ::DoWait(ST_DOQUIT)
return lRetVal

//---------------------------------------------------------------------------------------------//

METHOD Pwd() CLASS qFTPClient

  local cRetVal := ""
  local nPos := ""
  local cReply

  ::nStatus := ST_DOPWD

  ::Dump(":SPWD")

  ::oSocket:SendData("PWD" + CRLF)

  ::DoWait(ST_DOPWD)

  cReply := ::cReply

  nPos := At('"', cReply)

  cReply := Substr(cReply, nPos + 1)

  nPos := At('"', cReply)

  cReply := Substr(cReply, 1, nPos - 1)

  cRetVal := cReply

return cRetVal

//---------------------------------------------------------------------------------------------//

METHOD Del(pcFile) CLASS qFTPClient

  local lOK := .t.

  DEFAULT pcFile := ""

  ::nStatus := ST_DODELETE

  if !Empty(pcFile)
    ::Dump("S:DELE " + pcFile)
    ::oSocket:SendData("DELE " + pcFile + CRLF)
    ::DoWait(ST_DODELETE)

    lOK := ::nStatus == ST_DELETEOK
  else
    lOK := .f.
  endif

return lOK

//---------------------------------------------------------------------------------------------//

METHOD Rename(pcFrom, pcTo) CLASS qFTPClient

  local lOK := .t.

  DEFAULT pcFrom := ""
  DEFAULT pcTo   := ""

  if Empty(pcFrom) .or. Empty(pcTo)
    lOK := .f.
  else
    ::nStatus := ST_DORENFROM
    ::Dump("S:RNFR " + pcFrom)
    ::oSocket:SendData("RNFR " + pcFrom + CRLF)

    ::DoWait(ST_DORENFROM)

    if ::nStatus == ST_RENFROMOK
      ::nStatus := ST_DORENTO
      ::Dump("S:RNTO " + pcTo)
      ::oSocket:SendData("RNTO " + pcTo + CRLF)

      ::DoWait(ST_DORENTO)

      lOK := ::nStatus == ST_RENTOOK
    else
      lOK := .f.
    endif
  endif

return lOk

//---------------------------------------------------------------------------------------------//

METHOD MkDir(pcDir) CLASS qFTPClient

  local lOK := .t.

  ::nStatus := ST_DOMKDIR

  ::Dump("S:MKD " + pcDir)

  ::oSocket:SendData("MKD " + pcDir + CRLF)

  ::DoWait(ST_DOMKDIR)

  lOK := ::nStatus == ST_MKDIROK

return lOK

//---------------------------------------------------------------------------------------------//

METHOD RmDir(pcDir) CLASS qFTPClient

  local lOK := .t.

  ::nStatus := ST_DORMDIR

  ::Dump("S:RMD " + pcDir)

  ::oSocket:SendData("RMD " + pcDir + CRLF)

  ::DoWait(ST_DORMDIR)

  lOK := ::nStatus == ST_RMDIROK

return lOK

//---------------------------------------------------------------------------------------------//

METHOD Abort() CLASS qFTPClient

  local lOK := .t.

  ::nStatus := ST_DOABOR

  ::Dump("S:ABOR")

  ::oSocket:SendData("ABOR" + CRLF)

  ::DoWait(ST_DOABOR)

  lOK := ::nStatus == ST_ABOROK

return lOK

//---------------------------------------------------------------------------------------------//

METHOD Pasv CLASS qFTPClient

  local lOK     := .t.
  local cReply  := ""
  local nPos    := 0

  ::nStatus := ST_DOPASV

  ::Dump("S:PASV")

  ::oSocket:SendData("PASV" + CRLF)

  ::DoWait(ST_DOPASV)

  if (lOK := ::nStatus == ST_PASVOK)
    ::lPassive := .t.
    cReply := ::cReply
    nPos := At('(', cReply)

    cReply := Substr(cReply, nPos + 1)

    nPos := At(')', cReply)

    cReply := Left(cReply, nPos - 1)

    ::cDataIP := StrToken(cReply, 1, ",") + "."
    ::cDataIP += StrToken(cReply, 2, ",") + "."
    ::cDataIP += StrToken(cReply, 3, ",") + "."
    ::cDataIP += StrToken(cReply, 4, ",")

    ::nDataPort := 0

    ::nDataPort += 256 * Val(StrToken(cReply, 5, ","))

    ::nDataPort += Val(StrToken(cReply, 6, ","))
    ::Dump("I: Server has opened connection on port " + NTRIM(::nDataport))

  else
    lOK := .f.
  endif

return lOK

//---------------------------------------------------------------------------------------------//
METHOD DoWait(pnState) CLASS qFTPClient
local IniTime := Seconds()

* Do While ::nStatus == pnState .and. !::lClosed .and. !Eval(::bAbort)

  Do While .t.

     IF pnState = ST_RETROK
        IF ::lClosed .OR. Eval(::bAbort)
           EXIT
        ENDIF
        IF ::nRetrFSize = ::nRetrBRead
           EXIT
        ENDIF
      ELSEIF ::nStatus <> pnState .OR. ::lClosed .OR. Eval(::bAbort)
        EXIT
     ENDIF

     if Seconds() - IniTime > ::nTimeOut
        IF pnState <> ST_RETROK
           exit
        ENDIF
     endif

     SysRefresh()
  Enddo

  if pnState <> ST_DOABOR
    if Eval(::bAbort)
      ::Abort()
    endif
  endif

return nil

//---------------------------------------------------------------------------------------------//

FUNCTION NTRIM(n)
    LOCAL cRV := ALLTRIM(STR(n))
RETURN cRV

static function CodeDesc(nCode)

    local nEle := ascan(aCodes,nCode)
    local cRV  := "N/A          "

    if nEle > 0
        cRV := aDesc[nEle]
    endif

return cRV

static function BuildCodeArrs()

    aadd(aDesc,"ST_CLOSED     ");aadd(aCodes,0)
    aadd(aDesc,"ST_CONNECTING ");aadd(aCodes,1)
    aadd(aDesc,"ST_CONNECTED  ");aadd(aCodes,2)
    aadd(aDesc,"ST_CONNECTERR ");aadd(aCodes,3)

    aadd(aDesc,"ST_DOCWD      ");aadd(aCodes,4)
    aadd(aDesc,"ST_DONECWD    ");aadd(aCodes,5)
    aadd(aDesc,"ST_CWDERROR   ");aadd(aCodes,6)

    aadd(aDesc,"ST_DOTYPE     ");aadd(aCodes,7)
    aadd(aDesc,"ST_TYPEOK     ");aadd(aCodes,8)
    aadd(aDesc,"ST_TYPEBAD    ");aadd(aCodes,9)

    aadd(aDesc,"ST_DOPORT     ");aadd(aCodes,0)
    aadd(aDesc,"ST_PORTOK     ");aadd(aCodes,1)
    aadd(aDesc,"ST_PORTBAD    ");aadd(aCodes,2)

    aadd(aDesc,"ST_DOSTOR     ");aadd(aCodes,3)
    aadd(aDesc,"ST_STOROK     ");aadd(aCodes,4)
    aadd(aDesc,"ST_STORBAD    ");aadd(aCodes,5)
    aadd(aDesc,"ST_STORDONE   ");aadd(aCodes,6)

    aadd(aDesc,"ST_DOPASV     ");aadd(aCodes,7)
    aadd(aDesc,"ST_PASVOK     ");aadd(aCodes,8)
    aadd(aDesc,"ST_PASVBAD    ");aadd(aCodes,9)

    aadd(aDesc,"ST_DOQUIT     ");aadd(aCodes,0)
    aadd(aDesc,"ST_QUITOK     ");aadd(aCodes,1)
    aadd(aDesc,"ST_QUITBAD    ");aadd(aCodes,2)

    aadd(aDesc,"ST_DODIR      ");aadd(aCodes,3)
    aadd(aDesc,"ST_DIROK      ");aadd(aCodes,4)
    aadd(aDesc,"ST_DIRBAD     ");aadd(aCodes,5)
    aadd(aDesc,"ST_DIRDONE    ");aadd(aCodes,6)
    aadd(aDesc,"ST_DIRREADY   ");aadd(aCodes,2)

    aadd(aDesc,"ST_DOPWD      ");aadd(aCodes,7)
    aadd(aDesc,"ST_DONEPWD    ");aadd(aCodes,8)
    aadd(aDesc,"ST_PWDERROR   ");aadd(aCodes,9)

    aadd(aDesc,"ST_DORENFROM  ");aadd(aCodes,0)
    aadd(aDesc,"ST_RENFROMOK  ");aadd(aCodes,1)
    aadd(aDesc,"ST_RENFROMBAD ");aadd(aCodes,2)
    aadd(aDesc,"ST_DORENTO    ");aadd(aCodes,3)
    aadd(aDesc,"ST_RENTOOK    ");aadd(aCodes,4)
    aadd(aDesc,"ST_RENTOBAD   ");aadd(aCodes,5)

    aadd(aDesc,"ST_DODELETE   ");aadd(aCodes,6)
    aadd(aDesc,"ST_DELETEOK   ");aadd(aCodes,7)
    aadd(aDesc,"ST_DELETEBAD  ");aadd(aCodes,8)

    aadd(aDesc,"ST_DOMKDIR    ");aadd(aCodes,9)
    aadd(aDesc,"ST_MKDIROK    ");aadd(aCodes,0)
    aadd(aDesc,"ST_MKDIRBAD   ");aadd(aCodes,1)

    aadd(aDesc,"ST_DORETR     ");aadd(aCodes,2)
    aadd(aDesc,"ST_RETROK     ");aadd(aCodes,3)
    aadd(aDesc,"ST_RETRBAD    ");aadd(aCodes,4)
    aadd(aDesc,"ST_RETRDONE   ");aadd(aCodes,5)

    aadd(aDesc,"ST_DOABOR     ");aadd(aCodes,6)
    aadd(aDesc,"ST_ABOROK     ");aadd(aCodes,7)
    aadd(aDesc,"ST_ABORBAD    ");aadd(aCodes,8)

    aadd(aDesc,"ST_DORMDIR    ");aadd(aCodes,9)
    aadd(aDesc,"ST_RMDIROK    ");aadd(aCodes,0)
    aadd(aDesc,"ST_RMDIRBAD   ");aadd(aCodes,1)
return nil

METHOD Retr(pcRemote, pcLocal, nRetrFsize, oMeter) CLASS qFTPClient

  local lOK       := True
  local cPort     := ""
  local nPos      := 0
  local cLine     := ""
  local nNow      := 0

  // ::Dir(pcRemote)

  ::nRetrFsize := nRetrFsize

  nPos := Rat('/', pcRemote)
  if nPos == 0
    DEFAULT pcLocal := pcRemote
  else
    DEFAULT pcLocal := Substr(pcRemote, nPos + 1)
  endif

  ::nRetrHandle := FCreate(pcLocal)
  if ::nRetrHandle > 0

    lOK := ::XfrType("I")
    if lOK
      ::oTrnSocket := TSocket():New(0)

      if !::lPassive
        cPort := ::Port(::oTrnSocket)

        ::oTrnSocket:bAccept := { | poSocket | ::RetrAccept(poSocket:nSocket,oMeter)}
        ::oTrnSocket:Listen()

        ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))

        ::nStatus := ST_DOPORT
        ::Dump("S:" + cPort)

        ::oSocket:SendData(cPort + CRLF)

        ::DoWait(ST_DOPORT)
        if ::nStatus <> ST_PORTOK
          lOK := False
        endif
      else
        if ::Pasv()
          if ::nDataPort > 0
            ::oTrnSocket:bConnect := { | poSocket | ::RetrAccept(poSocket,oMeter)}
            ::oTrnSocket:bRead   := { | poSocket | ::RetrRead  (poSocket,oMeter)}
            ::oTrnSocket:bClose  := { | poSocket | ::RetrClose (poSocket,oMeter)}
            ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
            ::oTrnSocket:Connect(::cDataIP, ::nDataPort)
            lOK := True
          else
            lOK := False
          endif
        endif
      endif
    endif
  else
    lOK := False
  endif

  if lOK
    ::nStatus := ST_DORETR
    ::Dump("S:RETR " + pcRemote)

    ::oSocket:SendData("RETR " + pcRemote + CRLF)
    ::DoWait(ST_DORETR)

    ::DoWait(ST_RETROK)

    lOK := ::nStatus == ST_RETRDONE
    if !lOK
      ::Abort()
      ::oTrnSocket:End()
    endif

  endif

return lOK


//---------------------------------------------------------------------------------------------//


METHOD RetrAccept(pSocket,oMeter) CLASS qFTPClient
  local oSocket := nil
  if !::lPassive
    oSocket := TSocket():Accept(pSocket)
    oSocket:bRead  := {| poSocket | ::RetrRead(poSocket,oMeter)}
    oSocket:bClose  := {| poSocket | ::RetrClose(poSocket,oMeter)}
  endif
  ::Dump("I:Retr data connection established")
return nil

//---------------------------------------------------------------------------------------------//

METHOD RetrRead(poSocket,oMeter) CLASS qFTPClient
   local cData := poSocket:GetData()
   if ::nRetrHandle > 0
       ::nRetrBRead += len(cData)
       FWrite(::nRetrHandle, cData)
       oMeter:Set(::nRetrBRead)
   endif
return nil

//---------------------------------------------------------------------------------------------//

METHOD RetrClose(poSocket,oMeter) CLASS qFTPClient
  ::Dump("I:Retr Data completed")
  FClose(::nRetrHandle)
  //::nStatus := ST_RETRDONE
  poSocket:Close()
return nil




function FindIniNWord( cText, nPalabra )
local nLen
local n := 0
local nWord := 1
local cChar
local lEspacio := .f.
local nEn := 0

nLen := len( cText )

for n := 1 to nLen

    cChar := substr( cText, n, 1 )

    if cChar == " "
       lEspacio := .t.
    else
       if lEspacio
          nWord++
          lEspacio := .f.
          if nWord == nPalabra
             nEn := n
             exit
          endif
       endif
    endif
next

return nEn



FUNCTION FtpGetFile(cRemote,cLocal,cMsg,cTitle, cServer, bFTP, cUser, cPassword )
    DEFAULT cMsg   := "Downloading " + cRemote + " to " + cLocal + "..."
    DEFAULT cTitle := "FTP Get File"
    MsgMeter({|oMeter,oText,oDlg,lEnd,oBtn| FTPGet(cRemote,cLocal,oMeter, cServer, bFTP, cUser, cPassword )},cMsg,cTitle)
RETURN NIL

FUNCTION FtpPutFile( cLocal,cRemote,cMsg,cTitle, cServer, bFTP, cUser, cPassword  )
    DEFAULT cMsg   := "Uploading " + cLocal + " to " + cRemote + "..."
    DEFAULT cTitle := "FTP Put File"
    MsgMeter({|oMeter,oText,oDlg,lEnd,oBtn| FTPPut(cLocal,cRemote,oMeter, cServer, bFTP, cUser, cPassword)},cMsg,cTitle)
RETURN nil

Function FtpFSize(cRemote, cServer, bFTP, cUser, cPassword )
  local cLogFile  := 'dirftp.txt'

  local nSize     := 0
  DEFAULT bFTP      := {|cMessage| Logfile(cLogFile, {cMessage})}
  begin sequence
    Ferase(cLogFile)
    oFTP := qFTPClient():New(cServer, 21,bFTP ,,cUser, cPassword)

    oFTP:lPassive := .F.
    infstat("Connecting to FTP server...")

    if oFTP:Connect()
        infstat("Getting Directory " + cRemote)
        oFTP:DIR(cRemote)
        if len(oFTP:acDir) > 1
            msgstop("This FTP transfer method only allows one file per transfer, no wildcards...","QFTP")
            BREAK
        elseif len(oFtp:acDir) < 1
            msgstop("No valid files found to receive...","QFTP")
            BREAK
        else
            nSize := val(alltrim(substr(oFTP:acDir[1],19,20)))
        endif

        oFTP:Quit()
        oFTP:End()
    else
      Msginfo("Connect failed!")
    endif
  end sequence
return nSize


Function FTPGet(cRemote,cLocal,oMeter, cServer, bFTP, cUser, cPassword )
  local nFileSize := FtpFSize(cRemote, cServer, bFTP, cUser, cPassword)
  local cLogFile  := 'getftp.txt'
  DEFAULT bFTP      := {|cMessage| Logfile(cLogFile, {cMessage})}

  oMeter:SetTotal(nFileSize)

  Ferase(cLogFile)
  oFTP := qFTPClient():New(cServer, 21,bFTP ,,cUser, cPassword)

  oFTP:lPassive := .F.
  //infstat("Connecting to FTP server...")
  eval( bFTP, "Connecting to FTP server...")

  if oFTP:Connect()
     // infstat("Getting file " + cRemote)
      eval( bFTP, "Getting file " + cRemote)
      oFTP:Retr(cRemote,cLocal,oMeter)
      oFTP:Quit()
      oFTP:End()
  else
    Msginfo("Connect failed!")
  endif

return nil

Function FTPPut(cLocal,cRemote,oMeter, cServer, bFTP, cUser, cPassword )
  local cLogFile  := 'putftp.txt'
  //	DEFAULT bFTP      := {|cMessage| Logfile(cLogFile, {cMessage})}

  if oMeter != nil
     oMeter:SetTotal(100)  // were using percent...
  endif

  Ferase(cLogFile)
  oFTP := qFTPClient():New(cServer, 21,bFTP ,,cUser, cPassword)
  oFtp:nTimeOut := 60
  oFTP:lPassive := .T.

  eval( bFTP, "Connecting to FTP server...")

  if oFTP:Connect()
      eval( bFTP, "Putting file " + cLocal)
      oFTP:Stor(cLocal,cRemote,{|n| oMeter:Set(n),SysRefresh()},oMeter)
      oFTP:Quit()
      oFTP:End()
  else
    Msginfo("Connect failed!")
  endif

return nil

FUNCTION InfStat(cMsg,oWnd)
return nil
    // B. Hopp, 12/25/98
    //          Old dos function modified to FiveWin..
    oWnd    := IIF(oWnd == NIL .OR. VALTYPE(oWnd) <> "O",GetWndFrame(),oWnd)
    MsgPaint( oWnd:oMsgBar:hWnd, cMsg, oWnd:oMsgBar:cMsgDef, .t.,                                ;
              oWnd:oMsgBar:lCentered, If( Len( oWnd:oMsgBar:aItem ) > 0, oWnd:oMsgBar:aItem[ 1 ]:nLeft(), 0 ),;
              oWnd:oMsgBar:nClrText, oWnd:oMsgBar:nClrPane, oWnd:oMsgBar:oFont:hFont,                                    ;
              oWnd:oMsgBar:lInset )
RETURN Nil





/*
         111111111122222222223333333333444444444455555555556666666666777777777788888888889
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

-rw-------   1 websrv   web          4048 Jun 18  2004 CXImage Request information .htm
drwx------   2 websrv   web            96 Dec 12 18:12 DAVID
-rw-------   1 websrv   web         29696 Sep 14 21:24 HPIM0169.JPG
-rw-------   1 websrv   web        502272 Jan  9 19:20 HPIM2777.JPG
-rw-------   1 websrv   web          5784 Jun  7  2004 Image1.gif
-rw-------   1 websrv   web         62465 Jul 31  2004 Image2.jpg
-rw-------   1 websrv   web          5614 Jun 18  2004 RE Codemax 2.0 versus Codemax 3.0.htm
-rw-------   1 websrv   web          7893 Feb 28  2004 canalfive_logo.jpg
drwxr-xr-x  11 websrv   web          8192 Jan 18  2005 cgi-bin
drwx------   2 websrv   web            96 Jul 20  2004 fons
-rw-------   1 websrv   web       1008946 Dec 12 17:21 fwfun.chm
drwx------   2 websrv   web            96 Nov  3 18:24 gea
-rw-------   1 websrv   web          3987 Feb 28  2004 index.htm
-rw-------   1 websrv   web          1072 Sep 17 09:17 make.log
-rw-------   1 websrv   web       2030080 Dec 14 01:13 ppcdsgn.exe
-rw-------   1 websrv   web          2444 Jul  8  2004 themes.obj

Tipos de permiso de acceso:
Read (lectura): Permiso para ver el archivo o directorio, sin hacer cambios.

Write (escritura): Permiso de escritura: puede escribir el archivo, y por tanto, cambiarlo.

Execute (ejecución): El archivo o directorio puede ser ejecutado. Se usa para directorios con scripts, formularios, etc ...

Y tratándose de directorios:

read listar los archivos de un directorio

write añadir nuevos archivos al directorio

execute acceder a los archivos del directorio

Como conozco los permisos de un archivo ?
Si tenemos acceso ftp al servidor, tecleamos el comando ls -l y vemos algo asi:

-rw-r--r--   1 irvnet   irvnet       1272 Sep 28 07:31 index.php
| //  /       |         |           |                     |
| | |   |        |         |          tamaño           nombre del archivo
| | |   |        |         |_ nombre grupo
| | |   |        |
| | |   |        |_ nombre usuario
| | |   |
| | |   |_ Permisos genericos
| | |
| | |_ Los siguientes tres digitos los permisos del Group
| |
| |___ los siguientes tres caracteres determinan los permisos del owner:
|      r de real, lectura; w, write, escritura y x de
|       execute, ejecución
|
|
|___ El primer carácter indica si nos encontramos ante un directorio o un
     fichero: d significa directorio, - significa fichero,
     l significa link

Advierte que tenemos TRES categorias de usuarios ("user," "group," y "other") y para categoria pueden asignarse TRES tipos de permisos: "r," "w," y "x".

Fijando permisos
La orden chmod puede usarse con letras o numeros. La forma mas corriente es expresar los permisos numericamente. Seguro que lo has visto por ahi, chmod 777 etc ...
Para comprender el significado tienes que tener en cuenta que convencionalmente 4 significa permiso de lectura. 2 permiso de escritura y 1 permiso de ejecución. Sumando estos valores vemos que un archivo puede tener los siguientes permisos (por cada tipo de usuario):

	4= lectura
	2= escritura
	1= ejecución

	6 (4+2)= lectura y escritura
	5 (4+1)= lectura y ejecución
	3 (2+1)= escritura y ejecución
	7 (4+2+1)= lectura, escritura y ejecución
Todo ello para los tres tipos de usuario.

Asi, un chmod file 777 significa que owner, group y others tienen permiso de lectura, escritura y ejecución. chmod 766 significa que el owner tiene permiso de lectura, escritura y ejecución, y el group y others permiso de lectura y escritura. Chmod 744 significa que el owner tiene permisos de lectura, escritura y ejecución, y group y others unicamente permisos de lectura.

Como ves, son tres digitos, de izquierda a derecha designan los permisos del owner, group y others.

Vemos a continuación su equivalente en letras:

0  =  ---  =  sin acceso
1  =  --x  =  ejecución
2  =  -w-  =  escritura
3  =  -wx  =  escritura y ejecución
4  =  r--  =  lectura
5  =  r-x  =  lectura y ejecución
6  =  rw-  =  lectura y escritura
7  =  rwx  =  lectura, escritura y ejecución
Asi, en el ejemplo de antes:

		rw-r--r--
significa que el owner tiene permisos de lectura y escritura (rw-); el group permisos de lectura unicamente (r--) y other, permiso de lectura (r--). ¿como seria el equivamente numerico? sería chmod 644.

La sintaxis para usar chmod con texto:

chmod [ugo][+-][rwx] [nombre_archivo]
Donde [u=user, g=group y o=other]; [+/- activa o desactiva los atributos siguientes] [r=read, w=write, x=execute]

Por ejemplo, chmod go+r index.php significa que asignamos permisos de lectura para group y others en index.php

De esta forma solo cambiamos los atributos que especificamos, pero no alteramos otros compatibles que pudieran estar asignados anteriormente) por ejemplo, no modifica la atribucion anterior a group de un permiso de ejecución).

Si queremos fijar de nuevo todos los permisos, la sintaxis sería:

chmod go=r index.php donde asignamos a group y other permiso de lectura sobre index.php y eliminamos cualquier otro permiso para ambos.

Ten encuenta asimismo que puedes usar comodines:

chmod 644 *.html etc ...

Calculando valores chmod
   Chmod
Permission Owner Group Other
Read
Write
Execute



This free script provided by JavaScript Kit



*/
