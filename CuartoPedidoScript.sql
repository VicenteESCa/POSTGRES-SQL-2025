CREATE OR REPLACE FUNCTION update_season_driver_stats(
    p_year INT,
    p_driver_id VARCHAR(100),
    p_new_wins INT,
    p_new_points DECIMAL(8, 2)
)
RETURNS VOID AS $$
DECLARE
    v_max_races INT;
BEGIN
    SELECT COUNT(id) INTO v_max_races 
    FROM race
    WHERE year = p_year;
    
    IF p_new_wins > v_max_races THEN
        RAISE EXCEPTION 'Regla de Negocio Incumplida: El total de victorias (%) no puede exceder el número total de carreras (%) en la temporada %.',
            p_new_wins, v_max_races, p_year;
    END IF;

    UPDATE season_driver
    SET 
        total_race_wins = p_new_wins,
        total_points = p_new_points
    WHERE year = p_year AND driver_id = p_driver_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_season_driver_secure(
    p_year INT,
    p_driver_id VARCHAR(100)
)
RETURNS VOID AS $$
DECLARE
    v_entries INT;
BEGIN
    SELECT total_race_entries INTO v_entries
    FROM season_driver
    WHERE year = p_year AND driver_id = p_driver_id;

    IF v_entries > 0 THEN
        RAISE EXCEPTION 'Regla de Negocio de Borrado: No se puede eliminar el registro del piloto % (Año %) porque ya tiene % carreras registradas. Debe tener 0 participaciones para ser eliminado.',
            p_driver_id, p_year, v_entries;
    END IF;

    DELETE FROM season_driver
    WHERE year = p_year AND driver_id = p_driver_id;
    
    RAISE NOTICE 'Registro eliminado exitosamente para el piloto % en %', p_driver_id, p_year;
END;
$$ LANGUAGE plpgsql;

-- Insertamos un dato base para poder eliminarlo después
INSERT INTO season_driver (year, driver_id, total_race_wins, total_points, total_race_entries, total_race_starts, total_race_laps, total_podiums, total_pole_positions, total_fastest_laps, total_driver_of_the_day, total_grand_slams)
VALUES (2024, 'fernando-alonso', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

SELECT delete_season_driver_secure(2024, 'fernando-alonso');

-- Insertamos un dato base para poder actualizarlo después
INSERT INTO season_driver (year, driver_id, total_race_wins, total_points, total_race_entries, total_race_starts, total_race_laps, total_podiums, total_pole_positions, total_fastest_laps, total_driver_of_the_day, total_grand_slams)
VALUES (2024, 'alain-prost', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

SELECT update_season_driver_stats(2024, 'alain-prost', 5, 100.00);