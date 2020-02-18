USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[DescripcionHoratios]    Script Date: 12/02/2020 09:50:24 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[DescripcionHoratios](
	[id] [int] NULL,
	[Dias] [varchar](10) NULL,
	[entrada] [varchar](10) NULL,
	[almuerzo] [varchar](10) NULL,
	[regresoA] [varchar](10) NULL,
	[salida] [varchar](10) NULL,
	[act] [int] NULL
) ON [PRIMARY]
GO


