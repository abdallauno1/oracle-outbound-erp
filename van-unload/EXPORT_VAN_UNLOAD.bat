CALL SETVAR.bat
CD "%EXPDIR_SAP%\VanUnload"

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
IF "%TIME:~0,1%"==" " SET mytime=0%TIME:~1,1%%TIME:~3,2%%TIME:~6,2%
IF NOT "%TIME:~0,1%"==" " SET mytime=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

REM Step 1 : Load XTEL Outbound staging area
SQLPLUS %USRPWDDSN% @%DIR_ROOT%\Xlauncher_EXPORT_VAN_UNLOAD.sql

REM Step 2 : Generate CSV files for Van Unload
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_VANUNLOAD_H.sql %EXPDIR_SAP%\VanUnload\VANUNLOAD_H_%mydate%%mytime%.csv
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_VANUNLOAD_R.sql %EXPDIR_SAP%\VanUnload\VANUNLOAD_R_%mydate%%mytime%.csv

echo END