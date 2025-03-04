# Layoffs Data Cleaning

#### SQL Data Cleaning & Transformation

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
- [Next Steps](#next-steps)
- [References](#references)

---

## Project Overview

This project focuses on cleaning and preparing a dataset related to layoffs in various companies. The goal is to perform data cleaning tasks such as deduplication, standardisation, handling null values, and removing unnecessary columns and rows. These steps are essential to make the data consistent, usable, and ready for further analysis or reporting.

---

### Data Sources

The primary dataset used for this analysis is the 'Layoffs Dataset', found on Kaggle - accessible [here](https://www.kaggle.com/datasets/swaptr/layoffs-2022).

---

### Tools

- **MySQL**
    - Data Cleaning
    - Data Transformation
- **DBeaver**

---

### Data Cleaning

In the data preparation & cleaning phase, we performed the following tasks:

1. **Deduplication:**
   - Created a staging table to copy the original data for manipulation.
   - Identified duplicates based on key columns (`company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, and `country`).
   - Removed duplicate records by utilising a window function to assign a row number for each group of potential duplicates and then deleting rows with a row number greater than 1.

2. **Standardisation:**
   - Replaced blank or invalid values in the `industry` column with `NULL`.
   - Trimmed whitespace from the `company` column to standardise values.
   - Standardised values in the `industry` and `country` columns.
   - Reformatted the `date` column into a standardized `DATE` datatype.

3. **Handling Null Values:**
   - Handled missing values in the `industry` column by replacing them with values from other records with matching `company` and `location` information.

4. **Row & Column Removal:**
   - Removed redundant columns such as `row_num` used for deduplication purposes.
   - Removed rows with `NULL` values in critical fields like `total_laid_off` and `percentage_laid_off`.

---

### Next Steps

Based on the results of the data cleaning process, we could recommend the following actions:

- **Further Analysis:** With the cleaned dataset, further exploratory data analysis (EDA) can be conducted to find insights like trends in layoffs across industries and regions.
- **Data Archiving:** Store cleaned datasets in a centralised location for easy access and sharing within others.

---

### References

1. [Data Cleaning in SQL](https://www.youtube.com/watch?v=4UltKCnnnTA) - Alex The Analyst
