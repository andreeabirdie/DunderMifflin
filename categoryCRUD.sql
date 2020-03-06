use DunderMifflin;

--create
go
create or alter procedure createCategory(@nume varchar(40))
as
	begin
	if((select 1 from  Category where category_name=@nume) is null)
		begin
		declare @id int = (select max(cod_cat) from Category)+1;
		set identity_insert Category ON;
		insert into Category (cod_cat,category_name) values (@id,@nume);
		set identity_insert Category OFF;
		end
	else print('Exista deja aceasta categorie in tabel');
	end

exec createCategory Carton;

--read
go
create  or alter procedure readCategory(@id int)
as
	begin
	select * from Category where cod_cat=@id;
	end

--update 
go
create or alter procedure updateCategory(@nume varchar(40),@id int)
as
	begin
	if(dbo.is_positive(@id)=0)
		print('Id-ul categoriei nu poate fi negativ');
	else
		begin
		if((select 1 from  Category where cod_cat=@id) is null)
			print('Nu exista categoria cu id-ul'+convert(varchar(5),@id));
		else 
			begin
			update Category
			set category_name=@nume
			where cod_cat=@id;
			end
		end
	end

--delete
go
create or alter procedure deleteCategory(@id int)
as
	begin
	if(dbo.is_positive(@id)=0)
		print('Id-ul categoriei nu poate fi negativ');
	else
		begin
		if((select 1 from  Category where cod_cat=@id) is null)
			print('Nu exista categoria cu id-ul'+convert(varchar(5),@id));
		else 
			if exists (select 1 from Product where cod_cat=@id)
				print('Nu poate fi stearsa categoria cu codul '+convert(varchar(5),@id)+' deoarece e in relatie cu tabela Produse');
			else
				delete from Category where cod_cat=@id;
		end
	end