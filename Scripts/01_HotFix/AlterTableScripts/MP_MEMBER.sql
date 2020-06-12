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
ALTER TABLE safran.MP_MEMBER ADD
	CAL_NO float(53) NULL,
	PROFILE_NO float(53) NULL
GO
ALTER TABLE safran.MP_MEMBER SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
