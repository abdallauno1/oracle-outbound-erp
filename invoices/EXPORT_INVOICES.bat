CALL SETVAR.bat
CD "%EXPDIR_SAP%\CashInvoice"

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
IF "%TIME:~0,1%"==" " SET mytime=0%TIME:~1,1%%TIME:~3,2%%TIME:~6,2%
IF NOT "%TIME:~0,1%"==" " SET mytime=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

REM Step 1 : Load XTEL Outbound staging area
SQLPLUS %USRPWDDSN% @%DIR_ROOT%\Xlauncher_EXPORT_INVOICES.sql

REM Step 2 : Generate CSV files for Invoice
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_INVOICE_H.sql %EXPDIR_SAP%\CashInvoice\INVOICE_H_%mydate%%mytime%.csv
sqlplus %USRPWDDSN% @%DIR_CTRL%\SPOOL_INVOICE_R.sql %EXPDIR_SAP%\CashInvoice\INVOICE_R_%mydate%%mytime%.csv

echo END