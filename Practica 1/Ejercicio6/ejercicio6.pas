{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program ejercicio6;

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
	
	
var																						{variables}
	aux: integer;
	celu: celular;
	
	arch_logicoAux: archivo;
	arch_fisicoAux: string[128];
	
	arch_texto: Text;
	texto_fisico: string[128];
	
	arch_logicoA: archivo;
	arch_fisicoA: string[128];
	
	cadena: string;
	stockM: integer;
	telefonoM: string;
	
	arch_texto22: Text;
	texto22_fisico: string[128];
begin

	writeln('¿Que vamos a hacer?. Escribir 1 para crear archivo auxiliar, 2 para crear archivo para inciso A con el textp que se dispone');
	writeln('Para hacer el inciso B, presione 3,  para hacer el inciso c presione 4 o por ultimo para el D presione 5');
	writeln('Para agregar uno o mas telefonos preione 6, para modificar el stock de un celular presione 7');
	writeln('Para exportar telefonos sin stock presione 8');
	readln(aux);
		
		arch_fisicoAux := 'archivoAux.dat';      {en esto se basa el primer archivo de texto}
		assign(arch_logicoAux , arch_fisicoAux);
		
		texto_fisico := 'celulares.txt';     {se supone que este archivo se dispone}
		assign(arch_texto , texto_fisico);   {tener cuidado con el alcance}
		
		arch_fisicoA:= 'incisoA.dat';
		assign(arch_logicoA , arch_fisicoA);   {archivo para todos los incisos}
		
		texto22_fisico:= 'SinStock.txt';
		assign(arch_texto22 , texto22_fisico);
			
	if(aux = 1)then begin
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
					end
					else
						if(aux = 6)then begin     {agregar uno o mas celulares}
							leerCelular(celu);
							reset(arch_logicoA);
							seek(arch_logicoA , filesize(arch_logicoA));
							while(celu.marca <> 'fin')do begin
								write(arch_logicoA , celu);
								leerCelular(celu);
							end;
							close(arch_logicoA);
						end
						else
							if(aux = 7)then begin                                   {cambiar valor de uno o mas elementos en el registrp}
								writeln('A que telefono le cambiamos el monto');
								readln(telefonoM);
								writeln('Ingrese nuevo valor del stock');
								readln(stockM);
								reset(arch_logicoA);
								while(not eof(arch_logicoA))do begin
									read(arch_logicoA , celu);
									if(celu.nombre = telefonoM)then begin
										writeln('cambio exitoso');
										celu.stockDispo := stockM;
										seek(arch_logicoA , filepos(arch_logicoA) - 1);
										write(arch_logicoA , celu);
									end;
								end;
								close(arch_logicoA);
							end
							else
								if(aux = 8)then begin
									rewrite(arch_texto22);
									reset(arch_logicoA);
									while(not eof(arch_logicoA))do begin
										read(arch_logicoA , celu);
										if(celu.stockDispo = 0)then begin
											writeln(arch_texto22 , celu.codigo ,'    ',celu.precio:2:1, '    ' ,celu.marca);
											writeln(arch_texto22 , celu.stockDispo , '    ' , celu.stockMin , '    '  ,celu.descripcion);
											writeln(arch_texto22 , celu.nombre);
										end;	
									end;		
									close(arch_logicoA);
									close(arch_texto22);
								end;
end.

