


--  ███████╗████████╗██████╗ ██╗   ██╗████████╗████████╗██╗   ██╗██████╗  █████╗ 
--  ██╔════╝╚══██╔══╝██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██║   ██║██╔══██╗██╔══██╗
--  ███████╗   ██║   ██████╔╝██║   ██║   ██║      ██║   ██║   ██║██████╔╝███████║
--  ╚════██║   ██║   ██╔══██╗██║   ██║   ██║      ██║   ██║   ██║██╔══██╗██╔══██║
--  ███████║   ██║   ██║  ██║╚██████╔╝   ██║      ██║   ╚██████╔╝██║  ██║██║  ██║
--  ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
--                                                                               


CREATE USER myuser;
-- ALTER USER myuser WITH PASSWORD 'user';


-- CREATE SCHEMA IF NOT EXISTS gestione2024;
-- CREATE DATABASE gestione2024;
-- GRANT ALL PRIVILEGES ON DATABASE gestione2024 TO myuser;

CREATE SCHEMA gestione2024 AUTHORIZATION myuser;
GRANT ALL ON SCHEMA gestione2024 TO myuser;


CREATE TABLE gestione2024.case (
    ID serial PRIMARY KEY,
    citta varchar(256),
    cap varchar(256),
    indirizzo varchar(256),
    note varchar(1024)
);

CREATE TABLE gestione2024.spese_case (
    data TIMESTAMP PRIMARY KEY,
    id_casa INT REFERENCES gestione2024.case(ID),
    note VARCHAR(2056),
    entrate DOUBLE PRECISION,
    uscite DOUBLE PRECISION,
    altre_note BYTEA
);


CREATE VIEW gestione2024.spese_casa_somma AS
SELECT
    id_casa,
    SUM(entrate) AS totale_entrate,
    SUM(uscite) AS totale_uscite
FROM
    gestione2024.spese_case
GROUP BY
    id_casa;


CREATE TABLE gestione2024.macchine (
    targa VARCHAR(256) PRIMARY KEY,
    marca VARCHAR(256),
    modello VARCHAR(256)
);


CREATE TABLE gestione2024.spese_macchine (
    data TIMESTAMP PRIMARY KEY,
    id_macchina VARCHAR(256) REFERENCES gestione2024.macchine(targa),
    note VARCHAR(2056),
    entrate DOUBLE PRECISION,
    uscite DOUBLE PRECISION,
    altre_note BYTEA
);


CREATE VIEW gestione2024.spese_macchine_somma AS
SELECT
    id_macchina,
    SUM(entrate) AS totale_entrate,
    SUM(uscite) AS totale_uscite
FROM
    gestione2024.spese_macchine
GROUP BY
    id_macchina;



-- Creazione della tabella macchine_benzina
CREATE TABLE gestione2024.macchine_benzina (
    data timestamp PRIMARY KEY,
    id_macchina VARCHAR(256) REFERENCES gestione2024.macchine(targa),
    km int,
    litri double precision,
    differenzaKm int,
    diffKmL double precision,
    diffL100km double precision,
    note varchar(2056)
);





-- Creazione della view tutteLeSomme
-- non funziona
-- CREATE VIEW tutteLeSomme AS
-- SELECT
--   'gestione2024.spese_casa_somma' AS tabella,
--   id_casa AS id,
--   totale_entrate,
--   totale_uscite
-- FROM gestione2024.spese_casa_somma
-- UNION
-- SELECT
--   'gestione2024.spese_macchine_somma' AS tabella,
--   id_macchina AS id,
--   totale_entrate,
--   totale_uscite
-- FROM gestione2024.spese_macchine_somma;





-- Creazione della view tutteLeSomme
-- CREATE VIEW tutteLeSomme AS
-- SELECT
--   COALESCE(c.id_casa, m.id_macchina) AS id,
--   COALESCE(c.totale_entrate, 0) + COALESCE(m.totale_entrate, 0) AS totale_entrate,
--   COALESCE(c.totale_uscite, 0) + COALESCE(m.totale_uscite, 0) AS totale_uscite
-- FROM gestione2024.spese_casa_somma c
-- FULL OUTER JOIN gestione2024.spese_macchine_somma m ON c.id_casa = m.id_macchina;







--  ████████╗███████╗███████╗████████╗
--  ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
--     ██║   █████╗  ███████╗   ██║   
--     ██║   ██╔══╝  ╚════██║   ██║   
--     ██║   ███████╗███████║   ██║   
--     ╚═╝   ╚══════╝╚══════╝   ╚═╝   
--                                    


INSERT INTO gestione2024.case (ID, citta, cap, indirizzo, note)
VALUES
  (1, 'Roma', '00100', 'Via Roma 123', 'Appartamento principale'),
  (2, 'Milano', '20100', 'Corso Milano 456', 'Casa vacanze'),
  (3, 'Napoli', '80100', 'Viale Napoli 789', 'Appartamento in affitto');




INSERT INTO gestione2024.macchine (targa, marca, modello)
VALUES
  ('ABC123', 'Fiat', '500'),
  ('XYZ456', 'Toyota', 'Corolla'),
  ('DEF789', 'Volkswagen', 'Golf');






INSERT INTO gestione2024.spese_case (data, id_casa, note, entrate, uscite, altre_note)
VALUES
  ('2024-01-01', 1, 'Spesa supermercato', 200.50, 0.00, NULL),
  ('2024-01-02', 2, 'Pagamento bollette', 0.00, 100.00, NULL),
  ('2024-01-03', 1, 'Manutenzione', 0.00, 50.00, 'Dettagli manutenzione');





INSERT INTO gestione2024.spese_macchine (data, id_macchina, note, entrate, uscite, altre_note)
VALUES
  ('2024-01-01', 'ABC123', 'Rifornimento carburante', 0.00, 50.00, NULL),
  ('2024-01-02', 'ABC123', 'Manutenzione', 30.00, 0.00, 'Dettagli manutenzione'),
  ('2024-01-03', 'ABC123', 'Viaggio', 0.00, 20.00, NULL);




INSERT INTO gestione2024.macchine_benzina (data, id_macchina, km, litri, differenzaKm, diffKmL, diffL100km, note)
VALUES
  ('2023-12-01 10:00:00', 'ABC123', 93781, 28.92, 467, 16.14, 6.19, 'Rifornimento mensile');




--  ████████╗██████╗ ██╗ ██████╗  ██████╗ ███████╗██████╗ 
--  ╚══██╔══╝██╔══██╗██║██╔════╝ ██╔════╝ ██╔════╝██╔══██╗
--     ██║   ██████╔╝██║██║  ███╗██║  ███╗█████╗  ██████╔╝
--     ██║   ██╔══██╗██║██║   ██║██║   ██║██╔══╝  ██╔══██╗
--     ██║   ██║  ██║██║╚██████╔╝╚██████╔╝███████╗██║  ██║
--     ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
--                                                        






-- LAG in postgresql permette l'accesso alla riga immediatamente precedente a quella che si sta inserendo
-- Creazione del trigger
CREATE OR REPLACE FUNCTION calcola_diff_km()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcolo della differenzaKm
    NEW.differenzaKm := NEW.km - LAG(NEW.km) OVER (PARTITION BY NEW.id_macchina ORDER BY NEW.data);

    -- Calcolo di diffKmL
    IF NEW.differenzaKm IS NOT NULL AND NEW.litri IS NOT NULL THEN
        NEW.diffKmL := NEW.differenzaKm / NEW.litri;
    END IF;

    -- Calcolo di diffL100km
    IF NEW.diffKmL IS NOT NULL THEN
        NEW.diffL100km := 100.0 / NEW.diffKmL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger che chiama la funzione appena definita
CREATE TRIGGER calcola_diff_km_trigger
BEFORE INSERT ON gestione2024.macchine_benzina
FOR EACH ROW EXECUTE FUNCTION calcola_diff_km();








--  ████████╗███████╗███████╗████████╗     ██████╗ 
--  ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝     ╚════██╗
--     ██║   █████╗  ███████╗   ██║         █████╔╝
--     ██║   ██╔══╝  ╚════██║   ██║        ██╔═══╝ 
--     ██║   ███████╗███████║   ██║███████╗███████╗
--     ╚═╝   ╚══════╝╚══════╝   ╚═╝╚══════╝╚══════╝
--                                                 



INSERT INTO gestione2024.macchine_benzina (data, id_macchina, km, litri, differenzaKm, diffKmL, diffL100km, note)
VALUES
  ('2023-12-05 15:30:00', 'ABC123', 94056, 28.17, NULL, NULL, NULL, 'Rifornimento settimanale'),
  ('2023-12-10 08:45:00', 'ABC123', 94341, 26.56, NULL, NULL, NULL, 'Aggiornamento dopo il viaggio');





