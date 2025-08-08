view: shared_fields {
  set: user_core_fields {
    fields: [
      users.user_id,
      users.email,
      users.signup_date,
      users.region
    ]
  }

  set: order_metrics {
    fields: [
      orders.order_id,
      orders.order_date,
      orders.total_orders,
      orders.total_revenue
    ]
  }
}
