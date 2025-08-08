view: orders {
  sql_table_name: analytics.orders ;;

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: order_date {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.order_ts ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.order_status ;;
  }

  measure: total_orders {
    type: count
  }

  measure: total_revenue {
    type: sum
    sql: ${TABLE}.order_amount ;;
    value_format_name: usd
  }
}
