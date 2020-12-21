# Manual de Utilizador - Problema do Quatro

Projeto Problema do Quatro
-------------------------------
* Unidade Curricular : Inteligência Artificial
* Projeto Problema do Quatro - 1ª Fase
* Alunos:
  * Marco Pereira nº 180221019
  * Afonso Cunha nº 180221017
  
Introdução
----------

O problema do quatro é um jogo constituído por um tabuleiro de 4 x 4 casas e um conjunto de 16 peças, que possuem traços característicos de forma e de cor. Existem quatro tipos de características:

- Branca ou Preta 
- Alta ou Baixa
- Quadrada ou Redonda 
- Cheia ou Oca

Isto significa que as 16 peças do jogo encontram-se divididas da seguinte forma, pelas características mencionadas:

- Existem 8 peças brancas e 8 peças pretas 
- Existem 8 peças altas e 8 peças baixas 
- Existem 8 peças quadradas e 8 peças redondas
- Existem 8 peças cheias e 8 peças ocas

![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/tabuleiro.jpg "Tabuleiro")

Qual é a solução?
-----------------------------
Para atingir um estado de solução é preciso completar pelo menos uma linha de 4 peças (na horizontal, vertical ou diagonal) que compartilhem pelo menos uma característica comum (4 peças pretas, ou 4 peças altas, ou 4 peças ocas etc).

Qual é o objetivo do programa?
-----------------------------
Este programa tem como objetivo encontrar a melhor solução possível do Jogo Do Quatro utilizando Algoritmos de Procura em Espaço de Estados. Podemos entender a melhor solução possível como o conjunto minimo de jogadas que o jogador terá de realizar para atingir um estado de solução. O programa tem uma série de estados de tabuleiro de teste (vazios, com peças variadas) e tem como objetivo encontrar uma solução óptima para qualquer um destes estados.

Temos o exemplo do seguinte tabuleiro: 

![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/teste.png "Tabuleiro")

A primeira componente da lista é um tabuleiro de teste com peças já colocadas, sendo que os zeros representam casas vazias. A segunda componente é caracterizada pelas peças de reserva que podem ser colocadas no tabuleiro para atingir um estado de solução. Depois de correr o programa podemos identificar a melhor solução e que peça se deve colocar para atingir este estado.

![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/solucao.png "Tabuleiro")

Este problema específico tinha uma solução simples e é identificado pela colocação da peça Branca Quadrada Baixa Oca na terceira casa da primeira linha. Com esta colocação podemos observar que a primeira linha fica com 4 peças com a caracteristica Quadrada e atinge-se um estado de solução.

Instalação e utilização
-----------------------
O programa executa em qualquer ambiente que consiga compilar **Common Lisp**. Neste manual irá-se dar o exemplo de como o programa pode ser executado no LispWorks:
* Fazer download dos ficheiros
* Abrir o LispWorks
* Dentro da pasta src irá encontrar 3 ficheiros importantes: puzzle.lisp, projeto.lisp e procura.lisp.
* Terá de abrir estes três ficheiros um de cada vez no LispWorks. Pode fazê-lo clicando em File > Open. 
* Em seguida terá de compilar um ficheiro de cada vez:  
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/compilar.png "iniciar")
* Depois de compilar os três ficheiros, terá de abrir um listener. Pode fazê-lo em Tools > Listener

Como se usa o programa?
-----------------------------
O programa tem um funcionamento simples:

- Executar o comando (iniciar):
```
CL-USER 1 > (iniciar)
```
- Em seguida o utilizador poderá escolher um dos problemas que estão inseridos no ficheiro [problemas.dat](https://github.com/marcopereira5/jogodoquatro/blob/master/src/problemas.dat) com o número correspondente (1, 2, 3, 4, 5, 6):
```
Problema 1: 
 - Tabuleiro: (((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 (PRETA QUADRADA ALTA OCA)) ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0) (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0) ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))) 
 - Reserva: ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Problema 2: 
 - Tabuleiro: (((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA)) ((BRANCA REDONDA ALTA OCA) 0 (BRANCA REDONDA ALTA CHEIA) 0) ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0) ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)) 
 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Problema 3: 
 - Tabuleiro: (((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA)) (0 0 0 (BRANCA REDONDA BAIXA OCA)) ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0) (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)) 
 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Problema 4: 
 - Tabuleiro: (((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA)) (0 0 0 0) (0 0 0 0) (0 0 0 0)) 
 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Problema 5: 
 - Tabuleiro: ((0 0 0 0) (0 0 0 0) (0 0 (PRETA REDONDA ALTA OCA) 0) (0 0 0 0)) 
 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Problema 6: 
 - Tabuleiro: ((0 0 0 0) (0 0 0 0) (0 0 0 0) (0 0 0 0)) 
 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
 --------------------------------------------------------------------------------------------- 
Escolher um problema: 
```
- Em seguida o utilizador poderá escolher um dos algoritmos que foram implementados no programa com o seu número correspondente:  
```
Escolher um algoritmo: 
1 - BFS 
2 - DFS 
3 - A-ESTRELA 
Escolha: 
```
- No caso de escolher o DFS (Depth-First Search) terá de especificar uma profundidade de limite e no caso de escolher o A-Estrela terá de escolher uma das duas heuristicas implementadas no programa:  
```
Profundidade: 
```
```
1 - Heuristica - h(x) = 4 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns
2 - Heuristica - h(x) = 8 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns mais o valor máximo de casas numa linha que estão ocupadas por pecas (+ eficiente)
Heuristica: 
```
- Depois de especificar estas propriedades (ou não no caso do BFS) o programa irá executar e mostrar uma solução e os estados durante as suas iterações:
```
 SOLUÇÃO 
 **************************************************************** 
 - Tabuleiro: 
 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA ALTA OCA))
 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0)
 ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))
 
 - Reserva: ((PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
 - Profundidade: 1 
 - Heuristica: 0 
 - Custo: 1 
 ----------------------------------------------------------------------------------------------
 - Tabuleiro: 
 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 (PRETA QUADRADA ALTA OCA))
 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0)
 ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))
 
 - Reserva: ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
 - Profundidade: 0 
 - Heuristica: 1 
 - Custo: 1 
 ----------------------------------------------------------------------------------------------
```
- Em seguida se o utilizador quiser observar algumas da propriedades técnicas dos algoritmos (fator de ramificação, penetrância, Nos gerados e Nos expandidos) poderá vizualizá-las no ficheiro que é criado automaticamente intitulado de [resultados.txt](https://github.com/marcopereira5/jogodoquatro/blob/master/src/Resultados.txt):
```
 A-ESTRELA 
 Desempenho: 
 - Tempo de Execução: 0 ms 
 - Nos Gerados: 16 
 - Nos expandidos: 1 
 - Penetrancia: 0.125 
 - Fator de Ramificação: 15.991211 
 ********************************************************************************************
```

Adicionar Problemas
-------------------
O programa permite a adição de problemas feitos por qualquer utilizador. Para o programa reconhecer o problema terá de introduzir o mesmo de acordo com uma syntax específica:
```
(((0 0 0 0) (0 0 0 0) (0 0 (preta redonda alta oca) 0) (0 0 0 0)) ((preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta quadrada baixa oca)(branca redonda alta cheia) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia) (branca quadrada baixa cheia)))
-
(((0 0 0 0) (0 0 0 0) (0 0 0 0) (0 0 0 0)) ((preta redonda alta oca) (preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta quadrada baixa oca)(branca redonda alta cheia) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia) (branca quadrada baixa cheia)))
```

Todos os problemas são separados por um delimitador "-" e estão em linhas diferentes. O problema terá de estar na forma de:

```
( (tabuleiro) (reserva) )
```
Exemplo: 
```
(((0 0 0 0) (0 0 0 0) (0 0 (preta redonda alta oca) 0) (0 0 0 0)) ((preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta quadrada baixa oca)(branca redonda alta cheia) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia) (branca quadrada baixa cheia)))
```
