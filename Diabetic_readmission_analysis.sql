
SELECT  *
FROM
 `diabetic-healthcare.Diabetic_healthercare.diabetic` LIMIT 10


-- counts how many rows we have

SELECT
count(*)
from 
`diabetic-healthcare.Diabetic_healthercare.diabetic`;







-- check how many duplicates we have
SELECT
  SUM(count_of_rows) - COUNT(DISTINCT all_columns_hash) AS count_of_duplicate_rows
FROM (
  SELECT
    FARM_FINGERPRINT(TO_JSON_STRING(t)) AS all_columns_hash,
    COUNT(*) AS count_of_rows
  FROM
    `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic` AS t
  GROUP BY
    all_columns_hash )
WHERE
  count_of_rows > 1;






-- update dataset

UPDATE
  `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
SET
  race = NULLIF(race, '?'),
  weight = NULLIF(weight, '?'),
  payer_code = NULLIF(payer_code, '?'),
  medical_specialty = NULLIF(medical_specialty, '?'),
  diag_1 = NULLIF(diag_1, '?'),
  diag_2 = NULLIF(diag_2, '?')
WHERE
  race = '?'
  OR weight = '?'
  OR payer_code = '?'
  OR medical_specialty = '?'
  OR diag_1 = '?'
  OR diag_2 = '?';




-- we want to know that how much missing data we are daeling with

SELECT
  ROUND(SUM(weight IS NULL) / COUNT(*) * 100, 2) AS weight_missing_percentage,
  ROUND(sum(payer_code is null)/count(*)*100,2) as payer_code_missing_percentage,
  ROUND(sum(medical_specialty is null)/count(*)*100,2) as medical_specialty_missing_percentage,
FROM
  `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`;





-- now we are handling duplicates patient encounterss
select
patient_nbr,
count(*)as encounter_count
from
`diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
group by
patient_nbr
having count(*)>1
order by
encounter_count desc;





-- We wanna find every unique patiant and their earliest encounter
select patient_nbr,
encounter_id,
min(encounter_id) as first_encounter
from
`diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
group by
patient_nbr




-- Rank the age groups from highest to lowest readmission rate (window function).
SELECT
    age AS age_group,
    COUNT(*) AS encounters,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct,
    RANK() OVER (ORDER BY COUNTIF(readmitted = '<30') / COUNT(*) DESC) AS risk_rank
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY age
ORDER BY risk_rank;




-- Do longer stays lead to more readmissions? One row per number of days (1 to 14).
SELECT
    time_in_hospital AS days_in_hospital,
    COUNT(*) AS encounters,
    COUNTIF(readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY time_in_hospital
ORDER BY time_in_hospital;
 
 
-- Do patients who were admitted before come back more often? (prior inpatient visits)
--     Groups under 50 visits are hidden.
SELECT
    number_inpatient AS prior_inpatient_visits,
    COUNT(*) AS encounters,
    COUNTIF(readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY number_inpatient
HAVING COUNT(*) >= 50
ORDER BY number_inpatient;
 
 
-- Top 10 specialties by readmission rate. Only specialties with 200+ visits,
--     and rows with a missing specialty ('?') are left out.
SELECT
    medical_specialty,
    COUNT(*) AS encounters,
    COUNTIF(readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
WHERE medical_specialty <> '?'
GROUP BY medical_specialty
HAVING COUNT(*) >= 200
ORDER BY readmission_rate_pct DESC
LIMIT 10;
 
 
-- Insulin (No / Steady / Up / Down) vs readmission rate.
SELECT
    insulin,
    COUNT(*) AS encounters,
    COUNTIF(readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY insulin
ORDER BY readmission_rate_pct DESC;



--Readmission rate by where the patient went after discharge (uses the lookup table).
--     Groups under 100 visits are hidden.
SELECT
    m.description AS discharge_destination,
    COUNT(*) AS encounters,
    COUNTIF(d.readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(d.readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM
  `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic` AS d
JOIN
  `diabetic-healthcare`.`Diabetic_healthercare`.`ids_mapping` AS m;
    ON d.discharge_disposition_id = m.discharge_disposition_id
GROUP BY m.description
HAVING COUNT(*) >= 100
ORDER BY readmission_rate_pct DESC;




-- Rank the age groups from highest to lowest readmission rate (window function).
SELECT
    age AS age_group,
    COUNT(*) AS encounters,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct,
    RANK() OVER (ORDER BY COUNTIF(readmitted = '<30') / COUNT(*) DESC) AS risk_rank
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY age
ORDER BY risk_rank;



-- Readmission rate by age group.
SELECT
    age AS age_group,
    COUNT(*) AS encounters,
    COUNTIF(readmitted = '<30') AS readmitted_within_30d,
    ROUND(100 * COUNTIF(readmitted = '<30') / COUNT(*), 2) AS readmission_rate_pct
FROM `diabetic-healthcare`.`Diabetic_healthercare`.`diabetic`
GROUP BY age































