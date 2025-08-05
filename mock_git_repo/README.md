# 🛍️ Ecommerce Looker Project

This Looker project models a foundational ecommerce domain with key entities: **users**, **orders**, and **products**.

The project supports reporting and analytics use cases such as:

- Revenue trends over time
- Conversion funnel by signup cohort
- Product category performance
- Repeat vs new customer behavior
- Regional breakdowns by customer or order volume

It defines clean explores with well-scoped dimensions and measures, and supports joins between orders, users, and product metadata.

The codebase is structured using best practices:
- Modular views and explores
- Centralized model file
- Git version control
- Reusable field sets and calculated fields

> ⚠️ This project assumes an existing warehouse with cleanly modeled tables: `analytics.orders`, `analytics.users`, and `analytics.products`. It is designed for internal use and team collaboration within a Git-backed Looker deployment.
