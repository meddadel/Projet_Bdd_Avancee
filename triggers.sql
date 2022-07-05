-- Setup trigger to check
create or REPLACE FUNCTION check_date_overlap()
RETURNS trigger as
$body$
declare
    temprow record;
    a date;
    b date;
    c date;
    d date;
begin
    c := new.date_debut;
    d := new.date_fin;

    for temprow in
        SELECT *
        FROM dbav.contrat_agence_comedien
        WHERE  id_comedien = new.id_comedien   -----------
        ORDER BY date_debut
    loop    
        a := temprow.date_debut;
        b := temprow.date_fin;

        
        /*
         * temprow:     A-------------B
         * new:             C----D
         */ 
        if a < c and b > d
        then
            RAISE EXCEPTION 'case A: record is overlapping with record %', temprow.id;
        end if;
    
        /*
         * temprow:         A----B
         * new:         C-------------D
         */ 
        if a > c and b < d
        then
            RAISE EXCEPTION 'case B: record is overlapping with record %', temprow.id;
        end if;
        
        /*
         * tn:  A-------------B
         * new:       C-------------D
         */ 
        if a < c and c < b and b < d
        then
            RAISE EXCEPTION 'case C: record is overlapping with record %', temprow.id;  
        end if;
            
        /*
         * temprow:           A-------------B
         * new:       C-------------D
         */ 
        if c < a and a < d and d < b
        then
            RAISE EXCEPTION 'case D: record is overlapping with record %', temprow.id;  
        end if;
    
        /*
         * temprow:                   A-------------B
         * new:         C-------------D
         */
        if c < a and a = d and d < b
        then
            RAISE EXCEPTION 'case E: record is overlapping with record %', temprow.id;  
        end if;
    
        /*
         * temprow:     A-------------B
         * new:                       C-------------D
         */ 
        if a < c and b = c and b < d
        then
            RAISE EXCEPTION 'case F: record is overlapping with record %', temprow.id;  
        end if;
        
    end loop;


    RETURN NEW;
end
$body$
LANGUAGE plpgsql;



drop trigger if exists on_check_date_overlap on dbav.contrat_agence_comedien;


create trigger on_check_date_overlap
    before update or insert
    on dbav.contrat_agence_comedien
    for each row
    execute procedure check_date_overlap();
----------------------------------------------------------
-- Setup trigger to check
create or REPLACE FUNCTION check_date_overlap_musicien()
RETURNS trigger as
$body$
declare
    temprow record;
    a date;
    b date;
    c date;
    d date;
begin
    c := new.date_debut;
    d := new.date_fin;

  for temprow in
      SELECT *
      FROM dbav.contrat_agence_musicien
      WHERE  id_musicien = new.id_musicien   -----------
      ORDER BY date_debut
  loop    
      a := temprow.date_debut;
      b := temprow.date_fin;
      
      /*
       * temprow:     A-------------B
       * new:             C----D
       */ 
      if a < c and b > d
      then
          RAISE EXCEPTION 'case A: record is overlapping with record %', temprow.id;
      end if;
  
      /*
       * temprow:         A----B
       * new:         C-------------D
       */ 
      if a > c and b < d
      then
          RAISE EXCEPTION 'case B: record is overlapping with record %', temprow.id;
      end if;
      
      /*
       * tn:  A-------------B
       * new:       C-------------D
       */ 
      if a < c and c < b and b < d
      then
          RAISE EXCEPTION 'case C: record is overlapping with record %', temprow.id;  
      end if;
          
      /*
       * temprow:           A-------------B
       * new:       C-------------D
       */ 
      if c < a and a < d and d < b
      then
          RAISE EXCEPTION 'case D: record is overlapping with record %', temprow.id;  
      end if;
  
      /*
       * temprow:                   A-------------B
       * new:         C-------------D
       */
      if c < a and a = d and d < b
      then
          RAISE EXCEPTION 'case E: record is overlapping with record %', temprow.id;  
      end if;
  
      /*
       * temprow:     A-------------B
       * new:                       C-------------D
       */ 
      if a < c and b = c and b < d
      then
          RAISE EXCEPTION 'case F: record is overlapping with record %', temprow.id;  
      end if;
      
  end loop;


    RETURN NEW;
end
$body$
LANGUAGE plpgsql;



drop trigger if exists on_check_date_overlap_musicien on dbav.contrat_agence_musicien;


create trigger on_check_date_overlap_musicien
    before update or insert
    on dbav.contrat_agence_musicien
    for each row
    execute procedure check_date_overlap_musicien();







----------------------------------------------------------

   create or REPLACE FUNCTION payment()
RETURNS trigger as
$body$
declare
    
    somme integer;
    total integer;
    c integer;
   
begin
    c := new.remuneration;

    total := (SELECT remuneration
            FROM dbav.contrat_producteur
            WHERE id_contrat = new.id_contrat);
            
    somme :=( SELECT sum(remuneration)
            FROM dbav.versements
            WHERE  id_contrat=new.id_contrat);

        if somme is null
        then
            if  (c) > total 
        then
            RAISE EXCEPTION 'versement impossible pour le contrat %', new.id_contrat;  
        end if;

        else if (c+somme) > total 
        then
            RAISE EXCEPTION 'versement impossible pour le contrat %', new.id_contrat;  
        end if;
        end if;
    RETURN NEW;
end
$body$
LANGUAGE plpgsql;






create trigger on_check_payment
    before update or insert
    on dbav.versements
    for each row
    execute procedure payment();

