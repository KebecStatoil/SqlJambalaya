/*
   torsdag 31. januar 201915:04:33
   User: 
   Server: dataengineeringsqldev.database.windows.net
   Database: SAFRANPROJECT
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE safran.BASELINE_LOG ADD
	PLAN_TYPE float(53) NULL
GO
ALTER TABLE safran.BASELINE_LOG SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
