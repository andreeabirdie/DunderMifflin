USE DunderMifflin;

/*Interogare care ne spune cate produse avem din fiecare categorie
GROUP BY,extrage informatii din mai multe tabele*/
SELECT C.category_name, COUNT(P.cod_p)
FROM Category AS C 
INNER JOIN Product AS P
ON P.cod_cat = C.cod_cat
GROUP BY C.category_name

/*Interogare care ne spune care produse din fiecare magazin se afla in inventar in cantitate mai mica de 5
WHERE,pe tabel in relatie N-M,extrage informatii din mai multe tabele*/
SELECT S.cod_p, S.cod_s, P.product_name, Store.city, Store.postalCode
FROM Stock AS S
INNER JOIN Product AS P
ON P.cod_p=S.cod_p
INNER JOIN Store 
ON S.cod_s=Store.cod_s
WHERE S.quantity<5

/*Interogare care ne spune pretul total al fiecarei comenzi
GROUP BY,extrage informatii din mai multe tabele*/
SELECT O.cod_order,SUM(P.price*O.quantity)
FROM Order_items AS O
INNER JOIN Product as P
ON O.cod_p = P.cod_p
GROUP BY O.cod_order

/*
Interogare care ne spune orasele cu mai mult de un numar de clienti, si numarul de clienti
GROUP BY,HAVING
*/
SELECT COUNT(Costumers.first_name),Costumers.city
FROM Costumers
GROUP BY Costumers.city
HAVING COUNT(Costumers.first_name)>1


/*Interogare care ne spune date despre branduri care vand caiete
WHERE,extrage informatii din mai multe tabele,DISTINCT*/
SELECT DISTINCT Brand.brand_name, Brand.email, Brand.phone
FROM Brand
INNER JOIN Product
ON Product.cod_b=Brand.cod_b
WHERE Product.product_name LIKE '%Caiet%' OR Product.product_name LIKE '%caiet%'

SELECT * FROM Costumers
SELECT * FROM Employees
SELECT * FROM Orders

/*Interogare care ne da emailurile clientilor care au comenzi nelivrate de 20 zile de la data comenzii
WHERE,DISTINCT,pe tabel in relatie N-M*/
SELECT DISTINCT C.first_name AS FirstNameC, C.last_name AS LastNameC, C.email AS emailCostumer,
E.first_name AS FirstNameE, E.last_name LastNameE, E.email AS emailEmployee
FROM Costumers AS C
INNER JOIN Orders 
ON Orders.cod_costumer=C.cod_costumer
INNER JOIN Employees AS E
ON Orders.cod_e=E.cod_e
WHERE Orders.stat <> 'incheiat' AND DATEDIFF(DAY,Orders.order_date,GETDATE()) > 20



/*Interogare care ne da numele clientilor care isi sarbatoresc ziua de nastere
WHERE*/
SELECT C.first_name, C.last_name, C.email
FROM Costumers AS C
WHERE DATEPART(d, C.dateOfBirth) = DATEPART(d, GETDATE()) 
AND DATEPART(m, C.dateOfBirth) = DATEPART(m, GETDATE())

/*
Interogare care verifica comenzile pentru care suma totala este mai mare de 200 de lei
HAVING,GROUP BY,extrage informatii din mai multe tabele,pe tabel in relatie N-M
*/
SELECT O.cod_order,SUM(P.price*O.quantity)
FROM Order_items AS O
INNER JOIN Product as P
ON O.cod_p = P.cod_p
GROUP BY O.cod_order
HAVING SUM(P.price*O.quantity) > 200

/*Interogare care ne spune detalii clientilor care au comenzi neplatite
WHERE,extrage informatii din mai multe tabele
*/
SELECT C.first_name,C.last_name,C.email,C.postalCode,P.amount
FROM Costumers AS C
INNER JOIN Payments AS P
ON P.cod_costumer = C.cod_costumer
WHERE P.paymentDate is NULL 

/*
Interogare care ne spune cateva date despre angajati si orasul magazinului in care lucreaza
extrage informatii din mai multe tabele
*/
SELECT E.first_name,E.last_name,E.email,S.city
FROM Employees AS E
INNER JOIN Store AS S
ON S.cod_s=E.cod_e
