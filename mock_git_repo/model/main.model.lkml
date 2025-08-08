connection: ecommerce_db

include: "/views/*.view.lkml"
include: "/explores/*.explore.lkml"

explore: ecommerce {
  from: ecommerce
}

# Optional: Datagroup for PDT caching
datagroup: daily_refresh {
  max_cache_age: "24 hours"
}
