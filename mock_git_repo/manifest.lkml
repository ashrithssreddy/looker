project_name: "ecommerce_analytics"

include: "/views/*.view.lkml"
include: "/explores/*.explore.lkml"
include: "/dashboards/*.dashboard.lookml"
include: "/sets/*.view.lkml"

# Optional extensions (if you're using custom visualizations or Looker extensions)
# Uncomment if needed
# application: {
#   file: "extension-dashboard/manifest.json"
#   label: "Ecommerce Dashboard Extension"
#   url: "https://your-extension-url.com"
# }

# Optionally declare constants, reusable value lists, etc.
# constants: {
#   region_list: ["US", "CA", "EU"]
# }

# Optional default localizations
# localization_settings: {
#   default_locale: "en"
# }

# Optional default settings for Liquid variables, timezone, etc.
# default_connection: "analytics_db"
