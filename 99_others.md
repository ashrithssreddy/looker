# 🧰 Miscellaneous
- [1. Development Workflow](#1-development-workflow)
- [2. SQL Runner](#2-sql-runner)
- [3. GitHub Repo in Looker](#3-github-repo-in-looker)


## 1. Development Workflow

Looker's typical development flow follows this sequence:

1. ✅ Start in Production Mode  
→ You can see what the business sees  
→ But you can't make dev changes yet

2. 🔄 Switch to Development Mode  
→ A new Git branch is automatically created for you  
→ You’re now working in isolation

3. 🧱 Create a View File  
→ Go to “Develop” → select your project  
→ Create a new view: `users.view.lkml`  
→ Define `sql_table_name`, at least one `dimension`

Example:
`view: users {`  
`  sql_table_name: analytics.users ;;`  
`  dimension: user_id { type: number sql: ${TABLE}.user_id ;; }`  
`}`

4. 📦 Create/Modify a Model File  
→ If one doesn't exist, create `main.model.lkml`  
→ Add `include: "users.view.lkml"`  
→ Add `explore: users { from: users }`  
→ Add the DB connection name

5. 🧪 Validate LookML  
→ Use the Looker “Validate” button (top-right)  
→ Fix any syntax errors

6. 🔍 Go to Explore  
→ Go to Explore → select your model → `users`  
→ You’ll now see your dimensions from `users.view`

7. 📊 Build Your First Tile  
→ Pick a field (e.g. `user_id`), select count  
→ Choose a chart type (e.g. bar or single value)  
→ Click “Save to Dashboard” → New Dashboard → Name it

8. 💾 Save + Commit  
→ Go back to Develop panel  
→ Commit the files (e.g., `users.view.lkml`, `main.model.lkml`)  
→ Push to Git

9. 🚀 Deploy to Production  
→ Deploy the branch from the Looker UI  
→ Tile + dashboard now available to all users

## 2. SQL Runner (Optional)

SQL Runner is a built-in query editor inside Looker — used for **ad hoc SQL** and quick table inspection.

#### 💡 What It Is
- Lightweight SQL console for querying your connected database
- Doesn’t require LookML or Explore
- Found under **Develop → SQL Runner**

#### 🛠️ When to Use It
- Previewing raw tables before modeling
- Validating SQL join logic manually
- Testing expressions before adding them to LookML
- Quick profiling: checking row counts, NULLs, distinct values

#### ⚡ Running Ad Hoc Queries
- Select a connection → schema → table  
- Write and run SQL directly  
- Results can be downloaded (CSV, JSON)

#### 🧪 Creating Temporary PDTs
- Write a full SQL SELECT statement  
- Click “Save as Persistent Derived Table (PDT)”  
- Looker will create a temp table in your warehouse  
- Good for prototyping views before committing LookML

📌 Notes:
- SQL Runner **does not version** your queries  
- Changes here do not affect LookML or dashboards  
- Great for early exploration, debugging, and QA

## 3. GitHub Repo in Looker
Looker uses **real Git under the hood** — each project links to a Git repo (GitHub, GitLab, Bitbucket, etc.) via the Looker UI. You commit + push from inside Looker’s **Develop tab**, and optionally deploy to production — all tracked in Git history.

#### 📁 Sample Git Repo Structure

looker_project/  
├── README.md  
├── .gitignore  
├── model/  
│   └── main.model.lkml  
├── views/  
│   ├── users.view.lkml  
│   ├── orders.view.lkml  
│   └── products.view.lkml  
├── dashboards/  
│   └── ecommerce.dashboard.lookml  
├── explores/  
│   └── ecommerce.explore.lkml  
├── sets/  
│   └── shared_fields.view.lkml  
└── manifest.lkml

<pre> looker_project/ ├── README.md ├── .gitignore ├── model/ │ └── main.model.lkml ├── views/ │ ├── users.view.lkml │ ├── orders.view.lkml │ └── products.view.lkml ├── dashboards/ │ └── ecommerce.dashboard.lookml ├── explores/ │ └── ecommerce.explore.lkml ├── sets/ │ └── shared_fields.view.lkml └── manifest.lkml </pre>

<pre> 
```text looker_project/ ├── README.md ├── .gitignore ├── model/ │ └── main.model.lkml ├── views/ │ ├── users.view.lkml │ ├── orders.view.lkml │ └── products.view.lkml ├── dashboards/ │ └── ecommerce.dashboard.lookml ├── explores/ │ └── ecommerce.explore.lkml ├── sets/ │ └── shared_fields.view.lkml └── manifest.lkml ``` 
</pre>

<pre> looker_project/ ├── README.md ├── .gitignore ├── model/ │ └── main.model.lkml ├── views/ │ ├── users.view.lkml │ ├── orders.view.lkml │ └── products.view.lkml ├── dashboards/ │ └── ecommerce.dashboard.lookml ├── explores/ │ └── ecommerce.explore.lkml ├── sets/ │ └── shared_fields.view.lkml └── manifest.lkml </pre>

<pre> ``` 
looker_project/
├── README.md
├── .gitignore
├── model/
│   └── main.model.lkml
├── views/
│   ├── users.view.lkml
│   ├── orders.view.lkml
│   └── products.view.lkml
├── dashboards/
│   └── ecommerce.dashboard.lookml
├── explores/
│   └── ecommerce.explore.lkml
├── sets/
│   └── shared_fields.view.lkml
└── manifest.lkml

``` </pre>

- `model/`: Contains all `.model.lkml` files (declares explores + connections)  
- `views/`: Holds each `view:` file with dimensions and measures  
- `dashboards/`: Optional — only used for LookML-defined dashboards  
- `explores/`: Sometimes separated for modular Explore configs  
- `sets/`: Shared field groupings or reusable logic  
- `manifest.lkml`: Project-level config (extensions, includes, etc.)

📌 You interact with this repo inside Looker’s **Develop panel**, but it’s versioned and structured like any GitHub project.






