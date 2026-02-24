-- Data cleaning

-- 1. Removing duplicate
-- 2. Standardizing data
-- 3. Null or blank values
-- 4. Removing rows or columns that are not relevant


-- Removing duplicate
SELECT *
FROM layoffs;

SELECT *, ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

WITH CTE AS (
SELECT *, ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs)
SELECT *
FROM CTE
WHERE row_num > 1;

-- Start by creating a duplicate working table called layoffs_staging in order to preserve original data set
CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging
SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

-- 1. Removing duplicate
SELECT *
FROM layoffs_staging
WHERE row_num > 1;

DELETE FROM layoffs_staging
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE row_num > 1;


-- 2. Standardizing data

UPDATE layoffs_staging
SET
company = TRIM(company),
location = TRIM(location),
industry = trim(industry),
total_laid_off = trim(total_laid_off),
percentage_laid_off = trim(percentage_laid_off),
`date` = trim(`date`),
stage = trim(stage),
country = trim(country),
funds_raised_millions = trim(funds_raised_millions),
row_num = trim(row_num);

-- checking each column for data that should be matched for consistency
SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY industry;

UPDATE layoffs_staging
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT industry
FROM layoffs_staging;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging;

SELECT DISTINCT stage
FROM layoffs_staging
ORDER BY stage;

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY country;

UPDATE layoffs_staging
SET country = 'United States'
WHERE country LIKE 'United States%';

-- 3. Null or blank values
SELECT *
FROM layoffs_staging
WHERE (total_laid_off IS NULL OR total_laid_off = ' ') AND (percentage_laid_off IS NULL OR percentage_laid_off = ' ');

DELETE FROM layoffs_staging
WHERE (total_laid_off IS NULL OR total_laid_off = ' ') AND (percentage_laid_off IS NULL OR percentage_laid_off = ' ');

-- 4. Removing rows or columns that are not relevant
ALTER TABLE layoffs_staging
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging;