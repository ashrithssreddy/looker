view: users {
  sql_table_name: analytics.users ;;

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: signup_date {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.signup_timestamp ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  measure: total_users {
    type: count
  }
}
