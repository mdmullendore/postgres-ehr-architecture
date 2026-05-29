CREATE TABLE IF NOT EXISTS "user" (
    user_id       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id    UUID          NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    email         VARCHAR(255)  NOT NULL UNIQUE,
    password_hash TEXT          NOT NULL,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE TRIGGER trg_user_updated_at
    BEFORE UPDATE ON "user"
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_user_patient_id ON "user" (patient_id);
CREATE INDEX IF NOT EXISTS idx_user_email      ON "user" (email);

COMMENT ON TABLE  "user"               IS 'Portal login credentials linked to a patient record.';
COMMENT ON COLUMN "user".user_id       IS 'Primary key, UUID.';
COMMENT ON COLUMN "user".patient_id    IS 'FK to patient — one portal account per patient.';
COMMENT ON COLUMN "user".email         IS 'Login email, must match patient contact email.';
COMMENT ON COLUMN "user".password_hash IS 'bcrypt hash of the user password. Never store plaintext.';