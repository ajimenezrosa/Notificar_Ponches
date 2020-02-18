  
declare @fechaentrada varchar(10)   
declare @fecha varchar(10) = convert(varchar(10), getdate(), 120)


SET @fechaentrada = CONVERT(char(2), DatePart (hh,GetDate())) + ':' + CONVERT(char(2), DatePart (mi,GetDate())) + ':00'   


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