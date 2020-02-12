

![Logo GitHub](https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ6YbjP5vT1VgTVr0p2ChwgAtmXZiiF0JuWCKDnEYgcNDqndVkF)


# Notificacion de Eventos de Ponches.

![ponches](https://ponchar.com/wp-content/uploads/2012/09/ponchador-para-el-control-de-asistencia.jpg)

# descripcion de procedure.
### Estos procedure notifican al persol tanto de RRHH como los diversos departamentos sobre los poches de Eventos de:
- Entradas Tardias, No ponches 
-  Salidas y entradas de almuerso 
-  Salidas anomalas
-----
### Strore Procedure en las bases de datos que ralizan las notificaciones al personal.

- Sp_PersonasConAnomaliasenAlmuerzo
- Sp_PersonasConAnomaliasenPonches
- Sp_PersonasQueDEbenPoncharYNoPonchan

--------

# Tablas Creadas para la parametrizacion de los envios.

- Los dias de la Semana
- El personal de la institucion
- Supervisores con sus Correos Electronicos a los cuales se les enviara la notificacion de sus Subordinados.
- registros de Vacaciones , Permisos y licencias medicas. Esto para excluirlos de las ***notificaciones de Ponches.***
-  Los Registros Descargados del Reloj de ponches con los Id de los empleados para macharlos con sus id del sistema. 
 - Las descripciones de los Horarios de los empleados. Con esto determinamos si la persona debia estar en la institucion o no. ***debio ponchar o no***
- Los Horarios de los Empleados, aqui se define cuales dias debe asistir el empleado y a que hora debe entrar, [Salir a Almorzar], [Regresar de almuerzo] y [Salir de institucion].

-----------
estas tablas se Alimentan de los Sistema de Recursos Humanos mediante Sincronizaciones realizadas a horas determinadas.

Los empleados se sincronizan Todos los dias a las ***6:00 AM*** 
Los Horarios de entradas de los empleados se sincronizan todos los dias a las ***6:00AM***


La tabla que contiene los Ponches se actualiza en el momento antes de realizar el envio de los Ponches via Correo Electronico.

# El Servidor de correo utilizado para realizar esta función es un Servidor SqlMail.

El correo NotifiacionSql sera creado para realizar los envios de las insidencias en el sistema de Ponches.

para poder controlar que los envios se hagan de forma correcta debemos asegurarnos de que los registros enviados fueron marcados como enviados en la base de datos.

## Existen dos tipos de notificaciones.
    
- notificaciones Directas a RRHH las cuales contienen todos los empleados que tienen insidencias.
-  Notificacion a los encargados de los departamenteos con sus empleados.

Anexo un Ejemplo de un envio de mail 

~~~Sql
declare @email varchar(1000) 
declare @Mensaje varchar(100)

EXEC sp_send_dbmail   
  @profile_name='NotifiacionSql',  
  @copy_recipients ='RRHH@SonnyBD.com',  
  @recipients=  @email,    
  @subject= @Mensaje,  
  @body=@Body ,  
  @body_format = 'HTML' ;  
  
~~~

# Formatos de envio de Correos y confirmacion del mismo.
  ###  Las notificaciones enviados por correo se emiten en un formato HTML.
  
  para esto debemos declarar 3 (tres)  variables

- Un Body que representara y conformara la etiqueta Body de nuestro HTML.
- Tablehead en el cual tendremos inicio de etiquetas html ,head y los estilos usando la etiqueta style.
- con la etiqueta TableTail se realizan los cierres de todo nuestro html.

~~~sql
DECLARE @Body NVARCHAR(MAX),  
    @TableHead VARCHAR(1000),  
    @TableTail VARCHAR(1000)  
 
~~~

estos ser ensamblarian de la siguiente forma:

     @TableHead
     @Body
     @TableTail





~~~sql
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
~~~


~~~sql
  SET @Body = (  
select   
    Cedula
    ,Nombres
    ,Fecha
    ,hora
    ,Departamento
    ,Codigo
    ,Sucursal
 from DatosPonches

      FOR   XML RAW('tr'),  
            ELEMENTS  
      )  
~~~


