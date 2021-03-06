;;;; projeto.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 1� projeto
;;;; Autor: Marco Pereira N� 180221019 / Afonso Cunha N� 180221017


(defun mostrar-solucao (no time algoritmo nos-gerados nos-expandidos fator)
"Fun��o que mostra a solu��o de uma forma mais compreens�vel (caminho inicio ao fim)"
 (concatenate 'string (format nil " ~S ~% Desempenho: ~% - Tempo de Execu��o: ~D ms ~% - Nos Gerados: ~D ~% - Nos expandidos: ~D ~% - Penetrancia: ~D ~% - Fator de Ramifica��o: ~D ~% ********************************************************************************************~%" algoritmo time nos-gerados nos-expandidos (penetrancia (1+ (no-profundidade no)) nos-gerados) fator) (mostrar-no no algoritmo))
)

(defun mostrar-no (no algoritmo)
"Fun��o que retorna uma string de toda a composi��o de um n�"
  (cond 
   ((null no) nil)
   ((equal algoritmo 'a-estrela) 
    (format t " - Tabuleiro: ~D ~% - Reserva: ~D ~% - Profundidade: ~D ~% - Heuristica: ~D ~% - Custo: ~D ~% ----------------------------------------------------------------------------------------------" 
        (mostrar-tabuleiro (tabuleiro no)) (reserva no) (no-profundidade no) (no-heuristica no) (no-custo no)) (terpri) (mostrar-no (cadddr no) algoritmo))
   ((or (equal algoritmo 'bfs) (equal algoritmo 'dfs)) 
    (format t " - Tabuleiro: ~D ~% - Reserva: ~D ~% - Profundidade: ~D ~%----------------------------------------------------------------------------------------------" 
            (mostrar-tabuleiro (tabuleiro no)) (reserva no) (no-profundidade no)) (terpri) (mostrar-no (cadddr no) algoritmo)))
)

(defun mostrar-tabuleiro (tabuleiro)
"Fun��o que coloca o tabuleiro de maneira percet�vel para o utilizador"
  (cond 
   ((null tabuleiro) "~%")
   (t (format nil (concatenate 'string (format nil "~% ~D" (car tabuleiro)) (mostrar-tabuleiro (cdr tabuleiro))))))
)

(defun penetrancia (caminho nos-gerados)
"Fun��o que retorna a penetrancia de uma solu��o"
  (float (/ caminho nos-gerados))
)

(defun bissecao (N nos-gerados epsilon &optional (a 0) (b 100))
"Fun��o que retorna uma aproxima��o de um zero de uma fun��o qualquer seja o seu grau com o metodo da bissecao"
  (let* ((valor (average a b)) (valor-funcao (funcao valor N nos-gerados)))
    (cond 
     ((< (abs valor-funcao) epsilon) (float valor))
     ((< valor-funcao 0) (bissecao N nos-gerados epsilon valor b))
     ((> valor-funcao 0) (bissecao N nos-gerados epsilon a valor)))))

(defun average (a b)
"Fun��o que retorna uma divis�o para auxiliar o metodo da bisse"
  (/ (+ a b) 2)
)

(defun funcao (valor N nos-gerados)
"Fun��o que retorna a images de uma fun��o de um certo ponto. A fun��o testada aqui ser� do tipo b^n + b^(n-1) ... - nos-gerados = 0"
  (cond 
   ((= N 0) (- 0 nos-gerados))
   (t (+ (expt valor N) (funcao valor (1- N) nos-gerados))))
)

(defun escrever-no (string)
"Fun��o que cria ou escreve no ficheiro resultados.txt"
  (with-open-file (str (make-pathname :host "C" :directory '(:absolute "Users" "Home" "Desktop" "AI" "Projecto" "jogodoquatro" "src") :name "Resultados" :type "txt")
                     :direction :output
                     :IF-DOES-NOT-EXIST :create
                     :if-exists :append)
  (format str string)
  )
)

(defun return-file (heuristic)
"Fun��o que l� o ficheiro porblemas.dat"
   (with-open-file (str (make-pathname :host "C" :directory '(:absolute "Users" "Home" "Desktop" "AI" "Projecto" "jogodoquatro" "src") :name "problemas" :type "dat")
                     :direction :input)
                   (return-list-file str heuristic)
  )
)

(defun return-list-file (file heuristic)
"Fun��o que retorna uma lista em lisp dos problemas do ficheiro problemas.dat"
   (let* ((linha (read-line file nil :fim)))
         (cond 
          ((not (eq linha :fim)) (cond ((not (equal linha "-")) (cons (list (read-from-string linha) 0 (funcall heuristic (car (read-from-string linha))) nil) (return-list-file file heuristic))) (t (return-list-file file heuristic))))
          (t (close file) '()))))

(defun print-problemas (problemas &optional (count 1))
"Fun��o que faz print de um problema do ficheiro problemas.dat"
  (cond 
   ((null problemas) '())
   (t (format t "Problema ~D: ~% - Tabuleiro: ~D ~% - Reserva: ~D ~% --------------------------------------------------------------------------------------------- ~%" count (car (caar problemas)) (cadr (caar problemas)))
      (print-problemas (cdr problemas) (1+ count))))
)

(defun escolher-problema ()
"Fun��o que faz o prompt para o utilizador escolher o problema"
  (progn 
    (print-problemas (return-file 'heuristica-2))
    (format t "Escolher um problema: ")
    (let ((resposta (read)) (problemas-size (list-length (return-file 'heuristica-2))))
      (cond 
       ((or (<= resposta 0) (> resposta problemas-size) (not (atom resposta))) (progn (format t "Problema inv�lido. ~%") (sleep 2) (escolher-problema)))
       (t resposta))))
)

(defun escolher-algoritmo ()
"Fun��o que faz o prompt para o utilizador escolher o algoritmo"
  (progn 
    (format t "Escolher um algoritmo: ~%")
    (format t "1 - BFS ~%2 - DFS ~%3 - A-ESTRELA ~%")
    (format t "Escolha: ")
    (let ((resposta (read)))
      (cond
       ((or (<= resposta 0) (> resposta 3) (not (atom resposta))) (progn (format t "Algoritmo inv�lido. ~%") (sleep 1) (escolher-algoritmo)))
       (t 
        (cond 
         ((= resposta 1) 'bfs)
         ((= resposta 2) 'dfs)
         ((= resposta 3) 'a-estrela))))))
)

(defun escolher-profundidade ()
"Fun��o que faz o prompt para o utilizador escolher a profundidade"
  (progn 
    (format t "Profundidade: ")
    (let ((resposta (read)))
      (cond 
       ((or (<= resposta 0) (not (atom resposta))) (progn (format t "Profundidade inv�lida. ~%") (sleep 1) (escolher-profundidade)))
       (t resposta))))
)

(defun escolher-heuristica ()
"Fun��o que faz o prompt para o utilizador escolher a heuristica"
  (progn 
    (format t "1 - Heuristica - h(x) = 4 - p(x) onde p(x) � o valor m�ximo do alinhamento de pe�as com caracteristicas comuns~%")
    (format t "2 - Heuristica - h(x) = 8 - p(x) onde p(x) � o valor m�ximo do alinhamento de pe�as com caracteristicas comuns mais o valor m�ximo de casas numa linha que est�o ocupadas por pecas (+ eficiente)~%")
    (format t "Heuristica: ")
    (let ((resposta (read)))
      (cond 
       ((equal resposta 1) 'heuristica)
       ((equal resposta 2) 'heuristica-2)
       (t (progn (format t "Heuristica inv�lido. ~%") (sleep 1) (escolher-heuristica))))))
)


(defun iniciar ()
"Fun��o que inicia o programa"
  (let* ((problema (escolher-problema)) (algoritmo (escolher-algoritmo)) (profundidade (cond ((equal algoritmo 'dfs) (escolher-profundidade)) (t 9999))))
    (cond 
     ((equal algoritmo 'bfs) (format t "~%~%~% SOLU��O ~% **************************************************************** ~%") 
                             (bfs (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores))
     ((equal algoritmo 'dfs) (format t "~%~%~% SOLU��O ~% **************************************************************** ~%")
                             (dfs (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores profundidade))
     ((equal algoritmo 'a-estrela) (let ((e-heuristica (escolher-heuristica))) (format t "~%~%~% SOLU��O ~% **************************************************************** ~%") 
                                   (a-estrela (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores e-heuristica)))))
)