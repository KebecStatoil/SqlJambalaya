/*
 *  This is from Test
 *
 *  Missing Index Details from SQLQuery40.sql - dataplatformsqltest.database.windows.net.dataplatform-data (KEBEC@statoil.com (132))
 *  The Query Processor estimates that implementing the following index could improve the query cost by 59.3004%.
 */
/*
USE [dataplatform-data]
GO
CREATE NONCLUSTERED INDEX [IX_WORKORDEROPERATION_FSEDD]
ON [dbo].[WorkOrderOperation] ([Fsedd])
INCLUDE ([Vornr],[Arbpl],[Ltxa1],[Arbei],[Ismnw],[Fsavd],[Aufnr_fk])
GO
*/


/*
 *  This is from Dev
 *
 *  Missing Index Details from RefinedAndOriginalQueries.sql - dataplatformsqldev.database.windows.net.dataplatform-data (KEBEC@statoil.com (163))
 *  The Query Processor estimates that implementing the following index could improve the query cost by 12.227%.
 */
/*
USE [dataplatform-data]
GO
CREATE NONCLUSTERED INDEX [IX_WORKORDERUSERSTATUS_TXT04]
ON [dbo].[WorkOrderUserStatus] ([Txt04])
INCLUDE ([Aufnr_fk],[Udate],[Inact])
GO
*/


/*
 *  This is from test from just the CTE
 *
 *  Missing Index Details from SQLQuery46.sql - dataplatformsqltest.database.windows.net.dataplatform-data (KEBEC@statoil.com (132))
 *  The Query Processor estimates that implementing the following index could improve the query cost by 93.7706%.
*/
/*
USE [dataplatform-data]
GO
CREATE NONCLUSTERED INDEX [IX_WORKORDERUSERSTATUS_TXT04_INACT]
ON [dbo].[WorkOrderUserStatus] ([Txt04],[Inact])
INCLUDE ([Aufnr_fk],[Udate])
GO
*/


/*
This is from Test

Missing Index Details from RefinedAndOriginalQueries.sql - dataplatformsqltest.database.windows.net.dataplatform-data (KEBEC@statoil.com (109))
The Query Processor estimates that implementing the following index could improve the query cost by 30.0871%.
*/

/*
USE [dataplatform-data]
GO
CREATE NONCLUSTERED INDEX [IX_WORKORDERUSERSTATUS_AUFNRFK_UDATE]
ON [dbo].[WorkOrderUserStatus] ([Aufnr_fk],[Udate])
GO
*/