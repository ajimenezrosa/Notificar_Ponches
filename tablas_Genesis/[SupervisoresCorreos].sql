USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[SupervisoresCorreos]    Script Date: 12/02/2020 09:56:23 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[SupervisoresCorreos](
	[id] [float] NULL,
	[NOMBRE] [nvarchar](255) NULL,
	[CEDULA_EMP] [nvarchar](255) NULL,
	[SUPERVISOR] [nvarchar](255) NULL,
	[EMAILSUPERVISOR] [nvarchar](255) NULL,
	[DEPTO] [nvarchar](255) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[activarEnvioCorreo] [int] NULL,
	[enviado] [int] NULL,
	[CorreoResguardado] [varchar](255) NULL,
	[depto1] [varchar](100) NULL,
	[emailsupervisor_bk] [varchar](1000) NULL
) ON [PRIMARY]
GO

ALTER TABLE [PonchesDB].[SupervisoresCorreos] ADD  DEFAULT ((0)) FOR [activarEnvioCorreo]
GO

ALTER TABLE [PonchesDB].[SupervisoresCorreos] ADD  DEFAULT ((0)) FOR [enviado]
GO


