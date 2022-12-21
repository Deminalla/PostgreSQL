INSERT INTO Produktai
	(Pavadinimas, Kaina, TurimasKiekis)
	VALUES('Anglis', 5.99, 872),
			('Bambukas',10.11, 150),
			('Vinys',0.99, 11),
			('Cementas', 2.78, 9000),
			('Vilna', 7.94, 345);
INSERT INTO Produktai
	(Pavadinimas, Kaina, TurimasKiekis)
	VALUES ('Lipnia Juosta', 2.78, -2); -- fail

		
INSERT INTO Klientai
	(AsmensKodas, Vardas, Pavarde, TelefonoNr, Amzius)
	VALUES(11111111111, 'Alma', 'Gaigalaite', 37064789102, 46),
			(12121212365, 'Tomas', 'Jonaitis', 37065208951, 39),
			(64897589632, 'Rytis', 'Rytukas', 37065741023, 15),
			(85469789650, 'Melinda', 'Kurnaite', 37069510357, 21);	
INSERT INTO Klientai
	(AsmensKodas, Vardas, Pavarde, TelefonoNr, Amzius)
	VALUES(123549, 'Alma', 'Gaigalaite', 37064789102, 46); -- error
	
			
INSERT INTO Imones
	(Pavadinimas, Miestas, Gatve)
	VALUES('Baldai jums', 'Vilnius', 'Gostauto 5'),
			('Menika', 'Klaipeda', 'Kauno 7'),
			('Rastinukas', 'Alytus', 'Vytauto 48');
	
			
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Statusas, Sumoketa)
	VALUES(11111111111, 37.78, 2, 'Pradetas', TRUE),
			(12121212365, 22.78, 2, 'Baigtas', True),
			(85469789650, 47.11, 1, 'Pradetas', True);
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr)
	VALUES(11111111111, 74.45, 1);
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Sumoketa)
	VALUES(64897589632, 12.47, 3, TRUE);
INSERT INTO Uzsakymai
	(KlientoAK, Kaina, ImonesNr, Statusas)
	VALUES(11111111111, 37.78, 2, 'NOP'); -- error


INSERT INTO YraUzsakyme
	(UzsakymoNr, ProduktoPavadinimas, Kiekis)
	VALUES(7, 'Anglis', 15),
			(7, 'Bambukas', 4),
			(8, 'Vinys', 2),
			(9, 'Bambukas', 7),
			(9, 'Vinys', 3),
			(9, 'Cementas', 200),
			(10, 'Cementas', 4),
			(11, 'Bambukas', 4);