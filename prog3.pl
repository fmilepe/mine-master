:- ensure_loaded(prog2).
:- dynamic vizinhos/2.

/* Setando vizinhanca das casas que ficam nos vértices do tabuleiro */
set_vizinhos(X,Y)   :- X=0, Y = 0, !, assert(vizinhos((0,0),(0,1))), assert(vizinhos((0,0),(1,0))),assert(vizinhos((0,0),(1,1))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, Y=T1,!, T2 is T1 - 1, assert(vizinhos((T1,T1),(T2,T1))),assert(vizinhos((T1,T1),(T1,T2))),assert(vizinhos((T1,T1),(T2,T2))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = 0, Y = T1, !, T2 is T1 - 1,  assert(vizinhos((0,T1),(1,T1))),assert(vizinhos((0,T1),(0,T2))),assert(vizinhos((0,T1),(1,T2))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, Y = 0, !, T2 is T1 - 1, assert(vizinhos((X,0),(T1,1))),assert(vizinhos((T1,0),(T2,0))),assert(vizinhos((0,T1),(T2,1))).

/* Setando Vizinhança das casas que ficam na lateral do tabuleiro e não são são vértices*/
set_vizinhos(X,Y)   :- X = 0, !, Y1 is Y - 1, Y2 is Y + 1, assert(vizinhos((X,Y),(0,Y2))),assert(vizinhos((X,Y),(1,Y2))),assert(vizinhos((X,Y),(1,Y))),assert(vizinhos((X,Y),(1,Y1))),assert(vizinhos((X,Y),(0,Y1))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, X = T1, !, Y1 is Y - 1, Y2 is Y + 1, X1 is X - 1, assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X1,Y1))), assert(vizinhos((X,Y),(X1,Y))), assert(vizinhos((X,Y),(X1,Y2))),assert(vizinhos((X,Y),(X,Y2))).
set_vizinhos(X,Y)   :- Y = 0, !, Y1 is Y + 1, X1 is X - 1, X2 is X + 1, assert(vizinhos((X,Y),(X1,Y))),assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X2,Y1))),assert(vizinhos((X,Y),(X2,Y))).
set_vizinhos(X,Y)   :- tamanho(T), T1 is T - 1, Y = T1, !, Y1 is Y - 1, X1 is X - 1, X2 is X + 1,assert(vizinhos((X,Y),(X1,Y))),assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X2,Y1))),assert(vizinhos((X,Y),(X2,Y))).

/* Setando demais vizinhanças */
set_vizinhos(X,Y)   :- X1 is X - 1, X2 is X + 1, Y1 is Y - 1, Y2 is Y + 1, assert(vizinhos((X,Y),(X1,Y1))),assert(vizinhos((X,Y),(X1,Y))), assert(vizinhos((X,Y),(X1,Y2))), assert(vizinhos((X,Y),(X,Y1))),assert(vizinhos((X,Y),(X,Y2))), assert(vizinhos((X,Y),(X2,Y1))), assert(vizinhos((X,Y),(X2,Y))),assert(vizinhos((X,Y),(X2,Y2))).

init_vizinhanca(X,Y) :- X=0,Y=0,!, set_vizinhos(0,0).
init_vizinhanca(X,Y) :- Y=0,!, tamanho(T), T1 is T - 1, X1 is X - 1, set_vizinhos(X,Y),init_vizinhanca(X1,T1).
init_vizinhanca(X,Y) :- set_vizinhos(X,Y), Y1 is Y - 1, init_vizinhanca(X,Y1),writeln(X).


init_vizinhos :- tamanho(T), T1 is T-1, init_vizinhanca(T1,T1).

lista_vizinhos(COORD,L) :- findall(V,vizinhos(COORD,V),L1), L = L1.

retira_vizinhos_abertos([], []).
retira_vizinhos_abertos([ H | T ],[H | R]) :- not(v(H,_)),!,retira_vizinhos_abertos(T, R).
retira_vizinhos_abertos([ _ | T ], R) :- retira_vizinhos_abertos(T, R).

prob_bomba_vizinho(Pivo,R) :- v(Pivo,K),!, lista_vizinhos(Pivo,L1),retira_vizinhos_abertos(L1,L2), len(L2,Len), R is K / Len.
prob_bomba_vizinho(_,_).

prob_bomba_vizinho_list([],[]).
prob_bomba_vizinho_list([V|L1],[P|L2]) :- prob_bomba_vizinho_list(L1,L2), prob_bomba_vizinho(V,P).

prob_bomba_casa(Casa,P) :- lista_vizinhos(Casa,L), retira_vizinhos_abertos(L,L1), diff(L,L1,L2),prob_bomba_vizinho_list(L2,R), max_list(R,P).
/*prob_bomba_casa(_,-1).*/
/*:- init_vizinhos.*/

