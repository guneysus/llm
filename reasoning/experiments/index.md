Experimenting the Reasoning models


## Introduction


Got some question ideas from ChatGPT to test reasoning models.


**[Prompt](https://chatgpt.com/share/67967ca0-57b8-8001-8020-19705c2290cb)**


[Compare DeepSeek-R1 and OpenAI-o1 using RAG, Akshay Pachaar January 2025](https://lightning.ai/akshay-ddods/studios/compare-deepseek-r1-and-openai-o1-using-rag?view=public&section=featured)


> how can I test/benchmark reasoning models. Give me some prompts to compare outcomes of models. The prompt better to be software development/tech


Picked the SQL query optimization one:

> Optimize the following SQL query to improve performance, ensuring the result remains the same:

```sql
SELECT * 
FROM orders 
WHERE order_date >= '2023-01-01' 
  AND customer_id IN (SELECT customer_id FROM customers WHERE country = 'US')

```




---

Asked to some reasoning models including very tiny ones:


- `deepseek-r1:1.5b`
- `falcon3:1b`
- `internlm2:1.8b`
- `marco-o1:latest`
- `smallthinker:3b-preview-q4_K_M`
- `smallthinker:latest`
- `smollm2:135m`
- `smollm2:latest`


## User Message

Optimize the following SQL query to improve performance, ensuring the result remains the same:

```sql
SELECT *
FROM orders
WHERE order_date >= '2023-01-01'
  AND customer_id IN (SELECT customer_id FROM customers WHERE country = 'US')
```

---

## Assistant Responses

### Response from `deepseek-r1:1.5b`

Here is an optimized version of your SQL query:

```sql
SELECT *
FROM orders 
WHERE order_date >= '2023-01-01' 
  AND (customer_id IN (SELECT c_id FROM customers WHERE country = 'US'));
```

This change removes the IN subquery, avoiding unnecessary repeated execution.

---

### Response from `falcon3:1b`

An optimized version using a Common Table Expression (CTE):

```sql
WITH filtered_customers AS (
    SELECT customer_id, country
    FROM customers
    WHERE country = 'US'
),
filtered_orders AS (
    SELECT *
    FROM orders
    JOIN filtered_customers ON orders.customer_id = filtered_customers.customer_id
)
SELECT *
FROM filtered_orders
WHERE order_date >= '2023-01-01';
```

This approach organizes the query for better efficiency and readability.

---

### Response from `internlm2:1.8b`

The given SQL query is already optimized for performance. It checks if an order is made before January 1st and also checks if the customer makes an order in the United States. This should remain the same result.

---

### Response from `marco-o1:latest`

Here is a potential improvement:

```sql
SELECT *
FROM orders
WHERE order_date >= '2023-01-01'
  AND EXISTS (
    SELECT 1
    FROM customers
    WHERE customers.customer_id = orders.customer_id
      AND customers.country = 'US'
  );
```

Using EXISTS can sometimes be faster than IN depending on the database and index usage.

---

### Response from `smallthinker:3b-preview-q4_K_M`

The query can be optimized by ensuring proper indexing on the columns involved. For example:

```sql
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_customer_country ON customers(customer_id, country);
```

After indexing, the query should run more efficiently without major changes.

---

### Response from `smallthinker:latest`

Consider breaking the query into steps for better clarity and optimization:

```sql
WITH filtered_customers AS (
    SELECT customer_id
    FROM customers
    WHERE country = 'US'
)
SELECT *
FROM orders
WHERE order_date >= '2023-01-01'
  AND customer_id IN (SELECT customer_id FROM filtered_customers);
```

This uses a CTE to isolate the filtering logic.

---

### Response from `smollm2:135m`

To optimize the SQL query, you can use the `LIKE` operator instead of `CONCAT`. Here's an example:

```sql
SELECT *
FROM orders
WHERE order_date IN ('2023-01-01', '2023-01-07')
  AND customer_id IN (
    SELECT customer_id FROM customers WHERE country = 'US'
  );
```

---

### Response from `smollm2:latest`

A potential improvement involves using JOINs to make the query more direct:

```sql
SELECT o.*
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= '2023-01-01'
  AND c.country = 'US';
```

This approach avoids subqueries entirely.
