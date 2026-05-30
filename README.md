# FlowMetrics — SaaS Customer & Revenue Analytics

End-to-end analytics on a 2-year B2B SaaS dataset. Built with **SQL · Python · Power BI** to investigate churn drivers and recommend retention investments.

> 🟡 **Project status: in progress.** Working through an 8-step analyst workflow.

---

## Project Brief

### The business

**FlowMetrics** is a fictional B2B project management SaaS (similar to ClickUp, Asana, or Monday). The company monetizes via per-account subscriptions across five tiers — Free Trial, Starter, Pro, Business, and Enterprise — sold globally with concentration in the US and Europe. Revenue depends on three levers: **acquiring** new customers, **converting** trials to paid, and **retaining** paid accounts month-over-month. Churn directly reduces Monthly Recurring Revenue (MRR).

### The stakeholder

**Primary audience:** the VP of Customer Success.
**Secondary readers:** customer-success team leads (who would execute the resulting retention plays) and the CFO (who would approve any associated investment).

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
| Data storage | MySQL |
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

This project follows an 8-step analyst workflow. Status is updated as each stage is completed.

| Step | Status | Artifact |
|------|--------|----------|
| 1. Understand business context | ✅ Done | This README, [Project Brief](#project-brief) above |
| 2. Understand the data |  ✅ Done | [The Dataset](#the-dataset) |
| 3. Profile data quality |  ✅ Done |[`01_data_quality.ipynb`](01_data_quality.ipynb) |
| 4. Define questions clearly | ✅ Done | [Business Questions](#business-questions) |
| 5. Clean and prepare data | ⬜ Not started | `02_data_cleaning.ipynb` |
| 6. Exploratory analysis | ⬜ Not started | `03_exploratory_analysis.ipynb` |
| 7. Answer the questions | ⬜ Not started | `sql/` queries + analysis notebooks |
| 8. Communicate findings | ⬜ Not started | Findings section + Power BI dashboard |

---

## Business Questions

This analysis is structured around a focused set of questions, each chosen to help the VP of Customer Success decide **where to invest to reduce churn.** The questions move from sizing the problem, to locating it, to explaining it.

### The investigation logic

```
Q1: How big is the problem?        →  size it
Q2–Q3: Where is churn concentrated? →  locate it (country, plan)
Q4: What behavior drives churn?     →  explain it (engagement)
```

---

### Q1 — How big is the churn problem?

**Question:** What is the overall customer churn rate over the two-year period, and how has it trended month over month?
**Metric:** Churn rate = customers who churned during a period ÷ customers active at the start of that period. Reported as an overall figure and as a monthly trend line.
**Why it matters:** You can't prioritize an investment without knowing the scale of the problem. The monthly trend also reveals whether churn is stable, worsening, or spiking in specific periods.

---

### Q2 — Is churn concentrated in specific countries?

**Question:** Do certain countries have materially higher churn rates than others?
**Metric:** Churn rate broken down by country, compared against the overall average to surface outliers.
**Why it matters:** If churn is geographically concentrated, the lever may be region-specific — local support coverage, localization, or market fit. A country running far above average is a targeted, actionable finding.

---

### Q3 — Which subscription plans have the highest churn?

**Question:** Which plan tiers lose customers fastest?
**Metric:** Churn rate by plan (Starter, Pro, Business, Enterprise).
**Why it matters:** If a specific plan churns disproportionately, the response could be improving that plan's value, adjusting its pricing, or proactively guiding those customers toward stickier tiers. *Caveat to test in analysis: plan-level churn may be a proxy for company size or engagement rather than a driver in itself.*

---

### Q4 — Do less-engaged customers churn more?

**Question:** Are customers who use the product less likely to churn?
**Metric:** Compare engagement between churned and retained customers, measured as **events per active month** (total feature events ÷ months active) to normalize for how long each customer has been around. Bucket customers into engagement tiers and compare churn rates across tiers.
**Why it matters:** This is the most directly actionable driver. If low engagement predicts churn, the lever is onboarding and product adoption — getting customers to value faster. *Note: raw total event counts are confounded by tenure, so the metric normalizes by active time.*

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
- 💼 LinkedIn: *[https://www.linkedin.com/in/mohannadmabrouk/]*

---

*Dataset is fully synthetic. All company names, customer records, and events are fictional.*
