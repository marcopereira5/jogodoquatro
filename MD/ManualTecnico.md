# Manual Técnico - Problema do Quatro


Projeto Problema do Quatro
-------------------------------
* Unidade Curricular : Inteligência Artificial
* Projeto Problema do Quatro - 1ª Fase
* Alunos:
  * Marco Pereira nº 180221019
  * Afonso Cunha nº 180221017
  

Módulos
-------
* puzzle.lisp: implementação da resolução do problema, incluindo a definição dos operadores e heurísticas, específicos do problema a ser tratado.
* procura.lisp: implementação dos métodos de procura, de forma independente do domínio de aplicação.
* projeto.lisp: interação com o utilizador e e funções de escrita e leitura de ficheiros.

O módulo puzzle contextualiza todo o problema e cria as funções necessárias (sucessores, heuristíca e end-condition) para realizar os algoritmos de procura do módulo procura (BFS, DFS A-ESTRELA). O módulo procura contém todos os algoritmos de procura do projeto e é independente de todo o contexto do problema, ou seja, qualquer problema que seja criado e contextualizado criando as funções (sucessores, heuristíca e end-condition) pode realizar estes métodos de procura. O módulo projeto realiza todas as funções de escrita e leitura de ficheiro. Este módulo importa os problemas e realiza as estatísticas do algoritmo a ser executado, sendo que estas funções são normalmente chamadas dentro do próprio algoritmo em si. Este módulo também trata das interação com o utilizador e executa as procuras de acordo com o input do utilizador.

Representação de um nó / objeto
-------------------------------
 Um nó é representado por 4 objetos:
 
 * O estado do nó:  
   Que é dividido por duas secções:
   * O Tabuleiro (os zeros indicam casas vazias):
 ``` lisp
(  
  ((branca quadrada alta oca) (preta quadrada baixa cheia) (branca quadrada baixa oca) (preta quadrada alta oca))
  ((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0)   
  (0 (preta redonda alta cheia) (preta redonda baixa cheia) 0)   
  ((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))  
)
```
  
   * A Reserva: 
 ```lisp
(
	(preta quadrada baixa oca)
	(branca redonda baixa cheia)
	(preta quadrada alta cheia)
)
 ```
   
 * A profundidade do nó:
 `1`
 * O valor heuristico do nó:
 `0`
 * O nó pai: 
```lisp
(
    (
      (
        ((branca quadrada alta oca) (preta quadrada baixa cheia) 0 (preta quadrada alta oca)) 
        ((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0) 
        (0 (preta redonda alta cheia) (preta redonda baixa cheia) 0) 
        ((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))
      )
      (
        (branca quadrada baixa oca)
        (preta quadrada baixa oca)
        (branca redonda baixa cheia)
        (preta quadrada alta cheia)
      )
    )
    0
    2
    NIL
  )
)
```
    

Estado de solução
-----------------
 É atingido um estado de solução quando existe uma linha com 4 peças com pelos menos uma característica igual. No nó exemplo acima podemos verificar um estado de solução, a 
 primeira linha apresenta 4 peças com a característica [Quadrada]:  
 ``` lisp
 (
		((branca [quadrada] alta oca) (preta [quadrada] baixa cheia) (branca [quadrada] baixa oca) (preta [quadrada] alta oca))   
		((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0)   
		(0 (preta redonda alta cheia) (preta redonda baixa cheia) 0)   
		((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))  
)
```
A função que testa esta condição é a seguinte:  

```lisp
(defun end-condition (no)
  (let ((NUMBER_SAME_CHARACTHERISTICS (max
  (check-line (linha 0 (tabuleiro no)))
  (check-line (linha 1 (tabuleiro no)))
  (check-line (linha 2 (tabuleiro no)))
  (check-line (linha 3 (tabuleiro no)))
  (check-line (coluna 0 (tabuleiro no)))
  (check-line (coluna 1 (tabuleiro no)))
  (check-line (coluna 2 (tabuleiro no)))
  (check-line (coluna 3 (tabuleiro no)))
  (check-line (diagonal-1 (tabuleiro no)))
  (check-line (diagonal-2 (tabuleiro no))))))
  (cond 
   ((= NUMBER_SAME_CHARACTHERISTICS 4) t)
   (t nil)))
)
```

Que é auxiliada pela seguinte função: 
```lisp
(defun check-line (line)
"Função que retorna o numero de vezes que a caracteristica mais comum aparece numa linha"
  (max
  (count 'branca (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (first x)))) line):test #'equal)
  (count 'preta (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (first x)))) line):test #'equal)
  (count 'redonda (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (second x)))) line):test #'equal)
  (count 'quadrada (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (second x)))) line):test #'equal)
  (count 'alta (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (third x)))) line):test #'equal)
  (count 'baixa (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (third x)))) line):test #'equal)
  (count 'cheia (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (fourth x)))) line):test #'equal)
  (count 'oca (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (fourth x)))) line):test #'equal)
  )
)
```
Heurísticas 
-----------
Foram criadas duas heurísticas para resolver o problema em questão. 

##### h(x) = 4 − p(x)

A primeira Heurística é caracterizada pela função *h(x) = 4 − p(x)* em que p(x) é o valor máximo do alinhamento de peças tomando em conta todas as possibilidades em termos de diração (diagonais, linhas, colunas) que tenham a mesma característica, ou seja, num tabuleiro com uma diagonal com 3 peças com pelo menos uma característica igual e sem qualquer outra direção com 3 ou mais peças com pelo menos uma característica igual terá uma heurística igual a 1, pois *h(x) = 4 - 3 = 1*.

```lisp
(defun heuristica (estado)
"Função que retorna a heuristica / Heuristica - h(x) = 4 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns"
  (let ((NUMBER_SAME_CHARACTHERISTICS (max
  (check-line (linha 0 estado))
  (check-line (linha 1 estado))
  (check-line (linha 2 estado))
  (check-line (linha 3 estado))
  (check-line (coluna 0 estado))
  (check-line (coluna 1 estado))
  (check-line (coluna 2 estado))
  (check-line (coluna 3 estado))
  (check-line (diagonal-1 estado))
  (check-line (diagonal-2 estado)))))
  (- 4 NUMBER_SAME_CHARACTHERISTICS))
)
```

##### h(x) = 8 − p(x)

A segunda Heurística é caracterizada pela função *h(x) = 8 − p(x)* em que p(x) é o valor máximo do alinhamento de peças tomando em conta todas as possibilidades em termos de diração (diagonais, linhas, colunas) que tenham a mesma característica mais o valor máximo de casas que estão ocupadas numa linha do tabuleiro, ou seja, num tabuleiro com uma diagonal com 2 peças com pelo menos uma característica igual e sem qualquer outra direção com 2 ou mais peças com pelo menos uma característica igual e que tenha uma linha com 3 casas ocupadas terá um valor heurístico de 3, pois *h(x) = 8 - (2 + 3) = 3*. Na próxima secção irá comprovar-se que esta heurística é mais eficiente que a primeira.

```lisp
(defun heuristica-2 (estado)
"Função que retorna a segunda heuristica - Heuristica - h(x) = 8 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns mais o valor máximo de casas numa linha que estão ocupadas por pecas"
  (let ((NUMBER_SAME_CHARACTHERISTICS (max
  (+ (check-line (linha 0 estado)) (check-line-count (linha 0 estado)) )
  (+ (check-line (linha 1 estado)) (check-line-count (linha 1 estado)))
  (+ (check-line (linha 2 estado)) (check-line-count (linha 2 estado)))
  (+ (check-line (linha 3 estado)) (check-line-count (linha 3 estado)))
  (+ (check-line (coluna 0 estado)) (check-line-count (coluna 0 estado)))
  (+ (check-line (coluna 1 estado)) (check-line-count (coluna 1 estado)))
  (+ (check-line (coluna 2 estado)) (check-line-count (coluna 2 estado)))
  (+ (check-line (coluna 3 estado)) (check-line-count (coluna 3 estado)))
  (+ (check-line (diagonal-1 estado)) (check-line-count (diagonal-1 estado)))
  (+ (check-line (diagonal-2 estado)) (check-line-count (diagonal-2 estado))))))
  (- 8 NUMBER_SAME_CHARACTHERISTICS))
)
```

```lisp
(defun check-line-count (line)
"Função que retorna quantos espaços estão ocupados por pecas numa linha"
  (- 4 (count 0 line))
)
```

**A função check-line está definida no capítulo acima**

Problemas Resolvidos e Análise Crítica
--------------------------------------

### Problema A
* Estado: 
```lisp
(
  (
    ((branca quadrada alta oca) (preta quadrada baixa cheia) 0 (preta quadrada alta oca)) 
    ((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0) 
    (0 (preta redonda alta cheia) (preta redonda baixa cheia) 0) 
    ((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))
  ) 
    ((branca quadrada baixa oca)(preta quadrada baixa oca)(branca redonda baixa cheia)(preta quadrada alta cheia))
  )
)
```
* Resultados
	* **BFS**:  
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
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 (PRETA QUADRADA ALTA OCA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
		 (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0)
		 ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))

		 - Reserva: ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 BFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 16 
		 - Nos expandidos: 1 
		 - Penetrancia: 0.125 
		 - Fator de Ramificação: 15.991211 
		 ********************************************************************************************
		```
   * **DFS (Profundidade = 2)**:	
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
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 (PRETA QUADRADA ALTA OCA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
		 (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0)
		 ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))

		 - Reserva: ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 1 ms 
		 - Nos Gerados: 16 
		 - Nos expandidos: 1 
		 - Penetrancia: 0.125 
		 - Fator de Ramificação: 15.991211 
		 ********************************************************************************************
		```
	* **A-ESTRELA (1º Heurística)**:
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
	* **A-ESTRELA (2º Heurística)**:
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
		```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 1 ms 
		 - Nos Gerados: 16 
		 - Nos expandidos: 1 
		 - Penetrancia: 0.125 
		 - Fator de Ramificação: 15.991211 
		 ********************************************************************************************
 		```
* Análise Crítica  
Todos os algoritmos produziram os mesmos resultados, sendo que neste problema em específico poderia-se usar qualquer algoritmo. A solução encontra-se no 1º nível de profundidade, sendo que poderiamos afirmar que o os algoritmos BFS e A-ESTRELA iriam ser os mais eficientes. Esta afirmação tem um certo teor de verdade sendo que o algoritmo DFS só encontra a solução na primeira iteração "por sorte", pois o primeiro sucessor deste nó é a colocação da peça (BRANCA QUADRADA BAIXA OCA) na primeira posição disponível, sendo que este operador traduz-se logo na solução do problema. Se o primeiro operador não fosse este, o DFS teria maior dificuldade em encontrar a solução.

### Problema B
* Estado
	```
	(
		(
			((branca quadrada alta oca) (preta redonda baixa oca) (preta quadrada alta oca) (branca quadrada alta cheia)) 
			((branca redonda alta oca) 0 (branca redonda alta cheia) 0) 
			((preta quadrada baixa cheia) (preta redonda alta cheia) (branca quadrada baixa oca) 0) 
			((preta quadrada baixa oca) 0 (branca quadrada baixa cheia) 0)
		) 
			((branca redonda baixa oca)(preta redonda baixa cheia)(preta redonda alta oca)(preta quadrada alta cheia)(branca redonda baixa cheia))
		)
	)
	```
* Resultados
	* **BFS**: 
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA))
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) 0 (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 BFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 425 
		 - Nos expandidos: 26 
		 - Penetrancia: 0.0070588235 
		 - Fator de Ramificação: 20.121766 
		 ********************************************************************************************
		```
	* **DFS (Profundidade = 3)**: 
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA OCA))
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) 0 (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 41 
		 - Nos expandidos: 2 
		 - Penetrancia: 0.07317073 
		 - Fator de Ramificação: 5.921936 
		 ********************************************************************************************
		```
	* **A-ESTRELA (1ª Heurística)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA OCA))
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 0 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 1 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) 0 (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 1 
		 - Custo: 1 
		 ----------------------------------------------------------------------------------------------
		```
		```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 1 ms 
		 - Nos Gerados: 418 
		 - Nos expandidos: 26 
		 - Penetrancia: 0.0071770335 
		 - Fator de Ramificação: 19.951249 
		 ********************************************************************************************
	  ```
	* **A-ESTRELA (2ª Heurística)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA OCA))
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 0 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 1 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA ALTA CHEIA))
		 ((BRANCA REDONDA ALTA OCA) 0 (BRANCA REDONDA ALTA CHEIA) 0)
		 ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA QUADRADA BAIXA OCA) 0)
		 ((PRETA QUADRADA BAIXA OCA) 0 (BRANCA QUADRADA BAIXA CHEIA) 0)

		 - Reserva: ((BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA CHEIA) (PRETA REDONDA ALTA OCA) (PRETA QUADRADA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 1 
		 - Custo: 1 
		 ----------------------------------------------------------------------------------------------
		```
		```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 418 
		 - Nos expandidos: 26 
		 - Penetrancia: 0.0071770335 
		 - Fator de Ramificação: 19.951249 
		 ********************************************************************************************
		```
* Análise Crítica  
Neste problema podemos observar que o DFS foi muito mais eficiente do que qualquer um dos outros algoritmos. Isto deve-se ao facto de o estado de solução se encontrar depois de se executar os dois primeiros operadores de cada iteração, ou seja, colocar a peça (BRANCA REDONDA BAIXA OCA) na primeira casa disponível e na segunda iteração colocar a peça (PRETA REDONDA BAIXA CHEIA) na segunda casa disponível, e assim atinge-se um estado de solução. Neste tipo de problemas as soluções são bastante recorrentes e os sucessores são muitos, sendo assim o DFS será normalmente mais rápido que o BFS ou o A-ESTRELA, porque terá de percorrer um número menor de nós para encontrar uma solução.

### Problema C
* Estado
	```
	(
		(
			((branca quadrada baixa cheia) 0 (preta redonda alta cheia) (preta quadrada baixa oca)) 
			(0 0 0 (branca redonda baixa oca)) 
			((branca redonda alta cheia) 0 (preta redonda alta oca) 0) 
			(0 (preta quadrada baixa cheia) 0 0)
		) 
			((branca redonda alta oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia))
		)
	)
	```
	* Resultados: 
		* **BFS**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 BFS 
		 Desempenho: 
		 - Tempo de Execução: 1 ms 
		 - Nos Gerados: 35498 
		 - Nos expandidos: 699 
		 - Penetrancia: 8.4511805E-5 
		 - Fator de Ramificação: 187.90978 
		 ********************************************************************************************
		```
	* **DFS (Profundidade 3)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA QUADRADA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 3 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA QUADRADA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 194 
		 - Nos expandidos: 32 
		 - Penetrancia: 0.020618556 
		 - Fator de Ramificação: 5.4197655 
		 ********************************************************************************************
		```
		
	* **A-ESTRELA (1ª Heurística)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 0 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 1 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 3 
		 - Custo: 3 
		 ----------------------------------------------------------------------------------------------
		```
		```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 2 ms 
		 - Nos Gerados: 4034 
		 - Nos expandidos: 63 
		 - Penetrancia: 7.436787E-4 
		 - Fator de Ramificação: 63.01574 
		 ********************************************************************************************
		```
		
	* **A-ESTRELA (2ª Heurística)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 0 
		 - Custo: 2 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((BRANCA REDONDA ALTA OCA) 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 2 
		 - Custo: 3 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) 0 (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))
		 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 (PRETA QUADRADA BAIXA CHEIA) 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 3 
		 - Custo: 3 
		 ----------------------------------------------------------------------------------------------
		 ```
		 ```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 1 ms 
		 - Nos Gerados: 657 
		 - Nos expandidos: 10 
		 - Penetrancia: 0.00456621 
		 - Fator de Ramificação: 25.136809 
		 ********************************************************************************************
		 ```
* Análise Crítica  
Como podemos observar o DFS continua a ser o algoritmo com melhores resultados. Já começamos a ver algumas diferenças entre o A-ESTRELA com a 2ª heurística e o A-ESTRELA com a 1ª Heurística, a 2ª Heurística neste problema criou uma procura muito mais eficiente que a 1ª. Conseguimos então ir comprovando a teoria do problema anterior, muitos sucessores por cada nó e múltiplas soluções em vários níveis vão favorecendo mais o DFS que os outros algoritmos de procura.


### Problema D
* Estado
```
(
	(
		((branca quadrada baixa cheia) (branca redonda alta cheia) (preta redonda alta cheia) (preta quadrada baixa oca)) 
		(0 0 0 0) 
		(0 0 0 0) 
		(0 0 0 0)
	) 
	(
		(preta redonda alta oca) (preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia)
	)
)
```

* Resultados
	* **BFS**:  
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
	* **DFS (Profundidade: 8)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA))
		 ((PRETA QUADRADA BAIXA CHEIA) 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 5 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA))
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 4 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 3 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 ((PRETA REDONDA ALTA OCA) 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA))
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 560 
		 - Nos expandidos: 4 
		 - Penetrancia: 0.010714286 
		 - Fator de Ramificação: 4.4103623 
		 ********************************************************************************************
		```
	* **A-ESTRELA (1ª Heurística)**:  
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
	* **A-ESTRELA  (2ª Heurística)**:  
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
* Análise Crítica  
Como podemos observar este problema apenas correu no DFS. O LispWorks tem um limite de memória heap que impede os outros algoritmos de correrem até ao fim. Nenhuma das Heurísticas conseguiu otimizar o A-Estrela, pois no caso deste problema as duas heurísticas são anuladas pois são as duas igual a 1 quando o programa começa, fazendo com que todos os nós tenham mesmo custo heurístico. O custo heurístico irá ser 1 em todos os nós até à solução e o A-Estrela irá tornar-se no BFS sendo que não existe nenhum critério aplicado à procura.

### Problema E
* Estado: 
```
	(
		(
			(0 0 0 0) 
			(0 0 0 0) 
			(0 0 (preta redonda alta oca) 0) 
			(0 0 0 0)
		) 
		(
		(preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta quadrada baixa oca)(branca redonda alta cheia) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia) (branca quadrada baixa cheia)
		)
	)
```

* Resultados
	* **BFS**:  
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
	* **DFS (Profundidade = 12)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA))
		 ((PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA OCA))
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 8 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA))
		 ((PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 7 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA))
		 ((PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 6 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA))
		 ((PRETA QUADRADA ALTA OCA) 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 5 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA))
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 4 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 3 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) 0 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) 0 0 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 1100 
		 - Nos expandidos: 7 
		 - Penetrancia: 0.008181818 
		 - Fator de Ramificação: 2.5078535 
		 ********************************************************************************************
		```
	* **A-ESTRELA (1ª Heurística)**:  
		![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
		
	* **A-ESTRELA (2ª Heurística)**:
    ```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((BRANCA REDONDA ALTA OCA) 0 0 0)
		 (0 (PRETA REDONDA BAIXA OCA) 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 (BRANCA REDONDA BAIXA OCA))

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 3 
		 - Heuristica: 0 
		 - Custo: 3 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA REDONDA ALTA OCA) 0 0 0)
		 (0 (PRETA REDONDA BAIXA OCA) 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 2 
		 - Custo: 4 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((BRANCA REDONDA ALTA OCA) 0 0 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 4 
		 - Custo: 5 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 (PRETA REDONDA ALTA OCA) 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 6 
		 - Custo: 6 
		 ----------------------------------------------------------------------------------------------
		```
		```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 4 ms 
		 - Nos Gerados: 590 
		 - Nos expandidos: 3 
		 - Penetrancia: 0.006779661 
		 - Fator de Ramificação: 8.028603 
		 ********************************************************************************************
		 ```
 
 * Análise Crítica  
 Neste problema conseguimos observar a melhoria da 2ª Heurística em relação à 1ª. Apesar do DFS ter conseguido correr e ter encontrado uma solução, o A-Estrela com a 2ª Heurística foi mais eficiente e conseguiu encontrar a melhor solução possível para este problema. Pode-se talvez ter uma melhor solução se diminuirmos a profundidade do DFS até 4, sendo que com profundidade = 3 o DFS não executa e excede o limite do Heap. O BFS continua a não conseguir executar devido à quantidade de sucessores e iterações necessárias para encontrar a solução. O A-Estrela com a 1ª Heurística continua a ser bastante ineficiente e não consegue executar devido às limitações do LispWorks.

### Problema F
* Estado: 
```
(
	(
		(0 0 0 0) 
		(0 0 0 0) 
		(0 0 0 0) 
		(0 0 0 0)
	) 
	(
		(preta redonda alta oca) (preta quadrada baixa cheia) (branca redonda alta oca) (branca redonda baixa oca) (preta redonda baixa oca) (branca quadrada alta oca) (preta quadrada alta oca) (branca quadrada baixa oca) (preta quadrada baixa oca)(branca redonda alta cheia) (preta redonda alta cheia) (branca redonda baixa cheia) (preta redonda baixa cheia) (branca quadrada alta cheia) (preta quadrada alta cheia) (branca quadrada baixa cheia)
	)
)
```

* Resultados: 
	* **BFS**:  
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
	* **DFS (Profundidade = 5)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA OCA))
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 4 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (PRETA REDONDA BAIXA OCA) 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 3 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 2 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA REDONDA ALTA OCA) 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 0 
		----------------------------------------------------------------------------------------------
		```
		```
		 DFS 
		 Desempenho: 
		 - Tempo de Execução: 0 ms 
		 - Nos Gerados: 50689 
		 - Nos expandidos: 49452 
		 - Penetrancia: 1.1836888E-4 
		 - Fator de Ramificação: 8.508996 
		 ********************************************************************************************
		```
	* **A-ESTRELA (1ª Heurística)**:   
	![alt text](https://github.com/marcopereira5/jogodoquatro/blob/master/images_md/erro.png "Erro")
	
	* **A-ESTRELA (2ª Heurística)**:
		```
		 SOLUÇÃO 
		 **************************************************************** 
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA BAIXA OCA))
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 4 
		 - Heuristica: 0 
		 - Custo: 4 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA OCA) 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 3 
		 - Heuristica: 2 
		 - Custo: 5 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA BAIXA OCA) 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 2 
		 - Heuristica: 4 
		 - Custo: 6 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 ((PRETA QUADRADA BAIXA CHEIA) 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 1 
		 - Heuristica: 6 
		 - Custo: 7 
		 ----------------------------------------------------------------------------------------------
		 - Tabuleiro: 
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)
		 (0 0 0 0)

		 - Reserva: ((PRETA REDONDA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA REDONDA ALTA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA ALTA CHEIA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA BAIXA CHEIA) (PRETA REDONDA BAIXA CHEIA) (BRANCA QUADRADA ALTA CHEIA) (PRETA QUADRADA ALTA CHEIA) (BRANCA QUADRADA BAIXA CHEIA)) 
		 - Profundidade: 0 
		 - Heuristica: 8 
		 - Custo: 8 
		 ----------------------------------------------------------------------------------------------
		 ```
		 ```
		 A-ESTRELA 
		 Desempenho: 
		 - Tempo de Execução: 2 ms 
		 - Nos Gerados: 846 
		 - Nos expandidos: 4 
		 - Penetrancia: 0.0059101656 
		 - Fator de Ramificação: 5.109215 
		 ********************************************************************************************
		 ```
	* Análise Crítica:  
	Neste problema podemos ver o quanto mais eficiente A-Estrela quando a Heurística é otimizada para o problema. O BFS e o A-Estrela com a 1ª Heurística não executaram devido à explicação do problema anterior. Neste problema o DFS com uma profundidade máxima de 5 tem uma menor eficiência que o A-Estrela com a segunda Heurística pois como o A-Estrela tem uma Heurística eficiente consegue encontrar logo o melhor caminho a seguir e o DFS vai procurando sem qualquer critério. Se aumentarmos a profundidade máxima o DFS poderá ser mais eficiente, mas nunca chegará à melhor solução possível.
	
Análise Geral
-------------
Depois de realizar os 6 testes, podemos afirmar que o algoritmo mais consistente para este problema é o DFS, mesmo que por vezes não encontre a solução ideal. Comprovamos assim a teoria de que se um problema tiver várias soluções em vários níveis e os sucessores de cada nó são muitos os DFS tem um melhor funcionamento. Em relação ao A-Estrela, a 1ª Heurística executou os primeiros 3 testes enquanto que a 2ª executou todos menos o 4. A única maneira de o A-Estrela com a 2ª Heurística não encontrar a solução é se o problema tiver um estado igual ao do problema 4. De resto, nos problemas finais, que são os mais difíceis, conseguiu encontar a melhor solução possível muito mais eficientemente que qualquer outro algortimo. Comprovamos assim que a 2ª Heurística é muito mais optimizada para o problema em questão que a 1ª. O BFS teve o pior desempenho, devido à quantidade de sucessores que cada nó produz.

Limitações Técnicas
-------------------
Uma das maiores limitações do desenvolvimento deste projeto foi o espaço de memória heap limitado do LispWorks. Muitos dos problemas, em alguns algoritmos, não conseguiram executar até ao fim, o que não permite que se observe a estatística e os resultados dos mesmos. Sendo assim não se conseguiu realizar uma análise comparativa real de todos os algoritmos em questão. Outra das limitações técnicas foi o facto de por vezes nas estatística o tempo de execução ser 0ms. Não sabemos a causa deste mau funcionamento e é uma das limitações que se teria de resolver numa próxima iteração do programa.

Ideias para Desenvolvimento Futuro
----------------------------------
A programação dos outros algoritmos de procura Simplified Memory‒Bounded A* (SMA*), Iterative Deepening A* (IDA*) ou Recursive Best First Search (RBFS).
