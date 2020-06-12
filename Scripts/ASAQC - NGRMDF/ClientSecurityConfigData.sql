
/*
 *  Set up base data for client security
 */


--INSERT INTO [security].[ApplicationRole]
--	([RoleName])
--VALUES
--	('NGRMDF_ASAQC_Internal'),
--	('NGRMDF_ASAQC_GR'),
--	('NGRMDF_ASAQC_JC'),
--	('NGRMDF_ASAQC_JS'),
--	('NGRMDF_ASAQC_SN'),
--	('NGRMDF_ASAQC_ASN_Vendor'),
--	('NGRMDF_ASAQC_CGG_Vendor'),
--	('NGRMDF_ASAQC_GERI_Vendor'),
--	('NGRMDF_ASAQC_WGP_Vendor')
--GO

--INSERT INTO [security].[ApplicationRolesFeilds]
--	([RoleName]
--	,[IDFIELD])
--VALUES
--	('NGRMDF_ASAQC_GR', 1035937),  -- 'GRANE'
--	('NGRMDF_ASAQC_JC', 32017325), -- 'JOHAN CASTBERG'
--	('NGRMDF_ASAQC_JS', 26376286), -- 'JOHAN SVERDRUP'
--	('NGRMDF_ASAQC_SN', 43718)     -- 'SNORRE'
--GO

--INSERT INTO [security].[Vendor]
--	([VendorName]
--	,[RoleName])
--VALUES
--	('ASN', 'NGRMDF_ASAQC_ASN_Vendor'),
--	('CGG', 'NGRMDF_ASAQC_CGG_Vendor'),
--	('GERI', 'NGRMDF_ASAQC_GERI_Vendor'),
--	('WGP', 'NGRMDF_ASAQC_WGP_Vendor')
--GO



