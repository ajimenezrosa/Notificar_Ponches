USE [Genesis]
GO

/****** Object:  Table [PonchesDB].[horarioEmpleados]    Script Date: 12/02/2020 09:52:46 a.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PonchesDB].[horarioEmpleados](
	[cedula] [varchar](13) NULL,
	[idTipoPonche] [int] NULL,
	[fechaInicio] [date] NULL,
	[fechaFinal] [date] NULL,
	[estatus] [int] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


