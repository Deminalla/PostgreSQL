CREATE TABLE Produktai(
	Pavadinimas VARCHAR(70) NOT NULL,
	Kaina DECIMAL(8,2) NOT NULL,
	TurimasKiekis BIGINT DEFAULT 1, -- DEFAULT 
	PRIMARY KEY (Pavadinimas),
	CONSTRAINT TeigiamasKiekis CHECK(Kiekis >= 0) 
);

CREATE TABLE Klientai(
	AsmensKodas BIGINT NOT NULL, -- 11 digits
	Vardas VARCHAR(50) NOT NULL,
	Pavarde VARCHAR(50) NOT NULL,
	TelefonoNr BIGINT NOT NULL,
	Amzius INTEGER NOT NULL, 
	PRIMARY KEY(AsmensKodas),
	CONSTRAINT TinkamasAmzius CHECK(Amzius > 12), 
	CONSTRAINT TinkamasAK CHECK(AsmensKodas >= 10000000000 AND AsmensKodas<= 99999999999) -- 11 digits
);

CREATE TABLE Imones(
	ImonesNr BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Pavadinimas VARCHAR(300) NOT NULL,
	Miestas VARCHAR(70) NOT NULL,
	Gatve VARCHAR(70) NOT NULL,
	PRIMARY KEY (ImonesNr)
);

CREATE TABLE Uzsakymai(
	UzsakymoNr BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1), 
	KlientoAK BIGINT NOT NULL,
	UzsakymoData TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- DEFAULT
	Kaina DECIMAL(8,2) NOT NULL,
	ImonesNr BIGINT,
	Statusas VARCHAR(30) DEFAULT 'Nepradetas' NOT NULL, -- DEFAULT 
	Sumoketa BOOLEAN NOT NULL DEFAULT FALSE, -- DEFAULT
	PRIMARY KEY (UzsakymoNr),
	CONSTRAINT IKlientai FOREIGN KEY (KlientoAK) REFERENCES Klientai ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT IImonei FOREIGN KEY (ImonesNr) REFERENCES Imones ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT TinkamasStatusas CHECK(Statusas IN ('Nepradetas', 'Pradetas', 'Baigtas')) -- CHECK
);

CREATE TABLE YraUzsakyme(
	UzsakymoNr BIGINT NOT NULL,
	ProduktoPavadinimas VARCHAR(70) NOT NULL,
	Kiekis BIGINT,
	PRIMARY KEY(UzsakymoNr, ProduktoPavadinimas),
	CONSTRAINT IUzsakymai FOREIGN KEY (UzsakymoNr) REFERENCES Uzsakymai ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT IProduktai FOREIGN KEY (ProduktoPavadinimas) REFERENCES Produktai ON DELETE CASCADE ON UPDATE RESTRICT 
);

-- indexes
CREATE UNIQUE INDEX IndexImonesPavadinimas ON Imones(Pavadinimas);
CREATE INDEX IndexVardPav ON Klientai(Pavarde); -- allows duplicate values

