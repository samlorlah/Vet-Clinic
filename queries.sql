/*Queries that provide answers to the questions from all projects.*/

--Find all animals whose name ends in "mon".
SELECT * from animals WHERE name LIKE '%mon';

--List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

--List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

--List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

--List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

--Find all animals that are neutered.
SELECT * FROM  animals WHERE neutered = true;

--Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';

--Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

--Inside a transaction update the animals table by setting the species column to unspecified.
BEGIN;
SAVEPOINT first_sp;

UPDATE animals SET species = 'unspecified';

--Verify that change was made.
SELECT * from animals;

--Roll back the change and verify that the species columns went back to the state before the transaction.
ROLLBACK first_sp;
COMMIT;

SELECT * from animals;

--BEGIN ANOTHER TRANSACTION
BEGIN;

--Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

--Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

--Commit the transaction.
COMMIT;

--Verify that change was made and persists after commit.
SELECT * from animals;

--Inside a transaction delete all records in the animals table
BEGIN;
SAVEPOINT del_data;

DELETE FROM animals;

--Roll back the transaction.
ROLLBACK TO del_data;
COMMIT;

-- Verify if all records in the animals table still exists.
SELECT * from animals;

--Begin Transaction
BEGIN;
SAVEPOINT data1;

--Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '01-01-2022';

--Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = (weight_kg * -1);

--Rollback
ROLLBACK TO data1;

--Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0;

--Commit
COMMIT;

--How many animals are there?
SELECT count(*) FROM animals;

--How many animals have never tried to escape?
SELECT count(*) FROM animals WHERE escape_attempts = 0;

--What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

--Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) as AVG_escape FROM animals GROUP BY neutered;

--What is the minimum and maximum weight of each type of animal?
SELECT MIN(weight_kg), MAX(weight_kg), species FROM animals GROUP BY species;

--What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species,AVG(escape_attempts) FROM animals WHERE date_of_birth  BETWEEN '1990-01-01' AND '2020-12-31' GROUP BY species;

--What animals belong to Melody Pond?
SELECT name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;

--How many animals are there per species?
SELECT species.name AS Specie_name, COUNT(animals.name) as Number_of_animals FROM species JOIN animals ON species.id = animals.species_id GROUP BY Specie_name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id JOIN species ON animals.species_id = species.id WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Wincheste' AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name as owner_full_name, COUNT(animals.name) AS Number_of_animals FROM owners LEFT JOIN animals ON owners.id = animals.owner_id GROUP BY owner_full_name ORDER BY Number_of_animals DESC;
