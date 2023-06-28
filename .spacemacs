;; -*- mode: emacs-lisp -*-

;; @todo
;; - Paste after typing '/'. See: https://github.com/syl20bnr/spacemacs/issues/5101.
;; - Left align org mode tables when editing Behat table and tabbing.

(defun my-php-mode-hook ()
  ;; Disable PHPMD.
  (setq-default flycheck-disabled-checkers
    (append flycheck-disabled-checkers
      '(php-phpmd)))

  ; Load skeleton templates.
  (require 'php-ext)

  ;; PHP completion.
  (use-package company-php)
  (use-package ac-php)
  (make-local-variable 'company-backends)
  (add-to-list 'company-backends 'company-ac-php-backend)
  (setq ac-sources '(ac-source-php))
  ;; (company-mode t)
  ;; (ac-php-core-eldoc-setup)

  ;; Enable LSP mode.
  ;; (use-package lsp-mode)
  ;; (load-file "/Users/UQ/.emacs.d/private/lsp-intellij.el")
  ;; (with-eval-after-load 'lsp-mode
  ;;   (require 'lsp-intellij)
  ;;   (add-hook 'php-mode-hook #'lsp-intellij-enable))
  ;; (require 'lsp-ui)
  ;; (add-hook 'lsp-after-open-hook #'lsp-ui-mode)
  ;; (require 'company-lsp)
  ;; (setq company-lsp-enable-snippet t
  ;;   company-lsp-cache-candidates t)
  ;; (push 'company-lsp company-backends)
  ;; (push 'php-mode company-global-modes)
  ;; (lsp-prog-major-mode-enable)
  ;; (lsp-php-enable)
  ;; (lsp-define-stdio-client
  ;;   lsp-php
  ;;   "php"
  ;;   "/Users/UQ/vm/apps/uq-drupal-standard/drupal"
  ;;   '("php" "/Users/UQ/bin/php-language-server/bin/php-language-server.php")
  ;;   )
  ;; (setq lsp-php-server-install-dir "/Users/UQ/bin/php-language-server/")
  ;; (setq lsp-php-language-server-command
  ;;   (list "php"
  ;;     (expand-file-name "~/bin/php-language-server/bin/php-language-server.php")))

  ;; Use the Drupal,DrupalPractice rulesets for PHPCS.
  (php-enable-drupal-coding-style)
  (setq php-mode-coding-style 'drupal)
  (setq flycheck-phpcs-standard "Drupal,DrupalPractice")

  ;; Cascade method calls.
  (setq php-lineup-cascaded-calls t)

  ;; Ensure PHP 7 is used.
  (setq php-executable "/usr/local/opt/php/bin/php")
)

(defun dotspacemacs/layers ()
  "Configuration Layers declaration."

  (setq-default
   ;; Base distribution to use.
   dotspacemacs-distribution 'spacemacs

   ;; List of additional paths where to look for configuration layers.
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; Emacs.
     better-defaults
     org

     ;; Themes.
     colors
     themes-megapack

     ;; Source control.
     git
     version-control

     ;; Tags.
     gtags

     ;; Operating systems.
     osx

     ;; Fun.
     emoji

     ;; Checkers.
     ;; (spell-checking :variables spell-checking-enable-auto-dictionary 0)
     syntax-checking

     ;; Language support.
     emacs-lisp
     html
     javascript
     (markdown :variables markdown-live-preview-engine 'vmd)
     php
     python
     shell-scripts
     sql
     typescript
     yaml
     vimscript

     ;; Completion.
     auto-completion

     ;; Private.
     lsp-intellij
   )

   ;; List of additional packages that will be installed without being wrapped in a layer.
   dotspacemacs-additional-packages
   '(
     editorconfig
     lsp-mode
     lsp-ui
     company-lsp
     ;; @todo Move to a private init.el.
     company-php
     ac-php
     feature-mode
     doom-themes
     org-journal
   )

   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages
   '(
     evil-search-highlight-persist
   )

   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t)
)

(defun dotspacemacs/init ()
  "Initialisation function."

  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5

   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update t

   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)

   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 5

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   ;; spacemacs -dark
   ;; gruvbox - doesn't work?
    dotspacemacs-themes '(doom-one
                          badwolf
                          afternoon
                          ample-flat
                          colorsarenice-dark
                          farmhouse-dark
                          monokai
                          smyx
                          spolsky
                          wombat
                          zenburn)

   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
    dotspacemacs-default-font '("Hack"
                               :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; dotspacemacs-default-font '("Fira Mono"
   ;;                             :size 18
   ;;                             :weight normal
   ;;                             :width normal
   ;;                             :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts t

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil

   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil

   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil

   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom

   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar 1

   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols 1

   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers 'relative

   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")

   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing
    )
)

(defun dotspacemacs/user-init ()
  "Initialisation function for user code."

  ;; Use a custom file path.
  (setq custom-file
    (expand-file-name "private/local/custom.el" user-emacs-directory))
  (if (file-exists-p custom-file)
      (load custom-file))

  ;; Configure spell checking to use Aspell, with the Australian dictionary.
  (setq ispell-program-name "/usr/local/bin/aspell")
  (setq ispell-dictionary "en_AU")
  (setenv "DICTIONARY" "en_AU")

  ;; Always follow version controlled symlinks.
  (setq vc-follow-symlinks t)

  ;; File associations.
  (add-to-list 'magic-mode-alist '("filetype=sh" . sh-mode))

  ;; Set the indentation levels.
  (setq-default
    javascript-indent-level       2 ; javascript-mode
    js-indent-level               2 ; js-mode
    js2-basic-offset              2 ; js2-mode, in latest js2-mode, it's alias of js-indent-level
    web-mode-markup-indent-offset 2 ; web-mode, html tag in html file
    web-mode-css-indent-offset    2 ; web-mode, css in html file
    web-mode-code-indent-offset   2 ; web-mode, js code in html file
    css-indent-offset             2 ; css-mode
    sh-basic-offset               2 ; Shell script mode default indentation increment.
    sh-indentation                2 ; Shell script mode width for further indentation.
    smie-indent-basic             2 ; Basic amount of indentation.
  )

  ;; LSP mode hooks.
  (add-hook 'prog-major-mode #'lsp-prog-major-mode-enable)

  ;; PHP mode hook.
  (add-hook 'php-mode-hook 'my-php-mode-hook)

  ;; Custom keybindings.
  (spacemacs/set-leader-keys "d" 'spacemacs/kill-buffer-and-window)

  (setq-default fill-column 80)
)

(defun dotspacemacs/user-config ()
  "Configuration function for user code."

  ;; (setq feature-default-language "fi")
  (require 'feature-mode)
  (add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
  (add-to-list 'auto-mode-alist '("\.mjs$" . javascript-mode))


  ;; Map ";" to ex-mode (":").
  (define-key evil-normal-state-map ";" 'evil-ex)
  (define-key evil-visual-state-map ";" 'evil-ex)

  ;; Use '\' to repeat a find command (since ';' is mapped to ':').
  (define-key evil-normal-state-map (kbd "\\") 'evil-repeat-find-char)

  ;; Always enable company-mode completion.
  (global-company-mode)

  ;; https://github.com/PhilippBaschke/.spacemacs.d/blob/master/init.el

  (setq flycheck-eslintrc "~/.eslintrc")

  ;; @todo What is this?
  ;; (add-to-list 'completion-at-point-functions 'semantic-completion-at-point-function)

  ;; <CTRL-w> should delete a word backwards in all modes.
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "C-w") 'evil-delete-backward-word))
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "C-w") 'evil-delete-backward-word))

  ;; Turn on editorconfig.
  (editorconfig-mode 1)

  ;; Always enable indent-guide.
  (spacemacs/toggle-indent-guide-globally-on)

  ;; Turn off alarms.
  (setq ring-bell-function 'ignore)

  ;; Load WakaTime.
  (global-wakatime-mode)

  (setq dotspacemacs-mode-line-theme '(all-the-icons :separator 'slant))

  ;; Activate column indicator in prog-mode and text-mode.
  (add-hook 'prog-mode-hook 'turn-on-fci-mode)
  (add-hook 'text-mode-hook 'turn-on-fci-mode)

  ;; Use feature-mode for Cucumber files.
  ;; (require 'feature-mode)
  ;; (add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
  ;; (setq feature-default-language "fi")
  ;; (setq feature-default-i18n-file "/Users/UQ/vm/apps/uq-drupal-standard/drupal.v1.60.0/sites/all/modules/custom/uq-standard-behat/vendor/behat/gherkin/tests/Behat/Gherkin/Fixtures/i18n.yml")
)

(defun dotspacemacs/config ())
