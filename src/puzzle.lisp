;;;; puzzle.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 1� projeto
;;;; Autor: Marco Pereira N� 180221019 / Afonso Cunha N� 180221017



(defun teste-a ()
"Fun��o que representa um tabuleiro de teste"
  '(
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

(defun tabuleiro (no)
"Fun��o que retorna o tabuleiro"
  (cond 
   ((null no) nil)
   (t (car (car no)))
   )
)

(defun no-estado (no)
  (car no)
)

(defun reserva (no)
"Fun��o que retorna as pe�as de reserva"
  (cond 
   ((null no) nil)
   (t (cadr (car no)))
   )
)

(defun no-profundidade (no)
"Fun��o que retorna a profundidade do no"
  (cond 
   ((null no) nil)
   (t (cadr no)))
)

(defun no-pai (no)
  (cond 
   ((null no) nil)
   (t (cadddr no)))
)

(defun no-custo (no)
  (+ (caddr no) (cadr no))
)

(defun no-heuristica (no)
  (caddr no)
)

(defun linha (index list)
"Fun��o que retorna a linha do tabuleiro do index passado por argumento"
  (cond 
   ((null list) nil)
   (t (nth index list))
   )
)

(defun coluna (index list)
"Fun��o que retorna a coluna do tabuleiro do index passado por argumento"
  (cond 
   ((or (< index 0) (null list)) nil)
   (t (cons (nth index (car list)) (coluna index (cdr list)))))
)

(defun celula (l-index c-index list)
"Fun��o que retorna a c�lula numa determinada posicao"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null list)) nil)
   (t (nth c-index (nth l-index list)))
   )
)

(defun diagonal-1 (list)
"Fun��o que retorna a primeira diagonal"
  (cond 
   ((null list) nil)
   (t (list (nth 0 (nth 0 list)) (nth 1 (nth 1 list)) (nth 2 (nth 2 list)) (nth 3 (nth 3 list)))))
)

(defun diagonal-2 (list)
"Fun��o que retorna a segunda diagonal"
  (cond 
   ((null list) nil)
   (t (list (nth 3 (nth 0 list)) (nth 2 (nth 1 list)) (nth 1 (nth 2 list)) (nth 0 (nth 3 list)))))
)

(defun casa-vaziap (l-index c-index list)
"Fun��o que indica se uma determianda casa est� ocupada ou n�o"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null list)) nil)
   ((equal (nth c-index (nth l-index list)) 0) t)
   (t nil)
   )
)

(defun remover-peca (piece list)
"Fun��o que remove uma peca de uma lista"
  (cond 
   ((or (null piece) (null list)) nil)
   ((equal (car list) piece) (remover-peca piece (cdr list)))
   (t (cons (car list) (remover-peca piece (cdr list)))))
)

(defun substituir-list (index list element &optional (count 0))
"Fun��o auxiliar que substitui um elemento numa lista"
  (cond 
   ((null list) '())
   ((= index count) (cons element (substituir-list index (cdr list) element (+ count 1))))
   (t (cons (car list) (substituir-list index (cdr list) element (+ count 1)))))
)

(defun substituir-posicao (index piece line)
"Fun��o que substitu� uma peca numa determinada linha"
  (cond 
   ((or (< index 0) (null piece) (null line)) nil)
   (t (substituir-list index line piece))
   )
)

(defun substituir (l-index c-index piece list)
"Fun��o que substitui uma peca numa lista/tabuleiro"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null piece) (null list)) nil)
   (t (substituir-posicao l-index (substituir-posicao c-index piece (linha l-index list)) list)))
)

(defun operador (l-index c-index piece no)
"Fun��o que realiza uma jogada e retorna o estado seguinte"
    (cond 
     ((casa-vaziap l-index c-index (tabuleiro no)) (list (substituir l-index c-index piece (tabuleiro no)) (remover-peca piece (reserva no))))
     (t nil)
     )
)

(defun operadores ()
"Fun��o que retorna os operadores/jogadas poss�veis"
  '((0 0) (0 1) (0 2) (0 3) (1 0) (1 1) (1 2) (1 3) (2 0) (2 1) (2 2) (2 3) (3 0) (3 1) (3 2) (3 3))
)

(defun check-line (line)
"Fun��o que retorna o numero de vezes que a caracteristica mais comum aparece numa linha"
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

(defun check-line-count (line)
"Fun��o que retorna quantos espa�os est�o ocupados por pecas numa linha"
  (- 4 (count 0 line))
)

(defun end-condition (no)
"Fun��o que indica se o no um chegou � condi��o final / Condi��o final - Quando existem 4 caracteristicas iguais numa linha"
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

(defun heuristica (estado)
"Fun��o que retorna a heuristica / Heuristica - h(x) = 4 - p(x) onde p(x) � o valor m�ximo do alinhamento de pe�as com caracteristicas comuns"
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

(defun heuristica-2 (estado)
"Fun��o que retorna a segunda heuristica - Heuristica - h(x) = 8 - p(x) onde p(x) � o valor m�ximo do alinhamento de pe�as com caracteristicas comuns mais o valor m�ximo de casas numa linha que est�o ocupadas por pecas"
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

(defun novo-sucessor (no l-index c-index piece &optional (heuristic nil))
"Fun��o que retorna um novo sucessor de um determinado n� no contexto do problema"
  (let 
      ((oper (operador l-index c-index piece no)))
    (cond 
     ((null oper) nil)
     ((null heuristic) (list oper (1+ (no-profundidade no)) 0 no))
     (t (list oper (1+ (no-profundidade no)) (funcall heuristic (car oper)) no)
))))



(defun sucessores (no operadores algoritmo &optional (heuristic nil) (max-nivel nil))
"Fun��o que retorna os sucessores de um determinado no"
  (cond 
   ((equal algoritmo 'a-estrela)
    (remove NIL (mapcan #'(lambda (operador) (remove NIL (mapcar #'(lambda (peca) (novo-sucessor no (car operador) (cadr operador) peca heuristic)) (reserva no)))) (operadores))))
    ((equal algoritmo 'bfs) 
     (remove NIL (mapcan #'(lambda (operador) (remove NIL (mapcar #'(lambda (peca) (novo-sucessor no (car operador) (cadr operador) peca)) (reserva no)))) (funcall operadores))))
    ((equal algoritmo 'dfs)
     (remove NIL (mapcan #'(lambda (operador) (remove NIL (mapcar #'(lambda (peca) (gerar-sucessores-df no operador peca max-nivel)) (reserva no)))) (operadores)))))
)

(defun gerar-sucessores-df (no operador peca max-nivel)
  (cond
   ((>= (no-profundidade no) max-nivel) nil)
   (T (let ((NOVO-NO (novo-sucessor no (car operador) (cadr operador) peca)))
        (cond
         ((OR (null NOVO-NO) (<= (no-profundidade NOVO-NO) (no-profundidade no))) nil)
         (T NOVO-NO)
         )
        )
      )
   )
  )

