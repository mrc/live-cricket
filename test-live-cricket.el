(require 'ert)
(require 'live-cricket)
(require 'cl-lib)

(ert-deftest test-parse-title-form-1 ()
  "Match in progress, both batsmen in."
  (let* ((title "Eng 110/9 (16.6 ov, JW Dernbach 1*, CJ Jordan 9*, JM Muirhead 2/13) | Live Scorecard | ESPN Cricinfo")
         (result (live-cricket-parse-title title)))
    (should (cl-subsetp '((team . "Eng") (runs . "110") (wickets . "9")
                          (overs . "16") (in-over . "6")
                          (bats1 . "JW Dernbach") (bats1-runs . "1") (bats1-no . "*")
                          (bats2 . "CJ Jordan") (bats2-runs . "9") (bats2-no . "*")
                          (bowler . "JM Muirhead") (bowler-wickets . "2") (bowler-runs . "13"))
                        result :test #'equal))))

(ert-deftest test-parse-title-form-2 ()
  "Match in progress, one batsman in."
  (let* ((title "Eng 25/3 (5.0 ov, JE Root 1*, GJ Maxwell 1/6) | Live Scorecard | ESPN Cricinfo")
         (result (live-cricket-parse-title title)))
    (should (cl-subsetp '((team . "Eng") (runs . "25") (wickets . "3")
                          (overs . "5") (in-over . "0")
                          (bats1 . "JE Root") (bats1-runs . "1") (bats1-no . "*")
                          (bats2) (bats2-runs) (bats2-no)
                          (bowler . "GJ Maxwell") (bowler-wickets . "1") (bowler-runs . "6"))
                        result :test #'equal))))

(ert-deftest test-parse-title-form-3 ()
  "Match over."
  (let* ((title "Eng 111 (17.2 ov, CJ Jordan 10*, MA Starc 1/8) - Match over | Live Scorecard | ESPN Cricinfo")
         (result (live-cricket-parse-title title)))
    (should (cl-subsetp '((team . "Eng") (runs . "111") (wickets)
                          (overs . "17") (in-over . "2")
                          (bats1 . "CJ Jordan") (bats1-runs . "10") (bats1-no . "*")
                          (bowler . "MA Starc") (bowler-wickets . "1") (bowler-runs . "8"))
                        result :test #'equal))))

(ert-deftest test-normalize-score-1 ()
  "Elements of the match score are converted from strings to more
natural types."
  (let* ((title "Eng 110/9 (16.6 ov, JW Dernbach 1*, CJ Jordan 9*, JM Muirhead 2/13) | Live Scorecard | ESPN Cricinfo")
         (score (live-cricket-parse-title title))
         (result (live-cricket-normalize-match-score score)))
    (should (cl-subsetp '((team . "Eng")
                          (runs . 110) (wickets . 9)
                          (overs . 16) (in-over . 6)
                          (bats1-runs . 1)
                          (bats2-runs . 9)
                          (bowler-wickets . 2) (bowler-runs . 13))
                        result :test #'equal))))
