/****** Object:  Table [safran_staging].[ACTIVITIES]    Script Date: 28.10.2019 16:31:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [safran].[ACTIVITIES](
	[META_OraRowscn] [bigint] NULL,
	[META_SourceDatabase] int NOT NULL,
	[SEQ] [int] NOT NULL,
	[AN] [nvarchar](50) NULL,
	[DU] [int] NULL,
	[PC] [float] NULL,
	[RDU] [int] NULL,
	[WPN] [int] NULL,
	[TSE] [datetime2](7) NULL,
	[TSL] [datetime2](7) NULL,
	[TCE] [datetime2](7) NULL,
	[TCL] [datetime2](7) NULL,
	[ACS] [datetime2](7) NULL,
	[ACF] [datetime2](7) NULL,
	[ES] [datetime2](7) NULL,
	[EF] [datetime2](7) NULL,
	[LS] [datetime2](7) NULL,
	[LF] [datetime2](7) NULL,
	[TF] [int] NULL,
	[FF] [int] NULL,
	[DES] [nvarchar](255) NULL,
	[SUBNET_ID] [int] NULL,
	[NET_ID] [int] NOT NULL,
	[R1] [int] NULL,
	[R2] [int] NULL,
	[R3] [int] NULL,
	[R4] [int] NULL,
	[R5] [int] NULL,
	[R6] [int] NULL,
	[R7] [int] NULL,
	[R8] [int] NULL,
	[R9] [int] NULL,
	[R10] [int] NULL,
	[R11] [int] NULL,
	[R12] [int] NULL,
	[R13] [int] NULL,
	[R14] [int] NULL,
	[R15] [int] NULL,
	[R16] [int] NULL,
	[R17] [int] NULL,
	[R18] [int] NULL,
	[R19] [int] NULL,
	[R20] [int] NULL,
	[R21] [int] NULL,
	[R22] [int] NULL,
	[R23] [int] NULL,
	[R24] [int] NULL,
	[R25] [int] NULL,
	[R26] [int] NULL,
	[R27] [int] NULL,
	[R28] [int] NULL,
	[R29] [int] NULL,
	[R30] [int] NULL,
	[D1] [datetime2](7) NULL,
	[D2] [datetime2](7) NULL,
	[D3] [datetime2](7) NULL,
	[D4] [datetime2](7) NULL,
	[D5] [datetime2](7) NULL,
	[D6] [datetime2](7) NULL,
	[D7] [datetime2](7) NULL,
	[D8] [datetime2](7) NULL,
	[D9] [datetime2](7) NULL,
	[D10] [datetime2](7) NULL,
	[D11] [datetime2](7) NULL,
	[D12] [datetime2](7) NULL,
	[D13] [datetime2](7) NULL,
	[D14] [datetime2](7) NULL,
	[D15] [datetime2](7) NULL,
	[D16] [datetime2](7) NULL,
	[D17] [datetime2](7) NULL,
	[D18] [datetime2](7) NULL,
	[D19] [datetime2](7) NULL,
	[D20] [datetime2](7) NULL,
	[N1] [float] NULL,
	[N2] [float] NULL,
	[N3] [float] NULL,
	[N4] [float] NULL,
	[N5] [float] NULL,
	[N6] [float] NULL,
	[N7] [float] NULL,
	[N8] [float] NULL,
	[N9] [float] NULL,
	[N10] [float] NULL,
	[N11] [float] NULL,
	[N12] [float] NULL,
	[N13] [float] NULL,
	[N14] [float] NULL,
	[N15] [float] NULL,
	[N16] [float] NULL,
	[N17] [float] NULL,
	[N18] [float] NULL,
	[N19] [float] NULL,
	[N20] [float] NULL,
	[L1] [int] NULL,
	[L2] [int] NULL,
	[L3] [int] NULL,
	[L4] [int] NULL,
	[L5] [int] NULL,
	[L6] [int] NULL,
	[L7] [int] NULL,
	[L8] [int] NULL,
	[L9] [int] NULL,
	[L10] [int] NULL,
	[L11] [int] NULL,
	[L12] [int] NULL,
	[L13] [int] NULL,
	[L14] [int] NULL,
	[L15] [int] NULL,
	[L16] [int] NULL,
	[L17] [int] NULL,
	[L18] [int] NULL,
	[L19] [int] NULL,
	[L20] [int] NULL,
	[ON_TARGET] [int] NULL,
	[JOBFLAG] [int] NULL,
	[CURRENT_PROGRESS] [float] NULL,
	[FRONTLINE_DATE] [datetime2](7) NULL,
	[CANCELLED] [datetime2](7) NULL,
	[REMARKS] [varchar](max) NULL,
	[ORIGINAL_QTY] [float] NULL,
	[APPROVED_VO_QTY] [float] NULL,
	[ESTIMATED_VO_QTY] [float] NULL,
	[SUBCONTR_VO_QTY] [float] NULL,
	[INTERNAL_VO_QTY] [float] NULL,
	[JOBPACK_EST_QTY] [float] NULL,
	[EXPENDED_QTY] [float] NULL,
	[ESA] [datetime2](7) NULL,
	[CURRENT_AS] [datetime2](7) NULL,
	[CURRENT_AF] [datetime2](7) NULL,
	[CURRENT_PLANNED_PROG] [float] NULL,
	[BASE_PLANNED_PROG] [float] NULL,
	[OES] [datetime2](7) NULL,
	[OEF] [datetime2](7) NULL,
	[OLS] [datetime2](7) NULL,
	[OLF] [datetime2](7) NULL,
	[BES] [datetime2](7) NULL,
	[BESA] [datetime2](7) NULL,
	[BEF] [datetime2](7) NULL,
	[BLS] [datetime2](7) NULL,
	[BLF] [datetime2](7) NULL,
	[CES] [datetime2](7) NULL,
	[CEF] [datetime2](7) NULL,
	[CLS] [datetime2](7) NULL,
	[CLF] [datetime2](7) NULL,
	[ORIGINAL_QTY1] [float] NULL,
	[CSH] [float] NULL,
	[RSH] [float] NULL,
	[TSH] [float] NULL,
	[CURR_FRONTLINE_DATE] [datetime2](7) NULL,
	[ESS] [datetime2](7) NULL,
	[EFS] [datetime2](7) NULL,
	[TFS] [int] NULL,
	[FFS] [int] NULL,
	[HAMMOCK] [int] NULL,
	[ANALYSE_OPT] [int] NULL,
	[FSD] [datetime2](7) NULL,
	[FFD] [datetime2](7) NULL,
	[MANUAL_PROG_FLAG] [int] NULL,
	[CURRENT_PC] [float] NULL,
	[RDUA] [int] NULL,
	[CESA] [datetime2](7) NULL,
	[CTF] [int] NULL,
	[CFF] [int] NULL,
	[LOOS] [int] NULL,
	[COOS] [int] NULL,
	[OUT_OF_SYNC] [int] NULL,
	[FCDU] [int] NULL,
	[FCESA] [datetime2](7) NULL,
	[FCEF] [datetime2](7) NULL,
	[RESA] [datetime2](7) NULL,
	[RES] [datetime2](7) NULL,
	[REF] [datetime2](7) NULL,
	[RLS] [datetime2](7) NULL,
	[RLF] [datetime2](7) NULL,
	[REVISED_PLANNED_PROG] [float] NULL,
	[REV_FRONTLINE_DATE] [datetime2](7) NULL,
	[FCQTY] [float] NULL,
	[DUR_FMT] [int] NULL,
	[O1] [int] NULL,
	[O2] [int] NULL,
	[O3] [int] NULL,
	[O4] [int] NULL,
	[O5] [int] NULL,
	[O6] [int] NULL,
	[O7] [int] NULL,
	[O8] [int] NULL,
	[O9] [int] NULL,
	[O10] [int] NULL,
	[O11] [int] NULL,
	[O12] [int] NULL,
	[O13] [int] NULL,
	[O14] [int] NULL,
	[O15] [int] NULL,
	[O16] [int] NULL,
	[O17] [int] NULL,
	[O18] [int] NULL,
	[O19] [int] NULL,
	[O20] [int] NULL,
	[O21] [int] NULL,
	[O22] [int] NULL,
	[O23] [int] NULL,
	[O24] [int] NULL,
	[O25] [int] NULL,
	[O26] [int] NULL,
	[O27] [int] NULL,
	[O28] [int] NULL,
	[O29] [int] NULL,
	[O30] [int] NULL,
	[ROW_NO] [int] NULL,
	[OUTLINE_LEVEL] [int] NULL,
	[LINK_SUMMARY] [int] NULL,
	[CPC] [float] NULL,
	[REV_SCOPE] [float] NULL,
	[U1] [nvarchar](10) NULL,
	[U2] [nvarchar](10) NULL,
	[U3] [nvarchar](10) NULL,
	[U4] [nvarchar](10) NULL,
	[U5] [nvarchar](10) NULL,
	[U6] [nvarchar](10) NULL,
	[U7] [nvarchar](10) NULL,
	[U8] [nvarchar](10) NULL,
	[U9] [nvarchar](10) NULL,
	[U10] [nvarchar](10) NULL,
	[EVM_METHOD] [nvarchar](2) NULL,
	[EVM_PARM] [nvarchar](100) NULL,
	[MIN_DUR] [int] NULL,
	[ACT_EXI] [int] NULL,
	[ACT_FIT] [int] NULL,
	[ALAP] [int] NULL,
	[ACT_TYPE] [int] NULL,
	[LOOK_AHEAD] [int] NULL,
	[R31] [int] NULL,
	[R32] [int] NULL,
	[R33] [int] NULL,
	[R34] [int] NULL,
	[R35] [int] NULL,
	[R36] [int] NULL,
	[R37] [int] NULL,
	[R38] [int] NULL,
	[R39] [int] NULL,
	[R40] [int] NULL,
	[R41] [int] NULL,
	[R42] [int] NULL,
	[R43] [int] NULL,
	[R44] [int] NULL,
	[R45] [int] NULL,
	[R46] [int] NULL,
	[R47] [int] NULL,
	[R48] [int] NULL,
	[R49] [int] NULL,
	[R50] [int] NULL,
	[R51] [int] NULL,
	[R52] [int] NULL,
	[R53] [int] NULL,
	[R54] [int] NULL,
	[R55] [int] NULL,
	[R56] [int] NULL,
	[R57] [int] NULL,
	[R58] [int] NULL,
	[R59] [int] NULL,
	[R60] [int] NULL,
	[D21] [datetime2](7) NULL,
	[D22] [datetime2](7) NULL,
	[D23] [datetime2](7) NULL,
	[D24] [datetime2](7) NULL,
	[D25] [datetime2](7) NULL,
	[D26] [datetime2](7) NULL,
	[D27] [datetime2](7) NULL,
	[D28] [datetime2](7) NULL,
	[D29] [datetime2](7) NULL,
	[D30] [datetime2](7) NULL,
	[D31] [datetime2](7) NULL,
	[D32] [datetime2](7) NULL,
	[D33] [datetime2](7) NULL,
	[D34] [datetime2](7) NULL,
	[D35] [datetime2](7) NULL,
	[D36] [datetime2](7) NULL,
	[D37] [datetime2](7) NULL,
	[D38] [datetime2](7) NULL,
	[D39] [datetime2](7) NULL,
	[D40] [datetime2](7) NULL,
	[CURRENT_RDU] [float] NULL,
	[ESAS] [datetime2](7) NULL,
 CONSTRAINT [PK_ACTIVITIES] PRIMARY KEY CLUSTERED 
(
	[META_SourceDatabase] ASC,
	[NET_ID] ASC,
	[SEQ] ASC)
) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
