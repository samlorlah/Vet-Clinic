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

--Who was the last animal seen by William Tatcher?
SELECT animals.name, visits.date_of_visit 
FROM animals 
JOIN visits ON visits.animal_id = animals.id 
JOIN vets ON vets.id = visits.vet_id 
WHERE vets.name = 'William Tatcher' 
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(animals.name) FROM animals
JOIN visits ON visits.animal_id =  animals.id
JOIN vets ON  visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name AS vets_name, species.name AS species_name FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

--  What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.date_of_visit) AS visit_count
FROM animals JOIN visits ON visits.animal_id = animals.id 
GROUP BY animals.name 
ORDER BY visit_count 
DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, visits.date_of_visit AS visit_date
FROM animals INNER JOIN visits ON visits.animal_id = animals.id
INNER JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'
ORDER BY visit_date ASC LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name AS animal_name, animals.date_of_birth, animals.neutered, animals.escape_attempts, animals.weight_kg, vets.name AS vets_name, visits.date_of_visit AS date_visited
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
ORDER BY date_visited DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.animal_id)
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON animals.id = visits.animal_id
INNER JOIN specializations ON specializations.species_id = vets.id
WHERE specializations.species_id != animals.species_id;

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS specie, COUNT(visits.animal_id) AS visits
FROM visits
JOIN vets ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY visits DESC LIMIT 1;
