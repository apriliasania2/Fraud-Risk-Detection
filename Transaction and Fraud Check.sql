SELECT * FROM `dataset.cards` LIMIT 10;
SELECT * FROM `dataset.transactions` LIMIT 10;
SELECT * FROM `dataset.users` LIMIT 10;

# Checking `cards` Data Type
SELECT 
  column_name, 
  data_type 
FROM `dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'cards';

# Checking `transactions` Data Type
SELECT 
  column_name, 
  data_type 
FROM `dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'transactions';

# From the check results, the `amount` column is still a string, so it is changed to an integer
CREATE OR REPLACE TABLE `dataset.transactions_cleaned` AS
SELECT
  t.id,
  t.date,
  t.client_id,
  t.card_id,
  SAFE_CAST(
    REPLACE(
      REPLACE(
        REPLACE(REPLACE(amount, "$", ""), ",", ""), "(", ""), ")", ""
      ) AS NUMERIC
  ) * IF(STARTS_WITH(amount, "("), -1, 1) AS amount, 
  t.use_chip,
  t.merchant_id,
  t.merchant_city,
  t.merchant_state,
  t.zip,
  t.mcc,
  t.errors
FROM `dataset.transactions` t;

# Checking `users` Data Type
SELECT 
  column_name, 
  data_type 
FROM `dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'users';

# Join data
SELECT
	u.id AS client_id,
    u.gender,
    u.address,
    u.latitude,
    u.longitude,
    u.yearly_income,
    u.total_debt,
    u.credit_score,
    u.num_credit_cards,
    c.id AS card_id,
    c.card_brand,
    c.card_type,
    c.has_chip,
    c.credit_limit,
    c.card_on_dark_web,
    t.id AS transaction_id,
    t.date,
    t.amount,
    t.use_chip,
    t.merchant_id,
    t.merchant_city,
    t.merchant_state,
    t.errors
FROM `dataset.transactions_cleaned` AS t
JOIN `dataset.cards` AS c
	ON t.card_id = c.id
JOIN `dataset.users` AS u
	ON t.client_id = u.id;

# Check if there are any cards on the dark web
SELECT * FROM `dataset.cards`
WHERE card_on_dark_web = TRUE
LIMIT 10;

# Detect daily transactions exceeding the credit limit
SELECT
  t.card_id,
  DATE(t.date) AS trx_date,
  SUM(t.amount) AS total_daily_trx,
  c.credit_limit,
  CASE 
    WHEN SUM(t.amount) > c.credit_limit THEN 'DAILY LIMIT EXCEEDED'
    ELSE 'OK'
  END AS status
FROM `dataset.transactions_cleaned` AS t
JOIN `dataset.cards` AS c
  ON t.card_id = c.id
GROUP BY t.card_id, trx_date, c.credit_limit
HAVING SUM(t.amount) > c.credit_limit
ORDER BY total_daily_trx DESC;

# Check for multiple errors during transactions more than 50x
SELECT 
  client_id, 
  COUNT(*) AS error_trx
FROM `dataset.transactions`
WHERE errors IS NOT NULL
GROUP BY client_id
HAVING COUNT(*) > 50
ORDER BY error_trx DESC;
