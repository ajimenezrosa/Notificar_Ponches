USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[DatosReloj_Cargar]    Script Date: 12/02/2020 09:48:52 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[DatosReloj_Cargar](
	[NOMBRE] [varchar](41) NULL,
	[CEDULA] [varchar](8000) NULL,
	[COD_RELOJ] [char](10) NULL,
	[FECHA] [date] NULL,
	[HORA] [time](7) NULL,
	[CLOCKID] [char](4) NULL,
	[TIPO_PONCHE] [varchar](14) NOT NULL,
	[Cargado] [int] NULL,
	[enviado] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [PonchesDB].[DatosReloj_Cargar] ADD  DEFAULT ((0)) FOR [Cargado]
GO

ALTER TABLE [PonchesDB].[DatosReloj_Cargar] ADD  DEFAULT ((0)) FOR [enviado]
GO


