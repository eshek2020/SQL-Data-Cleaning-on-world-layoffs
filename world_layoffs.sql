
-- 1. Remove duplicates
-- 2. Standardise the data sets
-- 3. Null or blank values
-- 4. Remove rows or columns that are not relevant



SELECT *
FROM layoffs;

CREATE TABLE layoffs_2
LIKE layoffs;

SELECT *
FROM layoffs_2;

INSERT INTO  layoffs_2
SELECT * FROM layoffs;