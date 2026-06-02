CREATE TABLE IF NOT EXISTS users (
    user_id       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id    UUID          NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    email         VARCHAR(255)  NOT NULL UNIQUE,
    password_hash TEXT          NOT NULL,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE TRIGGER trg_user_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_user_patient_id ON users (patient_id);
CREATE INDEX IF NOT EXISTS idx_user_email      ON users (email);

COMMENT ON TABLE  users               IS 'Portal login credentials linked to a patient record.';
COMMENT ON COLUMN users.user_id       IS 'Primary key, UUID.';
COMMENT ON COLUMN users.patient_id    IS 'FK to patient — one portal account per patient.';
COMMENT ON COLUMN users.email         IS 'Login email, must match patient contact email.';
COMMENT ON COLUMN users.password_hash IS 'bcrypt hash of the user password. Never store plaintext.';