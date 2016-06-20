:- ensure_loaded(mina).
:- nb_setval(nminas,3).
tamanho(4).
casa(X,Y) :- tamanho(L),X >=0 , X < L, Y >=0, Y < L.

conta_minas_linha_cima(X,Y,3) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2).
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, mina(X1,Y),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_cima(_,_,0).

conta_minas_mesma_linha(X,Y,2) :- Y1 is Y-1, Y2 is Y+1, mina(X,Y1), mina(X,Y2).
conta_minas_mesma_linha(X,Y,1) :- Y1 is Y-1, mina(X,Y1).
conta_minas_mesma_linha(X,Y,1) :- Y1 is Y+1, mina(X,Y1).
conta_minas_mesma_linha(_,_,0).

conta_minas_linha_abaixo(X,Y,3) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2).
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1).
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y+1, mina(X1,Y1).
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2).
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y).
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y-1, mina(X1,Y1).
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y+1, mina(X1,Y1).
conta_minas_linha_abaixo(_,_,0).

valor(X,Y,N) :- casa(X,Y), not(mina(X,Y)), conta_minas_linha_abaixo(X,Y,N1),conta_minas_linha_cima(X,Y,N2),conta_minas_mesma_linha(X,Y,N3), N is N1 + N2 + N3.

calcula_casa(0,0,STR) :- valor(0,0,N),write(STR,'val('),write(STR,'0'),write(STR,','),write(STR,'0'),write(STR,','),write(STR,N),write(STR,').\n'),nl(STR),close(STR).
calcula_casa(0,0,STR) :- close(STR).
calcula_casa(L,0,STR) :- valor(L,0,N),write(STR,'val('),write(STR,L),write(STR,','),write(STR,'0'),write(STR,','),write(STR,N),write(STR,').\n'),nl(STR).
calcula_casa(L,C,STR) :- valor(L,C,N),write(STR,'val('),write(STR,L),write(STR,','),write(STR,C),write(STR,','),write(STR,N), write(STR,').\n'), C1 is C - 1,calcula_casa(L,C1,STR).
calcula_casa(L,C,STR) :- C1 is C -1,calcula_casa(L,C1,STR).

calcula_linha(0,STR) :- tamanho(T), T1 is T -1, calcula_casa(0,T1,STR).
calcula_linha(L,STR) :- tamanho(T), T1 is T -1, calcula_casa(L,T1,STR), L1 is L - 1, calcula_linha(L1,STR).
inicio :- open("ambiente.pl",write,STR), tamanho(T),T1 is T - 1,calcula_linha(T1,STR).
