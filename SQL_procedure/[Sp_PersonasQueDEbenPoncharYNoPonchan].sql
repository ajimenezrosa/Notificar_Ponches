    use msdb
	go
    
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

    
alter procedure [dbo].[Sp_PersonasQueDEbenPoncharYNoPonchan]    
as    


/*Alejandro Jimenez    
para determinar que la persona no se notifique a menos    
que su hora de entrada sea menor a la hora de desarga de los ponches....    
2020 Enero 17    
*/     
--update  [Genesis].[PonchesDB].[DatosReloj_Cargar]    
--set enviado = 2  
--where HORA < '11:00:00' and fecha = '2020-02-06'  
  
  declare @enviar_corroe int = 0
  
  declare @enviar_corroe2 int = 0

  declare @correoTransporte varchar(100) = ''

declare @fechaentrada varchar(10)     
SET @fechaentrada = CONVERT(char(2), DatePart (hh,GetDate())) + ':' + CONVERT(char(2), DatePart (mi,GetDate())) + ':00'    
    
    
declare @Correo varchar(100) ;    
declare @Mensaje varchar(1000);    
    
declare @email varchar(500) =     
(    
--'jose.jimenez@inabima.gob.do'    
SELECT     
      [Email]    
  FROM [AuditoriaDB].[dbo].[tblParametros]    
  where id = 6    
)    
--set @email = 'jose.jimenez@inabima.gob.do'    
    
while exists (    
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]    
where enviado = 0 AND HORA < '11:00:00' and fecha >=convert(varchar(10),getdate()-3,120)    
    
order by fecha asc    
    
)    
begin    
    
DECLARE @Body NVARCHAR(MAX),    
    @TableHead VARCHAR(1000),    
    @TableTail VARCHAR(1000)    
 ,@dias int = 2    
 ,@fecha varchar(10)     
     
 /*    
     
 Asignar fecha a enviar al personal de resursos humanos    
 */    
set @fecha = (    
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]    
where enviado = 0 AND HORA < '11:00:00' and fecha >=convert(varchar(10),getdate()-3,120)    
order by fecha asc    
    
    
)    
    
--set @fecha = '2019-05-27'    
SET @TableTail = '</table></body></html>' ;    
SET @TableHead = '<html><head>' + '<style>'    
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '    
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '    
    + CONVERT(VARCHAR(50), GETDATE(), 100)     
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>'     
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'    
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;    
    
SET @Body = (    
select  distinct    
    
 td =  A.cedula, ''    
 , td = Per.NOMBRE,''    
 --,a.CEDULA    
 , td =isNull( B.FECHA,@fecha),''    
 ,td = IsNull(B.HORA,'00:00:00' ), ''    
 ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''    
 ,td = isNull(B.COD_RELOJ,''), ''    
 ,td = 'No Definido', ''    
     
from [Genesis].[PonchesDB].[horarioEmpleados] A    
--left join (    
--select * from [Genesis].[PonchesDB].[DatosReloj_Cargar] where fecha = '2019-06-11'    
--  and hora < '11:00:00'    
-- )   B ON A.cedula = b.CEDULA     
    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
    
    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
   and     
   SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'    
    
)   B ON A.cedula = b.CEDULA    
    
    
 join [Genesis].[PonchesDB].[PersonalDB] Per    
    on per.cedula2 = a.cedula    
    
join     
 (    
     
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1    
 ) c on c.id = A.idTipoPonche    
    
    
    
  Where b.hora is null    
  /*filtramos por las personas que deben ponchas ese dia*/    
 and a.cedula in    
   (    
       
      select cedula from [Genesis].[PonchesDB].[horarioEmpleados] --where  dias = DATENAME(weekday ,@fecha) and act = 1    
       where idTipoPonche in    
       (     
      select id from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1    
      )    
       and entrada <= @fechaentrada    
       
   )    
/*=======================================================================================================================*/    
    
    
 --and a.cedula = '22500150150'    
    
 order by per.NOMBRE     
    
    
            FOR   XML RAW('tr'),    
                  ELEMENTS    
            )    
    
SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail    
    

if( @enviar_corroe = 1)
begin

EXEC sp_send_dbmail     
  @profile_name='SqlMail',    
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',    
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',    
  @subject='Query Result',    
  @body=@Body ,    
  @body_format = 'HTML' ;    

end    
    
    
/*    
=======================================================================================================    
Inicio de bucles para envio de correos a los encargados de depto    
Alejandro Jimenez Viernes 14 de Junio 2019    
*/    
    
exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha    
    
    
while exists(    
select top 1     
   emailsupervisor    
from    
[genesis].[PonchesDB].[SupervisoresCorreos]     
Where  [activarEnvioCorreo]= 1    
and enviado = 0  
)    
begin    
    
set @Correo =     
(    
  select top 1     
     [EMAILSUPERVISOR]    
  from    
  [genesis].[PonchesDB].[SupervisoresCorreos]     
   Where  [activarEnvioCorreo]= 1    
    and enviado = 0    
)    


set @Body = '';

print @correo

set @correoTransporte = @Correo;

set @Correo = 'jose.jimenez@inabima.gob.do'


/*    
=============================================================================================================    
*/    
set @mensaje = ''    
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'') from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)    
Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull([SUPERVISOR],'') from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)    
    
    
 /*    
     
 Asignar fecha a enviar al personal de resursos humanos    
 */    
    
    
--declare @fecha varchar(10)    
set @fecha = convert(varchar(10),getdate(),120)    
    
--declare @fecha varchar(10)    
    
if exists (    
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]    
where enviado = 0 AND HORA < '11:00:00' and fecha >=convert(varchar(10),getdate()-3,120) and fecha is not null    
order by fecha asc    
    
)    
begin    
set @fecha = (    
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]    
where enviado = 0 AND HORA < '11:00:00' and fecha >=convert(varchar(10),getdate()-3,120) and fecha is not null    
order by fecha asc    
    
    
)    
end    
print @fecha    
    
    
    
--print @correo    
    
SET @TableTail = '</table></body></html>' ;    
SET @TableHead = '<html><head>' + '<style>'    
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '    
    + '</style>' + '</head>' + '<body>' + '<h2 Color="darkblue">Reporte de Eventos Personas No Poncharon el ' +@fecha + '</h2>'+    
       '<h4>' + @Mensaje+ '</h4>'    
    + CONVERT(VARCHAR(50), GETDATE(), 100)     
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>'     
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'    
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;    
    
SET @Body = (    
select     
distinct    
 td =  A.cedula, ''    
 , td = Per.NOMBRE,''    
 --,a.CEDULA    
 , td =isNull( B.FECHA,@fecha),''    
 ,td = IsNull(B.HORA,'00:00:00' ), ''    
 ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''    
 ,td = isNull(B.COD_RELOJ,''), ''    
 ,td = 'No Definido', ''    
     
from [Genesis].[PonchesDB].[horarioEmpleados] A    
--left join (    
--select * from [Genesis].[PonchesDB].[DatosReloj_Cargar] where fecha = '2019-06-11'    
--  and hora < '11:00:00'    
-- )   B ON A.cedula = b.CEDULA     
    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
    
    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
   and     
   SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'    
    
)   B ON A.cedula = b.CEDULA    
    
    
 join [Genesis].[PonchesDB].[PersonalDB] Per    
    on per.cedula2 = a.cedula    
    
join     
 (    
     
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1    
 ) c on c.id = A.idTipoPonche    
     
     
 join  [genesis].[PonchesDB].[SupervisoresCorreos]  Sper     
   on Sper.[CEDULA_EMP] = per.cedula2    
     and Sper.[EMAILSUPERVISOR] = @correo    
    
    
  Where b.hora is null    
 /*filtramos por las personas que deben ponchas ese dia*/    
 and a.cedula in    
   (    
       
      select cedula from [Genesis].[PonchesDB].[horarioEmpleados] --where  dias = DATENAME(weekday ,@fecha) and act = 1    
       where idTipoPonche in    
       (     
      select id from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1    
      )    
       and entrada <= @fechaentrada    
       
   )    
    
    and A.cedula not in     
    (    
        
    select Cedula    
     from  [Genesis].[PonchesDB].VacacionesRH    
     where  getdate() between fecha_Inicio and fecha_fin    
    
    
    )    
    
    
/*=======================================================================================================================*/    
 --and a.cedula = '22500150150'    
    
 order by per.NOMBRE     
    
    
            FOR   XML RAW('tr'),    
                  ELEMENTS    
            )    
    


	/*print boby*/
	
	print @Body;
    



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail    
--set @mensaje = ''    
--Set @Mensaje ='Reporte Personas que no Poncharon  :' + ( select distinct isnull(Depto,'') from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)    
--Set @Mensaje += ( select top 1 isnull([SUPERVISOR],'') from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)    
declare @correo1 varchar(1000);    
--set @Correo1 = 'jose.jimenez@inabima.gob.do'    
    



if( @enviar_corroe2 = 1)
begin

--EXEC sp_send_dbmail     
--  @profile_name='SqlMail',    
--  @copy_recipients ='jose.jimenez@inabima.gob.do',    
--  @recipients=  @correo,    -----   @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',    
--  @subject= @Mensaje  ,    
--  @body=@Body ,    
--  @body_format = 'HTML' ;    
    
    
EXEC sp_send_dbmail     
  @profile_name='SqlMail',    
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',    
  @recipients=  @correo,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',    
  @subject='Query Result',    
  @body=@Body ,    
  @body_format = 'HTML' ;    


 end   
    
if( @enviar_corroe2 = 0)
begin
 --select @Body
 print @Body;
 end   
   print @Body;
    --select @Body
    
/*    
=============================================================================================================    
*/    
    
set @Correo = @correoTransporte;
    
update [genesis].[PonchesDB].[SupervisoresCorreos]     
 set enviado = 1     
  Where  [activarEnvioCorreo]= 1    
  and enviado = 0    
  and [EMAILSUPERVISOR] = @correo    
    
    
    
    
end    
    
    
    
    
/*    
    
*/    
    
    
    
  update [Genesis].[PonchesDB].[DatosReloj_Cargar]     
    set enviado = 1    
 where fecha = @fecha    
 AND HORA < '11:00:00'    
    
    
end     
    

go



exec [Sp_PersonasQueDEbenPoncharYNoPonchan]    