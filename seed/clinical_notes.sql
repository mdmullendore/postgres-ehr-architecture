SET LOCAL app.current_facility_id = '10000000-0000-4000-8000-000000000001';
SET LOCAL app.current_staff_user_id = '10000000-0000-4000-8000-000000000102';
SET LOCAL app.client_ip = '192.168.10.50';
SET LOCAL app.session_id = 'seed-session-notes';

INSERT INTO clinical_notes (
    clinical_note_id,
    appointment_id,
    note_type,
    note_body,
    created_by,
    updated_by
) VALUES
    (
        '10000000-0000-4000-8000-000000000601',
        '10000000-0000-4000-8000-000000000501',
        'chief_complaint',
        'Patient presents for annual wellness visit. No acute complaints.',
        '10000000-0000-4000-8000-000000000102',
        '10000000-0000-4000-8000-000000000102'
    ),
    (
        '10000000-0000-4000-8000-000000000602',
        '10000000-0000-4000-8000-000000000501',
        'provider_note',
        'Vitals within normal limits. Discussed diet and exercise. Labs ordered: CBC, lipid panel. Plan: return in 12 months.',
        '10000000-0000-4000-8000-000000000102',
        '10000000-0000-4000-8000-000000000102'
    ),
    (
        '10000000-0000-4000-8000-000000000603',
        '10000000-0000-4000-8000-000000000502',
        'chief_complaint',
        'Follow-up for elevated blood pressure noted at last visit.',
        '10000000-0000-4000-8000-000000000102',
        '10000000-0000-4000-8000-000000000102'
    ),
    (
        '10000000-0000-4000-8000-000000000604',
        '10000000-0000-4000-8000-000000000503',
        'provider_note',
        'A1c 7.8%, down from 8.2%. Medication adherence reviewed. Continue metformin; schedule ophthalmology referral.',
        '10000000-0000-4000-8000-000000000103',
        '10000000-0000-4000-8000-000000000103'
    ),
    (
        '10000000-0000-4000-8000-000000000605',
        '10000000-0000-4000-8000-000000000504',
        'administrative',
        'Parent/guardian consented to telehealth session. Interpreter not required.',
        '10000000-0000-4000-8000-000000000101',
        '10000000-0000-4000-8000-000000000101'
    )
ON CONFLICT (clinical_note_id) DO NOTHING;
