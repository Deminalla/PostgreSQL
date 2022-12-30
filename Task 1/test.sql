--kiek atveju vardas prasideda J
SELECT COUNT(DISTINCT isbn) 
FROM stud.autorius
WHERE lower(vardas) LIKE 'j%';


SELECT Round(AVG(verte))
FROM stud.knyga
WHERE (puslapiai BETWEEN 300 AND 500) AND metai IN(2007, 2015, 2017);


SELECT pavadinimas, verte,
CASE WHEN verte>20 THEN 'brangu'
ELSE 'pigu'
END AS apibendrinimas
FROM stud.knyga;


-- kiek zmoniu skaito kiekviena knyga
SELECT pavadinimas, COUNT(skaitytojas) AS "skaitytoju kiekis"
FROM stud.egzempliorius
INNER JOIN stud.knyga
ON stud.egzempliorius.isbn = stud.knyga.isbn
WHERE grazinti IS NOT NULL AND paimta IS NOT NULL
GROUP BY pavadinimas
ORDER BY 2 DESC;


--nuo kurio index prasideda on varduose (jei nera tai 0)
SELECT DISTINCT vardas, POSITION('on' IN lower(vardas)) AS pozicija
FROM stud.skaitytojas;


--egzemplioriai kuriame 1 ir 5 nr sutampa
SELECT se.nr, vardas, pavarde, pavadinimas
FROM stud.egzempliorius AS se
LEFT JOIN stud.skaitytojas
ON se.skaitytojas=stud.skaitytojas.nr, stud.knyga
WHERE substring(CAST(se.nr AS TEXT) from 1 for 1) = substring(CAST(se.nr AS TEXT) from 5 for 5)
AND se.isbn = stud.knyga.isbn;

--------------------------------
-- when both name and surname match in both tables
SELECT vardas, pavarde 
FROM stud.autorius
INTERSECT 
SELECT vardas, pavarde 
FROM stud.skaitytojas;

-- all Jonas from both tables
SELECT vardas, pavarde 
FROM stud.autorius
WHERE vardas = 'Jonas'
UNION
SELECT vardas, pavarde 
FROM stud.skaitytojas
WHERE vardas = 'Jonas';

SELECT isbn, MIN(grazinti)
FROM stud.egzempliorius
GROUP BY isbn
ORDER BY 2;

-- return ak,... if their nr exists in egz (will only print out the ones that are in egz)
-- can do this with join
SELECT ak, vardas, pavarde
FROM stud.skaitytojas
WHERE EXISTS (
	SELECT skaitytojas 
	FROM stud.egzempliorius
	WHERE skaitytojas = stud.skaitytojas.nr
	);

-- will return the nr that are inside egz
-- could do this with join
SELECT nr
FROM stud.skaitytojas
WHERE nr = ANY(
	SELECT skaitytojas
	FROM stud.egzempliorius
);

-- kiekvieniems isleidimo metams, pupuliariausia knyga
WITH kiekis AS( -- how much each book was read
	SELECT k.isbn, k.metai, k.pavadinimas, COUNT(*) AS skaityta
	FROM stud.egzempliorius AS se, stud.knyga AS k
	WHERE paimta IS NOT NULL
	AND se.isbn = k.isbn
	GROUP BY k.isbn
	)
SELECT metai, MAX(skaityta)
FROM kiekis
GROUP BY metai;


----------------------------
-- kiekvienai leidyklai skaicius autoriu, isleidusiu joje bent viena knyga
SELECT leidykla, COUNT(autorius.isbn)
FROM stud.knyga AS knyga
LEFT JOIN stud.autorius AS autorius
ON knyga.isbn = autorius.isbn
GROUP BY leidykla;

-- pavadinimai ir isbn knygu, kuriu skaitytoju amziaus vidurkis yra mazesnis uz visu knygu skaitanciuju amziaus vidurki. 
-- greta pateikti ir tu knygu skaitanciuju amziaus vidurkius
WITH amzius AS (
	SELECT isbn, EXTRACT(YEAR FROM(AGE(CURRENT_DATE, gimimas))) AS metai
	FROM stud.egzempliorius 
	JOIN stud.skaitytojas
	ON stud.egzempliorius.skaitytojas = stud.skaitytojas.nr
)
SELECT pavadinimas, knyga.isbn, AVG(amzius.metai)
FROM stud.knyga AS knyga
JOIN amzius
ON knyga.isbn = amzius.isbn
GROUP BY knyga.isbn
HAVING AVG(amzius.metai) < (
	SELECT AVG(metai) -- 19.9375
	FROM amzius);

---------------------------------
-- Gabrieles

-- kiekvienai knygai, kurios pavadinimas prasideda priebalsiu, isbn ir jos egzempliorius skaitanciu skaitytoju amziaus vidurkis
SELECT E.isbn, AVG(EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, S.Gimimas))) -- gets the year from the differenceFROM stud.Egzempliorius AS E    JOIN stud.Skaitytojas AS S ON E.Skaitytojas = S.NR    JOIN stud.Knyga AS K ON E.ISBN = K.ISBNWHERE     E.Skaitytojas IS NOT NULL     AND LEFT(Pavadinimas,1) IN ('B','C','D','F','G','H','J','K','L','M','N','P','R','S','T','V','Z') -- left here extracts first 1 char from pavadinimas GROUP BY E.isbn;


-- pavadinimai knygu, kuriu egzemplioriu bibliotekoje yra maziau uz visu knygu egzemplioriu skaiciu vidurki
WITH egzVidurkis AS (
	SELECT isbn, COUNT(*) AS yraEgz
	FROM stud.egzempliorius
	GROUP BY isbn
)
SELECT pavadinimas, knyga.isbn
FROM stud.knyga AS knyga
JOIN egzVidurkis
ON knyga.isbn = egzVidurkis.isbn
WHERE yraEgz < (
	SELECT AVG(yraEgz)
	FROM egzVidurkis
);


