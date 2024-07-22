program testeo;
const
	valorAlto = '9999';
type
	infoProvincia = record
		nombre: string;
		codigo: integer;
		cantidadAlfabetizadas: integer;
		totalEncuestados: integer;
	end;
	
	archivo = file of infoProvincia;

procedure leerInfo(var info: infoProvincia);
begin
	writeln('escriba el nombre de la provincia');
	readln(info.nombre);
	if(info.nombre <> 'fin')then begin
		writeln('escriba el codigo de la localidad');
		readln(info.codigo);
		writeln('escriba la cantidad de personas alfabetizadas');
		readln(info.cantidadAlfabetizadas);
		writeln('escriba la cantidad de personas encuestadas');
		readln(info.totalEncuestados);
	end;
end;

procedure crearArchivoMaestro(var arch_maestro: archivo);
var
	info: infoProvincia;
begin
	rewrite(arch_maestro);
	leerInfo(info);
	while(info.nombre <> 'fin')do begin
		write(arch_maestro , info);
		leerInfo(info);
	end;
	close(arch_maestro);
end;

procedure crearArchivoDetalle(var arch_detalle: archivo);
var
	info: infoProvincia;
begin
	rewrite(arch_detalle);
	leerInfo(info);
	write(arch_detalle , info);
	close(arch_detalle);
end;

procedure leer(var archivo: archivo ; var info: infoProvincia);
begin
	if(not eof(archivo))then 
		read(archivo , info)
	else
		info.nombre := valorAlto;
end;

procedure minimo(var r1,r2 : infoProvincia ; var min: infoProvincia ; var arch_detalle1: archivo ; var arch_detalle2: archivo);
begin
	if(r1.nombre < r2.nombre)then begin
		min:= r1;
		leer(arch_detalle1 , r1);
	end
	else begin
		min:= r2;
		leer(arch_detalle2 , r2);
	end;
end;

procedure actualizarMaestro(var arch_maestro: archivo ; var arch_detalle1: archivo ; var arch_detalle2: archivo);
var
	infoM , infoD1 , infoD2 , min : infoProvincia;
begin
	reset(arch_detalle1);
	reset(arch_detalle2);
	reset(arch_maestro);
	leer(arch_detalle1 , infoD1);
	leer(arch_detalle2 , infoD2);
	minimo(infoD1 , infoD2 , min , arch_detalle1 , arch_detalle2);
	while(min.nombre <> valorAlto)do begin
		read(arch_maestro , infoM);
		while(infoM.nombre <> min.nombre) do begin
			read(arch_maestro , infoM);
		end;
		while(infoM.nombre = min.nombre)do begin
			infoM.cantidadAlfabetizadas	:= min.cantidadAlfabetizadas;					//aca la actualizacion
			infoM.totalEncuestados := min.totalEncuestados;
			minimo(infoD1, infoD2 , min , arch_detalle1 , arch_detalle2);																
		end;
		seek(arch_maestro , filepos(arch_maestro)- 1);
		write(arch_maestro , infoM);
	end;
	close(arch_maestro);
	close(arch_detalle2);
	close(arch_detalle1);
end;

procedure mostrarMaestro(var arch_maestro: archivo);
var
	info: infoProvincia;
begin
	reset(arch_maestro);
	while(not eof(arch_maestro))do begin
		read(arch_maestro , info);
		writeln('Info de la provincia');
		writeln('Nombre: ' , info.nombre , ' -- Codigo:  ' , info.codigo);
		writeln('Cantidad de personas alfabetizadas: ' , info.cantidadAlfabetizadas , ' -- Cantidad de entrevistados:  ' , info.totalEncuestados);
	end;	
	close(arch_maestro);
end;

var
	arch_maestro: archivo;
	arch_detalle: archivo;
	arch_detalleDos: archivo;
	
	num: integer;
begin
	writeln('capo escribi que vamos a hacer');
	writeln('Ingresa 1 para crear el maestro -- Ingrese 2 para mostrar ese archivo maestro -- Ingresa 3 para crear un archivo detalle');
	writeln('Ingrese 4 para crear otro archivo -- Ingresa 5 para actualizar maestro -- Ingresa 6 para mostrar archivo maestro');
	readln(num);
	
	assign(arch_maestro , 'ArchivoMaestro.dat');
	assign(arch_detalle , 'ArchivoDetalle1.dat');
	assign(arch_detalleDos , 'ArchivoDetalle2.dat');
	
	case num of
		1:
		begin
			crearArchivoMaestro(arch_maestro);
		end;
		2:
		begin
			mostrarMaestro(arch_maestro);
		end;
		3:
		begin
			crearArchivoDetalle(arch_detalle);
		end;
		4:
		begin
			crearArchivoDetalle(arch_detalleDos);
		end;
		5:
		begin
			actualizarMaestro(arch_maestro , arch_detalle , arch_detalleDos);
		end;
		6:
		begin
			mostrarMaestro(arch_maestro);
		end;
	end;
end.
