-- Creación del esquema

CREATE SCHEMA mitaller;

-- Conecto con el esquema

USE mitaller;

-- Creación de tablas especificando claves primarias y foráneas

CREATE TABLE clientes(
	id_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    telefono INT NOT NULL, 
	dni INT NOT NULL, 
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL
);

CREATE TABLE usuarios(
	id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    password INT NOT NULL, 
	rol VARCHAR(45) NOT NULL, 
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL
);

CREATE TABLE estado(
	id_estado INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    tipo_estado VARCHAR(45) NOT NULL
);

CREATE TABLE forma_pago(
	id_pago INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    tipo_pago VARCHAR(45) NOT NULL
);

CREATE TABLE tecnicos(
	id_tecnico INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL
);

CREATE TABLE ordenes_de_trabajo(
    id_orden INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
    id_usuario INT NOT NULL, 
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
    id_estado INT NOT NULL,
	FOREIGN KEY (id_estado) REFERENCES estado (id_estado),
    id_tecnico INT NOT NULL, 
    FOREIGN KEY (id_tecnico) REFERENCES tecnicos (id_tecnico),
	item VARCHAR(45) NOT NULL,
	fecha_inicio DATE NOT NULL,
    fecha_fin DATE Null
); 

CREATE TABLE factura(
    id_factura INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
    id_orden INT NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES ordenes_de_trabajo (id_orden),
    id_pago int NOT NULL,
    FOREIGN KEY (id_pago) REFERENCES forma_pago (id_pago),
    importe INT NOT NULL, 
	fecha date NOT NULL
);

INSERT INTO clientes (id_cliente, telefono, dni, nombre, apellido)
VALUES (null, 1155889977, 30258147, 'beth', 'gibbons'),
(null, 1155998877, 30258148, 'roger', 'waters'),
(null, 1155998822, 30258149, 'tom', 'yorke'),
(null, 1155889999, 30258162, 'jimmy', 'hendrix'),
(null, 1155998832, 30258150, 'bjork', 'gum');

INSERT INTO usuarios (id_usuario, password, rol, nombre, apellido)
VALUES (null, 1234, 'supervisor', 'fito', 'paez'),
(null, 2255, 'vendedor', 'luis', 'spinetta'),
(null, 4321, 'tecnico', 'luca', 'prodan'),
(null, 3412, 'supervisor', 'gustavo', 'cerati'),
(null, 5522, 'tecnico', 'charly', 'garcia');

INSERT INTO estado (id_estado, tipo_estado)
VALUES (null, 'recibido'),
(null, 'diagnostico'),
(null, 'presupuestado'),
(null, 'esperando_aprobacion'),
(null, 'en_curso'),
(null, 'finalizado'),
(null, 'Facturado');

INSERT INTO forma_pago (id_pago, tipo_pago)
VALUES (null, 'contado'),
(null, 'debito'),
(null, 'credito'),
(null, 'ahora12'),
(null, 'ahora18'),
(null, 'cheque');

insert INTO tecnicos (id_tecnico, nombre, apellido)
VALUES (null, 'ricardo', 'mollo'),
(null, 'indio', 'solari'),
(null, 'adrian', 'dargelos'),
(null, 'axel', 'krygier'),
(null, 'norberto', 'napolitano');

insert INTO ordenes_de_trabajo (id_orden, id_cliente, id_usuario, id_estado, id_tecnico, item, fecha_inicio, fecha_fin)
VALUES (null, 1, 2, 6, 1, 'soldadora', '23-10-10', '23-10-20'),
(null, 2, 2, 6, 1, 'amoladora', '23-10-10', '23-10-23'),
(null, 3, 3, 2, 2, 'taladro', '23-10-11', '23-10-11'),
(null, 4, 3, 6, 3, 'lijadora', '23-10-12','23-10-19'),
(null, 5, 5, 4, 3, 'caladora', '23-10-13', '23-10-13'),
(null, 1, 2, 6, 1, 'soldadora', '23-10-10', '23-10-28');

insert INTO factura (id_factura, id_cliente, id_orden, id_pago, importe, fecha)
VALUES (null, 2, 1, 2, 2500, '23-10-20'),
(null, 2, 2, 2, 3000, '23-10-21'),
(null, 3, 3, 3, 1500, '23-10-22'),
(null, 4, 4, 3, 4000, '23-10-22'),
(null, 5, 5, 5, 5000, '23-10-24');


create or replace view item_recibido as
(select item from ordenes_de_trabajo
 where id_estado = 1);
 
create or replace view orden_recibido as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'recibido');
 
 create or replace view orden_diagnostico as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'diagnostico');
 
  create or replace view orden_presupuestado as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'presupuestado');
  
  create or replace view orden_esperando_aprobacion as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'esperando_aprobacion'); 

 create or replace view orden_en_curso as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'en_curso'); 
 
  create or replace view orden_finalizado as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'finalizado'); 

   create or replace view orden_entregado as
 (select tipo_estado, id_orden, item from ordenes_de_trabajo o join estado e on (o.id_estado = e.id_estado)
 where tipo_estado = 'entregado'); 

-- Funcion para Calcular el Tiempo promedio de reparacion por técnico

DELIMITER $$
CREATE FUNCTION calcularTiempoPromedioReparacionPorTecnico(idtecnico INT)
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE tiempoPromedio INT;
    SELECT AVG(DATEDIFF(fecha_inicio, fecha_fin)) INTO tiempoPromedio
    FROM ordenes_de_trabajo
    WHERE idtecnico = id_tecnico AND id_estado = 6;
    RETURN tiempoPromedio;
END;
$$ 

-- SELECT id_tecnico, calcularTiempoPromedioReparacionPorTecnico(id_tecnico) AS tiempoPromedio FROM ordenes_de_trabajo;

-- Funcion para Calcular el importe saldo total a pagar por cliente.

DELIMITER $$
CREATE FUNCTION obtenerTotalSaldoPorCliente(idcliente INT)
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT sum(importe) into total
    FROM factura
    WHERE id_cliente = idcliente;
    RETURN total;
END;
$$ 

-- SELECT id_cliente, obtenerTotalSaldoPorCliente(id_cliente) AS totalSaldo FROM factura group by id_cliente;

-- Realicé un store procedure para ver los detalles de la orden de trabajo seleccionada.

DELIMITER $$
CREATE PROCEDURE ObtenerDetallesOrden (IN sp_id_orden INT)
BEGIN
    SELECT
        o.id_orden,
        c.nombre AS nombre_cliente,
        c.apellido AS apellido_cliente,
        t.nombre AS nombre_tecnico,
        t.apellido AS apellido_tecnico,
        e.tipo_estado,
        o.item,
        o.fecha_inicio,
        o.fecha_fin
    FROM
        ordenes_de_trabajo o
        JOIN clientes c ON o.id_cliente = c.id_cliente
        JOIN tecnicos t ON o.id_tecnico = t.id_tecnico
        JOIN estado e ON o.id_estado = e.id_estado
    WHERE
        o.id_orden = sp_id_orden;
END $$

CALL ObtenerDetallesOrden(2);

-- Este un store procedure ordena alfabéticamente asc o des segun el parametro que le pase cualquier campo de la tabla tecnicos

DELIMITER $$
CREATE PROCEDURE sp_tecnicos_por_orden_alfabetico(IN field CHAR(20), IN order_direction CHAR(4))
BEGIN
    IF field <> '' THEN
        SET @tecnicos_orden_alf = CONCAT('ORDER BY ', field);
    ELSE
        SET @tecnicos_orden_alf = '';
    END IF;
    
    IF order_direction = 'ASC' THEN
        SET @orden = 'ASC';
    ELSE
        SET @orden = 'DESC';
    END IF;

    SET @clausula = CONCAT('SELECT * FROM tecnicos ', @tecnicos_orden_alf, ' ', @orden);
    PREPARE runSQL FROM @clausula;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END
$$

CALL sp_tecnicos_por_orden_alfabetico('apellido','DESC');

-- Este store procedure indica si la carga del nuevo cliente fue exitosa, o si 1 o más campos quedan vacíos indica un Error

DELIMITER $$
CREATE PROCEDURE sp_insertar_cliente(
    IN sp_nombre VARCHAR(255),
    IN sp_apellido VARCHAR(255),
    IN sp_telefono VARCHAR(20),
    IN sp_dni VARCHAR(15),
    OUT p_output VARCHAR(50))
BEGIN
    IF sp_nombre <> '' AND sp_apellido <> '' AND sp_telefono <> '' AND sp_dni <> '' THEN
        INSERT INTO clientes (nombre, apellido, telefono, dni)
        VALUES (sp_nombre, sp_apellido, sp_telefono, sp_dni);
        SET p_output = 'Inserción exitosa';
    ELSE
        SET p_output = 'ERROR: no se pudo crear el cliente indicado';
    END IF;
    SET @clausula = 'SELECT * FROM clientes ORDER BY id_cliente DESC';
    PREPARE runSQL FROM @clausula;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END $$

CALL sp_insertar_cliente('Demi', 'Koro', '1122345678', '28555555', @result);
SELECT @result as result_insertar_cliente;

CALL sp_insertar_cliente('', '', '', '', @result);
SELECT @result as result_insertar_cliente;

-- Actualizar el estado de la orden de trabajo a estado facturada (7). Cada vez que se realice una factura, el trigger automaticamente lo pasa al estado 7 que es el facturado.

DELIMITER $$
CREATE TRIGGER AfterGenerarFactura
AFTER INSERT ON factura 
FOR EACH ROW
BEGIN
    UPDATE ordenes_de_trabajo
    SET id_estado = 7  
    WHERE id_orden = NEW.id_orden;
END $$

insert INTO factura (id_factura, id_cliente, id_orden, id_pago, importe, fecha)
VALUES (null, 2, 1, 2, 2500, '23-10-28');

Select * from ordenes_de_trabajo;

-- TRIGGER LOGS -- 

--  Creación tabla de registros ordenes_logs

CREATE TABLE ordenes_logs (
	id_log INT PRIMARY KEY auto_increment,
    entidad varchar(100),
    id_orden int,
    fecha_insert datetime,
    creado_por varchar(100),
    fecha_ultima_modificacion datetime,
    ultima_modificacion_por varchar(100)
);

--  Registro de movimientos en tabla Ordenes. Deja registro de los movimientos realizados en ordenes de trabajo, en una tabla en particular llamada ordenes_logs.

CREATE TRIGGER `tr_registro_movimientos_ordenes`
AFTER INSERT ON `ordenes_de_trabajo`
FOR EACH ROW
INSERT INTO `ordenes_logs`(entidad, id_orden, fecha_insert, creado_por, fecha_ultima_modificacion, ultima_modificacion_por) 
VALUES ('ordenes_de_trabajo', NEW.id_orden, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

insert INTO ordenes_de_trabajo (id_orden, id_cliente, id_usuario, id_estado, id_tecnico, item, fecha_inicio, fecha_fin)
VALUES (null, 1, 2, 6, 1, 'nivel laser', '23-05-11', '23-07-11');

Select * from ordenes_logs;

-- Trigger BEFORE
-- Trigger modifica nombres y apellidos en mayúscula previo a la inserción.

DELIMITER $$
CREATE TRIGGER mayusculas_clientes
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
    SET NEW.nombre = UPPER(NEW.nombre);
    SET NEW.apellido = UPPER(NEW.apellido);
END $$

INSERT INTO clientes (id_cliente, telefono, dni, nombre, apellido)
VALUES (null, 1155889977, 30258147, 'jhony', 'greenwood');

SELECT * from clientes;


