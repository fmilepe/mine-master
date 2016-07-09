/* Carregando arquivo com a configuração das minas */
:- ensure_loaded(mina).

/* Calcula o número de minas na configuração atual do tabuleiro */
:- findall(COORD,mina(COORD),MINAS), len(MINAS,NUMMINAS), nb_setval(nminas,NUMMINAS).

/* Define o tamanho do tabuleiro */
tamanho(4).

casa(X,Y) :- tamanho(L),X >=0 , X < L, Y >=0, Y < L.

/* Conta quantas minas existem nas casas vizinhas a X e Y e que ficam na linha acima dessa casa */
conta_minas_linha_cima(X,Y,3) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2),!.
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, mina(X1,Y), Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,2) :- X > 0, X1 is X - 1, Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, mina(X1,Y),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_cima(X,Y,1) :- X > 0, X1 is X - 1, Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_cima(_,_,0).

/* Conta quantas minas existem nas casas vizinhas a X e Y e que ficam na mesma linha dessa casa */
conta_minas_mesma_linha(X,Y,2) :- Y1 is Y-1, Y2 is Y+1, mina(X,Y1), mina(X,Y2), !.
conta_minas_mesma_linha(X,Y,1) :- Y1 is Y-1, mina(X,Y1),!.
conta_minas_mesma_linha(X,Y,1) :- Y1 is Y+1, mina(X,Y1),!.
conta_minas_mesma_linha(_,_,0).

/* Conta quantas minas existem nas casas vizinhas a X e Y e que ficam na linha abaixo dessa casa */
conta_minas_linha_abaixo(X,Y,3) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2),!.
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y), Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_abaixo(X,Y,2) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y-1, mina(X1,Y1), Y2 is Y+1, mina(X1,Y2),!.
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, mina(X1,Y),!.
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y-1, mina(X1,Y1),!.
conta_minas_linha_abaixo(X,Y,1) :- tamanho(L),X < L, X1 is X + 1, Y1 is Y+1, mina(X1,Y1),!.
conta_minas_linha_abaixo(_,_,0).

/* Calcula o valor a ser mostrado quando uma casa sem mina for aberta */
valor(X,Y,N) :- casa(X,Y), not(mina(X,Y)), conta_minas_linha_abaixo(X,Y,N1),conta_minas_linha_cima(X,Y,N2),conta_minas_mesma_linha(X,Y,N3), N is N1 + N2 + N3.

/* Calcula o valor para uma casa e escreve esse valor no arquivo de ambiente e chama recursivamente o calcula_casa para a próxima célula do tabuleiro */
calcula_casa(0,0,STR) :- valor(0,0,N),!,write(STR,'valor('),write(STR,'0'),write(STR,','),write(STR,'0'),write(STR,','),write(STR,N),write(STR,').\n'),nl(STR),close(STR).
calcula_casa(0,0,STR) :- close(STR).
calcula_casa(L,0,STR) :- valor(L,0,N),!,write(STR,'valor('),write(STR,L),write(STR,','),write(STR,'0'),write(STR,','),write(STR,N),write(STR,').\n'),nl(STR).
calcula_casa(L,C,STR) :- valor(L,C,N),!,write(STR,'valor('),write(STR,L),write(STR,','),write(STR,C),write(STR,','),write(STR,N), write(STR,').\n'), C1 is C - 1,calcula_casa(L,C1,STR).
calcula_casa(L,C,STR) :- C1 is C -1,calcula_casa(L,C1,STR).

/* Inicia o calcula casa na ultima coluna de uma linha */
calcula_linha(0,STR) :- tamanho(T), T1 is T -1, calcula_casa(0,T1,STR).
calcula_linha(L,STR) :- tamanho(T), T1 is T -1, calcula_casa(L,T1,STR), L1 is L - 1, calcula_linha(L1,STR).

/* Abre a stream do arquivo de ambiente e inicia o calcula linha a partir da ultima linha do tabuleiro*/
inicio :- open("ambiente.pl",write,STR), tamanho(T),T1 is T - 1,calcula_linha(T1,STR).
