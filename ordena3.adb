with Ada.Text_IO;
use Ada.Text_IO;

procedure Ordena3 is

	package IntIO is new Integer_IO(Integer);
	use IntIO;
	
	procedure LeeEntero (Int: out Integer) is
	begin
		Put("Escribe un numero entero a ordenar");
		New_Line;
		Get(Int);
	end;
	
	function Compara (max: Integer; min: Integer) return Boolean is
	begin
		return max > min;
	end;
	
	procedure Ordena (a: in out Integer; b: in out Integer; c: in out Integer) is
		aux: Integer;
	begin
		if Compara(a,b) then
			aux := b;
			b := a;
			a := aux;
		end if;
		if Compara(a,c) then
			aux := a;
			a := c;
			c := b;
			b := aux;
		elsif not Compara(a,c) and Compara(b,c) then
			aux := b;
			b := c;
			c := aux;
		end if;
	end;	
	
	a: Integer;
	b: Integer;
	c: Integer;
begin
	LeeEntero(a);
	LeeEntero(b);
	LeeEntero(c);
	Ordena(a,b,c);
	Put(a);
	Put(b);
	Put(c);
end;