# sql-layoffs-data-cleaning
End-to-end SQL data cleaning workflow applied to a real-world layoffs dataset.


# 📊 SQL Data Cleaning Project: Layoffs Dataset

## 📌 Project Overview
This project demonstrates comprehensive data cleaning techniques on a real-world layoffs dataset using SQL. I followed along with [Alex The Analyst's MySQL Data Cleaning Tutorial](https://www.youtube.com/watch?v=4UltKCnnnTA&list=PLUaB-1hjhk8FE_XZ87vPPSfHqb6OcM0cF) to learn and apply industry-standard data cleaning practices. The objective was to transform raw, inconsistent data into a clean, analysis-ready format through duplicate removal, data standardization, handling missing values, and ensuring proper data types.

## 📂 Dataset Information
* **Source**: [Alex The Analyst - MySQL Series](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series)
* **Description**: Tech industry layoffs data containing information about companies, locations, industries, and layoff statistics
* **Original Columns**: 
  - `company` - Company name
  - `location` - City/location of layoffs
  - `industry` - Industry sector
  - `total_laid_off` - Number of employees laid off
  - `percentage_laid_off` - Percentage of workforce affected
  - `date` - Date of layoffs
  - `stage` - Company funding stage
  - `country` - Country where layoffs occurred
  - `funds_raised_millions` - Total funds raised by company

## 🛠️ Tools & Technologies
* **Database**: MySQL
* **SQL Techniques**: 
  - Common Table Expressions (CTEs)
  - Window Functions (`ROW_NUMBER()`, `PARTITION BY`)
  - Self-Joins
  - Data Type Conversions
  - String Manipulation Functions

## 🧹 Data Cleaning Process

### 1. **Created Staging Table**
To preserve the integrity of raw data, a staging table was created where all transformations were performed. This follows the best practice of never modifying original data directly.

```sql
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
```

### 2. **Removed Duplicate Records**
Used `ROW_NUMBER()` window function with `PARTITION BY` across all columns to identify duplicate entries, then created a secondary staging table to permanently remove them.

**Key Technique**: Added a `row_num` column to flag duplicates, then deleted all records where `row_num > 1`.

### 3. **Standardized Data**
* **Trimmed whitespace** from company names using `TRIM()`
* **Normalized industry values** - Consolidated variations like "Crypto Currency", "CryptoCurrency" into "Crypto"
* **Cleaned country names** - Removed trailing periods (e.g., "United States." → "United States")
* **Converted date format** - Transformed text dates to proper `DATE` data type using `STR_TO_DATE()`

### 4. **Handled Missing Values**
* **Removed unusable records** - Deleted rows where both `total_laid_off` AND `percentage_laid_off` were NULL 
* **Converted empty strings to NULL** - Standardized missing data representation
* **Populated missing industries** - Used self-joins to fill in missing industry values based on matching company names

```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
```

### 5. **Final Cleanup**
Removed helper columns (`row_num`) that were only needed during the cleaning process, leaving a streamlined, production-ready dataset.

## ✅ Results & Outcome
A clean, consistent, and analysis-ready dataset with:
- ✓ No duplicate records
- ✓ Standardized formatting across all text fields
- ✓ Proper data types for all columns
- ✓ Missing data handled appropriately
- ✓ Only meaningful records retained

## 💡 Key SQL Skills Demonstrated
* Creating and managing staging tables
* Advanced duplicate detection using window functions
* Data standardization and normalization techniques
* Strategic NULL handling and data population
* Self-joins for data enrichment
* Data type conversions and formatting
* Following SQL best practices and safe update procedures

## 🚀 How to Run
1. Download the raw `layoffs.csv` dataset from the source repository
2. Import the dataset into MySQL as the `layoffs` table
3. Execute the `data_cleaning.sql` script
4. The cleaned data will be available in the `layoffs_staging2` table

## 📈 Next Steps
This cleaned dataset is now ready for:
* **Exploratory Data Analysis (EDA)** - Uncovering trends and patterns
* **Statistical Analysis** - Analyzing layoff trends by industry, country, and time period
* **Data Visualization** - Creating dashboards in Tableau, Power BI, or Python
* **Predictive Modeling** - Building models to forecast future trends



## 🎯 Learning Outcomes
This project strengthened my skills in:
- Writing complex SQL queries for real-world data problems
- Implementing data quality assurance procedures
- Following industry best practices for data cleaning
- Preparing datasets for downstream analysis and reporting

---

**Author**: Saniya Khan  
**Date**: December 2024  
**Tutorial Credit**: [Alex The Analyst - Data Cleaning in MySQL](https://www.youtube.com/watch?v=4UltKCnnnTA&list=PLUaB-1hjhk8FE_XZ87vPPSfHqb6OcM0cF)  
**Purpose**: Data Analysis Learning & Portfolio Project
