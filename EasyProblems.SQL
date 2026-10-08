# LeetCode 183 — Customers Who Never Order

### Concept

**LEFT JOIN + IS NULL**

Use this pattern when you need to find records from one table that **do not have a matching record** in another table.

### Logic

* `LEFT JOIN` → keeps all customers, even if they have no orders.
* `IS NULL` → finds customers whose matching order does not exist.

### Query

```sql
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o
    ON c.id = o.customerId
WHERE o.customerId IS NULL;
```

### Pattern to Remember

```text
Find records with NO match
→ LEFT JOIN
→ WHERE matching_column IS NULL
```

**Key Pattern:** `LEFT JOIN + IS NULL`
