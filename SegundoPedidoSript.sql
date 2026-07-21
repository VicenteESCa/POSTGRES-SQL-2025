/*
En la siguiente seccion se hara las vistas tanto para el administrador como para el cliente,
y se crearan los roles y usuarios correspondientes con sus respectivos permisos.
Esta seccion es complementaria al PrimerPedidoScript.sql ya que
la vista de cliente se basa en la tabla "driver" que se creo en el primer script, por lo que debe ejecutarse despues de este.
*/

CREATE VIEW v_hall_of_fame AS
SELECT
    "total_podiums" AS "Podios",
    "total_points" AS "Puntos Totales"
    "full_name" AS "Piloto",
    "total_race_wins" AS "Victorias",
FROM "driver"
WHERE "total_race_wins" > 0
ORDER BY "Victorias" DESC


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "driver", "season_driver", "season_driver_standing" TO rol_admin;

CREATE USER admin_f1 LOGIN PASSWORD 'pass-word-ad-min-123';

GRANT rol_admin TO admin_f1;                    

CREATE ROLE rol_cliente;

GRANT SELECT ON v_hall_of_fame TO rol_cliente;

CREATE USER cliente_f1 LOGIN PASSWORD 'cli-ente-pass-123';

GRANT rol_cliente TO cliente_f1;