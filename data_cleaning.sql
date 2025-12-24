SELECT * FROM layoffs;
-- 1. remove duplicates
-- 2. standardize data
-- 3. handle nulls or missing values
-- 4. remove any coloumns that aren't needed

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- why we did this?
-- we should not work on the raw data directly, not the best practice

-- 1. checking for duplicates

WITH duplicate_cte AS (SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging)
 
SELECT * FROM duplicate_cte
WHERE row_num>1;

-- checking if the result is correct.(checking with the company oda, row_num =2)

-- SELECT * FROM layoffs WHERE company='Oda';
-- figured out that we have to partition by every column

-- deleting the duplicates




SELECT * FROM layoffs_staging2;

DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT  -- ← Changed to row_num
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO  layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

 -- deleting duplicates
 
 SET SQL_SAFE_UPDATES = 0;
 
DELETE
FROM layoffs_staging2 
WHERE row_num>1;

SELECT * FROM layoffs_staging2 
WHERE row_num>1;

SET SQL_SAFE_UPDATES = 1;


SELECT * FROM layoffs_staging2 ;

-- 2. STANDARDIZING DATA (Finding issues in data and fixing it)
SELECT company, TRIM(company)
FROM layoffs_staging2;

 SET SQL_SAFE_UPDATES = 0;
 
 UPDATE layoffs_staging2
 SET  company= TRIM(company);
 
 SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

-- checking each col
 SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country= TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT * FROM layoffs_staging2 ;

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y ')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y ');


SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

-- 3. HANDLING NULLS 

SELECT * FROM layoffs_staging2
where total_laid_off IS NULL 
and percentage_laid_off IS NULL ; 

-- where both of these cols are null then they are pretty useless.
 SET SQL_SAFE_UPDATES = 0;
 
UPDATE layoffs_staging2
SET industry= NULL
WHERE industry='';

SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL 
OR industry = '';

-- we will try to populate the data
SELECT *
FROM layoffs_staging2 
WHERE company LIKE 'Bally%'; 

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE  
 layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

DELETE FROM layoffs_staging2
where total_laid_off IS NULL 
and percentage_laid_off IS NULL ; 

-- chceking 
SELECT * FROM layoffs_staging2
where total_laid_off IS NULL 
and percentage_laid_off IS NULL ; 

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



