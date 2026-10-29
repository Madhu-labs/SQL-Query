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

========================================================================================================================================================================================================================================= 
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
======================================================================================================================================================================================================================================
21-10-2026

# LeetCode SQL 176 — Second Highest Salary

## Concept
Use `DISTINCT`, `ORDER BY`, and `LIMIT` with `OFFSET` to find the second-highest distinct salary. Use a subquery so the result is `NULL` when no second-highest salary exists.

## SQL Query
```sql
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```

## Logic
1. `DISTINCT salary` removes duplicate salaries.
2. `ORDER BY salary DESC` sorts salaries from highest to lowest.
3. `LIMIT 1 OFFSET 1` skips the highest salary and selects the next one.
4. The outer `SELECT` returns the result as `SecondHighestSalary`.
5. If there is no second-highest distinct salary, the subquery returns `NULL`.

## Pattern to Remember
**`DISTINCT` + `ORDER BY DESC` + `LIMIT` + `OFFSET` + Subquery**

Use this pattern to retrieve the Nth-highest distinct value.

## Key Pattern
```sql
ORDER BY column_name DESC
LIMIT 1 OFFSET 1;
```

**Important:** Use `DISTINCT` because the problem asks for the second-highest *distinct* salary. The scalar subquery ensures the output still contains one row with `NULL` if a second salary does not exist.

=================================================================================================================================================================================================================================================

21-10-2026

# LeetCode SQL 184 — Department Highest Salary

## Concept
Use a subquery with `GROUP BY` and `MAX()` to find the highest salary in each department, then join the results to retrieve all employees earning that salary.

## SQL Query
```sql
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
    ON e.departmentId = d.id
JOIN (
    SELECT departmentId, MAX(salary) AS max_salary
    FROM Employee
    GROUP BY departmentId
) m
    ON e.departmentId = m.departmentId
    AND e.salary = m.max_salary;
```

## Logic
1. The subquery groups employees by `departmentId`.
2. `MAX(salary)` finds the highest salary in each department.
3. Join the subquery with `Employee` using the department ID and matching salary.
4. Join `Department` to get the department name.
5. Employees tied for the highest salary are all included.

## Pattern to Remember
**`GROUP BY` + `MAX()` + Subquery + `JOIN`**

Use this pattern when you need to find records matching the maximum value within each group.

## Key Pattern
```sql
SELECT departmentId, MAX(salary)
FROM Employee
GROUP BY departmentId;
```

**Important:** Do not use `LIMIT 1` for each department. Multiple employees can share the highest salary, and the solution must return all of them.
=======================================================================================================================================================================================================================================

22-10-2026

# LeetCode SQL 185 — Department Top Three Salaries

## Concept
Use `DENSE_RANK()` with `PARTITION BY` to rank employees by salary within each department and return employees whose salary ranks in the top three distinct salaries.

## SQL Query
```sql
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM (
    SELECT
        name,
        salary,
        departmentId,
        DENSE_RANK() OVER (
            PARTITION BY departmentId
            ORDER BY salary DESC
        ) AS salary_rank
    FROM Employee
) e
JOIN Department d
    ON e.departmentId = d.id
WHERE e.salary_rank <= 3;
```

## Logic
1. `PARTITION BY departmentId` ranks employees separately within each department.
2. `ORDER BY salary DESC` ranks the highest salary first.
3. `DENSE_RANK()` assigns the same rank to equal salaries without skipping the next rank.
4. `WHERE salary_rank <= 3` keeps employees earning one of the top three **distinct** salaries.
5. Join `Department` to retrieve department names.

## Pattern to Remember
**`DENSE_RANK()` + `PARTITION BY` + `ORDER BY` + Subquery**

Use this pattern when you need the top N distinct values within each group, including ties.

## Key Pattern
```sql
DENSE_RANK() OVER (
    PARTITION BY departmentId
    ORDER BY salary DESC
)
```

**Important:** Use `DENSE_RANK()`, not `ROW_NUMBER()`. Equal salaries must receive the same rank, and all employees tied within the top three distinct salaries must be returned.
==================================================================================================================================================================================================================================================
22-10-2026

# 1667. Fix Names in a Table

**Concept:** String Functions — `UPPER()`, `LOWER()`, `SUBSTRING()`

### SQL Query
```sql
SELECT user_id,
       CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;
```

### Logic
- `LEFT(name, 1)` extracts the first character.
- `UPPER()` converts it to uppercase.
- `SUBSTRING(name, 2)` extracts the remaining characters.
- `LOWER()` converts the remaining characters to lowercase.
- `CONCAT()` joins both parts.
- `ORDER BY user_id` sorts the result by user ID.

### Pattern to Remember
Use `UPPER()` for the first character and `LOWER()` for the remaining characters.

**Key Pattern:** String manipulation + sorting.

**Important:** Use `SELECT` to format the output; do not use `UPDATE`, because the problem asks you to return a result table.
========================================================================================================================================================================================================================================================
23-10-2026

# 1527. Patients With a Condition

**Concept:** Pattern Matching using `LIKE` and `REGEXP`

### SQL Query
```sql
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%'
   OR conditions LIKE '% DIAB1%';
```

### Logic
- `LIKE 'DIAB1%'` finds conditions starting with `DIAB1`.
- `LIKE '% DIAB1%'` finds `DIAB1` after a space, meaning it starts another condition code.
- `OR` includes patients matching either condition.

### Pattern to Remember
Condition codes are separated by spaces, so check both the beginning of the string and occurrences after a space.

**Key Pattern:** `LIKE` + wildcard `%`.

**Important:** Do not use `LIKE '%DIAB1%'` alone because it could match `DIAB1` in the middle of a code rather than at the beginning of a condition code.

=======================================================================================================================================================================================================================================================================
23-10-2026

# 1141. User Activity for the Past 30 Days I

**Concept:** `COUNT(DISTINCT)` + `GROUP BY` + Date Filtering

### SQL Query
```sql
SELECT activity_date AS day,
       COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;
```

### Logic
- `BETWEEN` selects dates from June 28 to July 27, 2019, inclusive (30 days).
- `GROUP BY activity_date` groups activities by day.
- `COUNT(DISTINCT user_id)` counts each user only once per day, even if they perform multiple activities.
- `AS day` and `AS active_users` give the required column names.

### Pattern to Remember
Use `COUNT(DISTINCT user_id)` when counting unique users per day.

**Key Pattern:** Date filtering + grouping + distinct counting.

**Important:** Do not count all rows with `COUNT(*)`, because one user can perform multiple activities on the same day. Days with zero activity are automatically excluded.
===========================================================================================================================================================================================
24-10-2026
# 1174. Immediate Food Delivery II

**Concept:** First Order + Conditional Aggregation + Percentage Calculation

### SQL Query
```sql
SELECT
    ROUND(
        AVG(order_date = customer_pref_delivery_date) * 100,
        2
    ) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MIN(order_date)
    FROM Delivery
    GROUP BY customer_id
);
```

### Logic
- The subquery finds each customer's earliest `order_date`.
- The `WHERE` clause keeps only each customer's first order.
- `order_date = customer_pref_delivery_date` evaluates to `1` for immediate orders and `0` for scheduled orders in MySQL.
- `AVG()` calculates the fraction of immediate first orders.
- Multiply by `100` to get the percentage.
- `ROUND(..., 2)` rounds the result to two decimal places.

### Pattern to Remember
Use `MIN(date)` with `GROUP BY customer_id` to identify each customer's first order.

**Key Pattern:** First record per group + conditional average.

**Important:** Calculate the percentage using only first orders, not all orders. This solution uses MySQL syntax.

==============================================================================================================================================================================================================================
24-10-2026

# 550. Game Play Analysis IV

**Concept:** First Login + Date Difference + Percentage Calculation

### SQL Query
```sql
SELECT ROUND(
    COUNT(DISTINCT a.player_id) /
    (SELECT COUNT(DISTINCT player_id) FROM Activity),
    2
) AS fraction
FROM Activity a
JOIN (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
) f
ON a.player_id = f.player_id
AND a.event_date = DATE_ADD(f.first_login, INTERVAL 1 DAY);
```

### Logic
- The subquery finds each player's first login date using `MIN(event_date)`.
- `DATE_ADD(first_login, INTERVAL 1 DAY)` calculates the next calendar day.
- The `JOIN` keeps players who logged in on that next day.
- `COUNT(DISTINCT a.player_id)` counts those players.
- Divide by the total number of distinct players.
- `ROUND(..., 2)` rounds the fraction to two decimal places.

### Pattern to Remember
Use `MIN(date)` to find the first event, then `DATE_ADD()` to check the following day.

**Key Pattern:** First occurrence per group + date comparison + fraction.

**Important:** Return a fraction, not a percentage. For example, `1 / 3 = 0.33`, not `33.33`.
=============================================================================================================================================================================================================================================
27-10-2026

# 178. Rank Scores

**Concept:** Window Function — `DENSE_RANK()`

### SQL Query
```sql
SELECT score,
       DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores
ORDER BY score DESC;
```

### Logic
- `ORDER BY score DESC` ranks scores from highest to lowest.
- `DENSE_RANK()` assigns the same rank to equal scores.
- After a tie, the next rank is consecutive, with no gaps.
- The final `ORDER BY score DESC` displays scores in descending order.

### Pattern to Remember
Use `DENSE_RANK()` when equal values must share a rank and the next rank must have no gaps.

**Key Pattern:** Ranking + window function.

**Important:** Use `DENSE_RANK()`, not `RANK()`. `RANK()` leaves gaps after ties, while `DENSE_RANK()` does not.

=============================================================================================================================================================================================
27-10-2026

# 180. Consecutive Numbers

**Concept:** Self-Join + Consecutive Rows

### SQL Query
```sql
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1
JOIN Logs l3 ON l2.id = l3.id - 1
WHERE l1.num = l2.num
  AND l2.num = l3.num;
```

### Logic
- `l1`, `l2`, and `l3` represent three rows of the same table.
- The joins ensure the rows have consecutive IDs.
- `l1.num = l2.num AND l2.num = l3.num` checks that all three numbers are equal.
- `DISTINCT` prevents duplicate numbers in the output.

### Pattern to Remember
Use multiple self-joins when checking whether values repeat across consecutive rows.

**Key Pattern:** Self-join + consecutive IDs + equality checks.

**Important:** Three consecutive rows must have the same number. The number may appear more than three times; `DISTINCT` ensures it is returned only once.

==========================================================================================================================================================================================================
28-10-2026


# 1965. Employees With Missing Information

**Concept:** `FULL OUTER JOIN` logic using `UNION` and `LEFT JOIN`

### SQL Query
```sql
SELECT e.employee_id
FROM Employees e
LEFT JOIN Salaries s
    ON e.employee_id = s.employee_id
WHERE s.salary IS NULL

UNION

SELECT s.employee_id
FROM Salaries s
LEFT JOIN Employees e
    ON s.employee_id = e.employee_id
WHERE e.name IS NULL

ORDER BY employee_id;
```

### Logic
- The first query finds employees whose salary is missing.
- The second query finds employees whose name is missing.
- `UNION` combines the results and removes duplicates.
- `ORDER BY employee_id` sorts IDs in ascending order.

### Pattern to Remember
Use `LEFT JOIN` with `IS NULL` to find records missing from another table.

**Key Pattern:** Missing records + `LEFT JOIN` + `IS NULL` + `UNION`.

**Important:** MySQL does not support `FULL OUTER JOIN` directly, so combine two `LEFT JOIN` queries using `UNION`.

============================================================================================================================================================================================================================
28-10-2026

# 601. Human Traffic of Stadium

**Concept:** Self-Joins + Consecutive IDs

### SQL Query
```sql
SELECT DISTINCT s1.*
FROM Stadium s1
JOIN Stadium s2
    ON s2.id = s1.id + 1
JOIN Stadium s3
    ON s3.id = s1.id + 2
WHERE s1.people >= 100
  AND s2.people >= 100
  AND s3.people >= 100
  AND (
      s1.id IN (
          SELECT id FROM Stadium WHERE people >= 100
      )
  )
ORDER BY s1.visit_date;
```

### Correct, complete solution
```sql
SELECT DISTINCT s.*
FROM Stadium s
WHERE s.people >= 100
  AND (
      s.id IN (
          SELECT s1.id
          FROM Stadium s1
          JOIN Stadium s2 ON s2.id = s1.id + 1
          JOIN Stadium s3 ON s3.id = s1.id + 2
          WHERE s1.people >= 100
            AND s2.people >= 100
            AND s3.people >= 100
      )
      OR s.id - 1 IN (
          SELECT s1.id
          FROM Stadium s1
          JOIN Stadium s2 ON s2.id = s1.id + 1
          JOIN Stadium s3 ON s3.id = s1.id + 2
          WHERE s1.people >= 100
            AND s2.people >= 100
            AND s3.people >= 100
      )
      OR s.id - 2 IN (
          SELECT s1.id
          FROM Stadium s1
          JOIN Stadium s2 ON s2.id = s1.id + 1
          JOIN Stadium s3 ON s3.id = s1.id + 2
          WHERE s1.people >= 100
            AND s2.people >= 100
            AND s3.people >= 100
      )
  )
ORDER BY s.visit_date;
```

### Logic
- A valid group requires at least **three consecutive IDs**.
- Each row in that group must have `people >= 100`.
- The query identifies every group of three qualifying consecutive IDs.
- It returns all qualifying rows belonging to those groups, including overlapping groups.
- `DISTINCT` removes duplicates, and `ORDER BY` sorts by visit date.

### Pattern to Remember
Use self-joins to find three consecutive IDs, then include every qualifying row that belongs to a group of at least three.

**Key Pattern:** Consecutive rows + threshold condition + overlapping groups.

**Important:** Consecutive means consecutive `id` values, not consecutive calendar dates.
===========================================================================================================================================================================================================================================

29-10-2026


# 1204. Last Person to Fit in the Bus

**Concept:** Window Function + Cumulative Sum

### SQL Query
```sql
SELECT person_name
FROM (
    SELECT person_name,
           SUM(weight) OVER (ORDER BY turn) AS total_weight
    FROM Queue
) q
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1;
```

### Logic
- `SUM(weight) OVER (ORDER BY turn)` calculates the cumulative weight as people board in turn order.
- The inner query calculates the total weight after each person boards.
- `WHERE total_weight <= 1000` keeps people who fit within the bus limit.
- `ORDER BY total_weight DESC LIMIT 1` returns the last person who can board.

### Pattern to Remember
Use a window function with `SUM() OVER (ORDER BY ...)` to calculate a running total.

**Key Pattern:** Cumulative sum + filtering + last valid row.

**Important:** Use `turn` to determine boarding order, not `person_id`. The bus limit is 1,000 kg.

==============================================================================================================================================================================================================================================


29-10-2026

# 1321. Restaurant Growth

**Concept:** Self-Join + Seven-Day Moving Window

### SQL Query
```sql
SELECT
    a.visited_on,
    SUM(b.amount) AS amount,
    ROUND(SUM(b.amount) / 7, 2) AS average_amount
FROM (
    SELECT visited_on, SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
) a
JOIN (
    SELECT visited_on, SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
) b
    ON DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
GROUP BY a.visited_on
HAVING COUNT(*) = 7
ORDER BY a.visited_on;
```

### Logic
- First, group customer payments by date to get each day's total.
- Join the daily totals so each date matches itself and the previous six days.
- `SUM(b.amount)` calculates the total amount over the seven-day window.
- Divide by `7` and use `ROUND(..., 2)` to calculate the average.
- `HAVING COUNT(*) = 7` ensures the window contains seven days.
- `ORDER BY` returns dates in ascending order.

### Pattern to Remember
Aggregate by date first, then use a self-join with `DATEDIFF()` to calculate a moving window.

**Key Pattern:** Daily aggregation + date-range join + moving average.

**Important:** The output starts only after seven days of data are available. The average is the seven-day total divided by `7`, not the number of customer records.

===============================================================================================================================================================================================================================================================
30-10-2026




