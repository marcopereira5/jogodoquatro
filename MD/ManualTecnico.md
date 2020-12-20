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
A função que testa esta condição é a seguintes:  

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
