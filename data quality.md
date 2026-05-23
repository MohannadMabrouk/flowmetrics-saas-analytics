## Data Quality Findings — FlowMetrics

### 1. Row counts
✅ All 6 tables match expected counts (customers=800, users=9314, subs=1105, events=367350, tickets=8765, payments=2570).

### 2. Primary key integrity
✅ No duplicate `customer_id` in customers
✅ No duplicate `user_id` in users
⚠️ Content-level user duplicates found: **8 cases** of (customer_id, email) appearing twice with different user_ids.
   → Resolution: dropped duplicate rows in the cleaning step (kept the first occurrence of each customer_id + email pair)
