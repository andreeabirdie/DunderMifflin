USE DunderMifflin;

/*functie care valideaza daca un numar e pozitiv*/
go
create or alter function is_positive(@number int)
returns int
as
begin
	declare @valid int = 1;
	if(@number < 0) 
		set @valid = 0;
	return @valid;
end;

/*functie care valideaza un email*/
go
create or alter function is_email(@email varchar(40))
returns int
as 
begin
	declare @valid int = 1;
	if(@email not like '_%@__%.__%')
		set @valid = 0;
	return @valid;
end;

/*functie care valideaza un numar de telefon*/
go
create or alter function is_phone_number(@number varchar(30))
returns int
as
begin
	declare @valid int =0;
	if(len(@number) >= 10)
		set @valid =1;
	return @valid;
end;

/*operatii crud pentru tabelele  Category, Product, Brand, Store, Stock*/

/*------------------------------------Category(cod_cat pk, nume_categorie)---------------------------------------------*/
go
create or alter procedure createCategory(@name varchar(40))
as
begin
	if(@name is null)
		print('Numele nu poate fi vid');
	else if exists (select 1 from Category where category_name = @name)
			print('Exista deja categoria ' + @name);
		 else insert into Category(category_name) values (@name);
end;

exec createCategory Caiete;

go
create or alter procedure deleteCategory(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Category where cod_cat=@cod) 
			print('Nu exista categoria cu codul ' + CONVERT(VARCHAR(10),@cod));
			else if exists (select 1 from Product where cod_cat=@cod)
					print('Nu se poate sterge categoria ' + CONVERT(VARCHAR(10),@cod) + ' deoarece exista produse in tabela Produse care apartin categoriei.');
				else delete from Category where cod_cat=@cod;
end;

exec deleteCategory 5;
exec deleteCategory 23;

go 
create or alter procedure readCategory(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
	else if not exists (select 1 from Category where cod_cat=@cod) 
			print('Nu exista categoria cu codul ' + CONVERT(VARCHAR(10),@cod));
		else select * from Category where cod_cat=@cod; 
end;

exec readCategory 23;
exec readCategory 1;

go 
create or alter procedure updateCategory(@cod int, @name varchar(40))
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
	else if not exists (select 1 from Category where cod_cat=@cod) 
			print('Nu exista categoria cu codul ' + CONVERT(VARCHAR(10),@cod));
		else if exists (select 1 from Category where category_name=@name)
				print('Exista deja categoria cu numele ' + @name);
			else update Category set category_name=@name where cod_cat=@cod;
end;

exec updateCategory 23,'Caiete';
exec updateCategory 1, 'Caiete A4';
exec updateCategory 1,'Caiete';


/*-------------------------Brand(cod_b,brand_name,postalCode,city,street,email,phone)--------------------------*/
go
create or alter procedure createBrand(@name varchar(50), @postalCode varchar(10), @city varchar(20), @street varchar(50), @email varchar(30), @phone varchar(13))
as
begin
	declare @valid int = 1;
	if (@postalCode is null or @city is null or @street is null or @phone is null)
	begin
		set @valid =0 ;	
		print('Campurile cod postal, strada, orasul, nr de telefon nu pot fi nule');
	end
	if(@name is null)
	begin
		print('Numele nu poate fi vid');
		set @valid =0 ;
	end
	if(dbo.is_email(@email) = 0)
	begin
		set @valid =0 ;
		print('Emailul "' + @email + '" nu este valid');
	end
	if(dbo.is_phone_number(@phone)=0)
	begin	
		set @valid =0 ;
		print('Numarul de telefon "' + @phone + '" nu este valid');
	end
	if @valid=1
		if exists (select 1 from Brand where brand_name=@name) 
			print('Exista deja acest Brand in baza de date');
		else insert into Brand (brand_name,postalCode,city,street,email,phone) values (@name,@postalCode,@city,@street,@email,@phone);
end;

exec createBrand 'Pigna', 123456 , 'Cluj Napoca',null,'abc','07123';
exec createBrand 'Pigna',610255,'Piatra Neamt','str Mihai Eminescu','hello@rotring.ro','0745963589';
exec createBrand 'Rotring',610255,'Piatra Neamt','str Mihai Eminescu','hello@rotring.ro','0745963589';

go
create or alter procedure updateBrand(@cod int,@name varchar(50), @postalCode varchar(10), @city varchar(20), @street varchar(50), @email varchar(30), @phone varchar(13))
as
begin
	declare @valid int = 1;
	if (dbo.is_positive(@cod)=0)
	begin
		set @valid =0;
		print('Codul nu poate fi negativ');
	end
	if (@postalCode is null or @city is null or @street is null or @phone is null)
	begin
		set @valid =0 ;	
		print('Campurile cod postal, strada, orasul, nr de telefon nu pot fi nule');
	end
	if(@name is null)
	begin
		print('Numele nu poate fi vid');
		set @valid =0 ;
	end
	if(dbo.is_email(@email) = 0)
	begin
		set @valid =0 ;
		print('Emailul "' + @email + '" nu este valid');
	end
	if(dbo.is_phone_number(@phone)=0)
	begin	
		set @valid =0 ;
		print('Numarul de telefon "' + @phone + '" nu este valid');
	end
	if @valid=1
		if not exists (select 1 from Brand where cod_b=@cod) 
			print('Nu exista brandul ' + CONVERT(VARCHAR(10),@cod) +' in baza de date');
		else update Brand set brand_name=@name, postalCode = @postalCode , city = @city, street = @street, email = @email, phone=@phone
			where cod_b = @cod;
end;

exec updateBrand -5,'Pigna', 123456 , 'Cluj Napoca',null,'abc','07123';
exec updateBrand  1,'Pigna',610255,'Bucuresti','str Mihai Viteazu','hello@pigna.ro','0745963589';
exec updateBrand  1,'Rotring',610255,'Piatra Neamt','str Mihai Eminescu','hello@rotring.ro','0745963589';

go
create or alter procedure deleteBrand(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Brand where cod_b=@cod) 
			print('Nu exista brandul cu codul ' + CONVERT(VARCHAR(10),@cod));
			else if exists (select 1 from Product where cod_b=@cod)
					print('Nu se poate sterge brandul '  + CONVERT(VARCHAR(10),@cod) + ' deoarece exista produse in tabela Produse care apartin brandului.' );
				else delete from Brand where cod_b=@cod;
end;

exec deleteBrand 1;

go
create or alter procedure readBrand(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
	else if not exists (select 1 from Brand where cod_b=@cod) 
			print('Nu exista brandul cu codul ' + CONVERT(VARCHAR(10),@cod));
		else select * from Brand where cod_b=@cod; 
end;

exec readBrand 1;


/*--------------------------------------Stock(cod_s,cod_p,quantity)------------------------------------*/
go
create or alter procedure createStock(@cod_s int,@cod_p int,@quantity int)
as
begin
	declare @valid int = 1;
	if(dbo.is_positive(@quantity) = 0)
	begin
		set @valid = 0;
		print('Cantitatea trebuie sa fie pozitiva');
	end
	if not exists (select 1 from Product where cod_p = @cod_p)
	begin
		set @valid = 0;
		print('Nu exista produsul de cod ' + CONVERT(VARCHAR(10),@cod_p));
	end
	if not exists (select 1 from Store where cod_s = @cod_s)
	begin
		set @valid = 0;
		print('Nu exista magazinul de cod ' + CONVERT(VARCHAR(10),@cod_s));
	end
	if(@valid=1)
		if exists (select 1 from Stock where cod_p = @cod_p and cod_s = @cod_s)
			print('Exista deja produsul ' + CONVERT(VARCHAR(10),@cod_p) + ' in magazinul ' + CONVERT(VARCHAR(10),@cod_s));
		 else insert into Stock (cod_p,cod_s,quantity) values (@cod_p,@cod_s,@quantity);
end;

exec createStock 1,2,3;
exec createStock 1,2,-3;
exec createStock 1,3,10;


go
create or alter procedure updateStock(@cod_s int,@cod_p int,@quantity int)
as
begin
	declare @valid int = 1;
	if(dbo.is_positive(@quantity) = 0)
	begin
		set @valid = 0;
		print('Cantitatea trebuie sa fie pozitiva');
	end
	if not exists (select 1 from Product where cod_p = @cod_p)
	begin
		set @valid = 0;
		print('Nu exista produsul de cod ' + CONVERT(VARCHAR(10),@cod_p));
	end
	if not exists (select 1 from Store where cod_s = @cod_s)
	begin
		set @valid = 0;
		print('Nu exista magazinul de cod ' + CONVERT(VARCHAR(10),@cod_s));
	end
	if(@valid=1)
		if not exists (select 1 from Stock where cod_p = @cod_p and cod_s = @cod_s)
			print('Nu exista produsul ' + CONVERT(VARCHAR(10),@cod_p) + ' in magazinul ' + CONVERT(VARCHAR(10),@cod_s));
		 else update Stock set quantity = @quantity where cod_p = @cod_p and cod_s = @cod_s
end;

exec updateStock 1,2,-3;
exec updateStock 1,1000,3;
exec updateStock 1,2,45;

go
create or alter procedure deleteStock(@cod_s int,@cod_p int)
as
begin
	if(dbo.is_positive(@cod_s)=0 or dbo.is_positive(@cod_p)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Stock where cod_p = @cod_p and cod_s = @cod_s)
			print('Nu exista produsul ' + CONVERT(VARCHAR(10),@cod_p) + ' in magazinul ' + CONVERT(VARCHAR(10),@cod_s));
			else delete from Stock where cod_s = @cod_s and cod_p=@cod_p;
end;

exec deleteStock 1,3;

go
create or alter procedure readStock(@cod_s int,@cod_p int)
as
begin
	if(dbo.is_positive(@cod_s)=0 or dbo.is_positive(@cod_p)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Stock where cod_p = @cod_p and cod_s = @cod_s)
			print('Nu exista produsul ' + CONVERT(VARCHAR(10),@cod_p) + ' in magazinul ' + CONVERT(VARCHAR(10),@cod_s));
			else select * from Stock where cod_s = @cod_s and cod_p=@cod_p;
end;

exec readStock 1,2;
exec readStock 1,3;

/*--------------------------------------Store(cod_s,postalCode,city,street,email,phone)-----------------*/
go
create or alter procedure createStore(@postalCode varchar(10), @city varchar(20), @street varchar(50), @email varchar(30), @phone varchar(13))
as
begin
	declare @valid int = 1;
	if (@postalCode is null or @city is null or @street is null or @phone is null)
	begin
		set @valid =0 ;	
		print('Campurile cod postal, strada, orasul, nr de telefon nu pot fi nule');
	end
	if(dbo.is_email(@email) = 0)
	begin
		set @valid =0 ;
		print('Emailul "' + @email + '" nu este valid');
	end
	if(dbo.is_phone_number(@phone)=0)
	begin	
		set @valid =0 ;
		print('Numarul de telefon "' + @phone + '" nu este valid');
	end
	if @valid=1
		if exists (select 1 from Store where city = @city and email = @email) 
			print('Exista deja acest magazin in baza de date');
		else insert into Store (postalCode,city,street,email,phone) values (@postalCode,@city,@street,@email,@phone);
end;

go
create or alter procedure updateStore(@cod int, @postalCode varchar(10), @city varchar(20), @street varchar(50), @email varchar(30), @phone varchar(13))
as
begin
	declare @valid int = 1;
	if (dbo.is_positive(@cod)=0)
	begin
		set @valid =0;
		print('Codul nu poate fi negativ');
	end
	if (@postalCode is null or @city is null or @street is null or @phone is null)
	begin
		set @valid =0 ;	
		print('Campurile cod postal, strada, orasul, nr de telefon nu pot fi nule');
	end
	if(dbo.is_email(@email) = 0)
	begin
		set @valid =0 ;
		print('Emailul "' + @email + '" nu este valid');
	end
	if(dbo.is_phone_number(@phone)=0)
	begin	
		set @valid =0 ;
		print('Numarul de telefon "' + @phone + '" nu este valid');
	end
	if @valid=1
		if not exists (select 1 from Store where cod_s = @cod) 
			print('Nu exista acest magazin in baza de date');
		else update Store set postalCode = @postalCode,city = @city,street = @street,email = @email,phone =@phone 
			where cod_s = @cod;
end;

exec updateStore 1,610255,null,'str Mihai Viteazu','abc','07459';
exec updateStore  1,610255,'Piatra Neamt','str Mihai Eminescu','hello@rotring.ro','0745963589';

go
create or alter procedure deleteStore(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Store where cod_s=@cod) 
			print('Nu exista magazinul cu codul ' + CONVERT(VARCHAR(10),@cod));
			else if exists (select 1 from Stock where cod_s=@cod)
					print('Nu se poate sterge magazinul ' + CONVERT(VARCHAR(10),@cod) + ' deoarece inca exista stoc care apartine magazinului.');
				else delete from Store where cod_s=@cod;
end;

exec deleteStore 1000;
exec deleteStore 1;

go
create or alter procedure readStore(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Store where cod_s=@cod) 
			print('Nu exista magazinul cu codul ' + CONVERT(VARCHAR(10),@cod));
				else select * from Store where cod_s=@cod;
end;

exec readStore 1000;
exec readStore 1;


/*--------------------------------------Product(cod_p,product_name,price,cod_b,cod_cat)------------------------------------*/
alter table Product
add constraint chk_price check (price>=0)

go
create or alter procedure createProduct(@name varchar(50),@price float,@cod_cat int, @cod_b int)
as
begin
	declare @valid int = 1;
	if (@name is null)
	begin
		set @valid =0 ;	
		print('Numele nu poate fi vid');
	end
	if(dbo.is_positive(@price) = 0)
	begin
		set @valid =0 ;
		print('Pretul nu poate fi negativ.');
	end
	if not exists (select 1 from Category where cod_cat = @cod_cat)
	begin
		set @valid = 0;
		print('Nu exista categoria de cod ' + CONVERT(VARCHAR(10),@cod_cat));
	end
	if not exists (select 1 from Brand where cod_b = @cod_b)
	begin
		set @valid = 0;
		print('Nu exista brandul de cod ' + CONVERT(VARCHAR(10),@cod_b));
	end
	if @valid=1
		if exists (select 1 from Product where product_name = @name and cod_cat = @cod_cat and cod_b = @cod_b) 
			print('Exista deja acest produs in baza de date');
		else insert into Product (product_name,price,cod_cat,cod_b) values (@name,@price,@cod_cat,@cod_b);
end;

exec createProduct 'Stilou alb',12.5,1,1;
exec createProduct '',-12.5,2,2;

go
create or alter procedure updateProduct(@cod int,@name varchar(50),@price float,@cod_cat int, @cod_b int)
as
begin
declare @valid int = 1;
if (dbo.is_positive(@cod)=0)
	begin
		set @valid =0;
		print('Codul nu poate fi negativ');
	end
	if (@name is null)
	begin
		set @valid =0 ;	
		print('Numele produsului nu poate fi vid');
	end
	if(dbo.is_positive(@price) = 0)
	begin
		set @valid =0 ;
		print('Pretul nu poate fi negativ.');
	end
	if not exists (select 1 from Category where cod_cat = @cod_cat)
	begin
		set @valid = 0;
		print('Nu exista categoria de cod ' + CONVERT(VARCHAR(10),@cod_cat));
	end
	if not exists (select 1 from Brand where cod_b = @cod_b)
	begin
		set @valid = 0;
		print('Nu exista brandul de cod ' + CONVERT(VARCHAR(10),@cod_b));
	end
	if @valid=1
		if not exists (select 1 from Product where cod_p = @cod) 
			print('Nu exista acest produs in baza de date');
		else update Product set product_name = @name,cod_b = @cod_b,cod_cat=@cod_cat where cod_p=@cod;
end;

exec updateProduct 1003,'Stilou negru',12.5,1,1;
exec updateProduct 1003,null,-12.5,2,2;

go
create or alter procedure deleteProduct(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Product where cod_p=@cod) 
			print('Nu exista produsul cu codul ' + CONVERT(VARCHAR(10),@cod));
				else delete from Product where cod_p=@cod;
end;

exec deleteProduct -1;
exec deleteProduct 1003;

go
create or alter procedure readProduct(@cod int)
as
begin
	if(dbo.is_positive(@cod)=0)
		print('Codul nu poate fi negativ');
		else if not exists (select 1 from Product where cod_p=@cod) 
			print('Nu exista produsul cu codul ' + CONVERT(VARCHAR(10),@cod));
				else select * from Product where cod_p=@cod;
end;

exec readProduct 1;


/*------------views-----------------*/
if exists (select name from sys.indexes where name='N_idx_products')
drop index N_idx_products on Product
create nonclustered index N_idx_products on Product(product_name ASC)
go

go
create or alter view vw_products as
select product_name from Product
where product_name like '%C';

select * from vw_products;

if exists (select name from sys.indexes where name='N_idx_stores')
drop index N_idx_stores on Store
create nonclustered index N_idx_stores on Store(postalCode ASC)
go

go
create or alter view vw_stores as
select postalCode from Store
where postalCOde >= 10000;

select * from vw_stores;

