# FlowMetrics — SaaS Analytics 

A complete analytics portfolio project built on a synthetic B2B SaaS dataset. Covers SQL analysis, Python exploratory analysis, and a Power BI dashboard.

> **Note on the data:** FlowMetrics is a fictional B2B project-management SaaS company. The dataset is fully synthetic, generated to mirror realistic patterns (seasonality, churn dynamics, plan lifecycle, support escalations) including intentional anomalies for the analyst to discover.

---

## The fictional company

**FlowMetrics** is a B2B project management tool (think Asana / Monday / ClickUp), founded mid-2023. The dataset covers **June 2023 – May 2025**, spanning ~800 customers across 17 countries on five subscription tiers.

| Plan | Price/month | User cap |
|------|-------------|----------|
| Free Trial | $0 | 5 |
| Starter | $29 | 10 |
| Pro | $79 | 25 |
| Business | $199 | 100 |
| Enterprise | $499 | 9,999 |

---

## Data dictionary

### `customers.csv` — 800 rows
| Column | Type | Notes |
|--------|------|-------|
| customer_id | string | PK, format `CUST_NNNNN` |
| company_name | string | |
| industry | string | 10 categories |
| country | string | 17 countries, US-heavy |
| company_size | string | `1-10`, `11-50`, `51-200`, `201-1000`, `1000+` |
| signup_date | date | ISO format |
| acquisition_channel | string | Organic, Paid, Referral, Direct, Content, Partner |

### `users.csv` — ~9,300 rows
| Column | Type | Notes |
|--------|------|-------|
| user_id | string | PK, format `USR_NNNNNN` |
| customer_id | string | FK → customers |
| first_name, last_name | string | |
| email | string | **Contains data quality issues** (case inconsistencies, whitespace) |
| role | string | admin / manager / member / viewer |
| signup_date | date | |
| last_active_date | date | |

> ⚠️ Contains ~8 duplicate users to surface in cleaning.

### `subscriptions.csv` — ~1,100 rows
| Column | Type | Notes |
|--------|------|-------|
| subscription_id | string | PK |
| customer_id | string | FK → customers |
| plan_name | string | One of the 5 plans |
| mrr | int | Monthly Recurring Revenue |
| start_date | date | |
| end_date | date or null | NULL = currently active |
| status | string | `ended` / `active` / `churned` / `upgraded` / `downgraded` |

> Each customer has multiple subscription rows representing their plan lifecycle (trial → paid → upgrade → churn etc.).

### `feature_usage.csv` — ~367,000 rows
| Column | Type | Notes |
|--------|------|-------|
| event_id | string | PK |
| user_id | string | FK → users |
| customer_id | string | FK → customers (denormalized for convenience) |
| feature_name | string | 11 features |
| event_timestamp | datetime | ISO format |

### `support_tickets.csv` — ~8,800 rows
| Column | Type | Notes |
|--------|------|-------|
| ticket_id | string | PK |
| customer_id | string | FK → customers |
| category | string | Bug / Billing / Feature Request / How-to / Integration / Performance / Account Access |
| priority | string | Low / Medium / High / Critical |
| opened_date | date | |
| resolved_date | date or null | |
| resolution_hours | float or null | |
| status | string | `resolved` or `open` |
| csat_score | int or null | 1–5, NULL when survey not answered |

### `payments.csv` — ~2,600 rows
| Column | Type | Notes |
|--------|------|-------|
| payment_id | string | PK |
| customer_id | string | FK |
| subscription_id | string | FK |
| invoice_date | date | |
| amount | int | USD |
| status | string | `paid` or `failed` |
| paid_date | date or null | |
| payment_method | string | Credit Card / ACH / Wire / PayPal |

> ⚠️ Contains ~5 duplicate payment rows to surface in cleaning.

---

## Hidden patterns to discover (don't peek before doing your analysis)

<details>
<summary>Click to reveal — only after you've done your own EDA</summary>

The data has three deliberately injected anomalies that any decent analyst should surface. They make for great "I discovered..." talking points in interviews.

1. **Brazil has abnormally low CSAT** (~3.1 vs ~4.0 elsewhere). Worth investigating: is it a language/localization issue? An agent staffing gap? A product issue specific to that market?

2. **A churn spike in September–October 2024.** ~5× normal churn rate over a 2-month window. The hypothetical cause: a pricing change. In a real interview, you'd frame this as "I'd want to validate this with the product team — was there a pricing change, a launch issue, or a competitive event?"

3. **AI feature adoption exploded after March 2024.** The `ai_assistant_use` feature didn't exist before March 2024, then grew exponentially. By May 2025 it's the most-used feature in the platform. Great for a "feature adoption journey" visualization.

There are also expected patterns to demonstrate:
- Q4 signup spike, summer signup dip (seasonality)
- Churn correlated inversely with feature adoption (engaged customers stay)
- Larger company sizes have higher trial→paid conversion rates
- Resolution time scales inversely with ticket priority

</details>

---

## Suggested analysis questions

Tackle these in your SQL queries, Python notebook, and dashboard. The goal isn't to answer all of them — pick the ones that produce the strongest story.

**Revenue & growth**
- What is monthly MRR over time, segmented by plan?
- What is the trial → paid conversion rate, segmented by company size?
- Which acquisition channels produce the highest LTV?

**Churn & retention**
- What is monthly churn rate? Is there a month that looks anomalous?
- What is cohort retention by signup month?
- Do customers who use more features churn less? Quantify it.
- Do customers with unresolved tickets churn more?

**Product analytics**
- Which features have the highest adoption? Which are stagnant?
- How fast is `ai_assistant_use` growing? When did it become a top-3 feature?
- Power users (>X events/month): how do they differ from casual users?

**Customer support**
- What's average resolution time by priority? By category?
- CSAT by country — anything anomalous?
- Does CSAT correlate with subsequent churn?

**Health & risk**
- Which currently-active customers look at risk of churn? (Define your own criteria.)
- Which customers are upgrade candidates? (E.g., near user cap on their plan.)

---

## Repository structure

```
flowmetrics-saas-analytics/
├── README.md                        ← this file
├── data/
│   ├── customers.csv
│   ├── users.csv
│   ├── subscriptions.csv
│   ├── feature_usage.csv
│   ├── support_tickets.csv
│   └── payments.csv
├── sql/
│   ├── 01_create_schema.sql         ← DDL for MySQL/PostgreSQL
│   ├── 02_load_data.sql             ← LOAD DATA statements
│   ├── 10_revenue_analysis.sql      ← MRR, ARR, growth queries
│   ├── 20_churn_analysis.sql        ← cohort retention, churn drivers
│   ├── 30_product_analytics.sql     ← feature adoption queries
│   └── 40_support_analysis.sql      ← CSAT, resolution analysis
├── python/
│   ├── 01_data_cleaning.ipynb       ← duplicates, nulls, type casting
│   ├── 02_exploratory_analysis.ipynb
│   ├── 03_cohort_retention.ipynb
│   └── 04_churn_drivers.ipynb
└── powerbi/
    ├── FlowMetrics_Dashboard.pbix
    └── screenshots/
```

---

## How this project was structured

This is a portfolio project demonstrating end-to-end analytics work on a realistic dataset. Built across four phases:

1. **Week 1 — SQL foundation.** Schema design, data load, business question queries.
2. **Week 2 — Python deep dive.** Cleaning, EDA, cohort analysis, churn drivers.
3. **Week 3 — Power BI dashboard.** Executive + customer-health views.
4. **Week 4 — Write-up.** README, screenshots, demo video, blog post.

---

*Dataset generated for educational/portfolio use. All company names, customer data, and events are entirely synthetic.*
