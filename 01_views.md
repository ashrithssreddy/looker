# 📄 Views in Looker

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










## 2. View File Boilerplate
- Basic example (`view: users { ... }`)
- Required fields: `sql_table_name`, at least one `dimension`
- Optional metadata: `label`, `description`, etc.

## 3. Dimensions
- What is a dimension?
- Common `type:` values (`string`, `number`, `yesno`, etc.)
- Syntax examples
- `dimension_group` for time-based fields

## 4. Measures
- What is a measure?
- Common `type:` values (`sum`, `count`, `average`, etc.)
- Syntax examples
- Custom SQL-based measures

## 5. Time Handling in Views
- `dimension_group` with `timeframes`
- `convert_tz` and timezone handling
- Using time filters

## 6. Real-World Examples
- Sample ecommerce view: `orders.view.lkml`
- Sample user profile view: `users.view.lkml`


