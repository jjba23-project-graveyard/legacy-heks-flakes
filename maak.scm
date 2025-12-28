;;; heks-flakes

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; heks-flakes is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; heks-flakes is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with heks-flakes.  If not, see <https://www.gnu.org/licenses/>.

(define-module (maak)
  #:declarative? #t
  #:use-module (maak maak))

(define (update-flake path)
  ($ (list (~ "cd src/~a && nix flake update" path))))

(define (update-flakes)
  (update-flake "scala")
  (update-flake "haskell")
  (update-flake "python-uv")
  (update-flake "rust"))
