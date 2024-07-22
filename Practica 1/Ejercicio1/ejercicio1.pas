program ejercicio1;
type
	archivo = file of integer;
var
	arch_logico: archivo;
	arch_fisico: string[127];
	nro: integer;
begin
	writeln('ingrese la direccion del archivo');
	arch_fisico := 'ejercicio1.dat';
	assign(arch_logico, arch_fisico);
	rewrite(arch_logico);
	writeln('ingrese un numero');
	read(nro);
	while(nro <> 30000)do begin
		write(arch_logico , nro); {escritura del archivo}
		writeln('ingrese otro numero');
		read(nro);
	end;
	close(arch_logico);
end.
