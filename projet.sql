DROP SCHEMA IF EXISTS dbav CASCADE;
CREATE SCHEMA dbav;
SET search_path to dbav;
CREATE TYPE contrat AS ENUM ('CDI', 'CDD', 'AUTRE');
CREATE TYPE role_comediens AS ENUM ('gentil', 'mechant','superhero');

create table dbav.producteurs( 
	id_producteur integer primary key, 
	nom varchar(50) NOT NULL, 
	prenom varchar(50) NOT NULL, 
	mail varchar(50) NOT NULL UNIQUE, 
	dateNaiss date NOT NULL
	);

create table dbav.artiste(
id_artiste integer primary key
);   

create table dbav.comediens( 
	id_comedien integer references dbav.artiste  ON DELETE CASCADE ON UPDATE CASCADE primary key, 
	nom varchar(50) NOT NULL, 
	prenom varchar(50) NOT NULL, 
	mail varchar(50) NOT NULL UNIQUE, 
	dateNaiss date NOT NULL, 
    taille float NOT NULL,
    poids float NOT NULL,
    sexe char(1) NOT NULL check(sexe in ('F','M'))
	);

create table dbav.musiciens( 
	id_musicien integer references dbav.artiste  ON DELETE CASCADE ON UPDATE CASCADE primary key, 
	nom varchar(50) NOT NULL, 
	prenom varchar(50) NOT NULL, 
	mail varchar(50) NOT NULL UNIQUE, 
	dateNaiss date NOT NULL, 
    style varchar(25) check(style in ('ROCK N ROLL','JAZZ','ORIONTAL','classic')) NOT NULL,
    sexe char(1) check(sexe in ('F','M')) NOT NULL
	);

create table dbav.agents( 
	id_agent integer primary key, 
	nom varchar(50) NOT NULL, 
	prenom varchar(50) NOT NULL, 
	mail varchar(50) NOT NULL UNIQUE, 
	dateNaiss date NOT NULL
    );

create table dbav.contrat_agence_comedien(  
    id_contrat integer primary key,
    id_agent integer references dbav.agents  ON DELETE CASCADE ON UPDATE CASCADE,
    id_comedien integer NOT NULL,
	date_debut date NOT NULL,
    date_fin date NOT NULL,
    

	CONSTRAINT date_debut_fin CHECK (date_debut < date_fin),

    CONSTRAINT artiste_comedien
      FOREIGN KEY(id_comedien) 
	  REFERENCES comediens(id_comedien)
	  ON DELETE CASCADE ON UPDATE CASCADE

  
    );

    create table dbav.contrat_agence_musicien(  
    id_contrat integer primary key,
    id_agent integer references dbav.agents  ON DELETE CASCADE ON UPDATE CASCADE,
    id_musicien integer ,
	date_debut date NOT NULL,
    date_fin date NOT NULL,
    
	CONSTRAINT date_debut_fin CHECK (date_debut < date_fin),

    CONSTRAINT artiste_musicien
    FOREIGN KEY(id_musicien) 
	REFERENCES musiciens(id_musicien)
    ON DELETE CASCADE ON UPDATE CASCADE

    --reste le trigger pour le chevauchement des dates 
    );

create table dbav.contrat_producteur( 
    id_contrat integer primary key,
    id_producteur integer references dbav.producteurs  ON DELETE CASCADE ON UPDATE CASCADE,
	date_debut date NOT NULL,
    date_fin date,
    type contrat NOT NULL,
    remuneration integer NOT NULL,
    CHECK (remuneration > 0),
	CONSTRAINT date_debut_fin CHECK (date_debut < date_fin)
    
    );
    create table dbav.contrat_producteur_comedien( 
    id_contrat integer references dbav.contrat_producteur  ON DELETE CASCADE ON UPDATE CASCADE primary key,
	id_comedien integer,
    CONSTRAINT artiste_comedien
    FOREIGN KEY(id_comedien) 
    REFERENCES comediens(id_comedien)
    ON DELETE CASCADE ON UPDATE CASCADE
    );
 create table dbav.contrat_producteur_musicien( 
    id_contrat integer  references dbav.contrat_producteur  ON DELETE CASCADE ON UPDATE CASCADE primary key,
	id_musicien integer,
    CONSTRAINT artiste_musicien
    FOREIGN KEY(id_musicien) 
	REFERENCES musiciens(id_musicien)
	ON DELETE CASCADE ON UPDATE CASCADE
   
    );
create table dbav.versements( 
    id_contrat integer references dbav.contrat_producteur ON DELETE CASCADE ON UPDATE CASCADE,
    date_versement TIMESTAMP NOT NULL,
    remuneration integer NOT NULL,
    primary key(id_contrat,date_versement),
    CHECK (remuneration > 0)
    --reste le trigger pour remuneration <= dbav.contrat_producteur.remuneration
    );    

create table dbav.demande( 
    id_demande integer primary key,
    id_agent integer references dbav.agents  ON DELETE CASCADE ON UPDATE CASCADE,
    role_com role_comediens NOT NULL,
    sexe char(1) NOT NULL check(sexe in ('F','M')),
    taille float NOT NULL,
    poids float NOT NULL,
    date_debut date NOT NULL,
    date_fin date NOT NULL
    );

create table dbav.refus( 
    id_demande integer references dbav.demande ON DELETE CASCADE ON UPDATE CASCADE,
    id_comedien integer references dbav.comediens ON DELETE CASCADE ON UPDATE CASCADE,
    motif varchar(50),
    primary key(id_comedien, id_demande)

    );    

create table dbav.films( 
    id_film integer primary key,
    nom varchar(40),
    date_sortie date,
    UNIQUE(nom,date_sortie)
    );    

create table dbav.film_comediens( 
    id_film integer references dbav.films ON DELETE CASCADE ON UPDATE CASCADE,
    id_comedien integer references dbav.comediens ON DELETE CASCADE ON UPDATE CASCADE,
    role_comedien role_comediens,
    primary key(id_comedien, id_film ,role_comedien)
    );    

create table dbav.album( 
    id_album integer primary key,
    id_musicien integer references dbav.musiciens ON DELETE CASCADE ON UPDATE CASCADE,
    nom varchar(40) NOT NULL,
    date_sortie date NOT NULL
    );   

create table dbav.spectacles( 
    id_spectacle integer primary key,
    nom varchar(40) NOT NULL,
    lieu varchar(30) NOT NULL,
    date_spectacle date NOT NULL
    );   


create table dbav.musiciens_spectacle( 
    id_spectacle integer references dbav.spectacles ON DELETE CASCADE ON UPDATE CASCADE,
    id_musicien integer references dbav.musiciens ON DELETE CASCADE ON UPDATE CASCADE,
    primary key(id_spectacle,id_musicien)
    );   

