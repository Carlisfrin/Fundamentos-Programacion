--Programa creado y modificado por Carlos Arevalo Jimenez
with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Unchecked_Deallocation;

procedure Bingo is

	filasencarton : constant Positive := 3;
	numerosenfila : constant Positive := 5;
	totalnumeros : constant Positive := numerosenfila * filasencarton;
	nombrefichero : constant String := "datos.txt";
	
	type TipoPalabra is new String(1..6);
	
	type TipoNumeroString is new String(1..3);
	
	type TipoNumero is
	record
		numero : Positive;
		tachado : Boolean;
	end record;
	
	type TipoListaNum is array (1..numerosenfila) of TipoNumero;
	
	type TipoColor is (Verde, Amarillo, Rojo, Azul);
	
	type TipoFila is
	record
		color : TipoColor;
		numeros : TipoListaNum;
	end record;
	
	type TipoCarton is array (1..filasencarton) of TipoFila;
	
	type TipoNodoCarton;
	
	type TipoListaCartones is access all TipoNodoCarton;
	
	type TipoNodoCarton is
	record
		actual : TipoCarton;
		siguiente : TipoListaCartones;
	end record;
	
	type TipoBola is
	record
		color : TipoColor;
		valor : Positive;
	end record;
	
	type TipoNodoBola;
	
	type TipoListaBolas is access all TipoNodoBola;
	
	type TipoNodoBola is
	record
		actual : TipoBola;
		siguiente : TipoListaBolas;
	end record;
	
	type TipoRespuesta is (Nada, Tachado, Linea, Bingo);
	
	package TipoColor_IO is new Enumeration_IO(TipoColor);
	use TipoColor_IO;
	
	package TipoRespuesta_IO is new Enumeration_IO(TipoRespuesta);
	use TipoRespuesta_IO;
	
	procedure DeleteBola is new Ada.Unchecked_Deallocation(TipoNodoBola,TipoListaBolas);
	
	procedure DeleteCarton is new Ada.Unchecked_Deallocation(TipoNodoCarton,TipoListaCartones);
	
	function ListaCartonesVacia return TipoListaCartones is
		j : TipoListaCartones;
	begin
		j := null;
		return j;
	end;

	procedure InsertarCarton (l : in out TipoListaCartones;
						  c : TipoCarton) is
		pnodo: TipoListaCartones;
	begin
		pnodo := new TipoNodoCarton;
		pnodo.actual := c;
		pnodo.siguiente := l;
		l := pnodo;
	end;
	
	function ListaBolasVacia return TipoListaBolas is
		j : TipoListaBolas;
	begin
		j := null;
		return j;
	end;
		
	procedure InsertarBola(l : in out TipoListaBolas;
					      c : TipoBola) is
		pnodo: TipoListaBolas;
	begin
		pnodo := new TipoNodoBola;
		pnodo.actual := c;
		pnodo.siguiente := l;
		l := pnodo;
	end;

	function FinConfig (err : Boolean;
					final : Boolean) return Boolean is
	begin
		return err or final;
	end;
	
	procedure SaltoLinea (datos : File_Type;
					    eof : out Boolean) is
		e_ol: Boolean;
		carac: Character;
	begin
		eof := End_Of_File(datos);
		if not eof then
			Look_Ahead(datos,carac,e_ol);
			while e_ol and not eof loop
				Skip_Line(datos);
				Look_Ahead(datos,carac,e_ol);
				eof := End_Of_File(datos);
			end loop;
		end if;
	end;
	
	function CharBlanco (caracter : Character) return Boolean is
	begin
		return (caracter = ' ') or (caracter = ASCII.HT);
	end;
	
	procedure LeeCaracter (fich : File_Type;
					        problem : out Boolean;
						char : out Character) is
		eol : Boolean;
	begin
		loop
			SaltoLinea(fich, problem);
			if not problem then 
				Look_Ahead(fich, char, eol);
				Get(fich, char);
			end if;
		exit when not CharBlanco(char) or problem;
		end loop;
	end;
	
	procedure BuscarPalabra (papel : File_Type;
						palabro : TipoPalabra;
						encontrado : out Boolean) is
		letra : Character;
		finlinea : Boolean;
		conta : Positive;
		stop : Boolean;
	begin
		conta := 1;
		stop := False;
		loop
			Look_Ahead(papel, letra, finlinea);
			if palabro(conta) /= ' ' and not finlinea then
				if letra /= palabro(conta) then
					stop := True;
				else
					Get(papel, letra);
				end if;
			end if;
			if finlinea and palabro(conta) = ' ' then
				conta := 6;
			end if;
			conta := conta + 1;
		exit when stop or conta = 7;
		end loop;
		encontrado := not stop;
	end;
	
	function Numeriza (letra : Character) return Natural is
	begin
		return Character'Pos(letra) - Character'Pos('0');
	end;
	
	function ColorValido (color : TipoColor) return Boolean is
	begin
		return color'Valid;
	end;

	function OrdenaFila (numbers : TipoListaNum) return TipoListaNum is
		solucion : TipoListaNum;
		auxiliar : Positive;
	begin
		solucion := numbers;
		for i in 1..numerosenfila loop
			solucion(i).tachado := False;
			for j in (i+1)..numerosenfila loop
				if solucion(j).numero < solucion(i).numero then
					auxiliar := solucion(i).numero;
					solucion(i).numero := solucion(j).numero;
					solucion(j).numero := auxiliar;
				end if;
			end loop;
		end loop;
		return solucion;
	end;
	
	procedure LeeFila (data : File_Type;
					fila : out TipoFila;
					problemo : out Boolean;
					final : out Boolean) is
		car : Character;
		linea : Boolean;
		bien : Boolean;
		palabra : TipoPalabra;
		numero : Natural;
		contador : Natural;
	begin
		contador := 0;
		final := False;
		loop
			LeeCaracter(data, problemo, car);
			case car is
			when 'a' =>
				Look_Ahead(data, car, linea);
				if car = 'm' then
					Get(data, car);
					palabra := "arillo";
					BuscarPalabra(data, palabra, bien);
					if bien then
						fila.color := Amarillo;
					else
						problemo := True;
					end if;
				elsif car = 'z' then
					Get(data, car);
					palabra := "ul    ";
					BuscarPalabra(data, palabra, bien);
					if bien then
						fila.color := Azul;
					else
						problemo := True;
					end if;
				else
					problemo := True;
				end if;
			when 'v' =>
				palabra := "erde  ";
				BuscarPalabra(data, palabra, bien);
				if bien then
					fila.color := Verde;
				else
					problemo := True;
				end if;
			when 'r' =>
				palabra := "ojo   ";
				BuscarPalabra(data, palabra, bien);
				if bien then
					fila.color := Rojo;
				else
					problemo := True;
				end if;
			when '1'..'9' =>
				if contador = 0 then
					problemo := not ColorValido(fila.color);
				end if;
				numero := Numeriza(car);
				Look_Ahead(data, car, linea);
				if car in '0'..'9' then
					Get(data, car);
					numero := (10 * numero) + Numeriza(car);
					if numero = 10 then
						Look_Ahead(data, car, linea);
						if car = '0' then
							Get(data, car);
							numero := 100;
						end if;
					end if;
				end if;
				contador := contador + 1;
				fila.numeros(contador).numero := numero;
			when 'F' =>
				palabra := "IN    ";
				BuscarPalabra(data, palabra, final);
				problemo := not final;			
			when others =>
				problemo := True;
			end case;
			if contador < numerosenfila and final then
				problemo := True;
			end if;
		exit when problemo or contador = numerosenfila or final;
		end loop;
		if contador = numerosenfila then
			fila.numeros := OrdenaFila(fila.numeros);
		end if;
	end;
	
	procedure LeeCarton (file : File_Type;
					    carton : out TipoCarton;
					    err : out Boolean;
					    finish : out Boolean) is
		lin : TipoFila;
		cont : Natural;
		c : Character;
		f : Boolean;
		palab : TipoPalabra;
		eo_file : Boolean;
	begin
		cont := 0;
		loop
			LeeFila(file, lin, err, finish);
			if not FinConfig(err, finish) then
				cont := cont + 1;
				carton(cont) := lin;
			end if;
		exit when cont = filasencarton or FinConfig(err, finish);
		end loop;
		loop
			SaltoLinea(file, eo_file);
			if not eo_file then 
				Look_Ahead(file, c, f);
				if CharBlanco(c) then
					Get(file, c);
				end if;
			end if;
		exit when not CharBlanco(c) or eo_file;
		end loop;
		if c = 'F' then
			Get(file, c);
			palab := "IN    ";
			BuscarPalabra(file, palab, f);
			finish := f;
			err := not f;
		end if;
	end;
	
	function CartonValido (cart : TipoCarton) return Boolean is
		numaux : Positive;
		repetido : Boolean;
		fila : Positive;
		columna : Positive;
	begin
		repetido := True;
		fila := 1;
		columna := 1;
		loop
			numaux := cart(fila).numeros(columna).numero;
			for i in 1..filasencarton loop
				for j in 1..numerosenfila loop
					if i /= fila or j /= columna then
						if numaux = cart(i).numeros(j).numero then
							repetido := False;
						end if;
					end if;
				end loop;
			end loop;
			if fila /= 3 then
				fila := fila + 1;
			else
				fila := 1;
				columna := columna +1;
			end if;
		exit when columna = 6 and fila = 1;
		end loop;
		return repetido;
	end;
	
	procedure LeeJugador (archivo : File_Type;
						pjug : out TipoListaCartones) is
		fallo : Boolean;
		papeleta : TipoCarton;
		ending : Boolean;
	begin
		pjug := ListaCartonesVacia;
		loop
			LeeCarton(archivo, papeleta, fallo, ending);
			if fallo then
				Put("El archivo de texto tiene un dato erroneo, se ignora el resto de datos del jugador");
				New_Line;
				if not ending then
					loop
						LeeCarton(archivo, papeleta, fallo, ending);
					exit when ending or End_Of_File(archivo);
					end loop;
				end if;
			else
				if CartonValido(papeleta) then
					InsertarCarton(pjug, papeleta);
				else
					Put("El carton no es valido por tener un numero repetido, ignorado");
					New_Line;
				end if;
			end if;
		exit when FinConfig(fallo, ending);
		end loop;
	end;

	procedure FaseConfiguracion (fichero : File_Type;
							pjug1 : out TipoListaCartones;
							pjug2 : out TipoListaCartones;
							pjug3 : out TipoListaCartones) is
	begin
		LeeJugador(fichero, pjug1);
		if End_Of_File(fichero) then
			Put("El fichero ha acabado prematuramente");
			New_Line;
		else
			LeeJugador(fichero, pjug2);
			if End_Of_File(fichero) then
				Put("El fichero ha acabado prematuramente");
				New_Line;
			else
				LeeJugador(fichero, pjug3);
				if End_Of_File(fichero) then
					Put("El fichero ha acabado prematuramente");
					New_Line;
				end if;
			end if;
		end if; 
	end;
	
	function NumeroACaracter (n : Natural) return Character is
	begin
		return Character'Val(Character'Pos('0') + n);
	end;
	
	function NumeroAString (number : Positive) return TipoNumeroString is
		caracter : Character;
		string : TipoNumeroString;
	begin
		if number = 100 then
			string := "100";
		elsif number < 10 then
			caracter := NumeroACaracter(number);
			string(1) := caracter;
			string(2) := ' ';
			string(3) := ' ';
		else
			caracter := NumeroACaracter((number - number mod 10) / 10);
			string(1) := caracter;
			caracter := NumeroACaracter(number mod 10);
			string(2) := caracter;
			string(3) := ' ';
		end if;
		return string;
	end;
	
	procedure ImprimeJugador (lista : TipoListaCartones) is
		pnodo : TipoListaCartones;
		contador : Positive;
		numb : TipoNumeroString;
	begin
		contador := 1;
		pnodo := lista;
		if pnodo = ListaCartonesVacia then
			Put("El jugador no tiene cartones");
			New_Line;
		end if;
		while pnodo /= ListaCartonesVacia loop
			Put("Carton ");
			Put(NumeroACaracter(contador));
			New_Line;
			for i in 1..filasencarton loop
				Put(pnodo.actual(i).color);
				Put(' ');
				for j in 1..numerosenfila loop
					if pnodo.actual(i).numeros(j).tachado then
						Put("XX ");
					else
						numb := NumeroAString(pnodo.actual(i).numeros(j).numero);
						Put(numb(1));
						Put(numb(2));
						Put(numb(3));
					end if;
					if numb = "100" then
						Put(' ');
					end if;
				end loop;
				New_Line;
			end loop;
			New_Line;
			pnodo := pnodo.siguiente;
			contador := contador + 1;
		end loop;
	end;
	
	procedure ImprimeCartones (lista1 : TipoListaCartones;
							lista2 : TipoListaCartones;
							lista3 : TipoListaCartones) is
	begin
		Put("Jugador 1 ");
		ImprimeJugador(lista1);
		Put("Jugador 2 ");
		ImprimeJugador(lista2);
		Put("Jugador 3 ");
		ImprimeJugador(lista3);
	end;
	
	procedure LeeBola (data : File_Type;
					ball : out TipoBola;
					fallo : out Boolean) is
		c : Character;
		linea : Boolean;
		resto : TipoPalabra;
		encon : Boolean;
		numero : Positive;
	begin
		LeeCaracter(data, fallo, c);
		if not fallo then
			case c is
			when 'a' =>
				Look_Ahead(data, c, linea);
				if c = 'm' then
					Get(data, c);
					resto := "arillo";
					BuscarPalabra(data, resto, encon);
					if encon then
						ball.color := Amarillo;
					else
						fallo := True;
					end if;
				elsif c = 'z' then
					Get(data, c);
					resto := "ul    ";
					BuscarPalabra(data, resto, encon);
					if encon then
						ball.color := Azul;
					else
						fallo := True;
					end if;
				else
					fallo := True;
				end if;
			when 'v' =>
				resto := "erde  ";
				BuscarPalabra(data, resto, encon);
				if encon then
					ball.color := Verde;
				else
					fallo := True;
				end if;
			when 'r' =>
				resto := "ojo   ";
				BuscarPalabra(data, resto, encon);
				if encon then
					ball.color := Rojo;
				else
					fallo := True;
				end if;
			when others =>
				fallo := True;
			end case;
		end if;
		if not fallo then
			LeeCaracter(data, fallo, c);
			case c is
			when '1'..'9' =>
				numero := Numeriza(c);
				Look_Ahead(data, c, linea);
				if c in '0'..'9' then
					Get(data, c);
					numero := (10 * numero) + Numeriza(c);
					if numero = 10 then
						Look_Ahead(data, c, linea);
						if c = '0' then
							Get(data, c);
							numero := 100;
						end if;
					end if;
				end if;
				ball.valor := numero;
			when others =>
				fallo := True;
			end case;
		end if;
	end;
	
	function Acierto (numero : TipoNumero;
				    extraido : TipoBola) return Boolean is
	begin
		return not numero.tachado and extraido.valor = numero.numero;
	end;
	
	function TengoLinea (numeros : TipoListaNum;
					   actual : TipoBola) return Boolean is
		contador : Natural;
	begin
		contador := 0;
		for i in 1..numerosenfila loop
			if numeros(i).tachado or actual.valor = numeros(i).numero then
				contador := contador + 1;
			end if;
		end loop;
		return contador = numerosenfila;
	end;
	
	function TengoBingo (carton : TipoCarton;
					   extraccion : TipoBola) return Boolean is
		contador : Natural;
	begin
		contador := 0;
		for i in 1..filasencarton loop
			if TengoLinea (carton(i).numeros, extraccion) then
				contador := contador + 1;
			end if;
		end loop;
		return contador = filasencarton;
	end;
	
	function Respuesta (cartones : TipoListaCartones;
					ball : TipoBola) return TipoRespuesta is
		resultado : TipoRespuesta;
		pnodo : TipoListaCartones;
		cont : Natural;
	begin
		cont := 0;
		resultado := Nada;
		pnodo := cartones;
		while pnodo /= ListaCartonesVacia and resultado /= Bingo loop
			for i in 1..filasencarton loop
				for j in 1..numerosenfila loop
					if pnodo.actual(i).color = ball.color then
						if Acierto(pnodo.actual(i).numeros(j), ball) and resultado = Nada then
							resultado := Tachado;
						end if;
					end if;
					if pnodo.actual(i).numeros(j).numero <= ball.valor then
						cont := cont + 1;
					end if;
				end loop;
				if TengoLinea(pnodo.actual(i).numeros, ball) then
					resultado := Linea;
				end if;
			end loop;
			if TengoBingo(pnodo.actual, ball) then
				resultado := Bingo;
			end if;
			pnodo := pnodo.siguiente;
		end loop;
		if cont = totalnumeros then
			resultado := Bingo;
		end if;
		return resultado;
	end;
	
	procedure TachaNumeros (ball : TipoBola;
						   cartones : in out TipoListaCartones) is
		pnodo : TipoListaCartones;
		listaaux : TipoListaCartones;
	begin
		pnodo := cartones;
		while pnodo /= ListaCartonesVacia loop
			for i in 1..filasencarton loop
				if pnodo.actual(i).color = ball.color then
					for j in 1..numerosenfila loop
						if Acierto(pnodo.actual(i).numeros(j), ball) then
							pnodo.actual(i).numeros(j).tachado := True;
						end if;
					end loop;
				end if;
			end loop;
			InsertarCarton(listaaux, pnodo.actual);
			pnodo := pnodo.siguiente;
		end loop;
		cartones := listaaux;
	end;
	
	procedure ImprimeRespuesta (result : in out TipoRespuesta;
							yahaylinea : Boolean) is
	begin
		if result = Linea and yahaylinea then
			result := Tachado;
		end if;
		Put(result);
		New_Line;
	end;
	
	procedure EscribeRespuestas(r1 : in out TipoRespuesta;
							r2 : in out TipoRespuesta;
							r3 : in out TipoRespuesta;
							lin : Boolean) is
	begin
		Put("Jugador 1: ");
		ImprimeRespuesta(r1, lin);
		Put("Jugador 2: ");
		ImprimeRespuesta(r2, lin);
		Put("Jugador 3: ");
		ImprimeRespuesta(r3, lin);
		New_Line;
	end;
	
	function HayLinea (r1 : TipoRespuesta;
					r2 : TipoRespuesta;
					r3 : TipoRespuesta) return Boolean is
	begin
		return r1 = Linea or r2 = Linea or r3 = Linea;
	end;
	
	function HayBingo (r1 : TipoRespuesta;
					r2 : TipoRespuesta;
					r3 : TipoRespuesta) return Boolean is
	begin
		return r1 = Bingo or r2 = Bingo or r3 = Bingo;
	end;
	
	procedure EscribeUnaBola (bolita : TipoBola) is
		string : TipoNumeroString;
	begin
		Put(bolita.color);
		Put(' ');
		string := NumeroAString(bolita.valor);
		Put(string(1));
		Put(string(2));
		Put(string(3));
		New_Line;
	end;
	
	procedure FaseExtraccion (fichero : File_Type;
						   pjug1 : in out TipoListaCartones;
						   pjug2 : in out TipoListaCartones;
						   pjug3 : in out TipoListaCartones;
						   listabolas : out TipoListaBolas) is
		resul1 : TipoRespuesta;
		resul2 : TipoRespuesta;
		resul3 : TipoRespuesta;
		mal_dato : Boolean;
		eof : Boolean;
		bola : TipoBola;
		bingo : Boolean;
		linea : Boolean;
	begin
		linea := False;
		bingo := False;
		listabolas := ListaBolasVacia;
		loop
			ImprimeCartones(pjug1, pjug2, pjug3);
			LeeBola(fichero, bola, mal_dato);
			eof := End_Of_File(fichero);
				if not mal_dato then
					EscribeUnaBola (bola);
					InsertarBola(listabolas, bola);
					resul1 := Respuesta(pjug1, bola);
					resul2 := Respuesta(pjug2, bola);
					resul3 := Respuesta(pjug3, bola);
					TachaNumeros(bola, pjug1);
					TachaNumeros(bola, pjug2);
					TachaNumeros(bola, pjug3);
					EscribeRespuestas(resul1, resul2, resul3 , linea);					
				end if;
				if HayLinea(resul1, resul2, resul3) then
					linea := True;
				end if;
				if HayBingo(resul1, resul2, resul3) then
					bingo := True;
				end if;
		exit when mal_dato or eof or bingo;
		end loop;
		if mal_dato and not eof then
			Put("Hay un dato no valido, se ignora el resto de las extracciones");
			New_Line;
		end if;
	end;
	
	procedure EscribeBolas (lista : TipoListaBolas) is
		pnodo : TipoListaBolas;
		copia : TipoListaBolas;
		panterior : TipoListaBolas;
	begin
		copia := lista;
		Put("Bolas extraidas:");
		New_Line;
		if copia = ListaBolasVacia then
			Put("No ha habido extracciones");
			New_Line;
		elsif copia.siguiente = ListaBolasVacia then
			panterior := copia;
			EscribeUnaBola(panterior.actual);
		else
			panterior := copia.siguiente;
			while copia /= ListaBolasVacia and panterior /= copia loop
				panterior := copia;
				pnodo := copia.siguiente;
				while pnodo.siguiente /= ListaBolasVacia loop
					panterior := pnodo;
					pnodo := pnodo.siguiente;
				end loop;
				EscribeUnaBola(pnodo.actual);
				DeleteBola(panterior.siguiente);
				panterior.all.siguiente := null;
			end loop;
			EscribeUnaBola(panterior.actual);
		end if;
		New_Line;
	end;
	
	function UltimaBola (lista : TipoListaBolas) return TipoBola is
		pnodo : TipoListaBolas;
	begin
		pnodo := lista;
		while pnodo.siguiente /= ListaBolasVacia loop
			pnodo := pnodo.siguiente;
		end loop;
		return pnodo.actual;
	end;
	
	function FueBingo (player : TipoListaCartones;
					bol : TipoBola) return Boolean is
		pnodo : TipoListaCartones;
		lofue : Boolean;
	begin
		pnodo := player;
		lofue := False;
		while pnodo /= ListaCartonesVacia and not lofue loop
			if TengoBingo(pnodo.actual, bol) then
				lofue := True;
			end if;
			pnodo := pnodo.siguiente;
		end loop;
		return lofue or Respuesta(player, bol) = Bingo;
	end;
	
	procedure EscribeGanador (player1 : TipoListaCartones;
						     player2 : TipoListaCartones;
						     player3 : TipoListaCartones;
						     bolafinal : TipoBola) is
		contador : Natural;
		ganador : Positive;
	begin
		contador := 0;
		Put("Resultado: ");
		if FueBingo(player1, bolafinal) then
			contador := contador + 1;
			ganador := 1;
		end if;
		if FueBingo(player2, bolafinal) then
			contador := contador + 1;
			ganador := 2;
		end if;
		if FueBingo(player3, bolafinal) then
			contador := contador + 1;
			ganador := 3;
		end if;
		if contador /= 1 then
			Put("Empate");
		else 
			Put("Gana el jugador ");
			Put(NumeroACaracter(ganador));
		end if;
		New_Line;
	end;
	
	procedure FinDelJuego (pjug1 : TipoListaCartones;
					      pjug2 : TipoListaCartones;
					      pjug3 : TipoListaCartones;
					      listabolas : TipoListaBolas;
					      final : Boolean) is
		ultima_bola : TipoBola;					
	begin
		Put("El juego ha concluido");
		New_Line;
		New_Line;
		EscribeBolas(listabolas);
		if listabolas /= ListaBolasVacia then
			ultima_bola := UltimaBola(listabolas);
		end if;
		EscribeGanador(pjug1, pjug2, pjug3, ultima_bola);
	end;
	
	procedure BorraJugador (jugador : in out TipoListaCartones) is
		pnodo : TipoListaCartones;
	begin
		pnodo := jugador;
		while pnodo /= ListaCartonesVacia loop
			jugador := jugador.siguiente;
			DeleteCarton(pnodo);
			pnodo := jugador;
		end loop;
		jugador := null;
	end;
	
	procedure BorraBolas (listabolas : in out TipoListaBolas) is
		pnodo : TipoListaBolas;
	begin
		pnodo := listabolas;
		while pnodo /= ListaBolasVacia loop
			listabolas := listabolas.siguiente;
			DeleteBola(pnodo);
			pnodo := listabolas;
		end loop;
		listabolas := null;
	end;
	
	procedure BorraListas (p1 : out TipoListaCartones;
					     p2 : out TipoListaCartones;
					     p3 : out TipoListaCartones;
					     b : out TipoListaBolas) is
	begin
		BorraJugador(p1);
		BorraJugador(p2);
		BorraJugador(p3);
		BorraBolas(b);
	end;

	ficherodatos : File_Type;
	pjugador1 : TipoListaCartones;
	pjugador2 : TipoListaCartones;
	pjugador3 : TipoListaCartones;
	bolas : TipoListaBolas;
	fin_fich : Boolean;

begin
	Open(ficherodatos, In_File, "datos.txt");
	FaseConfiguracion(ficherodatos, pjugador1, pjugador2, pjugador3);
	fin_fich := End_Of_File(ficherodatos);
	if not fin_fich then
		FaseExtraccion(ficherodatos, pjugador1, pjugador2, pjugador3, bolas);
	end if;
	Close(ficherodatos);
	FinDelJuego(pjugador1, pjugador2, pjugador3, bolas, fin_fich);
	BorraListas(pjugador1, pjugador2, pjugador3, bolas);
end;