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
- Creating from Explore vs LookML
- Dashboard-level filters
- Layout options (tiles, spacing)

## 4. LookML Dashboards (Optional)
- Syntax: `dashboard:` and `element:` blocks
- Static vs dynamic dashboards
- When to use LookML over UI

## 5. Drill Fields & Interactions
- How to define drill behavior
- Linking to Explores or other dashboards
- Jump-to-URL or deep links
Visualizations supported