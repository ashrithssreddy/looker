# 📊 Visualizations in Looker
- [1. Types of Visualizations](#1-types-of-visualizations)
- [2. Customizations](#2-customizations)
- [3. Dashboards](#3-dashboards)
- [4. LookML Dashboards (Optional)](#4-lookml-dashboards-optional)
- [5. Drill Fields & Interactions](#5-drill-fields--interactions)

## 1. Types of Visualizations

Looker supports the following chart types in its Explore and Dashboard UI — ordered from most frequently used to least:

- Table  
- Bar chart  
- Line chart  
- Column chart  
- Pie chart  
- Single value  
- Area chart  
- Scatter plot  
- KPI (with trend line)  
- Donut chart  
- Funnel chart  
- Gauge  
- Boxplot  
- Map (points)  
- Map (regions)  
- Waterfall chart  
- Treemap  
- Timeline  
- Word cloud  
- Custom visualizations (via JavaScript plugin)

## 2. Customizations

Looker provides multiple ways to customize visualizations to match user needs or business branding.

#### 🎯 Axes, Series, Colors
- Toggle **x/y axes**, **gridlines**, and **label orientation**
- Control **color schemes**, **series ordering**, and **labeling**
- Apply **value formatting** (currency, %, decimals) directly in the UI

These settings are available per tile in the **"Edit" > "Series" and "Plot"** tabs.

#### ➕ Table Calculations and Custom Fields
- Table calcs allow you to write Excel-style formulas on top of query results (e.g., `${revenue} / ${orders}`)
- Custom fields can be built via point-and-click UI (no LookML needed)
- Use `percent_of_previous`, `rank`, `moving average`, and more

Useful for lightweight transformations without touching backend LookML.

#### 🧠 HTML Tooltips (Advanced)

Looker supports **custom HTML in tooltips** to show dynamic context when hovering over chart elements.

✅ Where to use:
- Line, bar, scatter, and other charts with hover elements

✅ How to define:
In your view file, you can define an `html` block inside a `dimension` or `measure`.

Example:

`measure: avg_order_value {`  
`  type: average`  
`  sql: ${TABLE}.order_amount ;;`  
`  html: "<b>Avg:</b> \${value}"`  
`}`

✅ Supported tokens:
- `\${value}` — shows the measure's rendered value
- `\${name}` — shows the field label
- You can embed other HTML elements like `<b>`, `<br>`, `<i>`, and inline styling

Tooltips are especially useful when:
- You want to show multiple metrics without cluttering the chart
- You want to show derived context (e.g., % change from previous)

📌 Notes:
- Only available in **LookML-defined fields**, not custom fields in Explore
- Helps make dashboards feel more interactive and insightful

## 3. Dashboards

Dashboards in Looker are visual collections of saved queries and charts — often created directly from the Explore UI.

#### 🛠️ Creating from Explore vs LookML

- **From Explore (UI-based)**:
  - Most common method
  - Create a visualization → click “Save to Dashboard”
  - Allows drag-and-drop editing of tiles
  - Saved in the Looker front-end (not part of Git versioning)

- **From LookML**:
  - Hand-coded `.dashboard.lookml` files
  - Covered separately in section 4

#### 🎛️ Dashboard-Level Filters

- Filters can be added to a dashboard to apply globally across multiple tiles
- Fields used in filters must exist in all tiles where the filter is applied
- You can set default values and allow user input

Example use cases:
- `date` filter affecting all charts  
- `region` filter syncing across multiple visualizations

#### 🧱 Layout Options (Tiles, Spacing)

- Tiles = individual visualizations on the dashboard
- You can adjust:
  - Width / height
  - Spacing between tiles
  - Order of appearance (drag to rearrange)
- Text tiles can be added for titles, sections, and instructions

📌 Notes:
- You can schedule dashboards for email delivery (PDF, CSV)
- Dashboards can be shared with groups or embedded externally
- Good layout = fewer tiles, clear labels, grouped metrics

## 4. LookML Dashboards (Optional)

LookML dashboards are defined as code using `.dashboard.lookml` files — giving you version control, reusability, and programmatic flexibility.

#### 🧱 Syntax: `dashboard:` and `element:` blocks

Basic structure:

`dashboard: user_summary {`  
`  title: "User Summary Dashboard"`  
`  filters: [ ... ]`  
`  elements: [ ... ]`  
`}`

Inside the dashboard block:
- `filter:` defines global filters
- `element:` defines each chart/tile
- You can reference saved Looks, inline queries, or explores

Example element:

`element: total_users_tile {`  
`  type: single_value`  
`  query: {`  
`    model: ecommerce`  
`    explore: users`  
`    fields: [users.total_users]`  
`  }`  
`}`

#### 📊 Static vs Dynamic Dashboards

- **Static**: Hardcoded dashboards with predefined tiles and filters
- **Dynamic**: Can include templated filters, variables, and links that change based on user inputs or URL params

You can use Liquid variables to customize behavior dynamically.

#### 🤔 When to Use LookML Over UI

Use LookML dashboards when:
- You need **Git version control**
- Dashboards are part of a **deployment pipeline**
- You want to **reuse tiles** across models/environments
- You need **complex filtering or dynamic linking**
- You're building for **embedded analytics**

📌 Notes:
- LookML dashboards are managed in Git and require deploy to update
- They support Markdown, text blocks, and layout customization via code

## 5. Drill Fields & Interactions

Drill behavior lets users **click into a value on a chart** and either:
- See a deeper breakdown (e.g., transactions behind total sales)
- Navigate to another Explore or dashboard
- Jump to an external tool (e.g., Salesforce, internal URL)

#### 🧠 How to Define Drill Behavior

Drills are defined at the **dimension or measure level** in the view file.

Example:

`dimension: user_id {`  
`  type: number`  
`  sql: ${TABLE}.user_id ;;`  
`  drill_fields: [orders.order_id, orders.order_amount]`  
`}`

This means clicking a user_id will show a table of related order IDs and amounts.

#### 🔗 Linking to Explores or Dashboards

Instead of showing fields, you can link to another Explore or dashboard.

Example:

`link: {`  
`  label: "View User Details"`  
`  url: "/explore/ecommerce/users?fields=users.id,users.email&user_id={{ value }}"`  
`}`

You can also link to LookML dashboards using:

`url: "/dashboards/user_summary_dashboard?user_id={{ value }}"`

#### 🌍 Jump-to-URL or Deep Links

Use `link:` blocks with `url:` and Liquid templating (`{{ value }}`) to:
- Jump to 3rd-party tools (e.g., Zendesk, Amplitude, Jira)
- Pass parameters dynamically
- Embed values in external systems

#### 📌 Notes
- `drill_fields:` = in-app table of details  
- `link:` = navigation to another page or tool  
- Drills enhance interactivity without cluttering the main tile
