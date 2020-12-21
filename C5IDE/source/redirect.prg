#include "fivewin.ch"


function RunCommand( szCommand )


Aplicacion():oOutPut:VarPut( szCommand + CRLF + CRLF )
Aplicacion():oOutPut:Refresh()


Stop(.f.)
Run1( Aplicacion():oOutPut:hWnd, cFilePath( GetModuleFileName(GetInstance())), szCommand )
Stop(.t.)

return nil




function Redirect()
local oWndChild
local oGet
local cVar := ''
local oGet2
local szCommand := space( 100 )

local oFont

DEFINE FONT oFont NAME "Courier New" SIZE 8, 14
//DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

DEFINE WINDOW oWndChild TITLE "Prueba de ventana de salida" MDICHILD OF Aplicacion():oWnd

    oWndChild:SetFont( oFont )

     @ 130, 10 GET Aplicacion():oOutPut VAR cVar OF oWndChild SIZE 1000, 300 PIXEL MULTILINE  HSCROLL

    oWndChild:oClient := Aplicacion():oOutPut

     //@ 2, 400 GET oGet2 VAR szCommand SIZE 300, 24 PIXEL
     //@ 2, 2 BUTTON "Ok" SIZE 100, 24 PIXEL OF oWnd ACTION ( Stop(.f.),Run1( oGet:hWnd, cFilePath( GetModuleFileName(GetInstance())), szCommand ), Stop(.t.) )
     //@ 2, 222 BUTTON "Stop" SIZE 100, 24 PIXEL OF oWnd ACTION Stop()


ACTIVATE WINDOW oWndChild VALID( Stop(), Aplicacion():oOutPut := nil,.t.)

return nil


#pragma BEGINDUMP


#include "windows.h"
#include "hbapi.h"

const int BUF_SIZE = 8192;

void ShowLastError(LPSTR);
void AppendText( HWND hWnd, LPCTSTR Text );
void DoEvents();
void PeekAndPump();

BOOL m_bStopped = FALSE;

HB_FUNC( STOP )
{
   m_bStopped = hb_parl( 1 );
}


HB_FUNC( RUN1 )
{
	HWND hWnd = (HWND) hb_parnl( 1 );
	HANDLE					PipeReadHandle;
	HANDLE					PipeWriteHandle;
	PROCESS_INFORMATION	ProcessInfo;
	SECURITY_ATTRIBUTES	SecurityAttributes;
	STARTUPINFO				StartupInfo;
	BOOL					   Success;
	LPTSTR m_szCommand = hb_parc( 3 ) ;
        LPTSTR m_szCurrentDirectory = hb_parc( 2 );

	DWORD	BytesLeftThisMessage = 0;
	DWORD	NumBytesRead;
	TCHAR	PipeData[20000];
	DWORD	TotalBytesAvailable = 0;
        DWORD ii;

        SendMessage( hWnd, EM_LIMITTEXT,(WPARAM) 0, 0 );

	//--------------------------------------------------------------------------
	//	Zero the structures.
	//--------------------------------------------------------------------------
	ZeroMemory( &StartupInfo,			sizeof( StartupInfo ));
	ZeroMemory( &ProcessInfo,			sizeof( ProcessInfo ));
	ZeroMemory( &SecurityAttributes,	sizeof( SecurityAttributes ));

	//--------------------------------------------------------------------------
	//	Create a pipe for the child's STDOUT.
	//--------------------------------------------------------------------------
	SecurityAttributes.nLength              = sizeof(SECURITY_ATTRIBUTES);
	SecurityAttributes.bInheritHandle       = TRUE;
	SecurityAttributes.lpSecurityDescriptor = NULL;

	Success = CreatePipe
	(
		&PipeReadHandle,		// address of variable for read handle
		&PipeWriteHandle,		// address of variable for write handle
		&SecurityAttributes,	// pointer to security attributes
		0						// number of bytes reserved for pipe (use default size)
	);


	if ( !Success )
	{
		ShowLastError("Error creating pipe");
		hb_ret();
		return;
	}


	//--------------------------------------------------------------------------
	//	Set up members of STARTUPINFO structure.
	//--------------------------------------------------------------------------
	StartupInfo.cb           = sizeof(STARTUPINFO);
	StartupInfo.dwFlags      = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES;
	StartupInfo.wShowWindow  = SW_HIDE;
	StartupInfo.hStdOutput   = PipeWriteHandle;
	StartupInfo.hStdError    = PipeWriteHandle;


	//----------------------------------------------------------------------------
	//	Create the child process.
	//----------------------------------------------------------------------------
	Success = CreateProcess
	(
		NULL,					// pointer to name of executable module
		m_szCommand,	   // command line
		NULL,					// pointer to process security attributes
		NULL,					// pointer to thread security attributes (use primary thread security attributes)
		TRUE,					// inherit handles
		0,						// creation flags
		NULL,					// pointer to new environment block (use parent's)
		m_szCurrentDirectory,	// pointer to current directory name
		&StartupInfo,			// pointer to STARTUPINFO
		&ProcessInfo			// pointer to PROCESS_INFORMATION
	);


	if ( !Success )
	{

		ShowLastError("Error creating process");
		hb_ret();
		return;
	}




	for ( ; ; )
	{
		NumBytesRead = 0;

		Success = PeekNamedPipe(
			PipeReadHandle,				// handle to pipe to copy from
			PipeData,					// pointer to data buffer
			1,							// size, in bytes, of data buffer
			&NumBytesRead,				// pointer to number of bytes read
			&TotalBytesAvailable,		// pointer to total number of bytes available
			&BytesLeftThisMessage		// pointer to unread bytes in this message
		);

		if ( !Success )
		{
			ShowLastError("PeekNamedPipe fialed");
			hb_ret();
			break;
		}

		if ( NumBytesRead )
		{
			Success = ReadFile
			(
				PipeReadHandle,		// handle to pipe to copy from
				PipeData,			// address of buffer that receives data
				BUF_SIZE - 1,		// number of bytes to read
				&NumBytesRead,		// address of number of bytes read
				NULL				// address of structure for data for overlapped I/O
			);

			if ( !Success )
			{
				ShowLastError("ReadFile fialed");
				hb_ret();
				break;
			}

			//------------------------------------------------------------------
			//	Zero-terminate the data.
			//------------------------------------------------------------------
			PipeData[NumBytesRead] = '\0';

			//------------------------------------------------------------------
			//	Replace backspaces with spaces.
			//------------------------------------------------------------------
			for ( ii = 0; ii < NumBytesRead; ii++ )
			{
				if ( PipeData[ii] == '\b' )
				{
					PipeData[ii] = ' ';
				}
			}
			AppendText( hWnd, (LPTSTR) PipeData );
			//CString strOut((CHAR*)PipeData);
			//strOut.Replace(_T("\b"), _T(" ") );

			//------------------------------------------------------------------
			//	If we're running a batch file that contains a pause command,
			//	assume it is the last output from the batch file and remove it.
			//------------------------------------------------------------------
			/*TCHAR  *ptr = _tcsstr(PipeData, _T("Press any key to continue . . ."));
			if ( ptr )
			{
				*ptr = '\0';
			}*/

			//------------------------------------------------------------------
			//	Append the output to the CEdit control.
			//------------------------------------------------------------------
			//AppendText(PipeData);
			//AppendText(strOut.Left(NumBytesRead));

			//------------------------------------------------------------------
			//	Peek and pump messages.
			//------------------------------------------------------------------
			PeekAndPump();
		}
		else
		{
			//------------------------------------------------------------------
			//	If the child process has completed, break out.
			//------------------------------------------------------------------
			if ( WaitForSingleObject(ProcessInfo.hProcess, 0) == WAIT_OBJECT_0 )	//lint !e1924 (warning about C-style cast)
			{
				break;
			}

			//------------------------------------------------------------------
			//	Peek and pump messages.
			//------------------------------------------------------------------
			PeekAndPump();

			//------------------------------------------------------------------
			//	If the user cancelled the operation, terminate the process.
			//------------------------------------------------------------------
			if ( m_bStopped )
			{

				Success = TerminateProcess( ProcessInfo.hProcess,	0	);

				if ( Success )
				{
					//AppendText("\r\nCancelado por el usuario.\r\n");
					MessageBox( 0, "Cancelado por el usuario","Atención",0);
				}
				else
				{
					ShowLastError("Error terminating process.");
				}

				break;
			}

			//------------------------------------------------------------------
			//	Sleep.
			//------------------------------------------------------------------
			//Sleep(m_dwSleepMilliseconds);
		}

	}

	//--------------------------------------------------------------------------
	//	Close handles.
	//--------------------------------------------------------------------------

	Success = CloseHandle(ProcessInfo.hThread);
	if ( !Success )
	{
		ShowLastError("Error closing thread handle.");
	}

	Success = CloseHandle(ProcessInfo.hProcess);
	if ( !Success )
	{
		ShowLastError("Error closing process handle.");
	}

	Success = CloseHandle(PipeReadHandle);
	if ( !Success )
	{
		ShowLastError("Error closing pipe read handle.");
	}

	Success = CloseHandle(PipeWriteHandle);
	if ( !Success )
	{
		ShowLastError("Error closing pipe write handle.");
	}

}


void ShowLastError(LPSTR szText)
{
	LPVOID		lpMsgBuf;
	DWORD		Success;

	//--------------------------------------------------------------------------
	//	Get the system error message.
	//--------------------------------------------------------------------------
	Success = FormatMessage
	(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		NULL,
		GetLastError(),
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),	//lint !e1924 (warning about C-style cast)
		(LPTSTR)&lpMsgBuf,
		0,
		NULL
	);


   /*
	CString	Msg;

	Msg = szText;
	Msg += _T("\r\n");
	if ( Success )
	{
		Msg += LPTSTR(lpMsgBuf);
	}
	else
	{
		Msg += _T("No status because FormatMessage failed.\r\n");
	}

	AppendText(Msg);
   */
}

void DoEvents()
{
	MSG msg;
	long sts;

	do {
		if (sts = PeekMessage(&msg, (HWND) NULL, 0, 0, PM_REMOVE)) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	} while (sts);
}


void PeekAndPump()
{
    MSG msg;
    long sts;

    while (::PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE))
    {
      do {
   		if (sts = PeekMessage(&msg, (HWND) NULL, 0, 0, PM_REMOVE)) {
   			TranslateMessage(&msg);
   			DispatchMessage(&msg);
   		}
   	} while (sts);
    }
}


void Stop()
{
	m_bStopped = TRUE	;
}

void AppendText( HWND hWnd, LPCTSTR Text )
{
	int Length;
	int nLines;
	if( !::IsWindow(	hWnd) )
		return;

	Length= GetWindowTextLength( hWnd );

	SendMessage( hWnd, EM_SETSEL, Length, Length );
	SendMessage( hWnd, EM_REPLACESEL, FALSE,(LPARAM)  Text );
	nLines = SendMessage( hWnd, EM_GETLINECOUNT, 0, 0 );
	SendMessage( hWnd, EM_SCROLL, nLines ,0 );

}

/*
void CRedirect::SetSleepInterval(DWORD dwMilliseconds)
{
	m_dwSleepMilliseconds = dwMilliseconds;
}
*/




#pragma ENDDUMP


