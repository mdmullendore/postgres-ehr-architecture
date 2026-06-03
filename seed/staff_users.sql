INSERT INTO staff_users (
    staff_user_id,
    facility_id,
    role_id,
    email,
    password_hash,
    first_name,
    last_name,
    is_active,
    mfa_enabled,
    last_login_at
) VALUES
    (
        '10000000-0000-4000-8000-000000000101',
        '10000000-0000-4000-8000-000000000001',
        (SELECT role_id FROM staff_roles WHERE role_code = 'admin'),
        'admin@riverside-clinic.example',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Alice',
        'Nguyen',
        TRUE,
        TRUE,
        '2026-05-28 08:15:00+00'
    ),
    (
        '10000000-0000-4000-8000-000000000102',
        '10000000-0000-4000-8000-000000000001',
        (SELECT role_id FROM staff_roles WHERE role_code = 'clinician'),
        'dr.chen@riverside-clinic.example',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Michael',
        'Chen',
        TRUE,
        FALSE,
        '2026-05-30 14:22:00+00'
    ),
    (
        '10000000-0000-4000-8000-000000000103',
        '10000000-0000-4000-8000-000000000002',
        (SELECT role_id FROM staff_roles WHERE role_code = 'admin'),
        'admin@cascade-general.example',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Jordan',
        'Patel',
        TRUE,
        TRUE,
        '2026-05-29 09:00:00+00'
    ),
    (
        '10000000-0000-4000-8000-000000000104',
        '10000000-0000-4000-8000-000000000001',
        (SELECT role_id FROM staff_roles WHERE role_code = 'front_desk'),
        'reception@riverside-clinic.example',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'Sam',
        'Rivera',
        TRUE,
        FALSE,
        '2026-05-31 07:45:00+00'
    )
ON CONFLICT (staff_user_id) DO NOTHING;
