CREATE TABLE IF NOT EXISTS facilities (
    facility_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_name VARCHAR(150) NOT NULL,
    facility_type VARCHAR(50) NOT NULL,
                         CHECK (facility_type IN ('Hospital', 'Clinic', 'Urgent Care', 'Virtual')),
    address_line1 VARCHAR(150) NOT NULL,
    address_line2 VARCHAR(150),
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    fax_number VARCHAR(20),
    npi_facility VARCHAR(10),
    clia_number VARCHAR(10),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_facility_npi LENGTH(npi_facility) = 10
);

CREATE INDEX IF NOT EXISTS idx_facilities_active_name ON facilities(is_active, facility_name);

COMMENT ON TABLE  facilities                  IS 'Facility record for each facility.';
COMMENT ON COLUMN facilities.facility_id      IS 'Primary key, UUID.';
COMMENT ON COLUMN facilities.facility_name    IS 'Name of the facility (e.g., St. Mary\'s Hospital, St. Mary\'s Clinic).';
COMMENT ON COLUMN facilities.facility_type    IS 'Type of the facility (e.g., Hospital, Clinic, Urgent Care, Virtual).';
COMMENT ON COLUMN facilities.address_line1    IS 'First line of the address.';
COMMENT ON COLUMN facilities.address_line2    IS 'Second line of the address.';
COMMENT ON COLUMN facilities.city             IS 'City of the facility.';
COMMENT ON COLUMN facilities.state            IS 'State of the facility.';
COMMENT ON COLUMN facilities.zip_code         IS 'Zip code of the facility.';
COMMENT ON COLUMN facilities.phone_number     IS 'Phone number of the facility.';
COMMENT ON COLUMN facilities.email            IS 'Email of the facility.';
COMMENT ON COLUMN facilities.fax_number       IS 'Fax number of the facility.';
COMMENT ON COLUMN facilities.npi_facility     IS 'NPI number of the facility.';
COMMENT ON COLUMN facilities.clia_number      IS 'CLIA number of the facility.';
COMMENT ON COLUMN facilities.is_active        IS 'Active status of the facility.';
COMMENT ON COLUMN facilities.created_at       IS 'Creation timestamp of the facility.';
COMMENT ON COLUMN facilities.updated_at       IS 'Last update timestamp of the facility.';