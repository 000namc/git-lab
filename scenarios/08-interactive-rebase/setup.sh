source /scenarios/_lib.sh
fresh
w README.md '# messy'                      "init: readme"
git switch -q -c feature
w api.py   'def get(): pass'               "feat(api): get endpoint"
c api.py   'def post(): pass'              "wip"
c api.py   '# fix typo in get'             "fxi typo"
w model.py 'class User: pass'              "feat(model): User"
c model.py '    name = ""'                 "fixup! feat(model): User"
printf 'def a():\n    pass\n\n\n\n\n\n\ndef b():\n    pass\n' > big.py; git add big.py; cm "feat: big.py skeleton"
sed -i 's/^def a():$/def a():  # part A/; s/^def b():$/def b():  # part B/' big.py; git add big.py; cm "feat: big change that should be two commits"
c api.py   '# docstring'                   "docs(api): docstring"
unfix
git config core.editor vim
echo; git log --oneline
echo; echo "편집기: vim (core.editor). todo 편집이 막막하면 GIT_SEQUENCE_EDITOR 로 자동화 가능 — README 참고"
