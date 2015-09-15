;; load-pathに追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; C-mにnewline-and-indentを割り当てる。初期値はnewline
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; 入力されるキーシーケンスを置き換える
;; ?\C-?はdelのキーシケンス
;; C-hでdelをする
(keyboard-translate ?\C-h ?\C-?)

;; 行の折り返し表示を切り替える
;; C-c lで行を折り返す
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t"でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;;; オートインデントでスペースを使う
(setq-default tab-width 2 indent-tabs-mode nil)

;;; マーク
(setq transient-mark-mode t)

;;; リージョン解除
(global-set-key (kbd "C-M-g") 'keyboard-escape-quit)

;;; 文字サイズ設定
(set-face-attribute 'default nil :height 130)
;;; バックタブ
(defun backtab()
  "Do reverse indentation"
  (interactive)
  (back-to-indentation)
  (delete-backward-char
   (if (< (current-column) (car tab-stop-list)) 0
     (- (current-column)
        (car (let ((value (list 0)))
               (dolist (element tab-stop-list value) 
                 (setq value (if (< element (current-column)) (cons element value) value)))))))))

;;; リージョンタブ
(defun backtab-line-or-region ()
  (interactive)
  (if mark-active (save-excursion
                    (setq count (count-lines (region-beginning) (region-end)))
                    (goto-char (region-beginning))
                    (while (> count 0)
                      (backtab)
                      (forward-line)
                      (setq count (1- count)))
                    (setq deactivate-mark nil))
    (backtab)))

(defun tab-to-tab-stop-line-or-region ()
  (interactive)
  (if mark-active (save-excursion
                    (setq count (count-lines (region-beginning) (region-end)))
                    (goto-char (region-beginning))
                    (while (> count 0)
                      (tab-to-tab-stop)
                      (forward-line)
                      (setq count (1- count)))
                    (setq deactivate-mark nil))
    (tab-to-tab-stop)))
;; ファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

;; 時計を表示（好みに応じてフォーマットを変更可能）
;;(setq display-time-day-and-date t)	; 曜日・月・日を表示
;;(setq display-time-24hr-format t)	; 24時表示
(display-time-mode t)
;; バッテリー残量を表示
(display-battery-mode t)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active 
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
;; これだとエコーエリアがチラつく
;; (count-lines-region (region-beginning) (region-end))
"" ))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))


;; TABの表示幅。初期値は8
(setq-default tab-width 2)

;; インデント
(define-key global-map (kbd "C-c i") 'indent-region)

;; コメントアウト
(define-key global-map (kbd "C-c ;") 'comment-dwin)

;;; 対応する括弧を光らせる
(show-paren-mode 1)

;;; 現在行を目立たせる
(global-hl-line-mode t)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;;; カーソルの位置が何行目かを表示する
(line-number-mode t)

;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;; windmove
;;; shift+矢印キーで移動
 (windmove-default-keybindings)

;;;　補完可能なものを随時表示
(icomplete-mode 1)

;;; スペルチェック
(setq-default flyspell-mode t)
(setq ispell-dictionary "american") 

;;; 自動補完
;;;(el-get 'sync '(aut-complete))
(add-hook 'auto-complete-mode-hook
          (lambda()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))

;;; カラーテーマ
;;;(load-theme 'monojdark t)
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-lethe))) 
;;; 選択範囲の色
(custom-set-faces
 '(region ((t (:background "#214283"))))
 '(helm-selection ((t (:background "#788D31"))))
 )
;;;　~などのバックアップファイルを作らない
(setq make-backup-files nil)
;;; *とかのバックアップファイルを作らない
(setq auto-save-default nil)

;; 行番号表示
(require 'linum)
(global-linum-mode)

;; 指定した行に移動
(global-set-key "\C-x\C-g" 'goto-line)

;;; package.elの準備
(require 'package)
(setq package-archives
      (append '(("marmalade" . "http://marmalade-repo.org/packages/")
                ("melpa" . "http://melpa.milkbox.net/packages/"))
              package-archives))
(package-initialize)
;;; enterでインデント
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "\C-m") 'newline-and-indent)
            (define-key python-mode-map (kbd "RET") 'newline-and-indent)))

(yas-global-mode t)

;;; 自動補完
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map "(" 'electric-pair)
            (define-key python-mode-map "[" 'electric-pair)
            (define-key python-mode-map "{" 'electric-pair)))
(defun electric-pair ()
  "insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;; C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c-mode-common-hook 'flycheck-mode)

;;; 自動インデント
(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である';'を入力したら、自動改行＋インデント
             ;;(c-toggle-auto-hungry-state 1)
             ;; RETキーで自動改行＋インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
             (define-key c-mode-map "(" 'electric-pair)
             (define-key c-mode-map "[" 'electric-pair)
             (define-key c-mode-map "{" 'electric-pair)
             (define-key c-mode-map "<" 'electric-pair)
             ))
(add-hook 'c++-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である';'を入力したら、自動改行＋インデント
             ;;(c++-toggle-auto-hungry-state 1)
             ;; RETキーで自動改行＋インデント
             (define-key c++-mode-base-map "\C-m" 'newline-and-indent)
             (define-key c++-mode-map "(" 'electric-pair)
             (define-key c++-mode-map "[" 'electric-pair)
             (define-key c++-mode-map "{" 'electric-pair)
             (define-key c++-mode-map "<" 'electric-pair)
             ))
;;; 関数名の自動補完
(add-hook 'emacs-lisp-mode-hook '(lambda ()
                                   (require 'auto-complete)
                                   (auto-complete-mode t)
                                   ))
(add-hook 'c-mode-common-hook '(lambda ()
                                 (require 'auto-complete)
                                 (auto-complete-mode t)
                                 ))
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3")
(require 'auto-complete-config)
(ac-config-default)

(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-modes (append ac-modes '(objc-mode)))

;; 括弧の補完
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

;; デフォルトの透明度を設定する
(add-to-list 'default-frame-alist '(alpha . 60))
(if window-system (progn
                    (set-frame-parameter nil 'alpha 60)
                    ))
;;; メニューバーにファイルパスを表示する
(setq frame-title-format
      (format "%%f-Emacs@%s" (system-name)))
;; フルスクリーン
(set-frame-parameter nil 'fullscreen 'maximized)
;; clangによる補完
(add-to-list 'load-path "~/.emacs.d/emacs-clang-complete-async-master")
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/el-get/repo/clang-complete-async/clang-complete")
  (setq ac-sources (append ac-sources '(ac-source-clang-async)))
  (ac-clang-launch-completion-process))
(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(my-ac-config)

;; ヘッダファイルがC++として認識される
(add-to-list 'auto-mode-alist '("\\.h\\'". c++-mode))

(add-to-list 'load-path "~/.emacs.d/emacs-clang-complete-async-master")
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/el-get/repo/clang-complete-async/clang-complete")
  (setq ac-sources (append ac-sources '(ac-source-clang-async)))
  (ac-clang-launch-completion-process))
(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(my-ac-config)

;; ヘッダファイルがC++として認識される
(add-to-list 'auto-mode-alist '("\\.h\\'". c++-mode))

(add-to-list 'load-path "~/.emacs.d/auto-complete-c-headers-master")
(require 'auto-complete-c-headers)
(add-hook 'c++-mode-hook '(setq ac-sources (append ac-sources '(ac-sources-c-headers))))
(add-hook 'c-mode-hook '(setq ac-sources (append ac-sources '(ac-sources-c-headers))))

;; html設定
(add-to-list 'load-path "~/.emacs.d/zencoding-master")
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)

;;自動改行C用
;;(setq c-auto-newline t)

(defun my-c-c++-mode-init ()
  (setq c-hanging-braces-alist '((class-open before after)
                                 (class-close before)))
  )

;;; rubyの設定開始
;; rubyファイルの認識
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\. rb$latex" . ruby-mode))
(add-to-list 'auto-mode-alist ' ("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist ' ("Gemfile$" . ruby-mode))

;;; かっこなどの自動補完
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'ruby-electric)
(add-hook 'ruby-mode-hook ' (lambda () (ruby-electric-mode t)))
(setq ruby-electric-expand-delimiters-list nil)

;;; エンドに対するハイライト
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;;; rcodetools
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)

;; シンボルのハイライト
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)



(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)

;;; C-cC-cで編集中に実行
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'smart-compile)
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;;; PHP設定
(autoload 'php-mode "php-mode")
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))
(setq php-mode-force-pear t)
(add-hook 'php-mode-user-hook
          '(lambda ()
             (setq php-manual-path "~/.emacs.d/php-chunked-xhtml")
             (setq php-manual-url "http://www.phppro.jp/phpmanual/")))

(add-to-list 'load-path "~/.emacs.d/elisp/php-mode-1.13.1")
(require 'php-mode)
;;; CSS
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

;;; javascript
(add-to-list 'auto-mode-alist (cons "\\.js\\'" 'javascript-mode))
(autoload 'javascript-mode "javascript" nil t)
(setq js-indent-level 2)

;;; HTML,CSS自動モード切り替え

(defun aka:init-mmm ()
  (load-library "mmm-mode")
  (require 'mmm-auto)
  (setq mmm-global-mode 'maybe)
  (setq mmm-submode-decoration-level 3)
  (setq mmm-font-lock-available-p t)
  (set-face-background 'mmm-default-submode-face "black")
  (mmm-add-classes
   '((embedded-css
      :submode css-mode
      :front "<style[^>]*>"
      :back "</style>")))
  (mmm-add-mode-ext-class nil "\\.html?\\'" 'embedded-css)
  (mmm-add-classes
   '((html-javascript
      :submode javascript-mode
      :front "<script[^>]*>"
      :back "</script>")))
  (mmm-add-mode-ext-class nil "\\.html?\\'" 'html-javascript))

;;; ツリー表示
(add-to-list 'load-path "~/.emacs.d/elisp/popwin-el-master")
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

(add-to-list 'load-path "~/.emacs.d/elisp/direx-el-master")
(require 'direx)
(setq direx:leaf-icon " "
	  direx:open-icon "\&#9662; "
	  direx:closed-icon "$#9654; ")
(push '(direx:direx-mode :position left :width 25 :dedicated t)
	  popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)

;;; scssの設定
(add-to-list 'load-path "~/.emacs.d/elisp/scss-mode-master")

(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))

;; インデント幅を２にする
;; コンパイルはcompass watch で行うので自動コンパイルをオフ
(defun scss-custom ()
  "scss-mode-hook"
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)
   )
  )
(add-hook 'scss-mode-hook
          '(lambda() (scss-custom)))

;;; dirtree
(add-to-list 'load-path "~/.emacs.d/emacs-dirtree-master")
(require 'dirtree)
(require 'tree-mode)
(require 'windata)
(autoload 'dirtree "dirtree" "Add directory to tree view" t)

;;; スクロールの高速動
(add-to-list 'load-path "~/.emacs.d/smooth-scroll.el-master")
(require 'smooth-scroll)
(smooth-scroll-mode t)

;;; web-mode
(add-to-list 'load-path "~/.emacs.d/elisp/web-mode-master")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.ctp\\'"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; web-modeの設定
(defun web-mode-hook ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-engines-alist
        '(("php"    . "\\.ctp\\'"))
        )
  )

(add-hook 'web-mode-hook  'web-mode-hook)

;; 色の設定
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#fff"))))
 '(web-mode-html-tag-face
   ((t (:foreground "#33ccff" :weight bold))))
 '(web-mode-html-attr-name-face
   ((t (:foreground "#ccffcc"))))
 '(web-mode-html-attr-value-face
   ((t (:foreground "#ffcccc"))))
 '(web-mode-comment-face
   ((t (:foreground "#ffffcc"))))
 '(web-mode-server-comment-face
   ((t (:foreground "#D9333F"))))
 '(web-mode-css-rule-face
   ((t (:foreground "#A0D8EF"))))
 '(web-mode-css-pseudo-class-face
   ((t (:foreground "#FF7F00"))))
 '(web-mode-css-at-rule-face
   ((t (:foreground "#FF7F00"))))
)

;;; erbの設定
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml-master")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
		  (lambda () (rinari-launch)))

;;; タブ・スペース可視化
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

(add-to-list 'load-path "~/.emacs.d/elisp/hlinum-mode-master")
(require 'hlinum)
(custom-set-variables
 '(global-linum-mode t))
(custom-set-faces
 '(linum-highlight-face ((t (:foreground "black"
                             :background "red")))))
