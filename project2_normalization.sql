SET statement_timeout = '10min'; -- Prevents postgres from timing out

CREATE TABLE Locations (
    location_id SERIAL PRIMARY KEY,
    state_code INTEGER,
    county_code INTEGER,
    census_tract_number NUMERIC,
    msamd INTEGER,
    population INTEGER,
    minority_population NUMERIC,
    hud_median_family_income INTEGER,
    tract_to_msamd_income NUMERIC,
    number_of_owner_occupied_units INTEGER,
    number_of_1_to_4_family_units INTEGER,
    FOREIGN KEY (state_code) REFERENCES States(state_code),
    FOREIGN KEY (state_code, county_code) REFERENCES Counties(state_code, county_code),
    FOREIGN KEY (msamd) REFERENCES MSAMD(msamd)
);

CREATE TEMP TABLE temp_locations AS
SELECT DISTINCT 
    a.state_code,
    a.county_code,
    a.census_tract_number,
    a.msamd,
    t.population,
    t.minority_population,
    t.hud_median_family_income,
    t.tract_to_msamd_income,
    t.number_of_owner_occupied_units,
    t.number_of_1_to_4_family_units
FROM Applications a
LEFT JOIN Tracts t ON (
    a.state_code = t.state_code AND 
    a.county_code = t.county_code AND 
    a.census_tract_number = t.census_tract_number
);

INSERT INTO Locations (state_code, county_code, census_tract_number, msamd, 
                       population, minority_population, hud_median_family_income,
                       tract_to_msamd_income, number_of_owner_occupied_units,
                       number_of_1_to_4_family_units)
SELECT * FROM temp_locations
ORDER BY state_code, county_code, census_tract_number, msamd;

CREATE TABLE Applications_3NF (
    application_id INTEGER PRIMARY KEY,
    as_of_year INTEGER NOT NULL,
    respondent_id TEXT NOT NULL,
    loan_type INTEGER NOT NULL,
    property_type INTEGER NOT NULL,
    loan_purpose INTEGER NOT NULL,
    owner_occupancy INTEGER NOT NULL,
    loan_amount_000s INTEGER,
    preapproval INTEGER NOT NULL,
    action_taken INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    applicant_ethnicity INTEGER NOT NULL,
    co_applicant_ethnicity INTEGER NOT NULL,
    applicant_sex INTEGER NOT NULL,
    co_applicant_sex INTEGER NOT NULL,
    applicant_income_000s INTEGER,
    purchaser_type INTEGER NOT NULL,
    rate_spread NUMERIC,
    hoepa_status INTEGER NOT NULL,
    lien_status INTEGER NOT NULL,
    edit_status INTEGER,
    sequence_number INTEGER,
    application_date_indicator INTEGER,
    FOREIGN KEY (respondent_id) REFERENCES Respondents(respondent_id),
    FOREIGN KEY (loan_type) REFERENCES LoanTypes(loan_type),
    FOREIGN KEY (property_type) REFERENCES PropertyTypes(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES LoanPurposes(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES OwnerOccupancies(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES Preapprovals(preapproval),
    FOREIGN KEY (action_taken) REFERENCES ActionsTaken(action_taken),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (applicant_ethnicity) REFERENCES Ethnicities(ethnicity_code),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES Ethnicities(ethnicity_code),
    FOREIGN KEY (applicant_sex) REFERENCES Sexes(sex_code),
    FOREIGN KEY (co_applicant_sex) REFERENCES Sexes(sex_code),
    FOREIGN KEY (purchaser_type) REFERENCES PurchaserTypes(purchaser_type),
    FOREIGN KEY (hoepa_status) REFERENCES HOEPAStatuses(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES LienStatuses(lien_status),
    FOREIGN KEY (edit_status) REFERENCES EditStatuses(edit_status)
);

INSERT INTO Applications_3NF (
    application_id, as_of_year, respondent_id, loan_type, property_type,
    loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken,
    location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex,
    co_applicant_sex, applicant_income_000s, purchaser_type, rate_spread,
    hoepa_status, lien_status, edit_status, sequence_number, application_date_indicator
)
SELECT 
    a.id,
    a.as_of_year,
    a.respondent_id,
    a.loan_type,
    a.property_type,
    a.loan_purpose,
    a.owner_occupancy,
    a.loan_amount_000s,
    a.preapproval,
    a.action_taken,
    l.location_id,
    a.applicant_ethnicity,
    a.co_applicant_ethnicity,
    a.applicant_sex,
    a.co_applicant_sex,
    a.applicant_income_000s,
    a.purchaser_type,
    a.rate_spread,
    a.hoepa_status,
    a.lien_status,
    a.edit_status,
    a.sequence_number,
    a.application_date_indicator
FROM Applications a
JOIN Locations l ON (
    (a.state_code = l.state_code OR (a.state_code IS NULL AND l.state_code IS NULL)) AND
    (a.county_code = l.county_code OR (a.county_code IS NULL AND l.county_code IS NULL)) AND
    (a.census_tract_number = l.census_tract_number OR (a.census_tract_number IS NULL AND l.census_tract_number IS NULL)) AND
    (a.msamd = l.msamd OR (a.msamd IS NULL AND l.msamd IS NULL))
);



CREATE TABLE ApplicationRaces (
    application_id INTEGER NOT NULL,
    race_code INTEGER NOT NULL,
    race_number INTEGER NOT NULL,
    applicant_type CHAR(1) NOT NULL,
    PRIMARY KEY (application_id, race_number, applicant_type),
    FOREIGN KEY (application_id) REFERENCES Applications_3NF(application_id),
    FOREIGN KEY (race_code) REFERENCES Races(race_code),
    CHECK (applicant_type IN ('A', 'C')),
    CHECK (race_number BETWEEN 1 AND 5)
);

INSERT INTO ApplicationRaces (application_id, race_code, race_number, applicant_type)
SELECT id, applicant_race_1, 1, 'A' FROM Applications WHERE applicant_race_1 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, applicant_race_2, 2, 'A' FROM Applications WHERE applicant_race_2 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, applicant_race_3, 3, 'A' FROM Applications WHERE applicant_race_3 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, applicant_race_4, 4, 'A' FROM Applications WHERE applicant_race_4 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, applicant_race_5, 5, 'A' FROM Applications WHERE applicant_race_5 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, co_applicant_race_1, 1, 'C' FROM Applications WHERE co_applicant_race_1 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, co_applicant_race_2, 2, 'C' FROM Applications WHERE co_applicant_race_2 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, co_applicant_race_3, 3, 'C' FROM Applications WHERE co_applicant_race_3 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, co_applicant_race_4, 4, 'C' FROM Applications WHERE co_applicant_race_4 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, co_applicant_race_5, 5, 'C' FROM Applications WHERE co_applicant_race_5 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF);

CREATE TABLE ApplicationDenialReasons (
    application_id INTEGER NOT NULL,
    denial_reason INTEGER NOT NULL,
    reason_number INTEGER NOT NULL,
    PRIMARY KEY (application_id, reason_number),
    FOREIGN KEY (application_id) REFERENCES Applications_3NF(application_id),
    FOREIGN KEY (denial_reason) REFERENCES DenialReasons(denial_reason),
    CHECK (reason_number BETWEEN 1 AND 3)
);

INSERT INTO ApplicationDenialReasons (application_id, denial_reason, reason_number)
SELECT id, denial_reason_1, 1 FROM Applications WHERE denial_reason_1 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, denial_reason_2, 2 FROM Applications WHERE denial_reason_2 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF)
UNION ALL
SELECT id, denial_reason_3, 3 FROM Applications WHERE denial_reason_3 IS NOT NULL AND id IN (SELECT application_id FROM Applications_3NF);

DROP TABLE Applications CASCADE;
DROP TABLE Tracts CASCADE;

ALTER TABLE Applications_3NF RENAME TO Applications;

CREATE INDEX idx_applications_respondent ON Applications(respondent_id);
CREATE INDEX idx_applications_location ON Applications(location_id);
CREATE INDEX idx_applicationraces_app ON ApplicationRaces(application_id);
CREATE INDEX idx_applicationraces_race ON ApplicationRaces(race_code);
CREATE INDEX idx_denialreasons_app ON ApplicationDenialReasons(application_id);
CREATE INDEX idx_locations_composite ON Locations(state_code, county_code, census_tract_number);

-- Code Sources:
-- Postgres Docs
--  - CREATE TABLE: https://www.postgresql.org/docs/current/sql-createtable.html
--  - Temporary Tables: https://www.postgresql.org/docs/current/sql-createtable.html#SQL-CREATETABLE-TEMPORARY
--  - SERIAL data type: https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-SERIAL
--  - Foreign Keys: https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-FK
--  - CHECK Constraints: https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-CHECK-CONSTRAINTS
--  - CREATE INDEX: https://www.postgresql.org/docs/current/sql-createindex.html
--  - DROP TABLE CASCADE: https://www.postgresql.org/docs/current/sql-droptable.html
--  - ALTER TABLE RENAME: https://www.postgresql.org/docs/current/sql-altertable.html