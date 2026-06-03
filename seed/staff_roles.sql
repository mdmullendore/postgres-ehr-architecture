INSERT INTO staff_roles (role_code, role_name) VALUES
    ('admin',       'Administrator'),
    ('clinician',   'Clinician'),
    ('front_desk',  'Front Desk')
ON CONFLICT (role_code) DO NOTHING;
