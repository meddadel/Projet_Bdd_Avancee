
CREATE OR REPLACE FUNCTION est_musicien(id_artiste int)
RETURNS BOOLEAN AS $$
BEGIN
       CASE 
        WHEN ( id_artiste IN (SELECT m.id_musicien FROM musiciens m) ) THEN RETURN TRUE;
        WHEN ( id_artiste IN (SELECT c.id_comedien FROM comediens c) ) THEN RETURN FALSE;
        ELSE RAISE EXCEPTION 'artiste inexistant %', id_artiste USING ERRCODE = '20002';
        END CASE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION est_musicien_and_comedien(id_artiste int)
RETURNS BOOLEAN AS $$
BEGIN
       CASE 
        WHEN ( id_artiste IN (SELECT m.id_musicien FROM musiciens m) ) AND ( id_artiste IN (SELECT c.id_comedien FROM comediens c) ) THEN RETURN TRUE;
        ELSE  RETURN FALSE;
        END CASE;
END;
$$ LANGUAGE plpgsql;


------------------------Contrat_producteur_comedien----------------------------------


DROP FUNCTION new_Contrat_producteur_comedien(id_contrat int,id_comed int ,id_producteur int, date_debut date, date_fin date, type contrat, remuneration int);

CREATE OR REPLACE FUNCTION new_Contrat_producteur_comedien(id_contrat int,id_comed int ,id_producteur int, date_debut date, date_fin date, type contrat, remuneration int)
RETURNS SETOF dbav.contrat_producteur_comedien AS $$ 
--  La fonction retourne un type “ensemble” (SETOF)
DECLARE
type_artiste BOOLEAN;
type_artiste2 BOOLEAN;
BEGIN
    IF NOT(date_fin is NULL) and NOT(type = 'CDI')
    THEN
        -- Si le client n'existe pas, termine avec une exception
        type_artiste := est_musicien (id_comed); 
        type_artiste2 := est_musicien_and_comedien(id_comed);
        IF (NOT(type_artiste) OR type_artiste2)
        THEN
        INSERT INTO dbav.contrat_producteur VALUES (id_contrat ,id_producteur, date_debut, date_fin, type,remuneration );
        INSERT INTO dbav.contrat_producteur_comedien VALUES (id_contrat,id_comed);
         -- renvoie tous les contrat du comedien id_comedien
        RETURN QUERY SELECT * FROM dbav.contrat_producteur_comedien WHERE id_comedien = id_comed;
        ELSE
        RAISE EXCEPTION 'le Client est un musicien % ', id_comedien USING ERRCODE = '20001' ; END IF;
    
    ELSE IF date_fin is NULL and type = 'CDI'
    THEN
     -- Si le client n'existe pas, termine avec une exception
        type_artiste := est_musicien (id_comed); 
        type_artiste2 := est_musicien_and_comedien(id_comed);
        IF (NOT(type_artiste) OR type_artiste2)
        THEN
            INSERT INTO dbav.contrat_producteur VALUES (id_contrat ,id_producteur, date_debut, NULL, type,remuneration );
            INSERT INTO dbav.contrat_producteur_comedien VALUES (id_contrat,id_comed);
             -- renvoie tous les reservations de CURRENT_USER
            RETURN QUERY SELECT * FROM dbav.contrat_producteur_comedien WHERE id_comedien = id_comed;
        ELSE
            RAISE EXCEPTION 'le Client est un musicien % ', id_musi USING ERRCODE = '20001' ; END IF;
    
    ELSE
        RAISE EXCEPTION 'LE TYPE CDI NE PREND PAS UNE DATE FIN 'USING ERRCODE = '20001' ; END IF; END IF;
    
END;
$$ LANGUAGE plpgsql;



--------------------------------------------------------------------------------------
------------------Contrat_producteur_musicien---------------------

DROP FUNCTION  new_Contrat_producteur_musicien(id_contrat int,id_musi int ,id_producteur int, date_debut date, date_fin date, type contrat, remuneration int);

CREATE OR REPLACE FUNCTION new_Contrat_producteur_musicien(id_contrat int,id_musi int ,id_producteur int, date_debut date, date_fin date, type contrat, remuneration int)
RETURNS SETOF dbav.contrat_producteur_musicien AS $$ 
--  La fonction retourne un type “ensemble” (SETOF)
DECLARE
type_artiste BOOLEAN;
BEGIN
    IF NOT(date_fin is NULL) and NOT(type = 'CDI')
    THEN
        -- Si le client n'existe pas, termine avec une exception
        type_artiste := est_musicien (id_musi); 
        IF type_artiste
        THEN
            INSERT INTO dbav.contrat_producteur VALUES (id_contrat ,id_producteur, date_debut, date_fin, type,remuneration );
            INSERT INTO dbav.contrat_producteur_musicien VALUES (id_contrat,id_musi);
             -- renvoie tous les reservations de CURRENT_USER
            RETURN QUERY SELECT * FROM dbav.contrat_producteur_musicien WHERE id_musicien = id_musi;
        ELSE
            RAISE EXCEPTION 'le Client est un comedien % ', id_musi USING ERRCODE = '20001' ; END IF;
    
    ELSE IF date_fin is NULL and type = 'CDI'
    THEN
     -- Si le client n'existe pas, termine avec une exception
        type_artiste := est_musicien (id_musi); 
        IF type_artiste
        THEN
            INSERT INTO dbav.contrat_producteur VALUES (id_contrat ,id_producteur, date_debut, NULL, type,remuneration );
            INSERT INTO dbav.contrat_producteur_musicien VALUES (id_contrat,id_musi);
             -- renvoie tous les reservations de CURRENT_USER
            RETURN QUERY SELECT * FROM dbav.contrat_producteur_musicien WHERE id_musicien = id_musi;
        ELSE
            RAISE EXCEPTION 'le Client est un comedien % ', id_musi USING ERRCODE = '20001' ; END IF;
    
    ELSE
        RAISE EXCEPTION 'LE TYPE CDI NE PREND PAS UNE DATE FIN 'USING ERRCODE = '20001' ; END IF; END IF;
    
END;
$$ LANGUAGE plpgsql;


------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION new_spectacle_musicien(id_spect int,musiciens integer[],nom varchar(40),lieu varchar(30), date_spectacle date)
RETURNS SETOF  dbav.musiciens_spectacle AS $$ 
--  La fonction retourne un type “ensemble” (SETOF)
DECLARE
type_artiste BOOLEAN;
i  INTEGER := 1;
BEGIN

  INSERT INTO dbav.spectacles VALUES (id_spect ,nom,lieu,date_spectacle);
  
  WHILE musiciens[i] is not null
  LOOP
    -- Si le client n'existe pas, termine avec une exception
    type_artiste := est_musicien (musiciens[i]);
    IF type_artiste
    THEN
        INSERT INTO dbav.musiciens_spectacle VALUES (id_spect ,musiciens[i]);
        i :=i+1;
    ELSE
        RAISE EXCEPTION 'le Client est un musicien % ', id_comedien USING ERRCODE = '20001' ; END IF;
  END LOOP;
  -- renvoie tous les MUSICIENS DU SPECTACLE id_spectacle
      RETURN QUERY SELECT * FROM dbav.musiciens_spectacle WHERE id_spectacle = id_spect;       
END;
$$ LANGUAGE plpgsql;




---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------