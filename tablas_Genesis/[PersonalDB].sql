USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[PersonalDB]    Script Date: 12/02/2020 09:55:37 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[PersonalDB](
	[No#] [float] NULL,
	[Cedula] [nvarchar](255) NULL,
	[Nombre] [nvarchar](255) NULL,
	[Departamento] [nvarchar](255) NULL,
	[Division] [nvarchar](255) NULL,
	[Cargo] [nvarchar](255) NULL,
	[Supervisor] [nvarchar](255) NULL,
	[Registro de ponche] [nvarchar](255) NULL,
	[Localidad] [nvarchar](255) NULL,
	[cedula2] [varchar](11) NULL
) ON [PRIMARY]
GO


