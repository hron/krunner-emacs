;;; krunner_emacs.el --- KRunner integration -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Aleksei Gusev
;;
;; Author: Aleksei Gusev <aleksei.gusev@gmail.com>
;; Maintainer: Aleksei Gusev <aleksei.gusev@gmail.com>
;; Created: June 26, 2025
;; Modified: July 18, 2025
;; Version: 0.0.3
;; Homepage: https://github.com/hron/krunner_emacs
;; Package-Requires: ((emacs "30.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Provides D-Bus service to run Emacs for known projects via krunner
;;
;;; Code:

(require 'dbus)
(require 'project)

(setq dbus-debug nil
      debug-on-error t)

(defconst krunner_emacs-service-name "org.kde.krunner_emacs")
(defconst krunner_emacs-object-path "/runner")
(defconst krunner_emacs-interface "org.kde.krunner1")

(defun krunner_emacs-run (project-root _action-id)
  "Run Emacs for PROJECT-ROOT, handles `org.kde.krunner1.Run'."
  (let ((project-root (expand-file-name project-root)))
    (message (concat "emacs --chdir " project-root))
    (start-process "emacs" nil "emacs" "--chdir" (expand-file-name project-root)))
  '())

(defun krunner_emacs-project-to-match (project-root)
  "Convert PROJECT-ROOT to D-Bus match response for krunner."
  (let ((name (file-name-base (string-remove-suffix "/" project-root))))
    `(:struct :string ,project-root
              :string ,name
              :string "emacs"
              :int32 50
              :double 0.5
              (:array
               (:dict-entry :string "subtext"
                            (:variant :string ,project-root))))))

(defun krunner_emacs-match (query)
  "Return projects that match QUERY, handles `org.kde.krunner1.Match'."
  (let* ((query-tokens (string-split query " "))
         (all-projects (progn
                         (project--read-project-list)
                         (project-known-project-roots)))
         (matched-projects (seq-filter
                            (lambda (p)
                              (seq-every-p (lambda (t) (string-match-p t p)) query-tokens))
                            all-projects)))
    (list (seq-map #'krunner_emacs-project-to-match matched-projects))))

(dbus-register-method :session
                      krunner_emacs-service-name
                      krunner_emacs-object-path
                      krunner_emacs-interface
                      "Run"
                      #'krunner_emacs-run
                      nil)

(dbus-register-method :session
                      krunner_emacs-service-name
                      krunner_emacs-object-path
                      krunner_emacs-interface
                      "Match"
                      #'krunner_emacs-match
                      nil)

(message "krunner_emacs: started")

(provide 'krunner_emacs)

;;; krunner_emacs.el ends here
