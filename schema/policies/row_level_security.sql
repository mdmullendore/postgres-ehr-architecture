-- Row-level security: scope PHI to the session facility.
-- Application must set per transaction, e.g.:
--   SET LOCAL app.current_facility_id = '<uuid>';

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinical_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE patient_portal_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY patients_facility_isolation ON patients
    FOR ALL
    USING (
        facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
    )
    WITH CHECK (
        facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
    );

CREATE POLICY appointments_facility_isolation ON appointments
    FOR ALL
    USING (
        facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
    )
    WITH CHECK (
        facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
    );

CREATE POLICY clinical_notes_facility_isolation ON clinical_notes
    FOR ALL
    USING (
        EXISTS (
            SELECT 1
            FROM appointments a
            WHERE a.appointment_id = clinical_notes.appointment_id
              AND a.facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM appointments a
            WHERE a.appointment_id = clinical_notes.appointment_id
              AND a.facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
        )
    );

CREATE POLICY portal_users_facility_isolation ON patient_portal_users
    FOR ALL
    USING (
        EXISTS (
            SELECT 1
            FROM patients p
            WHERE p.patient_id = patient_portal_users.patient_id
              AND p.facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM patients p
            WHERE p.patient_id = patient_portal_users.patient_id
              AND p.facility_id = NULLIF(current_setting('app.current_facility_id', true), '')::UUID
        )
    );

COMMENT ON POLICY patients_facility_isolation ON patients IS
    'Requires app.current_facility_id for staff sessions; bypass only for migration roles.';
