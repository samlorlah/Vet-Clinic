/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR,
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL
);

-- Add a column species of type string to your animals table.
ALTER TABLE animals ADD COLUMN species VARCHAR(255);

--Create a table named owners
CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  full_name VARCHAR NOT NULL,
  age INT NOT NULL,
  PRIMARY KEY (id)
);

--Create a table named species
CREATE TABLE species(
  id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  name VARCHAR NOT NULL,
  PRIMARY KEY (id)
);

-- Add primary key to id column of animals table.
ALTER TABLE animals ADD PRIMARY KEY (id);

-- set id column of animals table as autoincrement primary key.
ALTER TABLE animals ALTER COLUMN id SET DEFAULT nextval('animals_pkey');

-- Edit the animals table to drop the species column.
ALTER TABLE animals DROP COLUMN species;

-- Add columns species_id as foreign key to animals table.
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);

-- Add columns owner_id as foreign key to animals table.
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);

-- Create Vets Table
CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250) NOT NULL,
  age INT NOT NULL,
  date_of_graduation DATE NOT NULL,
  PRIMARY KEY (id)
);

-- Create Intermediate Table Between Vet and Species
CREATE TABLE specializations(
  species_id INT REFERENCES species(id),
  vet_id INT REFERENCES vets(id)
);

-- Create Intermediate Table Between Animals and Vets
CREATE TABLE visits(
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE
);