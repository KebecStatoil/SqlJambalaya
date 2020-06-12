---- Create tables
if not exists (select * from sys.objects where object_id = object_id(N'[diff].[ACTIVITIES]') and type in (N'U'))
create table [diff].[ACTIVITIES] (
  [SEQ] int NOT NULL,
  [AN] nvarchar(50),
  [DU] int,
  [PC] float,
  [RDU] int,
  [WPN] int,
  [TSE] datetime2(7),
  [TSL] datetime2(7),
  [TCE] datetime2(7),
  [TCL] datetime2(7),
  [ACS] datetime2(7),
  [ACF] datetime2(7),
  [ES] datetime2(7),
  [EF] datetime2(7),
  [LS] datetime2(7),
  [LF] datetime2(7),
  [TF] int,
  [FF] int,
  [DES] nvarchar(255),
  [SUBNET_ID] int,
  [NET_ID] int NOT NULL,
  [R1] int,
  [R2] int,
  [R3] int,
  [R4] int,
  [R5] int,
  [R6] int,
  [R7] int,
  [R8] int,
  [R9] int,
  [R10] int,
  [R11] int,
  [R12] int,
  [R13] int,
  [R14] int,
  [R15] int,
  [R16] int,
  [R17] int,
  [R18] int,
  [R19] int,
  [R20] int,
  [R21] int,
  [R22] int,
  [R23] int,
  [R24] int,
  [R25] int,
  [R26] int,
  [R27] int,
  [R28] int,
  [R29] int,
  [R30] int,
  [D1] datetime2(7),
  [D2] datetime2(7),
  [D3] datetime2(7),
  [D4] datetime2(7),
  [D5] datetime2(7),
  [D6] datetime2(7),
  [D7] datetime2(7),
  [D8] datetime2(7),
  [D9] datetime2(7),
  [D10] datetime2(7),
  [D11] datetime2(7),
  [D12] datetime2(7),
  [D13] datetime2(7),
  [D14] datetime2(7),
  [D15] datetime2(7),
  [D16] datetime2(7),
  [D17] datetime2(7),
  [D18] datetime2(7),
  [D19] datetime2(7),
  [D20] datetime2(7),
  [N1] float,
  [N2] float,
  [N3] float,
  [N4] float,
  [N5] float,
  [N6] float,
  [N7] float,
  [N8] float,
  [N9] float,
  [N10] float,
  [N11] float,
  [N12] float,
  [N13] float,
  [N14] float,
  [N15] float,
  [N16] float,
  [N17] float,
  [N18] float,
  [N19] float,
  [N20] float,
  [L1] int,
  [L2] int,
  [L3] int,
  [L4] int,
  [L5] int,
  [L6] int,
  [L7] int,
  [L8] int,
  [L9] int,
  [L10] int,
  [L11] int,
  [L12] int,
  [L13] int,
  [L14] int,
  [L15] int,
  [L16] int,
  [L17] int,
  [L18] int,
  [L19] int,
  [L20] int,
  [ON_TARGET] int,
  [JOBFLAG] int,
  [CURRENT_PROGRESS] float,
  [FRONTLINE_DATE] datetime2(7),
  [CANCELLED] datetime2(7),
  [REMARKS] varchar(max),
  [ORIGINAL_QTY] float,
  [APPROVED_VO_QTY] float,
  [ESTIMATED_VO_QTY] float,
  [SUBCONTR_VO_QTY] float,
  [INTERNAL_VO_QTY] float,
  [JOBPACK_EST_QTY] float,
  [EXPENDED_QTY] float,
  [ESA] datetime2(7),
  [CURRENT_AS] datetime2(7),
  [CURRENT_AF] datetime2(7),
  [CURRENT_PLANNED_PROG] float,
  [BASE_PLANNED_PROG] float,
  [OES] datetime2(7),
  [OEF] datetime2(7),
  [OLS] datetime2(7),
  [OLF] datetime2(7),
  [BES] datetime2(7),
  [BESA] datetime2(7),
  [BEF] datetime2(7),
  [BLS] datetime2(7),
  [BLF] datetime2(7),
  [CES] datetime2(7),
  [CEF] datetime2(7),
  [CLS] datetime2(7),
  [CLF] datetime2(7),
  [ORIGINAL_QTY1] float,
  [CSH] float,
  [RSH] float,
  [TSH] float,
  [CURR_FRONTLINE_DATE] datetime2(7),
  [ESS] datetime2(7),
  [EFS] datetime2(7),
  [TFS] int,
  [FFS] int,
  [HAMMOCK] int,
  [ANALYSE_OPT] int,
  [FSD] datetime2(7),
  [FFD] datetime2(7),
  [MANUAL_PROG_FLAG] int,
  [CURRENT_PC] float,
  [RDUA] int,
  [CESA] datetime2(7),
  [CTF] int,
  [CFF] int,
  [LOOS] int,
  [COOS] int,
  [OUT_OF_SYNC] int,
  [FCDU] int,
  [FCESA] datetime2(7),
  [FCEF] datetime2(7),
  [RESA] datetime2(7),
  [RES] datetime2(7),
  [REF] datetime2(7),
  [RLS] datetime2(7),
  [RLF] datetime2(7),
  [REVISED_PLANNED_PROG] float,
  [REV_FRONTLINE_DATE] datetime2(7),
  [FCQTY] float,
  [DUR_FMT] int,
  [O1] int,
  [O2] int,
  [O3] int,
  [O4] int,
  [O5] int,
  [O6] int,
  [O7] int,
  [O8] int,
  [O9] int,
  [O10] int,
  [O11] int,
  [O12] int,
  [O13] int,
  [O14] int,
  [O15] int,
  [O16] int,
  [O17] int,
  [O18] int,
  [O19] int,
  [O20] int,
  [O21] int,
  [O22] int,
  [O23] int,
  [O24] int,
  [O25] int,
  [O26] int,
  [O27] int,
  [O28] int,
  [O29] int,
  [O30] int,
  [ROW_NO] int,
  [OUTLINE_LEVEL] int,
  [LINK_SUMMARY] int,
  [CPC] float,
  [REV_SCOPE] float,
  [U1] nvarchar(10),
  [U2] nvarchar(10),
  [U3] nvarchar(10),
  [U4] nvarchar(10),
  [U5] nvarchar(10),
  [U6] nvarchar(10),
  [U7] nvarchar(10),
  [U8] nvarchar(10),
  [U9] nvarchar(10),
  [U10] nvarchar(10),
  [EVM_METHOD] nvarchar(2),
  [EVM_PARM] nvarchar(100),
  [MIN_DUR] int,
  [ACT_EXI] int,
  [ACT_FIT] int,
  [ALAP] int,
  [ACT_TYPE] int,
  [LOOK_AHEAD] int,
  [R31] int,
  [R32] int,
  [R33] int,
  [R34] int,
  [R35] int,
  [R36] int,
  [R37] int,
  [R38] int,
  [R39] int,
  [R40] int,
  [R41] int,
  [R42] int,
  [R43] int,
  [R44] int,
  [R45] int,
  [R46] int,
  [R47] int,
  [R48] int,
  [R49] int,
  [R50] int,
  [R51] int,
  [R52] int,
  [R53] int,
  [R54] int,
  [R55] int,
  [R56] int,
  [R57] int,
  [R58] int,
  [R59] int,
  [R60] int,
  [D21] datetime2(7),
  [D22] datetime2(7),
  [D23] datetime2(7),
  [D24] datetime2(7),
  [D25] datetime2(7),
  [D26] datetime2(7),
  [D27] datetime2(7),
  [D28] datetime2(7),
  [D29] datetime2(7),
  [D30] datetime2(7),
  [D31] datetime2(7),
  [D32] datetime2(7),
  [D33] datetime2(7),
  [D34] datetime2(7),
  [D35] datetime2(7),
  [D36] datetime2(7),
  [D37] datetime2(7),
  [D38] datetime2(7),
  [D39] datetime2(7),
  [D40] datetime2(7),
  [CURRENT_RDU] float,
  [ESAS] datetime2(7));
GO

--if not exists (select * from sys.indexes where name = N'PK_ACTIVITIES_SEQ_NET_ID')
--alter table [diff].[ACTIVITIES]
--add constraint PK_ACTIVITIES_SEQ_NET_ID primary key (SEQ, NET_ID);
--GO

if not exists (select * from sys.objects where object_id = object_id(N'[diff].[BASELINE_A]') and type in (N'U'))
create table [diff].[BASELINE_A] (
  [BASELINE_ID] int NOT NULL,
  [SEQ] int NOT NULL,
  [AN] nvarchar(50),
  [DU] int,
  [PC] float,
  [RDU] int,
  [WPN] int,
  [TSE] datetime2(7),
  [TSL] datetime2(7),
  [TCE] datetime2(7),
  [TCL] datetime2(7),
  [ACS] datetime2(7),
  [ACF] datetime2(7),
  [ES] datetime2(7),
  [EF] datetime2(7),
  [LS] datetime2(7),
  [LF] datetime2(7),
  [TF] int,
  [FF] int,
  [DES] nvarchar(255),
  [SUBNET_ID] int,
  [NET_ID] int,
  [N1] float,
  [N2] float,
  [N3] float,
  [N4] float,
  [I1] int,
  [I2] int,
  [I3] int,
  [I4] int,
  [ON_TARGET] int,
  [JOBFLAG] int,
  [CURRENT_PROGRESS] float,
  [CANCELLED] datetime2(7),
  [APPROVED_VO_QTY] float,
  [ESTIMATED_VO_QTY] float,
  [SUBCONTR_VO_QTY] float,
  [INTERNAL_VO_QTY] float,
  [JOBPACK_EST_QTY] float,
  [EXPENDED_QTY] float,
  [CSH] float,
  [RSH] float,
  [TSH] float,
  [ESA] datetime2(7),
  [FSD] datetime2(7),
  [FFD] datetime2(7),
  [CURRENT_PC] float,
  [OUT_OF_SYNC] int,
  [CURRENT_RDU] float);
GO

--if not exists (select * from sys.indexes where name = N'PK_BASELINE_A_BASELINE_ID_SEQ')
--alter table [diff].[BASELINE_A]
--add constraint PK_BASELINE_A_BASELINE_ID_SEQ primary key (BASELINE_ID, SEQ);
--GO

if not exists (select * from sys.objects where object_id = object_id(N'[diff].[BASELINE_LOG]') and type in (N'U'))
create table [diff].[BASELINE_LOG] (
  [BASELINE_ID] int NOT NULL,
  [BASELINE_REV] nvarchar(10) NOT NULL,
  [BASELINE_DATO] datetime2(7) NOT NULL,
  [CUT_OFF] datetime2(7) NOT NULL,
  [DESCRIPTION] nvarchar(255),
  [LOGIN_NAME] nvarchar(200) NOT NULL,
  [NET_ID] int,
  [PLAN_TYPE] float);
GO

--if not exists (select * from sys.indexes where name = N'PK_BASELINE_LOG_BASELINE_ID')
--alter table [diff].[BASELINE_LOG]
--add constraint PK_BASELINE_LOG_BASELINE_ID primary key (BASELINE_ID);
--GO

if not exists (select * from sys.objects where object_id = object_id(N'[diff].[MP_MEMBER]') and type in (N'U'))
create table [diff].[MP_MEMBER] (
  [MP_ID] int NOT NULL,
  [NET_ID] int NOT NULL,
  [NET_NO] int,
  [CAL_NO] float,
  [PROFILE_NO] float);
GO

--if not exists (select * from sys.indexes where name = N'PK_MP_MEMBER_MP_ID_NET_ID')
--alter table [diff].[MP_MEMBER]
--add constraint PK_MP_MEMBER_MP_ID_NET_ID primary key (MP_ID, NET_ID);
--GO