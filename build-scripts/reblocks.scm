(define-module (reblocks)
  #:use-module (ice-9 match)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module ((guix build utils) #:select (with-directory-excursion))
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system asdf)
  #:use-module (gnu packages)
  #:use-module (gnu packages aspell)
  #:use-module (gnu packages base)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages lisp-check)
  #:use-module (gnu packages lisp-xyz)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages webkit))

(define %source-dir (dirname (dirname (current-filename))))

#|

  :depends-on ("40ants-doc"
               "reblocks/app"
               "reblocks/server"
               "reblocks/debug"
               "reblocks/default-init"
               "reblocks/commands-hook"
               "reblocks/widgets/string-widget"
               "reblocks/widgets/funcall-widget"
               "reblocks/welcome/widget"
               "reblocks/utils/clos"
               "reblocks/utils/i18n"
               "reblocks/preview"
               ;; We need this because this module defines important method
               ;; make-js-backend
               "reblocks/js/jquery"
               ;; to load js dependencies after app was started
               "reblocks/app-dependencies"
               ;; This package defines an :around method for reblocks/widgets:render
               ;; which adds a wrapper around widget body
               "reblocks/widgets/render-methods"
               ;; we need to depend on this package, because
               ;; lack:builder will try to find `LACK.MIDDLEWARE.SESSION`
               ;; package
               "lack-middleware-session")
|#

#|
               "40ants-doc/core"
               "40ants-doc/restart"
               "40ants-doc/glossary"
               "40ants-doc/changelog"
               "40ants-doc/ignored-words"
|#
;; (define-public sbcl-40ants-doc
;;   (let ((commit "827926bc88d85886b9323314e314b2b0e047fc25")
;;         (revision "0"))
;;     (package
;;      (name "sbcl-40ants-doc")
;;      (version (git-version "0.12.0" revision commit))
;;      (source
;;       (origin
;;        (method git-fetch)
;;        (uri (git-reference
;;              (url "https://github.com/40ants/doc")
;;              (commit commit)))
;;        (file-name (git-file-name "cl-40ants-doc" version))
;;        (sha256
;;         (base32 "1p2lr89f6b7w49210lvxgqa3kgias6r2wrd2w1g77h18rcl2pmlz"))))
;;      (build-system asdf-build-system/sbcl)
;;      (arguments
;;       '(#:tests? #f))
;;      (native-inputs
;;       (list))
;;      (inputs
;;       (list ))
;;      (home-page "https://github.com/40ants/doc")
;;      (synopsis "Flexible documentation generator for Common Lisp projects. ")
;;      (description
;;       "Allows to put documentation inside lisp files and cross-reference between different entities. Based on MGL-PAX.")
;;      (license (license "MGL-PAX"
;;                        "https://github.com/40ants/doc/blob/master/COPYING"
;;                        "MGL-PAX")))))
(define-public sbcl-metatilities
  (let ((commit "a854dcde1df5ec779fc6eff449de0f601376a86a")
        (revision "0"))
    (package
      (name "sbcl-metatilities")
      (version (git-version "0.6.18" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/gwkkwg/metatilities")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1d9j8wvzqrg424w6l25r6xb6yjl4syb2z7ccr98b24wwm5ckhbsc"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; The tests fails
       '(#:tests? #f))
      (native-inputs
       ;; What is a system-connection?
       ;; https://github.com/hraban/metatilities/blob/master/metatilities.asd#L74
       (list sbcl-lift
             cl-metatilities-base
             cl-moptilities
             cl-containers
             cl-metabang-bind))
      (synopsis "These are the rest of metabang.com's Common Lisp utilities")
      (description
       "These are the rest of metabang.com's Common Lisp utilities and what not.")
      (home-page "https://common-lisp.net/project/metatilities/")
      (license license:expat))))

(define-public cl-metatilities
  (sbcl-package->cl-source-package sbcl-metatilities))

(define-public sbcl-f-underscore
  (let ((commit "7988171194cd259e12469dd7c30000be6ef1b31a")
        (revision "0"))
    (package
      (name "sbcl-f-underscore")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://gitlab.common-lisp.net/bpm/f-underscore")
               (commit commit)))
         (file-name (git-file-name "cl-f-underscore" version))
         (sha256
          (base32 "0mqvb2rxa08y07lj6smp8gf1ig32802fxq7mw5a283f2nkrinnb5"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:tests? #f))
      (native-inputs
       (list))
      (inputs
       (list))
      (home-page "https://gitlab.common-lisp.net/bpm/f-underscore")
      (synopsis "a tiny library of functional programming utils")
      (description
       "a tiny library of functional programming utils placed into the
public domain.  The idea is to make functional programs shorter and easier to
read without resorting to syntax [like arc's square bracket unary function
syntax]")
      (license license:public-domain))))

(define-public cl-f-underscore
  (sbcl-package->cl-source-package sbcl-f-underscore))

(define-public sbcl-40ants-asdf-system
  (let ((commit "c206276e1452d8edf22fc118a784bb9b45a982bb")
        (revision "0"))
    (package
      (name "sbcl-40ants-asdf-system")
      (version (git-version "0.3.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/40ants/40ants-asdf-system")
               (commit commit)))
         (sha256
          (base32 "0iykhcqgylvi4i709vfr25hz3rpcksdij861bkbjw58pn022bl5v"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Drop tests to avoid package more packages
       '(#:tests? #f))
      (native-inputs
       (list))
      (inputs
       (list))
      (home-page "https://github.com/40ants/40ants-asdf-system")
      (synopsis "Provides a class for being used instead of asdf:package-inferred-system.")
      (description "Provides a class for being used instead of asdf:package-inferred-system.")
      (license license:bsd-4))))

(define-public cl-40ants-asdf-system
  (sbcl-package->cl-source-package sbcl-40ants-asdf-system))

(define-public sbcl-with-output-to-stream
  (let ((commit "57ab58f91addc23b952af4d3c10671d5fe3578c8")
        (revision "0"))
    (package
      (name "sbcl-with-output-to-stream")
      (version (git-version "1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Hexstream/with-output-to-stream")
               (commit commit)))
         (sha256
          (base32 "17h9np736sdsj5acibi8czq054pvw5mwg1va0sbd5qrayafhvr86"))))
      (build-system asdf-build-system/sbcl)
      (native-inputs
       (list))
      (inputs
       (list
        cl-parachute))
      (home-page "https://www.hexstreamsoft.com/libraries/with-output-to-stream/")
      (synopsis "Provides a simple way of directing output to a stream according to the concise and intuitive semantics of FORMAT's stream argument.")
      (description
       "with-output-to-stream provides a simple way of directing output to a stream
according to the concise and intuitive semantics of FORMAT's stream argument.")
      (license license:unlicense))))

(define-public cl-with-output-to-stream
  (sbcl-package->cl-source-package sbcl-with-output-to-stream))

(define-public sbcl-log4cl-extras
  (let ((commit "920e5e551b116419aa82de46e4a8a0f787db7d82")
        (revision "0"))
    (package
      (name "sbcl-log4cl-extras")
      (version (git-version "0.9.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/40ants/log4cl-extras")
               (commit commit)))
         (sha256
          (base32 "0nhzsh9sm19kd6nwn8k4j8rkfpjnkfx3i30zqr2kvjs0h27ljpjy"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       ;; Drop tests to avoid package more packages
       '(#:tests? #f))
      (native-inputs
       (list))
      (inputs
       (list
        cl-40ants-asdf-system
        cl-pythonic-string-reader
        cl-log4cl
        cl-jonathan
        cl-40ants-doc
        cl-strings
        cl-global-vars
        cl-dissect
        cl-with-output-to-stream))
      (home-page "https://40ants.com/log4cl-extras")
      (synopsis "A bunch of addons to LOG4CL: JSON appender, context fields, cross-finger appender, etc.")
      (description
       "This library extends LOG4CL system in a few ways:

* It helps with configuration of multiple appenders and layouts.
* Has a facility to catch context fields and to log them.
* Has a macro to log unhandled errors.
* Adds a layout to write messages as JSON, which is useful for production as makes easier to parse and process such logs.
* Uses the appenders which are not disabled in case of some error which again, should be useful for production.")
      (license license:bsd-4))))

(define-public cl-log4cl-extras
  (sbcl-package->cl-source-package sbcl-log4cl-extras))

(define-public sbcl-reblocks
  (let ((commit "ee8b3958c4a50341796fda26ba38b8feb47fa578")
        (revision "0"))
    (package
      (name "sbcl-reblocks")
      (version (git-version "0.35.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/40ants/reblocks")
               (commit commit)))
         (file-name (git-file-name "cl-reblocks" version))
         (sha256
          (base32 "1p2lr89f6b7w49210lvxgqa3kgias6r2wrd2w1g77h18rcl2pmlz"))))
      (build-system asdf-build-system/sbcl)
      (arguments
       '(#:tests? #f))
      (native-inputs
       (list))
      (inputs
       (list cl-f-underscore
             cl-metatilities
             cl-metatilities-base
             cl-moptilities
             cl-containers
             cl-metabang-bind
             cl-parenscript
             cl-spinneret
             cl-routes
             cl-log4cl
             cl-metacopy
             cl-40ants-doc
             cl-str
             cl-log4cl-extras
             cl-40ants-asdf-system
             sbcl-lack))
      (home-page "https://40ants.com/reblocks/")
      (synopsis "A Common Lisp web framework, successor of the Weblocks.")
      (description
       "Reblocks is the fork of the Weblocks web frameworks written by Slava Akhmechet and maintained by Scott L. Burson and Olexiy Zamkoviy.")
      (license license:llgpl))))

(define-public cl-reblocks
  (sbcl-package->cl-source-package sbcl-reblocks))

cl-reblocks
