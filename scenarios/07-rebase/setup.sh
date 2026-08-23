source /scenarios/_lib.sh
fresh
w README.md '# demo'              "init: README"
w app.py    'def main(): pass'    "feat: app skeleton"
git switch -q -c feature
c app.py    '# feature step 1'    "feat(feature): step 1"
c app.py    '# feature step 2'    "feat(feature): step 2"
# feature 에서 갈라진 topic (--onto 연습용)
git switch -q -c topic
w topic.py  'topic work'          "feat(topic): work"
c topic.py  'topic work 2'        "feat(topic): work 2"
git switch -q feature
c util.py   'def helper(): pass'  "feat(feature): helper"
git switch -q main
w README.md '# demo\n\n## usage'  "docs: usage section"
c config.py 'DEBUG = False'       "chore: config"
# 충돌 연습용: main 과 feature 가 같은 줄을 다르게
git switch -q -c conflicting main
w app.py    'def main(): return 1' "feat(conflicting): main returns 1"
git switch -q feature
unfix
echo; git log --oneline --graph --all
