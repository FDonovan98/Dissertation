Github actions file works as described below. Works only with unity projects, does not work with IL2CPP backend

Creates pull request
Runs unit tests included in project
Builds project
Uploads build as Github Actions artifact
Enables automerge on pull request so pull request closes once all Actions have passed

Parsecsv.py works with output from Microsoft Forms used during data collection. Forms are not included for GDPR reasons. Test forms (testdata_N.csv, testdata_P.csv, testparticipants.csv) are included however for demonstration purposes, and were used with Parsecsv.py to generate parsed_test_results.csv.

stat_analysis.r performs statistical analysis on the .csv file output by Parsecsv.py