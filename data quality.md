## Data Quality Findings — FlowMetrics

### 1. Row counts
✅ All 6 tables match expected counts (customers=800, users=9314, subs=1105, events=367350, tickets=8765, payments=2570).

### 2. Primary key integrity
✅ No duplicate `customer_id`, `user_id`, `subscription_id`, `payment_id`, or `ticket_id` (PKs are clean).

⚠️ Content-level duplicates found:
   - **users**: 8 cases of (customer_id, email) appearing twice with different user_ids
   - **payments**: 5 cases of (customer_id, subscription_id, invoice_date, amount) appearing twice with different payment_ids
   - **Resolution**: Deduplicate on semantic keys during cleaning (Step 5), before any user-level or revenue-level aggregation.
