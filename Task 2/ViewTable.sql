-- kiek kiekvienas klientas turi uzsakymu
CREATE VIEW KlientuUzsakymuSK 
AS SELECT K.AsmensKodas,  
 (SELECT COUNT(*) 
 FROM Uzsakymai AS U
 WHERE K.AsmensKodas = U.KlientoAK
 ) AS UzsakymuSK 
FROM Klientai AS K;


CREATE VIEW NesumoketiUzsakymai 
AS SELECT UzsakymoNr, KlientoAK, Kaina
FROM Uzsakymai
WHERE Sumoketa = FALSE;


CREATE VIEW TrukstamiProduktai
AS SELECT Pavadinimas
FROM Produktai
WHERE Kiekis <= 3; -- kad ju yra mazai 
