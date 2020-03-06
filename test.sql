USE DunderMifflin;

CREATE TABLE Brand1
(cod_b INT PRIMARY KEY IDENTITY(1,1),
brand_name VARCHAR(50) NOT NULL,
postalCode VARCHAR(10),
city VARCHAR(20),
street VARCHAR(50),
email VARCHAR(30) NOT NULL,
phone VARCHAR(13)
);

CREATE TABLE Category1
(cod_cat INT PRIMARY KEY IDENTITY(1,1),
category_name VARCHAR(40) NOT NULL
);

CREATE TABLE Product1
(cod_p INT PRIMARY KEY IDENTITY(1,1),
product_name VARCHAR(50) NOT NULL,
price FLOAT,
cod_b INT FOREIGN KEY REFERENCES Brand1(cod_b),
CONSTRAINT FK_ProductBrand1 FOREIGN KEY (cod_b) REFERENCES Brand1(cod_b) ON DELETE CASCADE ON UPDATE CASCADE,
cod_cat INT FOREIGN KEY REFERENCES Category1(cod_cat)
);

CREATE TABLE Store1
(cod_s INT PRIMARY KEY IDENTITY(1,1),
postalCode VARCHAR(10),
city VARCHAR(30),
street VARCHAR(50),
email VARCHAR(30),
phone VARCHAR(13)
);

CREATE TABLE Stock1
(cod_s INT FOREIGN KEY REFERENCES Store1(cod_s),
cod_p INT FOREIGN KEY REFERENCES Product1(cod_p),
quantity INT
CONSTRAINT pk_Stock1 PRIMARY KEY (cod_s,cod_p)
);



