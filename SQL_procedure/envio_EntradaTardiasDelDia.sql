
  
declare @Mensaje varchar(1000);  
  
declare @email varchar(500) =   
(  
  
SELECT   
      [Email]  
  FROM [AuditoriaDB].[dbo].[tblParametros]  
  where id = 6  
)  
  
  

  
DECLARE @Body NVARCHAR(MAX),  
    @TableHead VARCHAR(1000),  
    @TableTail VARCHAR(1000)  
 ,@dias int = 2  
 ,@fecha varchar(10)   
   
 /*  
   
 Asignar fecha a enviar al personal de resursos humanos  
 */  
set @fecha = (select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]  
where enviado = 1 AND HORA < '11:00:00'  
order by fecha asc  
)  
  
  set @fecha = convert(varchar(10),getdate(),120)
  
  
SET @TableTail = '</table></body></html>' ;  
SET @TableHead = '<html><head>' + '<style>'  
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '  
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Entrada Tardias : ' + @fecha +'  </h1> '  
    + CONVERT(VARCHAR(50), GETDATE(), 100)   
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>'   
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'  
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'  
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'  
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'  
    + '<td bgcolor=#E6E6FA><b>Departamento</b></td>'  
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'  
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;  
  
SET @Body = (  
select   
  
 td =  h.cedula, ''  
 , td = a.NOMBRE,''  
 --,a.CEDULA  
 , td = a.FECHA,''  
 ,td = a.HORA, ''  
 --,td = a.TIPO_PONCHE, ''  
 ,td = dp.DEPTO, ''  
 ,td = a.COD_RELOJ, ''  
 ,td = IsNull(c.descrip,'No Definido'), ''  
   
 --,a.CLOCKID  
   
 --,a.Cargado  
 --,a.enviado  
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a  
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha  
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche   
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID   
  /*Agregaremos el departamento segun solicitud de Francis Rodriguez de RRHH*/  
  join [Genesis].[PonchesDB].SupervisoresCorreos DP on a.CEDULA = dp.CEDULA_EMP  
 where (a.HORA > D.entrada  and a.HORA < D.almuerzo )  
    or a.HORA is null  
    and h.cedula not in   
    (  
      
    select Cedula  
     from  [Genesis].[PonchesDB].VacacionesRH  
     where  getdate() between fecha_Inicio and fecha_fin  
  
  
    )  
 group by  
 h.cedula   
 ,a.NOMBRE  
 --,a.CEDULA  
 ,a.FECHA  
 ,a.HORA  
 --,a.TIPO_PONCHE  
 ,dp.DEPTO  
 ,a.COD_RELOJ  
 ,a.CLOCKID  
 ,c.descrip  
 order by fecha desc  
  
  
            FOR   XML RAW('tr'),  
                  ELEMENTS  
            )  
  
  
--select * from [Genesis].[PonchesDB].SupervisoresCorreos  
  
  
SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail  
  
  
  
EXEC sp_send_dbmail   
  @profile_name='SqlMail',  
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',  
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',  
  @subject='Reporte de entradas Tardias.',  
  @body=@Body ,  
  @body_format = 'HTML' ;  
  