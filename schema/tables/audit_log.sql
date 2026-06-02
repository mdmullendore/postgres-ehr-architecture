CREATE TABLE IF NOT EXISTS audit_log (
    audit_id              UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    occurred_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    table_name            VARCHAR(63)  NOT NULL,
    record_id             UUID         NOT NULL,
    action                VARCHAR(10)  NOT NULL
                              CHECK (action IN ('insert', 'update', 'delete')),
    old_data              JSONB,
    new_data              JSONB,
    actor_staff_user_id   UUID         REFERENCES staff_users (staff_user_id),
    actor_portal_user_id  UUID,
    ip_address            INET,
    session_id            VARCHAR(128)
);

CREATE INDEX IF NOT EXISTS idx_audit_log_occurred_at ON audit_log (occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_log_table_record ON audit_log (table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_actor_staff ON audit_log (actor_staff_user_id)
    WHERE actor_staff_user_id IS NOT NULL;

COMMENT ON TABLE  audit_log IS 'Append-only log of PHI table changes (HIPAA audit controls).';
COMMENT ON COLUMN audit_log.actor_portal_user_id IS
    'Set when a portal user acts; FK added after patient_portal_users exists.';
