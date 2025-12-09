CREATE TABLE Preliminary (
    as_of_year TEXT,
    respondent_id TEXT,
    agency_name TEXT,
    agency_abbr TEXT,
    agency_code TEXT,
    loan_type_name TEXT,
    loan_type TEXT,
    property_type_name TEXT,
    property_type TEXT,
    loan_purpose_name TEXT,
    loan_purpose TEXT,
    owner_occupancy_name TEXT,
    owner_occupancy TEXT,
    loan_amount_000s TEXT,
    preapproval_name TEXT,
    preapproval TEXT,
    action_taken_name TEXT,
    action_taken TEXT,
    msamd_name TEXT,
    msamd TEXT,
    state_name TEXT,
    state_abbr TEXT,
    state_code TEXT,
    county_name TEXT,
    county_code TEXT,
    census_tract_number TEXT,
    applicant_ethnicity_name TEXT,
    applicant_ethnicity TEXT,
    co_applicant_ethnicity_name TEXT,
    co_applicant_ethnicity TEXT,
    applicant_race_name_1 TEXT,
    applicant_race_1 TEXT,
    applicant_race_name_2 TEXT,
    applicant_race_2 TEXT,
    applicant_race_name_3 TEXT,
    applicant_race_3 TEXT,
    applicant_race_name_4 TEXT,
    applicant_race_4 TEXT,
    applicant_race_name_5 TEXT,
    applicant_race_5 TEXT,
    co_applicant_race_name_1 TEXT,
    co_applicant_race_1 TEXT,
    co_applicant_race_name_2 TEXT,
    co_applicant_race_2 TEXT,
    co_applicant_race_name_3 TEXT,
    co_applicant_race_3 TEXT,
    co_applicant_race_name_4 TEXT,
    co_applicant_race_4 TEXT,
    co_applicant_race_name_5 TEXT,
    co_applicant_race_5 TEXT,
    applicant_sex_name TEXT,
    applicant_sex TEXT,
    co_applicant_sex_name TEXT,
    co_applicant_sex TEXT,
    applicant_income_000s TEXT,
    purchaser_type_name TEXT,
    purchaser_type TEXT,
    denial_reason_name_1 TEXT,
    denial_reason_1 TEXT,
    denial_reason_name_2 TEXT,
    denial_reason_2 TEXT,
    denial_reason_name_3 TEXT,
    denial_reason_3 TEXT,
    rate_spread TEXT,
    hoepa_status_name TEXT,
    hoepa_status TEXT,
    lien_status_name TEXT,
    lien_status TEXT,
    edit_status_name TEXT,
    edit_status TEXT,
    sequence_number TEXT,
    population TEXT,
    minority_population TEXT,
    hud_median_family_income TEXT,
    tract_to_msamd_income TEXT,
    number_of_owner_occupied_units TEXT,
    number_of_1_to_4_family_units TEXT,
    application_date_indicator TEXT
);

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


