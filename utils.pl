/* Cláusula auxiliar que calcula o comprimento de uma lista. */
len([],0).
len([_|L],N1) :- len(L,N), N1 is N+1.

/* Cláusula auxiliar que calcula a diferença entre duas listas. */
diff([],_,[]).
diff([X | L1], L2, [X|L3]) :- not(member(X,L2)),!,diff(L1,L2,L3).
diff([_|L1],L2, L3) :- diff(L1,L2,L3).
