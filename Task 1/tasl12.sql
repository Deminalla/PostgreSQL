-- 1. visu egzemplioriu, paimtu pries konkretu skaiciu dienu, numeriai, paemimo ir grazinimo datos
SELECT nr, paimta, grazinti 
FROM stud.egzempliorius 
WHERE paimta < CURRENT_DATE -1;

-- 2. vardai ir pavardes visu autoriu, kuriu knygas yra paemes bent vienas skaitytojas
SELECT DISTINCT vardas, pavarde
FROM stud.autorius
INNER JOIN stud.egzempliorius
ON stud.autorius.isbn = stud.egzempliorius.isbn 
WHERE stud.egzempliorius.skaitytojas IS NOT NULL;