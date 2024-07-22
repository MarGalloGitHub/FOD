
program Ejercicio1;

const
	valorAlto = 9999;
type
	empleado = record
		codigo : integer;
		nombre : string;
		montoComision : real;
	end;
	
	archivo = file of empleado;

procedure leerEmpleado(var emple: empleado);
begin
	writeln('Escriba el codigo del empleado');
	readln(emple.codigo);
	if(emple.codigo <> 0)then begin
		writeln('Escriba el nombre del empleado');
		readln(emple.nombre);
		writeln('Escriba el monto por comision del empleado');
		readln(emple.montoComision);
	end;
end;

procedure crearArchivoTexto(var arch_texto: text);
var
	emple : empleado;
begin
	rewrite(arch_texto);
	leerEmpleado(emple);
	while(emple.codigo <> 0)do begin
		writeln(arch_texto , emple.codigo);
		writeln(arch_texto ,emple.montoComision);
		writeln(arch_texto , emple.nombre);
		leerEmpleado(emple);
	end;
	close(arch_texto);
end;

procedure crearArchivoBinario(var arch_logico1: archivo ; var arch_texto: text);
var
	emple: empleado;
begin
	rewrite(arch_logico1);
	reset(arch_texto);
	while(not eof(arch_texto))do begin
		readln(arch_texto , emple.codigo);
		readln(arch_texto , emple.montoComision);
		readln(arch_texto , emple.nombre);
		write(arch_logico1 , emple);
	end;
	close(arch_texto);	
	close(arch_logico1);
end;


procedure leer(var archivo: archivo ; var emple: empleado);
begin
	if(not eof(archivo))then begin
		read(archivo , emple)
	end
	else
		emple.codigo:= valorAlto;
end;

procedure crearArchivoCompacto(var arch_compacto: archivo ; var arch_logico1: archivo);
var
	aux,emple: empleado;
	montoTotal: real;
begin
	rewrite(arch_compacto);
	reset(arch_logico1);
	leer(arch_logico1 , emple);
	while(emple.codigo <> valorAlto)do begin
		aux:= emple;
		montoTotal:= 0;
		while(aux.codigo = emple.codigo)do begin
			montoTotal:= montoTotal + emple.montoComision;
			leer(arch_logico1 , emple);
		end;
		aux.montoComision := montoTotal;
		write(arch_compacto , aux);
	end;
	close(arch_logico1);
	close(arch_compacto);
end;

procedure leerArchivoOriginal(var arch_logico1: archivo);
var
	emple: empleado;
begin
	reset(arch_logico1);
	while(not eof(arch_logico1))do begin
		read(arch_logico1, emple);
		writeln('');
		write('Datos del empleado: Codigo:  ', emple.codigo , '--Monto Comision Total: ', emple.montoComision:2:1 , '--Nombre: ' , emple.nombre);
	end;
	close(arch_logico1);
end;

procedure leerArchivoCompacto(var arch_compacto: archivo);
var
	emple: empleado;
begin
	reset(arch_compacto);
	while(not eof(arch_compacto))do begin
		read(arch_compacto, emple);
		writeln('');
		write('Datos del empleado: Codigo:  ', emple.codigo , '--Monto Comision Total: ', emple.montoComision:2:1 , '--Nombre: ' , emple.nombre);
	end;
	close(arch_compacto);
end;

var
	arch_logico1: archivo;
	arch_fisico1: string[128];
	
	arch_compacto: archivo;
	arch_fisico2: string[128];
	
	arch_texto: text;
	arch_textoFisico: string[128];

	
	num : integer;
begin
	Writeln('Escriba un numero para realizar operacion: 1, para crear archivo de texto con datos empleados, 2 para crear archivo binario de empleados , 3 para crear archivo compacto');
	writeln('Escriba 4 para leer archivos');
	readln(num);
	
	arch_textoFisico := 'textoDeEmpleados.txt';				//preguntar esto en clase
	assign(arch_texto , arch_textoFisico);
	
	arch_fisico1:= 'EmpleadosBinario.dat';
	assign(arch_logico1 , arch_fisico1);
	
	arch_fisico2:= 'ArchivoCompacto.dat';
	assign(arch_compacto , arch_fisico2);
	
	case num of 
		1:
		begin
			crearArchivoTexto(arch_texto);
		end;
	    2:
	    begin
			crearArchivoBinario(arch_logico1 , arch_texto);
		end;
		3:
		begin
			crearArchivoCompacto(arch_compacto , arch_logico1);
		end;
		4:
		begin
			writeln('Ahora el archivo de empleados original');
			leerArchivoOriginal(arch_logico1);
			writeln('Ahora el archivo compacto');
			leerArchivoCompacto(arch_compacto);
		end;
	end;
end.
