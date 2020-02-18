USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[Validar_NotificarNoponches]    Script Date: 18/02/2020 10:48:01 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[Validar_NotificarNoponches](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fechahora] [varchar](50) NULL,
	[fecha] [varchar](10) NULL,
	[act] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [PonchesDB].[Validar_NotificarNoponches] ADD  DEFAULT ((1)) FOR [act]
GO


