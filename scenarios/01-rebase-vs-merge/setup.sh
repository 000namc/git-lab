source /scenarios/_lib.sh
fresh
c README.md "# demo"            "init: README"
c app.py    "def main(): pass"  "feat: app skeleton"
git switch -q -c feature
c app.py    "# feature step 1"  "feat(feature): step 1"
c app.py    "# feature step 2"  "feat(feature): step 2"
c util.py   "def helper(): pass" "feat(feature): helper"
git switch -q main
c README.md "## usage"          "docs: usage section"
c config.py "DEBUG = False"     "chore: config"
git switch -q feature
echo; git lg
