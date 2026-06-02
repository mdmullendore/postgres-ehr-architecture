CREATE TABLE IF NOT EXISTS clinical_notes (
    clinical_note_id  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    appointment_id    UUID          NOT NULL REFERENCES appointments (appointment_id) ON DELETE CASCADE,
    note_type         VARCHAR(30)   NOT NULL
                          CHECK (note_type IN (
                              'chief_complaint', 'provider_note', 'administrative'
                          )),
    note_body         TEXT          NOT NULL,
    created_by        UUID          REFERENCES staff_users (staff_user_id),
    updated_by        UUID          REFERENCES staff_users (staff_user_id),
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_clinical_notes_updated_at
    BEFORE UPDATE ON clinical_notes
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_clinical_notes_appointment ON clinical_notes (appointment_id);

COMMENT ON TABLE clinical_notes IS 'Clinical and administrative narrative PHI, separated from scheduling.';
