dashboard: ecommerce_summary {
  title: "Ecommerce Summary"
  layout: auto

  filter: signup_month {
    type: date
    default_value: "30 days"
    field: users.signup_date
  }

  filter: region {
    type: string
    field: users.region
  }

  element: total_revenue_tile {
    type: single_value
    title: "Total Revenue (Last 30 Days)"
    query: {
      model: main
      explore: ecommerce
      fields: [orders.total_revenue]
      filters: [users.signup_date: "{{ signup_month }}"]
    }
  }

  element: user_count_tile {
    type: single_value
    title: "Total Users"
    query: {
      model: main
      explore: ecommerce
      fields: [users.total_users]
      filters: [users.region: "{{ region }}"]
    }
  }

  element: revenue_trend_tile {
    type: line
    title: "Revenue Over Time"
    query: {
      model: main
      explore: ecommerce
      fields: [orders.order_date_month, orders.total_revenue]
      filters: [users.region: "{{ region }}"]
    }
  }
}
