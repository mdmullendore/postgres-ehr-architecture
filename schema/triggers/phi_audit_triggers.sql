CREATE TRIGGER trg_audit_patients
    AFTER INSERT OR UPDATE OR DELETE ON patients
    FOR EACH ROW EXECUTE FUNCTION record_phi_audit('patient_id');

CREATE TRIGGER trg_audit_appointments
    AFTER INSERT OR UPDATE OR DELETE ON appointments
    FOR EACH ROW EXECUTE FUNCTION record_phi_audit('appointment_id');

CREATE TRIGGER trg_audit_clinical_notes
    AFTER INSERT OR UPDATE OR DELETE ON clinical_notes
    FOR EACH ROW EXECUTE FUNCTION record_phi_audit('clinical_note_id');

CREATE TRIGGER trg_audit_patient_portal_users
    AFTER INSERT OR UPDATE OR DELETE ON patient_portal_users
    FOR EACH ROW EXECUTE FUNCTION record_phi_audit('portal_user_id');
