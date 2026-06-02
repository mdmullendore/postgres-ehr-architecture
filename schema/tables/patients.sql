CREATE TABLE IF NOT EXISTS patients (
    patient_id       UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    mrn              VARCHAR(20)     NOT NULL UNIQUE,
    first_name       VARCHAR(100)    NOT NULL,
    last_name        VARCHAR(100)    NOT NULL,
    date_of_birth    DATE            NOT NULL,
    sex              VARCHAR(10)     NOT NULL
                         CHECK (sex IN ('male', 'female', 'intersex', 'unknown')),
    gender_identity  VARCHAR(50),
    phone_primary    VARCHAR(20),
    email            VARCHAR(255),
    address_line1    TEXT,
    address_line2    TEXT,
    city             VARCHAR(100),
    state            VARCHAR(100),
    postal_code      VARCHAR(20),
    country          VARCHAR(100)    DEFAULT 'US',
    blood_type       VARCHAR(5)
                         CHECK (blood_type IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    is_active        BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  patients                 IS 'Core demographic and contact record for each patient.';
COMMENT ON COLUMN patients.mrn             IS 'Medical Record Number — unique within the facility.';
COMMENT ON COLUMN patients.sex             IS 'Biological sex at birth.';
COMMENT ON COLUMN patients.gender_identity IS 'Patient self-reported gender identity.';
COMMENT ON COLUMN patients.is_active       IS 'FALSE for merged, deceased, or test records.';