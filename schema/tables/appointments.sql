CREATE TABLE IF NOT EXISTS appointments (
    appointment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL,
    provider_id UUID NOT NULL,
    facility_id UUID NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    appointment_type VARCHAR(50) NOT NULL,
    appointment_status VARCHAR(30) NOT NULL DEFAULT 'Scheduled',
    reason_for_visit TEXT,
    chief_complaint TEXT,
    provider_notes TEXT,
    administrative_notes TEXT,
    insurance_provider_id UUID,
    copay_amount NUMERIC(6, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    CONSTRAINT chk_appointment_times CHECK (end_time > start_time),
    CONSTRAINT chk_appointment_status CHECK (
        appointment_status IN (
            'Scheduled', 'Confirmed', 'Arrived', 'In Progress', 
            'Completed', 'Canceled', 'No Show', 'Rescheduled'
        )
    )
);

CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_provider_date ON appointments(provider_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_start_time ON appointments(start_time);

COMMENT ON TABLE  appointments                          IS 'Appointment record for each appointment.';
COMMENT ON COLUMN appointments.appointment_id           IS 'Primary key, UUID.';
COMMENT ON COLUMN appointments.patient_id               IS 'FK to patient record.';
COMMENT ON COLUMN appointments.provider_id              IS 'FK to provider record.';
COMMENT ON COLUMN appointments.facility_id              IS 'FK to facility record.';
COMMENT ON COLUMN appointments.appointment_date         IS 'Date of the appointment.';
COMMENT ON COLUMN appointments.start_time               IS 'Start time of the appointment.';
COMMENT ON COLUMN appointments.end_time                 IS 'End time of the appointment.';
COMMENT ON COLUMN appointments.appointment_type         IS 'Type of the appointment (e.g., New Patient, Follow-up, Annual Physical).';
COMMENT ON COLUMN appointments.appointment_status       IS 'Status of the appointment (e.g., Scheduled, Confirmed, Arrived, In Progress, Completed, Canceled, No Show, Rescheduled).';
COMMENT ON COLUMN appointments.reason_for_visit         IS 'Reason for the visit.';
COMMENT ON COLUMN appointments.chief_complaint          IS 'Chief complaint of the patient.';
COMMENT ON COLUMN appointments.provider_notes           IS 'Notes from the provider.';
COMMENT ON COLUMN appointments.administrative_notes     IS 'Notes from the administrative staff.';
COMMENT ON COLUMN appointments.insurance_provider_id    IS 'FK to insurance provider record (if applicable).';
COMMENT ON COLUMN appointments.copay_amount             IS 'Copay amount for the appointment.';
COMMENT ON COLUMN appointments.created_at               IS 'Creation timestamp of the appointment.';
COMMENT ON COLUMN appointments.updated_at               IS 'Last update timestamp of the appointment.';
COMMENT ON COLUMN appointments.created_by               IS 'FK to user record who created the appointment.';