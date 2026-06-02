CREATE TABLE IF NOT EXISTS providers (
    provider_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),
                CHECK (suffix IN ('MD', 'DO', 'NP', 'PA', 'DDS', 'etc.')),
    gender CHAR(1),
                CHECK (gender IN ('M', 'F', 'O', 'U')),
    date_of_birth DATE,
    npi_individual VARCHAR(10) NOT NULL UNIQUE,
    state_license_number VARCHAR(50) NOT NULL,
    dea_number VARCHAR(9),
    primary_specialty VARCHAR(100) NOT NULL,
    taxonomy_code VARCHAR(10),
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_provider_npi CHECK (length(npi_individual) = 10)
);

CREATE INDEX IF NOT EXISTS idx_providers_last_name ON providers(last_name, first_name);
CREATE INDEX IF NOT EXISTS idx_providers_specialty ON providers(primary_specialty) WHERE is_active = TRUE;

COMMENT ON TABLE  providers                       IS 'Provider record for each provider.';
COMMENT ON COLUMN providers.provider_id           IS 'Primary key, UUID.';
COMMENT ON COLUMN providers.first_name            IS 'First name of the provider.';
COMMENT ON COLUMN providers.middle_name           IS 'Middle name of the provider.';
COMMENT ON COLUMN providers.last_name             IS 'Last name of the provider.';
COMMENT ON COLUMN providers.suffix                IS 'Suffix of the provider.';
COMMENT ON COLUMN providers.gender                IS 'Gender of the provider.';
COMMENT ON COLUMN providers.date_of_birth         IS 'Date of birth of the provider.';
COMMENT ON COLUMN providers.npi_individual        IS 'NPI number of the provider.';
COMMENT ON COLUMN providers.state_license_number  IS 'State license number of the provider.';
COMMENT ON COLUMN providers.dea_number            IS 'DEA number of the provider.';
COMMENT ON COLUMN providers.primary_specialty     IS 'Primary specialty of the provider.';
COMMENT ON COLUMN providers.taxonomy_code         IS 'Taxonomy code of the provider.';
COMMENT ON COLUMN providers.phone_number          IS 'Phone number of the provider.';
COMMENT ON COLUMN providers.email                 IS 'Email of the provider.';
COMMENT ON COLUMN providers.is_active             IS 'Active status of the provider.';
COMMENT ON COLUMN providers.created_at            IS 'Creation timestamp of the provider.';
COMMENT ON COLUMN providers.updated_at            IS 'Last update timestamp of the provider.';