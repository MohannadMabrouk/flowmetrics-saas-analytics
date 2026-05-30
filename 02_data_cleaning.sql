-- ============================================================
-- 02 — Data Cleaning
--
-- Produces two clean tables (users_clean, payments_clean) from
-- the raw tables, applying the cleaning decisions documented in
-- DATA_QUALITY_FINDINGS.md.
--
-- Cleaning applied:
--   1. users     → drop 8 content-level duplicates on
--                  (customer_id, normalized email);
--   2. payments  → drop 5 content-level duplicates on
--                  (customer_id, subscription_id, invoice_date, amount)
--
-- Other tables (customers, subscriptions, feature_usage,
-- support_tickets) passed all quality checks and are queried as-is.
--
-- Design notes:
--   - Raw tables are NOT modified — clean tables sit alongside them
--     to preserve the audit trail and allow rollback.
--   - DROP TABLE IF EXISTS makes this script idempotent
--     (safe to re-run from scratch).
--   - ROW_NUMBER() with ORDER BY <primary_key> ensures the kept
--     row is deterministic — every run keeps the same record.

-- ============================================================


-- ============================================================
-- 1. CLEAN USERS
-- ============================================================
-- Issue: 8 cases where the same person (same customer_id + email)
-- appears with two different user_ids. Also 189 emails contain leading/trailing whitespace.
-- Resolution: keep the first row per (customer_id, normalized email);
-- store the cleaned email in `clean_email`.
-- ============================================================

DROP TABLE IF EXISTS users_clean;

CREATE TABLE users_clean AS
WITH ranked_users AS (
    SELECT
        user_id,
        customer_id,
        first_name,
        last_name,
        LOWER(TRIM(email)) AS clean_email,
        role,
        signup_date,
        last_active_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, LOWER(TRIM(email))
            ORDER BY user_id
        ) AS rn
    FROM users
)
SELECT
    user_id,
    customer_id,
    first_name,
    last_name,
    clean_email,
    role,
    signup_date,
    last_active_date
FROM ranked_users
WHERE rn = 1;


-- ============================================================
-- 2. CLEAN PAYMENTS
-- ============================================================
-- Issue: 5 cases where the same invoice (same customer_id,
-- subscription_id, invoice_date, and amount) appears twice with
-- different payment_ids. Causes ~$760 of double-counted revenue
-- if left in.
-- Resolution: keep the first row per duplicate group.
-- ============================================================

DROP TABLE IF EXISTS payments_clean;

CREATE TABLE payments_clean AS
WITH ranked_payments AS (
    SELECT
        payment_id,
        customer_id,
        subscription_id,
        invoice_date,
        amount,
        status,
        paid_date,
        payment_method,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, subscription_id, invoice_date, amount
            ORDER BY payment_id
        ) AS rn
    FROM payments
)
SELECT
    payment_id,
    customer_id,
    subscription_id,
    invoice_date,
    amount,
    status,
    paid_date,
    payment_method
FROM ranked_payments
WHERE rn = 1;


-- ============================================================
-- 3. POST-CLEANING VERIFICATION
-- ============================================================
-- These queries confirm the cleaning worked as intended.
-- Each should return the expected result; if any does not,
-- something has changed in the raw data and the cleaning
-- assumptions need to be re-reviewed.
-- ============================================================

-- 3.1 — Final row counts
SELECT 'users_clean'    AS table_name, COUNT(*) AS row_count FROM users_clean
UNION ALL
SELECT 'payments_clean',                COUNT(*)             FROM payments_clean;
-- Expected: users_clean = 9,306, payments_clean = 2,565

-- 3.2 — Confirm no content-level duplicates remain in users_clean
SELECT customer_id, clean_email, COUNT(*) AS occurrences
FROM users_clean
GROUP BY customer_id, clean_email
HAVING COUNT(*) > 1;
-- Expected: 0 rows

-- 3.3 — Confirm no content-level duplicates remain in payments_clean
SELECT customer_id, subscription_id, invoice_date, amount, COUNT(*) AS occurrences
FROM payments_clean
GROUP BY customer_id, subscription_id, invoice_date, amount
HAVING COUNT(*) > 1;
-- Expected: 0 rows

-- 3.4 — Confirm emails in users_clean are fully normalized
SELECT COUNT(*) AS rows_with_uncleaned_email
FROM users_clean
WHERE clean_email != LOWER(TRIM(clean_email));
-- Expected: 0

-- 3.5 — Quantify the revenue impact of removing payment duplicates
SELECT
    (SELECT SUM(amount) FROM payments        WHERE status = 'paid') AS raw_paid_revenue,
    (SELECT SUM(amount) FROM payments_clean  WHERE status = 'paid') AS clean_paid_revenue,
    (SELECT SUM(amount) FROM payments        WHERE status = 'paid')
        - (SELECT SUM(amount) FROM payments_clean WHERE status = 'paid') AS double_counted_revenue;
-- Expected: difference ≈ $760 (the value double-counted due to duplicates)