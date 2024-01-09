---------P11---------
---------Prima parte a proiectului--------------

DROP TABLE IF EXISTS Angajati CASCADE;
DROP TABLE IF EXISTS tura CASCADE;

-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

-- DROP TYPE public."actiune";

CREATE TYPE public."actiune" AS ENUM (
	'imprumut',
	'returnare',
	'prelungire',
	'rezervare');

-- DROP TYPE public."tipcoperta";

CREATE TYPE public."tipcoperta" AS ENUM (
	'moale',
	'tare');
-- public.angajati definition

-- Drop table

-- DROP TABLE public.angajati;

CREATE TABLE Angajati (
    AngajatID INT PRIMARY KEY,
    Nume VARCHAR(100) NOT NULL,
    Prenume VARCHAR(100) NOT NULL,
    DataAngajarii DATE NOT NULL
);

-- Asigurați-vă că acest bloc este executat înaintea oricărei referințe la tabelul angajati

-- Creare tabel Angajati în schema public
CREATE TABLE public.angajati (
    AngajatID INT PRIMARY KEY,
    Nume VARCHAR(100) NOT NULL,
    Prenume VARCHAR(100) NOT NULL,
    DataAngajarii DATE NOT NULL
);


-- Creare tabel Reclamatii
CREATE TABLE Reclamatii (
    ReclamatieID INT PRIMARY KEY,
    CititorID INT REFERENCES Cititori (CititorID),
    Descriere TEXT NOT NULL,
    SursaReclamatie VARCHAR(50) CHECK (SursaReclamatie IN ('Cititor', 'Biblioteca')),
    StatusReclamatie VARCHAR(50) CHECK (StatusReclamatie IN ('Deschisa', 'In Proces', 'Rezolvata')),
    DataReclamatie TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE public.tura;
-- Creare tabel Tura
CREATE TABLE Tura (
    TuraID INT PRIMARY KEY,
    AngajatID INT,
    Orelucrate INT NOT NULL,
    DescriereTaskuri TEXT,
    CONSTRAINT fk_angajat_tura FOREIGN KEY (AngajatID) REFERENCES Angajati (AngajatID)
);


-- Creare tabel Imprumuturi, acum inclusiv AngajatID
CREATE TABLE Imprumuturi (
    ImprumutID INT PRIMARY KEY,
    CititorID INT, -- Această relație va fi definită după crearea tabelului Cititori
    AngajatID INT REFERENCES Angajati (AngajatID), -- Relație foreign key către tabelul Angajati
    DataImprumut DATE NOT NULL,
    DataScadenta DATE NOT NULL
);

drop table opeariuniimprumut

-- Creare tabel OperatiuniImprumut
CREATE TABLE OperatiuniImprumut (
    OperatiuneID INT PRIMARY KEY,
    ImprumutID INT NOT NULL,
    TuraID INT,
    Timestamp TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT operatiuniimprumut_imprumutid_fkey FOREIGN KEY (ImprumutID) REFERENCES Imprumuturi (ImprumutID),
    CONSTRAINT fk_tura_operatiuni FOREIGN KEY (TuraID) REFERENCES Tura (TuraID)
);



-- public.edituri definition

-- Drop table

-- DROP TABLE public.edituri;

CREATE TABLE public.edituri (
	edituraid int4 NOT NULL,
	numeeditura varchar(100) NOT NULL,
	CONSTRAINT edituri_pkey PRIMARY KEY (edituraid)
);


-- public.operatiiimprumut definition

-- Drop table

DROP TABLE public.operatiiimprumut;


-- public.adrese definition

-- Drop table

-- DROP TABLE public.adrese;

CREATE TABLE public.adrese (
	adresaid int4 NOT NULL,
	edituraid int4 NULL,
	adresa varchar(255) NOT NULL,
	oras varchar(100) NOT NULL,
	tara varchar(100) NOT NULL,
	telefon varchar(20) NULL,
	CONSTRAINT adrese_pkey PRIMARY KEY (adresaid),
	CONSTRAINT adrese_edituraid_fkey FOREIGN KEY (edituraid) REFERENCES public.edituri(edituraid)
);


-- public.autori definition

-- Drop table

-- DROP TABLE public.autori;

CREATE TABLE public.autori (
	autorid int4 NOT NULL,
	mentorid int4 NULL,
	nume varchar(100) NOT NULL,
	prenume varchar(100) NOT NULL,
	datanasterii date NULL,
	nationalitate varchar(50) NULL,
	CONSTRAINT autori_pkey PRIMARY KEY (autorid),
	CONSTRAINT fk_mentorid FOREIGN KEY (mentorid) REFERENCES public.autori(autorid)
);


-- public.carti definition

-- Drop table

-- DROP TABLE public.carti;

CREATE TABLE public.carti (
	carteid int4 NOT NULL,
	cota varchar(255) NOT NULL,
	dataachizitiei date NOT NULL,
	titlu varchar(255) NOT NULL,
	edituraid int4 NULL,
	limba varchar(50) NULL,
	numarpagini int4 NULL,
	CONSTRAINT carti_pkey PRIMARY KEY (carteid),
	CONSTRAINT carti_edituraid_fkey FOREIGN KEY (edituraid) REFERENCES public.edituri(edituraid)
);


-- public.categorii definition

-- Drop table

-- DROP TABLE public.categorii;

CREATE TABLE public.categorii (
	categorieid int4 NOT NULL,
	numecategorie varchar(100) NOT NULL,
	categorieparinteid int4 NULL,
	CONSTRAINT categorii_pkey PRIMARY KEY (categorieid),
	CONSTRAINT fk_categorie_parinte FOREIGN KEY (categorieparinteid) REFERENCES public.categorii(categorieid)
);


-- public.categoriicarti definition

-- Drop table

-- DROP TABLE public.categoriicarti;

CREATE TABLE public.categoriicarti (
	carteid int4 NOT NULL,
	categorieid int4 NOT NULL,
	CONSTRAINT categoriicarti_pkey PRIMARY KEY (carteid, categorieid),
	CONSTRAINT categoriicarti_carteid_fkey FOREIGN KEY (carteid) REFERENCES public.carti(carteid),
	CONSTRAINT categoriicarti_categorieid_fkey FOREIGN KEY (categorieid) REFERENCES public.categorii(categorieid)
);


-- public.cititori definition

-- Drop table

-- DROP TABLE public.cititori;

CREATE TABLE public.cititori (
	cititorid int4 NOT NULL,
	nume varchar(100) NOT NULL,
	prenume varchar(100) NOT NULL,
	datanasterii date NULL,
	adresaid int4 NULL,
	telefon varchar(20) NULL,
	email varchar(100) NOT NULL,
	datainregistrarii date NOT NULL,
	CONSTRAINT cititori_email_key UNIQUE (email),
	CONSTRAINT cititori_pkey PRIMARY KEY (cititorid),
	CONSTRAINT cititori_adresaid_fkey FOREIGN KEY (adresaid) REFERENCES public.adrese(adresaid)
);


-- public.imprumuturi definition

-- Drop table

-- DROP TABLE public.imprumuturi;

CREATE TABLE public.imprumuturi (
	imprumutid int4 NOT NULL,
	cititorid int4 NULL,
	dataimprumut date NOT NULL,
	datascadenta date NOT NULL,
	CONSTRAINT imprumuturi_pkey PRIMARY KEY (imprumutid),
	CONSTRAINT imprumuturi_cititorid_fkey FOREIGN KEY (cititorid) REFERENCES public.cititori(cititorid)
);


-- public.operatiuniimprumut definition

-- Drop table

-- public.publicatii definition

-- Drop table

-- DROP TABLE public.publicatii;

CREATE TABLE public.publicatii (
	publicatieid int4 NOT NULL,
	autorid int4 NULL,
	titlu varchar(255) NOT NULL,
	tippublicatie varchar(50) NOT NULL,
	CONSTRAINT publicatii_pkey PRIMARY KEY (publicatieid),
	CONSTRAINT publicatii_autorid_fkey FOREIGN KEY (autorid) REFERENCES public.autori(autorid)
);


-- public.recenzii definition

-- Drop table

-- DROP TABLE public.recenzii;

CREATE TABLE public.recenzii (
	recenzieid int4 NOT NULL,
	carteid int4 NULL,
	cititorid int4 NULL,
	rating int4 NULL,
	textrecenzie text NULL,
	datarecenzie date NOT NULL,
	CONSTRAINT recenzii_pkey PRIMARY KEY (recenzieid),
	CONSTRAINT recenzii_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
	CONSTRAINT recenzii_carteid_fkey FOREIGN KEY (carteid) REFERENCES public.carti(carteid),
	CONSTRAINT recenzii_cititorid_fkey FOREIGN KEY (cititorid) REFERENCES public.cititori(cititorid)
);


-- public.receptiicarti definition

-- Drop table

DROP TABLE public.receptiicarti;

CREATE TABLE ReceptiiCarti (
    ReceptieID INT PRIMARY KEY,
    CarteID INT,
    AngajatID INT,
    DataReceptie DATE NOT NULL,
    CONSTRAINT fk_carte_receptie FOREIGN KEY (CarteID) REFERENCES Carti (CarteID),
    CONSTRAINT fk_angajat_receptie FOREIGN KEY (AngajatID) REFERENCES Angajati (AngajatID)
);


-- Asigurați-vă că tabela Carti există deja

-- Adăugare coloană CarteID la tabela ReceptiiCarti, dacă nu există
ALTER TABLE ReceptiiCarti ADD COLUMN IF NOT EXISTS CarteID INT;

-- Adăugare constrângere de cheie străină pentru CarteID în tabela ReceptiiCarti
-- Presupunând că tabelul ReceptiiCarti a fost deja creat fără coloana CarteID

-- Încercarea de a adăuga coloana CarteID la tabelul ReceptiiCarti
DO $$
BEGIN
    -- Verifică dacă coloana nu există înainte de a o adăuga
    IF NOT EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'receptiicarti' 
        AND column_name = 'carteid'
    ) THEN
        ALTER TABLE public.receptiicarti ADD COLUMN CarteID INT;
        ALTER TABLE public.receptiicarti ADD CONSTRAINT fk_carte_receptie FOREIGN KEY (CarteID) REFERENCES public.carti(CarteID);
    END IF;
END
$$;


-- public.reviste definition

-- Drop table

-- DROP TABLE public.reviste;

CREATE TABLE public.reviste (
	revistaid int4 NOT NULL,
	publicatieid int4 NULL,
	numarul int4 NOT NULL,
	datapublicarii date NOT NULL,
	CONSTRAINT reviste_pkey PRIMARY KEY (revistaid),
	CONSTRAINT reviste_publicatieid_fkey FOREIGN KEY (publicatieid) REFERENCES public.publicatii(publicatieid)
);

-- Adăugare coloană AngajatID la tabelul Imprumuturi
ALTER TABLE Imprumuturi
ADD COLUMN AngajatID INT;

-- Adăugare constrângere de cheie străină pentru AngajatID în tabelul Imprumuturi
ALTER TABLE Imprumuturi
ADD CONSTRAINT fk_imprumuturi_angajatid FOREIGN KEY (AngajatID) REFERENCES Angajati (AngajatID);


-- public.autoricarti definition

-- Drop table

-- DROP TABLE public.autoricarti;

CREATE TABLE public.autoricarti (
	carteid int4 NOT NULL,
	autorid int4 NOT NULL,
	rol varchar(50) NULL,
	CONSTRAINT autoricarti_pkey PRIMARY KEY (carteid, autorid),
	CONSTRAINT autoricarti_autorid_fkey FOREIGN KEY (autorid) REFERENCES public.autori(autorid),
	CONSTRAINT autoricarti_carteid_fkey FOREIGN KEY (carteid) REFERENCES public.carti(carteid)
);


-- public.cartiimprumutate definition

-- Drop table

-- DROP TABLE public.cartiimprumutate;

CREATE TABLE public.cartiimprumutate (
	imprumutid int4 NOT NULL,
	carteid int4 NOT NULL,
	datareturnare date NULL,
	CONSTRAINT cartiimprumutate_pkey PRIMARY KEY (imprumutid, carteid),
	CONSTRAINT cartiimprumutate_carteid_fkey FOREIGN KEY (carteid) REFERENCES public.carti(carteid),
	CONSTRAINT cartiimprumutate_imprumutid_fkey FOREIGN KEY (imprumutid) REFERENCES public.imprumuturi(imprumutid)
);


-- public.penalizari definition

-- Drop table

-- DROP TABLE public.penalizari;

CREATE TABLE public.penalizari (
	penalizareid int4 NOT NULL,
	imprumutid int4 NULL,
	carteid int4 NULL,
	cititorid int4 NULL,
	valoarepenalizare numeric(10, 2) NOT NULL,
	motivpenalizare varchar(255) NULL,
	datapenalizare date NOT NULL,
	CONSTRAINT penalizari_pkey PRIMARY KEY (penalizareid),
	CONSTRAINT penalizari_cititorid_fkey FOREIGN KEY (cititorid) REFERENCES public.cititori(cititorid),
	CONSTRAINT penalizari_imprumutid_carteid_fkey FOREIGN KEY (imprumutid,carteid) REFERENCES public.cartiimprumutate(imprumutid,carteid)
);



------------------------------------------------------------------------------------------------------
-------!!!!!Pentru P12!!!!--------------------
-------!!!!!A 2a parte a proiectului!!!!------
------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------
---Restrictii pentru Carti-----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- Restricție la nivel de atribut: ne asigurăm că 'DataAchizitiei' este în trecut
ALTER TABLE Carti ADD CONSTRAINT check_data_achizitie_past CHECK (DataAchizitiei <= CURRENT_DATE);

-- Restricție de unicitate: ne asigurăm că 'Cota' este unică în baza de date
ALTER TABLE Carti ADD CONSTRAINT unique_cota UNIQUE (Cota);

-- Restricție de validare la nivel de înregistrare: ne asigurăm că numărul de pagini este pozitiv
ALTER TABLE Carti ADD CONSTRAINT check_numar_pagini CHECK (NumarPagini > 0);

-- Funcție pentru obținerea numărului total de pagini pentru cărți dintr-o anumită categorie:

CREATE OR REPLACE FUNCTION TotalPaginiCategorie(categorie_id INT) RETURNS INT AS $$
DECLARE
    total_pagini INT;
BEGIN
    SELECT SUM(NumarPagini) INTO total_pagini
    FROM Carti
    JOIN Categoriicarti ON Carti.CarteID = Categoriicarti.CarteID
    WHERE Categoriicarti.CategorieID = categorie_id;
    RETURN total_pagini;
END;
$$ LANGUAGE plpgsql;

--Procedură pentru actualizarea editurii unei cărți:

CREATE OR REPLACE PROCEDURE SchimbaEdituraCarte(carte_id INT, noua_editura_id INT) AS $$
BEGIN
    UPDATE Carti SET EdituraID = noua_editura_id WHERE CarteID = carte_id;
END;
$$ LANGUAGE plpgsql


----------------------------------------------------------------------------------------------

--Gestionarea cheilor surogat pentru CarteID folosind secvențe: ----2, 3 chei

CREATE SEQUENCE carteid_seq START 1;

CREATE OR REPLACE FUNCTION assign_carteid() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.CarteID IS NULL
	THEN
        NEW.CarteID := NEXTVAL('carteid_seq');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_carte_insert
BEFORE INSERT ON Carti
FOR EACH ROW EXECUTE FUNCTION assign_carteid();

-- Crearea funcției care atribuie un CititorID unic din secvența creată--
CREATE SEQUENCE cititorid_seq 
    START WITH 1 
    INCREMENT BY 1;

CREATE OR REPLACE FUNCTION assign_cititorid() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.CititorID IS NULL THEN
        NEW.CititorID := NEXTVAL('cititorid_seq');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_cititor_insert
BEFORE INSERT ON Cititori
FOR EACH ROW EXECUTE FUNCTION assign_cititorid();

---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
----------Reguli de validare pentru verificarea limbii cărții:-------------------------
---------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION check_limba_cartii() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Limba NOT IN ('Engleză', 'Română', 'Franceză', 'Germană', 'Spaniolă') THEN
        RAISE EXCEPTION 'Limba cărții nu este acceptată.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_carte_insert_or_update
BEFORE INSERT OR UPDATE ON Carti
FOR EACH ROW EXECUTE FUNCTION check_limba_cartii();

------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Trigger pentru imprumuturi, daca cititorul intarzie o anumita perioada de timp, va fi sanctionat cu o anume suma
-------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION verifica_intarziere_si_penalizeaza() RETURNS TRIGGER AS $$
DECLARE
    zile_intarziere INT;
    valoare_penalizare DECIMAL;
BEGIN
    -- Calculul pentru numărul de zile de întârziere
    zile_intarziere := NEW.DataReturnare - (SELECT DataScadenta FROM Imprumuturi WHERE ImprumutID = NEW.ImprumutID);

    -- Determinarea valoarii penalizării în funcție de zilele de întârziere
    IF zile_intarziere BETWEEN 1 AND 7 THEN
        valoare_penalizare := 10;
    ELSIF zile_intarziere BETWEEN 8 AND 14 THEN
        valoare_penalizare := 30;
    ELSIF zile_intarziere BETWEEN 15 AND 31 THEN
        valoare_penalizare := 50;
    ELSIF zile_intarziere > 31 THEN
        valoare_penalizare := 100;
    ELSE
        RETURN NEW;
    END IF;

    -- Inseram penalizarea în tabela Penalizari
    INSERT INTO Penalizari (ImprumutID, CarteID, CititorID, ValoarePenalizare, MotivPenalizare, DataPenalizare)
    VALUES (NEW.ImprumutID, NEW.CarteID, (SELECT CititorID FROM Imprumuturi WHERE ImprumutID = NEW.ImprumutID), 
            valoare_penalizare, 'Întârziere la returnare', CURRENT_DATE);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_cartiimprumutate_update
AFTER UPDATE ON CartiImprumutate
FOR EACH ROW WHEN (OLD.DataReturnare IS DISTINCT FROM NEW.DataReturnare)
EXECUTE FUNCTION verifica_intarziere_si_penalizeaza();

-------------------------------------------------------------------------------------------------------------------
-----Trigger pentru numarul de carti imprumutate si numarul de carti de restituit----------------------------------
-------------------------------------------------------------------------------------------------------------------

ALTER TABLE Cititori
ADD COLUMN NrCartiImprumutate INT DEFAULT 0,
ADD COLUMN NrCartiDeRestituit INT DEFAULT 0;

-- Funcție pentru trigger-ul de împrumut
CREATE OR REPLACE FUNCTION incrementa_carti_imprumutate_si_de_restituit() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cititori 
    SET NrCartiImprumutate = NrCartiImprumutate + 1,
        NrCartiDeRestituit = NrCartiDeRestituit + 1
    WHERE CititorID = NEW.CititorID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger-ul de împrumut
CREATE TRIGGER after_imprumut_insert
AFTER INSERT ON Imprumuturi
FOR EACH ROW EXECUTE FUNCTION incrementa_carti_imprumutate_si_de_restituit();


-- Funcție pentru trigger-ul de returnare
CREATE OR REPLACE FUNCTION decrementa_carti_imprumutate_si_de_restituit() RETURNS TRIGGER AS $$
BEGIN
     IF OLD.DataReturnare IS DISTINCT FROM NEW.DataReturnare THEN
        UPDATE Cititori 
        SET NrCartiImprumutate = NrCartiImprumutate - 1,
            NrCartiDeRestituit = NrCartiDeRestituit - 1
        WHERE CititorID = NEW.CititorID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger-ul de returnare
CREATE TRIGGER after_imprumut_update
AFTER UPDATE ON Imprumuturi
FOR EACH ROW EXECUTE FUNCTION decrementa_carti_imprumutate_si_de_restituit();


-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
---Restrictii pentru Angajati---
-----------------------------------------------------------------------------------------------

-- Restricție la nivel de atribut: ne asigurăm că 'DataAngajarii' este în trecut
ALTER TABLE Angajati ADD CONSTRAINT check_date_past CHECK (DataAngajarii < CURRENT_DATE);


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
---INSERTURI---

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


--Angajati--
INSERT INTO Angajati (AngajatID, Nume, Prenume, DataAngajarii) VALUES
(1, 'Popescu', 'Ion', '2021-06-15'),
(2, 'Ionescu', 'Maria', '2020-08-01'),
(3, 'Vasilescu', 'Ana', '2022-01-10'),
(4, 'Constantinescu', 'Elena', '2021-09-01'),
(5, 'Marinescu', 'Dan', '2022-01-15'),
(6, 'Georgescu', 'Larisa', '2021-07-20');



--Tura--
INSERT INTO Tura (TuraID, AngajatID, Orelucrate, DescriereTaskuri) VALUES
(1, 1, 8, 'Preluare si sortare colete'),
(2, 2, 6, 'Inventar'),
(3, 3, 7, 'Asistenta clienti'),
(4, 4, 9, 'Catalogare'),
(5, 5, 5, 'Curățenie și organizare'),
(6, 6, 8, 'Ajutor la sala de lectură');



--Imprumuturi--
INSERT INTO Imprumuturi (ImprumutID, CititorID, AngajatID, DataImprumut, DataScadenta) VALUES
(1, 101, 1, '2023-03-15', '2023-04-15'),
(2, 102, 2, '2023-03-20', '2023-04-20'),
(3, 103, 1, '2023-03-25', '2023-04-25'),
(4, 104, 4, '2023-04-01', '2023-05-01'),
(5, 105, 5, '2023-04-05', '2023-05-05'),
(6, 106, 6, '2023-04-10', '2023-05-10');


--OperatiuniImprumut--
INSERT INTO OperatiuniImprumut (OperatiuneID, ImprumutID, TuraID, Timestamp) VALUES
(1, 1, 1, '2023-03-15 09:00:00'),
(2, 2, 2, '2023-03-20 10:00:00'),
(3, 3, 1, '2023-03-25 11:30:00'),
(4, 4, 4, '2023-04-01 09:30:00'),
(5, 5, 5, '2023-04-05 10:15:00'),
(6, 6, 6, '2023-04-10 11:00:00');


--Edituri--
INSERT INTO public.edituri (edituraid, numeeditura) VALUES
(1, 'Editura Litera'),
(2, 'Editura Humanitas'),
(3, 'Editura Polirom'),
(4, 'Editura Nemira'),
(5, 'Editura Cartea Românească'),
(6, 'Editura Corint');


--Adrese--
INSERT INTO public.adrese (adresaid, edituraid, adresa, oras, tara, telefon) VALUES
(1, 1, 'Strada Principala, Nr. 10', 'Bucuresti', 'Romania', '0210000001'),
(2, 2, 'Bd. Libertatii, Nr. 22', 'Cluj-Napoca', 'Romania', '0210000002'),
(3, 3, 'Strada Pacii, Nr. 5', 'Iasi', 'Romania', '0210000003'),
(4, 4, 'Strada Libertatii, Nr. 44', 'Timisoara', 'Romania', '0210000004'),
(5, 5, 'Bd. Revolutiei, Nr. 10', 'Constanta', 'Romania', '0210000005'),
(6, 6, 'Aleea Rozelor, Nr. 8', 'Sibiu', 'Romania', '0210000006');


--Autori--
INSERT INTO public.autori (autorid, mentorid, nume, prenume, datanasterii, nationalitate) VALUES
(1, NULL, 'Doe', 'John', '1980-01-01', 'Romana'),
(2, 1, 'Smith', 'Jane', '1985-05-05', 'Romana'),
(3, NULL, 'Brown', 'Mike', '1975-09-09', 'Romana'),
(4, 1, 'Albu', 'Andrei', '1972-11-30', 'Romana'),
(5, 2, 'Negrescu', 'Bianca', '1980-03-15', 'Romana'),
(6, 3, 'Enescu', 'Catalin', '1991-07-21', 'Romana');


--Carti--
INSERT INTO public.carti (carteid, cota, dataachizitiei, titlu, edituraid, limba, numarpagini) VALUES
(1, 'C-001', '2022-01-10', 'Istoria Lumii', 1, 'Română', 300),
(2, 'C-002', '2022-02-15', 'Enciclopedia Naturii', 2, 'Română', 500),
(3, 'C-003', '2022-03-20', 'Arta Culinară', 3, 'Română', 250),
(4, 'C-004', '2022-04-10', 'Poezii Alese', 4, 'Română', 120),
(5, 'C-005', '2022-05-15', 'Romanul Adolescentului Miop', 5, 'Română', 220),
(6, 'C-006', '2022-06-20', 'Amintiri din Copilarie', 6, 'Română', 150);


--Categorii--
INSERT INTO public.categorii (categorieid, numecategorie, categorieparinteid) VALUES
(1, 'Stiinta', NULL),
(2, 'Arta', NULL),
(3, 'Literatura', NULL),
(4, 'Poezie', NULL),
(5, 'Roman', NULL),
(6, 'Povestiri', NULL);


--Categoriicarti--
INSERT INTO public.categoriicarti (carteid, categorieid) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);


--Cititori--
INSERT INTO public.cititori (cititorid, nume, prenume, datanasterii, adresaid, telefon, email, datainregistrarii) VALUES
(101, 'Pop', 'Mihai', '1990-04-10', 1, '0720000001', 'mihai.pop@email.ro', '2023-01-01'),
(102, 'Ionescu', 'Elena', '1985-07-15', 2, '0720000002', 'elena.ionescu@email.ro', '2023-02-01'),
(103, 'Vasile', 'Ioana', '1995-11-20', 3, '0720000003', 'ioana.vasile@email.ro', '2023-03-01'),
(104, 'Dumitru', 'Laura', '1992-05-10', 4, '0720000004', 'laura.dumitru@email.ro', '2023-04-01'),
(105, 'Nicolescu', 'Bogdan', '1988-08-15', 5, '0720000005', 'bogdan.nicolescu@email.ro', '2023-05-01'),
(106, 'Stefanescu', 'Diana', '1996-12-20', 6, '0720000006', 'diana.stefanescu@email.ro', '2023-06-01');


--Imprumuturi--
INSERT INTO public.imprumuturi (imprumutid, cititorid, dataimprumut, datascadenta) VALUES
(1, 101, '2023-03-15', '2023-04-15'),
(2, 102, '2023-03-20', '2023-04-20'),
(3, 103, '2023-03-25', '2023-04-25'),
(4, 104, '2023-04-01', '2023-05-01'),
(5, 105, '2023-04-05', '2023-05-05'),
(6, 106, '2023-04-10', '2023-05-10');


--Publicatii--
INSERT INTO public.publicatii (publicatieid, autorid, titlu, tippublicatie) VALUES
(1, 1, 'Viata pe Marte', 'Carte'),
(2, 2, 'Secretele Oceanului', 'Revista'),
(3, 3, 'Călătorii în timp', 'Jurnal'),
(4, 4, 'Misterele Naturii', 'Carte'),
(5, 5, 'Istoria Artei Moderne', 'Revista'),
(6, 6, 'Descoperiri Stiintifice', 'Jurnal');


--Recenzii--
INSERT INTO public.recenzii (recenzieid, carteid, cititorid, rating, textrecenzie, datarecenzie) VALUES
(1, 1, 101, 5, 'O carte extraordinara!', '2023-04-01'),
(2, 2, 102, 4, 'Foarte informativa.', '2023-04-05'),
(3, 3, 103, 3, 'Interesantă, dar greu de citit.', '2023-04-10'),
(4, 4, 104, 5, 'Fascinantă și captivantă!', '2023-04-15'),
(5, 5, 105, 4, 'Bine documentată, dar lungă.', '2023-04-20'),
(6, 6, 106, 3, 'Interesantă, dar cu un stil greoi.', '2023-04-25');


--ReceptiiCarti--
INSERT INTO ReceptiiCarti (ReceptieID, CarteID, AngajatID, DataReceptie) VALUES
(1, 1, 1, '2023-03-01'),
(2, 2, 2, '2023-03-05'),
(3, 3, 3, '2023-03-10'),
(4, 4, 4, '2023-03-15'),
(5, 5, 5, '2023-03-20'),
(6, 6, 6, '2023-03-25');


--Reclamatii--
INSERT INTO Reclamatii (ReclamatieID, CititorID, Descriere, SursaReclamatie, StatusReclamatie, DataReclamatie) VALUES
(1, 101, 'Cartea primită este deteriorată', 'Cititor', 'Deschisa', '2023-04-01 10:00:00'),
(2, 102, 'Întârziere în procesarea împrumutului', 'Biblioteca', 'In Proces', '2023-04-02 11:30:00'),
(3, 103, 'Eroare în catalogul online', 'Cititor', 'Rezolvata', '2023-04-03 09:20:00'),
(4, 104, 'Lipsă marcatori de pagină', 'Cititor', 'Deschisa', '2023-04-10 12:00:00'),
(5, 105, 'Întârziere în răspunsul la solicitare', 'Biblioteca', 'In Proces', '2023-04-15 14:30:00'),
(6, 106, 'Sistemul online este indisponibil', 'Cititor', 'Rezolvata', '2023-04-20 16:20:00');


--Penalizari--
INSERT INTO Penalizari (penalizareid, imprumutid, carteid, cititorid, valoarepenalizare, motivpenalizare, datapenalizare) VALUES
(1, 1, 1, 101, 10.00, 'Intarziere', '2023-04-16'),
(2, 2, 2, 102, 30.00, 'Intarziere', '2023-04-22'),
(3, 3, 3, 103, 50.00, 'Intarziere', '2023-05-01'),
(4, 4, 4, 104, 10.00, 'Intarziere', '2023-05-02'),
(5, 5, 5, 105, 30.00, 'Intarziere', '2023-05-07'),
(6, 6, 6, 106, 50.00, 'Intarziere', '2023-05-12');


--Autoricarti--
INSERT INTO Autoricarti (carteid, autorid, rol) VALUES
(1, 1, 'Autor principal'),
(2, 2, 'Co-autor'),
(3, 3, 'Editor'),
(4, 4, 'Autor principal'),
(5, 5, 'Co-autor'),
(6, 6, 'Editor');


--Cartiimprumutate--
INSERT INTO Cartiimprumutate (imprumutid, carteid, datareturnare) VALUES
(1, 1, '2023-04-15'),
(2, 2, '2023-04-20'),
(3, 3, '2023-04-25'),
(4, 4, '2023-05-02'),
(5, 5, '2023-05-07'),
(6, 6, '2023-05-12');

