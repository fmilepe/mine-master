/* Carrega as cláusulas criadas no prog1.pl */
:- ensure_loaded(prog1).

/* Carrega as cláusulas auxiliares criadas no arquivo utils.pl */
:- ensure_loaded(utils).

/* Abre o arquivo onde será salvo o log do jogo atual e inicializa as constantes stream (stream do arquivo de log), 
	count (contador que diz qual o numero da jogada atua) e finish (booleano que diz se o jogo já acabou) */
:- open("jogo.pl",write,STR), nb_setval(stream, STR), nb_setval(count, 0),nb_setval(finish,false).

/* Declarando que a cláusula v (que guarda os valores que já foram abertos), será alterada dinamicamente com assert */
:- dynamic v/2.

/* 
	A cláusula posição é aquela que executa uma jogada. Ao chamar posição com 2 coordenadas a casa é aberta e seu valor se torna conhecido, se a casa não possuir bomba, ou o jogo é encerrado, se a casa possuir uma bomba. Cada jogada válida também gera uma entrada no arquivo de log do jogo (jogo.pl)

	A regra abaixo garante que se o jogo já tiver sido encerrado o jogador não consiga abrir mais nenhuma posição do tabuleiro.
*/
posicao(_,_) :- acabou(FIM), FIM, !, writeln('Jogo encerrado, de make para começar um novo jogo.').

/* Evita que o jogador consiga abrir de novo uma posição já aberta */
posicao(X,Y) :- v((X,Y),_), !, writeln('Posicao já aberta, escolha outra para jogar.').

/* O jogador abriu uma posição com mina e o jogo será encerrado. */
posicao(X,Y) :- mina(X,Y), !, write(X),write(','),writeln(Y), writeln('Caboom! Jogo encerrado'),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente, write(STR,'jogo encerrado'),close(STR),nb_setval(finish,true).

/* Jogador abriu uma posição sem bomba e cujo valor é maior que 0. */
posicao(X,Y) :- valor(X,Y,N), N > 0, !, write_jogada(X,Y),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente,write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR),assert(v((X,Y),N)),testa_fim.

/* Jogador abriu uma posição sem bomba e cujo valor é igual a  0. Todas as casas vizinhas serão abertas usando a cláusula posicao2. */
posicao(X,Y) :- valor(X,Y,N), N = 0, !, write_jogada(X,Y),nb_getval(stream,STR),print_jogada(X,Y),print_cab_ambiente, X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR), assert(v((X,Y),N)), testa_fim.

/* Regras criadas para evitar que uma chamada inválida de posicao(X,Y) dê falso. */
posicao(X,Y) :- not(casa(X,Y)), !.
posicao(X,Y) :- not(valor(X,Y,_)).

/* Cláusula criada para abrir automaticamente as casas vizinhas a uma casa com valor 0.*/
posicao2(X,Y) :- v((X,Y),_),!.
posicao2(X,Y) :-  valor(X,Y,N), N > 0,!, write_jogada(X,Y),nb_getval(stream,STR),write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,','),write(STR,N),write(STR,').'),nl(STR),assert(v((X,Y),N)).
posicao2(X,Y) :- valor(X,Y,N), N = 0,!, write_jogada(X,Y),nb_getval(stream,STR), X1 is X -1, X2 is X + 1, Y1 is Y-1, Y2 is Y + 1, posicao2(X1,Y1),posicao2(X,Y1),posicao2(X2,Y1), posicao2(X1,Y), posicao2(X2,Y),posicao2(X1,Y2),posicao2(X,Y2),posicao2(X2,Y2), write(STR,'valor('), write(STR,X),write(STR,','),write(STR,Y),write(STR,',0).'),nl(STR),assert(v((X,Y),N)).
posicao2(X,Y) :- not(casa(X,Y)).

/* Informa no terminal em qual casa se está jogando no momento */
write_jogada(X,Y) :- write('Jogando na casa '),write(X), write(':'), write(Y), write('.\n').

/* Escreve as informações da jogada no arquivo de log */
print_jogada(X,Y) :- nb_getval(stream,STR),nb_getval(count, C),C1 is C+1, write(STR,'\n/* JOGADA '),write(STR,C1), write(STR,' */\n'), write(STR,'posicao('),write(STR,X),write(STR,','),write(STR,Y),write(STR,').'),nb_setval(count,C1).

/* Escreve o cabeçalho do log de ambiente no arquivo de log. */
print_cab_ambiente :- nb_getval(stream,STR),write(STR,'\n/* AMBIENTE */ \n').

/* Testa se a variável de fim de jogo está setada como verdadeira */
acabou(FIM):- nb_getval(finish,FIM).

/* Testa se o jogador venceu com a ultima jogada. */
testa_fim :- findall(X, v(X,_),L1), tamanho(T), len(L1,LGTH), nb_getval(nminas,MINAS), N is LGTH + MINAS, T2 is T*T, N=T2,!, nb_setval(finish,true),writeln('Parabéns, você venceu!'),nb_getval(stream,STR),close(STR).

/* Garante que, se o jogador não venceu, o testa_fim dê verdadeiro, sem alterar nada no ambiente. Isso foi feito porque o testa_fim estava dando falso e fazendo com que toda a cláusula posicao que o chamava desse falso */
testa_fim.


