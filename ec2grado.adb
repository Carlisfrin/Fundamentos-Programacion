with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Numerics.Generic_Elementary_Functions;
use Ada.Numerics;

procedure Ec2Grado is

	package FIO is new Float_IO(Float);
	use FIO;
	
	package Math is new Generic_Elementary_Functions(Float);
	use Math;
	
	function Real (a:Float; b:Float; c:Float) return Boolean is
	begin
		return (b**2 - 4.0 * a * c) >= 0.0 ;
	end;
	
	function UnaSoluc (a:Float; b:Float; c:Float) return Boolean is
	begin
		return (b**2 - 4.0 * a * c) = 0.0 ;
	end;

	function Sol1(a: Float; b: Float; c: Float) return Float is
	begin
		return ( - b + sqrt( (b**2) - (4.0 * a * c))) / 2.0 * a ;
	end;

	function Sol2(a: Float; b: Float; c: Float) return Float is
	begin
		return ( - b - sqrt( (b**2) - (4.0 * a * c))) / 2.0*a ;
	end;
	
	function SolReal (a: Float; b:Float) return Float is
	begin
		return -b / (2.0*a);
	end;
	
	function SolImag (a:Float; b:Float; c:Float) return Float is
	begin
		return sqrt(abs((b**2) - (4.0*a*c))) / 2.0*a;
	end;
	
	a: constant Float := 1.0;
	b: constant Float := 2.0;
	c: constant Float := 2.0;
	
begin
	if Real(a,b,c) and UnaSoluc(a,b,c) then
		Put("Su solucion es un numero real doble");
		New_Line;
		Put(Sol1(a, b, c));
	elsif not Real(a, b, c) then
		Put("Su solucion son dos numeros imaginarios conjugados");
		New_Line;
		Put(SolReal(a,b));
		Put(" +/-");
		Put(SolImag(a,b,c));
		Put(" j");
	else 
		Put("Su solucion son dos numeros reales");
		New_Line;
		Put(Sol1(a, b, c));
		New_Line;
		Put(Sol2(a, b, c));
	end if;
end;