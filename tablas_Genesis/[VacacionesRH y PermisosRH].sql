USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[VacacionesRH]    Script Date: 12/02/2020 09:58:46 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[VacacionesRH](
	[Fecha_Inicio] [date] NULL,
	[Fecha_Fin] [date] NULL,
	[Fecha_a_Trabajar] [date] NULL,
	[Cedula] [nvarchar](255) NULL,
	[Nombre] [nvarchar](255) NULL,
	[Departamento] [nvarchar](255) NULL,
	[Localidad] [nvarchar](255) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idSoluflex] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


