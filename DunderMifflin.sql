CREATE DATABASE DunderMifflin;
USE DunderMifflin;

CREATE TABLE Brand
(cod_b INT PRIMARY KEY IDENTITY(1,1),
brand_name VARCHAR(50) NOT NULL,
postalCode VARCHAR(10),
city VARCHAR(20),
street VARCHAR(50),
email VARCHAR(30) NOT NULL,
phone VARCHAR(13)
);

CREATE TABLE Category
(cod_cat INT PRIMARY KEY IDENTITY(1,1),
category_name VARCHAR(40) NOT NULL
);

CREATE TABLE Product
(cod_p INT PRIMARY KEY IDENTITY(1,1),
product_name VARCHAR(50) NOT NULL,
price FLOAT,
cod_b INT FOREIGN KEY REFERENCES Brand(cod_b),
CONSTRAINT FK_ProductBrand FOREIGN KEY (cod_b) REFERENCES Brand(cod_b) ON DELETE CASCADE ON UPDATE CASCADE,
cod_cat INT FOREIGN KEY REFERENCES Category(cod_cat)
);

CREATE TABLE Store 
(cod_s INT PRIMARY KEY IDENTITY(1,1),
postalCode VARCHAR(10),
city VARCHAR(30),
street VARCHAR(50),
email VARCHAR(30),
phone VARCHAR(13)
);

CREATE TABLE Stock
(cod_s INT FOREIGN KEY REFERENCES Store(cod_s),
cod_p INT FOREIGN KEY REFERENCES Product(cod_p),
quantity INT
CONSTRAINT pk_Stock PRIMARY KEY (cod_s,cod_p)
);

CREATE TABLE Employees
(cod_e INT PRIMARY KEY IDENTITY(1,1),
last_name VARCHAR(20),
first_name VARCHAR(50),
cod_s INT FOREIGN KEY REFERENCES Store(cod_s),
email VARCHAR(30),
phone VARCHAR(13),
wage FLOAT
);

ALTER TABLE Employees
ADD dateOfBirth DATE;

CREATE TABLE Costumers
(cod_costumer  INT PRIMARY KEY IDENTITY(1,1),
last_name VARCHAR(20),
first_name VARCHAR(50),
email VARCHAR(30),
phone VARCHAR(13),
postalCode VARCHAR(10),
city VARCHAR(30),
street VARCHAR(50)
);

ALTER TABLE Costumers
ADD dateOfBirth DATE;

CREATE TABLE Orders
(cod_order INT PRIMARY KEY IDENTITY(1,1),
cod_costumer INT FOREIGN KEY REFERENCES Costumers(cod_costumer),
stat VARCHAR(20),
order_date DATE,
cod_s INT FOREIGN KEY REFERENCES Store(cod_s),
cod_e INT FOREIGN KEY REFERENCES Employees(cod_e)
);

CREATE TABLE Order_items
(cod_order INT FOREIGN KEY REFERENCES Orders(cod_order),
cod_p INT FOREIGN KEY REFERENCES Product(cod_p),
quantity INT,
pricePerProduct FLOAT
CONSTRAINT pk_OrderItem PRIMARY KEY (cod_order,cod_p)
);

CREATE TABLE Payments
(cod_payment INT PRIMARY KEY IDENTITY(1,1),
cod_costumer INT FOREIGN KEY REFERENCES Costumers(cod_costumer),
paymentMode VARCHAR(20),
amount FLOAT,
paymentDate DATE
);
