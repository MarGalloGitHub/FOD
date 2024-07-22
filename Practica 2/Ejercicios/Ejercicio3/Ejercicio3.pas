program Ejercicio3;

type
	producto = record
		codigo: integer;
		precio: integer;
		stockActual: integer;
		stockMinimo: integer;
		nombre: string;
	end;
	
	venta = record
		codigo: integer;
		cantidadUnidades: integer;
	end;
		

	maestro = file of producto;
	detalle = file of venta;

procedure leerProducto(var prod: producto);
begin
	writeln('Escriba el codigo del producto');
	readln(prod.codigo);
	if(prod.codigo <> 0)then begin
		writeln('Escriba el precio del producto');
		readln(prod.precio);
		writeln('Escriba el numero de stock actual');
		readln(prod.stockActual);
		writeln('Escriba el numero del stock minimo');
		readln(prod.stockMinimo);
		writeln('Escriba el nombre del producto');
		readln(prod.nombre);
	end;
end;

procedure leerVenta(var ven: venta);
begin
	writeln('escriba el codigo de la venta');
	readln(ven.codigo);
	if(ven.codigo <> 0)then begin
		writeln('escriba la cantidad de unidades vendidas');
		readln(ven.cantidadUnidades);
	end;
end;	
	
procedure crearArchivoMaestro(var arch_Maestro: maestro);
var
	prod: producto;
begin
	rewrite(arch_Maestro);
	leerProducto(prod);
	while(prod.codigo <> 0)do begin
		write(arch_Maestro , prod);
		leerProducto(prod);
	end;
	close(arch_Maestro);
end;

procedure crearArchivoDetalle(var arch_Detalle: detalle);
var
	ven: venta;
begin
	rewrite(arch_Detalle);
	leerVenta(ven);
	while(ven.codigo <> 0)do begin
		write(arch_Detalle , ven);
		leerVenta(ven);
	end;
	close(arch_Detalle);
end;

procedure actualizarMaestro(var arch_Mlogico: maestro ; var arch_Dlogico: detalle);
var
	prod: producto;
	ven: venta;
begin
	reset(arch_Mlogico);
	reset(arch_Dlogico);
	while(not eof(arch_Dlogico))do begin
		read(arch_Mlogico , prod);
		read(arch_Dlogico , ven);
		while(prod.codigo <> ven.codigo)do
			read(arch_Mlogico , prod);
		while((not eof(arch_Dlogico)) AND (prod.codigo = ven.codigo))do begin
			prod.stockActual:= prod.stockActual - ven.cantidadUnidades;
			read(arch_Dlogico , ven);
		end;
		if(not eof(arch_Dlogico))then begin
			seek(arch_Dlogico , filepos(arch_Dlogico) - 1);
		end;
		seek(arch_Mlogico, filepos(arch_Mlogico) - 1);
		write(arch_Mlogico , prod);
	end;
	close(arch_Mlogico);
	close(arch_Dlogico);
end;

procedure crearArchivoTexto(var arch_texto: text ; var arch_Mlogico: maestro);
var
	prod: producto;
begin
	reset(arch_Mlogico);
	rewrite(arch_texto);
	while(not eof(arch_Mlogico))do begin
		read(arch_Mlogico , prod);
		if(prod.stockActual < prod.stockMinimo)then begin
			writeln(arch_texto ,'Codigo:  ', prod.codigo ,'  Precio:  ' , prod.precio , '  Stock Actual : ' , prod.stockActual , '  Stock Minimo    ', prod.stockMinimo);
			writeln(arch_texto , '  Nombre:  ' ,  prod.nombre);
		end;
	end;
	close(arch_texto);
	close(arch_Mlogico);
end;
	
var
	arch_Mlogico: maestro;	
	
	arch_Dlogico: detalle;
	
	arch_texto: text;
	
	num: integer;
begin
	writeln('Que hacemos master? Ingreso un numero para cada opcion');
	writeln('Ingrese 1 para crear archivo maestro -- 2 para crear archivo detalle ');
	writeln('Ingrese 3 para actualizar archivo maestro -- 4 para listar en archivo de texto lo pedidio ');
	writeln('Ingrese 5 para mostrar archivo de texto actualizado');
	readln(num);
	
	assign(arch_Mlogico , 'archivoMaestro.dat');
	assign(arch_Dlogico , 'archivoDetalle.dat');
	assign(arch_texto , 'stock_minimo.txt');

	case num of
		1:
		begin
			crearArchivoMaestro(arch_Mlogico);
		end;
		2:
		begin
			crearArchivoDetalle(arch_Dlogico);
		end;
		3:
		begin
			actualizarMaestro(arch_Mlogico , arch_Dlogico);
		end;
		4:
		begin
			crearArchivoTexto(arch_texto , arch_Mlogico);
		end;
	end;
end.
