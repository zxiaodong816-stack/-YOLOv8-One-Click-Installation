:: ---------------------------------------------------------------------
:: search for 64-bit application for current user or system.
:: use uninstaller key in windows registry.
:: writing registry content into %tmp%\_search_out.txt.
:: the user script is responsible for explaining the output.
:: TODO: need robust way for searching registry key, 
:: ---------------------------------------------------------------------
:: usage:
:: 	call "%udir%\search_uninstaller" application
:: ---------------------------------------------------------------------
@ECHO OFF

IF "%~1"=="" (
	GOTO :USAGE_ERROR
)

CALL :_search_uninstaller ^
  "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" %~1
IF %ERRORLEVEL% EQU 0 GOTO :SUCCESS
CALL :_search_uninstaller ^
  "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" %~1
IF %ERRORLEVEL% EQU 0 GOTO :SUCCESS
CALL :_search_uninstaller ^
  "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" %~1
IF %ERRORLEVEL% EQU 0 GOTO :SUCCESS
CALL :_search_uninstaller ^
  "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" %~1
IF %ERRORLEVEL% EQU 0 GOTO :SUCCESS
GOTO :NOT_FOUND

:SUCCESS
DEL "%tmp%\_search_tmp.txt"
EXIT /B 0

:USAGE_ERROR
CALL "%logger%" "%~nx0" "application name not given"
DEL "%tmp%\_search_tmp.txt"
EXIT /B 1

:NOT_FOUND
CALL "%logger%" "%~nx0" "%~1 not found in registry"
DEL "%tmp%\_search_tmp.txt"
EXIT /B 2


:_search_uninstaller
SETLOCAL
SET "search_key=%~1"
SET "app_name=%~2"
CALL "%logger%" "%~nx0" "searching for %app_name% in %search_key:~0,23%..."
reg query "%search_key%" /f "%app_name%" /k 2>NUL | findstr /I "%app_name%" ^
  >"%tmp%\_search_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	ENDLOCAL
	EXIT /B 1
)
SET /P registry_key=< "%tmp%\_search_tmp.txt"
CALL "%logger%" "%~nx0" "registry_key %registry_key%"
reg query "%registry_key%" >"%tmp%\_search_out.txt" 2>>"%logfile%"
ENDLOCAL
EXIT /B 0
