:: ---------------------------------------------------------------------
:: log message both into stdout and logfile.
:: ---------------------------------------------------------------------
:: usage:
::  call "%logger%"      "scriptname" "message"
:: ---------------------------------------------------------------------
@ECHO OFF
SETLOCAL

SET "_script=%~1"
SET "_message=%~2"

ECHO [%time%] [%_script%] %_message%
ECHO [%time%] [%_script%] %_message% >>"%logfile%"

ENDLOCAL

EXIT /B 0
