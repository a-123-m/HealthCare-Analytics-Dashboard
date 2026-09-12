-- Create tables to import data

DROP TABLE IF EXISTS dim_date CASCADE;
CREATE TABLE dim_date (
    date_id       INTEGER,
    full_date     DATE         NOT NULL,            
    day           SMALLINT     NOT NULL CHECK (day BETWEEN 1 AND 31),
    month         SMALLINT     NOT NULL CHECK (month BETWEEN 1 AND 12),
    month_name    VARCHAR(9)   NOT NULL,
    quarter       VARCHAR(2)   NOT NULL,             
    year          SMALLINT     NOT NULL,
    day_of_week   VARCHAR(9)   NOT NULL,
    is_weekend    BOOLEAN      NOT NULL,
    fiscal_year   VARCHAR(6)   NOT NULL              
);

DROP TABLE IF EXISTS dim_disease CASCADE;
CREATE TABLE dim_disease (
    disease_id          VARCHAR(6)   ,    -- e.g. DIS039
    disease_name        VARCHAR(60)  NOT NULL,
    disease_category    VARCHAR(30)  NOT NULL,
    icd10_code          VARCHAR(10)  NOT NULL,
    chronic_flag        BOOLEAN      NOT NULL,        -- Yes/No in source
    transmission_type   VARCHAR(20)  NOT NULL,
    severity_level      VARCHAR(20)  NOT NULL,
    avg_recovery_days   SMALLINT     NOT NULL
);

DROP TABLE IF EXISTS dim_hospital CASCADE;
CREATE TABLE dim_hospital (
    hospital_id            VARCHAR(7) ,  -- e.g. HOS0064
    hospital_name          VARCHAR(60)  NOT NULL,
    hospital_type          VARCHAR(30)  NOT NULL,
    ownership_type         VARCHAR(30)  NOT NULL,
    city                   VARCHAR(30)  NOT NULL,
    state                  CHAR(2)      NOT NULL,
    bed_capacity           SMALLINT,                  
    accreditation_status   VARCHAR(20)  NOT NULL,
    established_year       SMALLINT     NOT NULL
);

DROP TABLE IF EXISTS dim_location CASCADE;
CREATE TABLE dim_location (
    location_id                    VARCHAR(7),  -- e.g. LOC0069
    city                           VARCHAR(30)  NOT NULL,
    state                          CHAR(2)      NOT NULL,
    region                         VARCHAR(15)  NOT NULL,
    country                        VARCHAR(5)   NOT NULL,
    zip_code                       VARCHAR(10),              
    population_density_per_sqkm    NUMERIC(10,2)  
);

DROP TABLE IF EXISTS dim_patient CASCADE;
CREATE TABLE dim_patient (
    patient_id       VARCHAR(9) ,       -- e.g. PAT016319
    first_name       VARCHAR(30)  NOT NULL,
    last_name        VARCHAR(30)  NOT NULL,
    gender           VARCHAR(10)  NOT NULL,
    date_of_birth    DATE,                            
    age              SMALLINT     NOT NULL,
    blood_group      VARCHAR(20)   NOT NULL,
    ethnicity        VARCHAR(30)  NOT NULL,
    marital_status   VARCHAR(15)  NOT NULL,
    occupation       VARCHAR(30)  NOT NULL,
    insurance_type   VARCHAR(25)  NOT NULL,
    smoking_status   VARCHAR(20)  NOT NULL,
    income_bracket   VARCHAR(20)                      -- e.g. "$25,000-$49,999"
);

DROP TABLE IF EXISTS fact_disease_incident CASCADE;
CREATE TABLE fact_disease_incident (
    incident_id                    VARCHAR(10)  , -- e.g. INC0254876
    date_id                        INTEGER       NOT NULL,
    patient_id                     VARCHAR(15)    NOT NULL ,
    disease_id                     VARCHAR(15)    NOT NULL,
    location_id                    VARCHAR(15)    NOT NULL,
    hospital_id                    VARCHAR(15)    NOT NULL ,
    admission_type                 VARCHAR(15),
    length_of_stay_days            SMALLINT ,
    treatment_cost_usd             NUMERIC(10,2),
    insurance_claim_amount_usd     NUMERIC(10,2),
    outcome                        VARCHAR(50) ,
    follow_up_required             VARCHAR(20),     
    readmission_flag               VARCHAR(20),     
    symptom_severity_score         SMALLINT
);

-- Check count of rows and columns
select 'fact_disease_incident' as table_name, COUNT(*) as total_rows from fact_disease_incident
UNION ALL
select 'dim_patient' as table_name, COUNT(*) as total_rows from dim_patient
UNION ALL
select 'dim_location' as table_name, COUNT(*) as total_rows from dim_location
UNION ALL
select 'dim_hospital' as table_name, COUNT(*) as total_rows from dim_hospital
UNION ALL
select 'dim_disease' as table_name, COUNT(*) as total_rows from dim_disease
UNION ALL
select 'dim_date' as table_name, COUNT(*) as total_rows from dim_date

select COUNT(*) from information_schema.columns WHERE table_name = 'dim_date';
select COUNT(*) from information_schema.columns WHERE table_name = 'dim_disease';
select COUNT(*) from information_schema.columns WHERE table_name = 'dim_hospital';
select COUNT(*) from information_schema.columns WHERE table_name = 'dim_location';
select COUNT(*) from information_schema.columns WHERE table_name = 'dim_patient';
select COUNT(*) from information_schema.columns WHERE table_name = 'fact_disease_incident';

select * from fact_disease_incident;
select * from dim_patient;
select * from dim_location;
select * from dim_hospital;
select * from dim_disease;
select * from dim_date;


-- Feature Engineering
select MIN(age) as min_age,MAX(age) as max_age from dim_patient;
ALTER TABLE dim_patient ADD COLUMN age_group VARCHAR(50);

UPDATE dim_patient SET age_group =
CASE
	WHEN age < 18 THEN 'Child'
	WHEN age BETWEEN 18 and 39 THEN 'Young Adult'
	WHEN age BETWEEN 40 and 59 THEN 'Middle Age'
	WHEN age >= 60 THEN 'Senior'
	ELSE 'Unknown'
END;

select age_group, COUNT(*) from dim_patient GROUP BY age_group;

select * from dim_patient;

ALTER table dim_patient ADD COLUMN patient_name TEXT;

select first_name, last_name ,CONCAT(first_name,' ',last_name) as full_name from dim_patient;
UPDATE dim_patient set patient_name = CONCAT(first_name,' ',last_name);
select first_name, last_name, patient_name from dim_patient;

select * from dim_disease;
select * from dim_hospital;
select * from dim_location;
select * from dim_date;
select * from fact_disease_incident;

select MIN(length_of_stay_days),MAX(length_of_stay_days) from fact_disease_incident;
ALTER TABLE fact_disease_incident ADD COLUMN stay_status TEXT;

UPDATE fact_disease_incident SET stay_status =
CASE
	WHEN length_of_stay_days BETWEEN 0 AND 3 THEN 'Short Stay'
	WHEN length_of_stay_days BETWEEN 4 AND 7 THEN 'Medium Stay'
	WHEN length_of_stay_days BETWEEN 8 AND 14 THEN 'Long Stay'
	WHEN length_of_stay_days BETWEEN 15 AND 30 THEN 'Extended Stay'
	ELSE 'Unknown'
END;

select length_of_stay_days, stay_status from fact_disease_incident;

/*
select * from dim_disease;
select * from dim_hospital;
select * from dim_location;
select * from dim_date;
select * from dim_patient;
select * from fact_disease_incident;
*/

-- Create analytical views
CREATE VIEW healthcare_analysis_view AS
SELECT
    -- Fact
    f.incident_id,
    f.date_id,
    f.patient_id,
    f.disease_id,
    f.location_id,
    f.hospital_id,
    f.admission_type,
    f.length_of_stay_days,
    f.stay_status,
    f.treatment_cost_usd,
    f.insurance_claim_amount_usd,
    f.outcome,
    f.follow_up_required,
    f.readmission_flag,
    f.symptom_severity_score,

    -- Date
    d.full_date,
    d.day,
    d.day_of_week,
    d."month" as month_no,
    d.month_name,
    d.year,

    -- Patient
    p.patient_name,
    p.gender,
    p.age,
    p.age_group,
    p.blood_group,
    p.ethnicity,
    p.marital_status,
    p.occupation,
    p.insurance_type,
    p.smoking_status,
    p.income_bracket,

    -- Disease
    dis.disease_name,
    dis.disease_category,
    dis.chronic_flag,
	dis.transmission_type,
	dis.severity_level,
    dis.avg_recovery_days,

    -- Location
    l.city AS location_city,
    l.state AS location_state,
    l.region,
    l.population_density_per_sqkm,

    -- Hospital
    h.hospital_name,
    h.hospital_type,
    h.ownership_type,
    h.city AS hospital_city,
    h.state AS hospital_state,
    h.bed_capacity

FROM fact_disease_incident f

LEFT JOIN dim_date d
    ON f.date_id = d.date_id

LEFT JOIN dim_patient p
    ON f.patient_id = p.patient_id

LEFT JOIN dim_disease dis
    ON f.disease_id = dis.disease_id

LEFT JOIN dim_location l
    ON f.location_id = l.location_id

LEFT JOIN dim_hospital h
    ON f.hospital_id = h.hospital_id;

select COUNT(*) from healthcare_analysis_view;

-- Export the final analytical table to system as a csv file
COPY (
    SELECT *
    FROM healthcare_analysis_view
)
TO 'C:/temp/final.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE
);