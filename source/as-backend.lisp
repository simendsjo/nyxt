;; https://discourse.atlas.engineer/t/nyxt-as-a-backend-application-framework/820/3
(in-package :nyxt-user)
(defparameter acceptor (make-instance 'hunchentoot:easy-acceptor :port 8080))
(hunchentoot:start acceptor)

(asdf:oos 'asdf:load-op :hunchentoot-test)

(defun regex-replace-all (replacements text)
  (dolist (repl replacements text)
    (setf text (ppcre:regex-replace-all (car repl)
                                        text
                                        (cdr repl)))))

(defun replace-nyxt-uris (text)
  (regex-replace-all (list (cons "href=\"nyxt:([^\"]+)\"" "href=\"/nyxt-command?name=\\1\"")
                             (cons "url\\('nyxt-resource:([^']+)'\\)" "url\('/nyxt-resource?name=\\1'\)"))
                       text))

(defun get-nyxt-command-output (name)
 (let* ((cmd (nyxt::find-command (find-symbol (string-upcase name) (symbol-package 'nyxt))))
         (buf (funcall cmd))
         (model (nyxt:document-model buf)))
    (replace-nyxt-uris (plump:serialize model nil))))

;; TODO: Handle keyword arguments to pass into the cmd
;; e.g. describe-function?fn=%1Bexecute-command
;; (nyxt:describe-function :fn 'execute-command)
;; (funcall 'nyxt:describe-function :fn 'execute-command)
(hunchentoot:define-easy-handler (nyxt-command :uri "/nyxt-command") (name)
  (setf (hunchentoot:content-type*) "text/html")
  (get-nyxt-command-output name))

(hunchentoot:define-easy-handler (nyxt-resource :uri "/nyxt-resource") (name)
    (nth-value 0 (gethash name *static-data*)))

(hunchentoot:define-easy-handler (say-yo :uri "/yo") (name)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))


