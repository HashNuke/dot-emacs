(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require `el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (end-of-buffer)
       (eval-print-last-sexp)))))

(setq el-get-sources
      '((:name starter-kit
	       :type elpa)
	(:name starter-kit-ruby
               :type elpa)
        (:name starter-kit-eshell
               :type elpa)
        (:name starter-kit-js
               :type elpa)
        (:name starter-kit-bindings
               :type elpa)))


(el-get 'sync
	'starter-kit
	'starter-kit-eshell
	'starter-kit-ruby
	'starter-kit-js
	'starter-kit-bindings)
