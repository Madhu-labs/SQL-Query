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


### 09-10-20026

# LeetCode 196 — Delete Duplicate Emails

### Concept

**DELETE + SELF JOIN**

Use a self join to compare rows in the same table and delete duplicate emails while keeping the row with the smallest `id`.

### Logic

* `p1.email = p2.email` → finds rows with the same email.
* `p1.id > p2.id` → identifies the row with the larger ID.
* `DELETE` → removes the duplicate row, keeping the smallest ID.

### SQL Query

```sql
DELETE p1
FROM Person p1
JOIN Person p2
    ON p1.email = p2.email
WHERE p1.id > p2.id;
```

### Pattern to Remember

```sql
DELETE p1
FROM TableName p1
JOIN TableName p2
    ON p1.column = p2.column
WHERE p1.id > p2.id;
```

**Key Pattern:** `DELETE + SELF JOIN`

**Important:** Unlike LeetCode 182, which finds duplicate emails using `GROUP BY` and `HAVING`, this problem actually deletes duplicate rows and preserves the row with the smallest `id`.



# LeetCode — Big Countries

### Concept

**WHERE + OR**

Use `WHERE` to filter rows based on conditions. Use `OR` when at least one condition must be true.

### Logic

* `area >= 3000000` → country has an area of at least 3 million.
* `population >= 25000000` → country has a population of at least 25 million.
* `OR` → returns countries satisfying either condition.

### SQL Query

```sql
SELECT name, population, area
FROM World
WHERE area >= 3000000
   OR population >= 25000000;
```

### Pattern to Remember

```sql
SELECT columns
FROM table
WHERE condition1 OR condition2;
```

**Key Pattern:** `WHERE + OR`

**Important:** Use `>=` because the question says “at least,” meaning the value can equal the specified limit.


=============================================================================================================================================================================================================================================
# LeetCode 1148 — Article Views I

### Concept
**WHERE + DISTINCT + ORDER BY**

Find authors who viewed at least one of their own articles.

### Logic
- `author_id = viewer_id` → author viewed their own article.
- `DISTINCT` → removes duplicate author IDs.
- `ORDER BY id ASC` → sorts IDs in ascending order.

### SQL Query

```sql
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id ASC;
```

### Pattern to Remember

```sql
SELECT DISTINCT column AS id
FROM table
WHERE condition
ORDER BY id ASC;
```

**Key Pattern:** `WHERE + DISTINCT + ORDER BY`

**Important:** Use `DISTINCT` because the same author may view their own article multiple times.

==============================================================================================================================================================================================================================================



# LeetCode 584 — Find Customer Referee

### Concept
**WHERE + OR + IS NULL**

Find customers who were not referred by customer `id = 2`, including customers who have no referee.

### Logic
- `referee_id != 2` → selects customers referred by someone other than customer 2.
- `IS NULL` → includes customers who were not referred by anyone.
- `OR` → returns rows satisfying either condition.

### SQL Query

```sql
SELECT name
FROM Customer
WHERE referee_id != 2
   OR referee_id IS NULL;
```

### Pattern to Remember

```sql
SELECT column
FROM table
WHERE condition
   OR column IS NULL;
```

**Key Pattern:** `WHERE + OR + IS NULL`

**Important:** `NULL` cannot be checked using `= NULL` or `!= NULL`. Use `IS NULL` or `IS NOT NULL` instead.

===============================================================================================================================================================================================================================
# LeetCode 1757 — Recyclable and Low Fat Products

### Concept
**WHERE + AND**

Use `WHERE` to filter rows and `AND` when both conditions must be true.

### Logic
- `low_fats = 'Y'` → product is low fat.
- `recyclable = 'Y'` → product is recyclable.
- `AND` → selects products satisfying both conditions.

### SQL Query

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y'
  AND recyclable = 'Y';
```

### Pattern to Remember

```sql
SELECT column
FROM table
WHERE condition1
  AND condition2;
```

**Key Pattern:** `WHERE + AND`

**Important:** Since `low_fats` and `recyclable` are ENUM values containing `'Y'` or `'N'`, compare them using quotes.

===================================================================================================================================================================================================================================
