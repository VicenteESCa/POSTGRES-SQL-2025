SELECT 
    d.full_name AS "Piloto",
    d.total_race_wins AS "Victorias",
    d.nationality_country_id AS "Nacionalidad"
FROM 
    driver d
WHERE 
    d.total_race_wins > (
        SELECT AVG(total_race_wins) 
        FROM driver 
        WHERE total_race_wins >= 0
    )
    AND (d.nationality_country_id = 'argentina' OR d.nationality_country_id = 'germany');

(SELECT 
	"full_name" AS "Piloto", 
	"total_race_wins" AS "Victorias", 
	"nationality_country_id" AS "Nacionalidad"
FROM 
	"driver"
WHERE 
	"total_race_wins" > (SELECT AVG("total_race_wins") 
	FROM "driver" 
	WHERE "total_race_wins" >= 0) AND "nationality_country_id" = 'argentina'
)
UNION
(
SELECT 
	"full_name" AS "Piloto", 
	"total_race_wins" AS "Victorias", 
	"nationality_country_id" AS "Nacionalidad"
FROM 
	"driver"
WHERE 
	"total_race_wins" > (SELECT AVG("total_race_wins") 
	FROM "driver"
	WHERE "total_race_wins" >= 0) AND "nationality_country_id" = 'germany'
);

CREATE INDEX idx_driver_nationality ON driver(nationality_country_id);