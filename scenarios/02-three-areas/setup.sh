source /scenarios/_lib.sh
fresh
w app.py    'VERSION = "0.1"'                 "feat: version constant"
w README.md '# three-areas'                    "docs: readme"
c app.py    'def run(): print("run")'         "feat: run()"
c app.py    'def stop(): print("stop")'       "feat: stop()"
# 세 공간을 다르게 만든다
printf 'VERSION = "0.2"\ndef run(): print("run")\ndef stop(): print("stop")\n' > app.py
git add app.py                                  # 인덱스: 0.2
printf 'VERSION = "0.3"\ndef run(): print("run!")\ndef stop(): print("stop")\n' > app.py   # 작업트리: 0.3 + run!
echo 'TODO' > notes.txt                         # untracked
unfix
echo; git status --short; echo; git log --oneline
