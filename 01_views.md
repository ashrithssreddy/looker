# 📄 Views in Looker
- [1. What is a View?](#1-what-is-a-view)
- [2. View File Boilerplate](#2-view-file-boilerplate)
- [3. Dimensions](#3-dimensions)
- [4. Measures](#4-measures)
- [5. Time Handling in Views](#5-time-handling-in-views)
- [6. Real-World Examples](#6-real-world-examples)

## 1. What is a View?

In Looker, a **View** is like a _blueprint_ for a table in your database.

- It tells Looker **where to look** (`sql_table_name`) and
- **how to interpret** each column (via `dimension`, `measure`, etc.)

Think of it as a **wrapper around a database table or SQL result**, where you define:
- What fields are available
- How they should be aggregated
- What metadata (labels, descriptions, formats) they carry

#### 🧠 How it connects to tables
- Every view usually maps to **one base table** (or derived table via SQL)
- It uses `sql_table_name: schema.table_name` to establish this connection

#### 🔁 Where it fits in Looker's architecture
Model → Explore → View
- **Model**: Says what Explores are available
- **Explore**: Combines multiple Views via joins
- **View**: Represents the structure and meaning of one table

📌 TL;DR:  
A **View** defines how Looker should understand and work with a single table (or derived result), including what to expose to business users.








## 2. View File Boilerplate

Every LookML view file starts with a `view:` declaration. It's used to define fields like dimensions and measures based on an underlying table.

#### 🧱 Basic Boilerplate  
`view: users {`  
`  sql_table_name: analytics.users ;;`  
`  dimension: user_id {`  
`    type: number`  
`    primary_key: yes`  
`    sql: ${TABLE}.user_id ;;`  
`  }`  
`  measure: total_users {`  
`    type: count`  
`  }`  
`}`

#### ✅ Required Fields  
- `view:` — Name of the view (typically matches the table)  
- `sql_table_name:` — Specifies the source table or derived result  
- At least one `dimension:` is required

#### 🧩 Optional Metadata  
- `label:` — UI-friendly name for the view  
- `description:` — Tooltip info for views or fields  
- `group_label:` — Collapses related fields together in the UI  




## 3. Dimensions

A **dimension** in Looker represents a raw column or a derived field — used for grouping, filtering, or displaying raw values in reports.

#### 🧠 Concept
- Dimensions are **non-aggregated fields**
- Think: `user_id`, `state`, `product_category`, `signup_date`
- Business users **group by** or **filter on** dimensions in dashboards

#### 🛠️ Common `type:` Values
- `string` — text fields like names, emails, categories  
- `number` — integers, floats, prices  
- `yesno` — boolean flags  
- `date`, `time`, `datetime` — date/time fields  
- `tier` — bucketing logic (e.g., price tiers)

#### 🧾 Example
`dimension: product_name {`  
`  type: string`  
`  sql: ${TABLE}.product_name ;;`  
`}`

#### ⏳ dimension_group (for time fields)
Used to auto-generate multiple time resolutions (e.g., day, week, month).

`dimension_group: signup_date {`  
`  type: time`  
`  timeframes: [raw, date, week, month, year]`  
`  sql: ${TABLE}.signup_ts ;;`  
`}`

#### 📌 Notes
- Every view needs **at least one dimension**
- Always close with `;;` in `sql:` blocks
- You can alias columns, cast types, or derive new ones using SQL inside `sql:`



## 4. Measures

A **measure** is an aggregated field — used to compute metrics like totals, averages, counts. Measures are typically the numbers business users care about.

#### 🧠 Concept
- Measures apply **aggregations** on top of dimensions
- Think: `total_sales`, `avg_order_value`, `count_users`
- Always requires a `type:` and often a `sql:` clause

#### ⚙️ Common `type:` Values
- `count` — total number of rows  
- `count_distinct` — unique count of a column  
- `sum` — total of a numeric field  
- `average` — mean value  
- `min`, `max` — smallest/largest value  
- `number` — use when defining a custom SQL aggregation manually

#### 🧾 Simple Example
`measure: total_sales {`  
`  type: sum`  
`  sql: ${TABLE}.sales_amount ;;`  
`}`

#### 🧪 Custom SQL-based Measure
Use `type: number` when you're writing full SQL logic yourself.

`measure: new_vs_repeat_ratio {`  
`  type: number`  
`  sql: CASE WHEN ${is_new} THEN 1 ELSE 0 END * 1.0 / COUNT(*) ;;`  
`}`

#### 📌 Notes
- Measures appear under the "Aggregates" section in Explore UI  
- You can reuse dimensions in measure definitions (e.g., `${price}` in sum)
- Always validate the aggregation makes sense for the business logic

## 5. Time Handling in Views

Time-based fields in Looker are handled using `dimension_group`, which auto-generates multiple granularities from a single timestamp.

#### ⏳ dimension_group with timeframes
Use this to expose fields like `signup_date`, `signup_week`, `signup_year` — all from one column.

`dimension_group: signup_date {`  
`  type: time`  
`  timeframes: [raw, date, week, month, quarter, year]`  
`  sql: ${TABLE}.signup_ts ;;`  
`}`

#### 🌐 Timezone Handling with convert_tz
If your DB stores UTC but you want reports in a local timezone:

`sql: CONVERT_TZ(${TABLE}.created_at, 'UTC', 'America/Los_Angeles') ;;`

- Works in MySQL and some dialects
- In BigQuery or Snowflake, use their respective `TIMESTAMP` functions

#### 🔍 Using Time Filters
Once a `dimension_group` is defined, Looker automatically enables time filters like:

- `is in the past 7 days`
- `is on or after last month`
- `is between date A and date B`

These filters are accessible from the Explore UI without extra config.

#### 📌 Notes
- Avoid using raw timestamps directly in filters — always define `dimension_group`
- You can use `datatype: date_time` in SQL Runner to preview data formats
- Always check your warehouse’s native time functions for edge-case formatting


## 6. Real-World Examples

Here are two example view files to demonstrate how dimensions, measures, and time handling come together in real projects.

#### 📦 orders.view.lkml

`view: orders {`  
`  sql_table_name: analytics.orders ;;`  

`  dimension: order_id {`  
`    type: number`  
`    primary_key: yes`  
`    sql: ${TABLE}.order_id ;;`  
`  }`  

`  dimension: customer_id {`  
`    type: number`  
`    sql: ${TABLE}.customer_id ;;`  
`  }`  

`  dimension_group: order_date {`  
`    type: time`  
`    timeframes: [date, week, month, year]`  
`    sql: ${TABLE}.order_ts ;;`  
`  }`  

`  measure: total_revenue {`  
`    type: sum`  
`    sql: ${TABLE}.order_amount ;;`  
`  }`  
`}`

#### 👤 users.view.lkml

`view: users {`  
`  sql_table_name: analytics.users ;;`  

`  dimension: user_id {`  
`    type: number`  
`    primary_key: yes`  
`    sql: ${TABLE}.user_id ;;`  
`  }`  

`  dimension: email {`  
`    type: string`  
`    sql: ${TABLE}.email_address ;;`  
`  }`  

`  dimension_group: signup_date {`  
`    type: time`  
`    timeframes: [date, month, year]`  
`    sql: ${TABLE}.signup_ts ;;`  
`  }`  

`  measure: total_users {`  
`    type: count`  
`  }`  
`}`


