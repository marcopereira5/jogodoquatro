;;;; projeto.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 1º projeto
;;;; Autor: Marco Pereira Nº 180221019 / Afonso Cunha Nº 180221017


(defun mostrar-solucao (no time algoritmo nos-gerados nos-expandidos fator)
"Função que mostra a solução de uma forma mais compreensível (caminho inicio ao fim)"
 (concatenate 'string (format nil " ~S ~% Desempenho: ~% - Tempo de Execução: ~D ms ~% - Nos Gerados: ~D ~% - Nos expandidos: ~D ~% - Penetrancia: ~D ~% - Fator de Ramificação: ~D ~% ********************************************************************************************~%" algoritmo time nos-gerados nos-expandidos (penetrancia (1+ (no-profundidade no)) nos-gerados) fator) (mostrar-no no algoritmo))
)

(defun mostrar-no (no algoritmo)
"Função que retorna uma string de toda a composição de um nó"
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
"Função que coloca o tabuleiro de maneira percetível para o utilizador"
  (cond 
   ((null tabuleiro) "~%")
   (t (format nil (concatenate 'string (format nil "~% ~D" (car tabuleiro)) (mostrar-tabuleiro (cdr tabuleiro))))))
)

(defun penetrancia (caminho nos-gerados)
"Função que retorna a penetrancia de uma solução"
  (float (/ caminho nos-gerados))
)

(defun bissecao (N nos-gerados epsilon &optional (a 0) (b 100))
"Função que retorna uma aproximação de um zero de uma função qualquer seja o seu grau com o metodo da bissecao"
  (let* ((valor (average a b)) (valor-funcao (funcao valor N nos-gerados)))
    (cond 
     ((< (abs valor-funcao) epsilon) (float valor))
     ((< valor-funcao 0) (bissecao N nos-gerados epsilon valor b))
     ((> valor-funcao 0) (bissecao N nos-gerados epsilon a valor)))))

(defun average (a b)
"Função que retorna uma divisão para auxiliar o metodo da bisse"
  (/ (+ a b) 2)
)

(defun funcao (valor N nos-gerados)
"Função que retorna a images de uma função de um certo ponto. A função testada aqui será do tipo b^n + b^(n-1) ... - nos-gerados = 0"
  (cond 
   ((= N 0) (- 0 nos-gerados))
   (t (+ (expt valor N) (funcao valor (1- N) nos-gerados))))
)

(defun escrever-no (string)
"Função que cria ou escreve no ficheiro resultados.txt"
  (with-open-file (str (make-pathname :host "C" :directory '(:absolute "Users" "Home" "Desktop" "AI" "Projecto" "jogodoquatro" "src") :name "Resultados" :type "txt")
                     :direction :output
                     :IF-DOES-NOT-EXIST :create
                     :if-exists :append)
  (format str string)
  )
)

(defun return-file (heuristic)
"Função que lê o ficheiro porblemas.dat"
   (with-open-file (str (make-pathname :host "C" :directory '(:absolute "Users" "Home" "Desktop" "AI" "Projecto" "jogodoquatro" "src") :name "problemas" :type "dat")
                     :direction :input)
                   (return-list-file str heuristic)
  )
)

(defun return-list-file (file heuristic)
"Função que retorna uma lista em lisp dos problemas do ficheiro problemas.dat"
   (let* ((linha (read-line file nil :fim)))
         (cond 
          ((not (eq linha :fim)) (cond ((not (equal linha "-")) (cons (list (read-from-string linha) 0 (funcall heuristic (car (read-from-string linha))) nil) (return-list-file file heuristic))) (t (return-list-file file heuristic))))
          (t (close file) '()))))

(defun print-problemas (problemas &optional (count 1))
"Função que faz print de um problema do ficheiro problemas.dat"
  (cond 
   ((null problemas) '())
   (t (format t "Problema ~D: ~% - Tabuleiro: ~D ~% - Reserva: ~D ~% --------------------------------------------------------------------------------------------- ~%" count (car (caar problemas)) (cadr (caar problemas)))
      (print-problemas (cdr problemas) (1+ count))))
)

(defun escolher-problema ()
"Função que faz o prompt para o utilizador escolher o problema"
  (progn 
    (print-problemas (return-file 'heuristica-2))
    (format t "Escolher um problema: ")
    (let ((resposta (read)) (problemas-size (list-length (return-file 'heuristica-2))))
      (cond 
       ((or (<= resposta 0) (> resposta problemas-size) (not (atom resposta))) (progn (format t "Problema inválido. ~%") (sleep 2) (escolher-problema)))
       (t resposta))))
)

(defun escolher-algoritmo ()
"Função que faz o prompt para o utilizador escolher o algoritmo"
  (progn 
    (format t "Escolher um algoritmo: ~%")
    (format t "1 - BFS ~%2 - DFS ~%3 - A-ESTRELA ~%")
    (format t "Escolha: ")
    (let ((resposta (read)))
      (cond
       ((or (<= resposta 0) (> resposta 3) (not (atom resposta))) (progn (format t "Algoritmo inválido. ~%") (sleep 1) (escolher-algoritmo)))
       (t 
        (cond 
         ((= resposta 1) 'bfs)
         ((= resposta 2) 'dfs)
         ((= resposta 3) 'a-estrela))))))
)

(defun escolher-profundidade ()
"Função que faz o prompt para o utilizador escolher a profundidade"
  (progn 
    (format t "Profundidade: ")
    (let ((resposta (read)))
      (cond 
       ((or (<= resposta 0) (not (atom resposta))) (progn (format t "Profundidade inválida. ~%") (sleep 1) (escolher-profundidade)))
       (t resposta))))
)

(defun escolher-heuristica ()
"Função que faz o prompt para o utilizador escolher a heuristica"
  (progn 
    (format t "1 - Heuristica - h(x) = 4 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns~%")
    (format t "2 - Heuristica - h(x) = 8 - p(x) onde p(x) é o valor máximo do alinhamento de peças com caracteristicas comuns mais o valor máximo de casas numa linha que estão ocupadas por pecas (+ eficiente)~%")
    (format t "Heuristica: ")
    (let ((resposta (read)))
      (cond 
       ((equal resposta 1) 'heuristica)
       ((equal resposta 2) 'heuristica-2)
       (t (progn (format t "Heuristica inválido. ~%") (sleep 1) (escolher-heuristica))))))
)


(defun iniciar ()
"Função que inicia o programa"
  (let* ((problema (escolher-problema)) (algoritmo (escolher-algoritmo)) (profundidade (cond ((equal algoritmo 'dfs) (escolher-profundidade)) (t 9999))))
    (cond 
     ((equal algoritmo 'bfs) (format t "~%~%~% SOLUÇÃO ~% **************************************************************** ~%") 
                             (bfs (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores))
     ((equal algoritmo 'dfs) (format t "~%~%~% SOLUÇÃO ~% **************************************************************** ~%")
                             (dfs (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores profundidade))
     ((equal algoritmo 'a-estrela) (let ((e-heuristica (escolher-heuristica))) (format t "~%~%~% SOLUÇÃO ~% **************************************************************** ~%") 
                                   (a-estrela (nth (1- problema) (return-file 'heuristica-2)) 'end-condition 'sucessores 'operadores e-heuristica)))))
)