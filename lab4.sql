/*view care imi aratata toate orasele si strada pe care se afla toate magazinele*/
go
create view view_stores as
select city, street from Store1;

/*view care imi arata orasul, strada si codul produsului pentru toate produsele care sunt in stock mai mic de 3*/
go
create view view_almostNoStock as
select city, street,postalcode, s.cod_p from Store1 as st
inner join Stock1 as s
on st.cod_s=s.cod_s
where quantity<3;

/*view care imi arata cate tipuri diferite de produse am in fiecare oras*/
go
create view view_nrTypesProducts as
select st.city,count(p.product_name) as nrProducts from Product1 as p
inner join Stock1 as s
on s.cod_p=p.cod_p
inner join Store1 as st
on s.cod_s=st.cod_s
group by st.city;


select * from view_almostNoStock;
select * from view_nrTypesProducts;
select * from view_stores;

/*------------------------------------*/
go
create procedure addProduct1
AS
BEGIN
declare @price float;
set @price = RAND()*(100-1)+1;

declare @name varchar(50)
set @name = CONVERT(varchar(50),  replace(NEWID(),'-',''));

declare @brand INT
set @brand = FLOOR(RAND()*(9-7+1))+7;

declare @category INT
set @category = FLOOR(RAND()*(6-1+1))+1;
insert into Product1
values(@name,@price,@brand,@category)
END

delete from Product1;
exec addProduct1;
select * from Product1;

/*------------------------------------*/
go 
create procedure addStore1
as 
begin
declare @postal varchar(10)
set @postal = CONVERT(varchar(10),  replace(NEWID(),'-',''));
declare @city varchar(30);
set @city = CONVERT(varchar(30),  replace(NEWID(),'-',''));
declare @street varchar(50);
set @street = CONVERT(varchar(50),  replace(NEWID(),'-',''));
declare @email varchar(30);
set @email = CONVERT(varchar(30), replace(NEWID(),'-',''));
declare @phone varchar(13);
set @phone = CONVERT(varchar(13),  replace(NEWID(),'-',''));

insert into Store1
values (@postal,@city,@street,@email,@phone);
end

delete from Store1;
exec addStore1;
select * from Store1;

/*------------------------------------*/
go 
create procedure addStock1
as
begin
declare @nrProducts int;
select @nrProducts = NoOfRows from TestTables where TestID = 1 and TableID = 3;
declare @lastProduct int;
set @lastProduct = IDENT_CURRENT('Product1');
declare @firstProduct int;
set @firstProduct = @lastProduct -@nrProducts+1;
declare @product int;
set @product = FLOOR(RAND()*(@lastProduct-@firstProduct+1))+@firstProduct

declare @nrStores int;
select @nrStores = NoOfRows from TestTables where TestID = 1 and TableID = 2;
declare @lastStore int;
set @lastStore = IDENT_CURRENT('Store1');
declare @firstStore int;
set @firstStore = @lastStore - @nrStores+1;
declare @store int;
set @store = FLOOR(RAND()*(@lastStore-@firstStore+1))+@firstStore;

declare @quantity int;
set @quantity = FLOOR(RAND()*(100-1+1))+1;

insert into Stock1
values (@store,@product,@quantity);
end


exec addStock1;
select * from Stock1;

/*------------------------------------*/
go
alter procedure runTest(@testName varchar(20),@descriere nvarchar(2000))
as
begin

declare @idTest int;
select @idTest = TestID from Tests where Name=@testName;

insert into TestRuns
values(@descriere,CURRENT_TIMESTAMP,null);
declare @TestRunId int;
set @TestRunId = IDENT_CURRENT('TestRuns');

declare cursor_delete cursor for 
select TableID,Position 
from TestTables where TestID=@idTest
order by Position ASC;

declare @tableId int,@pos int;
open cursor_delete;
fetch next from cursor_delete into @tableId,@pos;
while @@FETCH_STATUS=0
	begin
	declare @tableName varchar(20);
	select @tableName = Name from Tables where TableID=@tableId;
	exec('delete from '+@tableName);
	fetch next from cursor_delete into @tableId,@pos;
	end
close cursor_delete;
deallocate cursor_delete;


declare cursor_add cursor for
select TableID,NoOfRows,Position 
from TestTables where TestID=@idTest
order by Position DESC;

declare @rows int,@tableAddID int,@position int;
open cursor_add;
fetch next from cursor_add into @tableAddID,@rows,@position
while @@FETCH_STATUS=0
	begin
	declare @tableAddName varchar(20);
	select @tableAddName = Name from Tables where TableID=@tableAddID;
	insert into TestRunTables
	values(@TestRunId,@tableAddId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	while(@rows > 0)
		begin
		exec('add'+@tableAddName);
		set @rows = @rows -1;
		end
	update TestRunTables
	set EndAt=CURRENT_TIMESTAMP
	where TestRunID=@TestRunId and TableID=@tableAddID;
	fetch next from cursor_add into @tableAddId,@rows,@position;
	end
close cursor_add;
deallocate cursor_add;

declare cursor_views cursor for
select ViewID
from TestViews where TestId=1;

declare @viewName varchar(20),@viewId int;
open cursor_views;
fetch next from cursor_views into @viewId;
while @@FETCH_STATUS=0
	begin
	select @viewName = Name from Views where ViewID=@viewId;
	insert into TestRunViews
	values(@TestRunId,@viewId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	exec('select * from '+@viewName);
	update TestRunViews
	set EndAt=CURRENT_TIMESTAMP
	where TestRunID=@TestRunId and ViewID = @viewId;
	fetch next from cursor_views into @viewId;
	end
close cursor_views;
deallocate cursor_views;

update TestRuns
set EndAt=CURRENT_TIMESTAMP
where TestRunId = @TestRunId;
end;


exec runTest @testName = testLab4, @descriere = 'testing the test';

select * from Product1;
select * from Stock1;
select * from Store1;

select * from TestRuns where TestRunID = IDENT_CURRENT('TestRuns');
select * from TestRunTables where TestRunID = IDENT_CURRENT('TestRuns');
select * from TestRunViews where TestRunID = IDENT_CURRENT('TestRuns');


/*am incercat,n-am reusit*/
go
create procedure addGeneral(@tableName varchar(30))
as
begin

declare cursor_columns cursor for
select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Product1';

open cursor_columns;
declare @column_name varchar(30),@type varchar(30),@maximum_size int,@nullable varchar(5)
fetch next from cursor_columns into @column_name,@type,@maximum_size,@nullable;
fetch next from cursor_columns into @column_name,@type,@maximum_size,@nullable;
while @@FETCH_STATUS=0 
	begin
	if @nullable = 'YES'
	begin
		set  = NULL;
	end
	fetch next from cursor_columns into @column_name,@type,@maximum_size,@nullable;
	end
close cursor_columns;
deallocate cursor_columns;

end;
