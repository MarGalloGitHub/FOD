program ejercicio2;
type
	archivo = file of integer;
var
	arch_logico: archivo;
	arch_fisico: string[128];
	nro,cantidad,cantNumeros: integer;
	promedio: real;
begin
	promedio:= 0;
	cantNumeros:= 0;
	cantidad:= 0;
	arch_fisico:= 'ejercicio1.dat';
	assign(arch_logico , arch_fisico);   {vinculo con el archivo}
	reset(arch_logico);                 {abro archivo existente}
	while(not EOF(arch_logico))do begin
		read(arch_logico , nro);         {para mi}
		cantNumeros:= cantNumeros + 1;
		writeln('El numero es: ' , nro);
		if(nro < 1500)then
			cantidad:= cantidad + 1;
		promedio:= promedio + nro;
	end;
	Close(arch_logico);
	promedio:= (promedio / cantNumeros);
	writeln('La cantidad de numeros menores a 1500 es: ', cantidad);
	writeln('El promedio de numeros es:  ' , promedio:1:2);
end.
