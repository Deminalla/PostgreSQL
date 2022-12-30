-- 3. Kiekvienai datai, kada buvo paimtas bent vienas egzempliorius, visų paimtų knygų ir visų jas paėmusių skaitytojų skaičiai.
SELECT paimta, COUNT(nr) AS knygos, COUNT(DISTINCT skaitytojas) AS skaitytojai
FROM stud.egzempliorius
WHERE paimta IS NOT NULL
GROUP BY paimta
HAVING COUNT(nr) > 2; -- for example


-- 4. Kiekvienai knygai (pavadinimas, ISBN) jauniausio jos skaitytojo AK ir gimimo data. 
WITH es AS (
	SELECT isbn, MAX(gimimas) AS max -- 
   FROM stud.egzempliorius, stud.skaitytojas
   WHERE stud.egzempliorius.skaitytojas = stud.skaitytojas.nr --important to do this
   GROUP BY isbn
   )
SELECT pavadinimas, knyga.isbn, ak, es.max
FROM es
JOIN stud.skaitytojas AS skait 
ON es.max = skait.gimimas
RIGHT JOIN stud.knyga AS knyga
ON es.isbn = knyga.isbn;

------------------------------------------------------
--TESTAI

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
----------------------------

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

-- kiekvieniems isleidimo metams, pupuliariausia knyga ir ju skaitytojai
WITH kiekis AS( -- how much each book was read
	SELECT k.isbn, k.metai, k.pavadinimas, COUNT(*) AS skaityta
	FROM stud.egzempliorius AS se, stud.knyga AS k
	WHERE paimta IS NOT NULL
	AND se.isbn = k.isbn
	GROUP BY k.isbn
	)
, skait AS ( -- most popular book
	SELECT metai, MAX(skaityta) AS populiaru
	FROM kiekis
	GROUP BY metai
)
SELECT kiekis.metai, populiaru, skaitytojas, vardas, pavarde
FROM skait
JOIN kiekis
ON kiekis.metai = skait.metai AND skait.populiaru = kiekis.skaityta-- kad pridet populiaru
JOIN stud.egzempliorius AS se
ON kiekis.isbn = se.isbn -- kad paskui galeciau pridet vardas, pavarde
JOIN stud.skaitytojas
ON se.skaitytojas = stud.skaitytojas.nr
ORDER BY 1;

WITH kiekis AS( -- how much each book was read
	SELECT k.isbn, k.metai, k.pavadinimas, COUNT(*) AS skaityta
	FROM stud.egzempliorius AS se, stud.knyga AS k
	WHERE paimta IS NOT NULL
	AND se.isbn = k.isbn
	GROUP BY k.isbn
	)
, skait AS ( -- most popular book
	SELECT knyga.metai, MAX(skaityta) AS populiaru
	FROM stud.knyga AS knyga
	JOIN kiekis
	ON knyga.isbn = kiekis.isbn
	GROUP BY knyga.metai
)
SELECT kiekis.metai, populiaru, skaitytojas, vardas, pavarde
FROM skait
JOIN kiekis
ON kiekis.metai = skait.metai -- kad pridet populiaru
JOIN stud.egzempliorius AS se
ON kiekis.isbn = se.isbn -- kad paskui galeciau pridet vardas, pavarde
JOIN stud.skaitytojas
ON se.skaitytojas = stud.skaitytojas.nr
ORDER BY 1;

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


ITH kiekis AS( -- how much each book was read
	SELECT k.isbn, k.metai, k.pavadinimas, COUNT(*) AS skaityta, skaitytojas
	FROM stud.egzempliorius AS se, stud.knyga AS k
	WHERE paimta IS NOT NULL
	AND se.isbn = k.isbn
	GROUP BY k.isbn
	)
SELECT metai, MAX(skaityta)
FROM kiekis
GROUP BY metai;