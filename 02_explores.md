# 📂 Explores in Looker
- [1. What is an Explore?](#1-what-is-an-explore)
- [2. Explore Boilerplate](#2-explore-boilerplate)
- [3. Joins](#3-joins)
- [4. Filters in Explores](#4-filters-in-explores)
- [5. Drill Fields and Field Sets](#5-drill-fields-and-field-sets)
- [6. Real-World Example](#6-real-world-example)

## 1. What is an Explore?

An **Explore** in Looker is the starting point for analysis — it defines **which view(s)** users can query, and **how they relate** to each other.

#### 🧠 Layman Explanation  
Think of an Explore as a **curated lens** into your data.  
It tells Looker:
- Which table (view) to start from
- What other tables can be joined
- What filters, limits, or restrictions should apply

A user opens an Explore to slice, dice, filter, and visualize — all without writing SQL.

#### 🔗 How It Connects Views  
- Explores are defined in the **model file**
- Each Explore starts with a `from:` view (base view)
- Then joins other views using `join:` blocks  
You can expose **only one Explore per analysis**, but that Explore can reference many views.

#### 🧱 Role in Looker's Architecture  
**Model → Explore → View**

- **Model**: Declares Explores and includes views  
- **Explore**: Defines join logic between views  
- **View**: Contains fields (dimensions/measures) from a table

📌 TL;DR:  
An **Explore** connects views together and acts as the interface for end users to explore data through Looker’s UI — without needing SQL.

## 2. Explore Boilerplate

An Explore block lives in a **model file** (`.model.lkml`) and defines what view to explore, and what joins (if any) are allowed.

#### 🧱 Basic Syntax

`explore: orders {`  
`  from: orders`  
`}`

This creates an Explore named `orders` that starts from the `orders.view`.

#### 🔁 `from:` vs `joins:`

- `from:` defines the **base view** (starting table for queries)
- `join:` lets you bring in additional views (tables) via join logic

You can only have one `from:` per explore, but as many `join:` blocks as needed.

#### 🧩 Primary vs Joined Views

- The **primary view** (defined via `from:`) anchors the explore
- All filters, measures, and visualizations default to this base
- **Joined views** contribute related fields (e.g., user info on top of orders)

📌 Example with a join:
`explore: orders {`  
`  from: orders`  

`  join: users {`  
`    type: left_outer`  
`    sql_on: ${orders.user_id} = ${users.id} ;;`  
`  }`  
`}`

## 3. Joins

Joins in Looker allow you to pull in fields from other views (tables) into an Explore. All joins are defined inside the `explore:` block in a model file.

#### 🔧 Syntax and Required Fields

Every `join:` block needs at minimum:
- `name:` (implied by `join: users`)
- `type:` (join type)
- `sql_on:` (join condition)

Example:

`join: users {`  
`  type: left_outer`  
`  sql_on: ${orders.user_id} = ${users.id} ;;`  
`}`

#### 🔀 Join `type:` Options
- `left_outer` — default and most common
- `inner` — only matching rows
- `full_outer` — uncommon, supported in some dialects
- `cross` — avoid unless intentional

#### 🧮 `relationship:` (optional but important)
- Defines cardinality between primary and joined view  
- Helps Looker avoid exploding row counts

Options:
- `one_to_one`
- `many_to_one` (most common)
- `one_to_many`
- `many_to_many` (use cautiously)

Example:
`relationship: many_to_one`

#### 📌 Notes
- Use fully qualified field names in `sql_on:`: `${orders.user_id} = ${users.id}`
- Always test explores in the UI to ensure join behavior is sane



## 4. Filters in Explores

Explores can include built-in filters that control what data users see — either for UX reasons or for access control.

#### 🎯 `always_filter:`
Applies a filter **automatically** every time someone queries the Explore — users **can’t remove or override it**.

Useful for:
- Limiting to active records
- Enforcing time windows
- Hiding test data

Example:  
`always_filter: {`  
`  filters: [status: "active"]`  
`}`

#### 🔐 `access_filter:`
Implements **row-level security** — filters data based on **user attributes**.

Example:  
Only show rows where the `region` matches the user’s assigned region.

`access_filter: {`  
`  field: users.region`  
`  user_attribute: user_region`  
`}`

- `user_attribute` is managed in the Looker Admin panel  
- This is **invisible** to the end user — they can’t bypass it

#### 📌 Notes
- `always_filter` = hardcoded  
- `access_filter` = dynamic, based on the logged-in user  
- Both live inside the `explore:` block


## 5. Drill Fields and Field Sets

You can use `fields:` and `set:` to control what fields are visible or drillable inside an Explore.

#### 🎯 `fields: [...]`
Limits which dimensions and measures are exposed to users when they open the Explore.

Example:  
`fields: [orders.order_id, orders.order_date, users.first_name]`

Useful for:
- Hiding noisy or backend-only fields
- Keeping Explores clean and focused

#### 🧩 `set:` for Reusable Field Groups

Define field groups once and reuse them across Explores or joins.

Example:  
`set: user_core_fields {`  
`  fields: [users.id, users.email, users.signup_date]`  
`}`

Then include in an Explore or join like:  
`fields: [user_core_fields]`

#### 📌 Notes
- `fields:` is allowed inside `explore`, `join`, and `set`
- Helps reduce visual clutter for business users
- Also useful for permissioning different Explore variants

## 6. Real-World Example

Below is a complete `explore:` block from a model file. It starts from the `orders` view, joins `users` and `products`, and applies both an `always_filter` and `access_filter`.

`explore: orders {`  
`  from: orders`  

`  always_filter: {`  
`    filters: [orders.is_test_order: "no"]`  
`  }`  

`  access_filter: {`  
`    field: users.region`  
`    user_attribute: user_region`  
`  }`  

`  join: users {`  
`    type: left_outer`  
`    sql_on: ${orders.user_id} = ${users.id} ;;`  
`    relationship: many_to_one`  
`    fields: [user_core_fields]`  
`  }`  

`  join: products {`  
`    type: left_outer`  
`    sql_on: ${orders.product_id} = ${products.id} ;;`  
`    relationship: many_to_one`  
`  }`  
`}`
