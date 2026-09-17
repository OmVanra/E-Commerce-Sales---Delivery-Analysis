# 🛒 E-Commerce SQL Analysis

## 📌 Project Overview

**E-Commerce SQL Analysis** is a data analytics project built using **Google BigQuery SQL** to analyze e-commerce orders, customers, payments, freight costs, and delivery performance.

The project focuses on extracting business insights from transactional data and answering real-world business questions related to **sales trends, customer distribution, payment behavior, logistics, and order economics**.

---

## 🎯 Business Objective

Assuming the role of a **Data Analyst at Target**, the objective is to analyze e-commerce data and provide insights that can support business and operational decisions.

The analysis covers:

* Order growth and monthly trends
* Customer distribution across states
* Customer ordering behavior by time of day
* Order value and freight analysis
* Delivery time and delivery performance
* Payment methods and installments
* Year-over-year economic impact

---

## 🗂️ Dataset

The analysis uses multiple related tables:

| Table         | Description                                         |
| ------------- | --------------------------------------------------- |
| `customers`   | Customer information and location                   |
| `orders`      | Order details, timestamps, and delivery information |
| `order_items` | Product prices and freight values                   |
| `payments`    | Payment methods, values, and installments           |
| `geoloaction` | Geographic/location information                     |

---

## 🔍 Analysis Performed

### 📈 Order & Customer Analysis

* Explored dataset structure and characteristics
* Analyzed order date range
* Examined monthly and yearly order trends
* Analyzed customer distribution across Brazilian states
* Identified customer ordering patterns by time of day

### 💰 Economic & Sales Analysis

* Calculated year-over-year increase in payment value
* Analyzed total and average order price by state
* Analyzed total and average freight value by state

### 🚚 Delivery Analysis

* Calculated delivery time for individual orders
* Compared actual vs estimated delivery dates
* Identified states with the highest and lowest average delivery time
* Identified states with faster delivery compared with estimated dates
* Identified states with highest and lowest average freight values

### 💳 Payment Analysis

* Analyzed monthly orders by payment type
* Analyzed orders by number of payment installments

---

## 🛠️ Tools & Technologies

**Google BigQuery | SQL | Data Analysis | Exploratory Data Analysis | CTEs | JOINs | Window Functions | CASE Statements | Date Functions | Aggregations**

### SQL Concepts Used

* `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
* `JOIN`
* `DISTINCT`
* Aggregate Functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
* `CASE WHEN`
* `EXTRACT`
* `DATE_DIFF`
* `LAG()`
* CTEs (`WITH`)
* `SAFE_DIVIDE`
* `ROUND`
* Filtering and sorting

---

## 📊 Key Business Questions

The project answers questions such as:

* Is the number of orders growing over time?
* Which months show higher order activity?
* When do customers place most of their orders?
* How are customers distributed across states?
* How has order payment value changed between 2017 and 2018?
* Which states have the highest and lowest freight costs?
* Which states have the fastest and slowest delivery times?
* How does actual delivery compare with estimated delivery?
* Which payment methods are most frequently used?
* How many orders are placed using different installment plans?

---

## 🚀 Project Workflow

**Data Exploration → Data Cleaning & Understanding → SQL Analysis → KPI Calculation → Trend Analysis → Business Insights**

---

## 👨‍💻 Author

**Om Vanra**
Aspiring Data Analyst

**Skills:** SQL | Google BigQuery | Power BI | Python | Excel | Data Analysis

🔗 LinkedIn: [linkedin.com/in/om-vanra-033b14291](https://www.linkedin.com/in/om-vanra-033b14291/)
🔗 GitHub: [github.com/OmVanra](https://github.com/OmVanra)
