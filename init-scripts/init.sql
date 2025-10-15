-- Tabelle zur Speicherung des User-Inputs (Application) und des berechneten Praemie
CREATE TABLE application (
    id SERIAL PRIMARY KEY,
    postcode VARCHAR(5) NOT NULL,
    yearly_mileage INTEGER NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    calculated_premium DECIMAL NOT NULL
);

-- Tabelle zur Speicherung der Bundeslaender
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    region VARCHAR(255) UNIQUE NOT NULL,
    region_factor DECIMAL NOT NULL
);

-- Tabelle zur Speicherung der PLZ
CREATE TABLE postcodes (
    id SERIAL PRIMARY KEY,
    postcode VARCHAR(10) UNIQUE NOT NULL,
    region_id INTEGER REFERENCES regions(id)
);

-- Tabelle zur Speicherung von Fahrzeug-Faktoren
CREATE TABLE vehicle (
	id SERIAL PRIMARY KEY,
	vehicle_type TEXT UNIQUE,
	vehicle_factor DECIMAL
);

CREATE TABLE yearly_mileage (
    id SERIAL PRIMARY KEY,
    yearly_mileage_from INTEGER NOT NULL,
    yearly_mileage_to NUMERIC,
    yearly_mileage_factor REAL NOT NULL
);