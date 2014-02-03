live-cricket.el --- Retrieve the cricket score from the web
===========================================================

Asynchronously retrieve the cricket score from the web. Returns a
deferred object, which can be used in a chain for further
processing, or you can block until there's a result with
(deferred:sync!)

Example
-------

```elisp
(deferred:sync!
  (live-cricket-fetch-match-score
   "http://www.espncricinfo.com/new-zealand-v-india-2014/engine/current/match/667639.html"))
```

returns an alist like:

```elisp
  ((team . "Ind") (runs . "313") (wickets . "7") (overs . "93") (in-over . "0") (bats1 . "AT Rayudu") (bats1-runs . "49") (bats1-no . "*") (bats2 . "B Kumar") (bats2-runs . "3") (bats2-no . "*") (bowler . "SET Friday") (bowler-wickets . "0") (bowler-runs . "86"))
```

Titles used for testing:

```elisp
"Eng 25/3 (5.0 ov, JE Root 1*, GJ Maxwell 1/6) | Live Scorecard | ESPN Cricinfo"
"Eng 75/4 (11.0 ov, JC Buttler 6*, EJG Morgan 31*, GJ Maxwell 2/31) | Live Scorecard | ESPN Cricinfo"
"Eng 100/8 (15.1 ov, CJ Jordan 0*, SCJ Broad 2*, NM Coulter-Nile 2/17) | Live Scorecard | ESPN Cricinfo"
"Eng 104/8 (16.0 ov, SCJ Broad 2*, CJ Jordan 4*, NM Coulter-Nile 2/21) | Live Scorecard | ESPN Cricinfo"
"Eng 110/9 (16.6 ov, JW Dernbach 1*, CJ Jordan 9*, JM Muirhead 2/13) | Live Scorecard | ESPN Cricinfo"
"Eng 111 (17.2 ov, CJ Jordan 10*, MA Starc 1/8) - Match over | Live Scorecard | ESPN Cricinfo"
"Ind 41/0 (14.0 ov, M Vijay 19*, S Dhawan 16*, SET Friday 0/17) - Stumps | Live Scorecard | ESPN Cricinfo"
"AusWn 102/3 (18.3 ov, AJ Blackwell 10*, EJ Villani 36*, CM Edwards 0/10) - Match over | Live Scorecard | ESPN Cricinfo"
```
