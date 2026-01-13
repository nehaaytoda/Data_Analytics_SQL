## Data Analytics Layer

This phase is executed after the successful implementation of the [**Data Warehouse architecture**](https://github.com/nehaaytoda/Data-Warehouse_SQL), where data is ingested and transformed across three layers: **Bronze**, **Silver**, and **Gold**.

* **Bronze Layer**: Raw, ingested source data with minimal transformation
* **Silver Layer**: Cleansed, standardized, and conformed data
* **Gold Layer**: Business-ready, aggregated data exposed through **analytical views**

All analytical queries and reports are built exclusively on **Gold-layer views** to ensure consistency, performance, and semantic correctness.

## Analytics Framework

The analytics workflow is divided into **two major analytical segments**:

## 1. Exploratory Data Analysis (EDA)

EDA is performed to validate data quality, understand dimensional models, and identify analytical patterns prior to advanced computations.

#### 1.1 Database Exploration

* Schema inspection and metadata validation
* Table/view row counts and data volume analysis
* Primary key and foreign key relationship validation

#### 1.2 Dimension Exploration

* Analysis of core dimensions (e.g., Customer, Product, Time, Geography)
* Cardinality checks and uniqueness validation
* Detection of slowly changing dimension (SCD) behavior

#### 1.3 Date Range Exploration

* Validation of available historical time ranges
* Identification of missing or incomplete date intervals
* Time grain verification (daily, monthly, yearly)

#### 1.4 Measure Exploration

* Validation of fact table measures (e.g., revenue, quantity, cost)
* Null, zero, and outlier detection
* Measure aggregation behavior (additive, semi-additive, non-additive)

#### 1.5 Magnitude Analysis

* High-level aggregation analysis (totals, averages, distributions)
* Volume comparison across dimensions and time periods

#### 1.6 Ranking Analysis

* Ranking of entities using window functions
* Top-N / Bottom-N analysis for customers, products, and categories

## 2. Advanced Analytics

Advanced analytical techniques are applied to derive actionable business insights using SQL analytical functions.

#### 2.1 Change-over-Time Trend Analysis

* Period-over-period (MoM, QoQ, YoY) comparisons
* Trend identification and seasonality detection

#### 2.2 Cumulative Analysis

* Running totals and rolling aggregates
* Long-term growth and progression analysis

#### 2.3 Performance Analysis

* KPI evaluation against benchmarks or targets
* Variance and percentage difference calculations

#### 2.4 Part-to-Whole Analysis

* Contribution analysis using ratios and percentages
* Category and segment contribution to total performance

#### 2.5 Data Segmentation Analysis

* Customer and product segmentation based on behavioral metrics
* Clustering logic using rule-based thresholds

## Reporting Layer

These reports consolidate key metrics and behaviors for both customers and products, enabling informed decision-making and performance tracking.

### Customer Report

**Purpose**

The Customer Report provides a consolidated analytical view of customer behavior and performance, enabling evaluation of purchase patterns, revenue contribution, and engagement over time..

It captures core attributes such as:

* Customer name
* Age
* Transaction details

Customers are segmented into **VIP**, **Regular**, and **New**, and also grouped by age ranges. The report tracks total orders, total sales, quantity purchased, number of distinct products purchased, and customer lifespan.

**Analytical Value:**
This view supports understanding purchasing patterns, revenue contribution, and lifecycle trends, enabling targeted marketing, loyalty programs, and retention strategies.


### Product Report

**Purpose**

The Product Report provides a consolidated analytical view of product-level performance and behavior, enabling evaluation of revenue contribution, sales efficiency, and lifecycle characteristics.

It consolidates attributes including:

* Product name
* Category and subcategory
* Product cost

Products are segmented by revenue into **High-Performers**, **Mid-Range**, and **Low-Performers**, with metrics tracked for total orders, total sales, quantity sold, number of unique customers, and product lifespan.

**Analytical Value:**
This view enables evaluation of product performance, portfolio optimization, and identification of products driving or lagging business performance.

