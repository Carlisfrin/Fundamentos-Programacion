with Ada.Text_IO;
use Ada.Text_IO;

procedure Barcos is

	type TipoColumna is (a, b, c, d, e, f, g, h);
	subtype TipoFila is Integer range 1..10;
	
	type TipoCasilla is
	record
		columna: TipoColumna;
		fila: TipoFila;
	end record;
	
	package IntIO is new Integer_IO(Integer);
	use IntIO;
	
	package Columna_IO is new Enumeration_IO(TipoColumna);
	use Columna_IO;
	
	procedure LeerCasilla (cas: out TipoCasilla) is
	begin
		Put("Escribe la letra correspondiente a la columna:");
		New_Line;
		Get(cas.columna);
		Put("Escribe el numero correspondiente a la fila:");
		New_Line;
		Get(cas.fila);
	end;
	
	procedure Lee(ship: out TipoCasilla; shot: out TipoCasilla) is
	begin
		Put("Barco:");
		New_Line;
		LeerCasilla(ship);
		Put("Disparo:");
		New_Line;
		LeerCasilla(shot);
	end;
	
	function FilaSucesivas(fila1: TipoFila; fila2: TipoFila) return Boolean is
	begin
		if fila1 > fila2 then
			return fila1 - fila2 = 1;
		else
			return fila2 - fila1 < 2;
		end if;
	end;
	
	function ColumSucesivas(col1: TipoColumna; col2: TipoColumna) return Boolean is
	begin
		if col1 = a then
			return col1 = col2 or col2 = TipoColumna'Succ(col1);
		elsif col1 = h then
			return col1 = col2 or col2 = TipoColumna'Pred(col1);
		else
			return col1 = col2 or col2 = TipoColumna'Succ(col1) or col1 = TipoColumna'Succ(col2);
		end if;
	end;
	
	function TestCerca (cas1: TipoCasilla; cas2: TipoCasilla) return Boolean is
	begin
		return FilaSucesivas(cas1.fila, cas2.fila) and ColumSucesivas(cas1.columna, cas2.columna);
	end;
	
	procedure Escribe(defensa: in TipoCasilla; ataque: in TipoCasilla) is
	begin
		if ataque = defensa then
			Put("Hundido");
		else
			if TestCerca(defensa, ataque) then
				Put("Cerca");
			else
				Put("Agua");
			end if;
		end if;
	end;
	
	barco: TipoCasilla;
	disparo: TipoCasilla;
	
begin
	Lee(barco,disparo);
	Escribe(barco, disparo);
end;