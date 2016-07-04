:- ensure_loaded(prog1).
:- ensure_loaded(utils).
:- open("jogo.pl",write,STR), nb_setval(stream, STR), nb_setval(count, 0),nb_setval(finish,false).
:- dynamic v/2.

posicao(_,_) :- acabou(FIM), FIM, writeln('Jogo encerrado, de make para começar um novo jogo.').
posicao(X,Y) :- v((X,Y),_),writeln('Posicao já aberta, escolha outra para jogar.').
posicao(X,Y) :- mina(X,Y), writeln('Caboom! Jogo encerrado'),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente, write(STR,'jogo encerrado'),close(STR),nb_setval(finish,true).
posicao(X,Y) :- valor(X,Y,N), N > 0, write_jogada(X,Y),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente,write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR),assert(v((X,Y),N)),testa_fim.
posicao(X,Y) :- valor(X,Y,N), N = 0, write_jogada(X,Y),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente, X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR), assert(v((X,Y),N)), testa_fim.
posicao(X,Y) :- not(casa(X,Y)).

posicao2(X,Y) :- v((X,Y),_),!.
posicao2(X,Y) :-  valor(X,Y,N), N > 0,!, write_jogada(X,Y),nb_getval(stream,STR),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR),assert(v((X,Y),N)).
posicao2(X,Y) :- valor(X,Y,N), N = 0,!, write_jogada(X,Y),nb_getval(stream,STR), X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2), write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR),assert(v((X,Y),N)).
posicao2(X,Y) :- not(casa(X,Y)).

write_jogada(X,Y) :- write(X), write(','), write(Y), write('\n').

print_jogada(X,Y) :- nb_getval(stream,STR),nb_getval(count, C),C1 is C+1, write(STR,'\n/* JOGADA '),write(STR,C1), write(STR,' */\n'), write(STR,'posicao('),write(STR,X),write(STR,','),write(STR,Y),write(STR,').'),nb_setval(count,C1).

print_cab_ambiente :- nb_getval(stream,STR),write(STR,'\n/* AMBIENTE */ \n').

acabou(FIM):- nb_getval(finish,FIM).

testa_fim :- findall(X, v(X,_),L1), tamanho(T), len(L1,LGTH), nb_getval(nminas,MINAS), N is LGTH + MINAS, T2 is T*T, N=T2, nb_setval(finish,true),writeln('Parabéns, você venceu!'),nb_getval(stream,STR),close(STR).
/*testa_fim.*/


