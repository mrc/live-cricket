;;; live-cricket.el --- Retrieve the cricket score from the web

;; Copyright (C) 2014 Matt Curtis

;; Author: Matt Curtis <matt.r.curtis@gmail.com>
;; Version: 0.1
;; Package-Requires ((deferred 0.3.2))
;; Keywords: sport
;; URL: https://github.com/mrc/live-cricket

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Asynchronously retrieve the cricket score from the web. Returns a
;; deferred object, which can be used in a chain for further
;; processing, or you can block until there's a result with
;; (deferred:sync!)
;;
;;; Sample:
;;
;; (deferred:sync!
;;   (live-cricket-fetch-match-score
;;    "http://www.espncricinfo.com/new-zealand-v-india-2014/engine/current/match/667639.html"))
;;
;; returns an alist like:
;;
;; ((team . "Ind") (runs . "313") (wickets . "7") (overs . "93") (in-over . "0") (bats1 . "AT Rayudu") (bats1-runs . "49") (bats1-no . "*") (bats2 . "B Kumar") (bats2-runs . "3") (bats2-no . "*") (bowler . "SET Friday") (bowler-wickets . "0") (bowler-runs . "86"))
;;
;; Titles used for testing:
;;
;; "Eng 25/3 (5.0 ov, JE Root 1*, GJ Maxwell 1/6) | Live Scorecard | ESPN Cricinfo"
;; "Eng 75/4 (11.0 ov, JC Buttler 6*, EJG Morgan 31*, GJ Maxwell 2/31) | Live Scorecard | ESPN Cricinfo"
;; "Eng 100/8 (15.1 ov, CJ Jordan 0*, SCJ Broad 2*, NM Coulter-Nile 2/17) | Live Scorecard | ESPN Cricinfo"
;; "Eng 104/8 (16.0 ov, SCJ Broad 2*, CJ Jordan 4*, NM Coulter-Nile 2/21) | Live Scorecard | ESPN Cricinfo"
;; "Eng 110/9 (16.6 ov, JW Dernbach 1*, CJ Jordan 9*, JM Muirhead 2/13) | Live Scorecard | ESPN Cricinfo"
;; "Eng 111 (17.2 ov, CJ Jordan 10*, MA Starc 1/8) - Match over | Live Scorecard | ESPN Cricinfo"
;; "Ind 41/0 (14.0 ov, M Vijay 19*, S Dhawan 16*, SET Friday 0/17) - Stumps | Live Scorecard | ESPN Cricinfo"
;; "AusWn 102/3 (18.3 ov, AJ Blackwell 10*, EJ Villani 36*, CM Edwards 0/10) - Match over | Live Scorecard | ESPN Cricinfo"

;;; Code:

(require 'cl-lib)
(require 'deferred)
(require 'request-deferred)

(defun live-cricket-extract-title ()
  "Extract the HTML title from the buffer."
  (goto-char (point-min))
  (let* ((start-string "<title>")
         (end-string "</title>")
         (start (search-forward start-string))
         (end (- (search-forward end-string) (length end-string))))
    (buffer-substring start end)))

(defconst live-cricket-title-regex
  "\\(.+\\) \\([[:digit:]]+\\)/?\\([[:digit:]]+\\)? (\\([[:digit:]]+\\)\\.\\([[:digit:]]+\\) ov\\(?:, \\([^,]+\\) \\([[:digit:]]+\\)\\(\\*\\)\\)\\(?:, \\([^,]+\\) \\([[:digit:]]+\\)\\(\\*\\)\\)?, \\([^)]+\\) \\([[:digit:]]+\\)/\\([[:digit:]]+\\))"
  "Regular expression to locate ane extract attributes of the
cricket match. The match groups line up with
`live-cricket-title-fields'.")

(defconst live-cricket-title-fields
  '(team runs wickets overs in-over
         bats1 bats1-runs bats1-no
         bats2 bats2-runs bats2-no
         bowler bowler-wickets bowler-runs)
  "Fields for the match groups in `live-cricket-title-regex'.")

(defun live-cricket-parse-title (title)
  "Parse the score from the title. This is in a format which
starts like: ``AusWn 102/3 (18.3 ov, AJ Blackwell 10*, EJ Villani
36*, CM Edwards 0/10)''.

The result is an alist of attributes of the cricket match, with
the keys from `live-cricket-title-fields'."
  (message "parsing [%S]" title)
  (cl-labels ((m (n) (match-string-no-properties n title))
              (c (s n) (cons s (m n)))
              (fields (syms) (cl-mapcar #'c syms (number-sequence 1 100))))
    (cond
     ((string-match live-cricket-title-regex title)
      (fields live-cricket-title-fields)))))

(defun live-cricket-fetch-match-score (url)
  "Returns a deferred object which contains the result of the
cricket scores, fetched from URL."
  (deferred:$
    (request-deferred url
                      :parser #'live-cricket-extract-title)
    (deferred:nextc it #'request-response-data)
    (deferred:nextc it #'live-cricket-parse-title)))

(provide 'live-cricket)

;;; live-cricket.el ends here
