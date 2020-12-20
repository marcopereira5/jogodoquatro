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

##### Problema A
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
* Solução dos Algoritmos:
	* BFS:  
		```
		SOLUÇÃO 
		**************************************************************** 
		 - Tabuleiro: (((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) (BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA ALTA OCA)) ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0) (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0) ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))) 
		 - Reserva: ((PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 1 
		----------------------------------------------------------------------------------------------
		 - Tabuleiro: (((BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA BAIXA CHEIA) 0 (PRETA QUADRADA ALTA OCA)) ((BRANCA REDONDA ALTA OCA) (PRETA REDONDA ALTA OCA) (BRANCA REDONDA ALTA CHEIA) 0) (0 (PRETA REDONDA ALTA CHEIA) (PRETA REDONDA BAIXA CHEIA) 0) ((BRANCA REDONDA BAIXA OCA) (BRANCA QUADRADA ALTA CHEIA) (PRETA REDONDA BAIXA OCA) (BRANCA QUADRADA BAIXA CHEIA))) 
		 - Reserva: ((BRANCA QUADRADA BAIXA OCA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA) (PRETA QUADRADA ALTA CHEIA)) 
		 - Profundidade: 0 
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
   * DFS (Profundidade = 2):	
