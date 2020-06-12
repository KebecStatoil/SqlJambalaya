
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_ASN_Vendor', N'Vendor', N'ASN')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_CGG_Vendor', N'Vendor', N'CGG')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_GERI_Vendor', N'Vendor', N'GERI')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_GR', N'Partner', N'Grane')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_Internal', N'Internal', N'Internal')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_JC', N'Partner', N'Johan Castberg')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_JS', N'Partner', N'Johan Sverdrup')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_SN', N'Partner', N'Snorre')
GO
INSERT [security].[ApplicationRole] ([RoleName], [Type], [Alias]) VALUES (N'NGRMDF_ASAQC_WGP_Vendor', N'Vendor', N'WGP')
GO

INSERT [security].[Vendor] ([VendorName], [RoleName], [IsPrm], [IsVessel], [Alias]) VALUES (N'ASN', N'NGRMDF_ASAQC_ASN_Vendor', 1, 0, NULL)
GO
INSERT [security].[Vendor] ([VendorName], [RoleName], [IsPrm], [IsVessel], [Alias]) VALUES (N'CGG', N'NGRMDF_ASAQC_CGG_Vendor', 0, 1, NULL)
GO
INSERT [security].[Vendor] ([VendorName], [RoleName], [IsPrm], [IsVessel], [Alias]) VALUES (N'GERI', N'NGRMDF_ASAQC_GERI_Vendor', 0, 1, NULL)
GO
INSERT [security].[Vendor] ([VendorName], [RoleName], [IsPrm], [IsVessel], [Alias]) VALUES (N'WGP', N'NGRMDF_ASAQC_WGP_Vendor', 0, 1, NULL)
GO

INSERT [security].[ApplicationRolesFeilds] ([RoleName], [IDFIELD]) VALUES (N'NGRMDF_ASAQC_GR', 1035937)
GO
INSERT [security].[ApplicationRolesFeilds] ([RoleName], [IDFIELD]) VALUES (N'NGRMDF_ASAQC_JC', 32017325)
GO
INSERT [security].[ApplicationRolesFeilds] ([RoleName], [IDFIELD]) VALUES (N'NGRMDF_ASAQC_JS', 26376286)
GO
INSERT [security].[ApplicationRolesFeilds] ([RoleName], [IDFIELD]) VALUES (N'NGRMDF_ASAQC_SN', 43718)
GO
