use DunderMifflin;

go
create function is_positive(@number int)
returns int
as
begin
	declare @valid int = 1;
	if(@number < 0) 
		set @valid = 0;
	return @valid;
end;

go 
create function startsWithC(@nume varchar(40))
returns int
as
	begin
	declare @valid int = 1;
	if(@nume like 'D%') 
		set @valid = 0;
	return @valid;
	end

