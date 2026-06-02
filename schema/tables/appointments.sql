CREATE TABLE IF NOT EXISTS appointments (
    appointment_id        UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id            UUID           NOT NULL REFERENCES patients (patient_id),
    provider_id           UUID           NOT NULL REFERENCES providers (provider_id),
    facility_id           UUID           NOT NULL REFERENCES facilities (facility_id),
    appointment_date      DATE           NOT NULL,
    start_time            TIMESTAMPTZ    NOT NULL,
    end_time              TIMESTAMPTZ    NOT NULL,
    appointment_type      VARCHAR(50)    NOT NULL,
    appointment_status    VARCHAR(30)    NOT NULL DEFAULT 'Scheduled',
    reason_for_visit      VARCHAR(255),
    insurance_provider_id UUID,
    copay_amount          NUMERIC(6, 2)  DEFAULT 0.00,
    created_by            UUID           REFERENCES staff_users (staff_user_id),
    updated_by            UUID           REFERENCES staff_users (staff_user_id),
    created_at            TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_appointment_times CHECK (end_time > start_time),
    CONSTRAINT chk_appointment_status CHECK (
        appointment_status IN (
            'Scheduled', 'Confirmed', 'Arrived', 'In Progress',
            'Completed', 'Canceled', 'No Show', 'Rescheduled'
        )
    )
);

CREATE TRIGGER trg_appointments_updated_at
    BEFORE UPDATE ON appointments
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments (patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_provider_date ON appointments (provider_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_start_time ON appointments (start_time);
CREATE INDEX IF NOT EXISTS idx_appointments_facility ON appointments (facility_id);

COMMENT ON TABLE  appointments IS 'Scheduling and billing metadata; clinical narrative lives in clinical_notes.';
COMMENT ON COLUMN appointments.reason_for_visit IS 'Brief scheduling reason (not full clinical documentation).';
