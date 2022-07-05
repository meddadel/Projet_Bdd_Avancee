DJELLOUL ABBOU Mohammed Adel TP Vendredi
LAMHATTAT Reda TP Vendredi






# Projet_BDD
## Binôme
* Notre groupe est constitué de :
    * DJELLOUL ABBOU Mohammed Adel, numéro d'étudiant 22018734 
 	* LAMHATTAT Reda, numéro d'étudiant 22113173

**attention l’exécution du fichier de la création de la base de donnée va supprimer
un schéma "dbav" s'il en existe un puis le recrée en ajoutant nos tables**

## Composition de la base de données
Notre base de données contient 18 tables
*  producteurs
*  artiste
*  comediens
*  musiciens
*  agents
*  contrat_agence_comedien
*  contrat_agence_musicien
*  contrat_producteur
*  contrat_producteur_comedien
*  contrat_producteur_musicien
*  versements
*  demande
*  refus
*  films
*  film_comediens
*  album
*  spectacles
*  musiciens_spectacle

Chaque table a les contraintes ON DELETE CASCADE ON UPDATE CASCADE nécessaires ainsi que des champs NOT NULL, UNIQUE ou des contrainte de type CHECK.

## Architecture du projet

**création de la base de données et peuplement:**
 Dans le fichier **projet.sql**, on trouve le code sql pour la création de la base de données. **triggers.sql** va crée les triggers avec leurs fonctions, **fonctions.sql** contient quelques fonction pour faciliter la tache à l'administrateur et aussi avoir un meilleur rendement à l'éxecution, Le peuplement des tables est géré par **COPY.sql**.
 Les fichiers csv sont dans le dossier **CSV**. Ils ont été crées par nos soins, à base de scripts Python.
 * Pour créer et alimenter la base de données, il faut taper les commandes suivantes à la suite :
	* psql -f projet.sql
	* psql -f triggers.sql
	* psql -f fonctions.sql
	* psql -f COPY.sql


**Les modélisations**
Le fichier **Modélisation.pdf** correspond à la première modélisation que l'on a proposée.
qui explique quelques détails sur cette dernière.
