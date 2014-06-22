with Ada.Text_IO;
use Ada.Text_IO;

procedure Notas is

	type TipoTest is (Apto, NoApto);
	
	subtype TipoExamen is Float range 0.0..10.0;

	type TipoAlumno is
	record
		test: TipoTest;
		examen1: TipoExamen;
		examen2: TipoExamen;
	end record;
	
	package Test_IO is new Enumeration_IO(TipoTest);
	use Test_IO;

	package FIO is new Float_IO(Float);
	use FIO;
	
	procedure LeeTest (test: out TipoTest) is
	begin
		Put("Escribe el resultado del test:(Apto/NoApto)");
		New_Line;
		Get(test);
	end;
	
	procedure LeeExamen (nota: out TipoExamen) is
	begin
		Put("Escribe la nota:");
		New_Line;
		Get(nota);
	end;
	
	function TestApto (test: TipoTest) return Boolean is
	begin
		return test = Apto;
	end;
	
	procedure LeeAlumno (alumno: in out TipoAlumno) is
	begin
		LeeTest(alumno.test);
		if TestApto(alumno.test) then
			Put("Primer examen:");
			New_Line;
			LeeExamen(alumno.examen1);
			Put("Segundo examen:");
			New_Line;
			LeeExamen(alumno.examen2);
		else
			alumno.examen1 := 0.0;
			alumno.examen2 := 0.0;
		end if;
	end;
	
	procedure LeeDatos (alumno1: in out TipoAlumno; alumno2: in out TipoAlumno) is
	begin
		Put("Primer alumno:");
		New_Line;
		LeeAlumno(alumno1);
		Put("Segundo alumno:");
		New_Line;
		LeeAlumno(alumno2);
	end;
	
	function NotaMedia (nota1: TipoExamen; nota2: TipoExamen) return Float is
	begin
		return (nota1 + nota2) / 2.0;
	end;

	function NotaMayor (nota1: TipoExamen; nota2: TipoExamen) return Float is
	begin
		if nota1 > nota2 then
			return nota1;
		else
			return nota2;
		end if;
	end;
	
	function MejorNota (alumno1: in TipoAlumno; alumno2: in TipoAlumno) return Float is
	media1 : Float;
	media2 : Float;
	begin
		media1 := NotaMedia (alumno1.examen1, alumno1.examen2);
		media2 := NotaMedia (alumno2.examen1, alumno2.examen2);
		return NotaMayor(media1, media2);
	end;
	
	procedure EscribeMejorNota (alumno1: in TipoAlumno; alumno2: in TipoAlumno) is
	begin
		Put("La mejor nota es:");
		New_Line;
		Put(MejorNota(alumno1, alumno2));
	end;
	
	alumno1: TipoAlumno;
	alumno2: TipoAlumno;

begin
	LeeDatos(alumno1, alumno2);
	EscribeMejorNota(alumno1, alumno2);
end;