;;;; procura.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 1º projeto
;;;; Autor: Marco Pereira Nº 180221019 / Afonso Cunha Nº 180221017

(defun a-estrela (no fun-objetivo fun-sucessores operadores heuristic &optional (abertos '()) (fechados '()))
"Algoritmo de procura A*"
  (let ((START_TIME (get-internal-real-time)))
    (cond 
     ((and (null no) (null (check_node_value (car abertos) fechados))) (a-estrela nil fun-objetivo fun-sucessores operadores heuristic (cdr abertos) (append (list (car abertos)) fechados)))
     (t (let* 
      ((ABERTOS_let (colocar-sucessores-em-abertos abertos (funcall fun-sucessores (COND ((null no) (car abertos))
                                                 (T no))operadores 'a-estrela heuristic))) 
       (FECHADOS_let (append (list (cond ((null no) (car abertos)) (t no))) fechados)))
    (cond 
     ((funcall fun-objetivo (car ABERTOS_let)) (escrever-no (mostrar-solucao (car ABERTOS_let) (- (get-internal-real-time) START_TIME) 'a-estrela (1- (+ (list-length ABERTOS_let) (list-length FECHADOS_let))) (list-length FECHADOS_let) 
                                                (bissecao (no-profundidade (car ABERTOS_let)) (1- (+ (list-length ABERTOS_let) (list-length FECHADOS_let))) 0.01))))
     (t (a-estrela nil fun-objetivo fun-sucessores operadores heuristic (cdr ABERTOS_let) FECHADOS_let)
     )

    ))
   ))
))

(defun bfs (no-inicial fun-objetivo fun-sucessores operadores 
                       &optional (abertos nil) (fechados nil))
"Algoritmo de procura BFS"
  
  (let* ((START_TIME (get-internal-real-time)) (SUCESSORES-CALCULADOS (funcall fun-sucessores (COND ((null no-inicial) (car abertos))
                        (T no-inicial)) operadores 'bfs))
         (ABERTOS_let1 (COND ((null no-inicial) (abertos-bfs abertos SUCESSORES-CALCULADOS))
                          (T (append (list no-inicial) (abertos-bfs abertos SUCESSORES-CALCULADOS)))))
         (FECHADOS_let1 fechados))
    (COND
     ((null ABERTOS_let1) NIL)
     (T (let* ((N (car ABERTOS_let1)) (ABERTOS_let2 (remove (car abertos) ABERTOS_let1)) (FECHADOS_let2 (append (list N) FECHADOS_let1)))
          (cond
           ((funcall fun-objetivo N) (escrever-no (mostrar-solucao N (- (get-internal-real-time) START_TIME) 'bfs (1- (+ (list-length abertos) (list-length fechados))) (list-length fechados) (bissecao (no-profundidade (car abertos)) (1- (+ (list-length abertos) (list-length fechados))) 0.01))))
           (T (bfs nil fun-objetivo fun-sucessores operadores ABERTOS_let2 FECHADOS_let2))
           )
          )
        )
     )
    )
)

(defun dfs (no-inicial fun-objetivo fun-sucessores operadores max-nivel
                       &optional (abertos nil) (fechados nil))
"Algoritmo de procura DFS"
  
  (let* ((START_TIME (get-internal-real-time)) (SUCESSORES-CALCULADOS (funcall fun-sucessores (COND 
                                                          ((null no-inicial) (car abertos))
                                                          (T no-inicial))
                                         operadores 'dfs nil max-nivel))

         (ABERTOS_let (COND ((null no-inicial) (abertos-dfs abertos SUCESSORES-CALCULADOS))
                          (T (append (list no-inicial) (abertos-dfs abertos SUCESSORES-CALCULADOS)))))
         (FECHADOS_let fechados))
    (COND
     ((null ABERTOS_let) NIL)
     (T (let* ((N (car abertos)) (ABERTOS_let2 (remove (car abertos) ABERTOS_let)) (FECHADOS_let2 (append (list N) FECHADOS_let)))
          (cond
           ((funcall fun-objetivo N) (escrever-no (mostrar-solucao N (- (get-internal-real-time) START_TIME) 'dfs (1- (+ (list-length ABERTOS_let2) (list-length FECHADOS_let2))) (list-length fechados) (bissecao (no-profundidade N) (1- (+ (list-length abertos) (list-length fechados))) 0.01))))
           (T (dfs nil fun-objetivo fun-sucessores operadores max-nivel ABERTOS_let2 FECHADOS_let2))
           )
          )
        )
     )
    )
  )

(defun abertos-dfs (abertos sucessores)
"Função que adiciona aos abertos os sucessores de acordo com o algoritmo DFS"
  (append sucessores abertos)
  )


(defun abertos-bfs (abertos sucessores)
"Função que adiciona aos abertos os sucessores de acordo com o algoritmo BFS"
  (append abertos sucessores)
)


(defun check_node_value (no list)
"Função que verifica se existe um no com o mesmo estado do no passado como parametro mas com custo menor numa lista passada como parametro"
  (cond 
   ((null list) no)
   ((and (equal (no-estado no) (no-estado (car list))) (> (no-custo no) (no-custo (car list)))) nil)
   (t (check_node_value no (cdr list))))
)

(defun compare-nos (no-1 no-2)
"Função comparação para usar no sort"
  (< (no-custo no-1) (no-custo no-2))
)

(defun ordenar-nos (list)
"Função que retorna uma lista ordenada de acordo com o <compare-nos>"
  (cond 
   ((null list) nil)
   (t (sort list 'compare-nos))
   )
)

(defun colocar-sucessores-em-abertos (abertos sucessores)
"Função que retorna uma lista ordenado da juncao da lista de abertos com a lista de sucessores"
  (ordenar-nos (append abertos sucessores))
)