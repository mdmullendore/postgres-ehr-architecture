CREATE OR REPLACE FUNCTION record_phi_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_pk_column   TEXT;
    v_record_id   UUID;
    v_row         JSONB;
    v_old_data    JSONB;
    v_new_data    JSONB;
    v_action      VARCHAR(10);
    v_staff_id    UUID;
    v_portal_id   UUID;
BEGIN
    v_pk_column := TG_ARGV[0];
    v_action := lower(TG_OP);

    IF TG_OP = 'DELETE' THEN
        v_row := to_jsonb(OLD);
        v_old_data := v_row;
        v_new_data := NULL;
    ELSIF TG_OP = 'INSERT' THEN
        v_row := to_jsonb(NEW);
        v_old_data := NULL;
        v_new_data := v_row;
    ELSE
        v_row := to_jsonb(NEW);
        v_old_data := to_jsonb(OLD);
        v_new_data := v_row;
    END IF;

    v_record_id := (v_row ->> v_pk_column)::UUID;

    BEGIN
        v_staff_id := NULLIF(current_setting('app.current_staff_user_id', true), '')::UUID;
    EXCEPTION
        WHEN invalid_text_representation THEN
            v_staff_id := NULL;
    END;

    BEGIN
        v_portal_id := NULLIF(current_setting('app.current_portal_user_id', true), '')::UUID;
    EXCEPTION
        WHEN invalid_text_representation THEN
            v_portal_id := NULL;
    END;

    INSERT INTO audit_log (
        table_name,
        record_id,
        action,
        old_data,
        new_data,
        actor_staff_user_id,
        actor_portal_user_id,
        ip_address,
        session_id
    ) VALUES (
        TG_TABLE_NAME,
        v_record_id,
        v_action,
        v_old_data,
        v_new_data,
        v_staff_id,
        v_portal_id,
        NULLIF(current_setting('app.client_ip', true), '')::INET,
        NULLIF(current_setting('app.session_id', true), '')
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION record_phi_audit() IS
    'Append-only PHI change log. Trigger arg 0 = PK column name. Set app.current_* session vars.';
