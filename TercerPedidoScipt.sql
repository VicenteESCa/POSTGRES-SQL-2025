CREATE TABLE driver_audit_log (
    driver_id VARCHAR(100),             
    operation_type VARCHAR(10),        
    changed_by VARCHAR(100),            
    changed_at TIMESTAMP DEFAULT NOW(), 
    log_id SERIAL PRIMARY KEY,          
    old_data JSONB,                     
    new_data JSONB                      
);

CREATE OR REPLACE FUNCTION log_driver_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO driver_audit_log (driver_id, operation_type, changed_by, new_data)
        VALUES (NEW.id, 'INSERT', current_user, to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO driver_audit_log (driver_id, operation_type, changed_by, old_data, new_data)
        VALUES (NEW.id, 'UPDATE', current_user, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO driver_audit_log (driver_id, operation_type, changed_by, old_data)
        VALUES (OLD.id, 'DELETE', current_user, to_jsonb(OLD));
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_driver_changes
AFTER INSERT OR UPDATE OR DELETE ON "driver"
FOR EACH ROW
EXECUTE FUNCTION log_driver_changes();

UPDATE "driver" SET "abbreviation" = 'ALO' WHERE "id" = 'fernando-alonso';
SELECT * FROM driver_audit_log ORDER BY log_id DESC;