-- Oppgave 1

--a

SELECT * FROM ordredetalj 
JOIN ordrehode ON ordredetalj.ordrenr = ordrehode.ordrenr
AND ordrehode.levnr = 44;

--b

SELECT navn, levby from levinfo 
LEFT JOIN  ordrehode ON levinfo.levnr = ordrehode.levnr = levinfo.levnr 
LEFT JOIN ordredetalj on ordredetalj.ordrenr = ordrehode.ordrenr AND ordrehode.delnr = 1;

--c


SELECT navn, prisinfo.levnr, MIN(pris) as "pris" from levinfo 
INNER JOIN  prisinfo ON levinfo.levnr = prisinfo.levnr AND prisinfo.delnr = 201 
GROUP BY pris, navn, prisinfo.levnr;

--d

SELECT ordrehode.ordrenr , dato, beskrivelse, kvantum, pris, (kvantum*pris) as 'belop' from ordrehode 
JOIN ordredetalj ON ordrehode.ordrenr = ordredetalj.ordrenr 
JOIN prisinfo ON ordredetalj.delnr = prisinfo.delnr
JOIN delinfo ON ordredetalj.delnr = delinfo.delnr
AND ordrehode.ordrenr = 16
LIMIT 1;

--e

SELECT delnr, levnr FROM prisinfo
WHERE pris > (
  SELECT pris FROM prisinfo
  WHERE katalognr = 'X7770'
);


--f

CREATE TABLE fylke_by(
  fylke_by_id INT NOT NULL,
  levby   VARCHAR(20) NOT NULL,
	fylke   VARCHAR(20) NOT NULL,
	CONSTRAINT fylke_pk PRIMARY KEY(fylke_by_id)
  );

CREATE TABLE levinfo_2( 
  levnr INTEGER, 
  navn VARCHAR(20) NOT NULL, 
  adresse VARCHAR(20) NOT NULL, 
  fylke_by_id INT NOT NULL, 
  postnr INTEGER NOT NULL, 
  CONSTRAINT levinfo_pk PRIMARY KEY(levnr), 
  CONSTRAINT fylke_by_fk FOREIGN KEY(fylke_by_id) REFERENCES fylke_by(fylke_by_id));

INSERT INTO fylke_by VALUES(1 , 'OSLO','OSLO');
INSERT INTO  levinfo_2 VALUES(1 , 'Hermann','HHHHHHH',1, '1274');

--ii

CREATE VIEW levinfo_fylke AS
SELECT levnr,navn,adresse,postnr,levby,fylke FROM levinfo_2 
JOIN fylke_by ON levinfo_2.fylke_by_id = fylke_by.fylke_by_id;

--g

SELECT levby FROM levinfo
LEFT JOIN prisinfo ON levinfo.levnr = prisinfo.levnr 
GROUP BY levinfo.levby 
HAVING prisinfo.delnr IS NULL;

--h

CREATE VIEW ordre_18 as
SELECT levinfo.levnr,ordredetalj.ordrenr, (ordredetalj.kvantum*pris) as 'belop' 
FROM ordredetalj 
JOIN prisinfo ON ordredetalj.delnr = prisinfo.delnr
JOIN levinfo ON prisinfo.levnr = levinfo.levnr
AND ordrenr = 18;

SELECT levnr, min(b) as min_belop FROM (
SELECT levnr , SUM(belop) as b , COUNT(levnr) as c
FROM ordre_18
GROUP BY levnr
HAVING c = 2;
) GROUP BY levnr
LIMIT 1;

--oppgave 2

--a

SELECT * FROM forlag
WHERE telefon LIKE '2%'
UNION ALL
SELECT * FROM forlag
WHERE telefon NOT LIKE '2%';

--b

SELECT ROUND(AVG(avg_leve_tid),0) as avg_leve_tid FROM (
SELECT AVG(YEAR(CURRENT_DATE)-fode_aar) as 'avg_leve_tid' FROM forfatter 
WHERE fode_aar IS NOT NULL
UNION ALL
SELECT AVG(dod_aar-fode_aar) as 'avg_leve_tid' FROM forfatter 
WHERE fode_aar IS NOT NULL AND dod_aar IS NOT NULL
)avg_leve_tid;

--c

SELECT (COUNT(avg_leve_tid) / (SELECT COUNT(*) FROM forfatter)) *100 as prosent FROM (
SELECT COUNT(YEAR(CURRENT_DATE)-fode_aar) as 'avg_leve_tid' FROM forfatter 
WHERE fode_aar IS NOT NULL
UNION ALL
SELECT COUNT(dod_aar-fode_aar) as 'avg_leve_tid' FROM forfatter 
WHERE fode_aar IS NOT NULL AND dod_aar IS NOT NULL
)avg_leve_tid;




