CREATE OR REPLACE FUNCTION validate_driver_stats_update()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."total_race_wins" < OLD."total_race_wins" THEN
        RAISE EXCEPTION 'Error de validación: No se puede reducir el número de victorias totales (de % a %) para el piloto ID %.',
            OLD."total_race_wins", NEW."total_race_wins", OLD."id";
    END IF;

    IF NEW."total_points" < OLD."total_points" THEN
        RAISE EXCEPTION 'Error de validación: No se puede reducir el número de puntos totales (de % a %) para el piloto ID %.',
            OLD."total_points", NEW."total_points", OLD."id";
    END IF;
    IF NEW."total_podiums" < OLD."total_podiums" THEN
        RAISE EXCEPTION 'Error de validación: No se puede reducir el número de podios totales (de % a %) para el piloto ID %.',
            OLD."total_podiums", NEW."total_podiums", OLD."id";
    END IF;	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_driver_update
BEFORE UPDATE ON "driver"
FOR EACH ROW p
EXECUTE FUNCTION validate_driver_stats_update();
-- Prueba
UPDATE "driver"
SET "total_race_wins" = 5 
WHERE "id" = 'alain-prost'; 
-- Demostracion
SELECT "id", "total_race_wins"
FROM "driver"
WHERE "id" = 'alain-prost';
