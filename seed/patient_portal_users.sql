SET LOCAL app.current_facility_id = '10000000-0000-4000-8000-000000000001';
SET LOCAL app.current_staff_user_id = '10000000-0000-4000-8000-000000000101';
SET LOCAL app.client_ip = '192.168.10.50';
SET LOCAL app.session_id = 'seed-session-portal';

INSERT INTO patient_portal_users (
    portal_user_id,
    patient_id,
    email,
    password_hash,
    mfa_enabled,
    last_login_at
) VALUES
    (
        '10000000-0000-4000-8000-000000000401',
        '10000000-0000-4000-8000-000000000301',
        'emma.portal@example.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        TRUE,
        '2026-05-27 19:30:00+00'
    ),
    (
        '10000000-0000-4000-8000-000000000402',
        '10000000-0000-4000-8000-000000000302',
        'james.portal@example.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        FALSE,
        '2026-05-20 11:05:00+00'
    )
ON CONFLICT (portal_user_id) DO NOTHING;
