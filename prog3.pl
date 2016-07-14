/* Carregando cláusulas criadas no arquivo prog2.pl para serem usadas no decorrer do jogo. */
:- ensure_loaded(prog2).

/* Declarando que a cláusula vizinhos (que relaciona uma casa com as outras adjacentes a ela), será alterada dinamicamente com assert */
:- dynamic vizinhos/2.

/* Setando vizinhanca das casas que ficam nos vértices do tabuleiro */
set_vizinhos(X,Y)   :- X=0, Y = 0, !, assert(vizinhos((0,0),(0,1))), assert(vizinhos((0,0),(1,0))),assert(vizinhos((0,0),(1,1))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, Y=T1,!, T2 is T1 - 1, assert(vizinhos((T1,T1),(T2,T1))),assert(vizinhos((T1,T1),(T1,T2))),assert(vizinhos((T1,T1),(T2,T2))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = 0, Y = T1, !, T2 is T1 - 1,  assert(vizinhos((0,T1),(1,T1))),assert(vizinhos((0,T1),(0,T2))),assert(vizinhos((0,T1),(1,T2))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, Y = 0, !, T2 is T1 - 1, assert(vizinhos((T1,0),(T1,1))),assert(vizinhos((T1,0),(T2,0))),assert(vizinhos((T1,0),(T2,1))).

/* Setando vizinhança das casas que ficam na lateral do tabuleiro e não são são vértices*/
set_vizinhos(X,Y)   :- X = 0, !, Y1 is Y - 1, Y2 is Y + 1, assert(vizinhos((X,Y),(0,Y2))),assert(vizinhos((X,Y),(1,Y2))),assert(vizinhos((X,Y),(1,Y))),assert(vizinhos((X,Y),(1,Y1))),assert(vizinhos((X,Y),(0,Y1))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, !, Y1 is Y - 1, Y2 is Y + 1, X1 is X - 1, assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X1,Y1))), assert(vizinhos((X,Y),(X1,Y))), assert(vizinhos((X,Y),(X1,Y2))),assert(vizinhos((X,Y),(X,Y2))).
set_vizinhos(X,Y)   :- Y = 0, !, Y1 is Y + 1, X1 is X - 1, X2 is X + 1, assert(vizinhos((X,Y),(X1,Y))),assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X2,Y1))),assert(vizinhos((X,Y),(X2,Y))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, Y = T1, !, Y1 is Y - 1, X1 is X - 1, X2 is X + 1,assert(vizinhos((X,Y),(X1,Y))),assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X2,Y1))),assert(vizinhos((X,Y),(X2,Y))).

/* Setando demais vizinhanças */
set_vizinhos(X,Y)   :- X1 is X - 1, X2 is X + 1, Y1 is Y - 1, Y2 is Y + 1, assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X1,Y))), assert(vizinhos((X,Y),(X1,Y2))), assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X,Y2))), assert(vizinhos((X,Y),(X2,Y1))), assert(vizinhos((X,Y),(X2,Y))),assert(vizinhos((X,Y),(X2,Y2))).

/* Invoca o set_vizinhos para cada casa do tabuleiro recursivamente */
init_vizinhanca(X,Y) :- X=0,Y=0,!, set_vizinhos(0,0).
init_vizinhanca(X,Y) :- Y=0,!, tamanho(T), T1 is T - 1, X1 is X - 1, set_vizinhos(X,Y),init_vizinhanca(X1,T1).
init_vizinhanca(X,Y) :- set_vizinhos(X,Y), Y1 is Y - 1, init_vizinhanca(X,Y1).

/* Inicia as vizinhanças começando pela ultima casa do tabuleiro */
init_vizinhos :- tamanho(T), T1 is T-1, init_vizinhanca(T1,T1).

/* Busca todos os vizinhos de uma dada casa*/
lista_vizinhos(COORD,L) :- findall(V,vizinhos(COORD,V),L1), L = L1.

/* Recebe a lista de ccasas e retorna somente as que ainda não foram abertas */
retira_vizinhos_abertos([], []).
retira_vizinhos_abertos([ H | T ],[ H | R ]) :- not(v(H,_)),!,retira_vizinhos_abertos(T, R).
retira_vizinhos_abertos([ _ | T ], R) :- retira_vizinhos_abertos(T, R).

/* Dado uma casa pivô já aberta e com um valor K, calcula a probabilidade de seus vizinhos terem bomba usando a fórmula p = (K)/(# vizinhos fechados) */
prob_bomba_vizinho(Pivo,R) :- v(Pivo,K),!, lista_vizinhos(Pivo,L1),retira_vizinhos_abertos(L1,L2), len(L2,Len), R is K / Len.
prob_bomba_vizinho(_,_).

/* Recebe uma lista de nós e retorna a lista das probabilidades de os vizinhos desses nós terem uma bomba */
prob_bomba_vizinho_list([],[]).
prob_bomba_vizinho_list([V|L1],[P|L2]) :- prob_bomba_vizinho_list(L1,L2), prob_bomba_vizinho(V,P).

/* Calcula a probabilidade de uma casa ter uma bomba. A probabilidade de uma casa ter uma bomba é a maior das probabilidades calculadas para seus vizinhos pela cláusula prob_bomba_vizinho_list */
prob_bomba_casa(Casa,P) :- lista_vizinhos(Casa,L), retira_vizinhos_abertos(L,L1), diff(L,L1,L2),prob_bomba_vizinho_list(L2,R), max_list(R,P).

/* Varrendo todas as casas e achando a casa fechada com menor probabilidade de ter bomba, segundo a heurística escolhida. 
   A primeira chamada abaixo é usada como caso base da recursão, para que consigamos valorar a variável prob e usá-la conforme vamos retornando da recursão.
*/
casa_menos_chance_bomba((X,Y),(-1,-1),1.0) :- X < 0,!.

/* Calcula a probabilida para casas que não estão na coluna zero, e portanto a próxima casa da recursão será na mesma linha e na coluna anterior. */
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y > 0, v((X,Y),_),!, Y1 is Y - 1, casa_menos_chance_bomba((X,Y1),(V,S),P), Z is V, W is S, PROB is P.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y > 0, not(v((X,Y),_)), prob_bomba_casa((X,Y),P2),  Y1 is Y - 1, casa_menos_chance_bomba((X,Y1),(V,S),P), P2 > P,!, PROB is P, Z is V, W is S.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y > 0, not(v((X,Y),_)), Y1 is Y - 1, casa_menos_chance_bomba((X,Y1),(V,S),P), prob_bomba_casa((X,Y),P2), P2 =< P, !,PROB is P2, Z is X, W is Y.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y > 0, not(v((X,Y),_)), not(prob_bomba_casa((X,Y),P2)),!, Y1 is Y - 1, casa_menos_chance_bomba((X,Y1),(V,S),P), PROB is P, Z is V, W is S.

/* Calcula a probabilida para casas que estão na coluna 0. A próxima casa da recursão será na linha anterior e na última coluna. */
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y = 0, v((X,Y),_),!, X1 is X - 1, tamanho(T), T1 is T - 1, casa_menos_chance_bomba((X1,T1),(V,S),P), Z is V, W is S, PROB is P.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y = 0, not(v((X,Y),_)), X1 is X - 1, tamanho(T), T1 is T - 1, casa_menos_chance_bomba((X1,T1),(V,S),P), prob_bomba_casa((X,Y),P2), P2 > P,!, PROB is P, Z is V, W is S.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y = 0, not(v((X,Y),_)), X1 is X - 1, tamanho(T), T1 is T - 1, casa_menos_chance_bomba((X1,T1),(V,S),P), prob_bomba_casa((X,Y),P2), P2 =< P,!, PROB is P2, Z is X, W is Y.
casa_menos_chance_bomba((X,Y),(Z,W),PROB) :- Y = 0, not(v((X,Y),_)), not(prob_bomba_casa((X,Y),P2)), !, X1 is X - 1, tamanho(T), T1 is T - 1, casa_menos_chance_bomba((X1,T1),(V,S),P), PROB is P, Z is V, W is S.

casa_menos_chance_bomba(_,_,_).

/* Chamada que inicializa as relações de vizinhança */
:- init_vizinhos.

/* 
	Cláusula que seleciona as jogadas.

	A chamada abaixo calcula a casa com menor probabilidade de ter uma bomba e joga nela, se a probabiliade de ela ter bomba for menor que 1. Chama a propria clausula recursivamente para a próxima jogada.

*/
joga :- nb_getval(finish,FIM), not(FIM),tamanho(T), T1 is T - 1, casa_menos_chance_bomba((T1,T1),(X,Y),P), P < 1, X > -1,posicao(X,Y),joga.

/* Calcula a casa com menor probabilidade de ter bomba, mas recebe como resultado uma coordenada que indica que não tem nenhuma casa com essa probabilidade definida, então escolhe uma casa aleatória e joga nela. */
joga :- nb_getval(finish,FIM),not(FIM),tamanho(T),T1 is T-1, casa_menos_chance_bomba((T1,T1),COORD,P),COORD=(-1,-1) , random_between(0,T1,X),random_between(0,T1,Y),posicao(X,Y),joga.

/* 
	Trata os casos em que a casa com probabilidade definida e menor probabilidade de ter bomba com certeza tem uma bomba. 
	
	Seleciona uma posição aleatória e joga nela, se ela não for uma posição já aberta ou uma posição com probabilidade 1 de ter bomba. Caso a posição escolhida já esteja aberta ou tenha probabilidade de ter bomba igual a 1, não abre a casa e chama a cláusula recursivamente, para que ela tente gerar outra posição melhor para jogar.
*/
joga :- nb_getval(finish,FIM),not(FIM),tamanho(T),T1 is T-1, casa_menos_chance_bomba((T1,T1),COORD,P),P=1, random_between(0,T1,X),random_between(0,T1,Y),prob_bomba_casa((X,Y),P), P < 1, not(v((X,Y),_)), posicao(X,Y),joga.
joga :- nb_getval(finish,FIM),not(FIM),tamanho(T),T1 is T-1, casa_menos_chance_bomba((T1,T1),COORD,P),P=1, random_between(0,T1,X),random_between(0,T1,Y),prob_bomba_casa((X,Y),P), P < 1, v((X,Y),_), joga.
joga :- nb_getval(finish,FIM),not(FIM),tamanho(T),T1 is T-1, casa_menos_chance_bomba((T1,T1),COORD,P),P=1, random_between(0,T1,X),random_between(0,T1,Y),prob_bomba_casa((X,Y),P), P = 1,joga.
