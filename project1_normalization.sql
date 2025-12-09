SET statement_timeout = '10min'; -- Prevents postgres from timing out

CREATE TABLE Agencies (
    agency_code INTEGER PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_abbr TEXT NOT NULL
);

CREATE TABLE LoanTypes (
    loan_type INTEGER PRIMARY KEY,
    loan_type_name TEXT NOT NULL
);

CREATE TABLE PropertyTypes (
    property_type INTEGER PRIMARY KEY,
    property_type_name TEXT NOT NULL
);

CREATE TABLE LoanPurposes (
    loan_purpose INTEGER PRIMARY KEY,
    loan_purpose_name TEXT NOT NULL
);

CREATE TABLE OwnerOccupancies (
    owner_occupancy INTEGER PRIMARY KEY,
    owner_occupancy_name TEXT NOT NULL
);

CREATE TABLE Preapprovals (
    preapproval INTEGER PRIMARY KEY,
    preapproval_name TEXT NOT NULL
);

CREATE TABLE ActionsTaken (
    action_taken INTEGER PRIMARY KEY,
    action_taken_name TEXT NOT NULL
);

CREATE TABLE MSAMD (
    msamd INTEGER PRIMARY KEY,
    msamd_name TEXT NOT NULL
);

CREATE TABLE States (
    state_code INTEGER PRIMARY KEY,
    state_name TEXT NOT NULL,
    state_abbr TEXT NOT NULL
);

CREATE TABLE Counties (
    state_code INTEGER,
    county_code INTEGER,
    county_name TEXT NOT NULL,
    PRIMARY KEY (state_code, county_code),
    FOREIGN KEY (state_code) REFERENCES States(state_code)
);

CREATE TABLE Tracts (
    state_code INTEGER,
    county_code INTEGER,
    census_tract_number NUMERIC,
    population INTEGER,
    minority_population NUMERIC,
    hud_median_family_income INTEGER,
    tract_to_msamd_income NUMERIC,
    number_of_owner_occupied_units INTEGER,
    number_of_1_to_4_family_units INTEGER,
    PRIMARY KEY (state_code, county_code, census_tract_number),
    FOREIGN KEY (state_code, county_code) REFERENCES Counties(state_code, county_code)
);

CREATE TABLE Ethnicities (
    ethnicity_code INTEGER PRIMARY KEY,
    ethnicity_name TEXT NOT NULL
);

CREATE TABLE Races (
    race_code INTEGER PRIMARY KEY,
    race_name TEXT NOT NULL
);

CREATE TABLE Sexes (
    sex_code INTEGER PRIMARY KEY,
    sex_name TEXT NOT NULL
);

CREATE TABLE PurchaserTypes (
    purchaser_type INTEGER PRIMARY KEY,
    purchaser_type_name TEXT NOT NULL
);

CREATE TABLE DenialReasons (
    denial_reason INTEGER PRIMARY KEY,
    denial_reason_name TEXT NOT NULL
);

CREATE TABLE HOEPAStatuses (
    hoepa_status INTEGER PRIMARY KEY,
    hoepa_status_name TEXT NOT NULL
);

CREATE TABLE LienStatuses (
    lien_status INTEGER PRIMARY KEY,
    lien_status_name TEXT NOT NULL
);

CREATE TABLE EditStatuses (
    edit_status INTEGER PRIMARY KEY,
    edit_status_name TEXT NOT NULL
);

CREATE TABLE Respondents (
    respondent_id TEXT PRIMARY KEY,
    agency_code INTEGER,
    FOREIGN KEY (agency_code) REFERENCES Agencies(agency_code)
);

CREATE TABLE Applications (
    id INTEGER PRIMARY KEY,
    as_of_year INTEGER NOT NULL,
    respondent_id TEXT NOT NULL,
    loan_type INTEGER NOT NULL,
    property_type INTEGER NOT NULL,
    loan_purpose INTEGER NOT NULL,
    owner_occupancy INTEGER NOT NULL,
    loan_amount_000s INTEGER,
    preapproval INTEGER NOT NULL,
    action_taken INTEGER NOT NULL,
    msamd INTEGER,
    state_code INTEGER,
    county_code INTEGER,
    census_tract_number NUMERIC,
    applicant_ethnicity INTEGER NOT NULL,
    co_applicant_ethnicity INTEGER NOT NULL,
    applicant_race_1 INTEGER NOT NULL,
    applicant_race_2 INTEGER,
    applicant_race_3 INTEGER,
    applicant_race_4 INTEGER,
    applicant_race_5 INTEGER,
    co_applicant_race_1 INTEGER NOT NULL,
    co_applicant_race_2 INTEGER,
    co_applicant_race_3 INTEGER,
    co_applicant_race_4 INTEGER,
    co_applicant_race_5 INTEGER,
    applicant_sex INTEGER NOT NULL,
    co_applicant_sex INTEGER NOT NULL,
    applicant_income_000s INTEGER,
    purchaser_type INTEGER NOT NULL,
    denial_reason_1 INTEGER,
    denial_reason_2 INTEGER,
    denial_reason_3 INTEGER,
    rate_spread NUMERIC,
    hoepa_status INTEGER NOT NULL,
    lien_status INTEGER NOT NULL,
    edit_status INTEGER,
    sequence_number INTEGER, 
    application_date_indicator INTEGER,
    
    FOREIGN KEY (loan_type) REFERENCES LoanTypes(loan_type),
    FOREIGN KEY (respondent_id) REFERENCES Respondents(respondent_id),
    FOREIGN KEY (property_type) REFERENCES PropertyTypes(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES LoanPurposes(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES OwnerOccupancies(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES Preapprovals(preapproval),
    FOREIGN KEY (action_taken) REFERENCES ActionsTaken(action_taken),
    FOREIGN KEY (msamd) REFERENCES MSAMD(msamd),
    FOREIGN KEY (state_code, county_code, census_tract_number) REFERENCES Tracts(state_code, county_code, census_tract_number),
    FOREIGN KEY (state_code) REFERENCES States(state_code),
    FOREIGN KEY (state_code, county_code) REFERENCES Counties(state_code, county_code),
    FOREIGN KEY (applicant_ethnicity) REFERENCES Ethnicities(ethnicity_code),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES Ethnicities(ethnicity_code),
    FOREIGN KEY (applicant_race_1) REFERENCES Races(race_code),
    FOREIGN KEY (applicant_race_2) REFERENCES Races(race_code),
    FOREIGN KEY (applicant_race_3) REFERENCES Races(race_code),
    FOREIGN KEY (applicant_race_4) REFERENCES Races(race_code),
    FOREIGN KEY (applicant_race_5) REFERENCES Races(race_code),
    FOREIGN KEY (co_applicant_race_1) REFERENCES Races(race_code),
    FOREIGN KEY (co_applicant_race_2) REFERENCES Races(race_code),
    FOREIGN KEY (co_applicant_race_3) REFERENCES Races(race_code),
    FOREIGN KEY (co_applicant_race_4) REFERENCES Races(race_code),
    FOREIGN KEY (co_applicant_race_5) REFERENCES Races(race_code),
    FOREIGN KEY (applicant_sex) REFERENCES Sexes(sex_code),
    FOREIGN KEY (co_applicant_sex) REFERENCES Sexes(sex_code),
    FOREIGN KEY (purchaser_type) REFERENCES PurchaserTypes(purchaser_type),
    FOREIGN KEY (denial_reason_1) REFERENCES DenialReasons(denial_reason),
    FOREIGN KEY (denial_reason_2) REFERENCES DenialReasons(denial_reason),
    FOREIGN KEY (denial_reason_3) REFERENCES DenialReasons(denial_reason),
    FOREIGN KEY (hoepa_status) REFERENCES HOEPAStatuses(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES LienStatuses(lien_status),
    FOREIGN KEY (edit_status) REFERENCES EditStatuses(edit_status)
);

INSERT INTO Agencies (agency_code, agency_name, agency_abbr) VALUES
(1, 'Office of the Comptroller of the Currency (OCC)', 'OCC'),
(2, 'Federal Reserve System (FRS)', 'FRS'),
(3, 'Federal Deposit Insurance Corporation (FDIC)', 'FDIC'),
(5, 'National Credit Union Administration (NCUA)', 'NCUA'),
(7, 'Department of Housing and Urban Development (HUD)', 'HUD'),
(9, 'Consumer Financial Protection Bureau (CFPB)', 'CFPB');

INSERT INTO LoanTypes (loan_type, loan_type_name) VALUES
(1, 'Conventional (any loan other than FHA, VA, or FSA)'),
(2, 'FHA-insured (Federal Housing Administration)'),
(3, 'VA-guaranteed (Department of Veterans Affairs)'),
(4, 'FSA/RHS-guaranteed (Farm Service Agency/Rural Housing Service)');

INSERT INTO PropertyTypes (property_type, property_type_name) VALUES
(1, 'One-to-four family (other than manufactured housing)'),
(2, 'Manufactured housing'),
(3, 'Multifamily (5 or more dwellings)');

INSERT INTO LoanPurposes (loan_purpose, loan_purpose_name) VALUES
(1, 'Home purchase'),
(2, 'Home improvement'),
(3, 'Refinancing');

INSERT INTO OwnerOccupancies (owner_occupancy, owner_occupancy_name) VALUES
(1, 'Owner-occupied as a principal dwelling'),
(2, 'Not owner-occupied'),
(3, 'Not applicable');

INSERT INTO Preapprovals (preapproval, preapproval_name) VALUES
(1, 'Preapproval request was denied'),
(2, 'Preapproval request was approved but not accepted'),
(3, 'No preapproval request');

INSERT INTO ActionsTaken (action_taken, action_taken_name) VALUES
(1, 'Loan originated'),
(2, 'Application approved but not accepted'),
(3, 'Application denied by financial institution'),
(4, 'Application withdrawn by applicant'),
(5, 'File closed for incompleteness'),
(6, 'Loan purchased by the institution'),
(7, 'Preapproval request denied'),
(8, 'Preapproval request approved but not accepted');

-- Handling missing MSAMD names by assigning a placeholder name
INSERT INTO MSAMD (msamd, msamd_name)
SELECT 
    CAST(msamd AS INTEGER),
    CASE
        WHEN msamd_name = '' THEN 'Code ' || msamd || ' (Name Missing)'
        ELSE msamd_name
    END
FROM Preliminary
WHERE msamd != ''
GROUP BY msamd, msamd_name;

-- Got these codes from: https://transition.fcc.gov/oet/info/maps/census/fips/fips.txt
INSERT INTO States (state_code, state_name, state_abbr) VALUES
(1, 'Alabama', 'AL'), 
(2, 'Alaska', 'AK'), 
(4, 'Arizona', 'AZ'), 
(5, 'Arkansas', 'AR'),
(6, 'California', 'CA'), 
(8, 'Colorado', 'CO'), 
(9, 'Connecticut', 'CT'), 
(10, 'Delaware', 'DE'),
(11, 'District of Columbia', 'DC'), 
(12, 'Florida', 'FL'), 
(13, 'Georgia', 'GA'), 
(15, 'Hawaii', 'HI'),
(16, 'Idaho', 'ID'), 
(17, 'Illinois', 'IL'), 
(18, 'Indiana', 'IN'), 
(19, 'Iowa', 'IA'),
(20, 'Kansas', 'KS'), 
(21, 'Kentucky', 'KY'), 
(22, 'Louisiana', 'LA'), 
(23, 'Maine', 'ME'),
(24, 'Maryland', 'MD'), 
(25, 'Massachusetts', 'MA'), 
(26, 'Michigan', 'MI'), 
(27, 'Minnesota', 'MN'),
(28, 'Mississippi', 'MS'), 
(29, 'Missouri', 'MO'), 
(30, 'Montana', 'MT'), 
(31, 'Nebraska', 'NE'),
(32, 'Nevada', 'NV'), 
(33, 'New Hampshire', 'NH'), 
(34, 'New Jersey', 'NJ'),
(35, 'New Mexico', 'NM'),
(36, 'New York', 'NY'), 
(37, 'North Carolina', 'NC'), 
(38, 'North Dakota', 'ND'), 
(39, 'Ohio', 'OH'),
(40, 'Oklahoma', 'OK'), 
(41, 'Oregon', 'OR'), 
(42, 'Pennsylvania', 'PA'), 
(44, 'Rhode Island', 'RI'),
(45, 'South Carolina', 'SC'), 
(46, 'South Dakota', 'SD'), 
(47, 'Tennessee', 'TN'),
(48, 'Texas', 'TX'),
(49, 'Utah', 'UT'), 
(50, 'Vermont', 'VT'), 
(51, 'Virginia', 'VA'), 
(53, 'Washington', 'WA'),
(54, 'West Virginia', 'WV'), 
(55, 'Wisconsin', 'WI'), 
(56, 'Wyoming', 'WY'), 
(60, 'American Samoa', 'AS'),
(66, 'Guam', 'GU'), 
(69, 'Northern Mariana Islands', 'MP'), 
(72, 'Puerto Rico', 'PR'), 
(78, 'U.S. Virgin Islands', 'VI');

INSERT INTO Counties (state_code, county_code, county_name)
SELECT 
    CAST(state_code AS INTEGER),
    CAST(county_code AS INTEGER),
    county_name
FROM Preliminary
WHERE state_code != '' AND county_code != '' AND county_name != ''
GROUP BY state_code, county_code, county_name;

-- Used a CASE WHEN to convert empty strings to NULL before casting to NUMERIC/INTEGER since empty strings cannot be converted directly into these
INSERT INTO Tracts (state_code, county_code, census_tract_number, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units)
SELECT 
    CAST(state_code AS INTEGER), 
    CAST(county_code AS INTEGER), 
    CASE WHEN census_tract_number = '' THEN NULL ELSE CAST(census_tract_number AS NUMERIC) END, 
    CASE WHEN population = '' THEN NULL ELSE CAST(population AS INTEGER) END, 
    CASE WHEN minority_population = '' THEN NULL ELSE CAST(minority_population AS NUMERIC) END, 
    CASE WHEN hud_median_family_income = '' THEN NULL ELSE CAST(hud_median_family_income AS INTEGER) END, 
    CASE WHEN tract_to_msamd_income = '' THEN NULL ELSE CAST(tract_to_msamd_income AS NUMERIC) END, 
    CASE WHEN number_of_owner_occupied_units = '' THEN NULL ELSE CAST(number_of_owner_occupied_units AS INTEGER) END, 
    CASE WHEN number_of_1_to_4_family_units = '' THEN NULL ELSE CAST(number_of_1_to_4_family_units AS INTEGER) END
FROM Preliminary
WHERE state_code != '' AND county_code != '' AND census_tract_number != ''
GROUP BY state_code, county_code, census_tract_number, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units;

-- Added placeholders code 5 and code 9 for undocumented ethnicity codes in the source csv
INSERT INTO Ethnicities (ethnicity_code, ethnicity_name) VALUES
(1, 'Hispanic or Latino'), 
(2, 'Not Hispanic or Latino'), 
(3, 'Information not provided by applicant in mail, Internet, or telephone application'), 
(4, 'Not applicable'), 
(5, 'Code 5 (Undocumented)'), 
(9, 'No co-applicant');

INSERT INTO Races (race_code, race_name) VALUES
(1, 'American Indian or Alaska Native'), 
(2, 'Asian'), 
(3, 'Black or African American'), 
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White'), 
(6, 'Information not provided by applicant in mail, Internet, or telephone application'), 
(7, 'Not applicable'), 
(8, 'No co-applicant');

-- Added a placeholder code 5 for undocumented sex codes in the source data
INSERT INTO Sexes (sex_code, sex_name) VALUES
(1, 'Male'), 
(2, 'Female'), 
(3, 'Information not provided by applicant in mail, Internet, or telephone application'), 
(4, 'Not applicable'),
(5, 'Code 5 (Undocumented)'), 
(9, 'No co-applicant');

INSERT INTO PurchaserTypes (purchaser_type, purchaser_type_name) VALUES
(0, 'Not Applicable'), (1, 'Fannie Mae'), (2, 'Ginnie Mae'), (3, 'Freddie Mac'), (4, 'Federal agency or instrumentality other than Fannie Mae, Ginnie Mae, or Freddie Mac'),
(5, 'Commercial bank, savings bank, or savings association'), (6, 'Mortgage company, broker, or correspondent'), (7, 'Affiliate institution'),
(8, 'Other type of purchaser'), (9, 'Not applicable');

-- Added in a placeholder code 9 for undocumented denial reason codes
INSERT INTO DenialReasons (denial_reason, denial_reason_name) VALUES
(1, 'Debt-to-income ratio'), 
(2, 'Employment history'), 
(3, 'Credit history'), 
(4, 'Collateral (such as the property appraised value)'),
(5, 'Insufficient cash (down payment, closing costs)'), 
(6, 'Unverifiable information'), 
(7, 'Credit application incomplete'), 
(8, 'Other'),
(9, 'Code 9 (Undocumented)');

INSERT INTO HOEPAStatuses (hoepa_status, hoepa_status_name) VALUES
(1, 'High-cost mortgage'), (2, 'Not a high-cost mortgage');

-- Added a placeholder code 4, for undocumented lien status codes
INSERT INTO LienStatuses (lien_status, lien_status_name) VALUES
(1, 'First lien'), 
(2, 'Subordinate lien'), 
(3, 'Not applicable'),
(4, 'Code 4 (Undocumented)'); 

INSERT INTO EditStatuses (edit_status, edit_status_name) VALUES
(1, 'Passed edit'), (2, 'Failed edit');

INSERT INTO Respondents (respondent_id, agency_code)
SELECT 
    respondent_id, 
    MAX(CAST(agency_code AS INTEGER)) 
FROM Preliminary
WHERE respondent_id != '' AND agency_code != ''
GROUP BY respondent_id; 

-- The entire SELECT block below uses CASE WHEN to check for empty strings ('') in optional fields like msamd, loan_amount_000s, rate_spread, ...
-- and converts them to NULL. This prevents casting errors and makes sure that the Foreign Key constraints are satisfied for the nullable columns
INSERT INTO Applications (id, as_of_year, respondent_id, loan_type, property_type, loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken, msamd, state_code, county_code, census_tract_number, applicant_ethnicity, co_applicant_ethnicity, applicant_race_1, applicant_race_2, applicant_race_3, applicant_race_4, applicant_race_5, co_applicant_race_1, co_applicant_race_2, co_applicant_race_3, co_applicant_race_4, co_applicant_race_5, applicant_sex, co_applicant_sex, applicant_income_000s, purchaser_type, denial_reason_1, denial_reason_2, denial_reason_3, rate_spread, hoepa_status, lien_status, edit_status, sequence_number, application_date_indicator)
SELECT 
    id, 
    CASE WHEN as_of_year = '' THEN NULL ELSE CAST(as_of_year AS INTEGER) END, 
    respondent_id, 
    CASE WHEN loan_type = '' THEN NULL ELSE CAST(loan_type AS INTEGER) END, 
    CASE WHEN property_type = '' THEN NULL ELSE CAST(property_type AS INTEGER) END, 
    CASE WHEN loan_purpose = '' THEN NULL ELSE CAST(loan_purpose AS INTEGER) END, 
    CASE WHEN owner_occupancy = '' THEN NULL ELSE CAST(owner_occupancy AS INTEGER) END, 
    CASE WHEN loan_amount_000s = '' THEN NULL ELSE CAST(loan_amount_000s AS INTEGER) END, 
    CASE WHEN preapproval = '' THEN NULL ELSE CAST(preapproval AS INTEGER) END, 
    CASE WHEN action_taken = '' THEN NULL ELSE CAST(action_taken AS INTEGER) END, 
    CASE WHEN msamd = '' THEN NULL ELSE CAST(msamd AS INTEGER) END, 
    CASE WHEN state_code = '' THEN NULL ELSE CAST(state_code AS INTEGER) END, 
    CASE WHEN county_code = '' THEN NULL ELSE CAST(county_code AS INTEGER) END, 
    CASE WHEN census_tract_number = '' THEN NULL ELSE CAST(census_tract_number AS NUMERIC) END, 
    CASE WHEN applicant_ethnicity = '' THEN NULL ELSE CAST(applicant_ethnicity AS INTEGER) END, 
    CASE WHEN co_applicant_ethnicity = '' THEN NULL ELSE CAST(co_applicant_ethnicity AS INTEGER) END, 
    CASE WHEN applicant_race_1 = '' THEN NULL ELSE CAST(applicant_race_1 AS INTEGER) END, 
    CASE WHEN applicant_race_2 = '' THEN NULL ELSE CAST(applicant_race_2 AS INTEGER) END, 
    CASE WHEN applicant_race_3 = '' THEN NULL ELSE CAST(applicant_race_3 AS INTEGER) END, 
    CASE WHEN applicant_race_4 = '' THEN NULL ELSE CAST(applicant_race_4 AS INTEGER) END, 
    CASE WHEN applicant_race_5 = '' THEN NULL ELSE CAST(applicant_race_5 AS INTEGER) END, 
    CASE WHEN co_applicant_race_1 = '' THEN NULL ELSE CAST(co_applicant_race_1 AS INTEGER) END, 
    CASE WHEN co_applicant_race_2 = '' THEN NULL ELSE CAST(co_applicant_race_2 AS INTEGER) END, 
    CASE WHEN co_applicant_race_3 = '' THEN NULL ELSE CAST(co_applicant_race_3 AS INTEGER) END, 
    CASE WHEN co_applicant_race_4 = '' THEN NULL ELSE CAST(co_applicant_race_4 AS INTEGER) END, 
    CASE WHEN co_applicant_race_5 = '' THEN NULL ELSE CAST(co_applicant_race_5 AS INTEGER) END, 
    CASE WHEN applicant_sex = '' THEN NULL ELSE CAST(applicant_sex AS INTEGER) END, 
    CASE WHEN co_applicant_sex = '' THEN NULL ELSE CAST(co_applicant_sex AS INTEGER) END, 
    CASE WHEN applicant_income_000s = '' THEN NULL ELSE CAST(applicant_income_000s AS INTEGER) END, 
    CASE WHEN purchaser_type = '' THEN NULL ELSE CAST(purchaser_type AS INTEGER) END, 
    CASE WHEN denial_reason_1 = '' THEN NULL ELSE CAST(denial_reason_1 AS INTEGER) END, 
    CASE WHEN denial_reason_2 = '' THEN NULL ELSE CAST(denial_reason_2 AS INTEGER) END, 
    CASE WHEN denial_reason_3 = '' THEN NULL ELSE CAST(denial_reason_3 AS INTEGER) END, 
    CASE WHEN rate_spread = '' THEN NULL ELSE CAST(rate_spread AS NUMERIC) END, 
    CASE WHEN hoepa_status = '' THEN NULL ELSE CAST(hoepa_status AS INTEGER) END, 
    CASE WHEN lien_status = '' THEN NULL ELSE CAST(lien_status AS INTEGER) END, 
    CASE WHEN edit_status = '' THEN NULL ELSE CAST(edit_status AS INTEGER) END, 
    CASE WHEN sequence_number = '' THEN NULL ELSE CAST(sequence_number AS INTEGER) END, 
    CASE WHEN application_date_indicator = '' THEN NULL ELSE CAST(application_date_indicator AS INTEGER) END
FROM Preliminary
WHERE as_of_year != '' 
    AND respondent_id != '' 
    AND loan_type != '' 
    AND property_type != '' 
    AND loan_purpose != '' 
    AND owner_occupancy != '' 
    AND preapproval != '' 
    AND action_taken != '' 
    AND applicant_ethnicity != '' 
    AND co_applicant_ethnicity != '' 
    AND applicant_race_1 != '' 
    AND co_applicant_race_1 != '' 
    AND applicant_sex != '' 
    AND co_applicant_sex != '' 
    AND purchaser_type != '' 
    AND hoepa_status != '' 
    AND lien_status != '' 
ORDER BY id;

-- Code Sources:
-- Postgres Docs
--  - Conditional Functions: https://www.postgresql.org/docs/current/functions-conditional.html
--  - Casting data types: https://www.postgresql.org/docs/current/sql-createcast.html
--  - Inserting Data: https://www.postgresql.org/docs/current/dml-insert.html