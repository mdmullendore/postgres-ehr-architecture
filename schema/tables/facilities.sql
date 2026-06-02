CREATE TABLE IF NOT EXISTS facilities (
    facility_id    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_name  VARCHAR(150)  NOT NULL,
    facility_type  VARCHAR(50)   NOT NULL
                       CHECK (facility_type IN ('Hospital', 'Clinic', 'Urgent Care', 'Virtual')),
    address_line1  VARCHAR(150)  NOT NULL,
    address_line2  VARCHAR(150),
    city           VARCHAR(100)  NOT NULL,
    state          CHAR(2)       NOT NULL,
    zip_code       VARCHAR(10)   NOT NULL,
    phone_number   VARCHAR(20)   NOT NULL,
    email          VARCHAR(100),
    fax_number     VARCHAR(20),
    npi_facility   VARCHAR(10),
    clia_number    VARCHAR(10),
    is_active      BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_facility_npi CHECK (
        npi_facility IS NULL OR length(npi_facility) = 10
    )
);

CREATE TRIGGER trg_facilities_updated_at
    BEFORE UPDATE ON facilities
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_facilities_active_name ON facilities (is_active, facility_name);

COMMENT ON TABLE  facilities               IS 'Care sites (hospital, clinic, urgent care, virtual).';
COMMENT ON COLUMN facilities.npi_facility    IS 'Facility NPI when assigned (10 digits).';
