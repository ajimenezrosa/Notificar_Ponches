USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan]    Script Date: 17/02/2020 05:42:27 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*    
    
    
update [Genesis].[PonchesDB].[DatosReloj_Cargar]    
set enviado = 2    
    
where HORA < '11:00:00'    
  and fecha = convert(varchar(10),getdate(),120)    
    
*/    
    
--drop procedure [Sp_PersonasQueDEbenPoncharYNoPonchan]


/*
update [Genesis].[PonchesDB].[DatosReloj_Cargar]    
set enviado =  0   
    
where HORA < '11:00:00'    
  and fecha = convert(varchar(10),getdate(),120)    
*/

    
ALTER procedure [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan]    
as    


EXEC [Sp_PersonasQueDEbenPoncharYNoPonchan_rrhh]


EXEC [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan_ENCARGADOS]   
    

    
end     
    

