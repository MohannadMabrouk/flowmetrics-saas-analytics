# Data Quality Findings

Profiling results from [`01_data_quality.ipynb`](01_data_quality.ipynb). Each check was run against the loaded MySQL database (~389,000 rows across 6 tables). Findings below are documented for transparency and to inform the cleaning decisions applied in `02_data_cleaning.ipynb`.

## Summary

| # | Check | Issues found | Severity | Resolution |
|---|---|---|---|---|
| 1 | Row counts vs. expected | All 6 tables match expected counts (800 / 9,314 / 1,105 / 367,350 / 8,765 / 2,570) | ✅ None | No action |
| 2.1 | Duplicate `customer_id` | 0 | ✅ None | No action |
| 2.2 | Duplicate `user_id` (primary key) | 0 | ✅ None | No action |
| 2.2b | **Content-level user duplicates** (same `customer_id` + `email`) | **8 cases** | ⚠️ Medium | Drop duplicates in cleaning step, keeping first occurrence per (customer_id, email) |
| 2.3 | Duplicate `subscription_id` | 0 | ✅ None | No action |
| 2.4 | Duplicate `payment_id` | 0 | ✅ None | No action |
| 2.4b | Content-level payment duplicates (same customer_id + subscription_id + invoice_date + amount) | 5 cases | ⚠️ Medium | Drop duplicates in cleaning step... ~$760 of double-counted revenue |
| 2.5 | Duplicate `ticket_id` | 0 | ✅ None | No action |
| 3.x | Foreign key orphans (all 5 checks) | 0 across all child tables | ✅ None | No action |
| 4.1 | Nulls in `customers` | 0 nulls in any column | ✅ None | No action |
| 4.2 | Nulls in `subscriptions.end_date` | 180 nulls (16% of rows) | ✅ Expected | Confirmed: all 180 nulls correspond to `status='active'` — these are currently-active subscriptions, which is correct |
| 4.3 | Nulls in `support_tickets.csat_score` | 3,063 nulls (34.9%) | ✅ Expected | Treat as "no response" (informative null). When averaging CSAT, exclude null rows rather than imputing |
| 4.3b | Nulls in `support_tickets.resolved_date` / `resolution_hours` | 20 each | ✅ Expected | Correspond to the 20 tickets with `status='open'` — correct |
| 5.1 | MRR negative values | 0 | ✅ None | No action |
| 5.2 | Payment negative amounts | 0 | ✅ None | No action |
| 5.3 | CSAT scores outside 1–5 | 0 (distribution: 1=13, 2=190, 3=1,202, 4=2,597, 5=1,700) | ✅ None | No action |
| 5.4 | Dates outside dataset window | 0 across all date columns | ✅ None | No action |
| 5.5 | Logical date violations (last_active < signup, end < start, paid < invoice) | 0 across all 3 checks | ✅ None | No action |
| 6.1 | Emails with leading/trailing whitespace | **189 users (2.0%)** | ⚠️ Low | Apply `LOWER(TRIM(email))` before any email-based grouping or matching |
| 6.1b | Emails with mixed casing | 0 | ✅ None | No action |
| 6.2 | Country naming consistency | 17 distinct values, all clean canonical names | ✅ None | No action |
| 6.3 | Plan name consistency | 5 values, all match the expected enum | ✅ None | No action |
| 6.4 | Status values across tables | All values match expected enums (no typos or unexpected statuses) | ✅ None | No action |
| 7.1 | Customers with multiple active subscriptions | 0 | ✅ None | No action — one-active-sub-per-customer rule holds |
| 7.2 | MRR matches plan price | All 5 plan/MRR combinations match expected pricing | ✅ None | No action |
| 7.3 | Free Trial duration | All 800 trials are exactly 14 days | ✅ None | No action |
| 7.4 | Resolved tickets with NULL `resolved_date` | 0 | ✅ None | No action |
| 7.5 | Failed payments correctly have NULL `paid_date` | 22/22 failed payments have NULL paid_date | ✅ None | No action |

## Verdict

The dataset is **substantially clean**, with only two real issues to address before analysis:

1. **8 content-level duplicate users** — to be removed during cleaning to prevent double-counting in user-level metrics (active users, events per user, etc.)
2. **189 emails with whitespace** — to be normalized via `LOWER(TRIM(email))` before any email-based operations

All other checks passed. Nulls present in the data are informative (active subscriptions, unanswered surveys, open tickets) rather than missing data requiring imputation.

## What this means going forward

- **Revenue analysis is safe to run directly** — no duplicates, nulls, or anomalies in `subscriptions` or `payments.`
- **User-level analysis requires the 8 duplicates to be dropped first** — built into [`02_data_cleaning.sql`](02_data_cleaning.sql)
- **CSAT analysis must exclude nulls explicitly** — using `WHERE csat_score IS NOT NULL` rather than letting AVG silently skip them
- **Email-based joins or grouping must normalize first** — using `LOWER(TRIM(email))` to catch the 189 whitespace cases



