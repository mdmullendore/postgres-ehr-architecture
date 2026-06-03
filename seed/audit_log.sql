INSERT INTO audit_log (
    audit_id,
    occurred_at,
    table_name,
    record_id,
    action,
    old_data,
    new_data,
    actor_staff_user_id,
    actor_portal_user_id,
    ip_address,
    session_id
) VALUES
    (
        '10000000-0000-4000-8000-000000000701',
        '2026-05-01 08:00:00+00',
        'staff_users',
        '10000000-0000-4000-8000-000000000101',
        'update',
        '{"mfa_enabled": false}'::jsonb,
        '{"mfa_enabled": true}'::jsonb,
        '10000000-0000-4000-8000-000000000101',
        NULL,
        '192.168.10.10',
        'admin-setup-001'
    ),
    (
        '10000000-0000-4000-8000-000000000702',
        '2026-05-27 19:35:00+00',
        'patient_portal_users',
        '10000000-0000-4000-8000-000000000401',
        'update',
        '{"failed_login_count": 2}'::jsonb,
        '{"failed_login_count": 0}'::jsonb,
        NULL,
        '10000000-0000-4000-8000-000000000401',
        '203.0.113.44',
        'portal-login-8821'
    ),
    (
        '10000000-0000-4000-8000-000000000703',
        '2026-04-20 12:00:00+00',
        'providers',
        '10000000-0000-4000-8000-000000000201',
        'insert',
        NULL,
        '{"npi_individual": "1123456789", "last_name": "Chen"}'::jsonb,
        '10000000-0000-4000-8000-000000000101',
        NULL,
        '192.168.10.50',
        'seed-manual-audit'
    )
ON CONFLICT (audit_id) DO NOTHING;
