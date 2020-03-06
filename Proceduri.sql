USE DunderMifflin;

CREATE TABLE Versiuni
(cod_v INT PRIMARY KEY IDENTITY,
versiune INT);

INSERT INTO Versiuni (versiune)
values(0);

--modifica tipul unei coloane 
GO
CREATE PROCEDURE uspV1
AS
BEGIN
ALTER TABLE Employees 
Alter COLUMN last_name VARCHAR(30);
PRINT 'Am modificat tipul coloanei last_name din varchar(20) in varchar(30)';
END
 
 
--modifica tipul unei coloane din big int in int
GO
CREATE PROCEDURE uspUndoV1
AS
BEGIN
ALTER TABLE Employees 
Alter COLUMN last_name VARCHAR(20);
PRINT 'Am modificat tipul coloanei cod_s din varchar(30) in varchar(20)';
END

--adauga o constrangere de valoare implicita pentru un camp
GO
CREATE PROCEDURE uspV2
AS
BEGIN
ALTER TABLE Orders
ADD CONSTRAINT ConstrangereData DEFAULT GETDATE() FOR order_date;
PRINT 'Am adaugat constrangere default la campul order_date in tabelul Orders';
END

--adauga o constrangere de valoare implicita pentru un camp
GO
CREATE PROCEDURE uspUndoV2
AS
BEGIN
ALTER TABLE Orders
DROP CONSTRAINT ConstrangereData
PRINT 'Am sters constrangerea default a campului order_date';
END

--creeaza/sterge o tabela
GO
CREATE PROCEDURE uspV3
AS
BEGIN
CREATE TABLE CARTON
(cod_c INT PRIMARY KEY IDENTITY,
culoare VARCHAR(20));
PRINT 'Am adaugat tabelul Cartoane';
END

--creeaza/sterge o tabela
GO
CREATE PROCEDURE uspUndoV3
AS
BEGIN
DROP TABLE CARTON;
PRINT 'Am sters tabelul Cartoane';
END

--adauga un camp nou
GO
CREATE PROCEDURE uspV4
AS 
BEGIN
ALTER TABLE CARTON
ADD cod_cat INT;
PRINT 'Am adaugat la tabelul cartoane campul cod_cat';
END

--sterge camp
GO
CREATE PROCEDURE uspUndoV4
AS 
BEGIN
ALTER TABLE CARTON
DROP COLUMN cod_cat;
PRINT 'Am sters campul cod_cat din tableul cartoane';
END

DROP PROCEDURE uspV5;
DROP PROCEDURE uspUndoV5;
--creeaza/sterge o constrangere de cheie straina
GO 
CREATE PROCEDURE uspV5
AS
BEGIN
ALTER TABLE CARTON
ADD CONSTRAINT fk_CartonCat FOREIGN KEY (cod_cat) REFERENCES Category(cod_cat);
PRINT 'Am adaugat foreign key la cod_Cat in tabelul cartoane';
END;

GO 
CREATE PROCEDURE uspUndoV5
AS
BEGIN
ALTER TABLE CARTON
DROP CONSTRAINT fk_CartonCat;
PRINT 'Am sters constrangerea de foreign key din tabelul cartoane';
END;


Drop PROCEDURE modificaVersiune;

CREATE PROCEDURE modificaVersiune (@versiuneNoua INT)
AS
BEGIN
DECLARE @versiuneVeche INT
DECLARE @vers VARCHAR(10)
SELECT TOP 1 @versiuneVeche=versiune
FROM Versiuni
IF @versiuneNoua<0 OR @versiuneNoua>5
BEGIN
	PRINT 'Versiunea trebuie sa fie intre 1 si 5!'
END
ELSE
BEGIN
	IF @versiuneVeche < @versiuneNoua
	BEGIN
		SET @versiuneVeche = @versiuneVeche+1
		WHILE @versiuneVeche <=@versiuneNoua
		BEGIN
			SET @vers = 'uspV' + CONVERT(VARCHAR(10),@versiuneVeche)
			EXEC @vers
			PRINT 'S-a executat '+@vers
			SET @versiuneVeche=@versiuneVeche+1
			UPDATE Versiuni
			SET versiune=@versiuneVeche
		END
	END
	ELSE
	BEGIN
		WHILE @versiuneVeche > @versiuneNoua
		BEGIN
			SET @vers= 'uspUndoV' + CONVERT(VARCHAR(10),@versiuneVeche)
			EXEC @vers
			PRINT 'Executata procedura '+@vers
			SET @versiuneVeche=@versiuneVeche-1
			UPDATE Versiuni
			SET versiune=@versiuneVeche
		END
	END
END

END;

EXEC modificaVersiune 5;
EXEC modificaVersiune 0;

Select * FROM Versiuni 
