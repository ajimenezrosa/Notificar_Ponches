  
    
CREATE procedure [dbo].[Sp_PersonasConAnomaliasenAlmuerzo]    
as    
    
declare @fecha varchar(10) =     
(    
select min(Fecha) from [Genesis].[PonchesDB].[DatosReloj_Cargar]     
 where     
 --fecha = @fecha    
HORA > '11:00:00' AND HORA < '15:30:00'  and fecha  > convert(Varchar(10),getdate()-3,120)    
  and enviado = 0    
  )    
    
    
declare @PivotPonches table    
(    
Cedula varchar(13)    
,Nombres varchar(150)    
,Fecha varchar(10)    
,Entrada varchar(10)    
,Sal_almuerzo varchar(10)    
,Ent_Almuerzo Varchar(10)    
,Min_Almuerzo int    
,Salida VArchar(10)    
,Salida2 VArchar(10)    
,numPonches int    
,id int    
)    
    
    
insert into @PivotPonches    
(    
Cedula    
,Nombres    
,id    
)    
select a.cedula, p.Nombre    
 ,ROW_NUMBER() over(order by a.cedula) as row#    
 from [Genesis].PonchesDB.horarioEmpleados a    
join [Genesis].PonchesDB.DescripcionHoratios b    
  on a.idTipoPonche = b.id    
join [Genesis].[PonchesDB].[PersonalDB] P    
   on a.cedula = P.cedula2    
    
  where b.act = 1    
   and b.Dias = DATENAME(weekday, @fecha)    
    
    
    
/*    
=====================================================================================================    
*/    
    
    
update  a    
 set a.Entrada = b.Hora    
   ,a.Fecha = @fecha    
from  @PivotPonches a,    
(    
select     
  --distinct    
    
  A.cedula  --, ''    
 ,isNull( B.FECHA,@fecha) Fecha --,''    
 ,IsNull(B.HORA,'00:00:00' ) Hora --, ''    
 ,isNull(B.COD_RELOJ,'') Reloj --, ''    
 --,td = 'No Definido', ''    
 ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''    
from [Genesis].[PonchesDB].[horarioEmpleados] A    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
 ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
group by    
   b.firstname,b.lastname    
   ,b.user1    
   ,badge, date    
   ,clockid,a.time    
    
)   B ON A.cedula = b.CEDULA     
    
) b    
where a.Cedula = b.cedula    
   and b.NumeroPonche = 1     
    
    
/*    
=====================================================================================================    
*/    
    
    
    
    
/*    
=====================================================================================================    
*/    
    
    
update  a    
 set a.Sal_almuerzo = b.Hora    
   --,a.Fecha = @fecha    
from  @PivotPonches a,    
(    
select     
  --distinct    
    
  A.cedula  --, ''    
 ,isNull( B.FECHA,@fecha) Fecha --,''    
 ,IsNull(B.HORA,'00:00:00' ) Hora --, ''    
 ,isNull(B.COD_RELOJ,'') Reloj --, ''    
 --,td = 'No Definido', ''    
 ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''    
from [Genesis].[PonchesDB].[horarioEmpleados] A    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
 ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
group by    
   b.firstname,b.lastname    
   ,b.user1    
   ,badge, date    
   ,clockid,a.time    
    
)   B ON A.cedula = b.CEDULA     
    
) b    
where a.Cedula = b.cedula    
   and b.NumeroPonche = 2     
    
    
/*    
=====================================================================================================    
*/    
    
    
/*    
=====================================================================================================    
*/    
    
    
update  a    
 set a.Ent_Almuerzo = b.Hora    
   --,a.Fecha = @fecha    
from  @PivotPonches a,    
(    
select     
  --distinct    
    
  A.cedula  --, ''    
 ,isNull( B.FECHA,@fecha) Fecha --,''    
 ,IsNull(B.HORA,'00:00:00' ) Hora --, ''    
 ,isNull(B.COD_RELOJ,'') Reloj --, ''    
 --,td = 'No Definido', ''    
 ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''    
from [Genesis].[PonchesDB].[horarioEmpleados] A    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
 ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
group by    
   b.firstname,b.lastname    
   ,b.user1    
   ,badge, date    
   ,clockid,a.time    
    
)   B ON A.cedula = b.CEDULA     
    
) b    
where a.Cedula = b.cedula    
   and b.NumeroPonche = 3    
    
/*    
=====================================================================================================    
*/    
    
    
    
/*    
=====================================================================================================    
*/    
    
    
update  a    
 set a.Salida = b.Hora    
 ,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )    
   --,a.Fecha = @fecha    
from  @PivotPonches a,    
(    
select     
  --distinct    
    
  A.cedula  --, ''    
 ,isNull( B.FECHA,@fecha) Fecha --,''    
 ,IsNull(B.HORA,'00:00:00' ) Hora --, ''    
 ,isNull(B.COD_RELOJ,'') Reloj --, ''    
 --,td = 'No Definido', ''    
 ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''    
from [Genesis].[PonchesDB].[horarioEmpleados] A    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
 ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
group by    
   b.firstname,b.lastname    
   ,b.user1    
   ,badge, date    
   ,clockid,a.time    
    
)   B ON A.cedula = b.CEDULA     
    
) b    
where a.Cedula = b.cedula    
   and b.NumeroPonche = 4    
    
/*    
=====================================================================================================    
*/    
    
    
/*    
=====================================================================================================    
*/    
    
    
update  a    
 set a.Salida2 = b.Hora    
 --,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )    
   --,a.Fecha = @fecha    
from  @PivotPonches a,    
(    
select     
  --distinct    
    
  A.cedula  --, ''    
 ,isNull( B.FECHA,@fecha) Fecha --,''    
 ,IsNull(B.HORA,'00:00:00' ) Hora --, ''    
 ,isNull(B.COD_RELOJ,'') Reloj --, ''    
 --,td = 'No Definido', ''    
 ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''    
from [Genesis].[PonchesDB].[horarioEmpleados] A    
left join (    
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE    
      , REPLACE(USER1,'-','') AS CEDULA      
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA    
     ,ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) ,'00:00:00')AS HORA    
       , CLOCKID    
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'       
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE'     
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO'     
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE    
 ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#    
FROM [Genesis].[dbo].rawdata A     
RIGHT     
--left    
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)     
   where CAST(DATE AS DATE) = @fecha     
group by    
   b.firstname,b.lastname    
   ,b.user1    
   ,badge, date    
   ,clockid,a.time    
    
)   B ON A.cedula = b.CEDULA     
    
) b    
where a.Cedula = b.cedula    
   and b.NumeroPonche = 5    
    
/*    
=====================================================================================================    
*/    
    
    
    
    
declare @email varchar(500) =     
(    
    
SELECT     
      [Email]    
  FROM [AuditoriaDB].[dbo].[tblParametros]    
  where id = 6    
)    
    
    
--while exists (    
--select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]    
--where enviado = 0  AND HORA > '11:00:00' AND HORA < '15:00:00'    
    
--order by fecha asc    
    
--)    
--begin    
    
    
DECLARE @Body NVARCHAR(MAX),    
    @TableHead VARCHAR(1000),    
    @TableTail VARCHAR(1000)    
 ,@dias int = 2    
 --,@fecha varchar(10)     
     
-- /*    
     
-- Asignar fecha a enviar al personal de resursos humanos    
-- */    
--set @fecha = (    
--select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]    
--where enviado = 0  AND HORA > '11:00:00' AND HORA < '15:00:00'    
--order by fecha asc    
    
    
--)    
    
    
--set @fecha = '2019-05-27'    
    
if exists (    
select * from  @PivotPonches    
)    
begin    
    
SET @TableTail = '</table></body></html>' ;    
SET @TableHead = '<html><head>' + '<style>'    
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '    
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +'  </h1> '    
    + CONVERT(VARCHAR(50), GETDATE(), 100)     
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>'     
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'    
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'    
 + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'    
 + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'    
 + '<td bgcolor=#ffffb3><b>Minutos</b></td>'    
 + '<td bgcolor=#ffffb3><b>Salida</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Sucursal</b></td>   + '</tr>' ;    
    
SET @Body = (    
    
    
    
    
    
select distinct    
 td = cedula, ''    
 ,td = nombres, ''    
 ,td = Fecha , ''    
 ,td = isnull(Entrada,'00:00:00'), ''    
 , td =isnull(Sal_almuerzo,'00:00:00') , ''    
 ,td = isnull(Ent_Almuerzo,'00:00:00') , ''    
 ,td = isnull(Min_Almuerzo,0)-60 , ''    
    
 ,td = isnull( Salida,'00:00:00') , ''    
 from @PivotPonches     
  where (Min_Almuerzo > 65 or Min_Almuerzo < 5)    
     and cedula  not in     
    (    
        
    select Cedula    
     from  [Genesis].[PonchesDB].VacacionesRH    
     where  getdate() between fecha_Inicio and fecha_fin    
    
    
    )    
    
 order by nombres    
     
            FOR   XML RAW('tr'),    
                  ELEMENTS    
            )    
    
    
    
SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail    
    
    
    
EXEC sp_send_dbmail     
  @profile_name='SqlMail',    
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO; francis.rodriguez@inabima.gob.do' ,     
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',    
  @subject='Reporte de Eventos horas de Almuerzo.',    
  @body=@Body ,    
  @body_format = 'HTML' ;    
    
    
    
    
 -- update [Genesis].[PonchesDB].[DatosReloj_Cargar]     
 --   set enviado = 1    
 --where fecha = @fecha    
 -- AND HORA > '11:00:00' AND HORA < '15:30:00'    
    
    
end    
    
    
    
    
    
    
if exists (    
select * from  @PivotPonches    
)    
begin    
    
    
    
    
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
    
    
set @email =     
(    
  select top 1     
     [EMAILSUPERVISOR]    
  from    
  [genesis].[PonchesDB].[SupervisoresCorreos]     
   Where  [activarEnvioCorreo]= 1    
    and enviado = 0    
)    
    
    
    
--set @email = 'jose.jimenez@inabima.gob.do'    
    
    
    
SET @TableTail = '</table></body></html>' ;    
SET @TableHead = '<html><head>' + '<style>'    
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '    
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +   '   </h1> '    
    + CONVERT(VARCHAR(50), GETDATE(), 100)     
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>'     
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'    
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'    
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'    
 + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'    
 + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'    
 + '<td bgcolor=#ffffb3><b>Minutos</b></td>'    
 + '<td bgcolor=#ffffb3><b>Salida</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'    
    --+ '<td bgcolor=#E6E6FA><b>Sucursal</b></td>    
 + '</tr>' ;    
    
SET @Body = (    
    
    
    
    
    
select distinct    
 td = cedula, ''    
 ,td = nombres, ''    
 ,td = Fecha , ''    
 ,td = isnull(Entrada,'00:00:00'), ''    
 , td =isnull(Sal_almuerzo,'00:00:00') , ''    
 ,td = isnull(Ent_Almuerzo,'00:00:00') , ''    
 ,td = isnull(Min_Almuerzo,0)-60 , ''    
    
 ,td = isnull( Salida,'00:00:00') , ''    
 from @PivotPonches     
  where (Min_Almuerzo > 65 or Min_Almuerzo < 5)    
     and cedula  not in     
    (    
        
    select Cedula    
     from  [Genesis].[PonchesDB].VacacionesRH    
     where  getdate() between fecha_Inicio and fecha_fin    
    
    
    )    
 and cedula in (    
    select CEDULA_EMP from genesis.[PonchesDB].[SupervisoresCorreos] where EMAILSUPERVISOR = @email    
    )    
    
    
/*=======================================================================================================================*/    
    
 order by nombres    
     
            FOR   XML RAW('tr'),    
                  ELEMENTS    
            )    
    
    
    
SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail    
    
    
    
EXEC sp_send_dbmail     
  @profile_name='SqlMail',    
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO' , -- ; francis.rodriguez@inabima.gob.do' ,     
  @recipients= @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',    
  @subject='Reporte de Eventos horas de Almuerzo.',    
  @body=@Body ,    
  @body_format = 'HTML' ;    
    
    
    
  print @email;    
    
  update [genesis].[PonchesDB].[SupervisoresCorreos]     
 set enviado = 1     
  Where  [activarEnvioCorreo]= 1    
  and enviado = 0    
  and [EMAILSUPERVISOR] = @email    
    
    
    
    
  end    
    
  update [Genesis].[PonchesDB].[DatosReloj_Cargar]     
    set enviado = 1    
 where fecha = @fecha    
  AND HORA > '11:00:00' AND HORA < '15:30:00'    
  and enviado!= 1    
    
    
end    
    
    
    
    
    
    
  update [Genesis].[PonchesDB].[DatosReloj_Cargar]     
    set enviado = 1    
 where fecha = @fecha    
  AND HORA > '11:00:00' AND HORA < '15:30:00'    
    
    
      
--end     
    
    