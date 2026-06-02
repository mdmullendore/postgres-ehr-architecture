CREATE TABLE IF NOT EXISTS staff_roles (
    role_id    UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code  VARCHAR(30)  NOT NULL UNIQUE,
    role_name  VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO staff_roles (role_code, role_name) VALUES
    ('admin',       'Administrator'),
    ('clinician',   'Clinician')
ON CONFLICT (role_code) DO NOTHING;

COMMENT ON TABLE staff_roles IS 'Staff role definitions for least-privilege access control.';
