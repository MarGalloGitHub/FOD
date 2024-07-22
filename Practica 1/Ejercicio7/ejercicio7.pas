{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ejercicio7;
type
	
	novela = record
		nombre: string;
		genero: string;
		precio: real;
		codigo: integer
	end;

	archivo = file of novela;

procedure leerNovela(var nov: novela);
begin
	writeln('escriba el nombre de la novela');
	readln(nov.nombre);
	if(nov.nombre <> 'fin')then begin
		writeln('escriba el genero de la novela');
		readln(nov.genero);
		writeln('escriba el precio de la novela');
		readln(nov.precio);
		writeln('escriba el codigo de la novela');
		readln(nov.codigo);
	end;
end;
	
	
var
	arch_logico: archivo;
	arch_fisico: string[128];
	
	arch_texto: Text;
	texto_fisico: string[128];
	
	nov: novela;
	num: integer;
	nombreNov: string;
	
	codigoAux: integer;
	precioAux: real;
	generoAux: string;
begin
	arch_fisico:= 'auxiliar.dat';					{area de inicializacion de archivos}
	texto_fisico:= 'novelas.txt';
	assign(arch_logico , arch_fisico);
	assign(arch_texto , texto_fisico);    
	
	writeln('Que vamos a hacer? Para crear archivo de texto auxiliar presione 1 - Para crear archivo en base a texto auxliar presione 2');
	writeln('Para agregar una novela presione 3 - Para modificar una novela presione 4');
	readln(num);
	
	if(num = 1)then begin
		rewrite(arch_texto);
		leerNovela(nov);
		while(nov.nombre <> 'fin')do begin					
			writeln(arch_texto , nov.codigo, '    ' , nov.precio:2:0 , '    ', nov.genero);  {carga de lo que se dispone}
			writeln(arch_texto , nov.nombre);
			leerNovela(nov);
		end;
		close(arch_texto);
	end
	else
		if(num = 2)then begin
			rewrite(arch_logico);
			reset(arch_texto);
			while(not eof(arch_texto))do begin       {creacion de archivo en base a un texto, mirar como estan ordenadas las cargas y lecturas}
				readln(arch_texto , nov.codigo, nov.precio , nov.genero);
				readln(arch_texto, nov.nombre);
				write(arch_logico , nov);
			end;
			close(arch_texto);
			close(arch_logico);
		end
		else
			if(num = 3)then begin  {agregar novela}
				reset(arch_logico);
				leerNovela(nov);
				seek(arch_logico, filesize(arch_logico));
				write(arch_logico , nov);
				close(arch_logico);
			end
			else
				if(num = 4)then begin  {modificar una novela }
					writeln('escriba el nombre de la novela que se desea modificar');
					readln(nombreNov);
					reset(arch_logico);
					while(not eof(arch_logico))do begin
						read(arch_logico , nov);
						if(nov.nombre = nombreNov)then begin
							writeln('jefe aca hay una');
							writeln('ingrese un nuevo precio');
							
							readln(precioAux);
							writeln('ingrese un nuevo codigo');
							readln(codigoAux);
							writeln('escriba un genero nuevo');
							readln(generoAux);
	
							nov.precio:= precioAux;          {preguntar que onda los modulos}
							nov.codigo:= codigoAux;
							nov.genero:= generoAux;
							seek(arch_logico , filepos(arch_logico) - 1);
							write(arch_logico , nov);
						end;
					end;
					close(arch_logico);
				end;
end.
