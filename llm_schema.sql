-- Cleaned llm_schema.sql (Use this to replace your existing file content)

-- NOTE: All table names are now lowercase to match PostgreSQL default behavior
-- and prevent "relation does not exist" errors.

CREATE TABLE agencies (
    agency_code INTEGER PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_abbr TEXT NOT NULL
);

CREATE TABLE loantypes (
    loan_type INTEGER PRIMARY KEY,
    loan_type_name TEXT NOT NULL
);

CREATE TABLE propertytypes (
    property_type INTEGER PRIMARY KEY,
    property_type_name TEXT NOT NULL
);

CREATE TABLE loanpurposes (
    loan_purpose INTEGER PRIMARY KEY,
    loan_purpose_name TEXT NOT NULL
);

CREATE TABLE owneroccupancies (
    owner_occupancy INTEGER PRIMARY KEY,
    owner_occupancy_name TEXT NOT NULL
);

CREATE TABLE preapprovals (
    preapproval INTEGER PRIMARY KEY,
    preapproval_name TEXT NOT NULL
);

CREATE TABLE actionstaken (
    action_taken INTEGER PRIMARY KEY,
    action_taken_name TEXT NOT NULL
);

CREATE TABLE msamd (
    msamd INTEGER PRIMARY KEY,
    msamd_name TEXT NOT NULL
);

CREATE TABLE states (
    state_code INTEGER PRIMARY KEY,
    state_name TEXT NOT NULL,
    state_abbr TEXT NOT NULL
);

CREATE TABLE counties (
    state_code INTEGER,
    county_code INTEGER,
    county_name TEXT NOT NULL,
    PRIMARY KEY (state_code, county_code),
    FOREIGN KEY (state_code) REFERENCES states(state_code)
);

CREATE TABLE tracts (
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
    FOREIGN KEY (state_code, county_code) REFERENCES counties(state_code, county_code)
);

CREATE TABLE ethnicities (
    ethnicity_code INTEGER PRIMARY KEY,
    ethnicity_name TEXT NOT NULL
);

CREATE TABLE races (
    race_code INTEGER PRIMARY KEY,
    race_name TEXT NOT NULL
);

CREATE TABLE sexes (
    sex_code INTEGER PRIMARY KEY,
    sex_name TEXT NOT NULL
);

CREATE TABLE purchasertypes (
    purchaser_type INTEGER PRIMARY KEY,
    purchaser_type_name TEXT NOT NULL
);

CREATE TABLE denialreasons (
    denial_reason INTEGER PRIMARY KEY,
    denial_reason_name TEXT NOT NULL
);

CREATE TABLE hoepastatuses (
    hoepa_status INTEGER PRIMARY KEY,
    hoepa_status_name TEXT NOT NULL
);

CREATE TABLE lienstatuses (
    lien_status INTEGER PRIMARY KEY,
    lien_status_name TEXT NOT NULL
);

CREATE TABLE editstatuses (
    edit_status INTEGER PRIMARY KEY,
    edit_status_name TEXT NOT NULL
);

CREATE TABLE respondents (
    respondent_id TEXT PRIMARY KEY,
    agency_code INTEGER,
    FOREIGN KEY (agency_code) REFERENCES agencies(agency_code)
);

CREATE TABLE locations (
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
    FOREIGN KEY (state_code) REFERENCES states(state_code),
    FOREIGN KEY (state_code, county_code) REFERENCES counties(state_code, county_code),
    FOREIGN KEY (msamd) REFERENCES msamd(msamd)
);

-- THE MAIN APPLICATION DATA TABLE
CREATE TABLE applications (
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
    FOREIGN KEY (respondent_id) REFERENCES respondents(respondent_id),
    FOREIGN KEY (loan_type) REFERENCES loantypes(loan_type),
    FOREIGN KEY (property_type) REFERENCES propertytypes(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES loanpurposes(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES owneroccupancies(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES preapprovals(preapproval),
    FOREIGN KEY (action_taken) REFERENCES actionstaken(action_taken),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (applicant_ethnicity) REFERENCES ethnicities(ethnicity_code),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES ethnicities(ethnicity_code),
    FOREIGN KEY (applicant_sex) REFERENCES sexes(sex_code),
    FOREIGN KEY (co_applicant_sex) REFERENCES sexes(sex_code),
    FOREIGN KEY (purchaser_type) REFERENCES purchasertypes(purchaser_type),
    FOREIGN KEY (hoepa_status) REFERENCES hoepastatuses(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES lienstatuses(lien_status),
    FOREIGN KEY (edit_status) REFERENCES editstatuses(edit_status)
);*/

-- INSERTS (Provide a few key examples for the LLM)

INSERT INTO agencies (agency_code, agency_name, agency_abbr) VALUES
(1, 'Office of the Comptroller of the Currency (OCC)', 'OCC'),
(9, 'Consumer Financial Protection Bureau (CFPB)', 'CFPB');

INSERT INTO loantypes (loan_type, loan_type_name) VALUES
(1, 'Conventional (any loan other than FHA, VA, or FSA)'),
(2, 'FHA-insured (Federal Housing Administration)');

INSERT INTO propertytypes (property_type, property_type_name) VALUES
(1, 'One-to-four family (other than manufactured housing)'),
(3, 'Multifamily (5 or more dwellings)');

INSERT INTO owneroccupancies (owner_occupancy, owner_occupancy_name) VALUES
(1, 'Owner-occupied'),
(2, 'Not owner-occupied');

-- Example data (optional, but highly recommended for context)
INSERT INTO applications (
    application_id, as_of_year, respondent_id, loan_type, property_type,
    loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken,
    location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex,
    co_applicant_sex, applicant_income_000s, purchaser_type, rate_spread,
    hoepa_status, lien_status, edit_status, sequence_number, application_date_indicator
)
VALUES (1, 2024, '0000000001', 1, 1, 1, 1, 150, 1, 1, 1, 1, 2, 3, 3, 50, 1, 0.5, 1, 1, 1, 100, 1);
