-- kai reikalingas produktas uzsakymui, sumazint produkto kieki is Produktai entity
CREATE FUNCTION SumazintiKieki() 
RETURNS TRIGGER AS
	$$
	BEGIN
		IF((SELECT P.TurimasKiekis - NEW.Kiekis
	FROM Produktai as P
	WHERE P.Pavadinimas = NEW.ProduktoPavadinimas) < 0)
		THEN 
			RAISE EXCEPTION 'Uzsakymas virsyja turimu produktu kieki';
		END IF;
		IF((SELECT P.TurimasKiekis - NEW.Kiekis
	FROM Produktai as P
	WHERE P.Pavadinimas = NEW.ProduktoPavadinimas) >= 0)
		THEN 
			UPDATE Produktai
			SET TurimasKiekis = TurimasKiekis - NEW.Kiekis -- sumazinti kieki turimu produktu
			WHERE Produktai.Pavadinimas = NEW.ProduktoPavadinimas;
		END IF;	
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	
CREATE TRIGGER NaujoProduktoUzsakymas
BEFORE INSERT ON YraUzsakyme -- iterpiant nauja eilute i entity
FOR EACH ROW
EXECUTE FUNCTION SumazintiKieki();


--Create new order
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Statusas)
	VALUES(85469789650, 17.78, 3, 'Pradetas');

--View order number
SELECT * FROM Uzsakymai; -- 13
--Sukuriame uzsakyma
INSERT INTO YraUzsakyme
	(UzsakymoNr, ProduktoPavadinimas, Kiekis)
	VALUES(13, 'Vinys', 50); -- yra 11 -- error

INSERT INTO YraUzsakyme
	(UzsakymoNr, ProduktoPavadinimas, Kiekis)
	VALUES(13, 'Anglis', 13); -- buvo 872, now 859


--------------------------------------------------------------
-- Jokia imone vienu metu negali paimti daugiau nei 4 uzsakymu
CREATE FUNCTION MaxUzsakymuSkaciusImonei()
RETURNS TRIGGER AS
$$
BEGIN
IF(SELECT COUNT(*) FROM Uzsakymai
	  WHERE Uzsakymai.ImonesNr = NEW.ImonesNr) >= 4
THEN 
	RAISE EXCEPTION 'Virsytas uzsakymu skaicius vienai imonei';
END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- kviecia kiekviena kart iterpiant ar modifikuojant
CREATE TRIGGER MaxUzsakymuSkaicius
BEFORE INSERT OR
		 UPDATE OF ImonesNr ON Uzsakymai -- cia modifikuojant ImonesNr reiksme
FOR EACH ROW
EXECUTE PROCEDURE MaxUzsakymuSkaciusImonei();

----------------

--Check imones count
SELECT ImonesNr, COUNT(*)
FROM Uzsakymai
GROUP BY ImonesNr;

--Update values
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Statusas)
	VALUES(64897589632, 49.33, 3, 'Pradetas'),
			(12121212365, 87.22, 3, 'Pradetas');

INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Statusas)
	VALUES(12121212365, 46.81, 3, 'Pradetas'); -- error