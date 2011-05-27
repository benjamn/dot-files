;; Need to configure terminal to send ESC f/b for control right/left.

(global-set-key (kbd "C-h") 'delete-char)
(global-set-key (kbd "<deletechar>") 'delete-backward-char)
(global-set-key (kbd "ESC <deletechar>") 'backward-kill-word)

(global-set-key (kbd "C-p") 'backward-paragraph)
(global-set-key (kbd "C-n") 'forward-paragraph)

(provide 'ben)
