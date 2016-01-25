;;; mocha.el --- Mocha testing for Emacs:

;; Copyright (C) 2016 Al Scott <github.com/scottaj>
;; Author: Al Scott
;; URL: http://github.com/scottaj/mocha.el
;; Created: 2016
;; Version: 0.1
;; Keywords: javascript mocha jasmine
;; Package-Requires: ()

;; This file is NOT part of GNU Emacs.
;;
;;; Commentary:
;;
;; This mode provides the ability to run Mocha or Jasmine tests from within Emacs

;;; Code:
(require 'compile)

(defvar mocha-which-node "node")

(defvar mocha-command "mocha")

(defvar mocha-environment-variables nil)

(defvar mocha-options nil)

(defvar mocha-project-test-directory nil)

(defun mocha-command (&optional mocha-file)
  "The test command to run.

If MOCHA-FILE is specified run just that file otherwise run MOCHA-PROJECT-TEST-DIRECTORY"
  (concat mocha-environment-variables " "
          mocha-which-node " "
          mocha-command " "
          mocha-options " "
          (or mocha-file mocha-project-test-directory)))

(defun mocha-run (&optional mocha-file)
  "Run mocha in a compilation buffer.

If MOCHA-FILE is specified run just that file otherwise run MOCHA-PROJECT-TEST-DIRECTORY"
  (compile (mocha-command mocha-file))
  (pop-to-buffer "*compilation*")
  (rename-buffer "*mocha tests*"))

(defun mocha-test-project ()
  "Test the current project."
  (interactive)
  (mocha-run))

(defun mocha-test-file ()
  "Test the current file."
  (interactive)
  (mocha-run (buffer-file-name)))

;; Add NodeJS error format (from http://benhollis.net/blog/2015/12/20/nodejs-stack-traces-in-emacs-compilation-mode/)
(add-to-list 'compilation-error-regexp-alist-alist '(node "^[  ]+at \\(?:[^\(\n]+ \(\\)?\\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)\)?$" 1 2 3))
(add-to-list 'compilation-error-regexp-alist 'node)

(add-to-list 'compilation-error-regexp-alist-alist '(npm "^[  ]+at \\(?:[^\(\n]+ \(\\)?\\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)\)?$" 1 2 3))
(add-to-list 'compilation-error-regexp-alist 'npm)

(provide 'mocha)
;;; mocha.el ends here
