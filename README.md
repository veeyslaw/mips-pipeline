
	Caracteristicile procesorului	

	- instrucţiuni acceptate - add, addi, sub, nor, and, or, ori, andi, beq, lw, sw, j, nop;
	- pipeline cu 5 nivele;
	- detectie hazarduri;
	- forwarding;
	- fara tratarea exceptiilor.




	Detalii de implementare

	În afară de forwarding-ul reprezentat explicit în diagrama din curs – WB → EX si M → EX, am adaugat forwarding şi pentru cazul
	lw reg_x, y
	sw reg_x, z
	de tip WB → EX, care e lăsat ca temă în H&P, cât şi pentru instrucţiunile similare cu beq de tip M → ID.

	Hazard-urile care nu pot fi remediate prin forwarding sunt tratate introducând un buble sau, cel mult, doua în pipeline.

	Decizia şi calcularea adresei de salt a fost adusă în etapa de decodare, cu optimizarea – prezicem că instrucţiunea beq nu va efectua saltul.

	Scrierea în register file e efectuată pe frontul negativ al ceasului.

	Accesul la memorie e realizat din Word in Word (Word = 32 biţi). Atât memoria de date, cât şi cea de instrucţiuni au capacitatea de 256 de Cuvinte care poate fi modificată în “Headers/Lengths.v” la constanta SIZE_MEM. Register file conţine cei 32 de regiştri din curs.

	Am adăugat şi suport hardware pentru a folosi pe toţi cei 26 de biţi din instrucţiunea de tip J, nu doar 16.

	Memoria de date are, iniţial, valorile de la primele 30 de adrese setate la adresa respectivă.




	Organizarea nivelului superior

	Blocul de nivel superior – MIPS_top e divizat în HazardDetectionUnit, ForwardUnit, Etape şi Regiştri Pipeline.


	Semnificaţia denumirii semnalelor
	
	Pentru majoritatea semnalelor e respectată convenţia:

	- Semnalele fără sufixe “_etapă” sunt semnalele care nu trec prin regiştri pipeline;

	- Semnalele de tip “nume_etapă” sunt semnalele care trec cel puţin printr-un registru pipeline, iar “etapa” e cea in care valoarea acestui semnal poate fi observată (între 2 regiştri pipeline consecutivi), sau etapa în care acţioneaza un semnal de forward;
	
	- Semnalele ”nume_etapă_etapă” sunt semnalele înaintate.




	Formatul instrucţiunilor

	Pentru opcode-urile şi funct-urile instrucţiunilor am folosit imaginea din dosarul “Docs” fişierul “OpcodesFuncts.jpg”, în care sunt mai multe semnale decât în curs. Pentru instrucţiunea NOP e folosită o instrucţiune nulă, iar pentru J – opcode e ‘b000010.
	



	Compilare. Simulare. Vizualizarea semnalelor de unda.

	Pentru compilare, din dosarul “Scripts” executaţi script-ul “comp.sh”.
	
	Pentru compilare, simulare şi lansarea uneltei de vizualizare a simulării – gtkwave, din dosarul “Scripts” executaţi script-ul “sim.sh”.

	Pentru compilare manuala vă vine în ajutor fişierul “file_list.txt” din dosarul “Scripts” care conţine denumirile tuturor fişierelor proiectului relativ la dosarul care conţine proiectul.

	Microprocesorul e simulat pentru 1_000_000 unităţi de timp, iar, la finalul simulării, în dosarul “Outputs” e salvată starea memoriei de date în fişierul “dump_data_mem.txt”, cât şi cea a register file-ului în “dump_reg_file.txt” în format hexadecimal.







	Modificarea programului executat

	Pentru a modifica programul executat fără a traduce cod asamblare MIPS în cod maşină puteţi executa din dosarul “Scripts” script-ul python “load_program.py”, de exemplu executând comanda “python3 load_program.py” din terminal, care va încărca conţinutul fişierului “program_to_load.txt” în memoria de instrucţiuni începând cu adresa 0. Detalii despre editarea acestui fişier le găsiţi în primul bloc de linii comentate în interiorul acestuia.

	Pentru a schimba programul manual puteţi edita fişierul “Modules/MemReg/InstrMem.v”.




	Versiuni compilator, simulator, vizualizator şi python testate

	Compilator - Icarus Verilog version 10.3 (stable);
	Simulator - Icarus Verilog runtime version 10.3 (stable);
	Vizualizator - GTKWave Analyzer v3.3.101;
	Python - Python 3.7.5.
	
