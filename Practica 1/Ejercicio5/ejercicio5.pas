{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.
}

program ejercicio5;
type
	celular = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		marca: string;
		precio: real;
		stockMin: integer;
		stockDispo: integer;
	end;
	
	archivo = file of celular;
	
procedure leerCelular(var celu: celular);	
begin
	writeln('Escriba la marca del telefono');
	readln(celu.marca);
	if(celu.marca <> 'fin')then begin
		writeln('Escriba el nombre del telefono');
		readln(celu.nombre);
		writeln('Escriba la descripcion del telefono');
		readln(celu.descripcion);
		writeln('Escriba el codigo del telefono');
		readln(celu.codigo);
		writeln('Escriba el precio del telefono');
		readln(celu.precio);
		writeln('Escriba el stock minimo del telefono');
		readln(celu.stockMin);
		writeln('Escriba el stock disponible del telefono');
		readln(celu.stockDispo);
	end;
end;
	
procedure crearArchivoAuxiliar(var arch_logicoAux: archivo ; arch_fisicoAux: string ; var arch_texto: Text ; texto_fisico: string);
var
	celu: celular;
begin
		rewrite(arch_logicoAux);
		leerCelular(celu);
		while(celu.marca <> 'fin')do begin
			write(arch_logicoAux , celu);
			leerCelular(celu);
		end;
		close(arch_logicoAux);
		
		reset(arch_logicoAux); {abro archivo con el que cargar texto}
		rewrite(arch_texto);
		while(not eof(arch_logicoAux))do begin   {carga del texto}
			read(arch_logicoAux , celu);
			writeln(arch_texto , celu.codigo ,'    ',celu.precio:2:1, '    ' ,celu.marca);
			writeln(arch_texto , celu.stockDispo , '    ' , celu.stockMin , '    '  ,celu.descripcion);
			writeln(arch_texto , celu.nombre);
		end;
		close(arch_texto);
		close(arch_logicoAux);
end;
	
procedure informarCelu(celu: celular);
begin
	writeln('Codigo del telefono: ' , celu.codigo);
	writeln('Precio del telefono: ' , celu.precio);
	writeln('Marca del telefono: ' , celu.marca);
	writeln('Stock disponible del telefono: ' , celu.stockDispo);
	writeln('Stock minimo del telefono: ' , celu.stockMin);
	writeln('Descripcion del telefono: ' , celu.descripcion);
	writeln('Nombre del telefono: ' , celu.nombre);
end;	
	
var
	aux: integer;
	celu: celular;
	
	arch_logicoAux: archivo;
	arch_fisicoAux: string[128];
	
	arch_texto: Text;
	texto_fisico: string[128];
	
	arch_logicoA: archivo;
	arch_fisicoA: string[128];
	
	cadena: string;
begin

	writeln('¿Que vamos a hacer?. Escribir 1 para crear archivo auxiliar, 2 para crear archivo para inciso A con el textp que se dispone');
	writeln('Para hacer el inciso B, presione 3,  para hacer el inciso c presione 4 o por ultimo para el D presione 5');
	readln(aux);
		
		arch_fisicoAux := 'archivoAux.dat';      {en esto se basa el primer archivo de texto}
		assign(arch_logicoAux , arch_fisicoAux);
		
		texto_fisico := 'celulares.txt';     {se supone que este archivo se dispone}
		assign(arch_texto , texto_fisico);   {tener cuidado con el alcance}
		
		arch_fisicoA:= 'incisoA.dat';
		assign(arch_logicoA , arch_fisicoA);
			
	if(aux = 1)then begin
		
		crearArchivoAuxiliar(arch_logicoAux , arch_fisicoAux , arch_texto , texto_fisico);
	end
	else
		if(aux=2)then begin
			reset(arch_texto);
			rewrite(arch_logicoA);
			while(not eof(arch_texto))do begin
				readln(arch_texto , celu.codigo  , celu.precio , celu.marca);
				readln(arch_texto , celu.stockDispo , celu.stockMin , celu.descripcion);
				readln(arch_texto , celu.nombre);
				write(arch_logicoA , celu);
			end;
			
			close(arch_logicoA);
			close(arch_texto);
		end
		else
			if(aux = 3)then begin
				reset(arch_logicoA);
				while(not eof(arch_logicoA))do begin
					read(arch_logicoA , celu);
					if(celu.stockDispo < celu.stockMin)then 
						informarCelu(celu);
				end;
				close(arch_logicoA);
			end
			else
				if(aux = 4)then begin
					writeln('ingrese una descripcion para buscar un telefono');
					readln(cadena);
					reset(arch_logicoA);
					while(not eof(arch_logicoA))do begin
						read(arch_logicoA , celu);
						if(celu.descripcion = cadena)then 
							informarCelu(celu);                {tener en cuenta los espacios a la hora de cargar cadena}
					end;
					close(arch_logicoA);
				end
				else
					if(aux = 5)then begin
						reset(arch_logicoA);
						rewrite(arch_texto);
						while(not eof(arch_logicoA))do begin
							read(arch_logicoA , celu);
							writeln(arch_texto , celu.codigo ,'    ',celu.precio:2:1, '    ' ,celu.marca);
							writeln(arch_texto , celu.stockDispo , '    ' , celu.stockMin , '    '  ,celu.descripcion);
							writeln(arch_texto , celu.nombre);
						end;
						close(arch_texto);
						close(arch_logicoA);
					end;
end.
