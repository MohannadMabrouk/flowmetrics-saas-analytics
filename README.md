# FlowMetrics — SaaS Customer & Revenue Analytics

End-to-end analytics on a 2-year B2B SaaS dataset. Built with **SQL · Python · Power BI** to investigate churn drivers and recommend retention investments.

> 🟡 **Project status: in progress.** Working through an 8-step analyst workflow. Steps 2–8 will be added as the analysis progresses.

---

## 📋 Project Brief

### The business

**FlowMetrics** is a fictional B2B project management SaaS (similar in flavor to ClickUp, Asana, or Monday). The company monetizes via per-account subscriptions across five tiers — Free Trial, Starter, Pro, Business, and Enterprise — sold globally with concentration in the US and Europe. Revenue depends on three levers: **acquiring** new customers, **converting** trials to paid, and **retaining** paid accounts month-over-month. Churn directly reduces Monthly Recurring Revenue (MRR).

### The stakeholder

**Primary audience:** the VP of Customer Success.
**Secondary readers:** customer-success team leads (who would execute the resulting retention plays) and the CFO (who would approve any associated investment).
None of the readers are deeply technical, so findings are reported in plain language with dollar impact where relevant.

### The decision this analysis informs

The VP needs to decide **which retention investment(s) to prioritize over the next quarter.** Possible levers being weighed:

- Improving onboarding for new customers
- Building features that drive deeper product engagement
- Expanding support coverage for underperforming markets
- Proactive intervention on at-risk accounts
- Addressing pricing or billing friction

Each lever has a different cost and a different evidence threshold. This analysis exists to help pick between them.

### What success looks like

This analysis is successful if the VP can leave the readout able to:

1. **Name the top 2–3 drivers of churn**, backed by evidence
2. **Identify the customer segments or scenarios most at risk**
3. **Confidently choose one or two retention investments to fund next quarter**

The analysis fails if the VP's response is *"interesting, but what do I do with this?"* Every chart in this project is tested against that bar.

---

## Tech Stack

| Layer | Tools |
|-------|-------|
| Data storage | MySQL (alternative: SQLite) |
| Analysis | Python (pandas, matplotlib, seaborn), Jupyter |
| Querying | SQL (joins, window functions, CTEs) |
| Visualization | Power BI |
| Version control | Git / GitHub |

---

## The Dataset

Two years of synthetic operational data (June 2023 – May 2025):

| Table | Rows | Description |
|-------|------|-------------|
| `customers` | 800 | Company accounts |
| `users` | ~9,300 | Individual users within accounts |
| `subscriptions` | ~1,100 | Plan lifecycle records (trial → paid → churn/upgrade/downgrade) |
| `feature_usage` | ~367,000 | Daily feature event log |
| `support_tickets` | ~8,800 | Tickets with CSAT scores |
| `payments` | ~2,600 | Monthly invoice records |

---

## Analytical Workflow

This project follows an 8-step analyst workflow. Status updated as each stage completes.

| Step | Status | Artifact |
|------|--------|----------|
| 1. Understand business context | ✅ Done | This README, "Project Brief" above |
| 2. Understand the data |  ✅ Done | Data dictionary (below, expanding) |
| 3. Profile data quality |  ✅ Done |[`01_data_quality.ipynb`](01_data_quality.ipynb) |
| 4. Define questions clearly | ⬜ Not started | "Business Questions" section (below) |
| 5. Clean and prepare data | ⬜ Not started | `python/02_data_cleaning.ipynb` |
| 6. Exploratory analysis | ⬜ Not started | `python/03_exploratory_analysis.ipynb` |
| 7. Answer the questions | ⬜ Not started | `sql/` queries + analysis notebooks |
| 8. Communicate findings | ⬜ Not started | Findings section + Power BI dashboard |

---

## 🔍 Key Findings

> *To be populated as analysis progresses.*

---

## 📈 Dashboard

> *Power BI dashboard link to be added after Phase 3.*

---

## 👤 About

Built by **Mohannad Mabrouk** as a portfolio project to demonstrate end-to-end analytics workflow on realistic SaaS data.

- 🔗 GitHub: [@MohannadMabrouk](https://github.com/MohannadMabrouk)
- 💼 LinkedIn: *[Mohannad Mabrouk] (https://www.linkedin.com/in/mohannadmabrouk/)*

---

*Dataset is fully synthetic. All company names, customer records, and events are fictional.*
