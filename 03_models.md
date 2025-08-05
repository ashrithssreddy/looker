# 🧩 Models in Looker
- [1. What is a Model?](#1-what-is-a-model)
- [2. Model Boilerplate](#2-model-boilerplate)
- [3. Includes](#3-includes)
- [4. Connection](#4-connection)
- [5. Datagroups and PDT Triggers](#5-datagroups-and-pdt-triggers)
- [6. Real-World Example](#6-real-world-example)

## 1. What is a Model?

A **Model** in Looker is the **entry point** for a data project. It tells Looker:
- Which Explores exist
- How views are joined
- What database to use
- What caching policies apply

#### 🧠 Layman Explanation
If views are tables, and explores are joinable datasets, then the model is the **blueprint** for how all those views and explores are wired together.

Think of the `.model.lkml` file as the **"routing config"** for your data app.

#### 🔁 Model → Explore → View Recap
- **Model**: Includes and configures Explores  
- **Explore**: Combines Views  
- **View**: Represents a table or derived result

You can have multiple `.model.lkml` files in a project — each defining its own explore universe.

#### 📌 TL;DR  
The model file glues together views, defines explores, sets the connection, and handles caching — it's the brain of your Looker project.

## 2. Model Boilerplate

A `.model.lkml` file defines the explores available to users and sets up project-wide configs like DB connection, includes, and caching.

#### 🧱 Basic Structure

`connection: analytics_db`  
`include: "*.view"`  
`include: "*.explore.lkml"`  

`explore: orders {`  
`  from: orders`  
`}`

#### 🧩 Key Components

- `connection:` — Tells Looker which DB connection to use (defined in Admin panel)
- `include:` — Brings in `.view` or `.explore` files from the project
- `explore:` — Declares each Explore, with optional joins, filters, etc.

#### 📌 Notes
- A model can contain **many explores**
- You can create multiple model files for different subject areas (e.g., `sales.model.lkml`, `marketing.model.lkml`)
- Use `include:` wildcards to keep your model file clean and modular


## 3. Includes

The `include:` statement lets you pull other LookML files into your model file. This is how you link your views, explores, and other config files into a model.

#### 📂 Common Patterns

`include: "*.view"`  
`include: "*.explore.lkml"`  
`include: "shared/sets/*.lkml"`  

- Wildcards (`*`) are allowed
- Subfolder paths must be explicitly listed

#### 🔧 How It Works

- Looker compiles all included files together into a single namespace
- You can only use views or explores in a model **after including them**
- Good practice: keep views, explores, and sets in separate folders

#### 📌 Notes
- `include:` is only allowed in `.model.lkml` and `manifest.lkml`
- File paths are **relative to the project root**
- If a view or set isn’t recognized, check whether it’s properly included


## 4. Connection

The `connection:` parameter in the model file tells Looker **which database** to run queries against.

#### 🔌 What It Points To

- The value must match a **connection name** defined in the **Looker Admin > Connections** panel
- That connection includes:
  - Dialect (BigQuery, Snowflake, Redshift, etc.)
  - Host, credentials, and schema access

Example:  
`connection: analytics_db`

This tells Looker to use the `analytics_db` connection for all explores in this model.

#### 📌 Notes
- Every model must have one and only one `connection:` line
- Multiple models can share the same connection
- Connection switching is done via model files, not views or explores

## 5. Datagroups and PDT Triggers

Looker uses **datagroups** to manage caching and refresh logic for **Persistent Derived Tables (PDTs)**.

#### 🧠 What is a Datagroup?

A `datagroup` defines:
- When cached query results expire
- When PDTs should be rebuilt

It is declared in the **model file**.

Example:  
`datagroup: hourly_refresh {`  
`  max_cache_age: "1 hour"`  
`}`

#### 🔁 How PDTs Use Datagroups

In a view with a PDT, reference the datagroup like this:  
`persist_with: datagroup_trigger: hourly_refresh`

This tells Looker:
- Cache results for 1 hour  
- Rebuild the PDT every hour

#### ⏳ `persist_for:` vs `trigger`

- `persist_for:` — defines static cache TTL (e.g., "24 hours")
- `datagroup_trigger:` — ties to a datagroup's cache + rebuild schedule

Use `datagroup_trigger` when multiple views or PDTs need to stay in sync.

#### 📌 Notes
- All datagroups live in the model file
- PDT triggers only work if the database supports it (e.g., Snowflake, BQ, Redshift)
- You can monitor PDT rebuilds in **Looker Admin > PDTs**


## 6. Real-World Example

Here’s a complete `.model.lkml` file that includes a connection, includes, explore, and a datagroup trigger.

`connection: analytics_db`  
`include: "*.view"`  
`include: "*.explore.lkml"`  

`datagroup: daily_refresh {`  
`  max_cache_age: "24 hours"`  
`}`

`explore: orders {`  
`  from: orders`  

`  join: users {`  
`    type: left_outer`  
`    sql_on: ${orders.user_id} = ${users.id} ;;`  
`    relationship: many_to_one`  
`  }`  
`}`

This model connects to a DB, loads all views and explores, applies a 24-hour cache policy, and defines an `orders` explore with a `users` join.

