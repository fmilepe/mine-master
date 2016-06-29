len([],0).
len([_|L],N1) :- len(L,N), N1 is N+1.

diff([],_,[]).
diff([X | L1], L2, [X|L3]) :- not(member(X,L2)),!,diff(L1,L2,L3).
diff([_|L1],L2, L3) :- diff(L1,L2,L3).

max(N1,N2,N3) :- N1> N2,!, N3 is N1.
max(_,N2,N3) :- N3 is N2.

maximo_lista([N],N).
maximo_lista([P|L],Max) :- maximo_lista(L,Max), max(Max,P,R),Max is R.
/*maximo_lista([_|L],Max) :- maximo_lista(L,Max).*/
