/****** Object:  Table [survey].[Preplot]    Script Date: 28.06.2019 15:44:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [survey].[Preplot](
	[PreplotID] [int] NOT NULL,
	[PreplotName] [nvarchar](256) NULL,
	epsg_code INT NULL,
	epsg_trans INT NULL,
	proj4 NVARCHAR(MAX) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Updated] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NOT NULL,
	[SourceFilePath] [nvarchar](256) NULL,
	[SailFilePath] [nvarchar](256) NULL,
	[P111FilePath] [nvarchar](256) NULL,
 CONSTRAINT [IX_Preplot] UNIQUE NONCLUSTERED 
(
	[PreplotName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_Created]  DEFAULT (getutcdate()) FOR [Created]
GO

ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO

ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
GO


