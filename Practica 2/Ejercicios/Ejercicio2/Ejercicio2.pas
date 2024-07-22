program Ejercicio2;													esta mal, mirar bien para usar el leer

type
	alumno = record
		codigo: integer;
		cantMateriasSinFinal: integer;
		cantMateriasConFinal: integer;
		apellido: string;
		nombre: string;
	end;
	
	archivo = file of alumno;
	
	info = record
		codigo: integer;
		aproboFinal: string;
	end;
	
	detalle = file of info;
	
procedure leerAlumno(var alu: alumno);
begin
	writeln('escriba el codigo del alumno');
	readln(alu.codigo);
	if(alu.codigo <> 0)then begin
		writeln('escriba la cantidad de materias sin Final');
		readln(alu.cantMateriasSinFinal);
		writeln('escriba la cantidad de materias pero con Final aprobado');
		readln(alu.cantMateriasConFinal);
		writeln('escriba el apellido del alumno');
		readln(alu.apellido);
		writeln('escriba el nombre del alumno');
		readln(alu.nombre);
	end;
end;	

procedure leerInfo(var informacion: info);
begin
	writeln('escriba el codigo del alumno para el detalle');
	readln(informacion.codigo);
	if(informacion.codigo <> 0)then begin
		writeln('escriba APROBO si aprobo el final, caso contrario DESAPROBO');
		readln(informacion.aproboFinal);
	end;	
end;
	
procedure crearArchivoMaestro(var arch_Maestro: archivo);
var
	alu: alumno;
begin
	rewrite(arch_Maestro);
	leerAlumno(alu);
	while(alu.codigo <> 0)do begin
		write(arch_Maestro , alu);											//carga en archivo binario
		leerAlumno(alu);
	end;
	close(arch_Maestro);
end;

procedure crearArchivoDetalle(var arch_detalle: detalle);
var
	informacion: info;
begin
	rewrite(arch_detalle);
	leerInfo(informacion);
	while(informacion.codigo <> 0) do begin
		write(arch_detalle , informacion);
		leerInfo(informacion);
	end;
	close(arch_detalle);
end;

procedure actualizarMaestro(var arch_Maestro: archivo ; var arch_detalle: detalle);			//actualizar maestro con detalle que tiene datos repetiros
var
	informacion: info;
	alu: alumno;
begin
	reset(arch_Maestro);
	reset(arch_detalle);
	while(not eof(arch_detalle))do begin
		read(arch_Maestro , alu);
		read(arch_detalle, informacion);
		while(alu.codigo <> informacion.codigo)do 
			read(arch_maestro , alu);
		while((not eof(arch_detalle)) AND (alu.codigo = informacion.codigo))do begin			//aca hacer lo particular
			if(informacion.aproboFinal = 'APROBO')then begin
				alu.cantMateriasConFinal := alu.cantMateriasConFinal + 1;
				alu.cantMateriasSinFinal := alu.cantMateriasSinFinal - 1;
			end
			else
				if(informacion.aproboFinal = 'DESAPROBO')then begin
					alu.cantMateriasSinFinal := alu.cantMateriasSinFinal + 1;
				end;
			read(arch_detalle , informacion);
		end;
		if(not eof(arch_detalle))then 
			seek(arch_detalle , filepos(arch_detalle) - 1);
		seek(arch_Maestro , filepos(arch_Maestro ) - 1);
		write(arch_Maestro , alu);
	end;
	close(arch_detalle);
	close(arch_Maestro);
end;

procedure leerMaestro(var arch_Maestro: archivo);
var
	alu: alumno;
begin
	reset(arch_Maestro);
	while(not eof(arch_Maestro))do begin
		read(arch_Maestro , alu);
		writeln('Datos del alumno');
		writeln('Nombre:  ', alu.nombre);
		writeln('Apellido:  ', alu.apellido);
		writeln('Codigo:  ', alu.codigo);
		writeln('Cantidad de materias sin final:  ', alu.cantMateriasSinFinal);
		writeln('Cantidad de materias con final:  ', alu.cantMateriasConFinal);
	end;
	close(arch_Maestro);
end;

var
	arch_Maestro: archivo;
	arch_Mfisico: string[128];
	
	
	arch_detalle: detalle;
	arch_Dfisico: string[128];
	
	num: integer;
begin
	writeln('Que hacemos master? 1: crear Archivo maestro , 2: crear archivo detalle , 3: actualizas maestro , 4: listar maestro en archivo de texto');
	readln(num);
	
	arch_Mfisico := 'archivoMaestro.dat';
	assign(arch_Maestro , arch_Mfisico);
	
	arch_Dfisico:= 'archivoDetalle.dat';
	assign(arch_detalle , arch_Dfisico);
	
	
	case num of
		1:
		begin
			crearArchivoMaestro(arch_Maestro);
		end;
		2:
		begin
			crearArchivoDetalle(arch_detalle);
		end;
		3: 
		begin
			actualizarMaestro(arch_Maestro , arch_detalle);
		end;
		4:
		begin
			leerMaestro(arch_Maestro);
		end;
	end;
end.
