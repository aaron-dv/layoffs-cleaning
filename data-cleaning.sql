-- STAGES:

-- 1. Deduplication
-- 2. Standardisation
-- 3. Handling Null Values
-- 4. Column Removal

-- Data Overview

SELECT *
FROM layoffs;

--
-- 1. Deduplication
--

-- Create staging table

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- Identify duplicates

WITH RowNumber_CTE AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country) AS row_num
	FROM layoffs_staging
)
SELECT *
FROM RowNumber_CTE
WHERE row_num > 1;

-- Create secondary staging table
CREATE TABLE `layoffs_staging_2` (
  `company` varchar(50) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `total_laid_off` varchar(50) DEFAULT NULL,
  `percentage_laid_off` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `funds_raised_millions` varchar(50) DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging_2;

-- Delete duplicates
SELECT *
FROM layoffs_staging_2
WHERE row_num > 1;

DELETE
FROM layoffs_staging_2
WHERE row_num > 1;

--
-- 2. Standardisation
--

-- Standardise null values
SELECT *
FROM layoffs_staging_2
WHERE TRIM(industry) = ''
OR industry = 'NULL';

UPDATE layoffs_staging_2
SET industry = NULL
WHERE TRIM(industry) = ''
OR industry = 'NULL';

-- Trim 'company' column values

SELECT company, TRIM(company)
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET company = TRIM(company);

-- Standardise 'industry' column values

SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

SELECT *
FROM layoffs_staging_2
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

-- Standardise 'country' column values

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET country = 'United States'
WHERE country LIKE '%United States%';

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;

-- Reformat 'date' column & change to datatype to DATE

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') as dt
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

--
-- 3. Handling Null Values
--

-- Handling 'industry' column null values
SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL;

SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

--
-- 4. Row & Column Removal
--

-- Remove rows with null values for 'total_laid_off' and 'percentage_laid_off'

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Drop redundant 'row_num' column

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging_2;
