CREATE TABLE IF NOT EXISTS providers (
    provider_id          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name           VARCHAR(50)   NOT NULL,
    middle_name          VARCHAR(50),
    last_name            VARCHAR(50)   NOT NULL,
    suffix               VARCHAR(10),
    gender               CHAR(1),
    date_of_birth        DATE,
    npi_individual       VARCHAR(10)   NOT NULL UNIQUE,
    state_license_number VARCHAR(50)   NOT NULL,
    dea_number           VARCHAR(9),
    primary_specialty    VARCHAR(100)  NOT NULL,
    taxonomy_code        VARCHAR(10),
    phone_number         VARCHAR(20)   NOT NULL,
    email                VARCHAR(100)  NOT NULL UNIQUE,
    is_active            BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_provider_suffix CHECK (
        suffix IS NULL OR suffix IN ('MD', 'DO', 'NP', 'PA', 'DDS', 'DPM', 'PharmD')
    ),
    CONSTRAINT chk_provider_gender CHECK (
        gender IS NULL OR gender IN ('M', 'F', 'O', 'U')
    ),
    CONSTRAINT chk_provider_npi CHECK (length(npi_individual) = 10)
);

CREATE TRIGGER trg_providers_updated_at
    BEFORE UPDATE ON providers
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_providers_last_name ON providers (last_name, first_name);
CREATE INDEX IF NOT EXISTS idx_providers_specialty ON providers (primary_specialty) WHERE is_active = TRUE;

COMMENT ON TABLE providers IS 'Clinician directory (NPI, license, specialty).';
