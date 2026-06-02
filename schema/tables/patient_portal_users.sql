CREATE TABLE IF NOT EXISTS patient_portal_users (
    portal_user_id       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id           UUID          NOT NULL UNIQUE REFERENCES patients (patient_id) ON DELETE CASCADE,
    email                VARCHAR(255)  NOT NULL UNIQUE,
    password_hash        TEXT          NOT NULL,
    mfa_enabled          BOOLEAN       NOT NULL DEFAULT FALSE,
    failed_login_count   INTEGER       NOT NULL DEFAULT 0,
    locked_until         TIMESTAMPTZ,
    last_login_at        TIMESTAMPTZ,
    password_changed_at  TIMESTAMPTZ,
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_portal_failed_login_nonneg CHECK (failed_login_count >= 0)
);

CREATE TRIGGER trg_patient_portal_users_updated_at
    BEFORE UPDATE ON patient_portal_users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_portal_users_patient ON patient_portal_users (patient_id);
CREATE INDEX IF NOT EXISTS idx_portal_users_email   ON patient_portal_users (email);

ALTER TABLE audit_log
    ADD CONSTRAINT fk_audit_log_portal_user
    FOREIGN KEY (actor_portal_user_id) REFERENCES patient_portal_users (portal_user_id);

COMMENT ON TABLE  patient_portal_users IS 'Patient portal credentials (one account per patient).';
COMMENT ON COLUMN patient_portal_users.email IS
    'Login identifier; patient contact email lives on patients.email.';
