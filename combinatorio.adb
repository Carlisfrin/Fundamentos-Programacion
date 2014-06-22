with Ada.Text_IO;
use Ada.Text_IO;

procedure Combinatorio is

	package IntIO is new Integer_IO(Integer);
	use IntIO;
	
	procedure LeeClave(numero: out Integer) is
	begin
		Put("Escribe cuantas operaciones deseas realizar");
		New_Line;
		Get(numero);
	end;
	
	procedure LeeCombinatorio(combina1: out Integer; combina2: out Integer) is
	begin
		Put("Escribe el primer digito a combinar: ");
		Get(combina1);
		Put("Escribe el segundo digito a combinar: ");
		Get(combina2);
	end;
	
	function Factorial (factor: Integer) return Integer is
		acumulador: Integer;
	begin
		acumulador := 1;
		for i in 1..factor loop
			acumulador := acumulador * i;
		end loop;
		return acumulador;
	end;
	
	function CalculaCombinatorio(n: Integer; p: Integer) return Integer is
	begin
		return Factorial(n) / (Factorial(p) * Factorial(n - p));
	end;
	
	procedure EscribeSolucion(combina1: in Integer; combina2: in Integer; solucion: out Integer) is
	begin
		solucion := CalculaCombinatorio(combina1, combina2);
		Put("El resultado es: ");
		Put(solucion);
		New_Line;
		New_Line;
	end;
	
	procedure CompruebaMayor(sol: in Integer; max: in out Integer) is
	begin
		if sol > max then
			max := sol;
		end if;
	end;
	
	cantidad: Integer;
	comb1: Integer;
	comb2: Integer;
	soluc: Integer;
	mayor: Integer;
	
begin
	LeeClave(cantidad);
	mayor := 0;
	for i in 1..cantidad loop
		LeeCombinatorio(comb1, comb2);
		EscribeSolucion(comb1, comb2, soluc);
		CompruebaMayor(soluc, mayor);
	end loop;
	Put("El mayor resultado es: ");
	Put(mayor);
end;