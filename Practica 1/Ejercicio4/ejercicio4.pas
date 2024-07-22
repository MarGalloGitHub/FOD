{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}
program ejercicio4;


type
	empleado = record
		numero: integer;
		apellido: string;
		nombre: string;
		edad: integer;
		dni: integer;
	end;
	
	archivo = file of empleado;

procedure leerEmpleado(var emple: empleado);
begin
	writeln('escriba un apellido');
	readln(emple.apellido);
	if(emple.apellido <> 'fin')then begin
		writeln('escriba un numero de empleado');
		readln(emple.numero);
		writeln('escriba un nombre');
		readln(emple.nombre);
		writeln('escriba la edad del empleado');
		readln(emple.edad);
		writeln('escriba el dni del empleado');
		readln(emple.dni);
	end;	
end;

procedure informarEmpleado(emple: empleado);
begin
	writeln('Datos del empleado:  ' , '\n' , 'Nombre:  ' , emple.nombre, ',Apellido:  ' , emple.apellido , ', numero de empleado:  ' , emple.numero , ', edad:  ', emple.edad, ' y por ultimo su dni:  ' , emple.dni);
end;

procedure listadoTres(var arch_logico: archivo);
var
	emple: empleado;
begin
	reset(arch_logico);
	while(not eof(arch_logico))do begin
		read(arch_logico , emple);
		informarEmpleado(emple);
	end;
	close(arch_logico);
end;

procedure siPuedoAgrego(var arch_logico: archivo ; emple: empleado);
var
	puedo: boolean;
	emple2: empleado;
begin
	puedo:= true;
    reset( arch_logico ); 
	while(not eof(arch_logico))do begin
		read(arch_logico , emple2);
		if(emple2.numero = emple.numero)then
			puedo:= false;	
	end;
    close( arch_logico );  {preguntar si hace falta}
    reset( arch_logico);
    if(puedo = true)then begin
		seek( arch_logico, filesize(arch_logico)); 
		write(arch_logico, emple);
	end;
	close( arch_logico );
end;

procedure cambiarEdad(var arch_logico: archivo);
var
	edad,pos: integer;
	emple: empleado;
	nombre: string;
	puedo: boolean;
begin
	writeln('a que empleado vamos a cambiar su edad?');
	read(nombre);
	writeln('cual es su edad correcta?');
	read(edad);
	puedo:= false;
	reset(arch_logico);
	while((not eof(arch_logico)) AND (puedo = false))do begin
		read(arch_logico , emple);
		if(emple.nombre = nombre)then begin
			puedo:= true;
			pos:= filepos(arch_logico) - 1;
		end;	
	end;
	close(arch_logico);
	reset(arch_logico);
	if(puedo = true)then begin
		seek(arch_logico , pos);
		read(arch_logico , emple);
		emple.edad:= edad;
		seek(arch_logico , filepos(arch_logico) - 1);
		write(arch_logico , emple);
	end;
	close(arch_logico);
end;

procedure exportar1(var arch_logico: archivo ; var archivo_texto: Text);
var 
	emple: empleado;
begin
	reset(arch_logico);
	rewrite(archivo_texto);
	while(not eof(arch_logico))do begin
		read(arch_logico , emple);
		writeln(archivo_texto , emple.apellido);  
		writeln(archivo_texto , emple.nombre);
		write(archivo_texto , '   ' , emple.numero, '    ', emple.edad, '   ', emple.dni);
	end;
	close(archivo_texto);
	close(arch_logico);
end;

procedure exportar2(var arch_logico: archivo ; var archivo_texto2: Text);
var 
	emple: empleado;
begin
	reset(arch_logico);
	rewrite(archivo_texto2);
	while(not eof(arch_logico))do begin
		read(arch_logico , emple);
		if(emple.dni = 0)then begin
			writeln(archivo_texto2 , emple.apellido);  
			writeln(archivo_texto2 , emple.nombre);
			writeln(archivo_texto2 , '   ' , emple.numero, '    ', emple.edad, '   ', emple.dni);
		end;
	end;
	close(archivo_texto2);
	close(arch_logico);
end;

var
	arch_logico1: archivo;
	arch_fisico1: string[128];
	archivo_texto , archivo_texto2: Text;
	nombre_texto , nombre_texto2: string[128];
	emple: empleado;
begin
	arch_fisico1:= 'ejercicio4.dat ';
	nombre_texto:= 'todos_empleados.txt';
	nombre_texto2:= 'faltaDNIEmpleado.txt';
	assign(arch_logico1 , arch_fisico1);
	assign(archivo_texto , nombre_texto); {c}
	assign(archivo_texto2 , nombre_texto2);
	listadoTres(arch_logico1);
	leerEmpleado(emple);
	while(emple.apellido <> 'fin')do begin
		siPuedoAgrego(arch_logico1 , emple); {a}
		leerEmpleado(emple);
	end;
	cambiarEdad(arch_logico1); {b}
	listadoTres(arch_logico1);
	exportar1(arch_logico1, archivo_texto); {c}
	exportar2(arch_logico1, archivo_texto2); {d}
end.

