# Problema do Quatro

O que é o Problema do Quatro?
-----------------------------

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

Como se usa o programa?
-----------------------------
O programa tem um funcionamento simples:

- Executar o comando (iniciar):
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/iniciar.png "iniciar")
- Em seguida o utilizador poderá escolher um dos problemas que estão inseridos no ficheiro [problemas.dat](https://github.com/marcopereira5/jogodoquatro/blob/master/src/problemas.dat) com o número correspondente (1, 2, 3, 4, 5, 6):
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/problemas.png "problemas")
- Em seguida o utilizador poderá escolher um dos algoritmos que foram implementados no programa com o seu número correspondente:  
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/algoritmo.png "problemas")
- No caso de escolher o DFS (Depth-First Search) terá de especificar uma profundidade de limite e no caso de escolher o A-Estrela terá de escolher uma das duas heuristicas implementadas no programa:  
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/dfs.png "problemas")
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/a-estrela.png "problemas")
- Depois de especificar estas propriedades (ou não no caso do BFS) o programa irá executar e mostrar uma solução e os estados durante as suas iterações:
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/solucao2.png "problemas")
- Em seguida se o utilizador quiser observar algumas da propriedades técnicas dos algoritmos (fator de ramificação, penetrância, Nos gerados e Nos expandidos) poderá vizualizá-las no ficheiro que é criado automaticamente intitulado de [resultados.txt](https://github.com/marcopereira5/jogodoquatro/blob/master/src/Resultados.txt):
![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/resultados.png "problemas")
