--CONSULTAS

--1. Obtener los 3 primeros empleados que han tenido las mayores ventas totales el año pasado.
--(tablas implicadas person, empleyee, salesPerson[añadir a grafo])
USE Fragmento1AW;
GO

ALTER procedure Top3_vendedores_mayores_ventas_LastYear_por_fragmento @nom_fragmento varchar(100) as
begin
	declare @servidor nvarchar(100);
	declare @sql nvarchar(1000);

	-- Recuperación del nombre del servidor vinculado y BD del fragmento
	select @servidor = servidor
	from diccionario_distribucion
	where bd = @nom_fragmento;

	set @sql = 'insert into Top3_Vendedores_mas_ventas_LastYear (FirstName, MiddleName, LastName, SalesLastYear)
				select P.FirstName, P.MiddleName, P.LastName, SP.SalesLastYear
				from ' + @servidor + '.' + @nom_fragmento + '.dbo.SalesPerson SP join ' + @servidor + '.' + @nom_fragmento + '.dbo.Employee E
				on SP.BusinessEntityID = E.BusinessEntityID
				join ' + @servidor + '.' + @nom_fragmento + '.dbo.Person P on P.BusinessEntityID = E.BusinessEntityID';
	exec sp_executesql @sql;
end
Go

ALTER procedure Top3_vendedores_mayores_ventas_LastYear as
begin
	drop table if exists Top3_Vendedores_mas_ventas_LastYear;
	create table Top3_Vendedores_mas_ventas_LastYear(
		FirstName nvarchar(50),
		MiddleName nvarchar(50),
		LastName nvarchar(50),
		SalesLastYear money
	)

	-- cursor ----------------------------------------------------
	DECLARE @nombre_fragmento AS nvarchar(100)
	DECLARE fragmento CURSOR FOR SELECT bd FROM diccionario_distribucion
	OPEN fragmento
	FETCH NEXT FROM fragmento INTO @nombre_fragmento
	WHILE @@fetch_status = 0
	BEGIN
		exec Top3_vendedores_mayores_ventas_LastYear_por_fragmento @nombre_fragmento;
		FETCH NEXT FROM fragmento INTO @nombre_fragmento
	END
	CLOSE fragmento
	DEALLOCATE fragmento

	select top 3 * from Top3_Vendedores_mas_ventas_LastYear order by SalesLastYear desc
	
	drop table Top3_Vendedores_mas_ventas_LastYear
end
go

exec Top3_vendedores_mayores_ventas_LastYear
GO



--2. La cantidad de ventas totales por territorio. 
ALTER procedure Contando_Ventas_por_territorio @nom_fragmento varchar(100) as
begin
	declare @servidor nvarchar(100);
	declare @sql nvarchar(1000);

	-- Recuperación del nombre del servidor vinculado y BD del fragmento
	select @servidor = servidor
	from diccionario_distribucion
	where bd = @nom_fragmento;

	set @sql = 'insert into Cuentas_por_Territorio (Territorio, Ventas_Totales)
				select ST.[name], SOH.Ventas_Totales from
				(select TerritoryID, count(*) as Ventas_Totales from ' + @servidor + '.' + @nom_fragmento + '.dbo.SalesOrderHeader
				group by TerritoryID) as SOH
				join ' + @servidor + '.' + @nom_fragmento + '.dbo.SalesTerritory ST on ST.TerritoryID = SOH.TerritoryID';
	exec sp_executesql @sql;
end
Go

ALTER procedure Total_ventas_por_territorio as
begin
	drop table if exists Cuentas_por_Territorio;
	create table Cuentas_por_Territorio(
		Territorio nvarchar(50),
		Ventas_Totales int
	)

	-- cursor ----------------------------------------------------
	DECLARE @nombre_fragmento AS nvarchar(100)
	DECLARE fragmento CURSOR FOR SELECT bd FROM diccionario_distribucion
	OPEN fragmento
	FETCH NEXT FROM fragmento INTO @nombre_fragmento
	WHILE @@fetch_status = 0
	BEGIN
		exec Contando_Ventas_por_territorio @nombre_fragmento;
		FETCH NEXT FROM fragmento INTO @nombre_fragmento
	END
	CLOSE fragmento
	DEALLOCATE fragmento

	select Territorio, sum(Ventas_Totales) Ventas_Totales from Cuentas_por_Territorio group by Territorio
	
	drop table Cuentas_por_Territorio
end
go

exec Total_ventas_por_territorio
go



--3. Contar las órdenes de venta por tipo de envío
ALTER procedure Contando_Ventas_por_metodo_envio @nom_fragmento varchar(100) as
begin
	declare @servidor nvarchar(100);
	declare @sql nvarchar(1000);

	-- Recuperación del nombre del servidor vinculado y BD del fragmento
	select @servidor = servidor
	from diccionario_distribucion
	where bd = @nom_fragmento;

	set @sql = 'insert into Cuentas_por_metodo_envio ([Metodo_envio], Ventas_Totales)
				select [name], SOH.Ventas_Totales from
				(select ShipMethodID, count(*) as Ventas_Totales from ' + @servidor + '.' + @nom_fragmento + '.dbo.SalesOrderHeader
				group by ShipMethodID) SOH
				join ' + @servidor + '.' + @nom_fragmento + '.dbo.ShipMethod SM on SM.ShipMethodID = SOH.ShipMethodID';
	exec sp_executesql @sql;
end
Go

ALTER procedure Total_ventas_por_metodo_envio as
begin
	drop table if exists Cuentas_por_metodo_envio;
	create table Cuentas_por_metodo_envio(
		Metodo_envio nvarchar(50),
		Ventas_Totales int
	)

	-- cursor ----------------------------------------------------
	DECLARE @nombre_fragmento AS nvarchar(100)
	DECLARE fragmento CURSOR FOR SELECT bd FROM diccionario_distribucion
	OPEN fragmento
	FETCH NEXT FROM fragmento INTO @nombre_fragmento
	WHILE @@fetch_status = 0
	BEGIN
		exec Contando_Ventas_por_metodo_envio @nombre_fragmento;
		FETCH NEXT FROM fragmento INTO @nombre_fragmento
	END
	CLOSE fragmento
	DEALLOCATE fragmento

	select Metodo_envio, sum(Ventas_Totales) Ventas_Totales from Cuentas_por_metodo_envio group by Metodo_envio
	
	drop table Cuentas_por_metodo_envio
end
go

exec Total_ventas_por_metodo_envio
go



--4. Eliminar la última orden de venta registrada
ALTER procedure Eliminacion_ultima_orden_venta as
begin
	declare @SalesOrderID_MAX int;
	declare @Fragmento nvarchar(100);
	declare @Parametros nvarchar(1000);
	declare @sql nvarchar(1000);
	declare @servidor_volatil nvarchar(100);
	declare @servidor nvarchar(100);
	set @SalesOrderID_MAX = 0;

	-- cursor ----------------------------------------------------
	DECLARE @nom_fragmento AS nvarchar(100)
	DECLARE fragmento CURSOR FOR SELECT bd FROM diccionario_distribucion
	OPEN fragmento
	FETCH NEXT FROM fragmento INTO @nom_fragmento
	WHILE @@fetch_status = 0
	BEGIN
		select @servidor_volatil = servidor
		from diccionario_distribucion where bd = @nom_fragmento;

		set @sql = 'if ((select max(SalesOrderID) from ' + @servidor_volatil + '.' + @nom_fragmento + '.dbo.SalesOrderHeader) > ' + cast(@SalesOrderID_MAX as nvarchar(10)) + ')
						begin
							select @SalesOrderID_MAX = max(SalesOrderID) from ' + @servidor_volatil + '.' + @nom_fragmento + '.dbo.SalesOrderHeader
							set @servidor = ' + @servidor_volatil + '
							set @Fragmento = ' + @nom_fragmento + '
						end
					else
					 begin
						set @SalesOrderID_MAX = ' + cast(@SalesOrderID_MAX as nvarchar(10)) + '
						set @servidor = ' + @servidor + '
						set @Fragmento = ' + @Fragmento + '
					 end'
		set @Parametros = '@servidor nvarchar(100) OUTPUT, @SalesOrderID_MAX int OUTPUT, @Fragmento nvarchar(100) OUTPUT';
		exec sp_executesql @sql,@Parametros,@servidor = @servidor output, @SalesOrderID_MAX = @SalesOrderID_MAX output,
			@Fragmento = @Fragmento output;

		FETCH NEXT FROM fragmento INTO @nom_fragmento
	END
	CLOSE fragmento
	DEALLOCATE fragmento

	set @sql = 'delete from ' + @servidor + '.' + @Fragmento + '.dbo.SalesOrderHeader where SalesOrderID = ' + cast(@SalesOrderID_MAX as nvarchar(10))
	exec sp_executesql @sql;
	
end
go



--5. Listar los vendedores asignados a cada Tienda cliente 
ALTER procedure Lista_Tiendas_Vendedores as
begin
	declare @sql nvarchar(1000);
	declare @servidor nvarchar(100);

	drop table if exists Tienda_Vendedores;
	create table Tienda_Vendedores(
		TIENDA nvarchar(50),
		FirstName_Vendedor nvarchar(50),
		MiddleName_Vendedor nvarchar(50),
		LastName_Vendedor nvarchar(50)
	)

	-- cursor ----------------------------------------------------
	DECLARE @nom_fragmento AS nvarchar(100)
	DECLARE fragmento CURSOR FOR SELECT bd FROM diccionario_distribucion
	OPEN fragmento
	FETCH NEXT FROM fragmento INTO @nom_fragmento
	WHILE @@fetch_status = 0
	BEGIN
		select @servidor = servidor
		from diccionario_distribucion where bd = @nom_fragmento;

		set @sql = 'insert into Tienda_Vendedores
					select S.[name], FirstName, MiddleName, LastName from ' + @servidor + '.' + @nom_fragmento + '.dbo.Store S
					join ' + @servidor + '.' + @nom_fragmento + '.dbo.Person P on S.SalesPersonID = P.BusinessEntityID';
		exec sp_executesql @sql;

		FETCH NEXT FROM fragmento INTO @nom_fragmento
	END
	CLOSE fragmento
	DEALLOCATE fragmento

	select * from Tienda_Vendedores order by TIENDA
	drop table Tienda_Vendedores
	
end
go

exec Lista_Tiendas_Vendedores
GO



--6. Obtener la cantidad de órdenes de venta por vendedor 
alter procedure Total_ventas_por_vendedor as
begin
	
	drop table if exists Cuentas_por_Vendedor;
	create table Cuentas_por_Vendedor(
		FirstName_Vendedor nvarchar(50),
		MiddleName_Vendedor nvarchar(50),
		LastName_Vendedor nvarchar(50),
		Ventas_Totales int
	)

	insert into Cuentas_por_Vendedor
	select FirstName, MiddleName, LastName, count(*) from SalesOrderHeader SOH
	join Person P on SOH.SalesPersonID = P.BusinessEntityID
	GROUP BY FirstName, MiddleName, LastName
				
	insert into Cuentas_por_Vendedor
	select FirstName, MiddleName, LastName, count(*) from [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesOrderHeader SOH
	join Person P on SOH.SalesPersonID = P.BusinessEntityID
	GROUP BY FirstName, MiddleName, LastName
				
	insert into Cuentas_por_Vendedor
	select FirstName, MiddleName, LastName, count(*) from SalesOrderHeader SOH
	join [ConnectionFragmeto1a2].Fragmento2AW.dbo.Person P
	on SOH.SalesPersonID = P.BusinessEntityID
	GROUP BY FirstName, MiddleName, LastName
				
	insert into Cuentas_por_Vendedor
	select FirstName, MiddleName, LastName, count(*) from [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesOrderHeader SOH
	join [ConnectionFragmeto1a2].Fragmento2AW.dbo.Person P
	on SOH.SalesPersonID = P.BusinessEntityID
	GROUP BY FirstName, MiddleName, LastName

	select FirstName_Vendedor, MiddleName_Vendedor, LastName_Vendedor, sum(Ventas_Totales) from Cuentas_por_Vendedor
	group by FirstName_Vendedor, MiddleName_Vendedor, LastName_Vendedor
	
	drop table Cuentas_por_Vendedor
end
go

exec Total_ventas_por_vendedor
go



--7. Obtener los clientes que han comprado asociados a que están recibiendo publicidad por correo electrónico y su correspondiente total de
--ordenes de venta 
SELECT P.FirstName, P.MiddleName, P.LastName, COUNT(*) FROM [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesOrderHeader SOH
JOIN [ConnectionFragmeto2a1].Fragmento1AW.dbo.Customer C ON SOH.CustomerID = C.CustomerID
JOIN [ConnectionFragmeto2a1].Fragmento1AW.dbo.Person P on C.PersonID = P.BusinessEntityID
GROUP BY P.FirstName, P.MiddleName, P.LastName, cliente;



--8. Obtener los tipos de razones de ventas de los clientes suscritos a publicidad por correo electrónico y
--su correspondiente total de ordenes de venta 
select ReasonType, count(*) from [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesReason SR
join [ConnectionFragmeto2a1].Fragmento1AW.dbo.SalesOrderHeaderSalesReason SOHSR on SR.SalesReasonID = SOHSR.SalesReasonID
group by ReasonType



--9. Obtener las razones de venta de los clientes no suscritos a publicidad por correo electrónico y
--su correspondiente total de ordenes de venta 
select [name], count(*) from [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesReason SR
join [ConnectionFragmeto1a2].Fragmento2AW.dbo.SalesOrderHeaderSalesReason SOHSR on SR.SalesReasonID = SOHSR.SalesReasonID
group by [name]
