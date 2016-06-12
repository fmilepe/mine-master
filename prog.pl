:- ensure_loaded(input).

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

calcula_casa(L,0) :- valor(L,0,N),write("valor("),write(L),write(","),write(0),write(","),write(N),write(")."),writeln().
calcula_casa(L,C) :- valor(L,C,N),!,write(L),write(C),write(N),writeln(), C1 is C -1,calcula_casa(L,C1).
calcula_casa(L,C) :- C1 is C -1,calcula_casa(L,C1).

calcula_linha(0) :- tamanho(T), T1 is T -1, calcula_casa(0,T1).
calcula_linha(L) :- tamanho(T), T1 is T -1, calcula_casa(L,T1), L1 is L - 1, calcula_linha(L1).

/*calcula_casa(L,C) :- C1 is C -1,calcula_casa(L,C1).*/

