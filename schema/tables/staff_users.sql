CREATE TABLE IF NOT EXISTS staff_users (
    staff_user_id      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_id        UUID          NOT NULL REFERENCES facilities (facility_id),
    role_id            UUID          NOT NULL REFERENCES staff_roles (role_id),
    email              VARCHAR(255)  NOT NULL UNIQUE,
    password_hash      TEXT          NOT NULL,
    first_name         VARCHAR(100)  NOT NULL,
    last_name          VARCHAR(100)  NOT NULL,
    is_active          BOOLEAN       NOT NULL DEFAULT TRUE,
    mfa_enabled        BOOLEAN       NOT NULL DEFAULT FALSE,
    failed_login_count INTEGER       NOT NULL DEFAULT 0,
    locked_until       TIMESTAMPTZ,
    last_login_at      TIMESTAMPTZ,
    password_changed_at TIMESTAMPTZ,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_staff_failed_login_nonneg CHECK (failed_login_count >= 0)
);

CREATE TRIGGER trg_staff_users_updated_at
    BEFORE UPDATE ON staff_users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_staff_users_facility ON staff_users (facility_id) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_staff_users_role     ON staff_users (role_id);

COMMENT ON TABLE  staff_users                    IS 'EHR staff accounts (distinct from patient portal).';
COMMENT ON COLUMN staff_users.password_hash       IS 'bcrypt hash only; never store plaintext.';
COMMENT ON COLUMN staff_users.facility_id         IS 'Primary facility scope for row-level access.';
