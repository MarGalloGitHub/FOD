program ejercicio3;
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
	
procedure listadoUno(var arch_logico: archivo);
var
	apeOnom: string;
	emple: empleado;
begin
	writeln('escriba un nombre o un apellido');
	read(apeOnom);
	reset(arch_logico);
	while(not eof(arch_logico))do begin
		read(arch_logico , emple);
		if((emple.apellido = apeOnom) OR (emple.nombre = apeOnom))then 
			informarEmpleado(emple);
	end;
	close(arch_logico);
end;	

procedure listadoDos(var arch_logico: archivo);
var
	emple: empleado;
begin
	reset(arch_logico);
	while(not eof(arch_logico))do begin
		read(arch_logico , emple);
		if(emple.edad > 70)then 
			informarEmpleado(emple);
	end;
	close(arch_logico);
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
	
var
	arch_logico: archivo;
	arch_fisico: string[128];
	emple: empleado;
begin
	arch_fisico:= 'ejercicio3.dat ';
	assign(arch_logico , arch_fisico);
	rewrite(arch_logico);
	leerEmpleado(emple);
	while(emple.apellido <> 'fin')do begin
		write(arch_logico , emple);
		leerEmpleado(emple);
	end;
	close(arch_logico);	
	listadoUno(arch_logico);
	listadoDos(arch_logico);
	listadoTres(arch_logico);
end.
