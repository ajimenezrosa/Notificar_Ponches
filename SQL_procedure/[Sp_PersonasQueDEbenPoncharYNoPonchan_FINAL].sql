USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan]    Script Date: 17/02/2020 05:42:27 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
ALTER procedure [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan]    
as    



if  NOT exists (
select fecha from PonchesDB.Validar_NotificarNoponches
		where fecha = convert(varchar(10), getdate() , 120)
)
BEGIN

	PRINT 'EJECUCION DEL PROCESO'




/*INSERTA REGISTRO EN PONCHESDB.VALIDAR_NOTIFICARNOPONCHES*/

/*Ejecutar el procedure de los encargados primero.*/
exec [Sp_PersonasQueDEbenPoncharYNoPonchan_ENCARGADOS]


/*Despures de esto Ejecutar el procedimiento de RRHH*/
exec Sp_PersonasQueDEbenPoncharYNoPonchan_rrhh



INSERT INTO PonchesDB.Validar_NotificarNoponches
(

fechahora 
, fecha 
, act 
)
SELECT CONVERT(Varchar(50), getdate(), 120) ,  CONVERT(Varchar(10), getdate(), 120), 1
/*=============================================================================================*/


END




 
  
 go   

