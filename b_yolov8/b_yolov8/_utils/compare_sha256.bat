:: ---------------------------------------------------------------------
:: compare file sha256 against target sha256.
:: ---------------------------------------------------------------------
:: usage:
:: 	call "%udir%\compare_sha256" "filepath" "target_sha256"
:: ---------------------------------------------------------------------
@ECHO OFF

IF "%~1"=="" (
	CALL "%logger%" "%~nx0" "first arg not given"
	CALL "%logger%" "%~nx0" "usage: call udir\compare_sha256 filepath target_sha256"
	GOTO :FAILURE
)

IF NOT EXIST "%~1" (
	CALL "%logger%" "%~nx0" "file %~1 not found"
	GOTO :FAILURE
)

IF "%~2"=="" (
	CALL "%logger%" "%~nx0" "second arg not given"
	CALL "%logger%" "%~nx0" "usage: call udir\compare_sha256 filepath target_sha256"
	GOTO :FAILURE
)

:: ---------------------------------------------------------------------

certutil -hashfile "%~1" SHA256 >"%tmp%\_compare_sha256_tmp.txt" 2>>"%logfile%"
IF %ERRORLEVEL% NEQ 0 (
	CALL "%logger%" "%~nx0" "certutil failed with %ERRORLEVEL%"
	GOTO :FAILURE
)

FOR /F "usebackq skip=1 tokens=1" %%i IN ("%tmp%\_compare_sha256_tmp.txt") DO (
	SET "_sha256_f=%%i"
	GOTO :_FOR_END
)
:_FOR_END

IF NOT "%_sha256_f%"=="%~2" (
	CALL "%logger%" "%~nx0" "sha256 check failed"
	GOTO :FAILURE
)
CALL "%logger%" "%~nx0" "sha256 check passed"

:: ---------------------------------------------------------------------
:SUCCESS
EXIT /B 0

:FAILURE
EXIT /B 1
