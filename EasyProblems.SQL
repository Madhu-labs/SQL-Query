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
10-10-2026

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
11-10-2026

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

# LeetCode 1683 — Invalid Tweets

### Concept
**WHERE + LENGTH()**

Use `LENGTH()` to count the characters in a tweet and `WHERE` to filter tweets exceeding the limit.

### Logic
- `LENGTH(content)` → counts the characters in the tweet.
- `> 15` → selects tweets with more than 15 characters.

### SQL Query

```sql
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;
```

### Pattern to Remember

```sql
SELECT column
FROM table
WHERE LENGTH(text_column) > limit;
```

**Key Pattern:** `WHERE + LENGTH()`

**Important:** The question says *strictly greater than 15*, so use `> 15`, not `>= 15`.

======================================================================================================================================================================================================================================
12-10-2026

# LeetCode 1693 — Daily Leads and Partners

### Concept

**GROUP BY + COUNT(DISTINCT)**

Count the unique leads and partners for each date and product.

### Logic

* `GROUP BY date_id, make_name` → groups rows by date and product.
* `COUNT(DISTINCT lead_id)` → counts unique leads.
* `COUNT(DISTINCT partner_id)` → counts unique partners.
* `DISTINCT` prevents duplicate IDs from being counted more than once.

### SQL Query

```sql
SELECT date_id, make_name,
       COUNT(DISTINCT lead_id) AS unique_leads,
       COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY date_id, make_name;
```

### Pattern to Remember

```sql
SELECT column1, column2,
       COUNT(DISTINCT column3)
FROM table
GROUP BY column1, column2;
```

**Key Pattern:** `GROUP BY + COUNT(DISTINCT)`

**Important:** Use `COUNT(DISTINCT column)` when the question asks for the number of unique values, especially when the table may contain duplicates.
======================================================================================================================================================================
# LeetCode 1251 — Average Selling Price

### Concept

**JOIN + SUM() + GROUP BY + ROUND()**

Calculate the weighted average selling price of each product based on the number of units sold at each price.

### Logic

* `JOIN` → matches products and sales.
* `purchase_date BETWEEN start_date AND end_date` → finds the applicable price for each sale.
* `SUM(price * units) / SUM(units)` → calculates the weighted average price.
* `ROUND(..., 2)` → rounds the result to 2 decimal places.
* `LEFT JOIN` + `COALESCE()` → keeps products without sales and returns 0.

### SQL Query

```sql
SELECT p.product_id,
       COALESCE(ROUND(SUM(p.price * u.units) /
       SUM(u.units), 2), 0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;
```

### Pattern to Remember

```sql
SELECT id,
       COALESCE(ROUND(SUM(price * units) /
       SUM(units), 2), 0) AS average_price
FROM TableA
LEFT JOIN TableB ON condition
GROUP BY id;
```

**Key Pattern:** `JOIN + Weighted Average + GROUP BY`

**Important:** Use `SUM(price * units) / SUM(units)`, not `AVG(price)`, because products may be sold in different quantities at different prices.

====≠==============≠==================================≠==========================================≠============================================≠================
13-10-2026


# LeetCode 586 — Customer Placing the Largest Number of Orders

### Concept
**GROUP BY + COUNT() + ORDER BY + LIMIT**

Find the customer who has placed the highest number of orders.

### Logic
- `GROUP BY customer_number` → groups orders by customer.
- `COUNT(*)` → counts each customer's orders.
- `ORDER BY COUNT(*) DESC` → sorts customers by order count, highest first.
- `LIMIT 1` → returns only the top customer.

### SQL Query

```sql
SELECT customer_number
FROM Orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC
LIMIT 1;
```

### Pattern to Remember

```sql
SELECT column
FROM table
GROUP BY column
ORDER BY COUNT(*) DESC
LIMIT 1;
```

**Key Pattern:** `GROUP BY + COUNT + ORDER BY DESC + LIMIT 1`

**Important:** `DESC` sorts from highest to lowest. The problem guarantees exactly one customer has the most orders, so `LIMIT 1` is sufficient.
===================================================================================================================================================================================================================

# LeetCode #1075 — Project Employees I

**Pattern:** SQL JOIN + GROUP BY + Aggregate Functions

**Difficulty:** Easy

### Theory
Find the average experience of employees assigned to each project and round the result to two decimal places.

### Approach
1. Join `Project` and `Employee` using `employee_id`.
2. Use `AVG()` to calculate the average experience.
3. Use `ROUND()` to round the average to two decimal places.
4. Group the results by `project_id`.

### SQL Query
```sql
SELECT p.project_id,
       ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project p
JOIN Employee e
    ON p.employee_id = e.employee_id
GROUP BY p.project_id;
```

### Example
Project 1 experience values: `3, 2, 1`

Average: `(3 + 2 + 1) / 3 = 2.00`

Project 2 experience values: `3, 2`

Average: `(3 + 2) / 2 = 2.50`

### Key Concepts
- `JOIN`: combines related rows from two tables.
- `AVG()`: calculates an average.
- `ROUND(value, 2)`: rounds a number to two decimal places.
- `GROUP BY`: calculates results separately for each project.

### Complexity
The query processes the project and employee records and groups employees by project. Exact performance depends on the database engine and indexes.
========================================================================================================================================================================================================================

14-10-2026


# LeetCode 1729 — Find Followers Count

### Concept
**GROUP BY + COUNT() + ORDER BY**

Count the number of followers for each user and sort the results by user ID.

### Logic
- `GROUP BY user_id` → groups followers by user.
- `COUNT(follower_id)` → counts each user's followers.
- `ORDER BY user_id ASC` → sorts user IDs in ascending order.

### SQL Query

```sql
SELECT user_id,
       COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;
```

### Pattern to Remember

```sql
SELECT column, COUNT(*)
FROM table
GROUP BY column
ORDER BY column ASC;
```

**Key Pattern:** `GROUP BY + COUNT() + ORDER BY ASC`

**Important:** Group by `user_id` because the question asks for the follower count of each user.
=======================================================================================================================================================================================================================================

14-10-2026

# LeetCode 1050 — Actors and Directors Who Cooperated At Least Three Times

### Concept
**GROUP BY + COUNT() + HAVING**

Find actor-director pairs that worked together at least three times.

### Logic
- `GROUP BY actor_id, director_id` → groups records by each unique actor-director pair.
- `COUNT(*)` → counts how many times each pair cooperated.
- `HAVING COUNT(*) >= 3` → keeps pairs that cooperated at least three times.

### SQL Query

```sql
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;
```

### Pattern to Remember

```sql
SELECT column1, column2
FROM table
GROUP BY column1, column2
HAVING COUNT(*) >= 3;
```

**Key Pattern:** `GROUP BY + COUNT() + HAVING`

**Important:** Use `HAVING`, not `WHERE`, because we need to filter groups based on the result of `COUNT()`.

===========================================================================================================================================================================================================================================
14-10-2026


# LeetCode SQL 1741 — Find Total Time Spent by Each Employee

## Concept
Use `GROUP BY` with `SUM()` to calculate the total working time for each employee on each day.

## SQL Query
```sql
SELECT
    event_day AS day,
    emp_id,
    SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY event_day, emp_id;
```

## Logic
1. Calculate each entry's duration: `out_time - in_time`.
2. Group records by `event_day` and `emp_id`.
3. Use `SUM()` to add all durations for the same employee on the same day.
4. Rename `event_day` to `day` using `AS day`.

## Example
For employee `1` on `2020-11-28`:

- First entry: `32 - 4 = 28` minutes
- Second entry: `200 - 55 = 145` minutes
- Total: `28 + 145 = 173` minutes

## Pattern to Remember
**`GROUP BY` + `SUM()` + calculated expression**

Use this pattern when you need to calculate a total from multiple records in each group.

## Key Pattern
- `SUM()` — adds values together.
- `GROUP BY` — creates groups based on matching columns.
- `AS day` — renames a column in the output.

**Important:** Group by both the date and employee ID. Grouping only by employee ID would combine their working time across different days.

============================================================================================================================================================================================================================================

14-10-2026

# LeetCode SQL 1211 — Queries Quality and Percentage

## Concept
Use `GROUP BY`, `AVG()`, `ROUND()`, and conditional aggregation to calculate query quality and poor query percentage.

## SQL Query
```sql
SELECT
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(
        AVG(CASE WHEN rating < 3 THEN 1.0 ELSE 0 END) * 100,
        2
    ) AS poor_query_percentage
FROM Queries
GROUP BY query_name;
```

## Logic
1. **Quality:** Calculate `rating / position` for each row and find the average.
2. **Poor query percentage:** Count rows where `rating < 3` as `1.0`, and all other rows as `0`.
3. `AVG()` calculates the proportion of poor queries.
4. Multiply by `100` to convert the proportion into a percentage.
5. Use `ROUND(..., 2)` to round both results to two decimal places.
6. Group by `query_name` to calculate the results separately for each query.

## Pattern to Remember
**`GROUP BY` + `AVG()` + `CASE WHEN` + `ROUND()`**

Use conditional aggregation when calculating percentages or averages based on a condition.

## Key Pattern
```sql
AVG(CASE WHEN condition THEN 1.0 ELSE 0 END) * 100
```

**Important:** Use `1.0` instead of `1` to help ensure decimal division and avoid integer-division issues in SQL engines that perform integer division.

================================================================================================================================================================================================================================================

15-10-2026

# LeetCode SQL 1211 — Queries Quality and Percentage

## Concept
Use `GROUP BY`, `AVG()`, `ROUND()`, and conditional aggregation to calculate query quality and poor query percentage.

## SQL Query
```sql
SELECT
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND(
        AVG(CASE WHEN rating < 3 THEN 1.0 ELSE 0 END) * 100,
        2
    ) AS poor_query_percentage
FROM Queries
GROUP BY query_name;
```

## Logic
1. **Quality:** Calculate `rating / position` for each row and find the average.
2. **Poor query percentage:** Count rows where `rating < 3` as `1.0`, and all other rows as `0`.
3. `AVG()` calculates the proportion of poor queries.
4. Multiply by `100` to convert the proportion into a percentage.
5. Use `ROUND(..., 2)` to round both results to two decimal places.
6. Group by `query_name` to calculate the results separately for each query.

## Pattern to Remember
**`GROUP BY` + `AVG()` + `CASE WHEN` + `ROUND()`**

Use conditional aggregation when calculating percentages or averages based on a condition.

## Key Pattern
```sql
AVG(CASE WHEN condition THEN 1.0 ELSE 0 END) * 100
```

**Important:** Use `1.0` instead of `1` to help ensure decimal division and avoid integer-division issues in SQL engines that perform integer division.

==========================================================================================================================================================================================================================================================

15-10-2026

# LeetCode SQL 1741 — Find Total Time Spent by Each Employee

## Concept
Use `GROUP BY` with `SUM()` to calculate the total working time for each employee on each day.

## SQL Query
```sql
SELECT
    event_day AS day,
    emp_id,
    SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY event_day, emp_id;
```

## Logic
1. Calculate each entry's duration: `out_time - in_time`.
2. Group records by `event_day` and `emp_id`.
3. Use `SUM()` to add all durations for the same employee on the same day.
4. Rename `event_day` to `day` using `AS day`.

## Example
For employee `1` on `2020-11-28`:

- First entry: `32 - 4 = 28` minutes
- Second entry: `200 - 55 = 145` minutes
- Total: `28 + 145 = 173` minutes

## Pattern to Remember
**`GROUP BY` + `SUM()` + calculated expression**

Use this pattern when you need to calculate a total from multiple records in each group.

## Key Pattern
- `SUM()` — adds values together.
- `GROUP BY` — creates groups based on matching columns.
- `AS day` — renames a column in the output.

**Important:** Group by both the date and employee ID. Grouping only by employee ID would combine their working time across different days.

=============================================================================================================================================================================================================================================================
16-10-2026


# LeetCode #283 — Move Zeroes

**Pattern:** Two Pointers / In-place Array Manipulation

**Difficulty:** Easy

### Theory

Move all zeros to the end of an array while preserving the relative order of non-zero elements. Modify the original array without creating a copy.

### Approach

1. Initialize `index = 0` to track the next position for a non-zero value.
2. Traverse the array and copy each non-zero value to `nums[index]`.
3. Increment `index` after each non-zero value.
4. Fill all remaining positions with zeros.

### Example

**Input:** `nums = [0,1,0,3,12]`

**Output:** `[1,3,12,0,0]`

### Complexity

* **Time Complexity:** `O(n)` — the array is traversed twice at most.
* **Extra Space Complexity:** `O(1)` — the original array is modified directly.

### Key Takeaway

Use an index pointer to place non-zero values first, then fill the remaining positions with zeros. This preserves their relative order and uses constant extra space.
============================================================================================================================================================================================================================================

16-10-2026
# LeetCode SQL 1280 — Students and Examinations

## Concept

Use `CROSS JOIN`, `LEFT JOIN`, `COUNT()`, and `GROUP BY` to show every student-subject combination and count exam attendance, including zero attendance.

## SQL Query

```sql
SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
    AND sub.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY
    s.student_id,
    sub.subject_name;
```

## Logic

1. **`CROSS JOIN`** creates every possible student-subject combination.
2. **`LEFT JOIN`** matches each combination with its exam records.
3. **`COUNT(e.subject_name)`** counts matching exam records, including duplicates.
4. If a student never attended a subject's exam, the count is `0`.
5. **`GROUP BY`** groups records by student and subject.
6. **`ORDER BY`** sorts by `student_id`, then `subject_name`.

## Pattern to Remember

**`CROSS JOIN` + `LEFT JOIN` + `COUNT()` + `GROUP BY`**

Use this pattern when every possible combination must appear, even when no matching record exists.

## Key Pattern

* `CROSS JOIN` — generates all combinations.
* `LEFT JOIN` — preserves combinations without matches.
* `COUNT(column)` — ignores `NULL` values, so unmatched combinations return `0`.

**Important:** Use `COUNT(e.subject_name)`, not `COUNT(*)`. With a `LEFT JOIN`, `COUNT(*)` would count the unmatched row and incorrectly return `1` instead of `0`.

============================================================================================================================================================================================================================================

17-10-2026

# LeetCode SQL 570 — Managers with at Least 5 Direct Reports

## Concept
Use `GROUP BY` and `HAVING COUNT()` to find managers who have five or more direct reports.

## SQL Query
```sql
SELECT e.name
FROM Employee e
JOIN Employee r
    ON e.id = r.managerId
GROUP BY e.id, e.name
HAVING COUNT(*) >= 5;
```

## Logic
1. Use a **self join** because managers and employees are stored in the same table.
2. `e.id = r.managerId` matches each manager with their direct reports.
3. `GROUP BY e.id, e.name` groups employees under each manager.
4. `HAVING COUNT(*) >= 5` keeps only managers with at least five direct reports.

## Pattern to Remember
**Self Join + `GROUP BY` + `HAVING COUNT()`**

Use this pattern when you need to count related records in the same table and filter groups by their count.

## Key Pattern
- `JOIN Employee` — joins the table to itself.
- `ON e.id = r.managerId` — connects managers to their direct reports.
- `HAVING` — filters groups after aggregation.

**Important:** Use `HAVING`, not `WHERE`, to filter based on an aggregate such as `COUNT(*)`.


================================================================================================================================================================================================================================================
LeetCode SQL 197 — Rising Temperature
Concept

Use a self join to compare each day's temperature with the previous day's temperature.

SQL Query
SELECT w1.id
FROM Weather w1
JOIN Weather w2
    ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;
Logic
Join the Weather table to itself.
DATEDIFF(w1.recordDate, w2.recordDate) = 1 matches today's record with yesterday's record.
w1.temperature > w2.temperature selects dates when the temperature increased.
Return the ID of the warmer day.
Pattern to Remember

Self Join + DATEDIFF() + WHERE

Use this pattern when comparing records from consecutive dates.

Key Pattern
w1 — today's weather.
w2 — yesterday's weather.
DATEDIFF() — calculates the difference between two dates.
WHERE — filters rows based on the temperature comparison.

Important: Joining on a one-day date difference ensures the query compares consecutive calendar days, not just the previous available record.


===================================================================================================================================================================================================================================================

18-10-2026

# LeetCode SQL 577 — Employee Bonus

## Concept
Use `LEFT JOIN` and `WHERE` with `OR` to find employees whose bonus is less than 1000 or who have no bonus record.

## SQL Query
```sql
SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b
    ON e.empId = b.empId
WHERE b.bonus < 1000
   OR b.bonus IS NULL;
```

## Logic
1. Use `LEFT JOIN` to include all employees, even those without a bonus record.
2. Match employees and bonuses using `empId`.
3. `b.bonus < 1000` selects employees with bonuses below 1000.
4. `b.bonus IS NULL` selects employees who did not receive a bonus record.

## Pattern to Remember
**`LEFT JOIN` + `WHERE` + `IS NULL` + `OR`**

Use this pattern when you need matching records that satisfy a condition, along with records that have no match.

## Key Pattern
- `LEFT JOIN` — keeps every employee.
- `b.bonus < 1000` — checks for a bonus below 1000.
- `b.bonus IS NULL` — identifies employees with no bonus record.

**Important:** Use `IS NULL`, not `= NULL`, because SQL checks `NULL` values using `IS NULL` or `IS NOT NULL`.
=================================================================================================================================================================================================================================================
18-10-2026

# LeetCode SQL 1873 — Calculate Special Bonus

## Concept
Use `CASE WHEN` to calculate a bonus based on multiple conditions, and `MOD()` to check whether an employee ID is odd or even.

## SQL Query
```sql
SELECT
    employee_id,
    CASE
        WHEN MOD(employee_id, 2) = 1
             AND name NOT LIKE 'M%'
        THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;
```

## Logic
1. `MOD(employee_id, 2) = 1` checks whether the employee ID is odd.
2. `name NOT LIKE 'M%'` checks that the name does not start with `M`.
3. If both conditions are true, the bonus equals the employee's full salary.
4. Otherwise, the bonus is `0`.
5. `ORDER BY employee_id` sorts the results by employee ID.

## Pattern to Remember
**`CASE WHEN` + `MOD()` + `LIKE` + `ORDER BY`**

Use this pattern when calculating values based on conditions.

## Key Pattern
- `MOD(id, 2) = 1` — odd ID.
- `MOD(id, 2) = 0` — even ID.
- `LIKE 'M%'` — name starts with `M`.
- `NOT LIKE 'M%'` — name does not start with `M`.

**Important:** The `%` wildcard matches any sequence of characters after `M`. Both conditions must be true to receive the salary as a bonus.

===============================================================================================================================================================================================================================================

19-10-2026

# LeetCode SQL 627 — Swap Sex of Employees

## Concept
Use `UPDATE` with `CASE WHEN` to swap `'m'` and `'f'` values in a single SQL statement.

## SQL Query
```sql
UPDATE Salary
SET sex = CASE
    WHEN sex = 'm' THEN 'f'
    ELSE 'm'
END;
```

## Logic
1. `UPDATE Salary` modifies the existing table.
2. `CASE WHEN sex = 'm' THEN 'f'` changes male values to female.
3. `ELSE 'm'` changes female values to male.
4. The statement updates every row without creating temporary tables.

## Pattern to Remember
**`UPDATE` + `SET` + `CASE WHEN`**

Use this pattern when you need to change existing values based on conditions.

## Key Pattern
- `UPDATE` — modifies existing records.
- `SET` — specifies the column to change.
- `CASE WHEN` — chooses the new value based on a condition.

**Important:** This solution uses one `UPDATE` statement, as required. The `ELSE 'm'` branch works because the `sex` column contains only `'m'` and `'f'`.

================================================================================================================================================================================================================================================================

19-10-2026

# LeetCode SQL 1661 — Average Time of Process per Machine

## Concept
Use a self join to match each process's start and end timestamps, then calculate the average processing time for each machine.

## SQL Query
```sql
SELECT
    a.machine_id,
    ROUND(AVG(b.timestamp - a.timestamp), 3) AS processing_time
FROM Activity a
JOIN Activity b
    ON a.machine_id = b.machine_id
    AND a.process_id = b.process_id
WHERE a.activity_type = 'start'
  AND b.activity_type = 'end'
GROUP BY a.machine_id;
```

## Logic
1. Join `Activity` to itself using `machine_id` and `process_id`.
2. Alias `a` represents the start record; alias `b` represents the end record.
3. Calculate the duration: `b.timestamp - a.timestamp`.
4. Use `AVG()` to calculate the average duration for each machine.
5. Use `ROUND(..., 3)` to round the result to three decimal places.
6. `GROUP BY a.machine_id` calculates one average per machine.

## Pattern to Remember
**Self Join + `WHERE` + `AVG()` + `ROUND()` + `GROUP BY`**

Use this pattern when matching related records in the same table and calculating an average from their values.

## Key Pattern
- Self join — matches start and end records.
- `AVG()` — calculates the average process duration.
- `ROUND(value, 3)` — rounds to three decimal places.
- `GROUP BY machine_id` — produces one result per machine.

**Important:** Match both `machine_id` and `process_id` so each start timestamp is paired with the correct end timestamp.

==================================================================================================================================================================================================================================================================

20-10-2026
Use this SQL query for LeetCode 1280 — Students and Examinations. It includes every student-subject combination and returns `0` when a student has not attended an exam.

SQL

```
SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
    AND sub.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY
    s.student_id,
    sub.subject_name;
```

### Why this works

* `CROSS JOIN` creates every student-subject combination.

* `LEFT JOIN` matches the exam attendance records.

* `COUNT(e.subject_name)` counts attendance, including duplicate exam records, and returns `0` when there is no match.

* `GROUP BY` calculates the count for each student and subject.

* `ORDER BY` sorts by student ID and subject name.

Important: Use `COUNT(e.subject_name)`, not `COUNT(*)`. Otherwise, combinations without an exam record would incorrectly return `1` instead of `0`.

==================
20-10-2026

LeetCode SQL 1179 — Reformat Department Table

# LeetCode SQL 1179 — Reformat Department Table

## Concept

Use **conditional aggregation** with `MAX(CASE WHEN ...)` to convert monthly rows into separate revenue columns.

## SQL Query

```
SELECT
    id,
    MAX(CASE WHEN month = 'Jan' THEN revenue END) AS Jan_Revenue,
    MAX(CASE WHEN month = 'Feb' THEN revenue END) AS Feb_Revenue,
    MAX(CASE WHEN month = 'Mar' THEN revenue END) AS Mar_Revenue,
    MAX(CASE WHEN month = 'Apr' THEN revenue END) AS Apr_Revenue,
    MAX(CASE WHEN month = 'May' THEN revenue END) AS May_Revenue,
    MAX(CASE WHEN month = 'Jun' THEN revenue END) AS Jun_Revenue,
    MAX(CASE WHEN month = 'Jul' THEN revenue END) AS Jul_Revenue,
    MAX(CASE WHEN month = 'Aug' THEN revenue END) AS Aug_Revenue,
    MAX(CASE WHEN month = 'Sep' THEN revenue END) AS Sep_Revenue,
    MAX(CASE WHEN month = 'Oct' THEN revenue END) AS Oct_Revenue,
    MAX(CASE WHEN month = 'Nov' THEN revenue END) AS Nov_Revenue,
    MAX(CASE WHEN month = 'Dec' THEN revenue END) AS Dec_Revenue
FROM Department
GROUP BY id;
```

## Logic

1. Each row contains a department's revenue for one month.

2. `CASE WHEN month = 'Jan' THEN revenue END` returns revenue only for January.

3. `MAX()` extracts that month's value for each department.

4. Repeat the conditional expression for all 12 months.

5. `GROUP BY id` produces one row per department.

6. Months without revenue records return `NULL`.

## Pattern to Remember

**Conditional Aggregation +** `**CASE WHEN**` **+** `**MAX()**` **+** `**GROUP BY**`

Use this pattern when converting rows into columns, also known as **pivoting**.

## Key Pattern

```
MAX(CASE WHEN condition THEN value END) AS column_name
```

**Important:** Use `MAX()` to aggregate the conditional values into one row per department. Since `(id, month)` is unique, there is at most one revenue value per department per month.
===================






