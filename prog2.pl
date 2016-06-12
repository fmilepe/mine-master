:- ensure_loaded(prog1).
:- open("jogo.pl",write,STR), nb_setval(stream, STR), nb_setval(count, 0).

posicao(X,Y) :- mina(X,Y), writeln('jogo encerrado'),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente, write(STR,'jogo encerrado'),close(STR).
posicao(X,Y) :- valor(X,Y,N), N > 0, writeln(N),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente,write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR).
posicao(X,Y) :- valor(X,Y,N), N = 0, writeln('0'),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente,write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR), X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2).
posicao(X,Y) :- not(casa(X,Y)).

posicao2(X,Y) :- valor(X,Y,N), N > 0, writeln(N),nb_getval(stream,STR),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR).
posicao2(X,Y) :- valor(X,Y,N), N = 0, writeln('0'),nb_getval(stream,STR),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR), X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2).
posicao2(X,Y) :- not(casa(X,Y)).

print_jogada(X,Y) :- nb_getval(stream,STR),nb_getval(count, C),C1 is C+1, write(STR,'/* JOGADA '),write(STR,C1), write(STR,' */\n'), write(STR,'posicao('),write(STR,X),write(STR,','),write(STR,Y),write(STR,').'),nb_setval(count,C1).

print_cab_ambiente :- nb_getval(stream,STR),write(STR,'\n/* AMBIENTE */ \n').
