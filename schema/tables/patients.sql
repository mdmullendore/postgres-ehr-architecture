CREATE TABLE IF NOT EXISTS patients (
    patient_id           UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_id          UUID            NOT NULL REFERENCES facilities (facility_id),
    mrn                  VARCHAR(20)     NOT NULL,
    first_name           VARCHAR(100)    NOT NULL,
    last_name            VARCHAR(100)    NOT NULL,
    date_of_birth        DATE            NOT NULL,
    sex                  VARCHAR(10)     NOT NULL
                             CHECK (sex IN ('male', 'female', 'intersex', 'unknown')),
    gender_identity      VARCHAR(50),
    phone_primary        VARCHAR(20),
    email                VARCHAR(255),
    address_line1        TEXT,
    address_line2        TEXT,
    city                 VARCHAR(100),
    state                VARCHAR(100),
    postal_code          VARCHAR(20),
    country              VARCHAR(100)    DEFAULT 'US',
    is_active            BOOLEAN         NOT NULL DEFAULT TRUE,
    is_test              BOOLEAN         NOT NULL DEFAULT FALSE,
    deactivated_at       TIMESTAMPTZ,
    deactivation_reason  VARCHAR(50)
                             CHECK (deactivation_reason IS NULL OR deactivation_reason IN (
                                 'merged', 'deceased', 'duplicate', 'patient_request', 'other'
                             )),
    created_by           UUID            REFERENCES staff_users (staff_user_id),
    updated_by           UUID            REFERENCES staff_users (staff_user_id),
    created_at           TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_patients_facility_mrn UNIQUE (facility_id, mrn),
    CONSTRAINT chk_patients_deactivation_consistency CHECK (
        (is_active = TRUE AND deactivated_at IS NULL)
        OR (is_active = FALSE)
    )
);

CREATE TRIGGER trg_patients_updated_at
    BEFORE UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_patients_facility ON patients (facility_id);
CREATE INDEX IF NOT EXISTS idx_patients_active   ON patients (facility_id, is_active) WHERE is_active = TRUE;

COMMENT ON TABLE  patients                      IS 'Core demographic and contact record for each patient.';
COMMENT ON COLUMN patients.mrn                  IS 'Medical Record Number — unique within the facility.';
COMMENT ON COLUMN patients.is_test              IS 'TRUE for synthetic/test patients; exclude from production reporting.';
COMMENT ON COLUMN patients.deactivation_reason  IS 'Why the record was deactivated (soft retire, not hard delete).';
