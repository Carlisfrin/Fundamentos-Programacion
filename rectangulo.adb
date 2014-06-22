with Ada.Text_IO;
use Ada.Text_IO;

procedure Rectangulo is

	--Comprueba las coordenadas en X
	function TestX(px1,px2,rx1,rx2:Integer) return Boolean is
	begin
		if px1 < rx1 and px2 < rx1 then
			return false;
		elsif px1 > rx2 and px2 > rx2 then
			return false;
		else
			return true;
		end if;
	end;
	
	--Comprueba las coordenadas en Y		
	function TestY(py1,py2,ry1,ry2:Integer) return Boolean is
	begin
		if py1 < ry2 and py2 < ry2 then
			return false;
		elsif py1 > ry1 and py2 > ry1 then
			return false;
		else
			return true;
		end if;
	end;
	
	--Comprueba que se cumplan las condiciones en X e Y a la vez	
	function HayIntersec(ax1,ay1,ax2,ay2,bx1,by1,bx2,by2:Integer) return Boolean is
	begin
		return TestX(ax1,ax2,bx1,bx2) and TestY(ay1,ay2,by1,by2);
	end;
	
	--Prueba con los casos más destacados	
	PruebaCort: constant Boolean := HayIntersec(0,2,2,0,1,3,3,1);
	PruebaCruz: constant Boolean := HayIntersec(1,2,5,1,3,3,4,0);
	PruebaExt: constant Boolean := HayIntersec(1,2,5,0,2,6,5,3);
	
begin
	if PruebaCort then
		Put("Existe interseccion entre [(0,2), (2,0)] y [(1,3), (3,1)]");
	else
		Put("La interseccion es vacia entre [(0,2), (2,0)] y [(1,3), (3,1)]");
	end if;
	New_Line;	
	if PruebaCruz then
		Put("Existe interseccion entre [(1,2), (5,1)] y [(3,3), (4,0)]");
	else
		Put("La interseccion es vacia entre [(1,2), (5,1)] y [(3,3), (4,0)]");
	end if;
	New_Line;	
	if PruebaExt then
		Put("Existe interseccion entre [(1,2), (5,0)] y [(2,6), (5,3)]");
	else
		Put("La interseccion es vacia entre [(1,2), (5,0)] y [(2,6), (5,3)]");
	end if;
end;