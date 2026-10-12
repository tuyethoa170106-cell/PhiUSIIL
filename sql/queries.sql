-- Step 3: sql/queries.sql
CREATE OR REPLACE TABLE ph AS SELECT * FROM 'data/processed/phishing.parquet';
-- Q1: the two classes side by side
SELECT phishing, COUNT(*) AS addresses, AVG(URLLength) AS mean_length, 100.0 * AVG(IsHTTPS) AS https_pct, 100.0 * AVG(starts_https_www) AS starts_https_www_pct, AVG(NoOfSubDomain) AS subdomains, AVG(URLSimilarityIndex) AS similarity_index,
       100.0 * AVG(HasTitle) AS has_title_pct, AVG(NoOfImage) AS images FROM ph GROUP BY 1 ORDER BY 1;
-- Q2: top-level domains ranked by volume, with their share of phishing
SELECT TLD, COUNT(*) AS addresses, 100.0 * AVG(phishing) AS phishing_pct, RANK() OVER (ORDER BY COUNT(*) DESC) AS rank FROM ph GROUP BY 1 ORDER BY 4 LIMIT 15;
-- Q3: how well the similarity index alone separates the classes (bands of 10 points)
SELECT CAST(FLOOR(URLSimilarityIndex / 10) * 10 AS INT) AS similarity_from, COUNT(*) AS addresses, 100.0 * AVG(phishing) AS phishing_pct,
       100.0 * SUM(COUNT(*)) OVER (ORDER BY CAST(FLOOR(URLSimilarityIndex / 10) * 10 AS INT)) / SUM(COUNT(*)) OVER () AS cumulative_pct FROM ph GROUP BY 1 ORDER BY 1;
-- Q4: model table (numeric features and the keys needed for the splits)
CREATE OR REPLACE TABLE feat AS SELECT * EXCLUDE (URL) FROM ph;
SELECT phishing, COUNT(*) AS n FROM feat GROUP BY 1;
