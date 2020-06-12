/*
 *  source: https://stackoverflow.com/questions/5237198/transactsql-to-run-another-transactsql-script
 *
 *  note: for this to run turn on sql command mode (Query > SQLCMD Mode) 
 */

print 'foo'

:r "C:\Users\kebec\Documents\SQL Server Management Studio\Projects\SqlcmdMode\bar.sql"