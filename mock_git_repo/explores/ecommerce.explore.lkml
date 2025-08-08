explore: ecommerce {
  from: orders

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.user_id} ;;
    relationship: many_to_one
    fields: [user_core_fields]  # ⬅️ From sets, Optional
  }

  join: products {
    type: left_outer
    sql_on: ${orders.product_id} = ${products.product_id} ;;
    relationship: many_to_one
  }

  always_filter: {
    filters: [orders.status: "completed"]
  }

  access_filter: {
    field: users.region
    user_attribute: user_region
  }
}
