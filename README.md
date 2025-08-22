# Fraud Risk Detection with BigQuery SQL & Looker Studio

## Objective
This project aims to analyze **credit card transactions** to identify high-risk patterns and potential fraud. The analysis is conducted using **Google BigQuery** for data processing and integration, and **Looker Studio** for dashboard visualization.

---
## Dataset Schema
- **cards**
  `id`, `client_id`, `card_brand`, `card_type`, `card_number`, `expires`, `cvv`, `has_chip`, `num_cards_issued`, `credit_limit`, `acct_open_date`, `year_pin_last_changed`, `card_on_dark_web`

- **transactions**
  `id`, `date`, `client_id`, `card_id`, `amount`, `use_chip`, `merchant_id`, `merchant_city`, `merchant_state`, `zip`, `mcc`, `errors`

- **users**
  `id`, `current_age`, `retirement_age`, `birth_year`, `birth_month`, `gender`, `address`, `latitude`, `longitude`, `per_capita_income`, `yearly_income`, `total_debt`, `credit_score`, `num_credit_cards` 

---

## Goals
- Clean and transform raw transaction data
- Integrate multiple datasets (`users`, `cards`, `transactions`) into a single analytical view
- Detect high-risk pattern, such as:
  - Cards found on the dark web
  - Transactions exceeding the credit limit
  - Transaction errors (type & frequency)
  - Cards without a chip

---

## Tools 
- **Goggle BigQuery** > SQL queries, data cleaning, data integration
- **Looker Studio** > Interactive dashboard visualization & reporting

---

## Dashboard
You can explore the interactive dashboard here:
https://s.id/Fraud_Risk_Detection


