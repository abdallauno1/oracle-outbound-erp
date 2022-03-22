CALL SETVAR.bat
CD "%EXPDIR_SAP%\KDOrder"

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
IF "%TIME:~0,1%"==" " SET mytime=0%TIME:~1,1%%TIME:~3,2%%TIME:~6,2%
IF NOT "%TIME:~0,1%"==" " SET mytime=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

REM Step 1 : Load XTEL Outbound staging area
SQLPLUS %USRPWDDSN% @%DIR_ROOT%\Xlauncher_EXPORT_KD_ORDERS.sql

REM Step 2 : Generate CSV files for KD Order Request (T10X)
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_KDORDERS_H.sql %EXPDIR_SAP%\KDOrder\KDORDERS_H_%mydate%%mytime%.csv
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_KDORDERS_R.sql %EXPDIR_SAP%\KDOrder\KDORDERS_R_%mydate%%mytime%.csv

echo END